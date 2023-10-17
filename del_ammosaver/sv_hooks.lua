function PLUGIN:DoPlayerDeath(ply, attacker, dmg)
		if ix.config.Get("saveAmmoAfterDeath") then
			ply.del_ammoDeath = ply:GetAmmo()
			ply.del_ammoPlayerDeath = true
		end
	end

function PLUGIN:PlayerSpawn(ply)
	timer.Simple(0.25, function() 
		if ix.config.Get("saveAmmoAfterDeath") and ply and IsValid(ply) and ply.del_ammoPlayerDeath then
			for k, v in pairs(ply.del_ammoDeath) do
				ply:SetAmmo(v, k)
			end
			ply.del_ammoPlayerDeath = false
		end
	end)		
end