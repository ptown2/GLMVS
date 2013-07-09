local GAME = {}

GAME.ID			= "zombieescape"
GAME.Name		= "Zombie Escape"
GAME.MapPrefix	= {"ze"}
GAME.MapFileDB	= "map_zombieescape.txt"

GAME.HookEnd	= "OnTeamWin"
GAME.HookMap	= "OnChangeRound"

function GAME:OnInitialize()
	-- Not sure...
end

function GAME:GetEndTime()
	return 0 -- ???
end

function GAME:ShouldRestartRound()
	return self:GetRound() < self:GetMaxRounds()
end

function GAME:GetPlayerVote( pl )
	local votes = 0

	return math.ceil(votes / 5)
end

GLoader.RegisterGamemode( GAME )