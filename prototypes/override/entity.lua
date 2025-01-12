table.insert(data.raw.planet.fulgora.lightning_properties.priority_rules, {
	type = "prototype",
	string = "charging-rod",
	priority_bonus = 250,
})

local pipe_picture = assembler3pipepictures()
pipe_picture.north = util.empty_sprite()
pipe_picture.south.filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/centrifuge/centrifuge-pipe-S.png"
pipe_picture.east.filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/centrifuge/centrifuge-pipe-E.png"
pipe_picture.west.filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/centrifuge/centrifuge-pipe-W.png"

local fluid_boxes = {
	{
		production_type = "input",
		pipe_picture = pipe_picture,
		pipe_covers = pipecoverspictures(),
		volume = 1000,
		pipe_connections = { { flow_direction = "input", direction = defines.direction.north, position = { 0, -1 } } },
	},
	{
		production_type = "output",
		pipe_picture = pipe_picture,
		pipe_covers = pipecoverspictures(),
		volume = 1000,
		pipe_connections = { { flow_direction = "output", direction = defines.direction.south, position = { 0, 1 } } },
	},
}

-- Ensure centrifuges can accept fluid recipes. It isn't ideal that we change modded centrifuges this way, as the fluid boxes may be in the wrong positions, but on the other hand they're only visible when fluid recipes are used.
for _, machine in pairs(data.raw["assembling-machine"]) do
	if machine.crafting_categories and not machine.fluid_boxes then
		for _, category in pairs(machine.crafting_categories) do
			if category == "centrifuging" then
				machine.fluid_boxes = util.table.deepcopy(fluid_boxes)
				machine.fluid_boxes_off_when_no_fluid_recipe = true
				break
			end
		end
	end
end

--== Flare stack ==--

if settings.startup["cerys-disable-flare-stack-item-venting"].value then
	data.raw.furnace["electric-incinerator"].hidden = true
	data.raw.furnace["incinerator"].hidden = true
end
