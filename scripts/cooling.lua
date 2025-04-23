local common = require("common")

local Public = {}

local TEMPERATURE_LOSS_RATE = 0.6

function Public.tick_300_find_heat_entities(surface)
	local stretch_factor = common.get_cerys_surface_stretch_factor(surface)

	storage.cerys.heat_entities = surface.find_entities_filtered({
		type = { "heat-pipe", "boiler" },
		area = {
			left_top = {
				x = -common.CERYS_RADIUS * 1.2 * stretch_factor,
				y = -common.CERYS_RADIUS * 1.2 / stretch_factor,
			},
			right_bottom = {
				x = common.CERYS_RADIUS * 1.2 * stretch_factor,
				y = common.CERYS_RADIUS * 1.2 / stretch_factor,
			},
		},
	})
end

function Public.tick_60_cool_heat_entities()
	if not storage.cerys.heat_entities then
		return
	end

	local i = 1
	while i <= #storage.cerys.heat_entities do
		local e = storage.cerys.heat_entities[i]
		if e.valid and e.temperature then
			if e.temperature > 15 then
				e.temperature = math.max(15, e.temperature - TEMPERATURE_LOSS_RATE)
			end
			i = i + 1
		else
			table.remove(storage.cerys.heat_entities, i)
		end
	end
end

return Public
