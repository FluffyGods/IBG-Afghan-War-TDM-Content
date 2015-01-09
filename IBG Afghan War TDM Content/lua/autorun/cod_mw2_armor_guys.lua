local function AddPlayerModel( name, model )

	list.Set( "PlayerOptionsModel", name, model )
	player_manager.AddValidModel( name, model )
	
end

AddPlayerModel( "Juggernaut",		              "Models/mw2guy/riot/juggernaut.mdl" )
AddPlayerModel( "Riot Soldier-RU",			"Models/mw2guy/riot/riot_ru.mdl" )
AddPlayerModel( "Riot Soldier-US",			"Models/mw2guy/riot/riot_us.mdl" )
