extends Node

signal ready(who) # THIS MUST ONLY EMIT ONCE THE CHARACTER IS READY TO BEGIN A NEW TURN
signal end_turn  # THIS MUST ONLY EMIT AFTER EVERYTHING IS SAID AND DONE
signal play_card(card)
signal drew_card(card)
signal discard_card(card)

# signal take_damage(new_hp, old_hp, max_hp)
# signal heal_damage(new_hp, old_hp, max_hp)

# signal momentum_inc(old, new)
# signal momentum_dec(old, new)
# signal combo_activate # TODO combo signal args

var _DECK_ = preload( "res://cards/deck.gd" )
var _HAND_ = preload( "res://cards/hand.gd" )
var _DISCARD_ = preload( "res://cards/discard.gd" )

var ID = 'CHARACTER_'

var HEALTH     = 0
var HEALTH_MAX = 0
var MOMENTUM   = 0
var DRAW_SIZE  = 4

var DECK      = null
var HAND      = null
var DISCARD   = null
# idx [1:4] correspond to momentum levels 1-4 ; idx 0 unused
var SIGNATURE = [] # TODO signature.gd

var SPRITE = null

func _init( data, rivers, minions ):
  HAND = _HAND_.new()
  add_child( HAND )
  HAND.name = 'Hand'

  DISCARD = _DISCARD_.new()
  add_child( DISCARD )
  DISCARD.name = 'Discard'

  connect( 'drew_card', HAND, 'add_card' )
  # connect( 'play_card', HAND, 'remove_card' )
  connect( 'discard_card', HAND, 'remove_card' )

  slurp_data( data )

  add_child( rivers )
  rivers.name = 'Rivers'
  rivers.connect( 'momentum_update', self, 'set_momentum' )
  # TODO add_child( minion ) for minion in minions

func slurp_data( data ):
  var stats = data.stats
  var cards = data.cards

  ID += data.id

  HEALTH = stats.health
  HEALTH_MAX = stats.health_max
  DRAW_SIZE = stats.draw_size

  DECK = cards.deck
  add_child( DECK )
  DECK.name = 'Deck'

  SIGNATURE = cards.signature

  SPRITE = data.sprite
  # add_child( SPRITE )
  # SPRITE.name = 'Sprite'

# == SIGNALS == #

func _on_turn_start( battle ):
  draw_hand()

func _on_turn_end( battle ):
  var who = BM.HERO if self.name == BM.fighter_id_to_str( BM.HERO ) else BM.CPU
  emit_signal( 'ready', who )

# == MOVES == #

func play_card( card, river ):
  print( ID, ' // ', 'playing card ', card, ' into river ', river )
  # remove the card from our hand
  HAND.remove_card( card )
  # place the card into its river
  $Rivers.place_card( card, river )
  # tell the card it's been played
  card.play( BM.get_board(), river )
  # let the world know!
  emit_signal( 'play_card', card )
  # make sure the battle has confirmed our move and all is well
  yield()
  # tell the world we are done with our turn
  end_turn()

# we expect this to be extended by heroes and enemies
func end_turn():
  clear_hand()

# == ACTIONS == #

func draw_hand():
  # prints( ID, "// drawing new hand of size", DRAW_SIZE )
  # TODO make sure there are cards to draw from the deck
  # to_draw = min( DRAW_SIZE, DECK.size() )
  for i in range( DRAW_SIZE ):
    print( ID, " // drawing card ", i )
    draw_card()

func draw_card():
  if DECK.is_empty() and not DISCARD.is_empty():
    print( ID, " // reshuffling discard into deck" )
    # TODO emit a signal here for the UI
    DECK.cards = DISCARD.cards
    DISCARD.clear()
    DECK.shuffle()

  # TODO double check the deck...

  var card = DECK.draw()
  print( ID, " // drew card ", card.name )
  emit_signal( 'drew_card', card )

func clear_hand():
  print( ID, " // clearing hand" )
  for c in HAND.get_cards():
    discard_card( c )

func discard_card( card ):
  if not HAND.is_empty() and HAND.has( card ):
    emit_signal( 'discard_card', card )
    var _discard = yield( HAND, 'card_removed' )[0] # card_removed returns [card, hand]
    DISCARD.add_card( _discard )
    # print( ID, " // discarded card ", _discard.name )

func take_damage( amt ):
  HEALTH -= amt
  # emit_signal( 'take_damage', HEALTH, HEALTH + amt, HEALTH_MAX )
  if HEALTH <= 0:
    emit_signal( 'died' )

func heal_damage( amt ):
  var old_hp = HEALTH
  HEALTH = min( HEALTH + amt, HEALTH_MAX )
  # emit_signal( 'heal_damage', HEALTH, old_hp, HEALTH_MAX )

func set_momentum( old, new ):
  print( ID, ' // ', 'setting momentum to ', new, ' from ', old )
  MOMENTUM = new

  if old < new:
    # emit_signal( 'momentum_dec', MOMENTUM, lvl )
    # signature_check()
    pass
  elif old > new:
    # emit_signal( 'momentum_inc', MOMENTUM, lvl )
    pass

# == HELPERS == #

func validate_play( card, river ):
  return get_rivers().validate_play( card, river )

func get_rivers():
  return $Rivers

func get_sprite():
  return SPRITE

func get_hand():
  return HAND.cards

func get_deck():
  return DECK.cards

func get_valid_moves():
  var moves = []

  for card in HAND.cards:
    if card.POWER <= MOMENTUM + 1:
      moves.push_back( card )

  return moves
