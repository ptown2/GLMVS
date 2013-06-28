module( "GLMVS", package.seeall )

net.Receive( "GLMVS_ReceiveVotes", function( pl, len )
	local mapid, votes = net.ReadInt( 32 ), net.ReadInt( 32 )

	GLMVS.Maplist[ mapid ].Votes = GLMVS.Maplist[ mapid ].Votes + votes
end )

function Votemap( self )
	local pl = LocalPlayer()

	if ( !pl.VoteDelay || ( pl.VoteDelay < CurTime() ) ) then
		RunConsoleCommand( "glmvs_vote", self.MapID )

		pl.VoteDelay = CurTime() + GLMVS.VoteDelay
	end
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

	surface.SetFont( "VoteCaption" )
	local name = GLMVS.Maplist[ mapid ].Map
	local wid, hei = surface.GetTextSize( name )

	surface.SetTextPos( 4, 0 )
	surface.SetTextColor( color_white )
	surface.DrawText( name )

	surface.SetFont( "VoteCaption" )
	local votes = GLMVS.Maplist[ mapid ].Votes
	local wid, hei = surface.GetTextSize( votes )

	surface.SetTextPos( self:GetWide() - ( wid + 4 ), self:GetTall() - ( hei - 2 ) )
	surface.SetTextColor( color_white )
	surface.DrawText( GLMVS.Maplist[ mapid ].Votes )
end