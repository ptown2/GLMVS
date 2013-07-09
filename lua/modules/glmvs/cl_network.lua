module( "GLMVS", package.seeall )

net.Receive( "GLMVS_ReceiveVotes", function( pl, len )
	local mapid, votes = net.ReadInt( 32 ), net.ReadInt( 32 )

	TotalVotes = TotalVotes + votes
	Maplist[ mapid ].TotalVotes = Maplist[ mapid ].TotalVotes + votes
	Maplist[ mapid ].NextVote = math.abs( votes )
end )

net.Receive( "GLMVS_ReceiveMapInfo", function( pl, len )
	local CurGamemode = GetGamemode()
	local TempMapList = {}

	for mapid, info in pairs( Maplist ) do
		if !CurGamemode then break end

		if !table.HasValue( CurGamemode.MapPrefix, string.Explode( "_", info.Map )[ 1 ] ) then
			Maplist[ mapid ] = nil
		end

		if Maplist[ mapid ] then
			table.insert( TempMapList, info )
		end
	end

	Maplist = table.Copy( TempMapList )
	TempMapList = nil

	table.sort( Maplist, SortMaps )

	local mapinfo = net.ReadTable()
	for mapid, info in pairs( mapinfo ) do
		if info.Votes then
			TotalVotes = TotalVotes + info.Votes
			Maplist[ mapid ].TotalVotes = info.Votes
		end

		if info.Locked then
			Maplist[ mapid ].Locked = info.Locked
		end
	end

	-- Should I make that locked maps are sent to bottom or not?
	for mapid, info in pairs( Maplist ) do
		info.TotalVotes = info.TotalVotes || 0
		info.NextVote = 0
		info.ID = mapid
	end

	table.sort( Maplist, SortMaps )
end )