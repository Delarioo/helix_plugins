local PLUGIN = PLUGIN

ix.lang.AddTable("english", {
	optColor_ic = "Цвет IC сообщений",
	optColor_me = "Цвет ME сообщений",
	optColor_it = "Цвет IT сообщений",
	optColor_w = "Цвет W сообщений (шёпот)",
	optColor_y = "Цвет Y сообщений (крик)",
	optColor_looc = "Цвет LOOC сообщений",
	optColor_r = "Цвет R сообщений (радио)",
	optColor_listen = "Цвет сообщений, когда смотришь на персонажа.",
	optSize_w = "Размер W сообщений (шёпот)",
	optSize_y = "Размер Y сообщений (крик)",
	optFontWeight = "Толщина букв чата",
	optdFontWeight = "1 - Тонкий шрифт, 2 - Нормальный шрифт, 3 - Толстый (стандартный) шрифт",
	optchatFontScale = "Общий размер шрифта",
})

ix.option.Add("fontWeight", ix.type.number, 3, {
	min = 1,
	max = 3,
	category = "Customize Chat",
	OnChanged = function()
			hook.Run("LoadFonts", ix.config.Get("font"), ix.config.Get("genericFont"))
			hook.Run("CreateChat")
	end
})

ix.option.Add("chatFontScale", ix.type.number, 1, {
	category = "Customize Chat", min = 0.75, max = 2, decimals = 2,
	OnChanged = function()
		hook.Run("LoadFonts", ix.config.Get("font"), ix.config.Get("genericFont"))
		hook.Run("CreateChat")
	end
})

ix.option.Add('size_w', ix.type.number, 1, {
	min = 0.65,
	max = 1,
	decimals = 2,
	category = "Customize Chat",
	OnChanged = function()
			hook.Run("LoadFonts", ix.config.Get("font"), ix.config.Get("genericFont"))
			hook.Run("CreateChat")
	end
})

ix.option.Add('size_y', ix.type.number, 1, {
	min = 1,
	max = 1.35,
	decimals = 2,
	category = "Customize Chat",
	OnChanged = function()
			hook.Run("LoadFonts", ix.config.Get("font"), ix.config.Get("genericFont"))
			hook.Run("CreateChat")
	end
})

ix.option.Add('color_ic', ix.type.color, Color(255, 255, 150), {
	category = "Customize Chat",
})

ix.option.Add('color_r', ix.type.color, Color(75, 150, 50), {
	category = "Customize Chat",
})

ix.option.Add('color_me', ix.type.color, Color(255, 255, 150), {
	category = "Customize Chat",
})

ix.option.Add('color_it', ix.type.color, Color(255, 255, 185), {
	category = "Customize Chat",
})

ix.option.Add('color_w', ix.type.color, Color(220, 220, 115), {
	category = "Customize Chat",
})

ix.option.Add('color_y', ix.type.color, Color(220, 220, 115), {
	category = "Customize Chat"
})

ix.option.Add('color_looc', ix.type.color, Color(255, 255, 150), {
	category = "Customize Chat"
})

ix.option.Add('color_listen', ix.type.color, Color(175, 255, 150), {
	category = "Customize Chat"
})

