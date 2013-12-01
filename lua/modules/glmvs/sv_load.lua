module( "GLMVS", package.seeall )

--[[---------------------------------------------------------
Name: ManageResources
Desc: Adds/Manages all of the required resources that GLMVS requires.
-----------------------------------------------------------]]
function ManageResources()
	-- Add the network strings.
	util.AddNetworkString( "GLMVS_AdminGroupMult" )
	util.AddNetworkString( "GLMVS_ReceiveVotes" )
	util.AddNetworkString( "GLMVS_ReceiveMapInfo" )
	util.AddNetworkString( "GLMVS_GroupMultInfo" )
	util.AddNetworkString( "GLMVS_UpdateVotes" )

	-- Resource workshop the GLMVS Content
	resource.AddWorkshop( "160293553" )

	-- Add the images
	for _, info in ipairs( MapList ) do
		if file.Exists( "maps/" ..info.Map.. ".png", "MOD" ) then
			resource.AddFile( "maps/" ..info.Map.. ".png" )
		end
	end

	-- Get the JSON files
	MapsPlayed	= GFile.GetJSONFile( ReturnSettingVariable( "MapFileDB" ) )
	MapCount	= GFile.GetJSONFile( "mapcounts.txt" )
	GroupMult	= GFile.GetJSONFile( "groupmult.txt" )
end

--[[---------------------------------------------------------
Name: ManageMaps
Desc: Adds/Manages the locked maps and such.
-----------------------------------------------------------]]
function ManageMaps()
	-- Count the table length of maplist.
	CountMapList = table.Count( MapList )

	-- Handle locked, removed or anything to the maps.
	for mapid, info in ipairs( MapList ) do
		if not PLSendInfo[ mapid ] then PLSendInfo[ mapid ] = {} end

		if info.MinPlayers and ( info.MinPlayers > 1 ) then
			TrueCountMapList = TrueCountMapList + 1
		end

		if IsNonExistentMap( info.Map ) then
			info.Removed = 1
			PLSendInfo[ mapid ].Removed = 1
			CountMapList = CountMapList - 1
			GDebug.NotifyByConsole( 3, info.Map, " does not exist on the server. Client can't vote for this map." )
		elseif not IsNonExistentMap( info.Map ) and ( MapsPlayed[ info.Map ] or info.Map == CurrentMap ) then
			info.Locked = 1
			PLSendInfo[ mapid ].Locked = 1
			CountMapsPlayed = CountMapsPlayed + 1
		end
	end

	-- Reset the maplock threshold before sending it. Check if the minimum of maps are there.
	if CountMapsPlayed >= math.floor( CountMapList * math.max( 0, math.min( 1, MapLockThreshold ) ) ) then
		MapsPlayed = {}
		CountMapsPlayed = 1

		for id, sendinf in ipairs( PLSendInfo ) do
			local istrue = ( MapList[ id ].Map ~= CurrentMap ) and 0 or 1

			MapList[ id ].Locked = istrue
			sendinf.Locked = istrue
		end

		GFile.SetJSONFile( ReturnSettingVariable( "MapFileDB" ), MapsPlayed )
		GDebug.NotifyByConsole( 0, "Minimum locked maps requirement has been reached! Restarting the list." )
	end

	-- Sorty sort sort! 
	table.sort( MapList, SortMaps )
end


-- Keep track of the most players in-game.
hook.Add( "PlayerInitialSpawn", "GLMVS_TrackSendInfo", function( pl )
	-- Keep track of the most players in-game.
	local curplayers = #player.GetAll()
	if ( curplayers > MaxPlayerCount ) then
		MaxPlayerCount = curplayers
	end

	-- Send the player the required info.
	for mapid, info in ipairs( MapList ) do
		if ( info.Votes > 0 ) then
			if not PLSendInfo[ mapid ] then PLSendInfo[ mapid ] = {} end
			PLSendInfo[ mapid ].Votes = info.Votes
		end
	end

	-- Send it now!
	net.Start( "GLMVS_ReceiveMapInfo" )
		net.WriteTable( PLSendInfo )
	net.Send( pl )

	-- Send in the group multipliers.
	net.Start( "GLMVS_GroupMultInfo" )
		net.WriteTable( GroupMult )
	net.Send( pl )

	-- Notify the admin, owner or whoever it is that the addon is outdated.
	if CanNotifyUser( pl ) and NotifyForUpdates then
		if UpToDate then return end

		util.ChatToPlayer( pl, "(GLMVS) - There is a new update in GitHub. Please report this to your owner." )
	end

	-- Notify me/devs for contributions and such.
	if GDebug.Contributors[ pl:UniqueID() ] then
		util.ChatToPlayer( pl, pl:Name().. ", this server is using GLMVS v" ..GLVersion.. ", you've received x" ..GDebug.Contributors[ pl:UniqueID() ].MID.. " the votepower!" )
	end
end )


--[[---------------------------------------------------------
Name: SyncGroupMult
Desc: Forces everyone to sync by the group multiplier.
-----------------------------------------------------------]]
net.Receive( "GLMVS_GroupMultInfo", function( len, pl )
	if not IsUserGroupAdmin( pl ) then return end

	GroupMult = net.ReadTable( GLMVS.GroupMult )
	GFile.SetJSONFile( "groupmult.txt", GroupMult )
	SyncGroupMult()
end )

function SyncGroupMult()
	net.Start( "GLMVS_GroupMultInfo" )
		net.WriteTable( GroupMult )
	net.Broadcast()
end