if mods["lignumis"] and not mods["cerys-lunaponics"] then
	error(
		"\n\nPlaying Cerys alongside Lignumis requires installing the mod Wooden Cerys: Lunaponics (https://mods.factorio.com/mod/cerys-lunaponics).\n\nPlease download and install this mod from the Mod Portal.\n"
	)
end

if (mods["wood-logistics"] and mods["fulgora-coralmium-agriculture"]) and not mods["cerys-lunaponics"] then
	error(
		"\n\nPlaying Cerys alongside Wooden Logistics and Wooden Fulgora requires installing the mod Wooden Cerys: Lunaponics (https://mods.factorio.com/mod/cerys-lunaponics).\n\nPlease download and install this mod from the Mod Portal.\n"
	)
end
