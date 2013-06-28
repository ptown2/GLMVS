module( "GLMVS", package.seeall )

// Shared Global Vars
Maplist			= {}
MapsPlayed		= {}
Maplib			= {}
Gamemodes		= {}
MaxPlayerCount	= 0

// Shared Setting Vars
GLVersion	= "1.0.0.3"
CurrentMap	= string.lower( game.GetMap() )

function AddMap( map, plnum )
	local CurGamemode = GLMVS.ReturnCurGamemode()
	local isLocked = ( CurrentMap == string.lower( map ) ) && 1 || 0

	if CurGamemode then
		if !table.HasValue( CurGamemode.MapPrefix, string.Explode( "_", map )[ 1 ] ) then return end
	end

	if SERVER then
		table.insert( Maplist, { Map = string.lower( map ), Votes = 0, MinPlayers = plnum, Locked = isLocked } )
	end

	if CLIENT then
		table.insert( Maplist, { Map = string.lower( map ), Votes = 0, Name = nil, Author = nil, Description = nil, MinPlayers = plnum, Locked = isLocked } )
	end
end

function AddVote( pl, mapid, votes )
	Maplist[ mapid ].Votes = Maplist[ mapid ].Votes + votes

	net.Start( "GLMVS_ReceiveVotes" )
		net.WriteInt( mapid, 32 )
		net.WriteInt( votes, 32 )
	net.Broadcast()

	pl.VotedAlready = mapid
	pl.VotePower = votes
end

function IsNonExistantMap( map )
	return !file.Exists( "maps/" ..map.. ".bsp", "MOD" )
end

function SortMaps(a, b)
	if ( !a || !b ) then return false end

	local aname = string.lower( a.Name || a.Map )
	local bname = string.lower( b.Name || b.Map )

	if ( a.Locked ~= b.Locked ) then
		return a.Locked < b.Locked
	end

	return aname < bname
end

function ReturnCurGamemode()
	local gameconvar = GetConVar("gamemode"):GetString()

	if ( gameconvar && Gamemodes[ gameconvar ] ) then
		return Gamemodes[ gameconvar ]
	end

	if ( GAMEMODE && GAMEMODE.Name ) then
		return Gamemodes[ GAMEMODE.Name ]
	end

	if ( GM && GM.Name ) then
		return Gamemodes[ GM.Name ]
	end

	return nil
end