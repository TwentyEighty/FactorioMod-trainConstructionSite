require "util"

local trainTech = util.table.deepcopy(data.raw["technology"]["railway"])

trainTech.name = "trainassembly-trainTechnology"
trainTech.effects = {}
trainTech.localised_name = {"technology-name.trainTech"}
trainTech.localised_description = {"technology-description.trainTech"}
trainTech.prerequisites = {"railway", "engine", "logistics-2"}

for _, trainRecipe in pairs ({
  "locomotive",
  "cargo-wagon",
}) do
  table.insert(trainTech.effects,
  {
    type = "unlock-recipe",
    recipe = trainRecipe,
  })
  table.insert(trainTech.effects,
  {
    type = "unlock-recipe",
    recipe = trainRecipe .. "-fluid[" .. trainRecipe .. "]",
  })
end

for techName, techPrototype in pairs(data.raw["technology"]) do
  if techPrototype.effects then
    for techEffectIndex, techEffect in pairs(techPrototype.effects) do
      if techEffect.type == "unlock-recipe" then
        for _, wagonName in pairs({
          "fluid-wagon",
          "artillery-wagon",
        }) do
          if techEffect.recipe == wagonName then
            table.insert(data.raw["technology"][techName].effects, techEffectIndex + 1,
            {
              type = "unlock-recipe",
              recipe = wagonName .. "-fluid[" .. wagonName .. "]",
            })
          end
        end
      end
    end
  end
end

if data.raw["technology"]["railway"].prerequisites then
  for prerequisitesIndex, prerequisite in pairs(data.raw["technology"]["railway"].prerequisites) do
    if prerequisite == "engine" then
      data.raw["technology"]["railway"].prerequisites[prerequisitesIndex] = nil
    else
      if prerequisite == "logistics-2" then
        data.raw["technology"]["railway"].prerequisites[prerequisitesIndex] = "logistics"
      end
    end
  end
end

for _, prerequisitesName in pairs{
  "automation-2",
  "steel-processing",
} do
  table.insert(data.raw["technology"]["railway"].prerequisites, prerequisitesName)
end

if data.raw["technology"]["railway"].effects then
  for effectIndex, effect in pairs(data.raw["technology"]["railway"].effects) do
    if effect.type == "unlock-recipe"
    and (effect.recipe == "locomotive" or effect.recipe == "cargo-wagon") then
      data.raw["technology"]["railway"].effects[effectIndex] = nil -- this removes that single unlock
    end
  end

else
  data.raw["technology"]["railway"].effects = {}
end

for _, recipeName in pairs{
  "trainassembly",
  "trainassembly-trainfuel-raw-wood",
} do
  table.insert(data.raw["technology"]["railway"].effects,
  {
    type = "unlock-recipe",
    recipe = recipeName,
  })
end

if data.raw["technology"]["braking-force-1"].prerequisites then
  for brakePrerequisiteIndex, brakePrerequisite in pairs(data.raw["technology"]["braking-force-1"].prerequisites) do
    if brakePrerequisite == "railway" then
      data.raw["technology"]["braking-force-1"].prerequisites[brakePrerequisiteIndex] = trainTech.name
      break
    end
  end
end

data:extend(
{
  {
    type = "technology",
    name = "trainfuel-2",
    localised_name = {"technology-name.trainfuel", "trainassemblyfuel", "coal"},
    icon_size = 128,
    icon = "__trainConstructionSite__/graphics/placeholders/2x2.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "trainassembly-trainfuel-coal",
      },
    },
    prerequisites =
    {
      "railway",
    },
    unit =
    {
      count = 75,
      ingredients = util.table.deepcopy(data.raw["technology"]["railway"].unit.ingredients),
      time = 10,
    },
    order = "c-g-a-b",
  },
  {
    type = "technology",
    name = "trainfuel-3",
    localised_name = {"technology-name.trainfuel", "trainassemblyfuel", "solid-fuel"},
    icon_size = 128,
    icon = "__trainConstructionSite__/graphics/placeholders/2x2.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "trainassembly-trainfuel-solid-fuel",
      },
    },
    prerequisites =
    {
      "oil-processing",
      "trainfuel-2",
    },
    unit =
    {
      count = 100,
      ingredients = util.table.deepcopy(data.raw["technology"]["oil-processing"].unit.ingredients),
      time = 10,
    },
    order = "c-g-a-c",
  },
  {
    type = "technology",
    name = "trainfuel-4",
    localised_name = {"technology-name.trainfuel", "trainassemblyfuel", "rocket-fuel"},
    icon_size = 128,
    icon = "__trainConstructionSite__/graphics/placeholders/2x2.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "trainassembly-trainfuel-rocket-fuel",
      },
    },
    prerequisites = {"trainfuel-3", "rocket-silo"},
    unit =
    {
      count = 75,
      ingredients = util.table.deepcopy(data.raw["technology"]["automation-3"].unit.ingredients),

      time = 30,
    },
    order = "c-g-a-d",
  },
  {
    type = "technology",
    name = "trainfuel-5",
    localised_name = {"technology-name.trainfuel", "trainassemblyfuel", "nuclear-fuel"},
    icon_size = 128,
    icon = "__trainConstructionSite__/graphics/placeholders/2x2.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "trainassembly-trainfuel-nuclear-fuel",
      },
    },
    prerequisites = {"trainfuel-4", "kovarex-enrichment-process"},
    unit =
    {
      count = 500,
      ingredients = util.table.deepcopy(data.raw["technology"]["kovarex-enrichment-process"].unit.ingredients),
      time = 60,
    },
    order = "c-g-a-e",
  },
})

data:extend({
  trainTech,
})