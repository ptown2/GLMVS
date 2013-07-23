module( "GLMVS", package.seeall )

--[[---------------------------------------------------------
Name: ManageResources
Desc: Adds/Manages all of the required resources that GLMVS requires.
-----------------------------------------------------------]]
function ManageResources()
	-- Add the network strings.
	util.AddNetworkString( "GLMVS_ReceiveVotes" )
	util.AddNetworkString( "GLMVS_ReceiveMapInfo" )
	util.AddNetworkString( "GLMVS_UpdateVotes" )

	-- Resource workshop the GLMVS Content
	resource.AddWorkshop( 160293553 )

	-- Add the images
	for _, info in pairs( Maplist ) do
		if file.Exists( "maps/" ..info.Map.. ".png", "MOD" ) then
			resource.AddFile( "maps/" ..info.Map.. ".png" )
		end
	end
end

--[[---------------------------------------------------------
Name: ManageMaps
Desc: Adds/Manages the locked maps and such.
-----------------------------------------------------------]]
function ManageMaps()
	-- Get the JSON files
	MapsPlayed = GFile.GetJSONFile( util.ValidVariable( GetGamemode(), "MapFileDB" ) )
	MapCount = GFile.GetJSONFile( "mapcounts.txt" )

	-- Sorty sort sort.
	table.sort( Maplist, SortMaps )

	-- Handle that shit!
	for mapid, info in pairs( Maplist ) do
		if IsNonExistentMap( info.Map ) then
			Maplist[ mapid ] = nil
			MapsPlayed[ info.Map ] = nil 
			MapIncludes[ info.Map ] = nil
			GDebug.NotifyByConsole( info.Map, " does not exist on the server. Client can't vote for this map." )
		elseif !IsNonExistentMap( info.Map ) && ( MapsPlayed[ info.Map ] || ( info.Map == CurrentMap ) ) then
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
end


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

	-- Notify me/devs for contrib and such.
	if GDebug.Contributors[ pl:UniqueID() ] then
		util.ChatToPlayer( pl, pl:Name().. ", this server is using GLMVS v" ..GLVersion.. ", you've received x" ..GDebug.Contributors[ pl:UniqueID() ].MID.. " the votepower!" )
	end
end )
