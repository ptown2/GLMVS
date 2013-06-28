GAME.ID			= "zombieescape"
GAME.Name		= "Zombie Escape"
GAME.MapPrefix	= {"ze"}
GAME.MapFileDB	= "map_zombieescape"

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

	/*
	if IsValid(pl) then
		votes = votes + ( pl.ZombiesKilled or 0 )
	end
	*/

	return math.ceil(votes / 5)
end