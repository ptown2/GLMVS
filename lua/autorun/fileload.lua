module( "GLoader", package.seeall )

local function GetFileList( strDirectory )
	local files = {}

	local realDirectory = strDirectory.. "/*"
	local findFiles, findFolders = file.Find( realDirectory, "lsv" )

	for k, v in pairs( table.Add(findFiles, findFolders) ) do
		if ( v == "." || v == ".." || v == ".svn" ) then continue end
		table.insert( files, v )
	end

	return files
end

local function IsLuaFile( strFile )
	return ( string.sub( strFile, -4 ) == ".lua" )
end

local function IsDirectory( strDir )
	return ( string.GetExtensionFromFilename( strDir ) == nil )
end

local function LoadFile( strDirectory, strFile )
	local prefix = string.sub( strFile, 0, 3 )
	local realFile = strDirectory.. "/" ..strFile

	if ( prefix == "sh_" || strFile == "shared.lua" ) then
		MsgN( "SHARED Lua file: ", realFile, " loaded." )
		include( realFile )
	elseif ( prefix == "cl_" || strFile == "cl_init.lua" ) then
		MsgN( "CLIENT Lua file: ", realFile, " loaded." )
		if CLIENT then include( realFile ) end
	elseif ( prefix == "sv_" || strFile == "init.lua" ) then
		MsgN( "SERVER Lua file: ", realFile, " loaded." )
		if SERVER then include( realFile ) end
	elseif strDirectory == "gamemodes" then
		MsgN( "GAMEMODE Lua file: ", realFile, " loaded." )
		include( realFile )
	end
end

function RegisterCSFile( strDirectory )
	local filelist = GetFileList( strDirectory )

	for i, filen in pairs( filelist ) do
		local prefix = string.sub( filen, 0, 3 )

		if ( IsLuaFile( filen ) ) then
			if ( prefix == "cl_" || prefix == "sh_" || prefix == "gm_" ) || ( filen == "shared.lua" || filen == "cl_init.lua") then
				AddCSLuaFile( strDirectory.. "/" ..filen )
			end
		else
			RegisterCSFile( strDirectory.. "/" ..filen )
		end
	end
end

function RegisterGamemode( tblGame )
	if ( tblGame.ID && tblGame.Name ) then
		GLMVS.Gamemodes[ tblGame.ID ] = tblGame
		GLMVS.Gamemodes[ tblGame.Name ] = tblGame
	end
end