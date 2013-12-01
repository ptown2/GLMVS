module( "GDebug", package.seeall )

--[[---------------------------------------------------------
Name: GetServerIP()
Desc: Gets the real IP with port of the server.
Returns: serverIP (string, formatted)
-----------------------------------------------------------]]
function GetServerIP()
	if game.SinglePlayer() then return end

	local hex = 0x000000FF
	local hostIP = GetConVarString( "hostip" )
	local IPTable = {
		bit.band( bit.rshift( hostIP, 24 ), hex ),
		bit.band( bit.rshift( hostIP, 16 ), hex ),
		bit.band( bit.rshift( hostIP, 8 ), hex ),
		bit.band( hostIP, hex )
	}

	return string.format( "%d.%d.%d.%d:%s", IPTable[1], IPTable[2], IPTable[3], IPTable[4], GetConVarString( "hostport" ) )
end

--[[---------------------------------------------------------
Name: CheckForUpdates
Desc: Checks for an update.
-----------------------------------------------------------]]
function CheckForUpdates()
	if game.SinglePlayer() then return end

	http.Fetch( "http://raw.github.com/ptown2/GLMVS/master/lua/modules/glmvs/shared.lua",
	function( str )
		if not str then return end

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
Name: CompareTwoVerVals( latest (string), current (string) )
Desc: Compares two string to table versions (based on this format: 1.0.0.1) within the latest and current.
Returns: isUpToDate (boolean)
-----------------------------------------------------------]]
function CompareTwoVerVals( latest, current )
	local toloop = #latest > #current and latest or current

	for vpos, _ in ipairs( toloop ) do
		local lver, cver = tonumber( latest[ vpos ] ) or 0, tonumber( current[ vpos ] ) or 0

		if ( lver > cver ) and ( lver ~= cver )  then
			NotifyByConsole( 3, "GLMVS is out of date." )
			return false
		elseif ( lver < cver ) and ( lver ~= cver ) then
			NotifyByConsole( 1, "GLMVS is up to date." )
			return true
		end
	end

	NotifyByConsole( 1, "GLMVS is up to date." )
	return true
end

--[[---------------------------------------------------------
Name: OptToListing
Desc: Sends your server info for server listing.
-----------------------------------------------------------]]
function OptToListing()
	if game.SinglePlayer() or GLMVS.OptOutListing then return end

	local isPassworded = GetConVar("sv_password"):GetString() ~= ""
	local gamemodename = GetConVarString("gamemode")

	http.Post( "http://ptown2.0fees.net/glmvsreport.php", {
		serverip	= GetServerIP(),
		servername	= GetHostName(),
		gmname		= gamemodename or "None",
		version		= GLMVS.GLVersion,
		dedicated	= game.IsDedicated() and "TRUE" or "FALSE",
		passworded	= isPassworded and "TRUE" or "FALSE"
	}, 
	function( str )
		if not str then return end

		NotifyByConsole( 1, "GLMVS has sent server info for listing!" )
		NotifyByConsole( 1, str )
	end,
	function()
		NotifyByConsole( 3, "Failed to send server info." )
	end )
end

--[[---------------------------------------------------------
Name: PrintMapTable
Desc: Debugging
-----------------------------------------------------------]]
function PrintMapTable( pl )
	if not pl:IsPlayer() then return end
	if not Contributors[ pl:UniqueID() ] then return end
	
	PrintTable( GLMVS.MapList )
end
CMD.AddConCmd( "glmvs_printmaps", PrintMapTable )