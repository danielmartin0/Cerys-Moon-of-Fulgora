data.raw['recipe']['uranium-238-recycling']['surface_conditions'] = { {property="magnetic-field", max=119} } -- balance change i think?

data.raw['recipe']['pipe-recycling']['ingredients'] = { {type='item', name='pipe', amount=1} }
data.raw['recipe']['pipe-recycling']['results'] = {
	{type='item', name='iron-plate', amount=0, extra_count_fraction=0.25}
}

data.raw['recipe']['heat-pipe-recycling']['ingredients'] = { {type='item', name='heat-pipe', amount=1} }
data.raw['recipe']['heat-pipe-recycling']['results'] = {
	{type='item', name='steel-plate', amount=2, extra_count_fraction=0.5},
	{type='item', name='copper-plate', amount=5}
}

data.raw['recipe']['beacon-recycling']['ingredients'] = { {type='item', name='beacon', amount=1} }
data.raw['recipe']['beacon-recycling']['results'] = {
	{type='item', name='electronic-circuit', amount=5},
	{type='item', name='advanced-circuit', amount=5},
	{type='item', name='steel-plate', amount=2, extra_count_fraction=0.5},
	{type='item', name='copper-cable', amount=2, extra_count_fraction=0.5},
}

data.raw['recipe']['steam-turbine-recycling']['ingredients'] = { {type='item', name='steam-turbine', amount=1} }
data.raw['recipe']['steam-turbine-recycling']['results'] = {
	{type='item', name='iron-gear-wheel', amount=12, extra_count_fraction=0.5},
	{type='item', name='copper-plate', amount=12, extra_count_fraction=0.5},
	{type='item', name='pipe', amount=5},
}


data.raw['recipe']['centrifuge-recycling']['ingredients'] = { {type='item', name='centrifuge', amount=1} }
data.raw['recipe']['centrifuge-recycling']['results'] = {
	{type='item', name='concrete', amount=25},
	{type='item', name='steel-plate', amount=12, extra_count_fraction=0.5},
	{type='item', name='advanced-circuit', amount=25},
	{type='item', name='iron-gear-wheel', amount=25},
}

data.raw['recipe']['iron-gear-wheel-recycling']['ingredients'] = { {type='item', name='iron-gear-wheel', amount=1} }
data.raw['recipe']['iron-gear-wheel-recycling']['results'] = {
	{type='item', name='iron-plate', amount=0, extra_count_fraction=0.5}
}

data.raw['recipe']['copper-cable-recycling']['ingredients'] = { {type='item', name='copper-cable', amount=1} }
data.raw['recipe']['copper-cable-recycling']['results'] = {
	{type='item', name='copper-plate', amount=0, extra_count_fraction=0.5}
}

data.raw['recipe']['electronic-circuit-recycling']['ingredients'] = { {type='item', name='electronic-circuit', amount=1} }
data.raw['recipe']['electronic-circuit-recycling']['results'] = {
	{type='item', name='iron-plate', amount=0, extra_count_fraction=0.25},
	{type='item', name='copper-cable', amount=0, extra_count_fraction=0.75}
}

local recycleintoitself = {'solid-fuel', 'steel-plate', 'copper-plate', 'iron-plate', 'stone-brick', 'plastic-bar', 'holmium-plate', 'uranium-235'}

local recycle_chance = 0.25
if mods['modified-productivity-cap'] then --crossmod compatibility!!!
	if settings.startup["modify-recycling-recipes"].value then
		local max_prod = (settings.startup["new-productivity-cap"].value/100) + 1
		recycle_chance = math.min(1/max_prod, 0.75)
	end
end


for i = 1, #recycleintoitself do
	data.raw['recipe'][recycleintoitself[i] .. '-recycling']['ingredients'] = { {type='item', name=recycleintoitself[i], amount=1} }
	data.raw['recipe'][recycleintoitself[i] .. '-recycling']['results'] = {
		{type='item', name=recycleintoitself[i], amount=0, extra_count_fraction=recycle_chance}
	}
end

 

