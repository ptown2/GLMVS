local GAME = {}

GAME.ID			= "sandbox"
GAME.Name		= "Sandbox"
GAME.MapPrefix	= {"gm", "rp"}
GAME.MapFileDB	= "map_sandbox.txt"

function GAME:GetEndTime()
	return 45
end

function GAME:CanPlayerRTV( pl )
	return pl:IsAdmin(), "You need to be admin in order to RTV."
end

function GAME:OnStartVote()
	game.CleanUpMap()
	timer.Simple( self:GetEndTime(), GLMVS_EndVote )
end

GLoader.RegisterGamemode( GAME )