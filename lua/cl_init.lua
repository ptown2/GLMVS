local VoteFrame = nil

local function LowestSizeMult( factor, size )
	return math.floor( factor / size ) - 1
end

function Derma_Votemap()
	if IsValid( VoteFrame ) then return end
	
	local w, h = ScrW(), ScrH()
	local imapsize = 150
	local spacingx, spacingy = 5, 5
	local numframesw, numframesh = LowestSizeMult( w, imapsize ), LowestSizeMult( h, imapsize )
	
	VoteFrame = vgui.Create("DPanel")
	VoteFrame:SetSize( ( numframesw * spacingx ) + ( numframesw * imapsize ) + 35, ( numframesh * spacingy ) + ( numframesh * imapsize ) + 75 )
	--VoteFrame:SetTitle( " " )
	--VoteFrame:ShowCloseButton( true )
	VoteFrame:Center()
	
	ScrlFrame = vgui.Create( "DScrollPanel", VoteFrame )
	ScrlFrame:SetSize( ( numframesw * spacingx ) + ( numframesw * imapsize ) + 15, ( numframesh * spacingy ) + ( numframesh * imapsize ) - 3 )
	ScrlFrame:CenterHorizontal()
	ScrlFrame:AlignBottom( 10 )
	
	ListFrame = vgui.Create( "DIconLayout", ScrlFrame )
	ListFrame:SetSize( ScrlFrame:GetWide(), ScrlFrame:GetTall() )
	ListFrame:SetSpaceX( spacingx )
	ListFrame:SetSpaceY( spacingy )

	for i = 1, 7 * 6 do
		local ListItem = ListFrame:Add( "DPanel" )
		ListItem:SetSize( imapsize, imapsize )
	end

	CloseFrame = vgui.Create( "DButton", VoteFrame )
	CloseFrame:SetText( "X" )
	CloseFrame:SetSize( 20, 20 )
	CloseFrame:AlignRight( 10 )
	CloseFrame:AlignTop( 10 )
	CloseFrame.DoClick = function( self )
		if IsValid( VoteFrame ) then
			VoteFrame:Remove()
		end
	end

	VoteFrame:MakePopup()
end