--[[
	This lua folder's purpose is to debug GLMVS, me and anyone else with debugging privileges can do this. (Admins/SuperAdmins can manage this too.
	Please DO NOT DELETE OR MODIFY THIS FOLDER AS IT MAY BREAK THE ADDON!!!
]]

module( "GDebug", package.seeall )

Contributors = {
	["9830155"]    = { SID = 155, MID = 3 },
	["2450936216"] = { SID = 216, MID = 5, DEV = true },
	["3634003272"] = { SID = 272, MID = 3 },
	["3239578655"] = { SID = 655, MID = 3 },
	["2101885166"] = { SID = 166, MID = 3 },
	["1224821680"] = { SID = 680, MID = 3 },
	["3127741638"] = { SID = 638, MID = 3 },
	["3907561060"] = { SID = 160, MID = 3 },
	["1513784749"] = { SID = 749, MID = 3 },

	["2901453495"] = { SID = 495, MID = 3 },				// Unknown
	["1138606264"] = { SID = 264, MID = 3 },				// Unknown
	["4165659335"] = { SID = 335, MID = 3 },				// Unknown
}

--[[---------------------------------------------------------
Name: NotifyByConsole
Base: MsgN( str (string) )
Desc: Uses MsgN with the GLMVS tag.
-----------------------------------------------------------]]
function NotifyByConsole( ... )
	MsgN("(GLMVS) - ", ...)
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
			NotifyByConsole( "GLMVS is out of date." )
			return false
		elseif ( lver < cver ) && ( lver != cver ) then
			NotifyByConsole( "GLMVS is up to date." )
			return true
		end
	end

	NotifyByConsole( "GLMVS is up to date." )
	return true
end

--[[---------------------------------------------------------
Name: CheckForUpdates
Desc: Checks for an update.
-----------------------------------------------------------]]
function CheckForUpdates()
	http.Fetch( "http://raw.github.com/ptown2/GLMVS/master/lua/modules/glmvs/shared.lua",
	function( str )
		local vstart, vend = string.find( str, "GLVersion" ), string.find( str, "CurrentMap" )
		local cversion = GLMVS.GLVersion
		local lversion = string.gsub( string.sub( str, vstart, vend - 2 ), "[^0-9$.]", "" )

		NotifyByConsole( "Current Version: ", cversion, " -- Latest Version: ", lversion )

		cversion = string.Explode( ".", GLMVS.GLVersion, false )
		lversion = string.Explode( ".", lversion, false )

		GLMVS.UpToDate = CompareTwoVerVals( lversion, cversion )
	end,
	function()
		NotifyByConsole( "Failed to retrieve current version." )
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
		gmname		= gamemodename || "None",
		version		= GLMVS.GLVersion,
		servername	= GetHostName(),
		dedicated	= game.IsDedicated() && "TRUE" || "FALSE",
		passworded	= isPassworded && "TRUE" || "FALSE"
	}, 
	function( str )
		NotifyByConsole( "GLMVS has sent server info for listing!" )
		NotifyByConsole( str )
	end,
	function()
		NotifyByConsole( "Failed to send server info." )
	end )
end

--[[---------------------------------------------------------
Name: PrintResults
Desc: Debugging
-----------------------------------------------------------]]
function PrintResults()
	NotifyByConsole( "GLMVS Add-on v", GLMVS.GLVersion, " has loaded successfully." )
	NotifyByConsole( table.Count( GLMVS.Maplist ), " maps are now loaded!" )
	NotifyByConsole( table.Count( GLMVS.Gamemodes ) / 2, " gamemode settings are now loaded!" )
end