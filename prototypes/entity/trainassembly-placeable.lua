
local trainassembly = util.table.deepcopy(data.raw["locomotive"]["locomotive"])
trainassembly.name = "trainassembly-placeable"

trainassembly.minable.result = "trainassembly" -- name of the item

-- copy localisation from the item
trainassembly.localised_name = util.table.deepcopy(data.raw["item"][trainassembly.minable.result].localised_name)
trainassembly.localised_description = util.table.deepcopy(data.raw["item"][trainassembly.minable.result].localised_description)

-- copy the icon over from the item
trainassembly.icon = util.table.deepcopy(data.raw["item"][trainassembly.minable.result].icon)
trainassembly.icons = util.table.deepcopy(data.raw["item"][trainassembly.minable.result].icons)
trainassembly.icon_size = util.table.deepcopy(data.raw["item"][trainassembly.minable.result].icon_size)
trainassembly.icon_mipmaps = util.table.deepcopy(data.raw["item"][trainassembly.minable.result].icon_mipmaps)

-- remove the placeable_off_grid flag
trainassembly.flags = trainassembly.flags or {}
for flagIndex, flagName in pairs(trainassembly.flags) do
  if flagName == "placeable-off-grid" then
    trainassembly.flags[flagIndex] = nil
  end
end
table.insert(trainassembly.flags, "hidden")

-- selection box
trainassembly.selection_box = {{-3, -3}, {3, 3}} -- when train is facing north
trainassembly.vertical_selection_shift = 0 -- correction for vertical tracks

-- collision masks
trainassembly.collision_mask =
{
  "train-layer", "player-layer", -- default layers
}
trainassembly.collision_box = {{-2.95, -3.9}, {2.95, 3.9}} -- when train is facing north

trainassembly.fast_replaceable_group = nil
trainassembly.next_upgrade = nil
trainassembly.max_health = data.raw["assembling-machine"]["assembling-machine-2"].max_health

-- make sure tracks are comming out on both sides
trainassembly.joint_distance = 5
-- make sure you cannot connect it to an actual train
trainassembly.connection_distance = -5
-- you can still connect a train to this, but not this to a train
-- no need to fix this becose this item gets replaced when its build.

-- drawing box (for graphics)
trainassembly.drawing_box = {{-5, -5}, {5, 5}} -- drawing box covering the extra tile

-- graphics
trainassembly.front_light = nil
trainassembly.back_light = nil
trainassembly.stand_by_light = nil
trainassembly.wheels = -- invisible wheels
{
  priority = "very-low",
  width = 1,
  height = 1,
  direction_count = 4,
  frame_count = 1,
  line_length = 1,
  lines_per_file = 1,
  filenames =
  {
    "__core__/graphics/empty.png",
    "__core__/graphics/empty.png",
    "__core__/graphics/empty.png",
    "__core__/graphics/empty.png",
  },
  hr_version = nil,
}
trainassembly.pictures =
{
  layers =
  {
    -- north and south
    {
      width = 512,
      height = 512,
      scale = 0.5,
      direction_count = 4,
      frame_count = 1,
      line_length = 1,
      lines_per_file = 1,
      scale = 0.5,
      shift = util.by_pixel(31.5, -18),
      filenames =
      {
        "__trainConstructionSite__/graphics/entity/trainassembly/trainassembly-N.png",
        "__trainConstructionSite__/graphics/entity/trainassembly/trainassembly-empty.png",
        "__trainConstructionSite__/graphics/entity/trainassembly/trainassembly-S.png",
        "__trainConstructionSite__/graphics/entity/trainassembly/trainassembly-empty.png",
      },
      hr_version = nil,
    },
    -- east and west
    {
      width = 512,
      height = 512,
      scale = 0.5,
      direction_count = 4,
      frame_count = 1,
      line_length = 1,
      lines_per_file = 1,
      scale = 0.5,
      shift = util.by_pixel(30, -28),
      filenames =
      {
        "__trainConstructionSite__/graphics/entity/trainassembly/trainassembly-empty.png",
        "__trainConstructionSite__/graphics/entity/trainassembly/trainassembly-E.png",
        "__trainConstructionSite__/graphics/entity/trainassembly/trainassembly-empty.png",
        "__trainConstructionSite__/graphics/entity/trainassembly/trainassembly-W.png",
      },
      hr_version = nil,
    },
  },
}

data:extend{
  trainassembly,
}
