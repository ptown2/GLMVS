local GAME = {}

GAME.ID			= "deathrun"
GAME.Name		= "Deathrun"
GAME.MapPrefix	= {"dr"}
GAME.MapFileDB	= "map_deathrun.txt"

GAME.HookRound	= "OnRoundSet"

GAME.RoundsLeft = 0
function GAME:OnInitialize()
	self.RoundsLeft = GetConVar("dr_total_rounds"):GetInt() or 0

	function RTV.Start() end
	function RTV.ChangeMap() end
	function RTV.CanVote() return false end
end

function GAME:GetEndTime()
	return 30
end

function GAME:GetPlayerVote( pl )
	return pl:Frags()
end

function GAME:ShouldRestartRound( round )
	if ( round == ROUND_ENDING ) then
		self.RoundsLeft = math.max( 0, ( self.RoundsLeft or 0 ) - 1 )

		return self.RoundsLeft > 0
	end

	return true
end

function GAME:OnStartVote()
	GAMEMODE:SetRoundTime( self:GetEndTime() + 15 )
	timer.Simple( self:GetEndTime(), GLMVS_EndVote )
end

function GAME:OnRTVSuccess()
	local dteam, rteam = 0, 0

	for _, pl in pairs(player.GetAll()) do
		if pl.RockedAlready then
			if ( pl:Team() == TEAM_RUNNER ) then
				rteam = rteam + 1
			else
				dteam = dteam + 1
			end
		end
	end

	gamemode.Call( "SetRound", ROUND_ENDING, rteam > dteam and TEAM_DEATH or TEAM_RUNNER )
end

GLoader.RegisterGamemode( GAME )