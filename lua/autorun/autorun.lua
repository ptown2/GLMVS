if SERVER then
	AddCSLuaFile()
	AddCSLuaFile( "fileload.lua" )
	AddCSLuaFile( "init.lua" )
	--AddCSLuaFile( "shared.lua" )
	AddCSLuaFile( "sh_addmaps.lua" )
	AddCSLuaFile( "cl_init.lua" )

	-- AddCSLuaFile'd all modules manually...
	AddCSLuaFile( "modules/glmvs/shared.lua" )
	AddCSLuaFile( "modules/glmvs/sh_convars.lua" )
	AddCSLuaFile( "modules/glmvs/cl_init.lua" )
	AddCSLuaFile( "modules/gdebug/shared.lua" )
	AddCSLuaFile( "modules/skin/cl_zombiesurvival.lua" )
	AddCSLuaFile( "modules/utils/cl_init.lua" )

	AddCSLuaFile( "gamemodes/gm_zs.lua" )
	AddCSLuaFile( "gamemodes/gm_ttt.lua" )
	AddCSLuaFile( "gamemodes/gm_zescape.lua" )
	AddCSLuaFile( "gamemodes/gm_stalker.lua" )
end

if SERVER then
	include( "fileload.lua" )

	-- Included all modules manually...	
	include( "modules/glmvs/shared.lua" )
	include( "modules/glmvs/sh_convars.lua" )
	include( "modules/glmvs/init.lua" )
	include( "modules/glmvs/sv_load.lua" )
	include( "modules/gdebug/init.lua" )
	include( "modules/gdebug/shared.lua" )
	include( "modules/utils/init.lua" )

	include( "gamemodes/gm_zs.lua" )
	include( "gamemodes/gm_ttt.lua" )
	include( "gamemodes/gm_zescape.lua" )
	include( "gamemodes/gm_stalker.lua" )

	--include( "shared.lua" )
	include( "sh_addmaps.lua" )
	include( "init.lua" )
end

if CLIENT then
	include( "fileload.lua" )

	-- Included all modules manually...
	include( "modules/glmvs/shared.lua" )
	include( "modules/glmvs/sh_convars.lua" )
	include( "modules/glmvs/cl_init.lua" )
	include( "modules/gdebug/shared.lua" )
	include( "modules/skin/cl_zombiesurvival.lua" )
	include( "modules/utils/cl_init.lua" )

	include( "gamemodes/gm_zs.lua" )
	include( "gamemodes/gm_ttt.lua" )
	include( "gamemodes/gm_zescape.lua" )
	include( "gamemodes/gm_stalker.lua" )

	--include( "shared.lua" )
	include( "sh_addmaps.lua" )
	include( "cl_init.lua" )
end