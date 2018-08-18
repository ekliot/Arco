extends Node

var _RIVER_ = preload( "res://battles/river.gd" )

const RIVER_IDS = [ 'a', 'b', 'c', 'd' ]

var FIGHTER = null
var RIVERS = {}

var active_momentum = 0
var active_moves = [ null ] # this expects dicts of { 'card': Card, 'river': String }

func _init( fighter ):
  FIGHTER = fighter
  for id in RIVER_IDS:
    var riv = _RIVER_.new( self, fighter, id )
    # TODO connect to signals
    RIVERS[id] = riv

# == SIGNAL HANDLING == #

# == CORE == #

func place_card( card, river ):
  pass

# == VALIDATORS == #

# this checks that these rivers can accept the card
#   - card must belong to the same fighter as the rivers
#   - this river's active momentum must be valid for the card's power level
func valid_for( card ):
  var valid = card.get_owner_id() == FIGHTER \
              and card.get_power() <= active_momentum + 1
  return valid

# this validates that a card can be placed into a specific river
func validate_play( card, river_id ):
  return valid_for( card ) and get_river( river_id ).valid_for( card )

# == GETTERS == #

func get_rivers():
  return RIVERS

func get_rivers_as_list():
  return RIVERS.values()

func get_river( id ):
  return RIVERS[id]

func get_river_step( id, lvl ):
  get_river( id ).get_step( lvl )

func get_active_momentum():
  return active_momentum

func get_move_at_momentum( lvl ):
  if lvl <= active_momentum:
    return active_moves[lvl]

  return null

func get_active_river_at_momentum( lvl ):
  var move = get_move_at_momentum( lvl )
  if move:
    return get_river( move.river )

  return null

func get_card_at_momentum( lvl ):
  var move = get_move_at_momentum( lvl )
  if move:
    return move.card

  return null

func get_valid_steps( card ):
  var steps = []

  if valid_for( card ):
    for river in get_rivers_as_list():
      var step = river.get_valid_step( card )
      if step:
        steps.push_back( step )

  return steps
