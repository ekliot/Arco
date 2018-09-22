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
  _set_hand()
  _set_discard()

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

  _set_deck( cards.deck )

  SIGNATURE = cards.signature

  SPRITE = data.sprite
  # add_child( SPRITE )
  # SPRITE.name = 'Sprite'

func _set_hand():
  HAND = _HAND_.new()
  add_child( HAND )
  HAND.name = 'Hand'

func _set_deck( deck ):
  DECK = deck
  add_child( DECK )
  DECK.name = 'Deck'

func _set_discard():
  DISCARD = _DISCARD_.new()
  add_child( DISCARD )
  DISCARD.name = 'Discard'

# == SIGNALS == #

func _on_turn_start( battle ):
  draw_hand()

func _on_turn_end( battle ):
  var who = BM.HERO if self.name == BM.fighter_id_to_str( BM.HERO ) else BM.CPU
  emit_signal( 'ready', who )

# == MOVES == #

func play_card( card, river ):
  LOGGER.debug( self, "playing card %s into river %s" % [card.ID, river] )
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
    LOGGER.debug( self, "drawing card %d" % i )
    draw_card()

func draw_card():
  if DECK.is_empty() and not DISCARD.is_empty():
    LOGGER.debug( self, "reshuffling discard into deck" )
    # TODO emit a signal here for the UI
    DISCARD.transfer( DECK )
    DECK.shuffle()

  # TODO double check the deck isn't empty...

  var card = DECK.draw()
  if card:
    LOGGER.debug( self, "drew card %s" % card.name )
    emit_signal( 'drew_card', card )
  else:
    LOGGER.debug( self, '!!!!!! DREW null FROM THEIR DECK OH DEAR' )

func clear_hand():
  LOGGER.debug( self, "clearing hand" )
  for c in HAND.get_cards():
    discard_card( c )

func discard_card( card ):
  if HAND.has( card ):
    emit_signal( 'discard_card', card )
    var _discard = yield( HAND, 'card_removed' )[0] # card_removed returns [card, hand]
    DISCARD.add_card( _discard )
    LOGGER.debug( self, "discarded card %s" % _discard.name )

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
  LOGGER.debug( self, "setting momentum to %d from %d" % [new, old] )
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
