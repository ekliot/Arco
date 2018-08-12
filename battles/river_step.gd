extends Node

signal card_placed # who, level, card
signal card_cleared # who, level, card
signal card_activated # who, level, card

var RIVER = null
var FIGHTER = null
var MOMENTUM_LEVEL = -1

var active_card = null

func _init( river, fighter, level ):
  RIVER = river
  FIGHTER = fighter
  MOMENTUM_LEVEL = level

# == CORE == #

func place_card( card ):
  active_card = card
  emit_signal( 'card_placed', FIGHTER, MOMENTUM_LEVEL, card )

func clear_card( card ):
  emit_signal( 'card_cleared', FIGHTER, MOMENTUM_LEVEL, card )

func activate_card( card ):
  emit_signal( 'card_activated', FIGHTER, MOMENTUM_LEVEL, card )

# == VALIDATORS == #

func valid_for( card ):
  var valid = MOMENTUM_LEVEL == card.get_power()
  # TODO
  # return valid
  return true

# == GETTERS == #

func get_active_card():
  return active_card

func get_river():
  return RIVER

func get_river_id():
  return get_river().get_river_id()

func get_fighter():
  return FIGHTER

func get_momentum():
  return MOMENTUM_LEVEL
