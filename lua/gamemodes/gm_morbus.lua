local GAME = {}

GAME.ID			= "morbus"
GAME.Name		= "MORBUS"
GAME.MapPrefix	= {"mor", "para"}
GAME.MapFileDB	= "map_morbus.txt"

GAME.HookRound	= "Morbus_MapChange"

GAME.PostTime = GetConVar("morbus_round_post") and GetConVar("morbus_round_post"):GetInt() or 30
function GAME:OnInitialize()
	self.PostTime = GetConVar("morbus_round_post"):GetInt() or 30

	function RTV() return end
	function SMV.StartVote() return end
end

function GAME:GetEndTime()
	return self.PostTime
end

function GAME:GetPlayerVote( pl )
	return math.ceil( pl:Frags() / 5 )
end

function GAME:OnStartVote()
	SetRoundEnd( CurTime() + self.PostTime + 15 )
	timer.Simple( self:GetEndTime(), GLMVS_EndVote )
end

GLoader.RegisterGamemode( GAME )