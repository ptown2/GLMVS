module( "Map", package.seeall )

function AddMap( map, plnum )
	if IsNonExistantMap( map ) then return end

	if SERVER then
		table.insert( MAPLIST, { Map = map, MinPlayers = 0, Locked = false } )
	end
	
	if CLIENT then
		table.insert( MAPLIST, { Map = map, Name = "", Description = "", MinPlayers = plnum, Locked = false } )
	end
end

function IsNonExistantMap( map )
	return !file.Exists( "maps/".. map ..".bsp", "MOD" )
end

function GetMapWinner()
	local mapwinner = "nil"
	local votes = 0

	for mapname, numvotes in pairs( MAPLIST ) do
		if numvotes > votes then
			votes = numvotes
			mapwinner = mapname
		end
	end

	return mapwinner, votes
end

function SortMaps(a, b)
	if ( !a || !b ) then return true end

	if a.Locked ~= b.Locked then
		return a.Locked < b.Locked
	end

	if (a.Name || a.Map) ~= (b.Name || b.Map) then
		return (a.Name || a.Map) < (b.Name || b.Map)
	end
end