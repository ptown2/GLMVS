local GAME = {}

GAME.ID			= "ultimatechimerahunt"
GAME.Name		= "Ultimate Chimera Hunt"
GAME.MapPrefix	= {"uch"}
GAME.MapFileDB	= "map_uch.txt"

function GAME:OnInitialize()
	function StartMapVote() GLMVS_StartVote() end
end

function GAME:GetEndTime()
	return 30
end

function GAME:GetPlayerVote( pl )
	return pl:Frags()
end

function GAME:OnStartVote()
	timer.Simple( self:GetEndTime(), GLMVS_EndVote )
end

GLoader.RegisterGamemode( GAME )