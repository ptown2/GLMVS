local GAME = {}

GAME.ID			= "zombieescape"
GAME.Name		= "ZombieEscape"
GAME.MapPrefix	= {"ze"}
GAME.MapFileDB	= "map_zombieescape.txt"

GAME.HookRound	= "ChangeMap"

function GAME:OnInitialize()
	function GAMEMODE:ChangeMap() return end
end

function GAME:GetEndTime()
	return 30
end

function GAME:GetPlayerVote( pl )
	return math.ceil( pl:Frags() * 2 )
end

function GAME:OnStartVote()
	GAMEMODE:SendMapMessage( "Changing map in " ..self:GetEndTime().. " seconds." )
	timer.Simple( self:GetEndTime(), GLMVS_EndVote )
end

GLoader.RegisterGamemode( GAME )