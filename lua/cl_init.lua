local VoteFrame = nil

local texCorner = surface.GetTextureID("zombiesurvival/circlegradient")
local texUpEdge = surface.GetTextureID("gui/gradient_up")
local texDownEdge = surface.GetTextureID("gui/gradient_down")
local texRightEdge = surface.GetTextureID("gui/gradient")

local function LowestSizeMult( factor, size )
	return math.floor( ( factor / size ) - 1 )
end

local function Sizeto720p( size, src )
	return math.floor( size * ( src / 720 ) )
end

local function CreateFonts()
	surface.CreateFont( "VoteTitle" , { font = "Bebas Neue", size = Sizeto720p( 54, ScrH() ), weight = 1000 })
end

local function GenericImgButton( self )
	local c, alpha = Color( 255, 255, 0, 255 ), 255

	if ( self.Hovered ) then
		alpha = 205

		if ( self.Depressed ) then
			c = Color( 255, 0, 0, 255 )
		end

		surface.SetDrawColor( Color( c.r, c.g, c.b, alpha ) )
		surface.SetMaterial( Material( self.Image, "alphatest" ) )
		surface.DrawTexturedRect( 0, 0, self:GetWide() - 0 , self:GetTall() - 0 )
	end

	local c = color_white
	surface.SetDrawColor( Color( c.r, c.g, c.b, alpha ) )
	surface.SetMaterial( Material( self.Image, "smooth mips" ) )
	surface.DrawTexturedRect( 3, 3, self:GetWide() - 6 , self:GetTall() - 6 )
end

function Derma_Votemap()
	if IsValid( VoteFrame ) then return end

	CreateFonts()

	local w, h = ScrW(), ScrH()
	local imapsize, globalspacing = Sizeto720p( 150, h ), Sizeto720p( 8, h )
	local numframesw, numframesh = LowestSizeMult( w, imapsize ), LowestSizeMult( h, imapsize )

	VoteFrame = vgui.Create("DFrame")
	VoteFrame:SetTitle( " " )
	VoteFrame:SetSize( ( numframesw * globalspacing ) + ( numframesw * imapsize ) + 35, ( numframesh * globalspacing ) + ( numframesh * imapsize ) + ( draw.GetFontHeight( "VoteTitle" ) ) + 20 )
	VoteFrame:SetSkin( "zsvotemap" )
	VoteFrame:SetPaintShadow( color_black )
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

	for _, info in pairs( GLMVS.Maplist ) do
		local ListItem = ListFrame:Add( "DButton" )
		ListItem:SetSize( imapsize, imapsize )
		ListItem:SetText( " " )
		ListItem.Image = "../maps/" .. info.Map .. ".png"
		ListItem.Paint = GenericImgButton
	end

	VoteFrame:MakePopup()
end