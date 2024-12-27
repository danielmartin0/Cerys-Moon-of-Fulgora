local function sound_variations_with_volume_variations(
	filename_string,
	variations,
	min_volume,
	max_volume,
	modifiers_parameter
)
	local result = {}
	for i = 1, variations do
		result[i] = {
			filename = filename_string .. "-" .. i .. ".ogg",
			min_volume = min_volume or 0.5,
			max_volume = max_volume or 0.5,
		}
		if modifiers_parameter then
			result[i].modifiers = modifiers_parameter
		end
	end
	return result
end

data:extend({
	{
		type = "explosion",
		name = "plutonium-explosion",
		localised_name = { "entity-name.explosion" },
		icons = {
			{ icon = "__base__/graphics/icons/explosion.png" },
			{ icon = "__base__/graphics/icons/cannon-shell.png" },
		},
		flags = { "not-on-map" },
		hidden = true,
		subgroup = "explosions",
		animations = {
			{
				filename = "__base__/graphics/entity/explosion/explosion-2.png",
				draw_as_glow = true,
				priority = "high",
				line_length = 16,
				width = 64,
				height = 57,
				frame_count = 16,
				animation_speed = 0.5,
				scale = 0.5,
				shift = util.by_pixel(-15, 10),
				usage = "explosion",
			},
		},
		sound = {
			aggregation = {
				max_count = 1,
				remove = true,
			},
			variations = sound_variations_with_volume_variations("__base__/sound/small-explosion", 5, 0.35, 0.45),
		},
	},
})
