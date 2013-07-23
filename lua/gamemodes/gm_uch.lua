local GAME = {}

GAME.ID			= "ultimatechimerahunt"
GAME.Name		= "Ultimate Chimera Hunt"
GAME.MapPrefix	= {"uch"}
GAME.MapFileDB	= "map_uch.txt"

GAME.HookEnd	= "RoundEnd"

function GAME:OnInitialize()
	-- Do something else
end

function GAME:GetEndTime()
	return 30
end

function GAME:ShouldRestartRound()
	return true
end

function GAME:OnStartVote()
	timer.Simple( self:GetEndTime(), GLMVS_EndVote )
end

function GAME:GetPlayerVote( pl )
	local votes = 0

	return votes
end

GLoader.RegisterGamemode( GAME )