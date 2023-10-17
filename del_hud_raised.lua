local Schema = Schema
local PLUGIN = PLUGIN
PLUGIN.name = "del_draw hud for raised weapon"
PLUGIN.author = "Delarioo"
PLUGIN.description = "Позволяет HUD оружия отображаться только тогда, когда оружие поднято."

if CLIENT then

	function PLUGIN:CanDrawAmmoHUD(wep)
		local ply = wep:GetOwner()
		return ply:IsWepRaised()
	end

end