local PLUGIN = PLUGIN

function PLUGIN:LoadFonts(font, genericFont)
	local fontDefault = genericFont--"Arial"
	//Переделываем заводские фонты
	local weight
	local weightChoice = ix.option.Get("fontWeight")
	if weightChoice == 1 then
		weight = 100
	elseif weightChoice == 2 then
		weight = 700 
	else
		weight = 600
	end
	surface.CreateFont("ixChatFontCustom", {
		font = fontDefault,
		size = math.max(ScreenScale(6), 17) * ix.option.Get("chatFontScale", 1),
		extended = true,
		weight = weight,
		antialias = true
	})

	surface.CreateFont("del_ChatFontWhisper", {
		font = fontDefault,
		size = math.max(ScreenScale(7), 17) * ix.option.Get("chatFontScale", 1) * ix.option.Get('size_w', 1),
		extended = true,
		weight = weight,
		antialias = true
	})

	surface.CreateFont("del_ChatFontYell", {
		font = fontDefault,
		size = math.max(ScreenScale(7), 17) * ix.option.Get("chatFontScale", 1) * ix.option.Get('size_y', 1),
		extended = true,
		weight = weight,
		antialias = true
	})
	-- Italic
	surface.CreateFont("ixChatFontCustomItalic", {
		font = fontDefault,
		size = math.max(ScreenScale(6), 17) * ix.option.Get("chatFontScale", 1),
		extended = true,
		weight = weight,
		antialias = true,
		italic = true,
	})

	surface.CreateFont("del_ChatFontWhisperItalic", {
		font = fontDefault,
		size = math.max(ScreenScale(7), 17) * ix.option.Get("chatFontScale", 1) * ix.option.Get('size_w', 1),
		extended = true,
		weight = weight,
		antialias = true,
		italic = true,
	})

	surface.CreateFont("del_ChatFontYellItalic", {
		font = fontDefault,
		size = math.max(ScreenScale(7), 17) * ix.option.Get("chatFontScale", 1) * ix.option.Get('size_y', 1),
		extended = true,
		weight = weight,
		antialias = true,
		italic = true,
	})
end

function PLUGIN:ChatboxCreated()
	local Chat = ix.gui.chat
	Chat.history.AddLine = function(self, elements, bShouldScroll)

		local buffer = {
			"<font=ixChatFontCustom>"
		}

		if (ix.option.Get("chatTimestamps", false)) then
			buffer[#buffer + 1] = "<color=150,150,150>("

			if (ix.option.Get("24hourTime", false)) then
				buffer[#buffer + 1] = os.date("%H:%M")
			else
				buffer[#buffer + 1] = os.date("%I:%M %p")
			end

			buffer[#buffer + 1] = ") "
		end

		if (CHAT_CLASS) then
			buffer[#buffer + 1] = "<font="
			buffer[#buffer + 1] = CHAT_CLASS.font or "ixChatFontCustom"
			buffer[#buffer + 1] = ">"
		end

		for _, v in ipairs(elements) do
			if (type(v) == "IMaterial") then
				local texture = v:GetName()

				if (texture) then
					buffer[#buffer + 1] = string.format("<img=%s,%dx%d> ", texture, v:Width(), v:Height())
				end
			elseif (istable(v) and v.r and v.g and v.b) then
				buffer[#buffer + 1] = string.format("<color=%d,%d,%d>", v.r, v.g, v.b)
			elseif (type(v) == "Player") then
				local color = team.GetColor(v:Team())

				buffer[#buffer + 1] = string.format("<color=%d,%d,%d>%s", color.r, color.g, color.b,
					v:GetName():gsub("<", "&lt;"):gsub(">", "&gt;"))
			else
				buffer[#buffer + 1] = tostring(v):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("%b**", function(value)
					local inner = value:utf8sub(2, -2)

					if (inner:find("%S")) then
						return "<font="..CHAT_CLASS.font.."Italic>" .. value:utf8sub(2, -2) .. "</font>"
					end
				end)
			end
		end

		local panel = self:Add("ixChatMessage")
		panel:Dock(TOP)
		panel:InvalidateParent(true)
		panel:SetMarkup(table.concat(buffer))

		if (#ix.chat.entries >= 35) then
			local oldPanel = table.remove(ix.chat.entries, 1)

			if (IsValid(oldPanel)) then
				oldPanel:Remove()
			end
		end

		ix.chat.entries[#ix.chat.entries + 1] = panel
		return panel
	end
end