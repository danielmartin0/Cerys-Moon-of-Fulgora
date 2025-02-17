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
