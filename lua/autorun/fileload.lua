module( "GLoader", package.seeall )

local blacklisted = {
	["README_LAYOUT.lua"] = true,
}

local function GetFileList( strDirectory )
	local files = {}

	local realDirectory = strDirectory.. "/*"
	local findFiles, findFolders = file.Find( realDirectory, "LUA" )

	for k, v in ipairs( table.Add( findFiles, findFolders ) ) do
		if ( v == "." or v == ".." or v == ".svn" ) then continue end
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

	if ( prefix == "cl_" or strFile == "cl_init.lua" ) then
		if CLIENT then include( realFile ) end
	elseif ( prefix == "sv_" or strFile == "init.lua" ) then
		if SERVER then include( realFile ) end
	elseif strDirectory == "gamemodes" then
		include( realFile )
	else
		include( realFile )
	end
end


function RegisterCSFiles( strDirectory, noTree )
	local filelist = GetFileList( strDirectory )

	for _, filen in ipairs( filelist ) do
		local prefix = string.sub( filen, 0, 3 )

		if IsLuaFile( filen ) then
			if ( prefix == "cl_" or prefix == "sh_" or prefix == "gm_" ) or ( filen == "shared.lua" or filen == "cl_init.lua" ) or ( prefix ~= "sv_" ) and not ( blacklisted[ filen ] ) then
				AddCSLuaFile( strDirectory.. "/" ..filen )
			end
		else
			if not noTree then
				RegisterCSFiles( strDirectory.. "/" ..filen )
			end
		end
	end
end

function RegisterLuaFiles( strDirectory, noTree )
	local filelist = GetFileList( strDirectory )

	for _, filen in ipairs( filelist ) do
		local prefix = string.sub( filen, 0, 3 )

		if IsLuaFile( filen ) and not blacklisted[ filen ] then
			LoadFile( strDirectory, filen )
		else
			if IsDirectory( filen ) and not noTree then
				RegisterLuaFiles( strDirectory.. "/" ..filen )
				MsgN( "(GLMVS) - ", "MODULE folder ", filen, " loaded." )
			end
		end
	end
end

function RegisterGamemode( tblGame )
	if ( tblGame.ID and tblGame.Name ) then
		local id, name = tblGame.ID, tblGame.Name

		if SERVER then
			GLMVS.Gamemodes[ id ] = tblGame
			GLMVS.Gamemodes[ name ] = tblGame
		end

		if CLIENT then
			local gmtbl = { ID = tblGame.ID, Name = tblGame.Name, MapPrefix = tblGame.MapPrefix or {"gm", "dm", "cs", "de"}, DermaPack = tblGame.DermaPack or "" }

			GLMVS.Gamemodes[ id ] = gmtbl
			GLMVS.Gamemodes[ name ] = gmtbl
		end

		MsgN( "(GLMVS) - ", "GAMEMODE SETTING ", name, " loaded." )
	end
end