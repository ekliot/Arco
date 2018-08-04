extends Node

signal momentum_update # old, new

var _STEP_ = preload( "res://battles/river_step.gd" )

var FIGHTER = null
var STEPS = [ null ] # 1-indexed

var max_momentum = 0

func _init( rivers, fighter ):
  FIGHTER = fighter
  for i in range(4):
    var step = _STEP_.new( self, fighter, i+1 )
    # TODO connect to signals
    STEPS.push_back( step )

# == GETTERS == #

func get_steps():
  return STEPS

func get_step( level ):
  return STEPS[ level ]

func get_max_momentum():
  return max_momentum
