local GAME = {}

GAME.ID				= "zombiesurvival"
GAME.Name			= "Zombie Survival"
GAME.MapPrefix		= {"zs", "zm", "zh", "zps", "zr", "ze", "cs", "de"}
GAME.MapFileDB		= "map_zombiesurvival.txt"

GAME.HookRound		= "EndRound"
GAME.HookPostRound	= "LoadNextMap"

function GAME:OnInitialize()
	function GAMEMODE:LoadNextMap() return end
end

GAME.ZombieBonusTime = 0
GAME.RoundPlay = 0
function GAME:OnInitPostEntity()
	self.ZombieBonusTime = CurTime() + GAMEMODE.WaveZeroLength + 1250
	self.RoundPlay = self.RoundPlay + 1
end

function GAME:GetEndTime()
	return GAMEMODE.EndGameTime
end

function GAME:GetPlayerVote( pl )
	local votes = 0
	local ct = CurTime()

	if IsValid( pl ) then
		votes = votes + ( ( pl.ZombiesKilled or 0 ) / 4 )
		votes = votes + ( ( pl.ZombiesKilledAssists or 0 ) / 2 )
		votes = votes + ( ( pl.BrainsEaten or 0 ) * 4 )
		votes = votes + ( ( pl.BarricadeDamage or 0 ) / 100 )
		votes = votes + ( ( pl.RepairedThisRound or 0 ) / 50 )
		votes = votes + ( ( pl.HealedThisRound or 0 ) / 10 )

		if pl.DamageDealt then
			votes = votes + ( ( pl.DamageDealt[TEAM_HUMAN] or 0 ) / 250 )
			votes = votes + ( ( pl.DamageDealt[TEAM_UNDEAD] or 0 ) / 30 )
		end

		if ROUNDWINNER and ( ROUNDWINNER == TEAM_HUMAN ) then
			local SurvivalTime = math.max( ct - ( pl.SpawnedTime or 0 ), pl.SurvivalTime or 0 )
			votes = votes + ( SurvivalTime * 0.08333 )
		elseif pl.SurvivalTime then
			votes = votes + ( pl.SurvivalTime * 0.08333 )
		end

		if ROUNDWINNER and ( ROUNDWINNER == TEAM_UNDEAD ) and GAMEMODE.StartingZombie[ pl:UniqueID() ] then
			local ZombieTime = math.max( 0, ( self.ZombieBonusTime or 2400 ) - ct )
			votes = votes + ( ZombieTime * 0.125 )
		end
	end

	return math.floor( votes / 4 )
end

function GAME:ShouldRestartRound()
	return GAMEMODE:ShouldRestartRound()
end

function GAME:CanPlayerRTV( pl )
	if ( self.RoundPlay == 1 ) then
		return false, "Needs to be in the 2nd round of playing this map."
	end

	return true
end

function GAME:OnRTVSuccess()
	local zteam, hteam = 0, 0

	for _, pl in pairs(player.GetAll()) do
		if pl.RockedAlready then
			if ( pl:Team() == TEAM_HUMAN ) then
				hteam = hteam + 1
			else
				zteam = zteam + 1
			end
		end
	end

	gamemode.Call( "SetWave", 6 )
	gamemode.Call( "EndRound", hteam > zteam and TEAM_UNDEAD or TEAM_HUMAN )

	timer.Simple( self:GetEndTime(), GLMVS_EndVote )
end

GLoader.RegisterGamemode( GAME )