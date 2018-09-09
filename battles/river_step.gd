extends Node

signal card_placed(card)
signal card_cleared(card)
signal card_activated(card)

var FIGHTER = null setget ,get_fighter
var RIVER = null setget ,get_river
var MOMENTUM_LEVEL = -1 setget ,get_momentum

var active_card = null setget place_card,get_active_card

func _init( fighter, river, level ):
  FIGHTER = fighter
  RIVER = river
  MOMENTUM_LEVEL = level

# == CORE == #

func place_card( card ):
  # TODO check for current active card
  active_card = card
  prints( "STEP\t// card", card, 'placed in', self )
  emit_signal( 'card_placed', card )

func clear_card( card ):
  active_card = null
  emit_signal( 'card_cleared', card )

func activate_card( card ):
  card.activate()
  emit_signal( 'card_activated', card )

# == VALIDATORS == #

func valid_for( card ):
  var valid = MOMENTUM_LEVEL == card.POWER
  return valid

# == GETTERS == #

func get_active_card():
  return active_card

func get_river():
  return RIVER

func get_river_id():
  return get_river().RIVER_ID

func get_fighter():
  return FIGHTER

func get_momentum():
  return MOMENTUM_LEVEL
