local PLUGIN = PLUGIN

function PLUGIN:PlayerMessageSend(speaker, chatType, text, anonymous, receivers, rawText)
	if speaker then
		local char = speaker:GetCharacter()
		local faction = char:GetFaction()
		if (chatType == "ic" or chatType == "w" or chatType == "y") and 
			(faction == FACTION_CITIZEN or (faction == FACTION_MPF and !char:GetData('CombineMask', true))) then
			-- local class = Schema.voices.GetClass(speaker)

			local info = Schema.voices.Get("Human", rawText)

			if (info) then
				local volume = 80

				if (chatType == "w") then
					volume = 60
				elseif (chatType == "y") then
					volume = 150
				end

				if (info.sound) then
					local snd
					if speaker:IsFemale() then
						snd = info.sound[2]
					else
						snd = info.sound[1]
					end
					if (info.global) then
						netstream.Start(nil, "PlaySound", snd)
					else
						local sounds = {snd}

						ix.util.EmitQueuedSounds(speaker, sounds, nil, nil, volume)
					end
				end

				return info.text
			end
		end
	end
end
