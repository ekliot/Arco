extends Node

var _RIVER_ = preload( "res://battles/river.gd" )

const RIVER_IDS = [ 'a', 'b', 'c', 'd' ]

var FIGHTER = null
var RIVERS = {}

var active_momentum = 0
var active_moves = [] # this expects dicts of { 'card': Card, 'river': String }

func _init( fighter ):
  FIGHTER = fighter
  for id in RIVER_IDS:
    var riv = _RIVER_.new( self, fighter, id )
    # TODO connect to signals
    RIVERS[id] = riv

# == SIGNAL HANDLING == #

# == VALIDATORS == #

func valid_for( card ):
  var valid = card.get_owner_id() == FIGHTER \
              and card.get_power() <= active_momentum + 1
  return valid

# == GETTERS == #

func get_rivers():
  return RIVERS

func get_rivers_as_list():
  return RIVERS.values()

func get_river( id ):
  return RIVERS[id]

func get_active_momentum():
  return active_momentum

func get_move_at_momentum( level ):
  if level <= active_momentum:
    return active_moves[level-1]

  return null

func get_active_river_at_momentum( level ):
  var move = get_move_at_momentum( level )
  if move:
    return move.river

  return null

func get_card_at_momentum( level ):
  var move = get_move_at_momentum( level )
  if move:
    return move.card

  return null

func get_valid_steps( card ):
  var steps = []

  if valid_for( card ):
    for river in get_rivers_as_list():
      for step in river.get_valid_steps( card ):
        steps.push_back( step )

  return steps
