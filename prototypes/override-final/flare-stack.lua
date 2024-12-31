local find = require("lib").find
local common = require("common")
-- returns icon/icons always in the form of a table of icons
local function get_icons(prototype)
	if prototype.icons then
		return util.table.deepcopy(prototype.icons)
	else
		return {
			{
				icon = prototype.icon,
				icon_size = prototype.icon_size,
				icon_mipmaps = prototype.icon_mipmaps,
				draw_background = true,
			},
		}
	end
end
local no_icon = {
	icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/no.png",
	icon_size = 64,
}

local function fluid_name_is_flarable(name)
	if string.sub(name, 1, 10) == "parameter-" then
		return false
	end

	if name == "fluid-unknown" then
		return false
	end

	if name == "lava" then
		return false
	end

	return true
end

for _, vi in pairs(data.raw.fluid) do
	local newicons = get_icons(vi)
	table.insert(newicons, no_icon)

	if vi.gas_temperature or find(common.GAS_NAMES, vi.name) then
		data:extend({
			{
				type = "recipe",
				name = vi.name .. "-venting",
				localised_name = {
					"",
					vi.localised_name or { "fluid-name." .. vi.name },
					{ "cerys.venting-recipe-suffix" },
				},
				hidden_in_factoriopedia = true,
				hide_from_player_crafting = true,
				category = "gas-venting",
				enabled = true,
				energy_required = 1 / 5,
				ingredients = {
					{ type = "fluid", name = vi.name, amount = 10 },
				},
				results = {},
				icons = newicons,
				icon_size = 32,
				subgroup = "fluid-recipes",
				order = "z[venting]",
			},
		})
	else
		if fluid_name_is_flarable(vi.name) then
			data:extend({
				{
					type = "recipe",
					name = vi.name .. "-flaring",
					localised_name = {
						"",
						vi.localised_name or { "fluid-name." .. vi.name },
						{ "cerys.flaring-recipe-suffix" },
					},
					hidden_in_factoriopedia = true,
					hide_from_player_crafting = true,
					category = "flaring",
					enabled = true,
					energy_required = 1,
					ingredients = {
						{ type = "fluid", name = vi.name, amount = 10 },
					},
					results = {},
					icons = newicons,
					icon_size = 32,
					subgroup = "fluid-recipes",
					order = "z[flaring]",
				},
			})
		end
	end
end
