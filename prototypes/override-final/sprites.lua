if
	settings.startup["cerys-use-fulgora-starmap-graphic"].value
	and data.raw.planet["fulgora"]
	and data.raw.planet["fulgora"].starmap_icon
then
	data.raw["sprite"]["fulgora-background"].filename = data.raw.planet["fulgora"].starmap_icon
	data.raw["sprite"]["fulgora-background"].width = data.raw.planet["fulgora"].starmap_icon_size
	data.raw["sprite"]["fulgora-background"].height = data.raw.planet["fulgora"].starmap_icon_size
	data.raw["mod-data"]["Cerys"].data.fulgora_image_size = data.raw.planet["fulgora"].starmap_icon_size
end
