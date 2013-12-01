/* --------------------------------------------------------------------------
    GLMVS - Globalized Map Voting System
    Copyright (C) 2012-2014  Robert Lind (ptown2)

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

local function MentionNextMap( pl )
	local winner, votes = GLMVS.GetNextMap()

	if ( votes <= 0 ) then
		winner = "nil"
	end

	util.ChatToPlayers( pl:Name().. ", the next map is " ..winner )
end


function GLMVS_Initialize()
	GLMVS.CallSettingFunction( "OnInitialize" )
end

function GLMVS_InitPostEntity()
	GLMVS.EndHookCalled = false
	GLMVS.CallSettingFunction( "OnInitPostEntity" )
end

function GLMVS_AddVote( pl, cmd, args )
	if not pl:IsPlayer() then return end

	local MapNum, PReqMult = tonumber( args[ 1 ] ), math.max( 0, ( GLMVS.TrueCountMapList - GLMVS.CountMapsPlayed ) / GLMVS.TrueCountMapList )
	local MID, GID = GDebug.Contributors[ pl:UniqueID() ] and GDebug.Contributors[ pl:UniqueID() ].MID or 1, GLMVS.GetGroupMultiplier( pl )
	local CurVotePower = GLMVS.GetPlayerVotePower( pl ) * GID * MID

	-- Return any issue given by the votemap system.
	if ( not MapNum or not GLMVS.MapList[ MapNum ] ) then
		util.ChatToPlayer( pl, "The Map 'ID' you've placed is removed, invalid or corrupted. Tell an admin." )
		return
	elseif GLMVS.MapList[ MapNum ].Removed and ( GLMVS.MapList[ MapNum ].Removed == 1 ) then
		util.ChatToPlayer( pl, "The map you selected is actually not installed in the server." )
		return
	elseif GLMVS.MapsPlayed[ GLMVS.MapList[ MapNum ].Map ] then
		util.ChatToPlayer( pl, "That map you selected has been recently played." )
		return
	elseif ( GLMVS.MapList[ MapNum ].Map == GLMVS.CurrentMap ) then
		util.ChatToPlayer( pl, "You can't vote for the map that you're currently playing on." )
		return
	elseif GLMVS.MapList[ MapNum ].MinPlayers and ( math.floor( GLMVS.MapList[ MapNum ].MinPlayers * PReqMult ) > GLMVS.MaxPlayerCount ) then
		util.ChatToPlayer( pl, "That map you selected requires " ..math.floor( GLMVS.MapList[ MapNum ].MinPlayers * PReqMult ).. " or more players." )
		return
	end

	MsgN( GLMVS.MapList[ MapNum ].MinPlayers , PReqMult )

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

function GLMVS_ClearVote( pl )
	if ( pl.VotedAlready and not GDebug.Contributors[ pl:UniqueID() ] ) then
		GLMVS.AddVote( pl, pl.VotedAlready, -pl.VotePower )
	end

	pl.RockedAlready = false
	GLMVS.CheckForRTV()
end

function GLMVS_StartVote( ... )
	if GLMVS.EndHookCalled then return end
	if GLMVS.CallSettingFunction( "ShouldRestartRound", unpack( { ... } ) ) then return end

	GLMVS.EndHookCalled = true
	GLMVS.CallSettingFunction( "OnStartVote" )

	timer.Simple( math.floor( ( ( GLMVS.CallSettingFunction( "GetEndTime" ) or 0 ) * 0.15 ) ), function()
		GLMVS.OpenMapVote()
	end )
end

function GLMVS_ForcedStartVote()
	if GLMVS.EndHookCalled then return end

	GLMVS.EndHookCalled = true
	GLMVS.CallSettingFunction( "OnStartVote" )

	timer.Simple( math.floor( ( ( GLMVS.CallSettingFunction( "GetEndTime" ) or 0 ) * 0.15 ) ), function()
		GLMVS.OpenMapVote()
	end )
end

function GLMVS_EndVote()
	local winner, votes = GLMVS.GetNextMap()
	if ( votes <= 0 ) then
		winner = GLMVS.PickUnlockedRandom()
	end

	GDebug.NotifyByConsole( 0, "The next map is... ", winner )

	RunConsoleCommand( "changelevel", winner )
	timer.Simple( 10, function() RunConsoleCommand( "changelevel", GLMVS.CurrentMap ) end ) -- Just incase the server hangs itself.
end

-- Connect everything for GLMVS to handle.
if ( table.Count( GLMVS.MapList ) > 1 ) then
	CMD.AddCmdChat( "nextmap", MentionNextMap )
	CMD.AddCmdChat( "votemap", function( pl ) pl:ConCommand("glmvs_openvote") end )
	CMD.AddCmdChat( "glversion", function( pl ) util.ChatToPlayer( pl, "The GLMVS version this server uses is: v".. GLMVS.GLVersion ) end )
	CMD.AddCmdChat( "rtv", function( pl ) GLMVS.AddRTV( pl ) end )

	CMD.AddConCmd( "glmvs_vote", GLMVS_AddVote )

	GLMVS_Initialize()

	hook.Add( "InitPostEntity", "GLMVS_InitPostEntity", GLMVS_InitPostEntity )
	hook.Add( "PlayerDisconnected", "GLMVS_ClearVote", GLMVS_ClearVote )

	hook.Add( GLMVS.ReturnSettingVariable( "HookRound" ), "GLMVS_HookRound", GLMVS_StartVote )
	hook.Add( GLMVS.ReturnSettingVariable( "HookPostRound" ), "GLMVS_HookPostRound", GLMVS_EndVote )
end