local itemOverride   = require("prototypes/modded-trains-item-override")
local recipeOverride = require("prototypes/modded-trains-recipe-override")

-- For each train-like entity we want to create a recipe so we can put this in
-- our trainbuilding to make an actual train on the tracks. To get the fluidname
-- we require the itemname. To aquire the itemname we get the entity.minable.result.
-- For this we start to iterate over all tine train types
local trainsToIgnore = require("prototypes/modded-trains-to-ignore")
for _, trainType in pairs({
  "locomotive",
  "cargo-wagon",
  "fluid-wagon",
  "artillery-wagon",
}) do
  -- For each type, we get all the different entities (ex: locomotive mk1, mk2, ...)
  for _, trainEntity in pairs(data.raw[trainType]) do
    -- For each entity, we get the item name. The item name is stored in minable.result
    if (not trainsToIgnore[trainType][trainEntity.name]) and trainEntity.minable and trainEntity.minable.result then

      local itemName = itemOverride[trainType][trainEntity.name] or trainEntity.minable.result
      local item = data.raw["item-with-entity-data"][itemName] or data.raw["item"][itemName]

      -- now that we have the itemname we can create the fluid recipe.
      data:extend{
        {
          type = "recipe",
          name = trainEntity.name .. "-fluid[" .. trainType .. "]",
          category = "trainassembling",
          expensive = nil,
          normal =
          {
            enabled = false,
            energy_required = 15,
            ingredients =
            {
              {itemName, 1},
            },
            results =
            {
              {
                type    = "fluid",
                name    = itemName .. "-fluid",
                amount  = 1,
              },
            },
            main_product = itemName .. "-fluid",
            always_show_products = true,
          },
        }
      }

      -- Now we created recipes only requiring the item. If this is a locomotive
      -- we will also require fuel to start the engine.
      if trainType == "locomotive" then
        -- This is a locomotive, add another ingredient to the list for fuel
        table.insert(data.raw["recipe"][trainEntity.name .. "-fluid[" .. trainType .. "]"].normal.ingredients, {"trainassembly-recipefuel", 1})
      end

      -- Now we update the existing recipe. We need to update the localised_name...
      local recipeName = recipeOverride[trainType][trainEntity.name] or itemName
      if item then
        LSlib.recipe.setLocalisedName(recipeName, util.table.deepcopy(item.localised_name))
        LSlib.recipe.setMainResult(recipeName, itemName)
        LSlib.recipe.setShowProduct(recipeName, true)
      end
    end
  end
end


if data.raw["item-with-entity-data"]["locomotive-manual-build"] then
  data:extend{{
    type = "recipe",
    name = "locomotive-manual-build",
    category = "manual-crafting",
    expensive = nil,
    normal =
    {
      enabled = false,
      energy_required = 5,
      always_show_made_in = true,
      ingredients =
      {
        {"locomotive", 1},
      },
      result = "locomotive-manual-build",
    },
  }}
end
