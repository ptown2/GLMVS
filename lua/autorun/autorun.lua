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

	GLoader.RegisterCSFile( "modules" )
	GLoader.RegisterCSFile( "gamemodes" )
	GLoader.RegisterCSFile( "localization" )
end


/* ----------------------------------------
	Include all of the modules
---------------------------------------- */
if SERVER then
	-- Included all SERVER/SHARED modules manually...	
	include( "modules/glmvs/shared.lua" )
	include( "modules/glmvs/sh_convars.lua" )
	include( "modules/glmvs/init.lua" )
	include( "modules/glmvs/sv_load.lua" )
	include( "modules/gfile/init.lua" )
	include( "modules/gdebug/shared.lua" )
	include( "modules/cmds/init.lua" )
	include( "modules/util/init.lua" )
end

if CLIENT then
	-- Included all CLIENT/SHARED modules manually...
	include( "modules/glmvs/shared.lua" )
	include( "modules/glmvs/sh_convars.lua" )
	include( "modules/glmvs/cl_init.lua" )
	include( "modules/glmvs/cl_network.lua" )
	include( "modules/gdebug/shared.lua" )
	include( "modules/draw/cl_init.lua" )
	include( "modules/util/cl_init.lua" )
	include( "modules/skin/cl_zombiesurvival.lua" )
end


/* ----------------------------------------
	Include Gamemode Settings
---------------------------------------- */
include( "gamemodes/gm_zs.lua" )
include( "gamemodes/gm_ttt.lua" )
include( "gamemodes/gm_zescape.lua" )
include( "gamemodes/gm_stalker.lua" )


/* ----------------------------------------
	Include Rest of the crap
---------------------------------------- */
if SERVER then
	include( "maplibrary.lua" )
	include( "addmaps.lua" )
	include( "init.lua" )
end

if CLIENT then
	include( "maplibrary.lua" )
	include( "addmaps.lua" )
	include( "cl_init.lua" )
end


/* ----------------------------------------
	GDebug functions to run
---------------------------------------- */
hook.Add( "Initialize", "GLMVS_GDebugPrint", function()
	if SERVER then
		GDebug.PrintResults()
		GDebug.CheckForUpdates()
		GDebug.OptToListing()
	end
end )