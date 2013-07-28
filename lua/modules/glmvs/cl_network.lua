module( "GLMVS", package.seeall )


net.Receive( "GLMVS_ReceiveVotes", function( pl, len )
	local mapid, votes = net.ReadInt( 32 ), net.ReadInt( 32 )

	TotalVotes = TotalVotes + votes
	Maplist[ mapid ].TotalVotes = Maplist[ mapid ].TotalVotes + votes
	Maplist[ mapid ].NextVote = math.abs( votes )
end )


net.Receive( "GLMVS_ReceiveMapInfo", function( pl, len )
	-- Organize votes and locked maps what not
	local mapinfo = net.ReadTable()

	for mapid, info in ipairs( mapinfo ) do
		if Maplist[ mapid ] && info.Locked then
			Maplist[ mapid ].Locked = info.Locked
		end

		if Maplist[ mapid ] && info.Removed then
			Maplist[ mapid ].Removed = info.Removed
		end
	end

	-- Sort them once more.
	table.sort( Maplist, SortMaps )

	-- Then add the correct votes for it.
	for mapid, info in ipairs( mapinfo ) do
		if Maplist[ mapid ] && info.Votes then
			TotalVotes = info.Votes
			Maplist[ mapid ].TotalVotes = info.Votes
		end
	end
end )