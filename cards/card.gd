extends Node

signal played
signal activated
signal discarded

var OWNER = ""

var ID = "CARD_"
var TITLE = ""
var SUIT = ""
var POWER = -1
var DESCRIPTION = ""
var ICON = null

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
