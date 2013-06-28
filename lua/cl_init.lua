/* --------------------------------------------------------------------------
    GLMVS - Globalized Map Voting System
    Copyright (C) 2012  Robert Lind (ptown2)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
-------------------------------------------------------------------------- */

local VoteFrame = nil

local function CreateFonts()
	surface.CreateFont( "VoteTitle", { font = "Bebas Neue", size = util.Sizeto720p( 54, ScrH() ), weight = 500 })
	surface.CreateFont( "VoteCaption", { font = "Bebas Neue", size = util.Sizeto720p( 28, ScrH() ), weight = 500 })
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

	for id, info in pairs( GLMVS.Maplist ) do
		local ListItem = ListFrame:Add( "DButton" )
		ListItem:SetSize( imapsize, imapsize )
		ListItem:SetText( " " )
		ListItem:SetDisabled( tobool( info.Locked ) )
		ListItem.MapName = info.Name || info.Map
		--ListItem.ID = id
		ListItem.MapID = id
		ListItem.Image = util.IsValidImage( info.Map )
		ListItem.Paint = GLMVS.GenericImgButton
		ListItem.DoClick = GLMVS.Votemap
	end

	VoteFrame:MakePopup()
end

concommand.Add( "glmvs_openvote", Derma_Votemap )