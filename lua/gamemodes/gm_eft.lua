local GAME = {}

GAME.ID			= "extremefootballthrowdown"
GAME.Name		= "Extreme Football Throwdown"
GAME.MapPrefix	= {"eft", "xft"}
GAME.MapFileDB	= "map_eft.txt"

function GAME:OnInitialize()
	local oldEndOfGame, oldOnEndOfGame = GAMEMODE.EndOfGame, GAMEMODE.OnEndOfGame

	function GAMEMODE:EndOfGame( bGamemodeVote )
		oldEndOfGame( GAMEMODE, false )
	end

	function GAMEMODE:OnEndOfGame( bGamemodeVote )
		oldOnEndOfGame( GAMEMODE, bGamemodeVote )
		GLMVS_StartVote()
	end
end

function GAME:GetEndTime()
	return 30
end

function GAME:GetPlayerVote( pl )
	return math.ceil( pl:Frags() / 10 )
end

function GAME:OnStartVote()
	timer.Simple( self:GetEndTime(), GLMVS_EndVote )
end

GLoader.RegisterGamemode( GAME )