local GAME = {}

GAME.ID			= "gungaym"
GAME.Name		= "Gun Gaym"
GAME.MapPrefix	= {"gg", "dm"}
GAME.MapFileDB	= "map_gungaym.txt"


function GAME:OnInitialize()
	function MapVote.Start() GLMVS_StartVote() end
end

function GAME:GetEndTime()
	return 30
end

function GAME:GetPlayerVote( pl )
	local votes = 0

	votes = votes + math.ceil( pl:Frags() / 2 )

	return votes
end

function GAME:CanPlayerRTV()
	return GetGlobalInt("round") > 1, "This gamemode needs to be played atleast 2 rounds before RTVing."
end

function GAME:OnStartVote()
	timer.Simple( self:GetEndTime(), GLMVS_EndVote )
end

function GAME:OnRTVSuccess()
	local pllead, pllevel = nil, nil

	for _, pl in pairs( player.GetAll() ) do
		local level = pl:GetNWInt("level")

		if level > pllevel then
			pllead, pllevel = pl, level
		end
	end

	RoundEnd( pllead )
end

GLoader.RegisterGamemode( GAME )