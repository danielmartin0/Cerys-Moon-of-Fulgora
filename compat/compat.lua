-- This override is because many mods add their science packs to all modded labs. If a mod wants to mark Cerys as a dependency and extend these inputs, that is fine.
data.raw.lab["cerys-lab"].inputs = {
	"automation-science-pack",
	"logistic-science-pack",
	"cerys-science-pack",
	"utility-science-pack",
}

data.raw.lab["cerys-lab-dummy"].inputs = {
	"fulgoran-cryogenics-progress",
}
data.raw.lab["cerys-lab-dummy"].next_upgrade = nil
data.raw.lab["cerys-lab"].next_upgrade = nil
data.raw.reactor["cerys-fulgoran-reactor"].next_upgrade = nil
data.raw["assembling-machine"]["cerys-fulgoran-cryogenic-plant"].next_upgrade = nil
