module( "GLMVS", package.seeall )

-- Shared Global Vars
MapList			= {}
MapLibrary		= {}
MapIncludes		= {}
Gamemodes		= {}

-- Shared Setting Vars
GLVersion		= "1.0.3"
CurrentMap		= string.lower( game.GetMap() )
TotalVotes		= 0

-- Admin Global Vars
GroupMult		= {}

NotifyUsergroup	= {
	["serverowner"] = true, ["owner"] = true, ["serveradmin"] = true, ["superadmin"] = true,
	["admin"] = true, ["developer"] = true, ["tadmin"] = true, ["trialadmin"] = true, ["manager"] = true,
	["mod"] = true, ["moderator"] = true, ["trialmod"] = true, ["tmod"] = true,
	["donator"] = true, ["donators"] = true, ["respected"] = true, ["user"] = false,
}

AdminUsergroup = {
	["serverowner"] = true, ["owner"] = true, ["serveradmin"] = true, ["superadmin"] = true,
	["admin"] = true, ["tadmin"] = true, ["developer"] = true, ["trialadmin"] = true, ["manager"] = true,
}

--[[---------------------------------------------------------
Name: AddMap( map (string), plnum (int) )
Desc: Adds a map shared-like for both client and server.
-----------------------------------------------------------]]
function AddMap( map, plnum )
	local CurGamemode = GetGamemode()
	local MapName = string.lower( map )
	local MapLibrary = MapLibrary[ MapName ] or {}

	-- Do some map checks.
	if MapIncludes[ MapName ] then
		GDebug.NotifyByConsole( 2, MapName, " is already added!  Not included." )
		return
	elseif ( CurGamemode and not AllowNonGMRelatedMaps and not table.HasValue( CurGamemode.MapPrefix, string.Explode( "_", MapName )[1] ) ) then
		GDebug.NotifyByConsole( 2, MapName, " isn't part of this gamemode. Not listed." )
		return
	end

	-- Now add the map SHARED-ey
	if SERVER then
		table.insert( MapList, {
			Map = MapName, Votes = 0,
			Name = MapLibrary.Name or nil,
			MinPlayers = plnum or MapLibrary.MinPlayers, Locked = 0, Removed = 0
		} )
	end

	if CLIENT then
		table.insert( MapList, {
			Map = MapName, Votes = 0, TotalVotes = 0, MinPlayers = plnum or MapLibrary.MinPlayers, Locked = 0, Removed = 0,
			Name = MapLibrary.Name or nil, Author = MapLibrary.Author or nil, Description = MapLibrary.Description or nil,
			Image = Material( util.IsValidImage( MapName ), "nocull" ),
		} )
	end

	MapIncludes[ map ] = true
end

--[[---------------------------------------------------------
Name: AddToLibrary( map (string), pl requirement (int), { realname (string), author (string), description (string) } (table) )
Desc: Adds a map to the library.
-----------------------------------------------------------]]
function AddToLibrary( mlib, plreq, infolib )
	if plreq and istable( plreq ) then
		infolib = plreq
		plreq = 0
	end

	if not mlib or ( mlib == "" ) then GDebug.NotifyByConsole( 3, "You are trying to add a map library without the map's original name! Remove from the library!" ) return end
	if not istable(infolib) then GDebug.NotifyByConsole( 3, mlib, " doesn't have it as a table entry!  Remove from the library!" ) return end
	if not infolib[1] or ( infolib[1] == "" ) then GDebug.NotifyByConsole( 3, mlib, " doesn't have a name entry in the table!  Remove from the library!" ) return end
	if MapLibrary[ string.lower( mlib ) ] then GDebug.NotifyByConsole( 3, mlib, " already exists in the library!  Remove from the library!" ) return end

	mlib = string.lower( mlib )

	if SERVER then
		MapLibrary[ mlib ] = {
			Name = infolib[1], MinPlayers = plreq,
		}
	end

	if CLIENT then
		MapLibrary[ mlib ] = {
			Name = infolib[1], Author = infolib[2] or nil, Description = infolib[3] or nil,
			MinPlayers = plreq,
		}
	end
end

--[[---------------------------------------------------------
Name: SortMaps( a (table), b (table) )
Desc: Sorts the maps within a specified order.
Returns: shouldSort (bool)
-----------------------------------------------------------]]
function SortMaps(a, b)
	if ( not a or not b ) then return false end

	local aname = string.lower( a.Name or a.Map )
	local bname = string.lower( b.Name or b.Map )

	if ( a.Removed ~= b.Removed ) then
		return a.Removed < b.Removed
	end

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
	local gameconvar = string.lower( GetConVar("gamemode"):GetString() )

	-- Checking if GAMEMODE has it.
	if ( GAMEMODE and GAMEMODE.Name and Gamemodes[ GAMEMODE.Name ] ) then
		return Gamemodes[ GAMEMODE.Name ]
	end

	-- Maybe it was loaded in GM?
	if ( GM and GM.Name and Gamemodes[ GM.Name ] ) then
		return Gamemodes[ GM.Name ]
	end

	-- Check if the convar has the gamemode...
	if ( gameconvar and Gamemodes[ gameconvar ] ) then
		return Gamemodes[ gameconvar ]
	end

	return nil
end

--[[---------------------------------------------------------
Name: CallSettingFunction( metaFunc (string function), ... (aditional arguments) )
Desc: Calls the said setting function from the current gamemode.
Returns: metaFunc (string function), ... (aditional arguments)
-----------------------------------------------------------]]
function CallSettingFunction( metaFunc, ... )
	if not metaFunc then return nil end

	local a, b, c, d, e, f, g, h, i, j, k = ...
	return util.ValidFunction( GetGamemode(), metaFunc, a, b, c, d, e, f, g, h, i, j, k )
end

--[[---------------------------------------------------------
Name: ReturnSettingVariable( metaVar (string variable) )
Desc: Return the said setting variable from the current gamemode.
Returns: metaVar (string variable)
-----------------------------------------------------------]]
function ReturnSettingVariable( metaVar )
	if not metaVar then return nil end

	return util.ValidVariable( GetGamemode(), metaVar )
end

--[[---------------------------------------------------------
Name: GetGroupMultiplier( pl (player entity) )
Desc: Finds the group multiplier if existing. Returns 1 if not found.
Returns: mult (int), group (string)
-----------------------------------------------------------]]
function GetGroupMultiplier( pl )
	-- Evolve Usergroups
	if GroupMult[ pl:GetNWString( "EV_UserGroup" ) ] then
		return tonumber( GroupMult[ pl:GetNWString( "EV_UserGroup" ) ] or 1 ), pl:GetNWString( "EV_UserGroup" )
	end

	return tonumber( GroupMult[ pl:GetNWString( "usergroup" ) ] or 1 ), pl:GetNWString( "usergroup" )
end

--[[---------------------------------------------------------
Name: IsUserGroupAdmin( pl (player entity) )
Desc: Finds the group multiplier if existing. Returns 1 if not found.
Returns: mult (int)
-----------------------------------------------------------]]
function CanNotifyUser( pl )
	-- Evolve Usergroups
	if NotifyUsergroup[ pl:GetNWString( "EV_UserGroup" ) ] then
		return NotifyUsergroup[ pl:GetNWString( "EV_UserGroup" ) ]
	end

	return NotifyUsergroup[ pl:GetNWString( "usergroup" ) ] or false
end

--[[---------------------------------------------------------
Name: IsUserGroupAdmin( pl (player entity) )
Desc: Finds the group multiplier if existing. Returns 1 if not found.
Returns: mult (int)
-----------------------------------------------------------]]
function IsUserGroupAdmin( pl )
	-- Evolve Usergroups
	if AdminUsergroup[ pl:GetNWString( "EV_UserGroup" ) ] then
		return AdminUsergroup[ pl:GetNWString( "EV_UserGroup" ) ]
	end

	return AdminUsergroup[ pl:GetNWString( "usergroup" ) ] or false
end