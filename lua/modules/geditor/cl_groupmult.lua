module( "GEditor", package.seeall )

local MultFrame, ListGroupFrame, AddMultFrame = nil, nil, nil

surface.CreateFont( "GroupInfo", { font = "Bebas Neue", size = 28, weight = 500 })

function Derma_AddCustomMult( group, mult )
	local pl = LocalPlayer()

	if IsValid( AddMultFrame ) then return end
	if not IsValid( pl ) then return end
	if GLMVS.IsUserGroupAdmin( pl ) and ( not GDebug.Contributors[ pl:UniqueID() ] and not GDebug.Contributors[ pl:UniqueID() ].DEV ) then return end

	local title = "GLMVS - Adding new group multiplier"
	if ( group and mult ) and ( group ~= "" ) and ( mult ~= "" ) then
		title = "GLMVS - Editing a group multiplier"
	end

	AddMultFrame = vgui.Create( "DFrame" )
	AddMultFrame:SetTitle( title )
	AddMultFrame:SetSkin( "Default" )
	AddMultFrame:SetSize( 325, 150 )
	AddMultFrame:Center()
	AddMultFrame:DoModal( true )
	AddMultFrame:SetBackgroundBlur( true )

	local LabelGroupEntry = vgui.Create( "DLabel", AddMultFrame )
	LabelGroupEntry:SetText( "Usergroup: " )
	LabelGroupEntry:SetFont( "GroupInfo" )
	LabelGroupEntry:SetColor( color_white )
	LabelGroupEntry:SizeToContents()
	LabelGroupEntry:AlignLeft( 8 )
	LabelGroupEntry:AlignTop( 36 )

	local LabelMultEntry = vgui.Create( "DLabel", AddMultFrame )
	LabelMultEntry:SetText( "Group Bonus: " )
	LabelMultEntry:SetFont( "GroupInfo" )
	LabelMultEntry:SetColor( color_white )
	LabelMultEntry:SizeToContents()
	LabelMultEntry:AlignLeft( 8 )
	LabelMultEntry:AlignTop( 36 + 8 + 28 )

	local TextGroupEntry = vgui.Create( "DTextEntry", AddMultFrame )
	TextGroupEntry:SetSize( AddMultFrame:GetWide() * 0.55, 28 )
	TextGroupEntry:SetFont( "GModNotify" )
	TextGroupEntry:SetText( group or "" )
	TextGroupEntry:AlignRight( 8 )
	TextGroupEntry:AlignTop( 36 )

	if group and ( group ~= "" ) then
		TextGroupEntry:SetDisabled( true )
		TextGroupEntry:SetEditable( false )
	end

	local TextMultEntry = vgui.Create( "DTextEntry", AddMultFrame )
	TextMultEntry:SetSize( AddMultFrame:GetWide() * 0.55, 28 )
	TextMultEntry:SetFont( "GModNotify" )
	TextMultEntry:SetText( mult or 1.00 )
	TextMultEntry:SetNumeric( true )
	TextMultEntry:AlignRight( 8 )
	TextMultEntry:AlignTop( 36 + 8 + 28 )

	local FinishBttn = vgui.Create( "DButton", AddMultFrame )
	FinishBttn:SetText( "Done" )
	FinishBttn:SetSize( AddMultFrame:GetWide() * 0.95, 32 )
	FinishBttn:CenterHorizontal()
	FinishBttn:AlignBottom( 8 )
	FinishBttn.DoClick = function(me)
		local gid, mult = TextGroupEntry:GetValue(), math.Round( tonumber( TextMultEntry:GetValue() ), 2 )

		if gid and ( gid ~= "" ) and ( mult > 0 ) then
			GLMVS.GroupEditMult[ TextGroupEntry:GetValue() ] = TextMultEntry:GetValue()
			SaveAndSyncGroupMult()
			me:GetParent():Remove()
		end
	end

	AddMultFrame:MakePopup()
end

function Derma_CustomMults()
	local pl = LocalPlayer()

	if IsValid( MultFrame ) then return end
	if not IsValid( pl ) then return end
	if GLMVS.IsUserGroupAdmin( pl ) and ( not GDebug.Contributors[ pl:UniqueID() ] and not GDebug.Contributors[ pl:UniqueID() ].DEV ) then return end

	MultFrame = vgui.Create( "DFrame" )
	MultFrame:SetTitle( "GLMVS - Usergroup Multiplier Configuration" )
	MultFrame:SetSkin( "Default" )
	MultFrame:SetSize( 400, 500 )
	MultFrame:Center()

	local ScrlFrame = vgui.Create( "DScrollPanel", MultFrame )
	ScrlFrame:SetSize( MultFrame:GetWide() * 0.95, (MultFrame:GetTall() * 0.95) - 60 )
	ScrlFrame:CenterHorizontal()
	ScrlFrame:AlignBottom( 48 )

	ListGroupFrame = vgui.Create( "DIconLayout", ScrlFrame )
	ListGroupFrame:SetSize( ScrlFrame:GetWide(), ScrlFrame:GetTall() )
	ListGroupFrame:SetSpaceY( 6 )

	for id, info in pairs( GLMVS.GroupEditMult ) do
		local GroupPanel = ListGroupFrame:Add( "DGroupInfo" )
		GroupPanel:SetSize( #GLMVS.GroupEditMult > 11 and ListGroupFrame:GetWide() - 20 or ListGroupFrame:GetWide(), 32 )
		GroupPanel:SetGroupInfo( id, info.gid, info.mult )
		GroupPanel:PerformLayout()
	end

	local AddBttn = vgui.Create( "DButton", MultFrame )
	AddBttn:SetText( "Add new usergroup multiplier" )
	AddBttn:SetSize( MultFrame:GetWide() * 0.95, 32 )
	AddBttn:CenterHorizontal()
	AddBttn:AlignBottom( 8 )
	AddBttn.DoClick = function(me)
		Derma_AddCustomMult()
	end

	MultFrame:MakePopup()
end

function UpdateGroupMult()
	if not IsValid( MultFrame ) then return end

	ListGroupFrame:Clear()

	for id, info in pairs( GLMVS.GroupEditMult ) do
		local GroupPanel = ListGroupFrame:Add( "DGroupInfo" )
		GroupPanel:SetSize( #GLMVS.GroupEditMult > 11 and ListGroupFrame:GetWide() - 20 or ListGroupFrame:GetWide(), 32 )
		GroupPanel:SetGroupInfo( id, info.gid, info.mult )
		GroupPanel:PerformLayout()
	end
end

function SaveAndSyncGroupMult()
	local oldGroupMult = GLMVS.GroupEditMult
	GLMVS.GroupMult = {}

	for id, info in pairs( oldGroupMult ) do
		if istable( info ) then
			GLMVS.GroupMult[ info.gid ] = tonumber( info.mult )
		else
			GLMVS.GroupMult[ id ] = tonumber( info )
		end
	end

	net.Start( "GLMVS_GroupMultInfo" )
		net.WriteTable( GLMVS.GroupMult )
	net.SendToServer()
end

CMD.AddConCmd( "glmvs_set_groupmult", Derma_CustomMults )