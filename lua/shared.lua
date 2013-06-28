/* --------------------------------------------------------------------------
    GLMVS - Globalized Map Voting System
    Copyright (C) 2012  Robert Lind (ptown2)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
-------------------------------------------------------------------------- */

_G = debug.getregistry() -- Might use this later...

/* --------------------------------------------------------------------------
	The GLoader was having huge problems loading the modules folder, so I 
	had to disable it...
	
	Great, now this is a huge mess.
-------------------------------------------------------------------------- */

--[[
-- Load all files

GLoader.RegisterLuaFolder( "modules" )
GLoader.RegisterGamemodes( "gamemodes" )
GLoader.RegisterLanguages( "localization" )
]]