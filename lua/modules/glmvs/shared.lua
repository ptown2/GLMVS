module( "GLMVS", package.seeall )

// Shared Global Vars
Maplist		= {}
Maplib		= {}
Gamemodes	= {}

// Shared Setting Vars
GLVersion	= "1.0.0"
CurrentMap	= string.lower( game.GetMap() )

function AddMap( map, plnum )
	if IsNonExistantMap( map ) then return end

	if SERVER then
		table.insert( Maplist, { Map = map, MinPlayers = 0, Locked = false } )
	end
	
	if CLIENT then
		table.insert( Maplist, { Map = map, Name = "", Description = "", MinPlayers = plnum, Locked = false } )
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