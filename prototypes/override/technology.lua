if settings.startup["cerys-infinite-braking-technology"].value then
	if
		data.raw.technology["braking-force-7"]
		and not (
			data.raw.technology["braking-force-7"].max_level
			and data.raw.technology["braking-force-7"].max_level == "infinite"
		)
	then
		data.raw.technology["braking-force-7"].max_level = "infinite"
		data.raw.technology["braking-force-7"].unit.count_formula = "2^(L-7)*"
			.. data.raw.technology["braking-force-7"].unit.count
		data.raw.technology["braking-force-7"].unit.count = nil
	end
end
