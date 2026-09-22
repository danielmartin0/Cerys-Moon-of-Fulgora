if helpers.compare_versions(helpers.game_version, "2.1.20") < 0 then
	data.raw.item["solid-fuel"].fuel_category = "chemical-or-radiative"
else
	table.insert(data.raw.item["solid-fuel"].fuel_categories, "chemical-or-radiative")
end

-- NOTE: Do we still need this now that we can make frozen tile variants?
data.raw.item["stone-brick"].place_as_tile.condition.layers["cerys_tile"] = true

-- table.insert(data.raw.item["foundation"].place_as_tile.tile_condition, "cerys-water-puddles")
-- table.insert(data.raw.item["foundation"].place_as_tile.tile_condition, "cerys-water-puddles-freezing")

-- table.insert(data.raw.item["ice-platform"].place_as_tile.tile_condition, "cerys-water-puddles")
-- table.insert(data.raw.item["ice-platform"].place_as_tile.tile_condition, "cerys-water-puddles-freezing")
