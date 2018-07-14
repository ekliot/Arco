extends Node

signal turn_start # Battle
signal turn_end # Battle
signal game_over # winner

signal card_played # who, card, river
signal card_activated # who, card, river
signal card_removed # who, card, river

enum FIGHTERS { HERO, CPU }
enum MOVES { PLAY, SWAP, PASS }
const MAX_MOMENTUM = 4

var BOARD = {
  HERO: {
    'root': null,
    'minions': { 'a' : null, 'b' : null, 'c' : null, 'd' : null },
    'rivers':  { 'a' : [],   'b' : [],   'c' : [],   'd' : [] },
    'active_cards': [] # this expects dicts of { 'card': Card, 'river': String }
  },

  CPU: {
    'root': null,
    'minions': { 'a' : null, 'b' : null, 'c' : null, 'd' : null },
    'rivers':  { 'a' : [],   'b' : [],   'c' : [],   'd' : [] },
    'active_cards': [] # this expects dicts of { 'card': Card, 'river': String }
  }
}

var CUR_MOMENTUM = 0

# we need to be able to dynamically load different battle scenarios

func _init():
  pass

func _ready():
  # TEMP
  setup( {
    'enemies': {
      'root': preload( "res://characters/enemies/enemy.gd" ).new(),
      'minions': { 'a' : null, 'b' : null, 'c' : null, 'd' : null }
    }
  } )

func setup( params ):
  _setup_battle( params )
  $BattleUI.setup_ui()
  _connect_signals()

  _start_turn()

func _setup_battle( params ):
  player_data.setup_test_player_data() # TEMP

  BOARD[HERO].root    = preload( "res://characters/heroes/hero.gd" ).new()
  BOARD[HERO].minions = player_data.get_player_battle_data().minions
  BOARD[CPU].root    = params.enemies.root
  BOARD[CPU].minions = params.enemies.minions

func _connect_signals():
  # connect to hero signals
  # connect to enemy signals
  pass

# ============ #
# PRIVATE CORE #
# ============ #

func _start_turn():
  # this needs to be before the turn start signal emits
  # in order to guarantee the player has complete
  # information at the start of the turn timer
  get_fighter( CPU ).decide_next_move( self )
  emit_signal( 'turn_start', self )

func _end_turn():
  var result = _resolve_all_moves()
  if result == null:
    emit_signal( 'turn_end', self )
  else:
    emit_signal( 'game_over', result )

func _resolve_all_moves():
  # iterate up the rivers
  # for each momentum M in 1..4
  #  resolve momentum M card for hero
  #  resolve momentum M card for enemy
  var move = null

  for m in range( CUR_MOMENTUM ):
    # momentum methods are 1-indexed, and m will be reset at each iteration
    m += 1

    move = get_move_at_momentum( HERO, m )
    if move:
      # TEMP actually think though how this logics out
      move.card.activate( self, move.river )

      # TODO check for mini-combo satisfaction
      # for combo in player.combos:
      #   if combo.satisfied()
      #     combo.activate()

      # activate signature if final hit
      if m == 4:
        # TODO do signature shit
        pass

    move = get_move_at_momentum( CPU, m )
    if move:
      # TEMP actually think though how this logics out
      move.card.activate( self, move.river )

# ============ #
# PLAYER MOVES #
# ============ #

func play_card( who, card, river ):
  var _name = 'player' if who == HERO else 'enemy'
  print( 'battle.gd // ', _name, ' is playing card ', card, ' into river ', river )

  var rivers = get_rivers( who )
  var active_cards = get_active_cards( who )
  var momentum = get_current_momentum( who )

  # TODO validate move
  # TODO remove card from hand

  # clear the river if needed
  print( 'battle.gd // ', 'removing top ', momentum - card.level, ' cards from ', _name, '\'s river ', river )
  for i in range( momentum - card.level ):
    var data = active_cards.pop()
    print( 'battle.gd // ', 'removing card ', data.card, ' from river ', data.river )
    rivers[data.river].remove( data.card.level )
    emit_signal( 'card_removed', who, card, river )

  # add card to correct place in river
  rivers[river][card.level] = card
  active_cards[card.level] = { 'card': card, 'river': river }
  print( 'battle.gd // added card ', card, ' into river ', river )

  card.play( self, river )
  get_fighter( who ).set_momentum( card.level )
  emit_signal( 'card_played', who, card, river )

# TODO
func pass_turn():
  pass # lol

# TODO
func swap_rivers():
  pass

func mulligan():
  var hero = get_fighter( HERO )
  hero.clear_hand()
  hero.draw_hand()

# ======= #
# HELPERS #
# ======= #

# who will be targeted by an attack in a river vs the enemy or hero
func target_in_river( vs, river ):
  if !has_minions( vs ):
    var minion = get_minion_in_river( vs, river )

    if minion:
      return minion

    match( river ):
      'a':
        river = 'b'
      'b':
        river = 'a' if get_minion_in_river( vs, 'a' ) else 'c'
      'c':
        river = 'd' if get_minion_in_river( vs, 'd' ) else 'b'
      'd':
        river = 'c'

    minion = get_minion_in_river( vs, river )

    if minion:
      return minion

  return get_fighter( vs )

# TODO
func available_moves( who ):
  # return the river steps that can have cards played in them
  return null

func can_place_card( who, card, river ):
  # check if momentum is within limits for that fighter
  var cur_mom = get_current_momentum( who )
  if card.get_power() > cur_mom + 1:
    return false

  # check if the fighter can't play the card
  # if !get_fighter( who ).can_play_card( card, river ):
  #   return false

  return true

# TODO
func test_move_outcome( who, card, river ):
  # copy board state, make test move, and calculate the resulting board state
  return null

# ======= #
# GETTERS #
# ======= #

func get_board():
  return BOARD

func get_fighter( who ):
  return BOARD[who].root

func get_active_cards( who ):
  return BOARD[who].active_cards

func get_current_momentum( who ):
  return get_active_cards( who ).size()

func get_rivers( who ):
  return BOARD[who].rivers

func get_minions( who ):
  return BOARD[who].minions

func has_minions( who ):
  var minions = get_minions( who )

  for m in minions.values:
    if m != null:
      return true

  return false

# # GET by river

func get_minion_in_river( who, river ):
  return get_minions( who )[river]

# # GET by momentum

# the 'level' is 1-indexed
func get_move_at_momentum( who, level ):
  if level <= get_current_momentum( who ):
    return get_active_cards( who )[level]

  return null

# the 'level' is 1-indexed
func get_active_river_at_momentum( who, level ):
  var move = get_move_at_momentum( who, level )
  if move:
    return move.river

  return null

# the 'level' is 1-indexed
func get_card_at_momentum( who, level ):
  var move = get_move_at_momentum( who, level )
  if move:
    return move.card

  return null
