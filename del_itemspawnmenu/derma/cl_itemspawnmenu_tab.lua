local PANEL = {}
function PANEL:Init()
	self.CategoryTable = {}

	self.HorizontalDivider = vgui.Create( "DHorizontalDivider", self )
	self.HorizontalDivider:Dock( FILL )
	self.HorizontalDivider:SetLeftWidth( 192 )
	self.HorizontalDivider:SetLeftMin( 100 )
	self.HorizontalDivider:SetRightMin( 100 )
	if ( ScrW() >= 1024 ) then self.HorizontalDivider:SetLeftMin( 192 ) self.HorizontalDivider:SetRightMin( 400 ) end
	self.HorizontalDivider:SetDividerWidth( 6 )
	self.HorizontalDivider:SetCookieName( "SpawnMenuCreationMenuDiv" )

	self.ContentNavBar = vgui.Create( "ContentSidebar", self.HorizontalDivider )
	self.HorizontalDivider:SetLeft( self.ContentNavBar )

    self:FillContent()
end

function PANEL:EnableModify()
	self.ContentNavBar:EnableModify()
end

function PANEL:EnableSearch( ... )
	self.ContentNavBar:EnableSearch( ... )
end

function PANEL:CallPopulateHook( HookName )
end

function PANEL:FillContent()
	local items = ix.item.list
	local categories = {}
	for id, item in pairs(items) do
		item.spawn_id = id
		categories[item.category] = categories[item.category] or {}
		categories[item.category][#categories[item.category]+1] = item
	end
	for category, itemList in pairs(categories) do
		local cat = self.ContentNavBar.Tree:AddNode(category, "icon16/asterisk_orange.png") 
		cat.DoPopulate = function(s)
			if s.PropPanel then return end

			s.PropPanel = vgui.Create("ContentContainer", self)
			s.PropPanel:SetVisible(false)
			s.PropPanel:SetTriggerSpawnlistChange(false)
			table.sort(itemList, function(a,b)
				return a.name:lower() < b.name:lower()
			end)
			for _, item in ipairs(itemList) do
				spawnmenu.CreateContentIcon("HELIX_Type", s.PropPanel, item)
			end

			
		end
		cat.DoClick = function(s)
				s:DoPopulate()
				self:SwitchPanel(s.PropPanel)
		end
	end
end

function PANEL:SwitchPanel( panel )

	if ( IsValid( self.SelectedPanel ) ) then
		self.SelectedPanel:SetVisible( false )
		self.SelectedPanel = nil
	end

	self.SelectedPanel = panel
	if ( !IsValid( panel ) ) then return end

	self.HorizontalDivider:SetRight( self.SelectedPanel )
	self.HorizontalDivider:InvalidateLayout( true )

	self.SelectedPanel:SetVisible( true )
	self:InvalidateParent()

end

function PANEL:OnSizeChanged()
	self.HorizontalDivider:LoadCookies()
end

vgui.Register("ix_spawnmenuItemsViewerTab", PANEL, "EditablePanel")

DEFINE_BASECLASS("ContentIcon")
local PANEL = {}

function PANEL:Init()
	self:SetSize(128, 128)
	-- self.Icon = vgui.Create( "ModelImage", self )
	-- self.Icon:SetMouseInputEnabled( false )
	-- self.Icon:SetKeyboardInputEnabled( false )
	-- self.Icon:SetSize(80,80)
	-- self.Icon:Center()
	-- baseclass.Get("SpawnIcon").Init(self)
	-- self:SetDoubleClickingEnabled(false)
end

function PANEL:Setup(item)
	if (item.icon and item.icon != "") then
		self.Icon = vgui.Create("DPanel", self)
		self.Icon:SetSize(80,80)
		self.Icon:Center()
		self.Icon:SetMouseInputEnabled( false )
		self.Icon:SetKeyboardInputEnabled( false )
		self.Icon.Paint = function(s,x,y)
			surface.SetMaterial(Material(item.icon))
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect(5, 5, x-10, y-10)
		end
	else
		self.model = item.model
		self.Icon = vgui.Create( "ModelImage", self )
		self.Icon:SetMouseInputEnabled( false )
		self.Icon:SetKeyboardInputEnabled( false )
		self.Icon:SetSize(80,80)
		self.Icon:Center()
		self.Icon:SetModel( self.model, 0, "000000000" )
	end
	self.name = item.name
	self.id = item.spawn_id
	self:SetName(self.name)
	self:SetModel(self.model)

end
--https://wiki.facepunch.com/gmod/ContentIcon
function PANEL:DoClick()
	if CAMI.PlayerHasAccess(LocalPlayer(), "Helix - SpawnItems", nil) then
		net.Start("del_spawnItem")
			net.WriteString(self.id)
			net.WriteBool(false)
		net.SendToServer()
	end
end

function PANEL:OpenMenu()
	if CAMI.PlayerHasAccess(LocalPlayer(), "Helix - SpawnItems", nil) then
		local menu = DermaMenu()
		menu:SetPos(gui.MouseX(), gui.MouseY())
		
 		for _, ply in ipairs(player.GetAll()) do
 			-- if ply == LocalPlayer() then continue end
 			local name = ply:GetName()
 			menu:AddOption(name, function()
 				net.Start("del_spawnItem")
 					net.WriteString(self.id)
 					net.WriteBool(true)
 					net.WriteEntity(ply)
 				net.SendToServer() 
 	 		end)
 		end
 		menu:MakePopup()
	end
end


vgui.Register("ix_spawnmenuItemsViewerIcon", PANEL, "ContentIcon")
	
