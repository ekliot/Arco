extends VBoxContainer

const _RIVERUI_ = preload("river_ui.gd")

var MODEL = null

# == SETUP == #

func connect_to_model(rivers_model):
  MODEL = rivers_model
  MODEL.connect('momentum_update', self, '_on_momentum_update')
  # propogate to child UI elements
  for id in BM.RIVER_IDS:
    var riv_model = rivers_model.get_river(id)
    get_river(id).connect_to_model(riv_model)

func connect_to_card_pointer(card, pointer):
  for step in get_valid_steps(card):
    step.connect('pointer_lockon', pointer, 'lock_to')
    step.connect('pointer_unlock', pointer, 'unlock')

# == SIGNALS == #

func _on_momentum_update(old, new):
  pass

# == CORE == #

func reverse():
  for river in get_all_rivers():
    river.reverse()

func valid_for(card):
  return MODEL.valid_for(card)

func can_place_card(card, river):
  return valid_for(card) && MODEL.can_place_card(card, river)

func place_card(card, river):
  # var river_step = get_river_step(river, card.POWER)
  # river_step.place_card(card)
  pass

# == GETTERS == #

func get_all_rivers():
  # TODO
  var rivs = []
  for child in get_children():
    # if child.has_method('connect_to_model'): # HACK is there a better way to do this?
    if child is _RIVERUI_:
      rivs.push_back(child)
  return rivs

func get_river(id):
  return get_node(id.to_upper())

func get_river_step(id, momentum):
  return get_river(id).get_step(momentum)

func get_river_step_by_model(step_model):
  return get_river_step(step_model.get_river_id(), step_model.get_momentum())

func get_valid_steps(card):
  var steps = []

  for step in MODEL.get_valid_steps(card):
    steps.push_back(get_river_step_by_model(step))

  return steps
