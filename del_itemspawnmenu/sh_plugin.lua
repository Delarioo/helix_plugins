
PLUGIN.name = "del_item spawn menu"
PLUGIN.description = "Добавляет возможность спавнить предметы через spawnmenu."
PLUGIN.author = "Delarioo"

ix.util.Include("sv_hooks.lua")

CAMI.RegisterPrivilege({
	Name = "Helix - SpawnItems",
	MinAccess = "admin"
})

if CLIENT then
	function PLUGIN:InitPostEntity()
		if (CAMI.PlayerHasAccess(LocalPlayer(), "Helix - SpawnItems", nil)) then
			spawnmenu.AddContentType( "HELIX_Type", function( container, item )

				local icon = vgui.Create( "ix_spawnmenuItemsViewerIcon", container )
				icon:Setup( item )
				container:Add( icon )
	 
			end)

			spawnmenu.AddCreationTab("HELIX", function() 
			return vgui.Create("ix_spawnmenuItemsViewerTab")
			end, "icon16/bomb.png", 100)
			
			RunConsoleCommand("spawnmenu_reload")
		end	
	end
end 