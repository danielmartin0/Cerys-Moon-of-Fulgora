if mods["aai-industry"] then
  for _,result in pairs(data.raw.recipe["cerys-nuclear-scrap-recycling"].results) do
    if result.name == "stone-brick" then
      result.name = "stone"
      break
    end
  end
end
