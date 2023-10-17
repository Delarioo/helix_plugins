local PLUGIN = PLUGIN

PLUGIN.name = "del_Customize Chat"
PLUGIN.author = "Delarioo"
PLUGIN.description = "Позволяет изменять цвета и размер сообщений чата."

ix.util.Include("cl_hooks.lua")
ix.util.Include("cl_plugin.lua")


function ix.chat.traceCanHear(speaker, listener)
	local traceData = {
		start = speaker:EyePos(),
		endpos = listener:EyePos(),
		filter = {speaker, listener},
		mask = MASK_SOLID_BRUSHONLY
	}
	return  !util.TraceLine(traceData).Hit
end


function PLUGIN:InitializedChatClasses()
		ix.chat.Register("ic", {
			format = "%s says \"%s\"",
			indicator = "chatTalking",
			GetColor = function(self, speaker, text)
				if (LocalPlayer():GetEyeTrace().Entity == speaker) then
					return ix.option.Get("color_listen")
				end
				return ix.option.Get("color_ic")
			end,
			CanHear = function(self, speaker, listener) 
				local chatRange = ix.config.Get("chatRange", 280)
				return (speaker:EyePos() - listener:EyePos()):LengthSqr() <= (chatRange * chatRange) and ix.chat.traceCanHear(speaker, listener)
			end,
			font = "ixChatFontCustom"
		})

		-- Actions and such.
		ix.chat.Register("me", {
			format = "** %s %s",
			GetColor = function(self, speaker, text)
				if (LocalPlayer():GetEyeTrace().Entity == speaker) then
					return ix.option.Get("color_listen")
				end
				return ix.option.Get("color_me")
			end,
			CanHear = function(self, speaker, listener) 
				local chatRange = ix.config.Get("chatRange", 280) * 2
				return (speaker:EyePos() - listener:EyePos()):LengthSqr() <= (chatRange * chatRange) and ix.chat.traceCanHear(speaker, listener)
			end,
			prefix = {"/Me", "/Action"},
			description = "@cmdMe",
			indicator = "chatPerforming",
			deadCanChat = true,
			font = "ixChatFontCustom"
		})

		-- Actions and such.
		ix.chat.Register("it", {
			OnChatAdd = function(self, speaker, text)
				chat.AddText(ix.option.Get("color_it"), "** "..text)
			end,

			CanHear = ix.config.Get("chatRange", 280) * 2,
			prefix = {"/It"},
			description = "@cmdIt",
			indicator = "chatPerforming",
			deadCanChat = true,
			font = "ixChatFontCustom"
		})

		-- Whisper chat.
		ix.chat.Register("w", {
			format = "%s whispers \"%s\"",
			GetColor = function(self, speaker, text)
				if (LocalPlayer():GetEyeTrace().Entity == speaker) then
					return ix.option.Get("color_listen")
				end
				return ix.option.Get("color_w")
			end,
			CanHear = ix.config.Get("chatRange", 280) * 0.25,
			prefix = {"/W", "/Whisper"},
			description = "@cmdW",
			indicator = "chatWhispering",
			font = "del_ChatFontWhisper"
		})

		-- Yelling out loud.
		ix.chat.Register("y", {
			format = "%s yells \"%s\"",
			GetColor = function(self, speaker, text)
				if (LocalPlayer():GetEyeTrace().Entity == speaker) then
					return ix.option.Get("color_listen")
				end
				return ix.option.Get("color_y")
			end,
			CanHear = ix.config.Get("chatRange", 280) * 2,
			prefix = {"/Y", "/Yell"},
			description = "@cmdY",
			indicator = "chatYelling",
			font = "del_ChatFontYell"
		})

		ix.chat.Register("looc", {
			CanSay = function(self, speaker, text)
				local delay = ix.config.Get("loocDelay", 0)

				-- Only need to check the time if they have spoken in OOC chat before.
				if (delay > 0 and speaker.ixLastLOOC) then
					local lastLOOC = CurTime() - speaker.ixLastLOOC

					-- Use this method of checking time in case the oocDelay config changes.
					if (lastLOOC <= delay and !CAMI.PlayerHasAccess(speaker, "Helix - Bypass OOC Timer", nil)) then
						speaker:NotifyLocalized("loocDelay", delay - math.ceil(lastLOOC))

						return false
					end
				end

				-- Save the last time they spoke in OOC.
				speaker.ixLastLOOC = CurTime()
			end,
			OnChatAdd = function(self, speaker, text)
				chat.AddText(Color(255, 50, 50), "[LOOC] ", ix.option.Get("color_looc"), speaker:Name()..": "..text)
			end,
			CanHear = ix.config.Get("chatRange", 280),
			prefix = {".//", "[[", "/LOOC"},
			description = "@cmdLOOC",
			noSpaceAfter = true,
			font = "ixChatFontCustom"
		})
		ix.chat.Register("ooc", {
			CanSay = function(self, speaker, text)
				if (!ix.config.Get("allowGlobalOOC")) then
					speaker:NotifyLocalized("Global OOC is disabled on this server.")
					return false
				else
					local delay = ix.config.Get("oocDelay", 10)

					-- Only need to check the time if they have spoken in OOC chat before.
					if (delay > 0 and speaker.ixLastOOC) then
						local lastOOC = CurTime() - speaker.ixLastOOC

						-- Use this method of checking time in case the oocDelay config changes.
						if (lastOOC <= delay and !CAMI.PlayerHasAccess(speaker, "Helix - Bypass OOC Timer", nil)) then
							speaker:NotifyLocalized("oocDelay", delay - math.ceil(lastOOC))

							return false
						end
					end

					-- Save the last time they spoke in OOC.
					speaker.ixLastOOC = CurTime()
				end
			end,
			OnChatAdd = function(self, speaker, text)
				-- @todo remove and fix actual cause of speaker being nil
				if (!IsValid(speaker)) then
					return
				end

				local icon = "icon16/user.png"

				if (speaker:IsSuperAdmin()) then
					icon = "icon16/shield.png"
				elseif (speaker:IsAdmin()) then
					icon = "icon16/star.png"
				elseif (speaker:IsUserGroup("moderator") or speaker:IsUserGroup("operator")) then
					icon = "icon16/wrench.png"
				elseif (speaker:IsUserGroup("vip") or speaker:IsUserGroup("donator") or speaker:IsUserGroup("donor")) then
					icon = "icon16/heart.png"
				end

				icon = Material(hook.Run("GetPlayerIcon", speaker) or icon)

				chat.AddText(icon, Color(255, 50, 50), "[OOC] ", speaker, color_white, ": "..text)
			end,
			prefix = {"//", "/OOC"},
			description = "@cmdOOC",
			noSpaceAfter = true,
			font = "ixChatFontCustom",

		})

		ix.chat.Register("roll", {
			format = "** %s has rolled %s out of %s.",
			color = Color(155, 111, 176),
			CanHear = ix.config.Get("chatRange", 280),
			deadCanChat = true,
			OnChatAdd = function(self, speaker, text, bAnonymous, data)
				local max = data.max or 100
				local translated = L2(self.uniqueID.."Format", speaker:Name(), text, max)

				chat.AddText(self.color, translated and "** "..translated or string.format(self.format,
					speaker:Name(), text, max
				))
			end,
			font = "ixChatFontCustom",
		})
end

