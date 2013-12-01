module( "util", package.seeall )

--[[---------------------------------------------------------
Name: LowestSizeMult( factor (int, screen wid/hei), size (int) )
Desc: Checks if the function is a valid one.
Returns: multFactor (int)
-----------------------------------------------------------]]
function LowestSizeMult( factor, size )
	return math.floor( ( factor / size ) - 1 )
end

--[[---------------------------------------------------------
Name: SizeTo720p( size (int), src (int, screen wid/hei) )
Desc: Checks if the function is a valid one.
Returns: pixelSize (int)
-----------------------------------------------------------]]
function SizeTo720p( size, src )
	return math.floor( size * ( src / 720 ) )
end

--[[---------------------------------------------------------
Name: IsValidImage( mapname (string) )
Desc: Checks if the image is valid.
Returns: imgDirectory (string)
-----------------------------------------------------------]]
function IsValidImage( mapname )
	if file.Exists( "download/maps/" ..mapname.. ".png", "MOD" ) then
		return "../download/maps/" ..mapname.. ".png"
	end

	if file.Exists( "maps/" ..mapname.. ".png", "MOD" ) then
		return "../maps/" ..mapname.. ".png"
	end

	if file.Exists( "materials/noicon.png", "MOD" ) then
		return "materials/noicon.png"
	end

	if file.Exists( "maps/noicon.png", "MOD" ) then
		return "../maps/noicon.png"
	end

	if file.Exists( "download/maps/noicon.png", "MOD" ) then
		return "../download/maps/noicon.png"
	end

	return "null"
end