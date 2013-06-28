hook.Add( "InitPostEntity", "DebugPrintConsole", function()
	MsgN( table.Count( GLMVS.Maplist ), " maps are now loaded!" )
	MsgN( table.Count( GLMVS.Gamemodes ) / 2, " gamemode settings are now loaded!" )
end )