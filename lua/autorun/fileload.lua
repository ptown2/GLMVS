module( "GLoader", package.seeall )

local function GetFileList( strDirectory )
	local files = {}

	local realDirectory = strDirectory.. "/*"
	local findFiles, findFolders = file.Find( realDirectory, "LUA" )

	for k, v in ipairs( table.Add( findFiles, findFolders ) ) do
		if ( v == "." || v == ".." || v == ".svn" ) then continue end
		table.insert( files, v )
	end

	return files
end

local function GetFileType( strFile )
	return string.sub( strFile, -4 )
end

local function IsLuaFile( strFile )
	return ( GetFileType( strFile ) == ".lua" )
end

local function IsDirectory( strDir )
	return ( string.GetExtensionFromFilename( strDir ) == nil )
end

local function LoadFile( strDirectory, strFile )
	local prefix = string.sub( strFile, 0, 3 )
	local realFile = strDirectory.. "/" ..strFile

	if ( prefix == "sh_" || strFile == "shared.lua" ) then
		include( realFile )
	elseif ( prefix == "cl_" || strFile == "cl_init.lua" ) then
		if CLIENT then include( realFile ) end
	elseif ( prefix == "sv_" || strFile == "init.lua" ) then
		if SERVER then include( realFile ) end
	elseif strDirectory == "gamemodes" then
		include( realFile )
	end
end

function RegisterCSFiles( strDirectory )
	local filelist = GetFileList( strDirectory )

	for _, filen in ipairs( filelist ) do
		local prefix = string.sub( filen, 0, 3 )

		if ( IsLuaFile( filen ) ) then
			if ( prefix == "cl_" || prefix == "sh_" || prefix == "gm_" ) || ( filen == "shared.lua" || filen == "cl_init.lua" ) then
				AddCSLuaFile( strDirectory.. "/" ..filen )
			end
		else
			RegisterCSFiles( strDirectory.. "/" ..filen )
		end
	end
end

function RegisterLuaFiles( strDirectory )
	local filelist = GetFileList( strDirectory )

	for _, filen in ipairs( filelist ) do
		local prefix = string.sub( filen, 0, 3 )

		if ( IsLuaFile( filen ) ) then
			LoadFile( strDirectory, filen )
		else
			if !( GetFileType( filen ) == ".txt" ) then
				RegisterLuaFiles( strDirectory.. "/" ..filen )
				--MsgN( "(GLMVS) - ", "MODULE folder ", filen, " loaded." )
			end
		end
	end
end

function RegisterGamemode( tblGame )
	if ( tblGame.ID && tblGame.Name ) then
		if SERVER then
			GLMVS.Gamemodes[ tblGame.ID ] = tblGame
			GLMVS.Gamemodes[ tblGame.Name ] = tblGame
		end

		if CLIENT then
			GLMVS.Gamemodes[ tblGame.ID ] = { ID = tblGame.ID, Name = tblGame.Name, MapPrefix = tblGame.MapPrefix }
			GLMVS.Gamemodes[ tblGame.Name ] = { ID = tblGame.ID, Name = tblGame.Name, MapPrefix = tblGame.MapPrefix }
		end

		--MsgN( "(GLMVS) - ", "GAMEMODE SETTING ", tblGame.Name, " loaded." )
	end
end