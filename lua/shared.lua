-- _G = debug.getregistry() -- Might use this later...
-- Shared Load Global Vars
GAME			= {}
LANG			= {}

-- Shared Global Vars
MAPLIST			= {}
GAMEMODES		= {}
MAPLIB			= {}

-- Shared Config Vars
GLVERSION		= "1.0.0"
CURRENTMAP		= string.lower( game.GetMap() )

-- Load all files
Loader.RegisterLuaFolder( "modules" )
Loader.RegisterGamemodes( "gamemodes" )
Loader.RegisterLanguages( "localization" )