local lib = require("lib")
local common = require("common")

for _, quality in pairs(data.raw.quality) do
	data.raw.reactor["cerys-radiative-tower"].custom_tooltip_fields[1].quality_values[quality.name] = {
		"cerys.metres-tooltip-value",
		tostring(
			math.min(common.MAX_HEATING_RADIUS, common.FULGORAN_RADIATIVE_TOWER_HEATING_RADIUS_PLAYER + quality.level)
		),
	}

	data.raw.accumulator["cerys-charging-rod"].custom_tooltip_fields[1].quality_values[quality.name] =
		{ "cerys.kv-tooltip-value", tostring(100 * lib.calculate_max_polarity_fraction(quality.level)) }

	data.raw.reactor["cerys-fulgoran-reactor"].custom_tooltip_fields[1].quality_values[quality.name] = {
		"cerys.cooling-tooltip-value",
		tostring(common.REACTOR_COOLING_PER_SECOND * (1 - 0.1 * quality.level)),
	}
end
