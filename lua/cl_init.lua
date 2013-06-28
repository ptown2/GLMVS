local VoteFrame = nil

local function CreateFonts()
	surface.CreateFont( "VoteTitle", { font = "Bebas Neue", size = util.Sizeto720p( 54, ScrH() ), weight = 500 })
	surface.CreateFont( "VoteCaption", { font = "Bebas Neue", size = util.Sizeto720p( 28, ScrH() ), weight = 500 })
end

-- Sort the map and keep the MapID for the server.
for id, info in pairs( GLMVS.Maplist ) do
	info.ID = id
end

function Derma_Votemap()
	if IsValid( VoteFrame ) then return end

	CreateFonts()

	local w, h = ScrW(), ScrH()
	local imapsize, globalspacing = util.Sizeto720p( 150, h ), util.Sizeto720p( 8, h )
	local numframesw, numframesh = util.LowestSizeMult( w, imapsize ), util.LowestSizeMult( h, imapsize )

	VoteFrame = vgui.Create("DFrame")
	VoteFrame:SetTitle( " " )
	VoteFrame:SetSize( ( numframesw * globalspacing ) + ( numframesw * imapsize ) + 35, ( numframesh * globalspacing ) + ( numframesh * imapsize ) + ( draw.GetFontHeight( "VoteTitle" ) ) + 20 )
	VoteFrame:SetSkin( "zsvotemap" )
	VoteFrame:Center()

	local TitleLabel = vgui.Create( "DLabel", VoteFrame )
	TitleLabel:SetFont( "VoteTitle" )
	TitleLabel:SetColor( color_white )
	TitleLabel:SetText( "Vote for a map!" )
	TitleLabel:SizeToContents()
	TitleLabel:CenterHorizontal()
	TitleLabel:AlignTop( 10 )

	local ScrlFrame = vgui.Create( "DScrollPanel", VoteFrame )
	ScrlFrame:SetSize( ( numframesw * globalspacing ) + ( numframesw * imapsize ) - globalspacing, ( numframesh * globalspacing ) + ( numframesh * imapsize ) - 3 )
	ScrlFrame:CenterHorizontal()
	ScrlFrame:AlignBottom( 10 )

	local ListFrame = vgui.Create( "DIconLayout", ScrlFrame )
	ListFrame:SetSize( ScrlFrame:GetWide(), ScrlFrame:GetTall() )
	ListFrame:SetSpaceX( globalspacing )
	ListFrame:SetSpaceY( globalspacing )

	table.sort( GLMVS.Maplist, GLMVS.SortMaps )

	for id, info in pairs( GLMVS.Maplist ) do
		local ListItem = ListFrame:Add( "DButton" )
		ListItem:SetSize( imapsize, imapsize )
		ListItem:SetText( " " )
		ListItem:SetDisabled( tobool( info.Locked ) )
		ListItem.MapName = info.Name || info.Map
		ListItem.ID = id
		ListItem.MapID = info.ID
		ListItem.Image = util.IsValidImage( info.Map )
		ListItem.Paint = GLMVS.GenericImgButton
		ListItem.DoClick = GLMVS.Votemap
	end

	VoteFrame:MakePopup()
end

concommand.Add( "glmvs_openvote", Derma_Votemap )