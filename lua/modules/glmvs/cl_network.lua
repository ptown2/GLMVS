module( "GLMVS", package.seeall )

net.Receive( "GLMVS_GroupMultInfo", function( len, pl )
	local orgGroup, tempGroup = net.ReadTable(), {}

	for id, val in pairs( orgGroup ) do
		tempGroup[ #tempGroup + 1 ] = { gid = id, mult = tonumber( val ) }
	end

	table.sort( tempGroup, SortByGroup )
	GroupEditMult = tempGroup
	GroupMult = orgGroup

	GEditor.UpdateGroupMult()
end )

net.Receive( "GLMVS_ReceiveVotes", function( len, pl )
	local mapid, plent = net.ReadUInt( 32 ), Entity( net.ReadUInt( 16 ) )
	local votes, ovrd =  net.ReadInt( 32 ), net.ReadInt( 32 )
	local name = MapList[ mapid ].Name or MapList[ mapid ].Map

	TotalVotes = TotalVotes + votes
	MapList[ mapid ].TotalVotes = MapList[ mapid ].TotalVotes + votes

	if IsValid( plent ) and plent:IsPlayer() then
		local plmult, plgroup = GetGroupMultiplier( plent )
		local mcolor, mtext = Color( 0, 0, 0 ), ""

		if ( votes > 0 ) and ( not ovrd or ovrd == 0 ) then
			if ( plmult > 1 ) then
				mcolor, mtext = Color(0, 255, 125), "  [" .. math.ceil( ( plmult - 1 ) * 100 ) .. "% " .. string.upper( plgroup ) .. " Bonus]"
			end

			if not GDebug.Contributors[ plent:UniqueID() ] or ( GDebug.Contributors[ plent:UniqueID() ] and ( plent == LocalPlayer() ) ) then
				chat.AddText(
					Color(255, 25, 25), plent:Name(), Color(255, 255, 255), " has voted ",
					Color(0, 255, 0), name, Color(255, 255, 255), " for ",
					Color(0, 255, 0), tostring( votes ), Color(255, 255, 255), " votepoints.",
					mcolor, mtext
				)
				chat.PlaySound()
			end
		end
	end
end )


net.Receive( "GLMVS_ReceiveMapInfo", function( len, pl )
	-- Organize votes and locked maps.
	local mapinfo = net.ReadTable()

	for mapid, info in ipairs( mapinfo ) do
		if MapList[ mapid ] and info.Locked then
			MapList[ mapid ].Locked = info.Locked
		end

		if MapList[ mapid ] and info.Removed then
			MapList[ mapid ].Removed = info.Removed
		end
	end

	-- Sort them once more.
	table.sort( MapList, SortMaps )

	-- Then add the correct votes for it.
	for mapid, info in ipairs( mapinfo ) do
		if MapList[ mapid ] and info.Votes then
			TotalVotes = info.Votes
			MapList[ mapid ].TotalVotes = info.Votes
		end
	end
end )

--[[---------------------------------------------------------
Name: SortByGroup
Desc: Sorts the GroupMult whoever updates the list.
-----------------------------------------------------------]]
function SortByGroup( a, b )
	if ( not a or not b ) then return false end
	if ( not a.mult or not b.mult ) then return false end

	return tostring( a.mult ) < tostring( b.mult )
end