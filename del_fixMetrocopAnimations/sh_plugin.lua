local PLUGIN = PLUGIN

PLUGIN.name = "del_fix metrocop animations"
PLUGIN.author = "Delarioo"

function PLUGIN:UpdateAnimation(ply, mv, speed)
	local class = ix.anim.GetModelClass(ply:GetModel())
	if class == "metrocop" then 
		local vel = mv:Length2D()
		local activity = ply:GetSequenceName(ply:GetSequence())
		-- if tab[activity] and vel > 0.5 then
		if vel > 0.5 and activity:find("walk_") then
			local cSpeed = math.Clamp(vel* 0.8 / speed, 0.1, 1.5)
			ply:SetPlaybackRate(cSpeed)
			return true
		end
	end
end