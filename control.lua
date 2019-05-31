require "LSlib.lib"
require "src.debug"
require "src.help"
require "src.traindepot"
require "src.trainassembly"
require "src.traincontroller"

--Debug.enabled = true -- only when debugging

script.on_init(function(event)
  -- This is called once when a new save game is created or once
  -- when a save file is loaded that previously didn't contain the mod.
  Debug          :onInit()
  Help           :onInit()
  Traindepot     :onInit()
  Trainassembly  :onInit()
  Traincontroller:onInit()
end)



script.on_load(function()
  Traincontroller:onLoad()
end)



script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
  -- called when a mod setting changed
  Traincontroller:onSettingChanged(event)
end)



script.on_event(defines.events.on_player_created, function(event)
  -- Called after the new player was created.
  Debug              :onPlayerCreated(event.player_index)
  Traincontroller.Gui:onPlayerCreated(event.player_index)
end)



script.on_event(defines.events.on_player_left_game, function(event)
  -- Called after a player leaves the game.
  Help           .Gui:onPlayerLeftGame(event.player_index)
  Traindepot     .Gui:onPlayerLeftGame(event.player_index)
  Traincontroller.Gui:onPlayerLeftGame(event.player_index)
end)



script.on_event({defines.events.on_built_entity      ,
                 defines.events.on_robot_built_entity,
                 defines.events.script_raised_built  }, function(event)
  -- Called when an entity gets placed.
  local createdEntity = event.created_entity or event.entity
  if createdEntity and createdEntity.valid then
    local playerIndex = event.player_index
    Traindepot     :onBuildEntity(createdEntity)
    Trainassembly  :onBuildEntity(createdEntity, playerIndex)
    Traincontroller:onBuildEntity(createdEntity, playerIndex)
  end
end)



script.on_event({defines.events.on_player_mined_entity,
                 defines.events.on_robot_mined_entity ,
                 defines.events.on_entity_died        ,
                 defines.events.script_raised_destroy }, function(event)
  -- Called when an entity gets removed.
  local removedEntity = event.entity
  if removedEntity and removedEntity.valid then
    Traindepot     :onRemoveEntity(removedEntity)
    Trainassembly  :onRemoveEntity(removedEntity)
    Traincontroller:onRemoveEntity(removedEntity)
  end
end)



script.on_event(defines.events.on_player_rotated_entity, function(event)
  -- Called when player rotates an entity.
  local rotatedEntity = event.entity
  if rotatedEntity and rotatedEntity.valid then
    Trainassembly  :onPlayerRotatedEntity(rotatedEntity)
    Traincontroller:onPlayerRotatedEntity(rotatedEntity, event.player_index)
  end
end)



script.on_event(defines.events.on_entity_settings_pasted, function(event)
  -- Called after entity copy-paste is done.
  Trainassembly  :onPlayerChangedSettings(event.source     , event.destination )
  Traincontroller:onPlayerChangedSettings(event.destination, event.player_index)
end)



script.on_event(defines.events.on_entity_renamed, function(event)
  -- Called after an entity has been renamed either by the player or through script.
  Traincontroller:onRenameEntity(event.entity, event.old_name)
  Traindepot     :onRenameEntity(event.entity, event.old_name)
end)



script.on_event(defines.events.on_mod_item_opened, function(event)
  -- Called when the player opens a GUI.
  Help:onOpenItem(event.item, event.player_index)
end)



script.on_event(defines.events.on_gui_opened, function(event)
  -- Called when the player opens a GUI.
  Traindepot     .Gui:onOpenEntity(event.entity, event.player_index)
  Traincontroller.Gui:onOpenEntity(event.entity, event.player_index)
end)



script.on_event(defines.events.on_gui_closed, function(event)
  -- Called when the player closes a GUI.
  Help           .Gui:onCloseEntity(event.element, event.player_index)
  Traindepot     .Gui:onCloseEntity(event.element, event.player_index)
  Traincontroller.Gui:onCloseEntity(event.element, event.player_index)
  --Traincontroller.Gui:onCloseEntity(event.entity , event.player_index)
end)



script.on_event({--defines.events.on_gui_elem_changed           , -- Called when element value is changed (choose element button)
                 defines.events.on_gui_text_changed           , -- Called when text is changed by the player (textbox)
                 defines.events.on_gui_value_changed          , -- Called when slider value is changed (slider)
                 defines.events.on_gui_selection_state_changed, -- Called when selection state is changed (dropdown/listbox)
                 defines.events.on_gui_click                  }, function(event)
  -- Called when the player clicks on a GUI.
  Help           .Gui:onClickElement(event.element, event.player_index)
  Traindepot     .Gui:onClickElement(event.element, event.player_index)
  Traincontroller.Gui:onClickElement(event.element, event.player_index)
end)
