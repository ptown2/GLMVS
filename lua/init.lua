/* --------------------------------------------------------------------------
    GLMVS - Globalized Map Voting System
    Copyright (C) 2012  Robert Lind (ptown2)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
-------------------------------------------------------------------------- */

local function Initialize()
	util.ValidFunction( CurGamemode, "OnInitialize" )
end

local function AddVote( pl, cmd, args )
	local MapNum = tonumber( args[ 1 ] )
	local MID = Debug.Contributors[ pl:UniqueID() ] && Debug.Contributors[ pl:UniqueID() ].MID || 1
	local CurVotePower = GLMVS.GetPlayerVotePower( pl ) * MID

	if ( !MapNum || !GLMVS.Maplist[ MapNum ] ) then
		pl:PrintMessage( HUD_PRINTTALK, "The Map 'ID' you've placed is removed, invalid or corrupted. Tell an admin." )
		return
	elseif table.HasValue( GLMVS.MapsPlayed, GLMVS.Maplist[ MapNum ].Map ) then
		pl:PrintMessage( HUD_PRINTTALK, "That map you selected has been recently played." )
		return
	elseif ( GLMVS.Maplist[ MapNum ].Map == GLMVS.CurrentMap ) then
		pl:PrintMessage( HUD_PRINTTALK, "You cannot vote for the map that you're currently playing on." )
		return
	elseif ( GLMVS.Maplist[ MapNum ].MinPlayers && ( GLMVS.Maplist[ MapNum ].MinPlayers > GLMVS.MaxPlayerCount ) ) then
		pl:PrintMessage( HUD_PRINTTALK, "That map you selected requires " ..GLMVS.Maplist[ MapNum ].MinPlayers.. " or more players." )
		return
	end

	if ( pl.VotedAlready == MapNum ) then
		if ( CurVotePower > pl.VotePower ) then
			local PowerUpdate = math.abs( CurVotePower - pl.VotePower )
			GLMVS.AddVote( pl, pl.VotedAlready, PowerUpdate )
		end
		return
	end

	if pl.VotedAlready then
		GLMVS.AddVote( pl, pl.VotedAlready, -pl.VotePower )
	end

	GLMVS.AddVote( pl, MapNum, CurVotePower )

	local MapName = GLMVS.Maplist[ MapNum ].Name || GLMVS.Maplist[ MapNum ].Map
	util.ChattoPlayers( pl:Name().. " has voted " ..MapName.. " for " ..CurVotePower.. " votepoints." )
end

local function ClearVote( pl )
	if pl.VotedAlready then
		GLMVS.AddVote( pl, pl.VotedAlready, -pl.VotePower )
	end
end

local function StartVote()
	local CurGamemode = GLMVS.ReturnCurGamemode()

	if ( util.ValidFunction( CurGamemode, "ShouldRestartRound" ) || false ) then return end

	timer.Simple( math.floor( ( ( util.ValidFunction( CurGamemode, "GetEndTime" ) || 0 ) * 0.15 ) ), function()
		util.ValidFunction( CurGamemode, "OnStartVote" )
		GLMVS.OpenMapVote()
	end )
end

local function EndVote()
	local CurGamemode = GLMVS.ReturnCurGamemode()

	if !( util.ValidFunction( CurGamemode, "ShouldChangeMap" ) || true ) then return end

	local winner, votes = GLMVS.GetNextMap()
	if ( votes <= 0 ) then
		winner = GLMVS.PickUnlockedRandom()
	end

	--GLMVS.AddToRecentMaps( GLMVS.CurrentMap )

	MsgN( "The next map is... ", winner )
	RunConsoleCommand( "changelevel", winner )
	timer.Simple( 5, function() RunConsoleCommand( "changelevel", GLMVS.CurrentMap ) end )

	return true
end

-- Connect everything for GLMVS to handle.
hook.Add( "InitPostEntity", "AddGMHooks", function()
	local CurGamemode = GLMVS.ReturnCurGamemode()

	if ( #GLMVS.Maplist > 0 ) then
		concommand.Add( "glmvs_vote", AddVote )

		hook.Add( "Initialize", "GLMVSHookInit", Initialize )
		hook.Add( "PlayerDisconnected", "GLMVSClearVote", ClearVote )

		hook.Add( util.ValidVariable( CurGamemode, "HookEnd" ), "GLMVSHookStart", StartVote )
		hook.Add( util.ValidVariable( CurGamemode, "HookMap" ), "GLMVSHookEnd", EndVote )
	end
end )