local VANILLA_FULGORA_STARMAP_ICON = "__space-age__/graphics/icons/starmap-planet-fulgora.png"
local MIN_MODDED_FULGORA_ICON_SIZE = 2048

local cerys_parent = data.raw.planet.cerys.orbit and data.raw.planet.cerys.orbit.parent
	and data.raw[data.raw.planet.cerys.orbit.parent.type][data.raw.planet.cerys.orbit.parent.name]

if not (cerys_parent and not cerys_parent.hidden) then
	log("[CERYS]: No parent found")
	data.raw["sprite"]["cerys-fulgora-background"] = nil
elseif cerys_parent.name ~= "fulgora" and data.raw[cerys_parent.type][cerys_parent.name].starmap_icon then
	log("[CERYS]: Non-Fulgora parent found")
	-- TODO: support starmap icons
	data.raw["sprite"]["cerys-fulgora-background"].filename = data.raw[cerys_parent.type][cerys_parent.name].starmap_icon
	data.raw["sprite"]["cerys-fulgora-background"].width = data.raw[cerys_parent.type][cerys_parent.name].starmap_icon_size
	data.raw["sprite"]["cerys-fulgora-background"].height = data
		.raw
		[cerys_parent.type]
		[cerys_parent.name]
		.starmap_icon_size
	data.raw["mod-data"]["Cerys"].data.fulgora_image_size = data
		.raw
		[cerys_parent.type]
		[cerys_parent.name]
		.starmap_icon_size
elseif data.raw.planet["fulgora"] and data.raw.planet["fulgora"].starmap_icon
	and data.raw.planet["fulgora"].starmap_icon ~= VANILLA_FULGORA_STARMAP_ICON then
	local icon_size = data.raw.planet["fulgora"].starmap_icon_size or 0
	if icon_size < MIN_MODDED_FULGORA_ICON_SIZE then
		log("[CERYS]: Modded Fulgora starmap icon too small (" .. icon_size .. "), using built-in image")
	else
		log("[CERYS]: Modded Fulgora starmap icon found")
		data.raw["sprite"]["cerys-fulgora-background"].filename = data.raw.planet["fulgora"].starmap_icon
		data.raw["sprite"]["cerys-fulgora-background"].width = icon_size
		data.raw["sprite"]["cerys-fulgora-background"].height = icon_size
		data.raw["mod-data"]["Cerys"].data.fulgora_image_size = icon_size
	end
end
