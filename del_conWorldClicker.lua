local PLUGIN = PLUGIN;

PLUGIN.name = "del_fixWorldClicker";
PLUGIN.description = [[Отключает возможность использовать оружие и руки во время вызова контекстного меню
]];
PLUGIN.author = "Delarioo";
PLUGIN.schema = "HL2RP";

if (SERVER) then return end

function PLUGIN:OnContextMenuOpen()
	CreateContextMenu()
	if IsValid(LocalPlayer():GetActiveWeapon()) then
		local wep = LocalPlayer():GetActiveWeapon():GetClass()
		if wep == "weapon_physgun" or wep == "gmod_tool" then
			g_ContextMenu:SetWorldClicker(true);
			return
		end
	end
	g_ContextMenu:SetWorldClicker(false);
end
