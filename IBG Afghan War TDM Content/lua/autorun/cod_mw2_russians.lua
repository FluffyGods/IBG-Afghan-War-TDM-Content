local function AddPlayerModel( name, model )

	list.Set( "PlayerOptionsModel", name, model )
	player_manager.AddValidModel( name, model )
	
end

AddPlayerModel( "Gasmask Russian",		              "Models/mw2guy/RUS/gassoldier.mdl" )
AddPlayerModel( "Russian A",		              "Models/mw2guy/RUS/soldier_a.mdl" )
AddPlayerModel( "Russian C",			"Models/mw2guy/RUS/soldier_c.mdl" )
AddPlayerModel( "Russian D",			"Models/mw2guy/RUS/soldier_d.mdl" )
AddPlayerModel( "Russian E",			"Models/mw2guy/RUS/soldier_e.mdl" )
AddPlayerModel( "Russian F",			"Models/mw2guy/RUS/soldier_f.mdl" )
