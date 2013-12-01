local PANEL = {}

PANEL.m_EditBttn = nil
PANEL.m_RemoveBttn = nil
PANEL.m_TextGroup = nil

PANEL.m_GroupID = nil
PANEL.m_GroupMult = nil

function PANEL:Init()
	m_EditBttn = vgui.Create( "DButton", self )
	m_EditBttn:SetText( "Edit" )
	m_EditBttn:SetSkin( "Default" )

	m_RemoveBttn = vgui.Create( "DButton", self )
	m_RemoveBttn:SetText( "Remove" )
	m_RemoveBttn:SetSkin( "Default" )

	m_TextGroup = vgui.Create( "DLabel", self )
	m_TextGroup:SetText( "Group Name" )
	m_TextGroup:SetFont( "GroupInfo" )
	m_TextGroup:SetColor( color_black )
end

function PANEL:PerformLayout()
	local size1 = math.ceil( self:GetWide() * 0.15 )

	m_TextGroup:SizeToContents()
	m_TextGroup:CenterVertical()
	m_TextGroup:AlignLeft( 8 )

	m_EditBttn:SetSize( size1, self:GetTall() - 12 )
	m_EditBttn:CenterVertical()
	m_EditBttn:AlignRight( size1 + 12 )

	m_RemoveBttn:SetSize( size1, self:GetTall() - 12 )
	m_RemoveBttn:CenterVertical()
	m_RemoveBttn:AlignRight( 8 )
end

function PANEL:SetGroupInfo( id, gid, mult )
	self.m_GroupID = gid
	self.m_GroupMult = mult

	m_TextGroup:SetText( gid.. " - x" ..math.Round( self.m_GroupMult, 2 ) )

	m_EditBttn.DoClick = function(me)
		GEditor.Derma_AddCustomMult( self.m_GroupID, self.m_GroupMult )
	end

	m_RemoveBttn.DoClick = function( me )
		GLMVS.GroupEditMult[ id ] = nil
		GEditor.SaveAndSyncGroupMult()
		me:GetParent():Remove()
	end

	self:Refresh()
end

vgui.Register( "DGroupInfo", PANEL, "DPanel" )