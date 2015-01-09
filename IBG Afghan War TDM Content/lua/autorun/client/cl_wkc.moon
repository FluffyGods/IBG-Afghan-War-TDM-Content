export WKC_FBO

length_follow_camera = -> tonumber(GetGlobalString("wyozikc_followcam_length")) or 1.5
length_zoom_in = -> tonumber(GetGlobalString("wyozikc_zoomin_length")) or 0.5
length_freeze = -> tonumber(GetGlobalString("wyozikc_freeze_length")) or 4

show_killer_hud = -> GetGlobalString("wyozikc_showkillerhud") == "1"
show_killer_nick = -> GetGlobalString("wyozikc_showkillernick") == "1"
show_killer_role = -> GetGlobalString("wyozikc_showkillerrole") == "1"

wyozikc_fulltf2mode = -> GetGlobalString("wyozikc_fulltf2mode") == "1"

ttt_stoponend = -> GetGlobalString("wyozikc_ttt_stoponend") == "1"

killcam_enabled = CreateConVar("wyozikc_enabled", "1", FCVAR_ARCHIVE)

time_follow_camera = -> length_follow_camera!
time_zoom_in = -> time_follow_camera! + length_zoom_in!
time_freeze = -> time_zoom_in! + length_freeze!

local death_eye_pos, death_pos, death_attacker, death_attacker_pos, death_attacker_wep, death_attacker_role, killcam_started
killcam_drawn = false

stop_killcam = ->
	killcam_started = nil

cur_state = ->
	if not killcam_started
		return
	if not killcam_enabled\GetBool()
		return

	elapsed = CurTime() - killcam_started

	if killcam_started < CurTime() - time_freeze!
		return
	if not IsValid(death_attacker) or not death_attacker\IsPlayer() or death_attacker\Alive()
		if killcam_started < CurTime() - time_zoom_in!
			return "freeze", (time_freeze! - elapsed) / length_freeze!
		if killcam_started < CurTime() - time_follow_camera!
			return "zoom_in", (time_zoom_in! - elapsed) / length_zoom_in!
	return "follow_cam", (time_follow_camera! - elapsed) / length_follow_camera!

calc_cur_view = ->
	state, fraction = cur_state!
	if not state
		return

	follow_cam_pos = if wyozikc_fulltf2mode!
		my_pos = LocalPlayer!\GetPos!
		pos_diff = (if IsValid(death_attacker)
			(death_attacker\EyePos() - my_pos)
		else
			(death_pos - my_pos))\GetNormalized()

        wall_offset = 4
        tr = util.TraceHull
            start: my_pos + LocalPlayer!\GetUp()*50,
            endpos: my_pos - pos_diff * 150,
            filter: LocalPlayer!,
            mins: Vector( -wall_offset, -wall_offset, -wall_offset ),
            maxs: Vector( wall_offset, wall_offset, wall_offset ),

		tr.HitPos
	else
		death_eye_pos

	freeze_cam_pos = if IsValid(death_attacker)
		if death_attacker\Alive() then
			-- Distance from localply to attackerpos
			dist = follow_cam_pos\Distance(death_attacker\EyePos())
			-- Angle between localply and attackerpos
			init_angle = (death_attacker\EyePos() - death_eye_pos)\Angle()
			-- Compute vector
			attacker_eye_pos = death_attacker\EyePos()

			target_origin = attacker_eye_pos - init_angle\Forward() * math.min(180, dist) + Vector(0, 0, 20)
        	wall_offset = 4

	        tr = util.TraceHull
	            start: attacker_eye_pos,
	            endpos: target_origin,
	            filter: death_attacker,
	            mins: Vector( -wall_offset, -wall_offset, -wall_offset ),
	            maxs: Vector( wall_offset, wall_offset, wall_offset ),
	        

			npos = if tr.Hit and not tr.StartSolid
				tr.HitPos + tr.HitNormal * WallOffset
			else
				target_origin
			npos
		else
			death_attacker_pos
	else
		follow_cam_pos

	cam_angles = (pos)->
		if IsValid(death_attacker)
			(death_attacker\EyePos() - pos)\Angle()
		else
			(death_pos - pos)\Angle()

	switch state
		when "freeze"
			return freeze_cam_pos, cam_angles(freeze_cam_pos)
		when "zoom_in"
			pos = LerpVector(1 - fraction, follow_cam_pos, freeze_cam_pos)
			return pos, cam_angles(pos)
		when "follow_cam"
			return follow_cam_pos, cam_angles(follow_cam_pos)


net.Receive("wkc_killcam", ->
	attacker = net.ReadEntity()

	if not IsValid(attacker) or not attacker\IsPlayer()
		return

	death_attacker = attacker
	death_attacker_pos = attacker\GetPos()
	death_attacker_wep = net.ReadEntity()
	death_attacker_role = net.ReadUInt(8)

	death_eye_pos = LocalPlayer()\EyePos()
	death_pos = LocalPlayer()\GetPos()

	killcam_started = CurTime()
	killcam_drawn = false)

hook.Add("CalcView", "WKC_CalcView", (ply, origin, ang, fov) ->

	state, fraction = cur_state!
	if not state
		return

	pos, angles = calc_cur_view!

    view = 
    	origin: pos
    	angles: angles
    	fov: fov
 
    return view)

hook.Add("RenderScene", "WKC_DrawFBO", ->

	state = cur_state!

	if killcam_drawn or not killcam_started or state ~= "freeze"
		return

	if not WKC_FBO
		WKC_FBO = GetRenderTarget("WKC_FBO", ScrW(), ScrH())

	pos, ang = calc_cur_view!

	OldRT = render.GetRenderTarget()
	render.SetRenderTarget( WKC_FBO )
	
	do
		render.Clear( 0, 0, 0, 255, true )

		CamData =
			angles: ang,
			origin: pos,
			x: 0,
			y: 0,
			w: ScrW(),
			h: ScrH(),
			fov: 90,
			drawviewmodel: false,
			drawhud: false
	 
		cam.Start2D()
		render.RenderView(CamData)
		cam.End2D()
	 
	render.SetRenderTarget( OldRT )

	killcam_drawn = true)

hook.Add("TTTEndRound", "WKC_EndRound", ->
	if not ttt_stoponend!
		return
	stop_killcam!)

local old_state

TRANSLATE = if LANG and LANG.GetTranslation
	LANG.GetTranslation
else
	(txt) -> txt

for i=1,4 do
	surface.CreateFont("WKC_PlyNick#{i}", {font: "Trebuchet24",
	                                size: 12 + i*15,
	                                weight: 500})

get_proper_font = (nick) ->
	nick_length = string.len(nick)
	if nick_length > 25
		return "WKC_PlyNick1"	
	if nick_length > 20
		return "WKC_PlyNick2"
	if nick_length > 15
		return "WKC_PlyNick3"
	return "WKC_PlyNick4"

surface.CreateFont("WKC_WepSubText", {font: "Trebuchet24",
                                size: 20,
                                weight: 500})

mat = Material( "models/v_models/ResidualGrub/mosin/lense" )

hook.Add "HUDPaint", "WKC_DrawHud", ->

	state = cur_state!

	if not state
		if IsValid(throwaway_avatar_img)
			throwaway_avatar_img\Remove()

		if old_state
			old_state = nil
			hook.Call("WKCEnded", GAMEMODE)
		return

	if not old_state
		hook.Call("WKCStarted", GAMEMODE)

	if state == "zoom_in" and old_state ~= "zoom_in"
		LocalPlayer()\EmitSound("misc/freeze_cam.wav")

	old_state = state

	with LocalPlayer()
		if \KeyDown(IN_JUMP) -- Remove killcam
			stop_killcam!
			return

	if state ~= "freeze"
		return

	if LocalPlayer()\KeyDown(IN_ATTACK) -- Stop killcam if state is freeze and mouse1 is down
		stop_killcam!
		return

	mat\SetTexture("$basetexture", WKC_FBO)

	scr_w, scr_h = ScrW(), ScrH()

	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(mat)
	surface.DrawTexturedRect(0, 0, scr_w, scr_h)

	if not show_killer_hud!
		return

	start_x, start_y = scr_w - 550, scr_h/2 + 100
	mid_x, mid_y = start_x + 250, start_y + 150

	draw.RoundedBox(4, start_x, start_y, 500, 100, Color(0, 0, 0, 230))

	attacker_nick = if IsValid(death_attacker) and death_attacker\IsPlayer()
		death_attacker\Nick()
	else
		"World"

	attacker_color = if show_killer_role!
		switch death_attacker_role
			when ROLE_TRAITOR
				Color(255, 0, 0)
			when ROLE_INNOCENT
				Color(0, 255, 0)
			when ROLE_DETECTIVE
				Color(0, 0, 255)
			else
				Color(255, 255, 255)
	else
		Color(255, 255, 255)

	if show_killer_nick!
		if not IsValid(throwaway_avatar_img) and IsValid(death_attacker) and death_attacker\IsPlayer()
			export throwaway_avatar_img
			throwaway_avatar_img = vgui.Create("AvatarImage")
			throwaway_avatar_img\SetPlayer(death_attacker, 64)

		attacker_nick_x = mid_x + 240

		if IsValid(throwaway_avatar_img)
			with throwaway_avatar_img
				\SetPos(mid_x + 180, start_y + 30)
				\SetSize(64, 64)
			attacker_nick_x = mid_x + 170

		draw.SimpleText("You were killed by", "Trebuchet24", mid_x + 240, start_y + 5, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
		draw.SimpleTextOutlined(attacker_nick, get_proper_font(attacker_nick), attacker_nick_x, start_y + 23, attacker_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 2, Color(0, 0, 0))


	attacker_wep = if IsValid(death_attacker_wep)
		(death_attacker_wep.PrintName or death_attacker_wep\GetClass())
	else
		"unknown"

	attacker_wep = TRANSLATE(attacker_wep)

	-- Icons should show up only in TTT
	if ROLE_TRAITOR
		attacker_wep_icon = (if IsValid(death_attacker_wep)
				death_attacker_wep.Icon) or "VGUI/ttt/icon_id"

		surface.SetMaterial(Material(attacker_wep_icon))
		surface.SetDrawColor(255, 255, 255)
		surface.DrawTexturedRect(mid_x - 240, start_y + 9, 64, 64)

	draw.SimpleText(attacker_wep, "WKC_WepSubText", start_x + 10, start_y + 70, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
	
hook.Add "HUDShouldDraw", "WyoziKCRemoveDmgIndicator", (name)->
	if name == "CHudDamageIndicator" and cur_state!
		return --false


hook.Add "TTTSettingsTabs", "WyoziKCTTTSettings", (dtabs)->
	dsettings = dtabs.Items[2].Panel

	do
		dgui = vgui.Create("DForm", dsettings)
		dgui\SetName("Killcam")

		dgui\CheckBox("Enable killcam", "wyozikc_enabled")

		dsettings\AddItem(dgui)
