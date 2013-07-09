--[[
GLMVS uses this following gamemode map setting layout to make it work on the votemap system.
Once the file is in place it will load the file automatically.
Just make sure every info is CORRECT and that you do not place gramatical errors. Every entry is case-sensitive.
Please make sure you know some of the LUA coding basics, it is a total requirement when dealing with this addon.

If you don't know how to edit this properly, contact ptown2 (Lead Developer) anytime, he'll do it for you.

CAREFUL WHEN ADDING SOMETING, DO SOMETHING WRONG AND IT MIGHT NOT LOAD!
]]--

local GAME = {}

GAME.ID = ""							-- Gamemode's Folder ID, edited gamemodes (like TTT, redonettt or ttt_modified) will use the GAMEMODE.Name instead.
GAME.Name = ""							-- Gamemode's Name (You can get it from GM.Name or GAMEMODE.Name)
GAME.MapPrefix = {""}					-- Map prefixes
GAME.MapFileDB = "mapcycle_*.txt"		-- Map cycle (Replace * with the gamemode's shorter name)


-- Hooks
GAME.HookEnd = ""						-- Round End hook
GAME.HookMap = ""						-- Round Start or Map Load hook ( not game.LoadNextMap() )


-- NOTE: Useful for getting convars
-- RETURN: Anything
function GAME:OnInitialize()
	-- What you should do when the votemap initalizes. Skips when the function is ignored.
end


-- NOTE: Recommended only for TTT or to make the gamemode delay the round end time.
-- RETURN: Anything
function GAME:OnStartVote()
	-- What you should do when the votemap opens. Skips when the function is ignored.
end


-- NOTE: Use this to get the time left for the next round or next map.
-- RETURN: Integer
function GAME:GetEndTime()
	-- How long is the wait? Returns 0 when the function is ignored
end


-- NOTE: Recommended only for TTT or for gamemodes who use game states (ex. wait, preparing, playing, end, etc.)
-- RETURN: Boolean
function GAME:ShouldChangeMap()
	-- Should the votemap instantly change map when it begins the next round? Skips when the function is ignored.
end


-- NOTE: Use this only when the gamemode supports overriding the mapcycle system and does everything above like the three functions.
-- RETURN: Boolean or Inversed ShouldChangeMap Boolean
function GAME:ShouldRestartRound()
	-- Should the votemap not open when the round is resetting? Skips when the function is ignored.
end


-- NOTE: Use this to count the votepower to the player. Depends on what you calculate.
-- RETURN: Integer
function GAME:GetPlayerVote(pl)
	-- Just make sure it returns the math. Returns 0 when the function is ignored.
end

-- Leave this line alone
GLoader.RegisterGamemode( GAME )