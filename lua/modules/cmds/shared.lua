module( "CMD", package.seeall )

if SERVER then
	ChatCommands = {}

	--[[---------------------------------------------------------
	Name: commandChat
	Base: PlayerSay Hook
	Desc: Local function to use the PlayerSay hook for commands.
	-----------------------------------------------------------]]
	local function commandChat( pl, text, all )
		if not pl:IsPlayer() then return end

		if ChatCommands[ text ] then
			ChatCommands[ text ]( pl )

			return ""
		end
	end
	hook.Add( "PlayerSay", "GLMVS_ChatCommands", commandChat )

	--[[---------------------------------------------------------
	Name: AddConChat
	Desc: Adds a chat command with the said metaFunction using specific prefix triggers.
	-----------------------------------------------------------]]
	function AddCmdChat( str, metaFunc, triggers )
		if not metaFunc then return end

		if not triggers or not istable(triggers) then
			triggers = { "/", "!" }
		end

		for _, trig in ipairs(triggers) do
			ChatCommands[ trig .. str ] = metaFunc
		end
	end
end

--[[---------------------------------------------------------
Name: AddConCmd
Base: concommand.Add
Desc: Adds a concommand.
-----------------------------------------------------------]]
AddConCmd = concommand.Add