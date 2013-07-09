module( "GLMVS", package.seeall )

TotalVotes = 0

function Votemap( self )
	local pl = LocalPlayer()

	if ( !pl.VoteDelay || ( pl.VoteDelay < CurTime() ) ) then
		surface.PlaySound( "buttons/button3.wav" )
		RunConsoleCommand( "glmvs_vote", self.MapID )

		pl.VoteDelay = CurTime() + VoteDelay
	end
end

function GenericThink( self )
	Maplist[ self.MapID ].Votes = math.max( math.Approach( Maplist[ self.MapID ].Votes, Maplist[ self.MapID ].TotalVotes, ( Maplist[ self.MapID ].NextVote * 0.01 ) ), 0 )
end

function GenericImgButton( self )
	local IsLocked = self:GetDisabled()
	local c, alpha = color_white, 255
	local mapid = self.MapID

	if ( self.Hovered ) then alpha = 185 end
	if ( self.Depressed ) then c = Color( 150, 255, 150 ) end
	if ( IsLocked ) then c = Color( 125, 0, 0 ) alpha = 255 end

	surface.SetDrawColor( Color( c.r, c.g, c.b, alpha ) )
	surface.SetMaterial( Material( self.Image, "smooth mips" ) )
	surface.DrawTexturedRect( 0, 0, self:GetWide() , self:GetTall() )

	if ( IsLocked ) then
		local iconmult = 0.45

		surface.SetDrawColor( color_white )
		surface.SetMaterial( Material( "icon128/padlock.png", "smooth" ) )
		surface.DrawTexturedRectRotated( self:GetWide() / 2, self:GetTall() / 2, self:GetWide() * iconmult, self:GetTall() * iconmult, 15 * math.sin( CurTime() * 3 ) )
	end

	local mapname = self.MapName .. ( self.Author && " - BY: " .. self.Author || "" )
	surface.SetFont( "VoteCaption" )
	local wid, hei = surface.GetTextSize( mapname )

	surface.SetDrawColor( Color( 0, 0, 0, 235 ) )
	surface.DrawRect( 0, 3, self:GetWide(), hei - 3)
	draw.TickerText( mapname, "VoteCaption", color_white, self.Ticker, self:GetWide() - 4, 15, 1 )

	surface.SetFont( "VoteCaption" )
	local votes = Maplist[ mapid ].Votes
	votes = votes > 0 && math.Round( votes )  .. "   (".. math.Round( votes / GLMVS.TotalVotes * 100 ) .."%)" || nil

	if votes then
		local wid, hei = surface.GetTextSize( votes )

		surface.SetDrawColor( Color( 0, 0, 0, 235 ) )
		surface.DrawRect( self:GetWide() - ( wid + 8 ), self:GetTall() - ( hei - 2 ), ( wid + 8 ), hei - 2)

		surface.SetTextPos( self:GetWide() - ( wid + 4 ), self:GetTall() - ( hei - 2 ) )
		surface.SetTextColor( color_white )
		surface.DrawText( votes )
	end
end