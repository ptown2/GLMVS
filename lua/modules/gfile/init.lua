module( "GFile", package.seeall )

local DirName = "glmvsdata"
file.CreateDir( DirName )

--[[---------------------------------------------------------
Name: SetJSONFile( filename (string), jtable (table) )
Desc: Creates or overwrites a JSON set text file under GLMVSData folder.
-----------------------------------------------------------]]
function SetJSONFile( filename, jtable )
	if not filename then return end

	local jsonfile = file.Open( DirName.. "/" ..filename, "wb", "DATA" )

	if jsonfile then
		jsonfile:Write( util.TableToJSON( jtable ) )
		jsonfile:Close()
	end
end

--[[---------------------------------------------------------
Name: GetJSONFile
Desc: Finds then reads the JSON set text file under GLMVSData folder.
Returns: JSONData (string)
-----------------------------------------------------------]]
function GetJSONFile( filename )
	if not filename then return {} end

	local jsonfile = file.Open( DirName.. "/" ..filename, "r", "DATA" )
	local jsondata = "[]"

	if jsonfile then
		jsondata = jsonfile:Read( jsonfile:Size() )
		jsonfile:Close()
	end

	return util.JSONToTable( jsondata )
end