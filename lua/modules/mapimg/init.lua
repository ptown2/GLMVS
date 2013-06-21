hook.Add( "InitPostEntity", "AddResourceMapIMG", function() 
	for _, info in pairs( MAPLIST ) do
		if file.Exists( "maps/" .. info.Map .. ".png", "MOD" ) then
			resource.AddFile( "maps/" .. info.Map .. ".png" )
		end
	end
end)