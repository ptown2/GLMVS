--[[
GLMVS uses this following gamemode map setting layout to make it work on the votemap system.
Once the file is in place it will load the file automatically.
Just make sure every info is CORRECT and that you do not place gramatical errors. Every entry is case-sensitive.
Please make sure you know some of the LUA coding basics, it is a total requirement when dealing with this addon.

If you don't know how to edit this properly, contact ptown2 (Lead Developer) anytime, he'll do it for you.

CAREFUL WHEN ADDING SOMETING, DO SOMETHING WRONG AND IT MIGHT NOT LOAD!
]]--

local GAME = {}


GAME.ID		= ""					-- Gamemode's Folder -Name- ID, edited gamemodes (like TTT, redonettt or ttt_modified) will use the GAMEMODE.Name instead.
GAME.Name	= ""					-- Gamemode's Name (You can get it from GM.Name or GAMEMODE.Name)
GAME.MapPrefix	= {""}					-- Map prefixes
GAME.MapFileDB	= "map_*.txt"				-- Recent Maps Data (Replace * with the Gamemode's ID)


-- Hooks
GAME.HookEnd = ""					-- Round End hook / Load Next Map hook*
GAME.HookMap = ""					-- Load Next Map hook


-- NOTE: Useful for getting convars
-- RETURN: Anything
function GAME:OnInitialize()
	-- What you should do when the votemap initalizes. Skips when the function is ignored.
end


-- NOTE: Use this to get the time left for the next round or next map or w/e.
-- RETURN: Integer
function GAME:GetEndTime()
	-- How long is the wait? Returns 0 when the function is ignored
end


-- NOTE: This is called upon the HookEnd variable you've placed.
-- NOTE 2: Use this only when the gamemode has roundmax and currentround values.
-- NOTE 3: Don't use this if the hook you're using is called to DIRECTLY change the map. Use the HookMap for that hook in specific.
-- RETURN: Boolean
function GAME:ShouldRestartRound()
	-- Should the votemap not open when the round is resetting? Skips when the function is ignored.
end


-- NOTE: Recommended only to use a timer.Simple in order to call GLMVS_EndVote.
-- NOTE 2: Don't use this if the gamemode handles another hook to call when it is time to change map. (Look gm_zs.lua)
function GAME:OnStartVote()
	-- What you should do when the votemap opens. Skips when the function is ignored.
end


-- NOTE: Use this to count the votepower to the player. Depends on what you calculate.
-- RETURN: Integer
function GAME:GetPlayerVote(pl)
	-- Just make sure it returns the math. Returns 0 when the function is ignored.
end


-- Leave this line alone
GLoader.RegisterGamemode( GAME )

/*
	OTHER NOTES:
	* - Only if the gamemode doesn't have RoundEnd hook BUT has a hook to load the next map.
	Requires to modify the setting deeper.
*/
