-- This one will not work until the creator of this gamemode adds the line to call the hooks.
GAME.ID			= "stalker"
GAME.Name		= "The Stalker"
GAME.MapPrefix	= {"ts_"}
GAME.MapFileDB	= "map_stalker"

GAME.HookEnd	= "RoundEnd"

function GAME:OnInitialize()
	ROUNDSLEFT = GetConVar("sv_ts_num_rounds"):GetInt() or 0

	-- This is to prevent the gamemode change the map via mapcycle.
	function game.LoadNextMap() return false end
	function game.GetMapNext() return "RANDOM" end
end

function GAME:GetEndTime()
	return 15
end

function GAME:ShouldRestartRound()
	ROUNDSLEFT = math.max(0, (ROUNDSLEFT or 0) - 1)

	if ROUNDSLEFT <= 0 then
		timer.Simple(self:GetEndTime(), EndVote)
		return false
	end
	return true
end