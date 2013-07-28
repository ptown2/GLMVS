--[[
	This lua folder's purpose is to debug GLMVS, me and anyone else with debugging privileges can do this. (Admins/SuperAdmins can manage this too, soon)
	Please DO NOT DELETE OR MODIFY THIS FOLDER AS IT MAY BREAK THE ADDON!!!
]]

module( "GDebug", package.seeall )

ColorLevels = {
	[0] = Color( 255, 255, 255, 255 ),
	[1] = Color( 0, 255, 255, 255 ),
	[2] = Color( 255, 255, 0, 255 ),
	[3] = Color( 255, 0, 0, 255 ),
}

Contributors = {
	["2450936216"] = { MID = 3, DEV = true },
	["1061425253"] = { MID = 1.5, DEV = true },
}

--[[---------------------------------------------------------
Name: NotifyByConsole
Base: MsgC( level (int)[color], str (string) )
Desc: Uses MsgC with the GLMVS tag and a new line.
-----------------------------------------------------------]]
function NotifyByConsole( level, ... )
	local color = ColorLevels[ level ]
	if !color then
		color = ColorLevels[ 0 ]
	end

	MsgC( color, "(GLMVS) - ", ... )
	MsgN( "" )
end

--[[---------------------------------------------------------
Name: CompareTwoVerVals( latest (string), current (string) )
Desc: Compares two string versions (based on this format: 1.0.0.1) within the latest and current.
Returns: isUpToDate (boolean)
-----------------------------------------------------------]]
function CompareTwoVerVals( latest, current )
	local toloop = #latest > #current && latest || current

	for vpos, _ in ipairs( toloop ) do
		local lver, cver = tonumber( latest[ vpos ] ) || 0, tonumber( current[ vpos ] ) || 0

		if ( lver > cver ) && ( lver != cver )  then
			NotifyByConsole( 3, "GLMVS is out of date." )
			return false
		elseif ( lver < cver ) && ( lver != cver ) then
			NotifyByConsole( 1, "GLMVS is up to date." )
			return true
		end
	end

	NotifyByConsole( 1, "GLMVS is up to date." )
	return true
end

--[[---------------------------------------------------------
Name: GetServerIP()
Desc: Gets the real IP with port of the server.
Returns: serverIP (string, formatted)
-----------------------------------------------------------]]
function GetServerIP()
	local hostIP = GetConVarString( "hostip" )
	local IPTable = {
		[1] = bit.band( bit.rshift( hostIP, 24 ), 0x000000FF ),
		[2] = bit.band( bit.rshift( hostIP, 16 ), 0x000000FF ),
		[3] = bit.band( bit.rshift( hostIP, 8 ), 0x000000FF ),
		[4] = bit.band( hostIP, 0x000000FF )
	}

	return string.format( "%d.%d.%d.%d:%s", IPTable[1], IPTable[2], IPTable[3], IPTable[4], GetConVarString( "hostport" ) )
end

--[[---------------------------------------------------------
Name: CheckForUpdates
Desc: Checks for an update.
-----------------------------------------------------------]]
function CheckForUpdates()
	http.Fetch( "http://raw.github.com/ptown2/GLMVS/master/lua/modules/glmvs/shared.lua",
	function( str )
		if !str then return end

		local vstart, vend = string.find( str, "GLVersion" ), string.find( str, "CurrentMap" )
		local cversion = GLMVS.GLVersion
		local lversion = string.gsub( string.sub( str, vstart, vend - 2 ), "[^0-9$.]", "" )

		NotifyByConsole( 1, "Current Version: ", cversion, " -- Latest Version: ", lversion )

		cversion = string.Explode( ".", GLMVS.GLVersion, false )
		lversion = string.Explode( ".", lversion, false )

		GLMVS.UpToDate = CompareTwoVerVals( lversion, cversion )
	end,
	function()
		NotifyByConsole( 3, "Failed to retrieve current version." )
	end )
end

--[[---------------------------------------------------------
Name: OptToListing
Desc: Sends your server info for server listing.
-----------------------------------------------------------]]
function OptToListing()
	if GLMVS.OptOutListing then return end

	local isPassworded = GetConVar("sv_password"):GetString() != ""
	local gamemodename = GetConVarString("gamemode")

	http.Post( "http://ptown2.0fees.net/glmvsreport.php", {
		serverip	= GetServerIP(),
		servername	= GetHostName(),
		gmname		= gamemodename || "None",
		version		= GLMVS.GLVersion,
		dedicated	= game.IsDedicated() && "TRUE" || "FALSE",
		passworded	= isPassworded && "TRUE" || "FALSE"
	}, 
	function( str )
		if !str then return end

		NotifyByConsole( 1, "GLMVS has sent server info for listing!" )
		NotifyByConsole( 1, str )
	end,
	function()
		NotifyByConsole( 3, "Failed to send server info." )
	end )
end

--[[---------------------------------------------------------
Name: PrintResults
Desc: Debugging
-----------------------------------------------------------]]
function PrintResults()
	NotifyByConsole( 1, "GLMVS Add-on v", GLMVS.GLVersion, " has loaded successfully." )
	NotifyByConsole( 1, table.Count( GLMVS.Maplist ), " Maps are now loaded!" )
	NotifyByConsole( 1, table.Count( GLMVS.Gamemodes ) / 2, " Gamemode Settings are now loaded!" )
end

--[[---------------------------------------------------------
Name: PrintMapTable
Desc: Debugging
-----------------------------------------------------------]]
function PrintMapTable( pl )
	if SERVER then return end
	if !pl:IsPlayer() then return end
	if !Contributors[ pl:UniqueID() ] then return end
	
	PrintTable( GLMVS.Maplist )
end
concommand.Add( "glmvs_printmaps", PrintMapTable )