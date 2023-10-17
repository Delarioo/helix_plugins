
local PLUGIN = PLUGIN or {}

PLUGIN.name = "del_Radio"
PLUGIN.author = "Delarioo"
PLUGIN.description = "Добавляет простое радио и перезагружает все необходимые команды."

do
	local CLASS = {}
	CLASS.format = "%s передаёт \"%s\""
	CLASS.font = "ixChatFontCustom"

	function CLASS:GetColor(speaker, text)
		local chatRange = ix.config.Get("chatRange", 280) * 0.25
		if (LocalPlayer():GetEyeTrace().Entity == speaker) then
			return ix.option.Get("color_listen")
		elseif LocalPlayer() != speaker and (speaker:EyePos() - LocalPlayer():EyePos()):LengthSqr() <= (chatRange * chatRange) then
			return ix.option.Get("color_ic")
		else
			return ix.option.Get("color_r")
		end			
	end

	function CLASS:CanHear(speaker, listener)
		local chatRange = ix.config.Get("chatRange", 280)
		local character = listener:GetCharacter()
		local inventory = character:GetInventory()
		if inventory:HasItem("radio") then
			if (speaker:GetCharacter():GetData("frequency") == character:GetData("frequency")) then
				return true
			end
		end
		return (speaker:EyePos() - listener:EyePos()):LengthSqr() <= (chatRange * chatRange) and ix.chat.traceCanHear(speaker, listener)
	end
	function CLASS:OnChatAdd(speaker, text)
		local chatRange = ix.config.Get("chatRange", 280)
		if speaker:IsCombine() and speaker:GetNetVar("CombineMask", true) then
			text = string.format("<:: %s ::>", text)
		end
		local name = anonymous and
				L"someone" or hook.Run("GetCharacterName", speaker, "radio") or
				(IsValid(speaker) and speaker:Name() or "Console")
		chat.AddText(self:GetColor(speaker, text), string.format(self.format, name, text))
	end
	ix.chat.Register("radio", CLASS)
end

do
	local CLASS = {}
	CLASS.format = "%s передаёт шёпотом \"%s\""
	CLASS.font = "ixChatFontCustom"

	function CLASS:GetColor(speaker, text)
		local chatRange = ix.config.Get("chatRange", 280) * 0.25
		if (LocalPlayer():GetEyeTrace().Entity == speaker) then
			return ix.option.Get("color_listen")
		elseif LocalPlayer() != speaker and (speaker:EyePos() - LocalPlayer():EyePos()):LengthSqr() <= (chatRange * chatRange) then
			return ix.option.Get("color_ic")
		else
			return ix.option.Get("color_r")
		end			
	end

	function CLASS:CanHear(speaker, listener)
		local chatRange = ix.config.Get("chatRange", 280) * 0.25
		local character = listener:GetCharacter()
		local inventory = character:GetInventory()
		if inventory:HasItem("radio") then
			if (speaker:GetCharacter():GetData("frequency") == character:GetData("frequency")) then
				return true
			end
		end
		return (speaker:EyePos() - listener:EyePos()):LengthSqr() <= (chatRange * chatRange)
	end
	function CLASS:OnChatAdd(speaker, text)
		local chatRange = ix.config.Get("chatRange", 280) * 0.25
		if speaker:IsCombine() and speaker:GetNetVar("CombineMask", true) then
			text = string.format("<:: %s ::>", text)
		end
		local name = anonymous and
				L"someone" or hook.Run("GetCharacterName", speaker, "radio_whisper") or
				(IsValid(speaker) and speaker:Name() or "Console")
		chat.AddText(self:GetColor(speaker, text), string.format(self.format, name, text))
	end
	ix.chat.Register("radio_whisper", CLASS)
end
 
do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		local character = client:GetCharacter()
		local item = character:GetInventory():HasItem("radio")
		if (item) then
			if (!client:IsRestricted() and client:Alive() and !client:IsRagdolled()) then
				ix.chat.Send(client, "radio", message)
			else
				return "@notNow"
			end
		else
			return "@radioRequired"
		end
	end

	ix.command.Add("R", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		local character = client:GetCharacter()
		local item = character:GetInventory():HasItem("radio")
		if (item) then
			if (!client:IsRestricted() and client:Alive() and !client:IsRagdolled()) then
				ix.chat.Send(client, "radio_whisper", message)
			else
				return "@notNow"
			end
		else
			return "@radioRequired"
		end
	end

	ix.command.Add("RW", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.number
	COMMAND.description = "Частота рации в формате XXX.X. Диапозон 100.1 - 199.9"
	function COMMAND:OnRun(client, frequency)
		local character = client:GetCharacter()
		local inventory = character:GetInventory()
		local itemTable = inventory:HasItem("radio")

		if (itemTable) then
			if (string.find(frequency, "^%d%d%d%.%d$")) then
				if frequency<= 199.9 and frequency >= 100.1 then
					character:SetData("frequency", frequency)
					client:Notify(string.format("Частота изменена на %s.", frequency))
				else
					client:Notify("Частота должна быть в диапозоне 100.1 - 199.9")
				end 
			else
				client:Notify("Параметр должен соответствовать формату XXX.X")
			end
		else
			return "У Вас нет радио."
		end
	end

	ix.command.Add("SetFreq", COMMAND)
end

if CLIENT then

	function PLUGIN:IsRecognizedChatType(chatType)
		if (chatType == "radio" or chatType == "radio_whisper") then
			return true
		end
	end

else
	function PLUGIN:CanAutoFormatMessage(client, chatType, message)
		return chatType == "radio" or chatType == "radio_whisper"
	end
end