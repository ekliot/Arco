extends Node

signal played
signal activated
signal discarded

var OWNER = ""

var ID = "CARD_" # unique ID for the card, going CARD_<SUIT>_<NAME>
var TITLE = ""   # human-readable display name
var SUIT = -1    # corresponds to SUITS enum in cards/suits.gd
var POWER = -1   # power level of the card
var DESCRIPTION = ""

func play( board, river ):
  _onplay( board, river )
  emit_signal( 'played', self )

func activate( board, river ):
  _onactivate( board, river )
  emit_signal( 'activated', self )

func discard( board, river ):
  _ondiscard( board, river )
  emit_signal( 'discarded', self )

# ============= #
# OVERRIDEABLES #
# ============= #

func _onplay( board ):
  pass

func _onactivate( board ):
  pass

func _ondiscard( board ):
  pass

# ======= #
# GETTERS #
# ======= #

func get_title():
  return TITLE

func get_suit():
  return SUIT

func get_suit_as_str():
  return card_suits.NAMES[SUIT]

func get_power():
  return POWER

func get_description():
  return DESCRIPTION
