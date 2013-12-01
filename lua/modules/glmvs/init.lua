module( "GLMVS", package.seeall )

-- Server Global Vars
MapCount			= {}
MapsPlayed			= {}
MaxPlayerCount		= 0
CountMapsPlayed		= 0
CountMapList		= 0
TrueCountMapList	= 0
UpToDate			= true
EndHookCalled		= false

-- Player Send Vars
PLSendInfo			= {}

--[[---------------------------------------------------------
Name: GetNextMap
Desc: Gets the map with the most votes.
Returns: mapwinner (string), votes (int)
-----------------------------------------------------------]]
function GetNextMap()
	local mapwinner = nil
	local votes = 0

	for _, info in ipairs( MapList ) do
		if ( info.Votes > votes ) then
			votes = info.Votes
			mapwinner = info.Map
		end
	end

	return mapwinner, votes
end

--[[---------------------------------------------------------
Name: PickUnlockedRandom
Desc: Picks randomly a map that is unlocked.
Returns: unlockedmap (string)
-----------------------------------------------------------]]
function PickUnlockedRandom()
	local unlocked = {}

	for _, info in ipairs( MapList ) do
		if not tobool( info.Locked ) and not tobool( info.Removed ) then
			table.insert( unlocked, info.Map )
		end
	end

	return table.Random( unlocked )
end

--[[---------------------------------------------------------
Name: IsNonExistentMap( map (string) )
Desc: Finds if the map exists or not.
Returns: inversedFileExists (bool)
-----------------------------------------------------------]]
function IsNonExistentMap( map )
	return not file.Exists( "maps/" ..map.. ".bsp", "MOD" )
end

--[[---------------------------------------------------------
Name: AddToRecentMaps( map (string) )
Desc: Adds the map to the recently played maps data.
-----------------------------------------------------------]]
function AddToRecentMaps( map )
	if ( not MapIncludes[ map ] or MapsPlayed[ map ] ) then return end

	MapsPlayed[ map ] = true
	GFile.SetJSONFile( ReturnSettingVariable( "MapFileDB" ), MapsPlayed )
end

--[[---------------------------------------------------------
Name: CountFromMap( map (string) )
Desc: Sets the count ONCE the times this map has been played.
-----------------------------------------------------------]]
function CountFromMap( map )
	if ( not MapCount[ map ] ) then
		MapCount[ map ] = 0
	end

	MapCount[ map ] = MapCount[ map ] + 1
	GFile.SetJSONFile( "mapcounts.txt", MapCount )
end

--[[---------------------------------------------------------
Name: AddVote( pl (player entity), mapid(int), votes(int) )
Desc: Adds the vote to the selected map.
-----------------------------------------------------------]]
function AddVote( pl, mapid, votes, ovrd )
	if ( MVotePower > 0 ) and ( votes > MVotePower ) and not GDebug.Contributors[ pl:UniqueID() ] then
		votes = MVotePower
	end

	local MapName = MapList[ mapid ].Name or MapList[ mapid ].Map

	MapList[ mapid ].Votes = MapList[ mapid ].Votes + votes

	net.Start( "GLMVS_ReceiveVotes" )
		net.WriteUInt( mapid, 32 )
		net.WriteUInt( pl:EntIndex(), 16 )
		net.WriteInt( votes, 32 )
		net.WriteInt( ovrd or 0, 32 )
	net.Broadcast()

	pl.VotedAlready = mapid
	pl.VotePower = votes

	if ovrd then
		pl.VotePower = ovrd
	end
end

--[[---------------------------------------------------------
Name: AddRTV( pl (player entity) )
Desc: Adds a RTV Vote by the player.
-----------------------------------------------------------]]
function AddRTV( pl )
	local rtvtimelimit = RTVWaitTime * 60
	local canrtv, reason = CallSettingFunction( "CanPlayerRTV", pl )

	if ( canrtv == nil ) and not ( canrtv == false ) then
		canrtv, reason = true, ""
	end

	if not RTVMode then
		util.ChatToPlayer( pl, "You can't RTV since the server has it disabled." )
		return
	elseif EndHookCalled then
		util.ChatToPlayer( pl, "You can't RTV since the game ended." )
		return
	elseif pl.RockedAlready then
		util.ChatToPlayer( pl, "You can't RTV since you already did it." )
		return
	elseif ( #player.GetAll() < RTVPlayerREQ ) then
		util.ChatToPlayer( pl, "You can't RTV since it requires " ..RTVPlayerREQ.. " or more player(s)." )
		return
	elseif ( CurTime() < rtvtimelimit ) then
		util.ChatToPlayer( pl, "You have to wait " ..( rtvtimelimit / 60 ).. " minutes before doing a RTV." )
		return
	elseif not canrtv then
		util.ChatToPlayer( pl, reason )
		return
	end

	pl.RockedAlready = true

	local rtvcount, totalplys = CheckForRTV()
	util.ChatToPlayers( pl:Name().. " has decided to RTV. Requires " ..( totalplys - rtvcount ).. " more RTV votes. Type /rtv to vote!" )
end

--[[---------------------------------------------------------
Name: CheckForRTV
Desc: Checks if a RTV is going to be made.
-----------------------------------------------------------]]
function CheckForRTV()
	local rtvcount, totalplys = 0, math.ceil( #player.GetAll() * math.max( 0, math.min( 1, RTVThreshold ) ) )

	for _, pl in pairs( player.GetAll() ) do
		if pl.RockedAlready then
			rtvcount = rtvcount + 1
		end
	end

	MsgN( rtvcount, totalplys )
	if ( rtvcount >= totalplys ) and not EndHookCalled then
		-- Make it slightly late for the message.
		timer.Simple( 0.25, function()
			local timeleft = CallSettingFunction( "GetEndTime" ) or 30

			CallSettingFunction( "OnRTVSuccess" )
			util.ChatToPlayers( "Limit reached to RTV. Changing the map in ".. timeleft .." seconds." )
			GLMVS_ForcedStartVote()
		end )
	end

	return rtvcount, totalplys
end

--[[---------------------------------------------------------
Name: GetPlayerVotePower( pl (player entity) )
Desc: Calculates the votepower of the said player.
Returns: votepower (int)
-----------------------------------------------------------]]
function GetPlayerVotePower( pl )
	return math.ceil( math.max( SVotePower, CallSettingFunction( "GetPlayerVote", pl ) or 0 ) )
end

--[[---------------------------------------------------------
Name: OpenMapVote
Desc: Forces everyone to run the glmvs_openvote concomamnd.
-----------------------------------------------------------]]
function OpenMapVote()
	for _, pl in pairs( player.GetAll() ) do
		pl:ConCommand( "glmvs_openvote" )
	end
end