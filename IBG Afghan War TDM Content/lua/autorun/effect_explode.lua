function Splodev2()
	--local universalexplosion = ents.FindByClass("*explosion")
	--local universalboom = ents.FindByClass("*boom*")
	local explode = ents.FindByClass("env_explosion")
	local explode2 = ents.FindByClass("Explosion")
	local explodear2 = ents.FindByClass("env_ar2explosion")
	local physboom = ents.FindByClass("env_physexplosion")
	local m9kcmboom = ents.FindByClass("m9k_gdcw_cinematicboom")
	local m9kcmboom2 = ents.FindByClass("m9k_cinematicboom")
	local m9kcmboom3 = ents.FindByClass("m9k_cin*")
	local m9ktpaboom = ents.FindByClass("m9k_gdcw_tpaboom")
	local helimegabomb = ents.FindByClass("HelicopterMegaBomb")
	local fasgrenade = ents.FindByClass("grenade_final")
	local fasm79 = ents.FindByClass("explosion_m79")
	local m9kfrag = ents.FindByClass("m9k_frag_splode")
	local m9kgdcw = ents.FindByClass("m9k_gdcw_*")
	local m9kfx = ents.FindByClass("m9k_effect_ex*")
	local targets = {};
	targets[1] = explode
	targets[2] = explodear2
	targets[3] = physboom
	targets[4] = m9kcmboom
	targets[5] = m9ktpaboom
	targets[6] = helimegabomb
	targets[7] = fasgrenade
	targets[8] = fasm79
	targets[9] = explode2
	targets[10] = m9kfrag
	targets[11] = m9kcmboom2
	targets[12] = m9kcmboom3
	targets[13] = m9kgdcw
	targets[14] = m9kfx
	for k,v in pairs( targets ) do
		if v then
			for l,b in pairs( v ) do
				if( b:IsValid() ) then
					local Pos = b:LocalToWorld( b:OBBCenter( ) )
					ParticleEffect("dusty_explosion_rockets", Pos, Angle(0,0,0), nil)
					b:Remove()
				end
			end
		end
	end
end
game.AddParticles( "particles/vman_explosion.pcf" )
hook.Add("Think", "Splodev2", Splodev2)