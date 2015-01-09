--[[
 Call of Duty 4 Sniper Playermodel
	Revision:				1.1
	Begin Date: 			17 April 2011
	Update:					30 March 2013
	Models Created By:		Jesse V-92
 ]]

local function AddPlayerModel( name, model )

    list.Set( "PlayerOptionsModel", name, model )
    player_manager.AddValidModel( name, model )
    
end

AddPlayerModel( "CoD4_Sniper", "models/jessev92/player/military/cod4_sniper.mdl" )
