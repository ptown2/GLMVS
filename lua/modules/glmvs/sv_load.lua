-- Add the network strings.
util.AddNetworkString( "GLMVS_ReceiveVotes" )
util.AddNetworkString( "GLMVS_UpdateVotes" )

-- Resource add those files.
resource.AddFile( "resource/fonts/bebasneue.ttf" )

resource.AddFile( "materials/icon128/padlock.png" )

resource.AddFile( "materials/gui/circlegradient.vmt" )
resource.AddFile( "materials/gui/circlegradient.vtf" )

hook.Add( "InitPostEntity", "AddResourceMapIMG", function()
	-- Add the images to resource files
	for _, info in pairs( GLMVS.Maplist ) do
		if file.Exists( "maps/" ..info.Map.. ".png", "MOD" ) then
			resource.AddFile( "maps/" ..info.Map.. ".png" )
		end
	end
end )

-- Keep track of the most players in-game.
hook.Add( "PlayerInitialSpawn", "OnPlayerSpawn", function()
	local curplayers = #player.GetAll()

	if curplayers > GLMVS.MaxPlayerCount then
		GLMVS.MaxPlayerCount = curplayers
	end
end )