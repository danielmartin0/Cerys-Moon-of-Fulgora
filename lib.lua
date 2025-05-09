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

function Public.remove_surface_condition(entity, condition)
	if entity.surface_conditions then
		local conditions = table.deepcopy(entity.surface_conditions)
		local changed = false
		for i = #conditions, 1, -1 do
			local c = conditions[i]
			if type(condition) == "string" then
				if c.property == condition then
					table.remove(conditions, i)
					changed = true
				end
			elseif
				(c.property and condition.property and c.property == condition.property)
				and (not (condition.min or c.min) or (condition.min and c.min and c.min == condition.min))
				and (not (condition.max or c.max) or (condition.max and c.max and c.max == condition.max))
			then
				table.remove(conditions, i)
				changed = true
			end
		end

		if changed then
			entity.surface_conditions = conditions
		end
	end
end

return Public
