local Public = {}

function Public.get_prototype(base_type, name)
	for type_name in pairs(defines.prototypes[base_type]) do
		local prototypes = data.raw[type_name]
		if prototypes and prototypes[name] then
			return prototypes[name]
		end
	end
end

function Public.get_item_localised_name(name)
	local item = Public.get_prototype("item", name)
	if not item then
		return
	end
	if item.localised_name then
		return item.localised_name
	end
	local prototype
	local type_name = "item"
	if item.place_result then
		prototype = Public.get_prototype("entity", item.place_result)
		type_name = "entity"
	elseif item.place_as_equipment_result then
		prototype = Public.get_prototype("equipment", item.place_as_equipment_result)
		type_name = "equipment"
	elseif item.place_as_tile then
		-- Tiles with variations don't have a localised name
		local tile_prototype = data.raw.tile[item.place_as_tile.result]
		if tile_prototype and tile_prototype.localised_name then
			prototype = tile_prototype
			type_name = "tile"
		end
	end
	return prototype and prototype.localised_name or { type_name .. "-name." .. name }
end

return Public
