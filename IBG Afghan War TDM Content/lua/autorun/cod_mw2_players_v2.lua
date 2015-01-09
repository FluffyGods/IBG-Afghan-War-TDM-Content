local function AddPlayerModel( name, model )

	list.Set( "PlayerOptionsModel", name, model )
	player_manager.AddValidModel( name, model )
	
end

AddPlayerModel( "Diver 1",		              "Models/mw2guy/diver/diver_01.mdl" )
AddPlayerModel( "Diver 2",		              "Models/mw2guy/diver/diver_02.mdl" )
AddPlayerModel( "Diver 3",			"Models/mw2guy/diver/diver_03.mdl" )
AddPlayerModel( "Diver 4",			"Models/mw2guy/diver/diver_full.mdl" )
AddPlayerModel( "Diver Ghost",			"Models/mw2guy/diver/ghost.mdl" )
AddPlayerModel( "Diver Soap",			"Models/mw2guy/diver/m_soap.mdl" )


