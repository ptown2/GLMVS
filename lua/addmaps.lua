/* ----------------------------------------------------------------------------------------
	GLMVS - Map Adding System

	This file is to add the maps you're registering for the server,
	it uses a super easy format for everyone to follow and contribute for
	GLMVS. It is undesirable to add maps anyone will barely play on.
	But you can add as many as you please (until lua hangs itself).

	Format to add maps in the library:
	GLMVS.AddMap( mapname, playerreq )

	Example:
	GLMVS.AddToLibrary( "zs_relic" )
	GLMVS.AddToLibrary( "zs_asylum_v1", 8 )

	NOTES:
	The map MUST exist on the server, if not then it will be ignored.
	Duplicates of same map are also ignored.
	Non-GM related maps are also ignored.

	Playerreq is the MINIMUM AMOUNT of players required to play on that map.
	It is advised NOT TO DO THIS ON ALL MAPS!!!
---------------------------------------------------------------------------------------- */

-- Use this as example.
GLMVS.AddMap( "ze_minecraft_v1_1" )
GLMVS.AddMap( "zs_asylum_reborn_b2" )
GLMVS.AddMap( "zs_canyon" )