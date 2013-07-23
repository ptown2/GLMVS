module( "GLMVS", package.seeall )

-- Server Global Vars
MapCount		= {}
MapsPlayed		= {}
MaxPlayerCount	= 0
UpToDate		= true

-- Player Send Vars
PLSendInfo		= {}

--[[---------------------------------------------------------
Name: GetNextMap
Desc: Gets the map with the most votes.
Returns: mapwinner (string), votes (int)
-----------------------------------------------------------]]
function GetNextMap()
	local mapwinner = nil
	local votes = 0

	for _, info in pairs( Maplist ) do
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

	for _, info in pairs( Maplist ) do
		if !tobool( info.Locked ) then
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
	return !file.Exists( "maps/" ..map.. ".bsp", "MOD" )
end

--[[---------------------------------------------------------
Name: AddToRecentMaps( map (string) )
Desc: Adds the map to the recently played maps data.
-----------------------------------------------------------]]
function AddToRecentMaps( map )
	if ( !MapIncludes[ map ] || MapsPlayed[ map ] ) then return end

	MapsPlayed[ map ] = true
	GFile.SetJSONFile( util.ValidVariable( GetGamemode(), "MapFileDB" ), MapsPlayed )
end

--[[---------------------------------------------------------
Name: CountFromMap( map (string) )
Desc: Counts the times this map has been played.
-----------------------------------------------------------]]
function CountFromMap( map )
	if ( !MapCount[ map ] ) then
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
	if ( MVotePower > 0 ) && ( votes > MVotePower ) && !GDebug.Contributors[ pl:UniqueID() ] then
		votes = MVotePower
	end

	local MapName = GLMVS.Maplist[ mapid ].Name || GLMVS.Maplist[ mapid ].Map

	Maplist[ mapid ].Votes = Maplist[ mapid ].Votes + votes

	net.Start( "GLMVS_ReceiveVotes" )
		net.WriteInt( mapid, 32 )
		net.WriteInt( votes, 32 )
	net.Broadcast()

	pl.VotedAlready = mapid
	pl.VotePower = votes

	if ovrd then
		pl.VotePower = ovrd
	end

	if ( votes > 0 ) && !ovrd then
		if GDebug.Contributors[ pl:UniqueID() ] then
			util.ChatToPlayer( pl, pl:Name().. " has voted " ..MapName.. " for " ..votes.. " votepoints." )
		else
			util.ChatToPlayers( pl:Name().. " has voted " ..MapName.. " for " ..votes.. " votepoints." )
		end
	end
end

--[[---------------------------------------------------------
Name: AddRTV( pl (player entity) )
Desc: Adds a RTV Vote by the player.
-----------------------------------------------------------]]
function AddRTV( pl )
	local CurGamemode = GetGamemode()
	local rtvcount, totalplys = 0, math.ceil( #player.GetAll() * RTVThreshold )
	local rtvtimelimit = RTVWaitTime * 60

	for _, pl in pairs( player.GetAll() ) do
		if pl.RTVAlready then
			rtvcount = rtvcount + 1
		end
	end

	if !RTVMode then
		util.ChatToPlayer( pl, "You can't RTV since the server has it disabled." )
		return
	elseif ( CurTime() <= rtvtimelimit ) then
		util.ChatToPlayer( pl, "You have to wait " ..( rtvtimelimit / 60 ).. " minutes before doing a RTV." )
		return
	elseif ( #player.GetAll() < 1 ) then
		util.ChatToPlayer( pl, "You can't RTV since you're the only one." )
		return
	elseif pl.RockedAlready then
		util.ChatToPlayer( pl, "You can't RTV since you already did it." )
		return
	end

	pl.RockedAlready = true
	util.ChatToPlayers( pl:Name().. " has decided to RTV. Requires " ..( totalplys - rtvcount ).. " more RTV votes." )

	CheckForRTV()
end

--[[---------------------------------------------------------
Name: CheckForRTV
Desc: Checks if a RTV is going to be made.
-----------------------------------------------------------]]
function CheckForRTV()
	local rtvcount, totalplys = 0, math.ceil( #player.GetAll() * RTVThreshold )

	for _, pl in pairs( player.GetAll() ) do
		if pl.RTVAlready then
			rtvcount = rtvcount + 1
		end
	end

	if ( rtvcount >= totalplys ) then
		util.ChatToPlayers( "Limit reached to RTV. Changing the map in 30 seconds." )
		OpenMapVote()
		timer.Simple( 30, GLMVS_EndVote )
	end
end

--[[---------------------------------------------------------
Name: GetPlayerVotePower( pl (player entity) )
Desc: Finds then reads the JSON set text file under GLMVSData folder.
Returns: votepower (int)
-----------------------------------------------------------]]
function GetPlayerVotePower( pl )
	return math.max( SVotePower, math.ceil( ( util.ValidFunction( GetGamemode(), "GetPlayerVote", pl ) || 0 ) ) )
end

--[[---------------------------------------------------------
Name: OpenMapVote
Desc: Forces everyone to run the glmvs_openvote concomamnd.
-----------------------------------------------------------]]
function OpenMapVote()
	for _, pl in pairs( player.GetAll() ) do
		pl:ConCommand("glmvs_openvote")
	end
end