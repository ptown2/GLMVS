module( "GLMVS", package.seeall )

MapLockThreshold = math.floor(100 * CreateConVar("glmvs_maplockthreshold", "0.7", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Percentage number of maps that required to be played until list refresh."):GetFloat()) * 0.01
cvars.AddChangeCallback("glmvs_maplockthreshold", function(cvar, oldvalue, newvalue)
	MapLockThreshold = math.Clamp(math.floor(100 * (tonumber(newvalue) or 1)) * 0.01, 0.01, 0.99)
end)

SVotePower = CreateConVar("glmvs_svotepower", 2, FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Minimum vote power for the players."):GetInt()
cvars.AddChangeCallback("glmvs_svotepower", function(cvar, oldvalue, newvalue)
	SVotePower = tonumber(newvalue)
end)

MVotePower = CreateConVar("glmvs_mvotepower", 100, FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Maximum vote power for the players. Set -1 or 0 to disable."):GetInt()
cvars.AddChangeCallback("glmvs_mvotepower", function(cvar, oldvalue, newvalue)
	MVotePower = tonumber(newvalue)
end)

VoteDelay = CreateConVar("glmvs_votedelay", 2, FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Vote delay between votes made by the player, to prevent spam (in seconds)."):GetInt()
cvars.AddChangeCallback("glmvs_votedelay", function(cvar, oldvalue, newvalue)
	VoteDelay = tonumber(newvalue)
end)