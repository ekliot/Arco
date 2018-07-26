extends HBoxContainer

var BATTLE = null

onready var RIVER_ID = get_name().to_lower()

func _ready():
  for step in get_all_steps():
    step.RIVER_ID = get_name().to_lower()

# ===== #
# SETUP #
# ===== #

func set_battle( battle ):
  BATTLE = battle
  for step in get_all_steps():
    step.set_battle( battle )

# ==== #
# CORE #
# ==== #

func reverse():
  # reverse the order of RiverStep Nodes
  pass

func can_place_card( card ):
  return true
  # return get_step( card.get_power() ).is_playable()

func place_card( card ):
  var power = card.get_power()
  get_step( power ).place_card( card )

# ======= #
# GETTERS #
# ======= #

func get_step( level ):
  return get_node( String(level) )

func get_all_steps():
  var steps = []
  for child in get_children():
    if child.has_method( 'set_battle' ): # HACK
      steps.push_back( child )
  return steps
