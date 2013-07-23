local GAME = {}

GAME.ID			= "awesomestrike"
GAME.Name		= "Awesome Strike: Source"
GAME.MapPrefix	= {"cs", "de", "as", "aim", "fy", "ctf", "asctf"}
GAME.MapFileDB	= "map_ass.txt"

GAME.HookEnd	= "LoadNextMap"

function GAME:OnInitialize()
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