local lib = require("lib")
local common = require("common")

local radiative_heater = data.raw.reactor["cerys-radiative-heater"]
local radiative_heater_radius_vis = radiative_heater.radius_visualisation_specification
radiative_heater_radius_vis.distance_quality_multiplier = radiative_heater_radius_vis.distance_quality_multiplier or {}

for _, quality in pairs(data.raw.quality) do
	local player_heater_radius =
		math.min(common.MAX_HEATING_RADIUS, common.FULGORAN_RADIATIVE_TOWER_HEATING_RADIUS_PLAYER + quality.level)

	radiative_heater.custom_tooltip_fields[1].quality_values[quality.name] = {
		"cerys.metres-tooltip-value",
		tostring(player_heater_radius),
	}

	radiative_heater_radius_vis.distance_quality_multiplier[quality.name] = (player_heater_radius + 0.5)
		/ radiative_heater_radius_vis.distance

	data.raw.accumulator["cerys-charging-rod"].custom_tooltip_fields[1].quality_values[quality.name] =
		{ "cerys.kv-tooltip-value", tostring(100 * lib.calculate_max_polarity_fraction(quality.level)) }

	data.raw.reactor["cerys-fulgoran-reactor"].custom_tooltip_fields[1].quality_values[quality.name] = {
		"cerys.cooling-tooltip-value",
		tostring(common.REACTOR_COOLING_PER_SECOND * math.max(0.2, 1 - 0.1 * quality.level)),
	}
end
