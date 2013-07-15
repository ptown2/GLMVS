module( "GLMVS", package.seeall )

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