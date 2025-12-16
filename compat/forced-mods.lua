local has_WU_mods = mods["wood-logistics"] and mods["fulgora-coralmium-agriculture"]
local has_lignumis_directors_cut = mods["lignumis-cf"]
local has_lunaponics = mods["cerys-lunaponics"]

if has_WU_mods and not has_lunaponics then
	error(
		"\n\nPlaying Cerys alongside Wooden Logistics and Wooden Fulgora requires installing the mod Wooden Cerys: Lunaponics (https://mods.factorio.com/mod/cerys-lunaponics).\n\nPlease download and install this mod from the Mod Portal.\n"
	)
end

if has_lignumis_directors_cut and not has_lunaponics then
	error(
		"\n\nPlaying Cerys alongside Lignumis: Director's Cut requires installing the mod Wooden Cerys: Lunaponics (https://mods.factorio.com/mod/cerys-lunaponics).\n\nPlease download and install this mod from the Mod Portal.\n"
	)
end
