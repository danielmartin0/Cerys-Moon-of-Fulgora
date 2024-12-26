local merge = require("lib").merge

data:extend({
	merge(data.raw["simple-entity"]["lithium-iceberg-huge"], {
		name = "cerys-methane-iceberg-huge",
		collision_box = { { -1.75, -1.15 }, { 1.75, 1.15 } },
		order = "b[decorative]-l[rock]-p[methane-iceberg]-a[huge]",
		minable = merge(data.raw["simple-entity"]["lithium-iceberg-huge"].minable, {
			mining_time = data.raw["simple-entity"]["lithium-iceberg-huge"].minable.mining_time * 0.4,
			results = {
				{ type = "item", name = "methane-ice", amount_min = 8, amount_max = 15 },
			},
		}),
		autoplace = {
			probability_expression = "cerys_methane_iceberg_large",
		},
		pictures = {
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/dry-iceberg/dry-iceberg-huge/dry-iceberg-huge-2.png",
				width = 444,
				height = 310,
				scale = 0.5,
				shift = { 0.65, -0.75 },
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/dry-iceberg/dry-iceberg-huge/dry-iceberg-huge-5.png",
				width = 444,
				height = 310,
				scale = 0.5,
				shift = { 1.15, -0.75 },
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/dry-iceberg/dry-iceberg-huge/dry-iceberg-huge-7.png",
				width = 444,
				height = 310,
				scale = 0.5,
				shift = { 0.95, -0.25 },
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/dry-iceberg/dry-iceberg-huge/dry-iceberg-huge-11.png",
				width = 444,
				height = 310,
				scale = 0.5,
				shift = { 0.65, -0.75 },
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/dry-iceberg/dry-iceberg-huge/dry-iceberg-huge-12.png",
				width = 444,
				height = 310,
				scale = 0.5,
				shift = { 0.65, -0.75 },
			},
		},
	}),
})

data:extend({
	merge(data.raw["simple-entity"]["lithium-iceberg-big"], {
		name = "cerys-methane-iceberg-big",
		order = "b[decorative]-l[rock]-p[methane-iceberg]-b[big]",
		collision_box = { { -1.75, -1.15 }, { 1.75, 1.15 } },
		minable = merge(data.raw["simple-entity"]["lithium-iceberg-big"].minable, {
			mining_time = data.raw["simple-entity"]["lithium-iceberg-big"].minable.mining_time * 0.4,
			results = {
				{ type = "item", name = "methane-ice", amount_min = 5, amount_max = 6 },
			},
		}),
		autoplace = {
			probability_expression = "cerys_methane_iceberg_large",
		},
		pictures = {
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/dry-iceberg/dry-iceberg-big/dry-iceberg-big-1.png",
				width = 230,
				height = 154,
				scale = 0.5,
				shift = { 0.1, -0.25 },
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/dry-iceberg/dry-iceberg-big/dry-iceberg-big-2.png",
				width = 230,
				height = 154,
				scale = 0.5,
				shift = { 0, -0.25 },
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/dry-iceberg/dry-iceberg-big/dry-iceberg-big-3.png",
				width = 230,
				height = 154,
				scale = 0.5,
				shift = { 0, -0.25 },
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/dry-iceberg/dry-iceberg-big/dry-iceberg-big-4.png",
				width = 230,
				height = 154,
				scale = 0.5,
				shift = { 0, -0.25 },
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/dry-iceberg/dry-iceberg-big/dry-iceberg-big-5.png",
				width = 230,
				height = 154,
				scale = 0.5,
				shift = { 0.75, -0.25 },
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/dry-iceberg/dry-iceberg-big/dry-iceberg-big-6.png",
				width = 230,
				height = 154,
				scale = 0.5,
				shift = { 0, -0.0 },
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/dry-iceberg/dry-iceberg-big/dry-iceberg-big-7.png",
				width = 230,
				height = 154,
				scale = 0.5,
				shift = { 0.1, -0.25 },
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/dry-iceberg/dry-iceberg-big/dry-iceberg-big-8.png",
				width = 230,
				height = 154,
				scale = 0.5,
				shift = { 0, 0.05 },
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/dry-iceberg/dry-iceberg-big/dry-iceberg-big-9.png",
				width = 230,
				height = 154,
				scale = 0.5,
				shift = { 0.2, -0.25 },
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/dry-iceberg/dry-iceberg-big/dry-iceberg-big-10.png",
				width = 230,
				height = 154,
				scale = 0.5,
				shift = { -0.3, -0.25 },
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/dry-iceberg/dry-iceberg-big/dry-iceberg-big-11.png",
				width = 230,
				height = 154,
				scale = 0.5,
				shift = { 0, -0.35 },
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/dry-iceberg/dry-iceberg-big/dry-iceberg-big-12.png",
				width = 230,
				height = 154,
				scale = 0.5,
				shift = { 0.4, -0.35 },
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/dry-iceberg/dry-iceberg-big/dry-iceberg-big-13.png",
				width = 230,
				height = 154,
				scale = 0.5,
				shift = { 0, -0.35 },
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/dry-iceberg/dry-iceberg-big/dry-iceberg-big-14.png",
				width = 230,
				height = 154,
				scale = 0.5,
				shift = { 0, -0.35 },
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/dry-iceberg/dry-iceberg-big/dry-iceberg-big-15.png",
				width = 230,
				height = 154,
				scale = 0.5,
				shift = { 0, -0.25 },
			},
		},
	}),
})
