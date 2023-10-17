local PLUGIN = PLUGIN

local combineOverlay = ix.util.GetMaterial("effects/combine_binocoverlay")
local scannerFirstPerson = false

function PLUGIN:HUDPaint()
	if LocalPlayer():IsCombine() then 
		chr = LocalPlayer():GetCharacter()
		if chr == nil then return end -- О даа, это самый настоящий костыль, дамы и господа. Без этой строчки при подгрузке персонажа мы будем получать ошибки, ха. 
		if chr:GetData("CombineMask",true) then
			if ix.option.Get("combineMaskOverlay", true) then
				if !IsValid(ix.gui.combine) then
					vgui.Create("ixCombineDisplay")
				end
				local colorModify = {}
				colorModify["$pp_colour_colour"] = 0.77

				if (system.IsWindows()) then
					colorModify["$pp_colour_brightness"] = -0.05
					colorModify["$pp_colour_contrast"] = 1.2
				else
					colorModify["$pp_colour_brightness"] = 0
					colorModify["$pp_colour_contrast"] = 1
				end

				if (scannerFirstPerson) then
					COLOR_BLACK_WHITE["$pp_colour_brightness"] = 0.05 + math.sin(RealTime() * 10) * 0.01
					colorModify = COLOR_BLACK_WHITE
				end
				DrawColorModify(colorModify)

				render.UpdateScreenEffectTexture()
				combineOverlay:SetFloat("$alpha", ix.option.Get("combineMaskOverlaySaturation", 0.2))
				combineOverlay:SetInt("$ignorez", 1)

				render.SetMaterial(combineOverlay)
				render.DrawScreenQuad()
			-- else combineOverlay = ix.util.GetMaterial("Models/effects/vol_light001")
			end
		elseif (IsValid(ix.gui.combine)) then 
			ix.gui.combine:Remove()
		end
	end
end


//Отключаем стандартный оверлей режима
function Schema:CharacterLoaded(character) end
function Schema:RenderScreenspaceEffects() end