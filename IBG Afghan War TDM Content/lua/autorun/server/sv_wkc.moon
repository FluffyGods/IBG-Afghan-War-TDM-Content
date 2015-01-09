-- Replicated cvars apparently dont work so lets do it this way
create_fake_replicated_cvar = (name, default, flags) ->
	CreateConVar(name, default, flags)
	SetGlobalString(name, cvars.String(name) or default)
	cvars.AddChangeCallback(name, (cvar_name, old_value, new_value) ->
		SetGlobalString(name, tostring(new_value)))

create_fake_replicated_cvar("wyozikc_followcam_length", "1.5", FCVAR_ARCHIVE)
create_fake_replicated_cvar("wyozikc_zoomin_length", "0.5", FCVAR_ARCHIVE)
create_fake_replicated_cvar("wyozikc_freeze_length", "4", FCVAR_ARCHIVE)

create_fake_replicated_cvar("wyozikc_showkillerhud", "1", FCVAR_ARCHIVE)
create_fake_replicated_cvar("wyozikc_showkillernick", "1", FCVAR_ARCHIVE)
create_fake_replicated_cvar("wyozikc_showkillerrole", "1", FCVAR_ARCHIVE)

create_fake_replicated_cvar("wyozikc_fulltf2mode", "1", FCVAR_ARCHIVE)

-- Stop killcam early if round ends
create_fake_replicated_cvar("wyozikc_ttt_stoponend", "1", FCVAR_ARCHIVE)

util.AddNetworkString("wkc_killcam")
hook.Add("DoPlayerDeath", "WKC_SendKillCamData", (ply, attacker, dmginfo) ->

	net.Start("wkc_killcam")
	net.WriteEntity(attacker)
	net.WriteEntity(if util and util.WeaponFromDamage then util.WeaponFromDamage(dmginfo) else attacker\GetActiveWeapon())
	net.WriteUInt((if attacker.GetRole then attacker\GetRole() else 127), 8)
	net.Send(ply))

concommand.Add("wkc_debug_killself", (ply) ->
	ply\TakeDamage(9999, player.GetByID(2), player.GetByID(2)\GetActiveWeapon()))