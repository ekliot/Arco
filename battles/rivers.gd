extends Node

signal momentum_update(old, new)

var _RIVER_ = preload( "res://battles/river.gd" )

var FIGHTER = null setget ,get_fighter
var RIVERS = {} setget ,get_rivers

var active_momentum = 0 setget ,get_active_momentum
var active_moves = [ null ] # this expects dicts of { 'card': Card, 'river': String }

func _init( fighter ):
  FIGHTER = fighter
  for id in battlemaster.RIVER_IDS:
    var riv = _RIVER_.new( fighter, self, id )
    riv.connect( 'momentum_update', self, '_on_momentum_change' )
    RIVERS[id] = riv

# == SIGNAL HANDLING == #

func _on_momentum_change( old, new ):
  # TODO this is kind of a shitshow, optimize this later
  var _new = 0

  for riv in RIVERS.values():
    if riv.max_momentum > _new:
      _new = riv.max_momentum

  if _new != active_momentum:
    var _old = active_momentum
    active_momentum = _new
    emit_signal( 'momentum_update', _old, _new )

# == CORE == #

func place_card( card, river_id ):
  get_river( river_id ).place_card( card )

# == VALIDATORS == #

func valid_for( card ):
  """
  this checks that these rivers can accept the card
    - card must belong to the same fighter as the rivers
    - this river's active momentum must be valid for the card's power level
  """
  var valid = card.get_owner_id() == FIGHTER \
              and card.get_power() <= active_momentum + 1
  return valid

func validate_play( card, river_id ):
  """
  this validates that a card can be placed into a specific river
  """
  return valid_for( card ) and get_river( river_id ).valid_for( card )

# == GETTERS == #

func get_fighter():
  return FIGHTER

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
