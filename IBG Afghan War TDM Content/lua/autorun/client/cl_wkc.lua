local length_follow_camera
length_follow_camera = function()
  return tonumber(GetGlobalString("wyozikc_followcam_length")) or 1.5
end
local length_zoom_in
length_zoom_in = function()
  return tonumber(GetGlobalString("wyozikc_zoomin_length")) or 0.5
end
local length_freeze
length_freeze = function()
  return tonumber(GetGlobalString("wyozikc_freeze_length")) or 4
end
local show_killer_hud
show_killer_hud = function()
  return GetGlobalString("wyozikc_showkillerhud") == "1"
end
local show_killer_nick
show_killer_nick = function()
  return GetGlobalString("wyozikc_showkillernick") == "1"
end
local show_killer_role
show_killer_role = function()
  return GetGlobalString("wyozikc_showkillerrole") == "1"
end
local wyozikc_fulltf2mode
wyozikc_fulltf2mode = function()
  return GetGlobalString("wyozikc_fulltf2mode") == "1"
end
local ttt_stoponend
ttt_stoponend = function()
  return GetGlobalString("wyozikc_ttt_stoponend") == "1"
end
local killcam_enabled = CreateConVar("wyozikc_enabled", "1", FCVAR_ARCHIVE)
local time_follow_camera
time_follow_camera = function()
  return length_follow_camera()
end
local time_zoom_in
time_zoom_in = function()
  return time_follow_camera() + length_zoom_in()
end
local time_freeze
time_freeze = function()
  return time_zoom_in() + length_freeze()
end
local death_eye_pos, death_pos, death_attacker, death_attacker_pos, death_attacker_wep, death_attacker_role, killcam_started
local killcam_drawn = false
local stop_killcam
stop_killcam = function()
  killcam_started = nil
end
local cur_state
cur_state = function()
  if not killcam_started then
    return 
  end
  if not killcam_enabled:GetBool() then
    return 
  end
  local elapsed = CurTime() - killcam_started
  if killcam_started < CurTime() - time_freeze() then
    return 
  end
  if not IsValid(death_attacker) or not death_attacker:IsPlayer() or death_attacker:Alive() then
    if killcam_started < CurTime() - time_zoom_in() then
      return "freeze", (time_freeze() - elapsed) / length_freeze()
    end
    if killcam_started < CurTime() - time_follow_camera() then
      return "zoom_in", (time_zoom_in() - elapsed) / length_zoom_in()
    end
  end
  return "follow_cam", (time_follow_camera() - elapsed) / length_follow_camera()
end
local calc_cur_view
calc_cur_view = function()
  local state, fraction = cur_state()
  if not state then
    return 
  end
  local follow_cam_pos
  if wyozikc_fulltf2mode() then
    local my_pos = LocalPlayer():GetPos()
    local pos_diff = ((function()
      if IsValid(death_attacker) then
        return (death_attacker:EyePos() - my_pos)
      else
        return (death_pos - my_pos)
      end
    end)()):GetNormalized()
    local wall_offset = 4
    local tr = util.TraceHull({
      start = my_pos + LocalPlayer():GetUp() * 50,
      endpos = my_pos - pos_diff * 150,
      filter = LocalPlayer(),
      mins = Vector(-wall_offset, -wall_offset, -wall_offset),
      maxs = Vector(wall_offset, wall_offset, wall_offset)
    })
    follow_cam_pos = tr.HitPos
  else
    follow_cam_pos = death_eye_pos
  end
  local freeze_cam_pos
  if IsValid(death_attacker) then
    if death_attacker:Alive() then
      local dist = follow_cam_pos:Distance(death_attacker:EyePos())
      local init_angle = (death_attacker:EyePos() - death_eye_pos):Angle()
      local attacker_eye_pos = death_attacker:EyePos()
      local target_origin = attacker_eye_pos - init_angle:Forward() * math.min(180, dist) + Vector(0, 0, 20)
      local wall_offset = 4
      local tr = util.TraceHull({
        start = attacker_eye_pos,
        endpos = target_origin,
        filter = death_attacker,
        mins = Vector(-wall_offset, -wall_offset, -wall_offset),
        maxs = Vector(wall_offset, wall_offset, wall_offset)
      })
      local npos
      if tr.Hit and not tr.StartSolid then
        npos = tr.HitPos + tr.HitNormal * WallOffset
      else
        npos = target_origin
      end
      freeze_cam_pos = npos
    else
      freeze_cam_pos = death_attacker_pos
    end
  else
    freeze_cam_pos = follow_cam_pos
  end
  local cam_angles
  cam_angles = function(pos)
    if IsValid(death_attacker) then
      return (death_attacker:EyePos() - pos):Angle()
    else
      return (death_pos - pos):Angle()
    end
  end
  local _exp_0 = state
  if "freeze" == _exp_0 then
    return freeze_cam_pos, cam_angles(freeze_cam_pos)
  elseif "zoom_in" == _exp_0 then
    local pos = LerpVector(1 - fraction, follow_cam_pos, freeze_cam_pos)
    return pos, cam_angles(pos)
  elseif "follow_cam" == _exp_0 then
    return follow_cam_pos, cam_angles(follow_cam_pos)
  end
end
net.Receive("wkc_killcam", function()
  local attacker = net.ReadEntity()
  if not IsValid(attacker) or not attacker:IsPlayer() then
    return 
  end
  death_attacker = attacker
  death_attacker_pos = attacker:GetPos()
  death_attacker_wep = net.ReadEntity()
  death_attacker_role = net.ReadUInt(8)
  death_eye_pos = LocalPlayer():EyePos()
  death_pos = LocalPlayer():GetPos()
  killcam_started = CurTime()
  killcam_drawn = false
end)
hook.Add("CalcView", "WKC_CalcView", function(ply, origin, ang, fov)
  local state, fraction = cur_state()
  if not state then
    return 
  end
  local pos, angles = calc_cur_view()
  local view = {
    origin = pos,
    angles = angles,
    fov = fov
  }
  return view
end)
hook.Add("RenderScene", "WKC_DrawFBO", function()
  local state = cur_state()
  if killcam_drawn or not killcam_started or state ~= "freeze" then
    return 
  end
  if not WKC_FBO then
    WKC_FBO = GetRenderTarget("WKC_FBO", ScrW(), ScrH())
  end
  local pos, ang = calc_cur_view()
  local OldRT = render.GetRenderTarget()
  render.SetRenderTarget(WKC_FBO)
  do
    render.Clear(0, 0, 0, 255, true)
    local CamData = {
      angles = ang,
      origin = pos,
      x = 0,
      y = 0,
      w = ScrW(),
      h = ScrH(),
      fov = 90,
      drawviewmodel = false,
      drawhud = false
    }
    cam.Start2D()
    render.RenderView(CamData)
    cam.End2D()
  end
  render.SetRenderTarget(OldRT)
  killcam_drawn = true
end)
hook.Add("TTTEndRound", "WKC_EndRound", function()
  if not ttt_stoponend() then
    return 
  end
  return stop_killcam()
end)
local old_state
local TRANSLATE
if LANG and LANG.GetTranslation then
  TRANSLATE = LANG.GetTranslation
else
  TRANSLATE = function(txt)
    return txt
  end
end
for i = 1, 4 do
  surface.CreateFont("WKC_PlyNick" .. tostring(i), {
    font = "Trebuchet24",
    size = 12 + i * 15,
    weight = 500
  })
end
local get_proper_font
get_proper_font = function(nick)
  local nick_length = string.len(nick)
  if nick_length > 25 then
    return "WKC_PlyNick1"
  end
  if nick_length > 20 then
    return "WKC_PlyNick2"
  end
  if nick_length > 15 then
    return "WKC_PlyNick3"
  end
  return "WKC_PlyNick4"
end
surface.CreateFont("WKC_WepSubText", {
  font = "Trebuchet24",
  size = 20,
  weight = 500
})
local mat = Material("models/v_models/ResidualGrub/mosin/lense")
hook.Add("HUDPaint", "WKC_DrawHud", function()
  local state = cur_state()
  if not state then
    if IsValid(throwaway_avatar_img) then
      throwaway_avatar_img:Remove()
    end
    if old_state then
      old_state = nil
      hook.Call("WKCEnded", GAMEMODE)
    end
    return 
  end
  if not old_state then
    hook.Call("WKCStarted", GAMEMODE)
  end
  if state == "zoom_in" and old_state ~= "zoom_in" then
    LocalPlayer():EmitSound("misc/freeze_cam.wav")
  end
  old_state = state
  do
    local _with_0 = LocalPlayer()
    if _with_0:KeyDown(IN_JUMP) then
      stop_killcam()
      return 
    end
  end
  if state ~= "freeze" then
    return 
  end
  if LocalPlayer():KeyDown(IN_ATTACK) then
    stop_killcam()
    return 
  end
  mat:SetTexture("$basetexture", WKC_FBO)
  local scr_w, scr_h = ScrW(), ScrH()
  surface.SetDrawColor(255, 255, 255)
  surface.SetMaterial(mat)
  surface.DrawTexturedRect(0, 0, scr_w, scr_h)
  if not show_killer_hud() then
    return 
  end
  local start_x, start_y = scr_w - 550, scr_h / 2 + 100
  local mid_x, mid_y = start_x + 250, start_y + 150
  draw.RoundedBox(4, start_x, start_y, 500, 100, Color(0, 0, 0, 230))
  local attacker_nick
  if IsValid(death_attacker) and death_attacker:IsPlayer() then
    attacker_nick = death_attacker:Nick()
  else
    attacker_nick = "World"
  end
  local attacker_color
  if show_killer_role() then
    local _exp_0 = death_attacker_role
    if ROLE_TRAITOR == _exp_0 then
      attacker_color = Color(255, 0, 0)
    elseif ROLE_INNOCENT == _exp_0 then
      attacker_color = Color(0, 255, 0)
    elseif ROLE_DETECTIVE == _exp_0 then
      attacker_color = Color(0, 0, 255)
    else
      attacker_color = Color(255, 255, 255)
    end
  else
    attacker_color = Color(255, 255, 255)
  end
  if show_killer_nick() then
    if not IsValid(throwaway_avatar_img) and IsValid(death_attacker) and death_attacker:IsPlayer() then
      throwaway_avatar_img = vgui.Create("AvatarImage")
      throwaway_avatar_img:SetPlayer(death_attacker, 64)
    end
    local attacker_nick_x = mid_x + 240
    if IsValid(throwaway_avatar_img) then
      do
        local _with_0 = throwaway_avatar_img
        _with_0:SetPos(mid_x + 180, start_y + 30)
        _with_0:SetSize(64, 64)
      end
      attacker_nick_x = mid_x + 170
    end
    draw.SimpleText("You were killed by", "Trebuchet24", mid_x + 240, start_y + 5, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
    draw.SimpleTextOutlined(attacker_nick, get_proper_font(attacker_nick), attacker_nick_x, start_y + 23, attacker_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 2, Color(0, 0, 0))
  end
  local attacker_wep
  if IsValid(death_attacker_wep) then
    attacker_wep = (death_attacker_wep.PrintName or death_attacker_wep:GetClass())
  else
    attacker_wep = "unknown"
  end
  attacker_wep = TRANSLATE(attacker_wep)
  if ROLE_TRAITOR then
    local attacker_wep_icon = ((function()
      if IsValid(death_attacker_wep) then
        return death_attacker_wep.Icon
      end
    end)()) or "VGUI/ttt/icon_id"
    surface.SetMaterial(Material(attacker_wep_icon))
    surface.SetDrawColor(255, 255, 255)
    surface.DrawTexturedRect(mid_x - 240, start_y + 9, 64, 64)
  end
  return draw.SimpleText(attacker_wep, "WKC_WepSubText", start_x + 10, start_y + 70, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
end)
hook.Add("HUDShouldDraw", "WyoziKCRemoveDmgIndicator", function(name)
  if name == "CHudDamageIndicator" and cur_state() then
    return 
  end
end)
return hook.Add("TTTSettingsTabs", "WyoziKCTTTSettings", function(dtabs)
  local dsettings = dtabs.Items[2].Panel
  do
    local dgui = vgui.Create("DForm", dsettings)
    dgui:SetName("Killcam")
    dgui:CheckBox("Enable killcam", "wyozikc_enabled")
    return dsettings:AddItem(dgui)
  end
end)
