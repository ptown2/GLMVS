/* ----------------------------------------
	Autorun that shit
---------------------------------------- */
if SERVER then
	AddCSLuaFile( )
	AddCSLuaFile( "fileload.lua" )
end

include( "fileload.lua" )


/* ----------------------------------------
	AddCSLua all of the lua folders
---------------------------------------- */
if SERVER then
	AddCSLuaFile( "cl_init.lua" )
	AddCSLuaFile( "addmaps.lua" )
	AddCSLuaFile( "maplibrary.lua" )

	GLoader.RegisterCSFiles( "modules" )
	GLoader.RegisterCSFiles( "gamemodes" )
end


/* ----------------------------------------
	Include all of the modules and gamemodes
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
		GDebug.PrintResults()
		GDebug.CheckForUpdates()
		GDebug.OptToListing()
	end

	if CLIENT then
		include( "cl_init.lua" )
	end
end )