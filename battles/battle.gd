extends Node

signal turn_start
signal turn_end

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

# ============ #
# PRIVATE CORE #
# ============ #

func _start_turn():
  emit_signal( 'turn_start' )
  get_enemy_root().decide_next_move()

func _end_turn():
  # iterate up the rivers
  # for each momentum M in 1..4
  #  resolve momentum M cards for hero from A to D
  #  resolve momentum M cards for enemy from A to D
  pass

func _resolve_all_moves():
  var move = null

  for m in range( MAX_MOMENTUM ):
    move = get_hero_move_at_momentum( m )


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

func get_hero_root():
  return BOARD.hero.root

func get_enemy_root():
  return BOARD.enemies.root

func get_hero_active_cards():
  return BOARD.hero.active_cards

func get_hero_max_momentum():
  return get_hero_active_cards().size()

func get_enemy_active_cards():
  return BOARD.enemies.active_cards

func get_enemy_max_momentum():
  return get_enemy_active_cards().size()

func get_hero_rivers():
  return BOARD.hero.rivers

func get_enemy_rivers():
  return BOARD.enemies.rivers

func get_active_hero_river_at_momentum( level ):
  var rivs = get_hero_rivers()
  if rivs.a[level]:
    return 'a'
  if rivs.b[level]:
    return 'b'
  if rivs.c[level]:
    return 'c'
  if rivs.d[level]:
    return 'd'
  return null

func get_active_enemy_river_at_momentum( level ):
  var rivs = get_enemy_rivers()
  if rivs.a[level]:
    return 'a'
  if rivs.b[level]:
    return 'b'
  if rivs.c[level]:
    return 'c'
  if rivs.d[level]:
    return 'd'
  return null

# the 'level' is 1-indexed
func get_hero_move_at_momentum( level ):
  if level <= get_hero_max_momentum():
    return get_hero_active_cards()[level-1]

  return null

# the 'level' is 1-indexed
func get_enemy_move_at_momentum( level ):
  if level <= get_enemy_max_momentum():
    return get_enemy_active_cards()[level-1]

  return null
