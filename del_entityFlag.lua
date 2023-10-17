local PLUGIN = PLUGIN

PLUGIN.name = "del_Флаг на Спавн Ентити"
PLUGIN.author = "Delarioo"
PLUGIN.description = "Добавляет флаг на спавн ентити ('E'). "
PLUGIN.license = [[]]

ix.flag.Add("E", "Позволяет создавать энтити.")


if CLIENT then return end

function PLUGIN:PlayerSpawnSENT(ply, class)
	return ply:GetCharacter():HasFlags('E')
end