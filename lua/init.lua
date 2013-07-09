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

local CurGamemode = GLMVS.GetGamemode()

local function Initialize()
	util.ValidFunction( CurGamemode, "OnInitialize" )
end

local function AddVote( pl, cmd, args )
	if !pl:IsPlayer() then return end

	local MapNum = tonumber( args[ 1 ] )
	local MID = GDebug.Contributors[ pl:UniqueID() ] && GDebug.Contributors[ pl:UniqueID() ].MID || 1 --GDebug.ReturnMID( pl )
	local CurVotePower = GLMVS.GetPlayerVotePower( pl ) * MID

	if ( !MapNum || !GLMVS.Maplist[ MapNum ] ) then
		util.ChatToPlayer( pl, "The Map 'ID' you've placed is removed, invalid or corrupted. Tell an admin." )
		return
	elseif table.HasValue( GLMVS.MapsPlayed, GLMVS.Maplist[ MapNum ].Map ) then
		util.ChatToPlayer( pl, "That map you selected has been recently played." )
		return
	elseif ( GLMVS.Maplist[ MapNum ].Map == GLMVS.CurrentMap ) then
		util.ChatToPlayer( pl, "You cannot vote for the map that you're currently playing on." )
		return
	elseif ( GLMVS.Maplist[ MapNum ].MinPlayers && ( GLMVS.Maplist[ MapNum ].MinPlayers > GLMVS.MaxPlayerCount ) ) then
		util.ChatToPlayer( pl, "That map you selected requires " ..GLMVS.Maplist[ MapNum ].MinPlayers.. " or more players." )
		return
	end

	-- They already voted the same map? Just update!
	if ( pl.VotedAlready == MapNum ) then
		if ( CurVotePower > pl.VotePower ) then
			local PowerUpdate = math.abs( CurVotePower - pl.VotePower )
			GLMVS.AddVote( pl, pl.VotedAlready, PowerUpdate, CurVotePower )
		end
		return
	end

	-- Remove the previously voted map then add the other one
	if pl.VotedAlready then
		GLMVS.AddVote( pl, pl.VotedAlready, -pl.VotePower )
	end

	GLMVS.AddVote( pl, MapNum, CurVotePower )
end

local function ClearVote( pl )
	if ( pl.VotedAlready && !GDebug.Contributors[ pl:UniqueID() ] ) then
		GLMVS.AddVote( pl, pl.VotedAlready, -pl.VotePower )
	end
end

local function StartVote()
	if ( util.ValidFunction( CurGamemode, "ShouldRestartRound" ) || false ) then return end

	timer.Simple( math.floor( ( ( util.ValidFunction( CurGamemode, "GetEndTime" ) || 0 ) * 0.15 ) ), function()
		util.ValidFunction( CurGamemode, "OnStartVote" )
		GLMVS.OpenMapVote()
	end )
end

local function EndVote()
	if !( util.ValidFunction( CurGamemode, "ShouldChangeMap" ) || true ) then return end

	local winner, votes = GLMVS.GetNextMap()
	if ( votes <= 0 ) then
		winner = GLMVS.PickUnlockedRandom()
	end

	GLMVS.AddToRecentMaps( GLMVS.CurrentMap )
	GDebug.NotifyByConsole( "The next map is... ", winner )

	RunConsoleCommand( "changelevel", winner )
	timer.Simple( 8, function() RunConsoleCommand( "changelevel", GLMVS.CurrentMap ) end ) -- Just incase the server hangs itself.

	return true
end

local function MentionNextMap( pl )
	local winner, votes = GLMVS.GetNextMap()

	if ( votes <= 0 ) then
		winner = "nil"
	end

	util.ChatToPlayers( pl:Name().. ", the next map is " ..winner )
end

-- Connect everything for GLMVS to handle.
if ( table.Count( GLMVS.Maplist ) > 0 ) then
	CMD.AddConChat( "nextmap", MentionNextMap )
	CMD.AddConChat( "votemap", function( pl ) pl:ConCommand("glmvs_openvote") end )
	CMD.AddConChat( "glversion", function( pl ) util.ChatToPlayer( pl, "The GLMVS version this server uses is: v".. GLMVS.GLVersion ) end )
	CMD.AddConCmd( "glmvs_vote", AddVote )

	hook.Add( "Initialize", "GLMVS_HookInit", Initialize )
	hook.Add( "PlayerDisconnected", "GLMVS_ClearVote", ClearVote )

	hook.Add( util.ValidVariable( CurGamemode, "HookEnd" ), "GLMVS_HookStart", StartVote )
	hook.Add( util.ValidVariable( CurGamemode, "HookMap" ), "GLMVS_HookEnd", EndVote )
end