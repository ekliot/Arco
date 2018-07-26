extends VBoxContainer

var BATTLE = null

var enabled = true
var current_momentum = 0

# ===== #
# SETUP #
# ===== #

func set_battle( battle ):
  BATTLE = battle
  for riv in get_all_rivers():
    riv.set_battle( battle )

# ==== #
# CORE #
# ==== #

func reverse():
  # reverse each river
  pass

func can_place_card( card, river ):
  return enabled && get_river( river ).can_place_card( card )

func place_card( card, river ):
  var river_step = get_river_step( river, card.get_power() )
  river_step.place_card( card )

func enable():
  enabled = true

func disable():
  enabled = false

# ======= #
# GETTERS #
# ======= #

func is_enabled():
  return enabled

func get_all_rivers():
  var rivs = []
  for child in get_children():
    if child.has_method( 'set_battle' ): # HACK is there a better way to do this?
      rivs.push_back( child )
  return rivs

func get_river( river ):
  return get_node( river.to_upper() )

func get_river_step( river, momentum ):
  return get_river( river ).get_step( momentum )

# func get_current_momentum():
#   return get_active_cards().size()
#
# func get_active_cards():
#   return ACTIVE_CARDS
