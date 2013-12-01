local GAME = {}

GAME.ID			= "pirateshipwars"
GAME.Name		= "Pirate Ship Wars"
GAME.MapPrefix	= {"psw"}
GAME.MapFileDB	= "map_psw.txt"

function GAME:OnInitialize()
	function UMS_MapCycle.DoNextMap() GLMVS_StartVote() end
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