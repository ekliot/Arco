extends Node

signal card_placed(card, lvl)
signal momentum_update(old, new)
signal step_activated(who, level, card)

var _STEP_ = preload( "res://battles/river_step.gd" )

var FIGHTER = null setget ,get_fighter
var RIVERS = null setget, get_rivers
var RIVER_ID = null setget ,get_river_id
var STEPS = [ null ] setget ,get_steps # 1-indexed

var states = [ null ] # keep track of which cards are in each step

var max_momentum = 0 setget ,get_max_momentum

func _init( fighter, rivers, id ):
  FIGHTER = fighter
  RIVERS = rivers
  RIVER_ID = id
  for i in range( 1, 5 ):
    var step = _STEP_.new( fighter, self, i )
    STEPS.push_back( step )
    states.push_back( null )

# == SIGNALS == #

# == CORE == #

func clear_card( card ):
  var lvl = card.POWER
  states[lvl] = null

  prints( 'RIVER\t//', card, ' cleared for lvl ', lvl )

  emit_signal( 'card_cleared', card, RIVER_ID )
  _update_momentum()

func place_card( card ):
  var lvl = card.POWER
  states[lvl] = card

  prints( 'RIVER\t//', card, 'set for lvl', lvl )

  get_step( lvl ).place_card( card )
  emit_signal( 'card_placed', card, RIVER_ID )
  _update_momentum()

func _update_momentum():
  var last_m = max_momentum

  for lvl in range( 1, states.size() ):
    if states[lvl]:
      max_momentum = lvl

  if last_m != max_momentum:
    prints( "RIVER\t// momentum updated to", max_momentum, "from", last_m )
    emit_signal( 'momentum_update', last_m, max_momentum )

# == VALIDATORS == #

func valid_for( card ):
  # TODO this should check with other cards in the lane for certain conditions
  # e.g. if a card at step 2 says "only blades cards can be played in this lane"
  return get_valid_step( card ) != null

# == GETTERS == #

func get_rivers():
  return RIVERS

func get_fighter():
  return FIGHTER

func get_river_id():
  return RIVER_ID

func get_steps():
  return STEPS

func get_step( lvl ):
  return STEPS[ lvl ]

func get_max_momentum( refresh=False ):
  if refresh:
    _update_momentum()
  return max_momentum

func get_valid_step( card ):
  var step = get_step( card.POWER )
  if step.valid_for( card ):
    return step
  else:
    return null

func get_card_at_step( lvl ):
  return states[lvl]
