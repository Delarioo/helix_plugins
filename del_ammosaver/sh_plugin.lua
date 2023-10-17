local PLUGIN = PLUGIN

PLUGIN.name = "del_Ammo Saver after death."
PLUGIN.author = "Delarioo"

ix.config.Add("saveAmmoAfterDeath", true, "Позволяет сохранять запасные патроны после смерти персонажа.", nil, {
	category = "server"
})
ix.util.Include("sv_hooks.lua")