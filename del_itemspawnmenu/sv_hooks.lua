util.AddNetworkString("del_spawnItem")

net.Receive("del_spawnItem", function(len,ply)
	if CAMI.PlayerHasAccess(ply, "Helix - SpawnItems", nil) then
		if !ply and !ply:Alive() and ply:InVehicle() then return end
		local item_id = net.ReadString()
		local bInventory = net.ReadBool()
		if bInventory then
			local target = net.ReadEntity()
			if !target and !IsValid(target) and !target:IsPlayer() and !target:Alive() then return end
			local inventory = target:GetCharacter():GetInventory()
			local bAdded = inventory:Add(item_id)
			if bAdded then
				ix.log.Add(ply, "del_spawnItemInventory", item_id, target)
			else
				ply:Notify("Вы не можете добавить этот предмет в инвентарь этого персонажа. Возможно, там не хватает места.")
			end
		else
			-- local spawnposition = ply:GetPos() + ply:GetForward()*72
			local traceData = {
				start = ply:GetShootPos(),
				endpos = ply:GetShootPos()+ply:EyeAngles():Forward()*96,
				filter = ply
			}
			local tracePos = util.TraceLine(traceData).HitPos + angle_zero:Up()*5
			ix.item.Spawn(item_id, tracePos)
			ix.log.Add(ply, "del_spawnItem", item_id)
		end

	end
end)

ix.log.AddType("del_spawnItem", function(client, item)
	return string.format("%s заспавнил \"%s\".", client:Name(), item)
end)

ix.log.AddType("del_spawnItemInventory", function(client, item, target)
	return string.format("%s добавил в инвентарь персонажа '%s': \"%s\".", client:Name(), item, target:Name())
end)