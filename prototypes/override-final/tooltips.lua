local common = require("common")

for _, quality in pairs(data.raw.quality) do
	data.raw.reactor["cerys-radiative-tower"].custom_tooltip_fields[1].quality_values[quality.name] = {
		"cerys.metres-tooltip-value",
		tostring(common.FULGORAN_RADIATIVE_TOWER_HEATING_RADIUS_PLAYER + quality.level),
	}
	data.raw.accumulator["cerys-charging-rod"].custom_tooltip_fields[1].quality_values[quality.name] =
		{ "cerys.kv-tooltip-value", tostring(math.max(50, 100 - quality.level * 5)) }
end
