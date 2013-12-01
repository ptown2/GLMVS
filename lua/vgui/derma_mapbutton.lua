local PANEL = {}

function PANEL:Init()
	self:SetText( " " )
end

function PANEL:Think()
	GLMVS.MapList[ self.MapID ].Votes = math.Round( Lerp( FrameTime() * 2, GLMVS.MapList[ self.MapID ].Votes, GLMVS.MapList[ self.MapID ].TotalVotes ), 10 )
end

local lockmat = Material( "icon128/padlock.png", "smooth" )
function PANEL:Paint()
	local isLocked = self:GetDisabled()
	local MapID = self.MapID
	local c, alpha = color_white, 255

	if ( self.Hovered ) then alpha = 185 end
	if ( self.Depressed ) then c = Color( 150, 255, 150 ) end
	if ( isLocked ) then c = Color( 125, 0, 0 ) alpha = 255 end

	if ( self.Image and ( self.Image ~= "null" ) and GLMVS.ShowMapImages ) then
		surface.SetDrawColor( Color( c.r, c.g, c.b, alpha ) )
		surface.SetMaterial( self.Image )
		surface.DrawTexturedRect( 0, 0, self:GetWide() , self:GetTall() )
	else
		surface.SetDrawColor( Color( 190, 190, 190, alpha ) )
		surface.DrawRect( 0, 0, self:GetWide() , self:GetTall() )
	end

	if ( isLocked ) then
		local iconmult = 0.45

		surface.SetDrawColor( color_white )
		surface.SetMaterial( lockmat )
		surface.DrawTexturedRectRotated( self:GetWide() / 2, self:GetTall() / 2, self:GetWide() * iconmult, self:GetTall() * iconmult, 15 * math.sin( CurTime() * 3 ) )
	end

	surface.SetFont( "VoteCaption" )
	local mapname = self.MapName .. ( self.Author and " - BY: " .. self.Author or "" )
	local wid, hei = surface.GetTextSize( mapname )

	surface.SetDrawColor( Color( 0, 0, 0, 235 ) )
	surface.DrawRect( 0, 3, self:GetWide(), hei - 3)
	draw.TickerText( mapname, "VoteCaption", color_white, self.Ticker, self:GetWide() - 4, 15, 1 )

	surface.SetFont( "VoteCaption" )
	local votes = GLMVS.MapList[ MapID ].Votes
	votes = math.Round( votes, 1 ) > 0 and math.Round( votes, 1 )  .. "   (".. math.Round( votes / GLMVS.TotalVotes * 100 ) .."%)" or nil

	if ( votes ) then
		local wid, hei = surface.GetTextSize( votes )

		surface.SetDrawColor( Color( 0, 0, 0, 235 ) )
		surface.DrawRect( self:GetWide() - ( wid + 8 ), self:GetTall() - ( hei - 2 ), ( wid + 8 ), hei - 2)

		surface.SetTextPos( self:GetWide() - ( wid + 4 ), self:GetTall() - ( hei - 2 ) )
		surface.SetTextColor( color_white )
		surface.DrawText( votes )
	end
end

function PANEL:DoClick()
	local pl = LocalPlayer()

	if not pl.VoteDelay or ( pl.VoteDelay < CurTime() ) then
		surface.PlaySound( "buttons/button3.wav" )
		RunConsoleCommand( "glmvs_vote", self.MapID )

		pl.VoteDelay = CurTime() + GLMVS.VoteDelay or 3
	end
end

function PANEL:SetImageSize( int )
	self:SetSize( int, int )
end

function PANEL:SetMapData( id, mTbl )
	self.MapID		= id
	self.MapName	= mTbl.Name or mTbl.Map
	self.Author		= mTbl.Author
	self.Image		= mTbl.Image
	self.Ticker		= draw.NewTicker( 4, 2 )

	self:SetToolTip( mTbl.Description )
	self:SetDisabled( tobool( mTbl.Locked ) )

	GLMVS.MapList[ id ].Votes = 0
end

vgui.Register( "DMapButton", PANEL, "DButton" )