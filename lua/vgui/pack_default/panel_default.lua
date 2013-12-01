local VoteFrame = nil
local fontheight, subfontheight = util.SizeTo720p( 54, ScrH() ), util.SizeTo720p( 26, ScrH() )

surface.CreateFont( "VoteTitle", { font = "Bebas Neue", size = fontheight, weight = 500 })
surface.CreateFont( "VoteCaption", { font = "Bebas Neue", size = subfontheight, weight = 500 })

function GLMVS_VoteMap_Menu()
	if IsValid( VoteFrame ) then return end

	local w, h = ScrW(), ScrH()
	local imapsize, globalspacing = util.SizeTo720p( 150, h ), util.SizeTo720p( 8, h )
	local framesw, framesh = util.LowestSizeMult( w, imapsize ) * ( globalspacing + imapsize ), util.LowestSizeMult( h, imapsize ) * ( globalspacing + imapsize )

	VoteFrame = vgui.Create("DFrame")
	VoteFrame:SetTitle( " " )
	VoteFrame:SetSize( framesw + 35, framesh + fontheight + 20 )
	VoteFrame:SetSkin( "GSkin_Default" )
	VoteFrame:Center()

	local TitleLabel = vgui.Create( "DLabel", VoteFrame )
	TitleLabel:SetFont( "VoteTitle" )
	TitleLabel:SetColor( color_white )
	TitleLabel:SetText( "Vote for a map!" )
	TitleLabel:SizeToContents()
	TitleLabel:CenterHorizontal()
	TitleLabel:AlignTop( 10 )

	local ScrlFrame = vgui.Create( "DScrollPanel", VoteFrame )
	ScrlFrame:SetSize( framesw + 12, framesh - 3 )
	ScrlFrame:CenterHorizontal()
	ScrlFrame:AlignBottom( 8 )

	local ListFrame = vgui.Create( "DIconLayout", ScrlFrame )
	ListFrame:SetSize( ScrlFrame:GetWide(), ScrlFrame:GetTall() )
	ListFrame:SetSpaceX( globalspacing )
	ListFrame:SetSpaceY( globalspacing )

	for mapid, info in ipairs( GLMVS.MapList ) do
		if not tobool( info.Removed ) then
			local ListItem = ListFrame:Add( "DMapButton" )
			ListItem:SetImageSize( imapsize )
			ListItem:SetMapData( mapid, info )
		end
	end

	VoteFrame:MakePopup()
end