local common = require("common")
local cooling = require("scripts.cooling")

local surface = game.surfaces["cerys"]
if not (surface and surface.valid) then
	return
end

if not storage.cerys then
	return
end

if storage.cerys.heat_entities then
	storage.cerys.heat_entities = nil
end

if not storage.cerys.heat_pipes then
	storage.cerys.heat_pipes = {}
end
if not storage.cerys.boilers then
	storage.cerys.boilers = {}
end

local stretch_factor = common.get_cerys_surface_stretch_factor(surface)

local heat_entities = surface.find_entities_filtered({
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

for _, entity in pairs(heat_entities) do
	if entity.valid then
		if entity.type == "heat-pipe" then
			cooling.register_heat_pipe(entity)
		elseif entity.type == "boiler" then
			cooling.register_boiler(entity)
		end
	end
end
