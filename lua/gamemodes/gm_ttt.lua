local GAME = {}

GAME.ID			= "ttt"
GAME.Name		= "Trouble in Terrorist Town"
GAME.MapPrefix	= {"gm", "ttt"}
GAME.MapFileDB	= "map_ttt"

GAME.HookEnd	= "TTTEndRound"

function GAME:OnInitialize()
	ROUNDSLEFT = GetConVar("ttt_round_limit"):GetInt() or 0
	TIMELEFT = (GetConVar("ttt_time_limit_minutes"):GetInt() * 60) or 0

	-- This is to prevent the gamemode change the map via mapcycle.
	function game.LoadNextMap() return false end
	function game.GetMapNext() return "RANDOM" end
end

function GAME:GetEndTime()
	return GetConVar("ttt_preptime_seconds"):GetInt() or 0
end

function GAME:ShouldRestartRound()
	ROUNDSLEFT = (ROUNDSLEFT or 0) - 1

	if ROUNDSLEFT <= 0 or math.max(0, (TIMELEFT or 0) - CurTime()) <= 0 then
		timer.Simple((GetConVar("ttt_preptime_seconds"):GetInt() or 0), EndVote)
		return false
	end

	return true
end

GLoader.RegisterGamemode( GAME )