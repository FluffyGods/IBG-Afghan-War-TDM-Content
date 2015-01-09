
local function AddPlayerModel( name, model )

    list.Set( "PlayerOptionsModel", name, model )
    player_manager.AddValidModel( name, model )
	
	player_manager.AddValidHands( "BF4_US_01", "models/weapons/c_arms_cstrike.mdl", 0, "00000000" )
	player_manager.AddValidHands( "BF4_US_02", "models/weapons/c_arms_cstrike.mdl", 0, "00000000" )
	player_manager.AddValidHands( "BF4_US_03", "models/weapons/c_arms_cstrike.mdl", 0, "00000000" )
	player_manager.AddValidHands( "BF4_US_04", "models/weapons/c_arms_cstrike.mdl", 0, "00000000" )
	player_manager.AddValidHands( "BF4_RU_01", "models/weapons/c_arms_cstrike.mdl", 0, "00000000" )
	player_manager.AddValidHands( "BF4_RU_02", "models/weapons/c_arms_cstrike.mdl", 0, "00000000" )
	player_manager.AddValidHands( "BF4_RU_03", "models/weapons/c_arms_cstrike.mdl", 0, "00000000" )
	player_manager.AddValidHands( "BF4_RU_04", "models/weapons/c_arms_cstrike.mdl", 0, "00000000" )
    
end

AddPlayerModel( "BF4_US_01", "models/steinman/bf4/us_01.mdl" )
AddPlayerModel( "BF4_US_02", "models/steinman/bf4/us_02.mdl" )
AddPlayerModel( "BF4_US_03", "models/steinman/bf4/us_03.mdl" )
AddPlayerModel( "BF4_US_04", "models/steinman/bf4/us_04.mdl" )
AddPlayerModel( "BF4_RU_01", "models/steinman/bf4/ru_01.mdl" )
AddPlayerModel( "BF4_RU_02", "models/steinman/bf4/ru_02.mdl" )
AddPlayerModel( "BF4_RU_03", "models/steinman/bf4/ru_03.mdl" )
AddPlayerModel( "BF4_RU_04", "models/steinman/bf4/ru_04.mdl" )