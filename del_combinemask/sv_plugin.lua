local PLUGIN = PLUGIN

function PLUGIN:OnCharacterCreated(client, character)
	if character:IsCombine() and character:GetData('CombineMask') == nil then
		character:SetData('CombineMask', true)
		client:SetNetVar("CombineMask", true)
		if character:GetFaction() == FACTION_MPF then
			character:SetData('mask', 1)
			local groups = {}
			groups[1] = 0
			groups[2] = 1
			groups[3] = 1
			character:SetData('groups', groups)
			character:Save()
		end
	end
end
 