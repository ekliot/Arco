extends Node

signal take_damage
signal heal_damage

signal momentum_inc # old_momentum, new_momentum
signal momentum_dec # old_momentum, new_momentum
signal combo_activate

var ID = 'CHARACTER_'

var HEALTH = 0
var MOMENTUM = 0

var DECK = []
var HAND = []
# idx [1:4] correspond to momentum levels 1-4
var SIGNATURE = []

var RIVERS = {}
var ACTIVE = []

var MINIONS = {}

func _ready():
  for r in get_rivers():
    RIVERS[r.get_name().to_lower()] = r

func play_card( card, river ):
  print( ID, ' // ', 'playing card ', card, ' into river ', river )

  print( ID, ' // ', 'removing top ', MOMENTUM - card.level, ' cards' )
  for i in range( MOMENTUM - card.level ):
    var data = ACTIVE.pop()

    print( ID, ' // ', 'removing card ', data.card, ' from river ', data.river )
    RIVERS[data.river].remove_card( data.card.level )

  ACTIVE.push_back( { 'card': card, 'river': river } )
  RIVERS[river].add_card( card )
  print( ID, ' // ', 'added card ', card, ' into river ', river )

  set_momentum( card.level )

# ======= #
# HELPERS #
# ======= #

func set_momentum( lvl ):
  if lvl < MOMENTUM:
    emit_signal( 'momentum_dec', MOMENTUM, lvl )
  elif lvl > MOMENTUM:
    emit_signal( 'momentum_inc', MOMENTUM, lvl )

  MOMENTUM = lvl
  print( ID, ' // ', 'set momentum to ', lvl, ' from ', MOMENTUM )

func get_rivers():
  return RIVERS
