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

function Public.restrict_surface_conditions(recipe_or_entity, conditions)
	conditions = util.table.deepcopy(conditions)
	if conditions.property then
		conditions = { conditions }
	end

	local surface_conditions = recipe_or_entity.surface_conditions
			and util.table.deepcopy(recipe_or_entity.surface_conditions)
		or {}

	for _, condition in pairs(conditions) do
		for i = 1, #surface_conditions do
			local existing = surface_conditions[i]
			if existing.property == condition.property then
				if condition.min ~= nil then
					if existing.min ~= nil then
						existing.min = math.max(existing.min, condition.min)
					else
						existing.min = condition.min
					end
				end

				if condition.max ~= nil then
					if existing.max ~= nil then
						existing.max = math.min(existing.max, condition.max)
					else
						existing.max = condition.max
					end
				end
				goto continue
			end
		end
		-- No existing condition found, add new one
		table.insert(surface_conditions, {
			property = condition.property,
			min = condition.min,
			max = condition.max,
		})
		::continue::
	end

	recipe_or_entity.surface_conditions = surface_conditions
end

function Public.relax_surface_conditions(recipe_or_entity, conditions)
	conditions = util.table.deepcopy(conditions)

	if conditions.property then
		conditions = { conditions }
	end

	local surface_conditions = recipe_or_entity.surface_conditions
			and util.table.deepcopy(recipe_or_entity.surface_conditions)
		or {}

	for _, condition in pairs(conditions) do
		for i = 1, #surface_conditions do
			local existing_condition = surface_conditions[i]
			if existing_condition.property == condition.property then
				if condition.min ~= nil and existing_condition.min ~= nil then
					existing_condition.min = math.min(existing_condition.min, condition.min)
				end

				if condition.max ~= nil and existing_condition.max ~= nil then
					existing_condition.max = math.max(existing_condition.max, condition.max)
				end
			end
		end
	end

	recipe_or_entity.surface_conditions = surface_conditions
end

function Public.cerys_research_unit(count)
	return {
		count = count,
		ingredients = {
			{ "automation-science-pack", 1 },
			{ "logistic-science-pack", 1 },
			{ "cerys-science-pack", 1 },
		},
		time = 60,
	}
end

function Public.cerys_tech(args)
	local science_count = args.science_count or 500

	local ret = Public.merge({
		type = "technology",
		icon = "__space-age__/graphics/technology/research-productivity.png",
		icon_size = 256,
	}, args)

	if not args.research_trigger and not args.unit then
		ret.unit = Public.cerys_research_unit(science_count)
	end

	return ret
end

return Public
