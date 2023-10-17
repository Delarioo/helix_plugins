local PLUGIN = PLUGIN

PLUGIN.name = "del_Simple Roll."
PLUGIN.author = "Delarioo"

ix.command.Add("Roll", {
	description = "@cmdRoll",
	OnRun = function(self, client)
		local value = math.random(0, 100)
		ix.chat.Send(client, "roll", tostring(value), nil, nil, {})
		ix.log.Add(client, "roll", value)
	end
})

if SERVER then

	ix.log.AddType("roll", function(client, value)
		return string.format("%s rolled %d out of 100.", client:Name(), value)
	end)

end
