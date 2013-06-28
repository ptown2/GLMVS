module( "GLMVS", package.seeall )

function GetNextMap()
	local mapwinner = nil
	local votes = 0

	for _, info in pairs( GLMVS.Maplist ) do
		if info.Votes > votes then
			votes = info.Votes
			mapwinner = info.Map
		end
	end

	return mapwinner, votes
end

function PickUnlockedRandom()
	local unlocked = {}

	for _, info in pairs( GLMVS.Maplist ) do
		if !tobool( info.Locked ) then
			table.insert( unlocked, info.Map )
		end
	end

	return table.Random( unlocked )
end

function GetPlayerVotePower( pl )
	local CurGamemode = GLMVS.ReturnCurGamemode()

	return math.max( GLMVS.SVotePower, math.ceil( ( util.ValidFunction( CurGamemode, "GetPlayerVote", pl ) || 0 ) ) )
end

function OpenMapVote()
	for _, pl in pairs( player.GetAll() ) do
		pl:ConCommand("glmvs_openvote")
	end
end