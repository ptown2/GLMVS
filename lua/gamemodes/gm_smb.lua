local GAME = {}

GAME.ID			= "supermayhemboxes"
GAME.Name		= "Super Mayhem Boxes"
GAME.MapPrefix	= {"smb", "nox2d"}
GAME.MapFileDB	= "map_smb.txt"

function GAME:OnInitialize()
	local oldEndGame = GAMEMODE.EndGame

	function GAMEMODE:EndGame( winner )
		oldEndGame( GAMEMODE, winner )
		GLMVS_StartVote()
	end

	function game.LoadNextMap() return false end
end

function GAME:GetEndTime()
	return 30
end

function GAME:GetPlayerVote( pl )
	return math.ceil( pl:Frags() / 2 )
end

function GAME:OnStartVote()
	timer.Simple( self:GetEndTime(), GLMVS_EndVote )
end

GLoader.RegisterGamemode( GAME )