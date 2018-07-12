extends Node

signal draw_card # card, hand, deck
signal discard_card # card, hand, discard

signal take_damage # new_hp, old_hp, max_hp
signal heal_damage # new_hp, old_hp, max_hp
signal died

signal momentum_inc # old_momentum, new_momentum
signal momentum_dec # old_momentum, new_momentum
signal combo_activate

var ID = 'CHARACTER_'

var HEALTH     = 0
var HEALTH_MAX = 0
var MOMENTUM   = 0
var DRAW_SIZE  = 4

var DECK      = []
var HAND      = []
var DISCARD   = []
# idx [1:4] correspond to momentum levels 1-4 ; idx 0 unused
var SIGNATURE = []

var SPRITE = null

# ======= #
# ACTIONS #
# ======= #

func draw_hand():
  for i in range( DRAW_SIZE ):
    draw_card()

func draw_card():
  if DECK.empty():
    DECK = DISCARD
    DISCARD.clear()
    DECK.shuffle()

  var card = DECK.draw()
  HAND.push_back( card )
  emit_signal( 'draw_card', card, HAND, DECK )

func clear_hand():
  for c in HAND:
    DISCARD.push_back( c )
    HAND.erase( c )
    emit_signal( 'discard_card', c, HAND, DISCARD )

func play_card( card, river ):
  print( ID, ' // ', 'playing card ', card, ' into river ', river )

  # TODO remove card from hand

  set_momentum( card.level )

func take_damage( amt ):
  HEALTH -= amt
  emit_signal( 'take_damage', HEALTH, HEALTH + amt, HEALTH_MAX )
  if HEALTH <= 0:
    emit_signal( 'died' )

func heal_damage( amt ):
  var old_hp = HEALTH
  HEALTH = min( HEALTH + amt, HEALTH_MAX )
  emit_signal( 'heal_damage', HEALTH, old_hp, HEALTH_MAX )

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
