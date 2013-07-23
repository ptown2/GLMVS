local GAME = {}

GAME.ID			= "zombiesurvival"
GAME.Name		= "Zombie Survival"
GAME.MapPrefix	= {"zs", "zm", "zh", "zps", "zr", "ze"}
GAME.MapFileDB	= "map_zombiesurvival.txt"

GAME.HookEnd	= "EndRound"
GAME.HookMap	= "LoadNextMap"

function GAME:OnInitialize()
	function GAMEMODE:LoadNextMap() return end
end

function GAME:GetEndTime()
	return GAMEMODE.EndGameTime
end

function GAME:ShouldRestartRound()
	return GAMEMODE:ShouldRestartRound()
end

function GAME:GetPlayerVote( pl )
	local ct = CurTime()
	local votes = 0

	if IsValid( pl ) then
		votes = votes + ((pl.ZombiesKilled or 0) / 5)
		votes = votes + ((pl.ZombiesKilledAssists or 0) / 2)
		votes = votes + ((pl.BrainsEaten or 0) * 2)
		votes = votes + ((pl.BarricadeDamage or 0) / 100)
		votes = votes + ((pl.RepairedThisRound or 0) / 50)
		votes = votes + ((pl.HealedThisRound or 0) / 10)

		if pl.DamageDealt then
			votes = votes + ((pl.DamageDealt[TEAM_HUMAN] or 0) / 200)
			votes = votes + ((pl.DamageDealt[TEAM_UNDEAD] or 0) / 30)
		end

		if ROUNDWINNER and ROUNDWINNER == TEAM_HUMAN then
			local SurvivalTime = math.max(ct - (pl.SpawnedTime or 0), pl.SurvivalTime or 0)
			votes = votes + (SurvivalTime * 0.08333)
		elseif pl.SurvivalTime then
			votes = votes + (pl.SurvivalTime * 0.08333)
		end

		if ROUNDWINNER and ROUNDWINNER == TEAM_UNDEAD and GAMEMODE.StartingZombie[pl:UniqueID()] then
			local ZombieTime = math.max(0, ((GAMEMODE.WaveZeroLength or 1) + 1600) - ct)
			votes = votes + (ZombieTime * 0.125)
		end
	end

	return math.ceil(votes / 4)
end

GLoader.RegisterGamemode( GAME )