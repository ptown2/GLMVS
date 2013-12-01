local GAME = {}

GAME.ID			= "stopitslender"
GAME.Name		= "Stop it Slender"
GAME.MapPrefix	= {"slender", "ttt", "zs"}
GAME.MapFileDB	= "map_slender.txt"

function GAME:OnInitialize()
	local plmeta = FindMetaTable( "Player" )

	if plmeta then
		function plmeta:UseRTV() GLMVS.AddRTV( self ) end
	end
end

function GAME:GetEndTime()
	return 30
end

function GAME:OnStartVote()
	timer.Simple( self:GetEndTime(), GLMVS_EndVote )
end

GLoader.RegisterGamemode( GAME )