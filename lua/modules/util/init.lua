local CheckMeta = {
	["Player"] = IsValid,
	["Entity"] = IsValid,
	["table"] = istable,
}

--[[---------------------------------------------------------
Name: ValidVariable( meta (table), var (variable) )
Desc: Checks if the variable is a valid one.
Returns: validVar (variable)
-----------------------------------------------------------]]
function util.ValidVariable( meta, var )
	if meta and meta[ var ] then
		return meta[ var ]
	end

	return nil
end

--[[---------------------------------------------------------
Name: ValidFunction( meta (table function), funcname (function name string), ... (arguments) )
Desc: Checks if the function is a valid one.
Returns: validFunc (function)
-----------------------------------------------------------]]
function util.ValidFunction( meta, funcname, ... )
	if meta and meta[ funcname ] then
		return meta[ funcname ]( meta, ... )
	end

	return nil
end

--[[---------------------------------------------------------
Name: ChatToPlayer( meta (table), var (variable) )
Desc: Sends a printmessage to a specific player.
-----------------------------------------------------------]]
function util.ChatToPlayer( pl, str )
	pl:PrintMessage( HUD_PRINTTALK, str )
end

--[[---------------------------------------------------------
Name: ChatToPlayers( str (string) )
Desc: Sends a printmessage to every player.
-----------------------------------------------------------]]
function util.ChatToPlayers( str )
	for _, pl in pairs( player.GetAll() ) do
		pl:PrintMessage( HUD_PRINTTALK, str )
	end
end