/* ----------------------------------------
	Autorun that shit
---------------------------------------- */
if SERVER then
	AddCSLuaFile()
	AddCSLuaFile( "fileload.lua" )
end

include( "fileload.lua" )


/* ----------------------------------------
	AddCSLua all of the lua folders/files.
---------------------------------------- */
if SERVER then
	AddCSLuaFile( "addmaps.lua" )
	AddCSLuaFile( "maplibrary.lua" )

	GLoader.RegisterCSFiles( "modules" )
	GLoader.RegisterCSFiles( "gamemodes" )
	GLoader.RegisterCSFiles( "vgui" )
end


/* ----------------------------------------
	Include the rest of the addon.
---------------------------------------- */
GLoader.RegisterLuaFiles( "modules" )
GLoader.RegisterLuaFiles( "gamemodes" )


/* ----------------------------------------
	Include rest of the crap and run debug functions
---------------------------------------- */
hook.Add( "Initialize", "GLMVS_LoadEverything", function()
	include( "maplibrary.lua" )
	include( "addmaps.lua" )

	if SERVER then
		include( "init.lua" )

		-- Run the managing functions.
		GLMVS.ManageResources()
		GLMVS.ManageMaps()

		-- Run the debugging functions.
		GDebug.CheckForUpdates()
		GDebug.OptToListing()

		-- Count the map early.
		GLMVS.AddToRecentMaps( GLMVS.CurrentMap )
		GLMVS.CountFromMap( GLMVS.CurrentMap )
	end

	if CLIENT then
		local folderpack = GLMVS.ReturnSettingVariable( "DermaPack" ) or ""
		local folderlayout = GLMVS.ReturnSettingVariable( "DermaLayout" ) or ""

		GLoader.RegisterLuaFiles( "vgui", true )

		if ( folderpack and folderlayout ) and ( folderpack ~= "" ) and ( folderlayout ~= "" ) then
			GLoader.RegisterLuaFiles( "vgui/".. string.lower( folderpack ), true )
		else
			GLoader.RegisterLuaFiles( "vgui/pack_default", true )
		end

		CMD.AddConCmd( "glmvs_openvote", _G[ "GLMVS_VoteMap_Menu" ] )
	end

	-- Print-out the results.
	GDebug.PrintResults()
end )