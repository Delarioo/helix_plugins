local PLUGIN = PLUGIN

PLUGIN.name = "del_admin help"
PLUGIN.description = [[
Добавляет различные команду /adminhelp
]]
PLUGIN.author = "Delarioo"
PLUGIN.schema = "HL2RP"

do
	local CLASS = {}
	CLASS.format = "] %s запрашивает \"%s\""
	CLASS.font = "ixChatFontCustom"
	CLASS.color_white = Color(255,255,255)
	CLASS.color_red = Color(255,0,0)

	function CLASS:CanHear(speaker, listener)
		return listener:IsAdmin() or speaker == listener
	end
	function CLASS:OnChatAdd(speaker, text)
		local name = speaker:GetName()
		chat.AddText(self.color_white,"[", self.color_red, "ADMIN", self.color_white, string.format(self.format, name, text))
	end
	ix.chat.Register("del_admin", CLASS)
end

do
	local CLASS = {}
	CLASS.format = "] %s отвечает игроку '%s' : \"%s\""
	CLASS.font = "ixChatFontCustom"
	CLASS.color_white = Color(255,255,255)
	CLASS.color_red = Color(255,0,0)

	function CLASS:CanHear(speaker, listener)
		return listener:IsAdmin() or speaker == listener or listener == PLUGIN.lastPlayer
	end
	function CLASS:OnChatAdd(speaker, text, anon, data)
		local name = speaker:GetName()
		chat.AddText(self.color_white,"[", self.color_red, "ADMIN", self.color_white, string.format(self.format, name, data.target:GetName(),text))
	end
	ix.chat.Register("del_admin_responce", CLASS)
end

do
	local CLASS = {}
	CLASS.format = "] %s: \"%s\""
	CLASS.font = "ixChatFontCustom"
	CLASS.color_white = Color(255,255,255)
	CLASS.color_red = Color(255,0,0)

	function CLASS:CanHear(speaker, listener)
		return listener:IsAdmin()
	end
	function CLASS:OnChatAdd(speaker, text)
		local name = speaker:GetName()
		chat.AddText(self.color_white,"[", self.color_red, "ADMIN CHAT", self.color_white, string.format(self.format, name, text))
	end
	ix.chat.Register("del_admin_chat", CLASS)
end

do
	local COMMAND = {}
	COMMAND.description = "Обращение к активной администрации."
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		ix.chat.Send(client, "del_admin", message)
		PLUGIN.lastPlayer = client
	end

	ix.command.Add("adminhelp", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.description = "Ответить на последний запрос."
	COMMAND.adminOnly = true
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		if PLUGIN.lastPlayer then
			ix.chat.Send(client, "del_admin_responce", message, nil, nil,{target = PLUGIN.lastPlayer})
		else
			client:Notify("Пока что никто не обращался")
		end
	end

	ix.command.Add("adminresponce", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.description = "Чат администрации"
	COMMAND.adminOnly = true
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		ix.chat.Send(client, "del_admin_chat", message)
	end

	ix.command.Add("a", COMMAND)
end

ix.command.Add("PM", {
	description = "@cmdPM",
	arguments = {
		ix.type.player,
		ix.type.text
	},
	OnRun = function(self, client, target, message)
		local voiceMail = target:GetData("vm")

		if (voiceMail and voiceMail:find("%S")) then
			return target:GetName()..": "..voiceMail
		end
	end
})
