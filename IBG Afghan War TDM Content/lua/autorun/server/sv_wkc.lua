local create_fake_replicated_cvar
create_fake_replicated_cvar = function(name, default, flags)
  CreateConVar(name, default, flags)
  SetGlobalString(name, cvars.String(name) or default)
  return cvars.AddChangeCallback(name, function(cvar_name, old_value, new_value)
    return SetGlobalString(name, tostring(new_value))
  end)
end
create_fake_replicated_cvar("wyozikc_followcam_length", "1.5", FCVAR_ARCHIVE)
create_fake_replicated_cvar("wyozikc_zoomin_length", "0.5", FCVAR_ARCHIVE)
create_fake_replicated_cvar("wyozikc_freeze_length", "4", FCVAR_ARCHIVE)
create_fake_replicated_cvar("wyozikc_showkillerhud", "1", FCVAR_ARCHIVE)
create_fake_replicated_cvar("wyozikc_showkillernick", "1", FCVAR_ARCHIVE)
create_fake_replicated_cvar("wyozikc_showkillerrole", "1", FCVAR_ARCHIVE)
create_fake_replicated_cvar("wyozikc_fulltf2mode", "1", FCVAR_ARCHIVE)
create_fake_replicated_cvar("wyozikc_ttt_stoponend", "1", FCVAR_ARCHIVE)
util.AddNetworkString("wkc_killcam")
hook.Add("DoPlayerDeath", "WKC_SendKillCamData", function(ply, attacker, dmginfo)
  net.Start("wkc_killcam")
  net.WriteEntity(attacker)
  net.WriteEntity((function()
    if util and util.WeaponFromDamage then
      return util.WeaponFromDamage(dmginfo)
    else
      return attacker:GetActiveWeapon()
    end
  end)())
  net.WriteUInt(((function()
    if attacker.GetRole then
      return attacker:GetRole()
    else
      return 127
    end
  end)()), 8)
  return net.Send(ply)
end)
return concommand.Add("wkc_debug_killself", function(ply)
  return ply:TakeDamage(9999, player.GetByID(2), player.GetByID(2):GetActiveWeapon())
end)
