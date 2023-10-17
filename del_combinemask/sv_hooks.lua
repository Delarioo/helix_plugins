local PLUGIN = PLUGIN

function Schema:PlayerMessageSend(speaker, chatType, text, anonymous, receivers, rawText)
	return
end

function PLUGIN:CharacterLoaded(character)
	local ply = character:GetPlayer()
	if ply and ply:IsCombine() then
		ply:SetNetVar("CombineMask", character:GetData("CombineMask", true))
	end
end


function PLUGIN:PlayerMessageSend(speaker, chatType, text, anonymous, receivers, rawText)
	if ((chatType == "ic" or chatType == "w" or chatType == "y" or chatType == "dispatch")
		and speaker:IsCombine() and speaker:GetCharacter():GetData("CombineMask", true)) then
		local class = Schema.voices.GetClass(speaker)

		for k, v in ipairs(class) do
			local info = Schema.voices.Get(v, rawText)
			if (info) then
				local volume = 80

				if (chatType == "w") then
					volume = 60
				elseif (chatType == "y") then
					volume = 150
				end

				if (info.sound) then
					if (info.global) then
						netstream.Start(nil, "PlaySound", info.sound)
					else
						local sounds = {info.sound}
							speaker.bTypingBeep = nil
							if speaker:Team() == FACTION_MPF then
								sounds[#sounds + 1] = "NPC_MetroPolice.Radio.Off"
							else
								sounds[#sounds + 1] = "Vocoder.Off"
							end
						ix.util.EmitQueuedSounds(speaker, sounds, nil, nil, volume)
					end
				end
					return string.format("<:: %s ::>", info.text)
			end
		end	
		if ( speaker:GetCharacter():GetData("CombineMask", true)) then
			return string.format("<:: %s ::>", text)
		else return text
		end	
	end
end

function Schema:GetPlayerPainSound(client)
	return
end

function PLUGIN:GetPlayerPainSound(client)
	if (client:IsCombine() and client:GetCharacter():GetData("CombineMask", true)) then
		local sound = "NPC_MetroPolice.Pain"

		if (Schema:IsCombineRank(client:Name(), "SCN")) then
			sound = "NPC_CScanner.Pain"
		elseif (Schema:IsCombineRank(client:Name(), "SHIELD")) then
			sound = "NPC_SScanner.Pain"
		end

		return sound
	end
end

netstream.Hook("PlayerChatTextChanged", function(client, key)
	if !client.bTypingBeep then
		if (client:Team() == FACTION_MPF and client:GetCharacter():GetData("CombineMask", true)) then
			client:EmitSound("NPC_MetroPolice.Radio.On")
			client.bTypingBeep = true
		elseif (client:Team() == FACTION_OTA) then
			client:EmitSound("Vocoder.On")
			client.bTypingBeep = true
		end
	end
end)

netstream.Hook("PlayerFinishChat", function(client)
	if client.bTypingBeep then
		if (client:Team() == FACTION_MPF and client:GetCharacter():GetData("CombineMask", true)) then
			client:EmitSound("NPC_MetroPolice.Radio.Off")
			client.bTypingBeep = nil
		elseif (client:Team() == FACTION_OTA) then
			client:EmitSound("Vocoder.Off")
			client.bTypingBeep = nil
		end
	end
end)