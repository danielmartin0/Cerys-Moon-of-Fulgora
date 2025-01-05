local Public = {}

local TEMPERATURE_LOSS_RATE = 3

function Public.tick_60_cool_entities(surface)
	local entities = surface.find_entities_filtered({
		type = { "heat-pipe", "boiler" },
	})

	for _, e in pairs(entities) do
		if e.valid and e.temperature > 15 then
			e.temperature = math.max(15, e.temperature - TEMPERATURE_LOSS_RATE)
		end
	end
end

return Public
