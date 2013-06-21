include( "fileload.lua" )

if SERVER then
	AddCSLuaFile()
	AddCSLuaFile( "fileload.lua " )
	AddCSLuaFile( "init.lua" )
	AddCSLuaFile( "shared.lua" )
	AddCSLuaFile( "sh_maplist.lua" )
	AddCSLuaFile( "sh_addmaps.lua" )
	AddCSLuaFile( "cl_init.lua" )

	include( "shared.lua" )
	include( "sh_maplist.lua")
	include( "sh_addmaps.lua" )
	include( "init.lua" )
end

if CLIENT then
	include( "shared.lua" )
	include( "sh_maplist.lua")
	include( "sh_addmaps.lua" )
	include( "cl_init.lua" )
end