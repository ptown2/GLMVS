module( "util", package.seeall )

--[[---------------------------------------------------------
Name: ChatToPlayer( pl (entity), str (string) )
Desc: Sends a printmessage to a specific player.
-----------------------------------------------------------]]
function ChatToPlayer( pl, str )
	if not IsValid( pl ) then return end

	pl:PrintMessage( HUD_PRINTTALK, str )
end

--[[---------------------------------------------------------
Name: ChatToPlayers( str (string) )
Desc: Sends a printmessage to every player.
-----------------------------------------------------------]]
function ChatToPlayers( str )
	for _, pl in pairs( player.GetAll() ) do
		pl:PrintMessage( HUD_PRINTTALK, str )
	end
end