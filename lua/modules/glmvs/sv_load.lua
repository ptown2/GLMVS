module( "GLMVS", package.seeall )

-- Add the network strings.
util.AddNetworkString( "GLMVS_ReceiveVotes" )
util.AddNetworkString( "GLMVS_ReceiveMapInfo" )
util.AddNetworkString( "GLMVS_UpdateVotes" )

-- Resource add those files.
resource.AddFile( "resource/fonts/bebasneue.ttf" )

resource.AddFile( "materials/icon128/padlock.png" )

resource.AddFile( "materials/gui/circlegradient.vmt" )
resource.AddFile( "materials/gui/circlegradient.vtf" )

resource.AddFile( "maps/noicon.png" )

-- Add the images to resource files
hook.Add( "Initialize", "GLMVS_AddResourceMapIMG", function()
	for _, info in pairs( Maplist ) do
		if file.Exists( "maps/" ..info.Map.. ".png", "MOD" ) then
			resource.AddFile( "maps/" ..info.Map.. ".png" )
		end
	end
end )

-- Handle the non-existantmaps and then recent maps onto few tables.
hook.Add( "Initialize", "GLMVS_HandleTableMaps", function()
	-- Sorty sort sort.
	table.sort( Maplist, SortMaps )

	-- Handle that shit!
	for mapid, info in pairs( Maplist ) do
		if IsNonExistantMap( info.Map ) then
			Maplist[ mapid ] = nil
			MapsPlayed[ info.Map ] = nil 
			MapIncludes[ info.Map ] = nil
			GDebug.NotifyByConsole( info.Map, " does not exist on the server. Client can't vote for this map." )
		end

		if MapsPlayed[ info.Map ] || ( info.Map == CurrentMap ) then
			if !PLSendInfo[ mapid ] then
				PLSendInfo[ mapid ] = {}
			end

			info.Locked = 1
			PLSendInfo[ mapid ].Locked = 1
		end
	end

	-- Reset the maplock threshold before sending it. Check if the minimum of maps are there.
	if table.Count( MapsPlayed ) >= math.floor( table.Count( Maplist ) * MapLockThreshold ) then
		MapsPlayed = {}
		PLSendInfo = {}
		GFile.SetJSONFile( util.ValidVariable( GetGamemode(), "MapFileDB" ), MapsPlayed )
		GDebug.NotifyByConsole( "Minimum locked maps requirement has been reached. Restarting the list." )
	end
end )

-- Keep track of the most players in-game.
hook.Add( "PlayerInitialSpawn", "GLMVS_TrackSendInfo", function( pl )
	-- Keep track of the most players in-game.
	local curplayers = #player.GetAll()
	if ( curplayers > MaxPlayerCount ) then
		MaxPlayerCount = curplayers
	end

	-- Send the player the required info.
	for mapid, info in pairs( Maplist ) do
		if ( info.Votes > 0 ) then
			if !PLSendInfo[ mapid ] then
				PLSendInfo[ mapid ] = {}
			end

			PLSendInfo[ mapid ].Votes = info.Votes
		end
	end

	net.Start( "GLMVS_ReceiveMapInfo" )
		net.WriteTable( PLSendInfo )
	net.Send( pl )

	-- Notify the admin, owner or whoever it is that the addon is outdated.
	if ( NotifyUsergroup[ pl:GetNWString("usergroup") ] || NotifyUsergroup[ pl:GetNWString("EV_UserGroup") ] ) && NotifyForUpdates then
		if UpToDate then return end

		util.ChatToPlayer( pl, "(GLMVS) - There is a new update in GitHub. Please report this to your owner." )
	end

	-- Notify me/devs for contrib and such
	if GDebug.Contributors[ pl:UniqueID() ] then
		util.ChatToPlayer( pl, pl:Name().. ", this server is using GLMVS v" ..GLVersion.. ", you've received x" ..GDebug.Contributors[ pl:UniqueID() ].MID.. " the votepower!" )
	end
end )
