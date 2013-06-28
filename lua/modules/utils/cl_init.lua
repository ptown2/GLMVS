function util.LowestSizeMult( factor, size )
	return math.floor( ( factor / size ) - 1 )
end

function util.Sizeto720p( size, src )
	return math.floor( size * ( src / 720 ) )
end

function util.IsValidImage( mapname )
	if file.Exists( "maps/" ..mapname.. ".png", "MOD" ) then
		return "../maps/" ..mapname.. ".png"
	end

	return "../maps/noicon.png"
end