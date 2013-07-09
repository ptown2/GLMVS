module( "CMD", package.seeall )

--[[---------------------------------------------------------
Name: AddConChat
Base: PlayerSay Hook
Desc: Adds a chat command with the said metaFunction.
-----------------------------------------------------------]]
function AddConChat( str, metaFunc )
	local function commandChat( pl, text, all )
		if !pl:IsPlayer() then return end

		if text == "/" ..str || text == "!" ..str then
			if metaFunc then
				metaFunc( pl )
			end
			return ""
		end
	end

	hook.Add( "PlayerSay", "GLMVS_" ..string.upper( str ), commandChat )
end

--[[---------------------------------------------------------
Name: AddConCmd
Base: concommand.Add
Desc: Adds a concommand.
-----------------------------------------------------------]]
function AddConCmd( str, func )
	concommand.Add( str, func )
end