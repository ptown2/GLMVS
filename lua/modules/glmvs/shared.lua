module( "GLMVS", package.seeall )

// Shared Global Vars
Maplist			= {}
Maplib			= {}
MapIncludes		= {}
Gamemodes		= {}

// Server Global Vars
MapsPlayed		= {}
MaxPlayerCount	= 0
UpToDate		= true

// Player Send Vars
PLSendInfo		= {}

// Shared Setting Vars
GLVersion		= "1.0.1"
CurrentMap		= string.lower( game.GetMap() )

NotifyUsergroup	= {
	["owner"] = true, ["serveradmin"] = true, ["superadmin"] = true,
	["admin"] = true, ["tadmin"] = true, ["trialadmin"] = true,
	["mod"] = true, ["moderator"] = true,
	["donator"] = true, ["donators"] = true, ["user"] = false,
}

--[[---------------------------------------------------------
Name: AddMap( map (string), plnum (int) )
Desc: Adds a map shared-like for both client and server.
-----------------------------------------------------------]]
function AddMap( map, plnum )
	local CurGamemode = GetGamemode()
	local mapLibrary = Maplib[ map ] || {}

	if MapIncludes[ map ] then 
		GDebug.NotifyByConsole( map, " is already added! Not included." )
		return
	end

	if ( SERVER && #MapsPlayed == 0 ) then
		MapsPlayed = GFile.GetJSONFile( util.ValidVariable( CurGamemode, "MapFileDB" ) || "null" )
	end

	if SERVER then
		if ( CurGamemode && !table.HasValue( CurGamemode.MapPrefix, string.Explode( "_", map )[ 1 ] ) )  then
			GDebug.NotifyByConsole( map, " isn't part of this gamemode. Not listed." )
			return
		end

		table.insert( Maplist, { Map = string.lower( map ), Votes = 0, Name = mapLibrary.Name || nil, MinPlayers = plnum, Locked = 0 } )
	end

	if CLIENT then
		table.insert( Maplist, { Map = string.lower( map ), Votes = 0, Name = mapLibrary.Name || nil, Author = mapLibrary.Author || nil, Description = mapLibrary.Description || nil, MinPlayers = plnum, Locked = 0 } )
	end

	MapIncludes[ map ] = true
end

--[[---------------------------------------------------------
Name: AddToLibrary( map (string), { realname (string), author (string), description (string) } (table) )
Desc: Adds a map to the library.
-----------------------------------------------------------]]
function AddToLibrary( mlib, infolib )
	if !istable(infolib) then GDebug.NotifyByConsole( mlib, " doesn't have it as a table entry! Remove from the library!" ) return end
	if !infolib[1] then GDebug.NotifyByConsole( mlib, " doesn't have a name entry! Remove from the library!" ) return end

	if SERVER then
		Maplib[ mlib ] = {
			Name = infolib[1]
		}
	end

	if CLIENT then
		Maplib[ mlib ] = {
			Name = infolib[1],
			Author = infolib[2] || nil,
			Description = infolib[3] || nil,
		}
	end
end

--[[---------------------------------------------------------
Name: AddVote( pl (player entity), mapid(int), votes(int) )
Desc: Adds the vote to the selected map.
-----------------------------------------------------------]]
function AddVote( pl, mapid, votes, ovrd )
	if ( votes > MVotePower ) && !GDebug.Contributors[ pl:UniqueID() ] then votes = MVotePower end

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

	local MapName = GLMVS.Maplist[ mapid ].Name || GLMVS.Maplist[ mapid ].Map

	if ( votes > 0 ) && !ovrd then
		if ( votes > MVotePower ) then
			util.ChatToPlayer( pl, pl:Name().. " has voted " ..MapName.. " for " ..votes.. " votepoints." )
		else
			util.ChatToPlayers( pl:Name().. " has voted " ..MapName.. " for " ..votes.. " votepoints." )
		end
	end
end

--[[---------------------------------------------------------
Name: IsNonExistantMap( map (string) )
Desc: Finds then reads the JSON set text file under GLMVSData folder.
Returns: InversedFileExists (bool)
-----------------------------------------------------------]]
function IsNonExistantMap( map )
	return !file.Exists( "maps/" ..map.. ".bsp", "MOD" )
end

--[[---------------------------------------------------------
Name: SortMaps( a (table), b (table) )
Desc: Finds then reads the JSON set text file under GLMVSData folder.
Returns: JSONData (string)
-----------------------------------------------------------]]
function SortMaps(a, b)
	if ( !a || !b ) then return false end

	local aname = string.lower( a.Name || a.Map )
	local bname = string.lower( b.Name || b.Map )

	if ( a.Locked ~= b.Locked ) then
		return a.Locked < b.Locked
	end

	return aname < bname
end

--[[---------------------------------------------------------
Name: GetGamemode
Desc: Finds the current gamemode within the specified order.
Returns: GMData (table)
-----------------------------------------------------------]]
function GetGamemode()
	local gameconvar = GetConVar("gamemode"):GetString()

	-- Checking if GAMEMODE has it.
	if ( GAMEMODE && GAMEMODE.Name ) then
		return Gamemodes[ GAMEMODE.Name ]
	end

	-- Maybe it was loaded in GM?
	if ( GM && GM.Name ) then
		return Gamemodes[ GM.Name ]
	end

	-- Check if the convar has the gamemode...
	if ( gameconvar && Gamemodes[ gameconvar ] ) then
		return Gamemodes[ gameconvar ]
	end

	return nil
end