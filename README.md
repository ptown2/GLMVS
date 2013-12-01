GLMVS
=========

GLMVS stands for Globalized Map Voting System, a map voting system add-on that supports multiple gamemodes at once and soon to be an External-Fretta Framework. Modular coded to ensure easy modding and contributions from everyone.


#### SUPPORTED GAMEMODES: ####
* [Zombie Survival](http://facepunch.com/showthread.php?t=1160198) and [Awesome Strike: Source](http://www.facepunch.com/showthread.php?t=1127734) by [JetBoom](http://steamcommunity.com/profiles/76561197966880749)
* [Zombie Escape](http://facepunch.com/showthread.php?t=1187359) by [Samuel Maddock](http://steamcommunity.com/profiles/76561197991989781)
* [The Stalker](http://www.facepunch.com/showthread.php?t=1218503) by [Twoski](http://steamcommunity.com/profiles/76561197994990341)
* [Trouble in Terrorist Town](http://ttt.badking.net/) by [BadKingUrgrain](http://steamcommunity.com/profiles/76561197964193008)

and many other gamemodes.


#### UPCOMING GAMEMODE SUPPORTS: ####
* NONE AS OF NOW!

and many more soon! (Have one? REQUEST IT!)


#### INSTALLING THE ADDON: ####
Simply place GLMVS in your root folder of `garrysmod/addons`. Make sure it's a dedicated server and not your listen/local one. Edit the following files mentioned in the Adding Maps and Adding to Library sections. Carefully read and check that your settings are correct, do not leave out necessary commas out of the functions.


#### CONVARS: ####
* `glmvs_svotepower` `0 - INF (int)` The starting votepower for the players (Default is 2).
* `glmvs_mvotepower` `more than glmvs_svotepower - INF (int)` The maximum votepower for the players, prevents taking complete control of the votemap. This convar is supposed to be higher than the starting votepower. Place 0 or -1 to disable (Default is 100).
* `glmvs_maplockthreshold` `0 - 1 (float)` The percentage of maps required to be locked (Default is 0.7).
* `glmvs_rtvplayerreq` `0 - 128 (int)` The amount of required players before using the RTV (Default is 6).
* `glmvs_rtvthreshold` `0 - 1 (float)` The percentage of players required for RTV to take control (Default is 0.75).
* `glmvs_rtvtimelimit` `0 - INF (int)` Sets the cooldown timelimit before starting a RTV in minutes (Default is 15) .
* `glmvs_votedelay` `0 - INF (int)` The wait-time in seconds for the next vote to be produced. Place 0 or -1 to disable (Default is 2).
* `glmvs_notifyupdates` `0 - 1 (bool int)` Toggles the update notification (To players, doesn't disable for server console. Default is 1).
* `glmvs_optoutlist` `0 - 1 (bool int)` Opt-outs the GLMVS Server Listing (Sends the server info to the list (Default is 0).
* `glmvs_allowallmaps` `0 - 1 (bool int)` Enables GLMVS to allow to add any non-gamemode related maps (Default is 0).
* `glmvs_enablertv` `0 - 1 (bool int)` Enables the RTV Mode on GLMVS (Default is 0).
* `glmvs_frettamode` `0 - 1 (bool int)` Enables the Fretta Mode on GLMVS (Default is 0, NOT DONE YET!).


#### CLIENT CONVARS: ####
* `glmvs_showmapimg` `0 - 1 (bool int)` Shows the map images in the /votemap menu (Default is 1).


#### ADDING MAPS: ####
GLMVS will add maps via the `addmaps.lua` file using the `GLMVS.AddMap` function. This function requires two arguments Map Name (string) and Minimum Player Requirement (integer).

Example:
* `GLMVS.AddMap( "gm_construct" )` - This will add the map `GM_Construct` without minimum player requirement.
* `GLMVS.AddMap( "gm_flatgrass", 2 )` - This will add the map `GM_Flatgrass` with a `2` minimum player requirement. Notice: Setting the player requirement in here will overwrite the requirement mentioned in the library. (Version 1.0.3 and above)

Notes: GLMVS will only add gamemode based maps. Unless you set the convar to allow any maps. (See CONVARS)


#### ADDING TO MAP LIBRARY: ####
GLMVS has a library system to set maps with a custom name, their author and some small description for it. It will be added via the `maplibrary.lua` file using the `GLMVS.AddToLibrary`. This function requires three arguments Map Name (string), Player Requirement (int), and Map Attributions (table). The Map Attributions must be a table within the following order `{ name for map, author, description }` all being strings. If you call this function, you must place the new name for the map or it wont work.

Example:
* `GLMVS.AddToLibrary( "gm_test", 0, {"Test", "Whatever", "A map"} )` - This will set `GM_Test` name to Test with the author as `Whatever` with the description to `A map`.
* `GLMVS.AddToLibrary( "gm_construct", 0, {"Construct", "Facepunch"} )` - This will set `GM_Construct` name to `Construct` with the author as `Facepunch`.
* `GLMVS.AddToLibrary( "gm_flatgrass", {"Flatgrass"} )` - This will set `GM_Flatgrass` name to `Flatgrass`. (This is a fallback for versions 1.0.2.X and lower)

Note: If you don't want to fill it then just set it to nil (without quotes). However a name MUST be placed.


#### ADDING THE MAP IMAGES: ####
GLMVS has an automatic system that it will grab every map image that is added within its maplist then force the client to download them. Simply place your images on the root folder of `garrysmod/maps`. Make sure the images are sized as 150x150, png format and have the same name as the map's name. `gm_flatgrass` would translate the map image to `gm_flatgrass.png`.

Note GLMVS will ignore non-existent map images and will replace it with a missing map icon or simply a grey square.

Note 2: Make sure the images are always lowercase, no matter what.


#### UPDATE NOTIFICATOR: ####
GLMVS will notify the players about a new update in roll (anyone who's mentioned in the NotifyUsergroups) periodically. It captures the versioning within this github page and compares it with the one you've installed. It would be perfect not to modify the GLMVS module due to that reason. If the update notificator is too annoying, then you can disable the notification for players via the convar `glmvs_notifyupdate 0`. REMEMBER, it only disables the notification for the players, not for the server!


#### SERVER LISTING: ####
GLMVS will update/list your server upon every map change (soon to be daily or so). You can opt-out via the convar `glmvs_optoutlist 1`, but leaving it opt-in would help me keep stats/control of my addon. However, GLMVS will NOT SEND crucial server information. It will only send the following information:
* GLMVS Version
* Enviroment Realm (IP and Port, for versions 1.0.2.1 and above. IP only for 1.0.2 and below)
* Server's Current Gamemode
* Server's Name
* Is it Dedicated?
* Is it Passworded?

If it captures information beyond that point, please notify me (ptown2) so I can thoroughly investigate.


#### CONTRIBUTIONS/DEVELOPMENT: ####
You can contribute to the addon by helping on the github wiki for function documentation and such. Try asking in the issues page or in the facepunch thread for more information.


#### NOTICES: ####
This add-on is still in under-development, any changes are very crucial and demanding. Make sure to be updated at all costs!


#### DONATIONS: ####
Wish to give me some beer money? Then click the button below to do so!

[![Donate some beer money!](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=MQ495EBFXKD5Y&lc=US&item_name=GLMVS%20Donations&item_number=GLMVSDonation&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted)