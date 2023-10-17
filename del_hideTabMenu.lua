local PLUGIN = PLUGIN

PLUGIN.name = "del_Hide ScoreBoard."
PLUGIN.author = "Delarioo"

CAMI.RegisterPrivilege({
	Name = "Helix - Show Scoreboard",
	MinAccess = "admin"
})

if CLIENT then
	hook.Remove("ixScoreboard")
	hook.Add("CreateMenuButtons", "ixScoreboard", function(tabs)
		if (CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Show Scoreboard", nil)) then
			tabs["scoreboard"] = function(container)
				container:Add("ixScoreboard")
			end
		end
	end)
end