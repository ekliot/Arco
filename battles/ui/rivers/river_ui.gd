extends HBoxContainer

var MODEL = null

# onready var RIVER_ID = get_name().to_lower()

func _ready():
  # for step in get_all_steps():
  #   step.RIVER_ID = get_name().to_lower()
  pass

# == SETUP == #

func connect_to_model( river_model ):
  MODEL = river_model
  for step in range(4):
    var step_model = river_model.get_step( step+1 )
    get_step( step+1 ).connect_to_model( step_model )

# == CORE == #

func reverse():
  # reverse the order of RiverStep Nodes
  pass

func can_place_card( card ):
  return true
  # return get_step( card.get_power() ).is_playable()

func place_card( card ):
  var power = card.get_power()
  get_step( power ).place_card( card )

# == GETTERS == #

func get_step( level ):
  return get_node( String(level) )

func get_all_steps():
  var steps = []
  for child in get_children():
    if child.has_method( 'connect_to_model' ): # HACK
      steps.push_back( child )
  return steps
