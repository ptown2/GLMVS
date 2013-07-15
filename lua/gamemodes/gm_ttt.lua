local GAME = {}

GAME.ID			= "terrortown"
GAME.Name		= "Trouble in Terrorist Town"
GAME.MapPrefix	= {"gm", "ttt"}
GAME.MapFileDB	= "map_ttt.txt"

GAME.HookEnd	= "TTTEndRound"

function GAME:OnInitialize()
	self.ROUNDSLEFT = GetConVar("ttt_round_limit"):GetInt() || 0
	self.TIMELEFT = ( GetConVar("ttt_time_limit_minutes"):GetInt() * 60 ) || 0

	-- This is to prevent the gamemode change the map via mapcycle.
	function game.LoadNextMap() return false end
	function game.GetMapNext() return "RANDOM" end
end

function GAME:GetEndTime()
	return GetConVar("ttt_preptime_seconds"):GetInt() || 0
end

function GAME:ShouldRestartRound()
	self.ROUNDSLEFT = ( self.ROUNDSLEFT || 0 ) - 1

	return ( self.ROUNDSLEFT >= 1 ) && ( math.max( 0, ( self.TIMELEFT || 0 ) - CurTime() ) >= 1 )
end

function GAME:OnStartVote()
	timer.Simple( self:GetEndTime(), GLMVS_EndVote )
end

function GAME:GetPlayerVote( pl )
	local votes = 0

	return votes
end

GLoader.RegisterGamemode( GAME )