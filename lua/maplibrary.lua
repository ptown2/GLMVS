/* ----------------------------------------------------------------------------------------
	GLMVS - Map Library System

	This file is to add the library of all the maps you're registering for,
	it uses a super easy format for everyone to follow and contribute for
	GLMVS. It is undesirable to add maps you're not going to use for the library.
	But you can add as many as you please (until lua hangs itself).

	Format to add maps in the library:
	GLMVS.AddToLibrary( mapname, { realname, author, description } )

	Example:
	GLMVS.AddToLibrary( "zs_relic", { "Relic" } )
	GLMVS.AddToLibrary( "gm_construct", { "Construct", "Team Garry", "Basic GMod map" } )

	NOTES:
	The realname IS mandatory, author and description are optional.
	Make sure the 2nd argument for that function is a table with 
	strings inside and that commas are correctly placed.
---------------------------------------------------------------------------------------- */

-- Use this as example.
GLMVS.AddToLibrary( "ze_minecraft_v1_1", 4, { "ZE Minecraft" } )
GLMVS.AddToLibrary( "zs_asylum_reborn_b2", 0, { "Asylum Reborn" } )
GLMVS.AddToLibrary( "zs_canyon", 0, { "Canyon" } )