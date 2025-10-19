local cerys_parent = data.raw.planet.cerys.orbit
	and data.raw.planet.cerys.orbit.parent
	and data.raw[data.raw.planet.cerys.orbit.parent.type][data.raw.planet.cerys.orbit.parent.name]

if not (cerys_parent and not cerys_parent.hidden) then
	log("[CERYS]: No parent found")
	data.raw["sprite"]["cerys-fulgora-background"] = nil
elseif cerys_parent.name ~= "fulgora" and data.raw[cerys_parent.type][cerys_parent.name].starmap_icon then
	log("[CERYS]: Non-Fulgora parent found")
	-- TODO: support starmap icons
	data.raw["sprite"]["cerys-fulgora-background"].filename =
		data.raw[cerys_parent.type][cerys_parent.name].starmap_icon
	data.raw["sprite"]["cerys-fulgora-background"].width =
		data.raw[cerys_parent.type][cerys_parent.name].starmap_icon_size
	data.raw["sprite"]["cerys-fulgora-background"].height =
		data.raw[cerys_parent.type][cerys_parent.name].starmap_icon_size
	data.raw["mod-data"]["Cerys"].data.fulgora_image_size =
		data.raw[cerys_parent.type][cerys_parent.name].starmap_icon_size
elseif
	settings.startup["cerys-use-fulgora-starmap-graphic"].value
	and data.raw.planet["fulgora"]
	and data.raw.planet["fulgora"].starmap_icon
then
	data.raw["sprite"]["cerys-fulgora-background"].filename = data.raw.planet["fulgora"].starmap_icon
	data.raw["sprite"]["cerys-fulgora-background"].width = data.raw.planet["fulgora"].starmap_icon_size
	data.raw["sprite"]["cerys-fulgora-background"].height = data.raw.planet["fulgora"].starmap_icon_size
	data.raw["mod-data"]["Cerys"].data.fulgora_image_size = data.raw.planet["fulgora"].starmap_icon_size
end
