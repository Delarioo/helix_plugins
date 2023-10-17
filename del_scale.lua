local PLUGIN = PLUGIN

PLUGIN.name = "del_Character Scaler"
PLUGIN.author = "Delarioo"
PLUGIN.description = "Добавляет возможность изменить размер модели.\n* /charsetscale"


//Меняем рост при загрузке персонажа.
function PLUGIN:CharacterLoaded(character)
	local ply = character:GetPlayer()
	local scale = character:GetData("charScale", 1)
	ply:SetModelScale(scale)
	ply:SetViewOffset(Vector(0,0, 64 * scale))
end

//Добавляем команду
do 
	local COMMAND = {}
	COMMAND.description = "Изменение размера модели от 90 до 107 %"
	COMMAND.arguments = {ix.type.character, ix.type.number}
	COMMAND.adminOnly = true
	function COMMAND:OnRun(client, character, scale)
		scale = scale * .01
		if scale >= 0.9 and scale <= 1.07 then
			character:SetData("charScale", scale)
			local ply = character:GetPlayer()
			ply:SetModelScale(scale, 0)
			ply:SetViewOffset(Vector(0,0, 64 * scale))
		else
			ix.util.Notify("Размер модели должен быть в диапозоне 90-107 %", client)
		end
	end

	ix.command.Add("charSetScale", COMMAND)
end
