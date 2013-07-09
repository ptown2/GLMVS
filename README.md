GLMVS
=========

GLMVS stands for Globalized Map Voting System, a globalized map voting system add-on that supports multiple gamemodes at once. Modular coded to ensure easy modding and contributions for everyone.

#### SUPPORTED GAMEMODES: ####
* [Zombie Survival](http://facepunch.com/showthread.php?t=1160198) by [JetBoom](http://steamcommunity.com/profiles/76561197966880749) - (Tested and Fully Working)
* [Zombie Escape](http://facepunch.com/showthread.php?t=1187359) by [Samuel Maddock](http://steamcommunity.com/profiles/76561197991989781) - (Untested)
* [The Stalker](http://www.facepunch.com/showthread.php?t=1218503) by [Twoski](http://steamcommunity.com/profiles/76561197994990341) - (Barely, requires a hook to work. Need to talk Twoski about it!)
* [Trouble in Terrorist Town](http://ttt.badking.net/) by [BadKingUrgrain](http://steamcommunity.com/profiles/76561197964193008) - (Untested)

#### UPCOMING GAMEMODE SUPPORTS: ####
* Extreme Football Throwdown - (Maybe, if the fretta map voting doesn't come up for that gamemode.)
* Ultimate Chimera Hunt - (Need to talk Schythed about it!)

and many more soon! (Have one? REQUEST IT!)

#### CONVARS: ####
* `glmvs_svotepower` `0 - INF (int)` The starting votepower for the players (Default is 2).
* `glmvs_mvotepower` `more than glmvs_svotepower - INF (int)` The maximum votepower for the players, prevents taking complete control of the votemap. This convar is supposed to be higher than the starting votepower. (Default is 100).
* `glmvs_maplockthreshold` `0 - 1 (float)` The percentage of maps required to be locked (Default is 0.7).
* `glmvs_votedelay` `0 - INF (int/float)` The wait-time in seconds for the next vote to be produced. Place 0 or -1 to disable (Default is 2).
* `glmvs_notifyupdates` `0 - 1 (bool int)` Toggles the update notification (To players, doesn't disable for server console. Default is 1).
* `glmvs_optoutlist` `0 - 1 (bool int)` Opt-outs the GLMVS Server Listing (Sends the server info to the list. Default is 0).

#### UPDATE NOTIFICATOR: ####
GLMVS will notify the players about a new update in roll (anyone who's mentioned in the NotifyUsergroups) periodically. It captures the versioning within this github page and compares it with the one you've installed. It would be perfect not to modify the GLMVS module due to that reason. If the update notificator is too annoying, then you can disable the notification for players via the convar `glmvs_notifyupdate 0`. REMEMBER, it only disables the notification for the players, not for the server!

#### SERVER LISTING: ####
GLMVS will update/list your server upon every map change (soon to be daily or so). You can opt-out via the convar `glmvs_optoutlist 1`, but leaving it opt-in would help me keep stats/control of my addon. However, GLMVS will NOT SEND crucial server information. It will only send the following information:
* GLMVS Version
* Enviroment Realm (IP, without port)
* Server's Current Gamemode
* Server's Name
* Is it Dedicated?
* Is it Passworded?

If it captures information beyond that point, please notify me (ptown2) so I can thoroughly investigate.

#### CONTRIBUTIONS/DEVELOPMENT: ####
A working dev branch will come out soon. Hold on until further updates. You can still contribute to the addon by helping on the github wiki for function documentation and such.

#### NOTICES: ####
This add-on is still in under-development, any changes are very crucial and demanding. Make sure to be updated at all costs!