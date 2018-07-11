extends Node

signal turn_start # Battle
signal turn_end # Battle

var BOARD = {
  'hero': {
    'root': null,
    'minions': { 'a' : null, 'b' : null, 'c' : null, 'd' : null },
    'rivers':  { 'a' : [],   'b' : [],   'c' : [],   'd' : [] },
    'active_cards': [] # this expects dicts of { 'card': Card, 'river': String }
  },

  'enemies': {
    'root': null,
    'minions': { 'a' : null, 'b' : null, 'c' : null, 'd' : null },
    'rivers':  { 'a' : [],   'b' : [],   'c' : [],   'd' : [] },
    'active_cards': [] # this expects dicts of { 'card': Card, 'river': String }
  }
}

var MAX_MOMENTUM = 0

# we need to be able to dynamically load different battle scenarios

func _init():
  pass

func _ready():
  pass

func setup( params ):
  setup_battle( params )
  setup_ui()

func setup_battle( params ):
  BOARD.hero.root = params.player_data.hero
  BOARD.enemies.root = params.enemy_data.root
  BOARD.enemies.minions = params.enemy_data.minions

func setup_ui():
  # setup menu
  # setup duel
  # setup hand

# ============ #
# PRIVATE CORE #
# ============ #

func _start_turn():
  emit_signal( 'turn_start', self )
  get_enemy().decide_next_move()

func _end_turn():
  _resolve_all_moves()
  emit_signal( 'turn_end', self )

func _resolve_all_moves():
  # iterate up the rivers
  # for each momentum M in 1..4
  #  resolve momentum M card for hero
  #  resolve momentum M card for enemy
  var move = null

  for m in range( MAX_MOMENTUM ):
    # momentum methods are 1-indexed, and m will be reset at each iteration
    m += 1

    move = get_hero_move_at_momentum( m )
    if move:
      move.card.activate( self, move.river )

    move = get_enemy_move_at_momentum( m )
    if move:
      move.card.activate( self, move.river )

# ============ #
# PLAYER MOVES #
# ============ #

func play_card( who, card, river ):
  # validate move
  # add card to correct place in river
  card.play()

func pass_turn():
  pass # lol

func swap_rivers():
  pass

func mulligan():
  pass

# ======= #
# HELPERS #
# ======= #

# who the hero will hit
func hero_target_in_river( river ):
  if !get_enemy_minions().values.empty():
    var minion = get_enemy_minion_in_river( river )

    if minion:
      return minion

    match( river ):
      'a':
        river = 'b'
      'b':
        river = 'a' if get_enemy_minion_in_river( 'a' ) else 'c'
      'c':
        river = 'd' if get_enemy_minion_in_river( 'd' ) else 'b'
      'd':
        river = 'c'

    minion = get_enemy_minion_in_river( river )

    if minion:
      return minion

  return get_enemy()

# who the enemy will hit
func enemy_target_in_river( river ):
  if !get_hero_minions().values.empty():
    var minion = get_hero_minion_in_river( river )

    if minion:
      return minion

    match( river ):
      'a':
        river = 'b'
      'b':
        river = 'a' if get_hero_minion_in_river( 'a' ) else 'c'
      'c':
        river = 'd' if get_hero_minion_in_river( 'd' ) else 'b'
      'd':
        river = 'c'

    minion = get_hero_minion_in_river( river )

    if minion:
      return minion

  return get_hero()

# ======= #
# GETTERS #
# ======= #

func get_board():
  return BOARD

func get_hero():
  return BOARD.hero.root

func get_hero_active_cards():
  return BOARD.hero.active_cards

func get_hero_max_momentum():
  return get_hero_active_cards().size()

func get_hero_rivers():
  return BOARD.hero.rivers

func get_hero_minions():
  return BOARD.hero.minions

func get_enemy():
  return BOARD.enemies.root

func get_enemy_active_cards():
  return BOARD.enemies.active_cards

func get_enemy_max_momentum():
  return get_enemy_active_cards().size()

func get_enemy_rivers():
  return BOARD.enemies.rivers

func get_enemy_minions():
  return BOARD.enemies.minions

# # GET by river

func get_hero_minion_in_river( river ):
  return get_hero_minions()[river]

func get_enemy_minion_in_river( river ):
  return get_enemy_minions()[river]

# # GET by momentum

# the 'level' is 1-indexed
func get_hero_move_at_momentum( level ):
  if level <= get_hero_max_momentum():
    return get_hero_active_cards()[level-1]

  return null

# the 'level' is 1-indexed
func get_hero_active_river_at_momentum( level ):
  var move = get_hero_move_at_momentum( level )
  if move:
    return move.river

  return null

# the 'level' is 1-indexed
func get_hero_card_at_momentum( level ):
  var move = get_hero_move_at_momentum( level )
  if move:
    return move.card

  return null

# the 'level' is 1-indexed
func get_enemy_move_at_momentum( level ):
  if level <= get_enemy_max_momentum():
    return get_enemy_active_cards()[level-1]

  return null

# the 'level' is 1-indexed
func get_enemy_active_river_at_momentum( level ):
  var move = get_enemy_move_at_momentum( level )
  if move:
    return move.river

  return null

# the 'level' is 1-indexed
func get_enemy_card_at_momentum( level ):
  var move = get_enemy_move_at_momentum( level )
  if move:
    return move.card

  return null
