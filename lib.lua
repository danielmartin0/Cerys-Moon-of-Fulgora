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

function Public.override_surface_conditions(recipe, conditions)
	if conditions.property then
		conditions = { conditions }
	end

	recipe.surface_conditions = recipe.surface_conditions or {}

	for _, condition in pairs(conditions) do
		for i = #recipe.surface_conditions, 1, -1 do
			local existing_condition = recipe.surface_conditions[i]
			if existing_condition.property == condition.property then
				table.remove(recipe.surface_conditions, i)
			end
		end
		table.insert(recipe.surface_conditions, condition)
	end
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

local version_pattern = "%d+"
local version_format = "%02d"

function Public.format_version(version, format)
	if version then
		format = format or version_format
		local tbl = {}
		for v in string.gmatch(version, version_pattern) do
			tbl[#tbl + 1] = string.format(format, v)
		end
		if next(tbl) then
			return table.concat(tbl, ".")
		end
	end
	return nil
end

function Public.is_newer_version(old_version, current_version, format)
	if current_version and not old_version then
		return true
	end

	local v1 = Public.format_version(old_version, format)
	local v2 = Public.format_version(current_version, format)

	if v1 and v2 then
		if v2 > v1 then
			return true
		end
		return false
	end
	return nil
end

return Public
