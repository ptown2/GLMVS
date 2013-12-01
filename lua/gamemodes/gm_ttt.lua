local GAME = {}

GAME.ID			= "terrortown"
GAME.Name		= "Trouble in Terrorist Town"
GAME.MapPrefix	= {"gm", "ttt", "cs", "de"}
GAME.MapFileDB	= "map_ttt.txt"

GAME.HookRound	= "TTTEndRound"

GAME.RoundsLeft = GetConVar("ttt_round_limit") and GetConVar("ttt_round_limit"):GetInt() or 0
GAME.TimeLeft = GetConVar("ttt_time_limit_minutes") and ( GetConVar("ttt_time_limit_minutes"):GetInt() * 60 ) or 0
function GAME:OnInitialize()
	self.RoundsLeft = GetConVar("ttt_round_limit"):GetInt() or 0
	self.TimeLeft = ( GetConVar("ttt_time_limit_minutes"):GetInt() * 60 ) or 0

	function game.LoadNextMap() return false end
	function game.GetMapNext() return "RANDOM" end
end

function GAME:GetEndTime()
	return GetConVar("ttt_preptime_seconds"):GetInt() or 30
end

function GAME:GetPlayerVote( pl )
	local votes = 0

	votes = votes + math.ceil( pl:Frags() / 5 )

	return votes
end

function GAME:ShouldRestartRound()
	self.RoundsLeft = math.max( 0, ( self.RoundsLeft or 0 ) - 1 )

	return ( self.RoundsLeft >= 1 ) and ( math.max( 0, ( self.TimeLeft or 0 ) - CurTime() ) >= 1 )
end

function GAME:OnStartVote()
	SetRoundEnd(CurTime() + self:GetEndTime() + 15)
	timer.Simple( self:GetEndTime(), GLMVS_EndVote )
end

function GAME:OnRTVSuccess()
	if GetRoundState() == ROUND_ACTIVE then
		EndRound( WIN_NONE )
	end
end

GLoader.RegisterGamemode( GAME )