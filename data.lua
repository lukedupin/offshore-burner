-- Enhanced Offshore Pumps Mod
-- This mod adds burner and electric variants of offshore pumps
-- Compatible with Factorio 2.0

-- Create burner offshore pump (modify the original)
local burner_offshore_pump = table.deepcopy(data.raw["offshore-pump"]["offshore-pump"])
burner_offshore_pump.name = "burner-offshore-pump"
burner_offshore_pump.minable = {mining_time = 0.1, result = "burner-offshore-pump"}

-- Add brown tint to burner pump
burner_offshore_pump.tint = {r = 0.6, g = 0.4, b = 0.2, a = 1.0}

-- Add energy source for burner pump
burner_offshore_pump.energy_source = {
  type = "burner",
  fuel_categories = {"chemical"}, -- Changed from fuel_category to fuel_categories (array)
  effectivity = 1,
  fuel_inventory_size = 1,
  emissions_per_minute = {pollution = 10}, -- Updated emissions format for 2.0
  light_flicker = {
    color = {0.5, 0.5, 0.5},
    minimum_intensity = 0.6,
    maximum_intensity = 0.95
  },
  smoke = {
    {
      name = "smoke",
      deviation = {0.1, 0.1},
      frequency = 5,
      position = {0.0, -0.8},
      starting_vertical_speed = 0.08,
      starting_frame_deviation = 60
    }
  }
}
burner_offshore_pump.energy_usage = "30kW"

-- Create electric offshore pump
local electric_offshore_pump = table.deepcopy(data.raw["offshore-pump"]["offshore-pump"])
electric_offshore_pump.name = "electric-offshore-pump"
electric_offshore_pump.minable = {mining_time = 0.1, result = "electric-offshore-pump"}

-- Add bright yellow tint to electric pump
electric_offshore_pump.tint = {r = 1.0, g = 1.0, b = 0.0, a = 1.0}

-- Add energy source for electric pump
electric_offshore_pump.energy_source = {
  type = "electric",
  usage_priority = "secondary-input",
  emissions_per_minute = {pollution = 0} -- Updated emissions format for 2.0
}
electric_offshore_pump.energy_usage = "100kW"

-- Add both pumps to the game
data:extend({
  burner_offshore_pump,
  electric_offshore_pump
})

-- Create items for both pumps
data:extend({
  {
    type = "item",
    name = "burner-offshore-pump",
    icon = "__base__/graphics/icons/offshore-pump.png",
    icon_size = 64,
    subgroup = "energy-pipe-distribution",
    order = "b[pipe]-c[offshore-pump]-a[burner]",
    place_result = "burner-offshore-pump",
    stack_size = 20,
    weight = 20000, -- Added weight for 2.0
    default_import_location = "nauvis" -- Added for 2.0 space age compatibility
  },
  {
    type = "item",
    name = "electric-offshore-pump",
    icon = "__base__/graphics/icons/offshore-pump.png",
    icon_size = 64,
    subgroup = "energy-pipe-distribution",
    order = "b[pipe]-c[offshore-pump]-b[electric]",
    place_result = "electric-offshore-pump",
    stack_size = 20,
    weight = 25000, -- Added weight for 2.0
    default_import_location = "nauvis" -- Added for 2.0 space age compatibility
  }
})

-- Create recipes for both pumps
data:extend({
  {
    type = "recipe",
    name = "burner-offshore-pump",
    energy_required = 0.5,
    ingredients = {
      {type = "item", name = "iron-gear-wheel", amount = 2},
      {type = "item", name = "pipe", amount = 3},
      {type = "item", name = "stone-furnace", amount = 1}
    },
    results = {{type = "item", name = "burner-offshore-pump", amount = 1}}, -- Updated results format for 2.0
    enabled = false -- Changed to false, will be unlocked by steam power research
  },
  {
    type = "recipe",
    name = "electric-offshore-pump",
    energy_required = 2,
    ingredients = {
      {type = "item", name = "iron-gear-wheel", amount = 2},
      {type = "item", name = "pipe", amount = 3},
      {type = "item", name = "engine-unit", amount = 1}
    },
    results = {{type = "item", name = "electric-offshore-pump", amount = 1}}, -- Updated results format for 2.0
    enabled = false
  }
})

-- Safely add electric pump to engine technology
if data.raw["technology"]["engine"] and data.raw["technology"]["engine"].effects then
  table.insert(data.raw["technology"]["engine"].effects, {
    type = "unlock-recipe",
    recipe = "electric-offshore-pump"
  })
end

-- Add burner pump to steam power technology
if data.raw["technology"]["steam-power"] and data.raw["technology"]["steam-power"].effects then
  table.insert(data.raw["technology"]["steam-power"].effects, {
    type = "unlock-recipe",
    recipe = "burner-offshore-pump"
  })
end

-- Remove original offshore pump recipe (make burner the default)
if data.raw["recipe"]["offshore-pump"] then
  data.raw["recipe"]["offshore-pump"] = nil
end

-- Remove original offshore pump from steam power research and replace with burner version
for _, technology in pairs(data.raw.technology or {}) do
  if technology.effects then
    for _, effect in pairs(technology.effects) do
      if effect.type == "unlock-recipe" and effect.recipe == "offshore-pump" then
        effect.recipe = "burner-offshore-pump"
      end
    end
  end
end
