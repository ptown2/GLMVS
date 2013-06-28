local CheckMeta = {
	["Player"] = IsValid,
	["Entity"] = IsValid,
	["table"] = istable,
}

function util.ValidVariable( meta, var )
	if meta and meta[ var ] then
		return meta[ var ]
	end
	
	return nil
end

function util.ValidFunction( meta, funcname, ... )
	if meta and meta[ funcname ] then
		return meta[ funcname ]( meta, ... )
	end
	
	return nil
end

function util.ChattoPlayers( str )
	for _, pl in pairs( player.GetAll() ) do
		pl:PrintMessage( HUD_PRINTTALK, str )
	end
end