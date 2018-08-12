extends Node

signal momentum_update # old, new

var _STEP_ = preload( "res://battles/river_step.gd" )

var FIGHTER = null
var RIVER_ID = null
var STEPS = [ null ] # 1-indexed

var max_momentum = 0

func _init( rivers, fighter, id ):
  FIGHTER = fighter
  RIVER_ID = id
  for i in range(4):
    var step = _STEP_.new( self, fighter, i+1 )
    # TODO connect to signals
    STEPS.push_back( step )

# == GETTERS == #

func get_river_id():
  return RIVER_ID

func get_steps():
  return STEPS

func get_step( level ):
  return STEPS[ level ]

func get_max_momentum():
  return max_momentum

func get_valid_steps( card ):
  var steps = []
  for lvl in range(1,5):
    var step = get_step( lvl )
    if step.valid_for( card ):
      steps.push_back( step )

  return steps
