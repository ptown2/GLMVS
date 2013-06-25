--util.AddNetworkString("GLMVS_RecieveMaps")
util.AddNetworkString("GLMVS_UpdateVotes")

hook.Add( "InitPostEntity", "AddResourceMapIMG", function() 
	for _, info in pairs( GLMVS.Maplist ) do
		if file.Exists( "maps/" .. info.Map .. ".png", "MOD" ) then
			resource.AddFile( "maps/" .. info.Map .. ".png" )
		end
	end
end )