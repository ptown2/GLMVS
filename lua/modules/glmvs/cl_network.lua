module( "GLMVS", package.seeall )


net.Receive( "GLMVS_ReceiveVotes", function( pl, len )
	local mapid, votes = net.ReadInt( 32 ), net.ReadInt( 32 )

	TotalVotes = TotalVotes + votes
	Maplist[ mapid ].TotalVotes = Maplist[ mapid ].TotalVotes + votes
	Maplist[ mapid ].NextVote = math.abs( votes )
end )


net.Receive( "GLMVS_ReceiveMapInfo", function( pl, len )
	table.sort( Maplist, SortMaps )

	-- Set their corresponding map id or something
	for mapid, info in pairs( Maplist ) do
		info.TotalVotes = 0
		info.NextVote = 0
		info.Image = Material( util.IsValidImage( info.Map ), "nocull" )
		info.ID = mapid
	end

	-- Organize votes and locked maps what not
	local mapinfo = net.ReadTable()

	for mapid, info in pairs( mapinfo ) do
		if Maplist[ mapid ] && info.Locked then
			Maplist[ mapid ].Locked = info.Locked
		end
	end

	table.sort( Maplist, SortMaps )

	for mapid, info in pairs( mapinfo ) do
		if Maplist[ mapid ] && info.Votes then
			TotalVotes = TotalVotes + info.Votes
			Maplist[ mapid ].TotalVotes = info.Votes
		end
	end
end )