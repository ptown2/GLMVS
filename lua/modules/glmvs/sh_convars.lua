module( "GLMVS", package.seeall )

/* ----------------------------------------
	Floats
---------------------------------------- */
MapLockThreshold = CreateConVar( "glmvs_maplockthreshold", 0.7, FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Percentage number of maps that required to be played until list refresh." ):GetFloat()
cvars.AddChangeCallback( "glmvs_maplockthreshold", function( cvar, oldvalue, newvalue )
	MapLockThreshold = math.Clamp( tonumber( newvalue ) or 0, 0, 1 )
end )

RTVThreshold = CreateConVar( "glmvs_rtvthreshold", 0.75, FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Percentage number of players required to end the game and run RTV." ):GetFloat()
cvars.AddChangeCallback( "glmvs_rtvthreshold", function( cvar, oldvalue, newvalue )
	RTVThreshold = math.Clamp( tonumber( newvalue ) or 0, 0, 1 )
end )


/* ----------------------------------------
	Integers
---------------------------------------- */
SVotePower = CreateConVar( "glmvs_svotepower", 2, FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Minimum vote power for the players." ):GetInt()
cvars.AddChangeCallback( "glmvs_svotepower", function( cvar, oldvalue, newvalue )
	SVotePower = math.Clamp( math.floor( tonumber( newvalue ) or 1 ), 1, math.huge )
end )

MVotePower = CreateConVar( "glmvs_mvotepower", 500, FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Maximum vote power for the players. Set -1 or 0 to disable." ):GetInt()
cvars.AddChangeCallback( "glmvs_mvotepower", function( cvar, oldvalue, newvalue )
	MVotePower = math.Clamp( math.floor( tonumber( newvalue ) or 1 ), -1, math.huge )
end )

VoteDelay = CreateConVar( "glmvs_votedelay", 2, FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Vote delay between votes made by the player, to prevent spam (In seconds)." ):GetInt()
cvars.AddChangeCallback( "glmvs_votedelay", function( cvar, oldvalue, newvalue )
	VoteDelay = math.Clamp( math.floor( tonumber( newvalue ) or 1 ), -1, math.huge )
end )

RTVWaitTime = CreateConVar( "glmvs_rtvtimelimit", 15, FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Time to wait (from server start) until a RTV can be made. (In minutes)" ):GetInt()
cvars.AddChangeCallback( "glmvs_rtvtimelimit", function( cvar, oldvalue, newvalue )
	RTVWaitTime = math.Clamp( math.floor( tonumber( newvalue ) or 15 ), -1, math.huge )
end )

RTVPlayerREQ = CreateConVar( "glmvs_rtvplayerreq", 6, FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Number requirement of players in server needed before using the RTV." ):GetInt()
cvars.AddChangeCallback( "glmvs_rtvplayerreq", function( cvar, oldvalue, newvalue )
	RTVPlayerREQ = math.Clamp( math.floor( tonumber( newvalue ) or 1 ), 0, 128 )
end )

/* ----------------------------------------
	Boolean
---------------------------------------- */
NotifyForUpdates = CreateConVar( "glmvs_notifyupdates", 1, FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Notifies THE PLAYERS that there is a new version." ):GetBool()
cvars.AddChangeCallback( "glmvs_notifyupdates", function( cvar, oldvalue, newvalue )
	NotifyForUpdates = math.Clamp( tonumber( newvalue ) or 1, 0, 1 )
end )

OptOutListing = CreateConVar( "glmvs_optoutlist", 0, FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Opts you out of the GLMVS Server Listing feature." ):GetBool()
cvars.AddChangeCallback( "glmvs_optoutlist", function( cvar, oldvalue, newvalue )
	OptOutListing = math.Clamp( tonumber( newvalue ) or 0, 0, 1 )
end )

AllowNonGMRelatedMaps = CreateConVar( "glmvs_allowallmaps", 0, FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Sets to allow add every non-gamemode related maps if mentioned in the list." ):GetBool()
cvars.AddChangeCallback( "glmvs_allowallmaps", function( cvar, oldvalue, newvalue )
	AllowNonGMRelatedMaps = math.Clamp( tonumber( newvalue ) or 0, 0, 1 )
end )

RTVMode = CreateConVar( "glmvs_enablertv", 0, FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Enables the RTV feature if you want it for the server." ):GetBool()
cvars.AddChangeCallback( "glmvs_enablertv", function( cvar, oldvalue, newvalue )
	RTVMode = math.Clamp( tonumber( newvalue ) or 0, 0, 1 )
end )

FrettaMode = CreateConVar( "glmvs_frettamode", 0, FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Sets GLMVS as if it was a Fretta Gamemode. NOT DONE AND NOT WORKING!  Maybe will be not done." ):GetBool()
cvars.AddChangeCallback( "glmvs_frettamode", function( cvar, oldvalue, newvalue )
	FrettaMode = math.Clamp( tonumber( newvalue ) or 0, 0, 1 )
end )


/* ----------------------------------------
	Client ConVar Options
---------------------------------------- */
if CLIENT then
	ShowMapImages = CreateClientConVar( "glmvs_showmapimg", 1, true, true ):GetBool()
	cvars.AddChangeCallback( "glmvs_showmapimg", function( cvar, oldvalue, newvalue )
		ShowMapImages = math.Clamp( tonumber( newvalue ) or 0, 0, 1 )
	end )
end