GAME, LANG = {}, {}

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

	if ( prefix == "cl_" || strFile == "cl_init.lua" ) then
		if SERVER then AddCSLuaFile( realFile ) else include( realFile ) end
		return
	elseif ( prefix == "sh_" || strFile == "shared.lua" ) then
		if SERVER then AddCSLuaFile( realFile ) end
		include( realFile )
		return
	elseif ( prefix == "sv_" || strFile == "init.lua" ) then
		if SERVER then include( realFile ) end
		return
	end

	AddCSLuaFile( realFile )
	include( realFile )
end

function RegisterLuaFolder( strDirectory )
	local fileList = GetFileList( strDirectory )

	for i, filen in pairs( fileList ) do
		if ( IsLuaFile( filen ) ) then
			LoadFile( strDirectory, filen )
		end

		if ( IsDirectory( filen ) ) then
			RegisterLuaFolder( strDirectory.. "/" ..filen )
		end
	end
end

function RegisterGamemodes( strDirectory )
	local included = {}
	local gamemodelist = GetFileList( strDirectory )

	for i, filen in pairs(gamemodelist) do
		if IsLuaFile( filen ) then
			LoadFile( strDirectory, filen )

			if ( GAME.Name && GAME.ID ) then
				GLMVS.Gamemodes[GAME.ID] = GAME
				GLMVS.Gamemodes[GAME.Name] = GAME
			end

			included[filen] = GAME
			GAME = nil
		end
	end
end

function RegisterLanguages( strDirectory )
	local included = {}
	--local langlist = GetFileList( strDirectory )
end