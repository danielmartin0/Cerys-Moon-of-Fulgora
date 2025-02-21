local Public = {}

function Public.merge(old, new)
	old = util.table.deepcopy(old)

	for k, v in pairs(new) do
		if v == "nil" then
			old[k] = nil
		else
			old[k] = v
		end
	end

	return old
end

Public.find = function(tbl, f, ...)
	if type(f) == "function" then
		for k, v in pairs(tbl) do
			if f(v, k, ...) then
				return v, k
			end
		end
	else
		for k, v in pairs(tbl) do
			if v == f then
				return v, k
			end
		end
	end
	return nil
end

function Public.excise_technology(tech_name)
	local tech = data.raw.technology[tech_name]
	if not tech then
		return
	end

	if tech.prerequisites and #tech.prerequisites > 0 then
		local first_prereq = tech.prerequisites[1]
		for _, other_tech in pairs(data.raw.technology) do
			if other_tech.prerequisites then
				for i, prereq in ipairs(other_tech.prerequisites) do
					if prereq == tech_name then
						other_tech.prerequisites[i] = first_prereq
					end
				end
			end
		end
	end

	for trick_name, trick in pairs(data.raw["tips-and-tricks-item"]) do
		if trick.trigger and trick.trigger.type == "research" and trick.trigger.technology == tech_name then
			data.raw["tips-and-tricks-item"][trick_name] = nil
			break
		end

		if
			trick.skip_trigger
			and trick.skip_trigger.type == "research"
			and trick.skip_trigger.technology == tech_name
		then
			trick.skip_trigger = nil
		end

		if trick.trigger and trick.trigger.type == "sequence" then
			local new_triggers = {}
			for _, trigger in ipairs(trick.trigger.triggers) do
				if not (trigger.type == "research" and trigger.technology == tech_name) then
					table.insert(new_triggers, trigger)
				end
			end
			trick.trigger.triggers = new_triggers
		end

		if trick.skip_trigger and trick.skip_trigger.type == "sequence" then
			local new_triggers = {}
			for _, trigger in ipairs(trick.skip_trigger.triggers) do
				if not (trigger.type == "research" and trigger.technology == tech_name) then
					table.insert(new_triggers, trigger)
				end
			end
			trick.skip_trigger.triggers = new_triggers
		end
	end

	data.raw.technology[tech_name] = nil
end

function Public.excise_recipe(name)
	for _, tech in pairs(data.raw.technology) do
		if tech.effects and #tech.effects > 0 then
			local new_effects = {}
			for _, effect in ipairs(tech.effects) do
				if not (effect.type == "unlock-recipe" and effect.recipe == name) then
					table.insert(new_effects, effect)
				end
			end
			tech.effects = new_effects

			if #tech.effects == 0 then
				Public.excise_technology(tech.name)
			end
		end
	end

	for trick_name, trick in pairs(data.raw["tips-and-tricks-item"]) do
		if trick.trigger and trick.trigger.type == "set-recipe" and trick.trigger.recipe == name then
			data.raw["tips-and-tricks-item"][trick_name] = nil
			break
		end

		if trick.skip_trigger and trick.skip_trigger.type == "set-recipe" and trick.skip_trigger.recipe == name then
			trick.skip_trigger = nil
		end

		if trick.trigger and trick.trigger.type == "sequence" then
			local new_triggers = {}
			for _, trigger in ipairs(trick.trigger.triggers) do
				if not (trigger.type == "set-recipe" and trigger.recipe == name) then
					table.insert(new_triggers, trigger)
				end
			end
			trick.trigger.triggers = new_triggers
		end

		if trick.skip_trigger and trick.skip_trigger.type == "sequence" then
			local new_triggers = {}
			for _, trigger in ipairs(trick.skip_trigger.triggers) do
				if not (trigger.type == "set-recipe" and trigger.recipe == name) then
					table.insert(new_triggers, trigger)
				end
			end
			trick.skip_trigger.triggers = new_triggers
		end
	end

	if data.raw.recipe[name] then
		data.raw.recipe[name] = nil
	end

	if data.raw.recipe[name .. "-recycling"] then
		data.raw.recipe[name .. "-recycling"] = nil
	end

	if data.raw.recipe["item-" .. name .. "-incineration"] then -- Flare stack compatibility
		data.raw.recipe["item-" .. name .. "-incineration"] = nil
	end
end

function Public.excise_item(type, name)
	for trick_name, trick in pairs(data.raw["tips-and-tricks-item"]) do
		if trick.trigger and trick.trigger.type == "craft-item" and trick.trigger.item == name then
			data.raw["tips-and-tricks-item"][trick_name] = nil
			break
		end

		if trick.skip_trigger and trick.skip_trigger.type == "craft-item" and trick.skip_trigger.item == name then
			trick.skip_trigger = nil
		end

		if trick.trigger and trick.trigger.type == "sequence" then
			local new_triggers = {}
			for _, trigger in ipairs(trick.trigger.triggers) do
				if not (trigger.type == "craft-item" and trigger.item == name) then
					table.insert(new_triggers, trigger)
				end
			end
			trick.trigger.triggers = new_triggers
		end

		if trick.skip_trigger and trick.skip_trigger.type == "sequence" then
			local new_triggers = {}
			for _, trigger in ipairs(trick.skip_trigger.triggers) do
				if not (trigger.type == "craft-item" and trigger.item == name) then
					table.insert(new_triggers, trigger)
				end
			end
			trick.skip_trigger.triggers = new_triggers
		end
	end

	if data.raw[type][name] then
		data.raw[type][name] = nil
	end
end

return Public
