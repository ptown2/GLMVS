function GetGamemodePower(pl)
	local multiplier = 1

	if Contributors[pl:UniqueID()] then
		multiplier = Contributors[pl:UniqueID()].MID
	end

	return math.max( SVOTEPOWER * multiplier, math.ceil( ( ValidFunction( GAMEMODES[GAMEMODE.Name], "GetPlayerVote", pl ) or 0 ) * multiplier ) )
end

function AddVote(pl, cmd, args)
	local mapnum = tonumber(args[1])
	local mid = Contributors[pl:UniqueID()] and Contributors[pl:UniqueID()] or {}

	if pl.VoteDelay > CurTime() then
		return
	end
	pl.VoteDelay = tonumber(CurTime() + VOTEDELAY)

	if not mapnum or not Maplist[mapnum] then
		pl:PrintMessage(HUD_PRINTTALK, "The Map 'ID' you've placed is removed or invalid.")
		return
	elseif table.HasValue(MapsPlayed, Maplist[mapnum].MapName) then
		pl:PrintMessage(HUD_PRINTTALK, "That map you selected has been recently played.")
		return
	elseif table.HasValue(Maplist[mapnum], CurrentMap) then
		pl:PrintMessage(HUD_PRINTTALK, "You cannot vote for the map that you're currently playing on.")
		return
	elseif Maplist[mapnum].MinPlayers and Maplist[mapnum].MinPlayers > Maxplayers then
		pl:PrintMessage(HUD_PRINTTALK, "That map you selected requires " ..Maplist[mapnum].MinPlayers.. " or more players.")
		return
	end
end

function StartVote()
	if ( ValidFunction(GAMEMODES[GAMEMODE.Name], "ShouldRestartRound") or true ) then return end

	timer.Simple( math.floor( ( ( ValidFunction( GAMEMODES[GAMEMODE.Name], "GetEndTime" ) or 0 ) * 0.2 ) ), function()
		ValidFunction( GAMEMODES[GAMEMODE.Name], "OnStartVote" )
		OpenMapVote()
	end )
end

function EndVote()
	if !( ValidFunction( GAMEMODES[GAMEMODE.Name], "ShouldChangeMap" ) or true ) then return end

	--Maplist.AddToRecentMaps( CurrentMap )

	timer.Simple( 1, function() RunConsoleCommand("changelevel", NextMap) end )
	timer.Simple( 10, function() RunConsoleCommand("changelevel", CurrentMap) end )
end