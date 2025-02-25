data.raw.item["solid-fuel"].fuel_category = "chemical-or-radiative"

data.raw.item["stone-brick"].place_as_tile.condition.layers["cerys_tile"] = true
data.raw.item["stone-brick"].place_as_tile.condition_size = data.raw.item["stone-brick"].place_as_tile.condition_size
	+ 1

table.insert(data.raw.item["foundation"].place_as_tile.tile_condition, "cerys-water-puddles")
table.insert(data.raw.item["foundation"].place_as_tile.tile_condition, "cerys-water-puddles-freezing")

table.insert(data.raw.item["ice-platform"].place_as_tile.tile_condition, "cerys-water-puddles")
table.insert(data.raw.item["ice-platform"].place_as_tile.tile_condition, "cerys-water-puddles-freezing")
