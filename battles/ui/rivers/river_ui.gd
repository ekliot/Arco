extends HBoxContainer

const RiverStepUI = preload("river_step_ui.gd")

var MODEL = null
var STEPS = [ null ] # 1-indexed

# onready var RIVER_ID = get_name().to_lower()

func _ready():
  # for step in get_all_steps():
  #   step.RIVER_ID = get_name().to_lower()
  for child in get_children():
    # if child.has_method('connect_to_model'): # HACK
    if child is RiverStepUI:
      STEPS.push_back(child)

# == SETUP == #

func connect_to_model(river_model):
  MODEL = river_model
  for lvl in range(1,5):
    var step_model = river_model.get_step(lvl)
    get_step(lvl).connect_to_model(step_model)

# == CORE == #

func reverse():
  # reverse the order of RiverStep Nodes
  var reversed = []
  for c in get_children():
    reversed.push_front(c)
    remove_child(c)

  for c in reversed:
    add_child(c)

func place_card(card):
  var power = card.POWER
  get_step(power).place_card(card)

# == GETTERS == #

func get_step(level):
  return STEPS[level]

func get_all_steps():
  return STEPS

func get_valid_steps(card):
  var steps = []
  for step in MODEL.get_valid_steps(card):
    steps.push_back(get_step(step.get_momentum()))
