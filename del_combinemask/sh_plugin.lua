local PLUGIN = PLUGIN

PLUGIN.name = "del_Combine helmet"
PLUGIN.description = [[Отключает синий оверлей, свойственный ГО и ОТА, звуки при включении и отключении чата, а также '<:: ::>' в самом чате.
По умолчанию имеет состояние true (активное).
[КОМАНДЫ]
*/CombineMask - переключение состояния шлема у собственного персонажа. Работает только у ГО
[ОПЦИИ]
*"Оверлей шлема Альянса, когда та надета" - Отключение или включение оверлея отдельно от чата и звуков. Не может быть включена при состоянии шлема false

[ВНИМАНИЕ]
Плагин расчитан на работу ИСКЛЮЧИТЕЛЬНО с моделями из пака моделей проекта PostBellum. При работе с другими моделями бодигруппы меняются НЕККОРЕКТНО.
]]
PLUGIN.author = "Delarioo"
PLUGIN.schema = "HL2RP"

ix.util.Include("sv_hooks.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_hooks.lua")

sound.Add({
    name = "Vocoder.On",
    channel = CHAN_STATIC,
    volume = 1,
    level = 60,
    sound = {
        "common/on1.mp3",
        "common/on2.mp3",
        "common/on3.mp3",
        "common/on4.mp3",
        "common/on5.mp3",
        "common/on6.mp3",
    }
})

sound.Add({
    name = "Vocoder.Off",
    channel = CHAN_STATIC,
    volume = 1,
    level = 60,
    sound = {
        "common/off1.mp3",
        "common/off2.mp3",
        "common/off3.mp3",
        "common/off4.mp3",
        "common/off5.mp3",
        "common/off6.mp3",
        "common/off7.mp3",
        "common/off8.mp3",
        "common/off9.mp3"
    }
})

-- (Внимание, данный плагин оптимизирован исключительно под модели ГО с проекта PostBellum на момент 02.09.2022г)
-- (С другими моделями этот плагин работать НЕ БУДЕТ)

function PLUGIN:ChangeMask(target)
	if (IsValid(target) and target:IsCombine() and target:GetCharacter():GetFaction() == FACTION_MPF) then
		local char = target:GetCharacter()
		local bMask = char:GetData('CombineMask')
		local numMask = char:GetData('mask')

		if bMask then
			char:SetData('CombineMask', false)
			target:SetNetVar("CombineMask", false)
			local group = char:GetData('groups')
			group[2] = 0
			group[3] = 0
			char:SetData('groups', group)
			target:SetBodygroup(2, 0)
			target:SetBodygroup(3, 0)
			char:Save()
			return false
		else
			char:SetData('CombineMask', true)
			target:SetNetVar("CombineMask", true)
			local group = char:GetData('groups')
			group[2] = numMask
			group[3] = 1
			char:SetData('groups', group)
			target:SetBodygroup(2, numMask)
			target:SetBodygroup(3, 1)
			char:Save()
			return true
		end	
	else
		ix.util.Notify("Вы не можете сделать это!", client)
	end 
end
do 
	local COMMAND = {}
	COMMAND.description = "Отключение/включение функций маски ГОшника"

	function COMMAND:OnRun(client)
		bMask = PLUGIN:ChangeMask(client)
		if !bMask then
			ix.util.Notify("Вы сняли маску.", client)
		else 
			ix.util.Notify("Вы надели маску.", client)
		end
	end

	ix.command.Add("CombineMask", COMMAND)
end
 
do
	local CLASS = {}
	CLASS.color = Color(75, 150, 50)
	CLASS.format = "%s передаёт \"%s\""

	function CLASS:CanHear(speaker, listener)
		local character = listener:GetCharacter()
		local inventory = character:GetInventory()
		local bHasRadio = false

		for k, v in pairs(inventory:GetItemsByUniqueID("handheld_radio", true)) do
			if (v:GetData("enabled", false) and speaker:GetCharacter():GetData("frequency") == character:GetData("frequency")) then
				bHasRadio = true
				break
			end
		end

		return bHasRadio
	end

	function CLASS:OnChatAdd(speaker, text)
		if speaker:IsCombine() and speaker:GetCharacter():GetData('CombineMask') then
			text = speaker:IsCombine() and string.format("<:: %s ::>", text) or text
		end
		chat.AddText(self.color, string.format(self.format, speaker:Name(), text))
	end

	ix.chat.Register("radio", CLASS)
end

do
	local CLASS = {}
	CLASS.color = Color(255, 255, 175)
	CLASS.format = "%s передаёт \"%s\""

	function CLASS:GetColor(speaker, text)
		if (LocalPlayer():GetEyeTrace().Entity == speaker) then
			return Color(175, 255, 175)
		end

		return self.color
	end

	function CLASS:CanHear(speaker, listener)
		if (ix.chat.classes.radio:CanHear(speaker, listener)) then
			return false
		end

		local chatRange = ix.config.Get("chatRange", 280)

		return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= (chatRange * chatRange)
	end

	function CLASS:OnChatAdd(speaker, text)
		if speaker:IsCombine() and speaker:GetCharacter():GetData('CombineMask') then
			text = speaker:IsCombine() and string.format("<:: %s ::>", text) or text
		end
		chat.AddText(self.color, string.format(self.format, speaker:Name(), text))
	end

	ix.chat.Register("radio_eavesdrop", CLASS)
end

ix.lang.AddTable("english", {
	optCombineMaskOverlay = "Оверлей маски Альянса, когда та надета",
	optCombineMaskOverlaySaturation = "Насыщенность оверлея маски Альянса"
})

ix.option.Add("combineMaskOverlay", ix.type.bool, true, {
	category = "general"
})

ix.option.Add("combineMaskOverlaySaturation", ix.type.number, 0.3, {
	category = "general",
	min = 0.1, 
	max = 0.6,
	decimals = 2
}) 