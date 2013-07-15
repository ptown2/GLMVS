local GAME = {}

GAME.ID			= "stalker"
GAME.Name		= "The Stalker"
GAME.MapPrefix	= {"ts"}
GAME.MapFileDB	= "map_stalker.txt"

GAME.HookEnd	= "LoadNextMap"

function GAME:OnInitialize()
	-- This is to prevent the gamemode change the map automatically.
	function GAMEMODE:LoadNextMap() return end
end

function GAME:GetEndTime()
	return 30
end

function GAME:OnStartVote()
	timer.Simple( self:GetEndTime(), GLMVS_EndVote )
end

function GAME:GetPlayerVote( pl )
	local votes = 0

	return votes
end

GLoader.RegisterGamemode( GAME )