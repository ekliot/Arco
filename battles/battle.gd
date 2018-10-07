extends Node

signal all_ready
signal turn_start(battle)
signal turn_end(battle)
signal game_over(winner)

signal card_played(card, river)
signal card_activated(card, river)
signal card_removed(card, river)

var SCENARIO = null
var CUR_MOMENTUM = 0

var turn = 0
var ready_players = { BM.HERO: false, BM.CPU: false }

# we need to be able to dynamically load different battle scenarios

func _init( scenario=null ):
  SCENARIO = scenario

func _ready():
  # TEMP
  _setup( {
    'enemies': {
      'root': preload( "res://characters/enemies/skeleton.gd" ),
      'minions': { 'a' : null, 'b' : null, 'c' : null, 'd' : null }
    }
  } )
  _start_turn()

func _setup( params ):
  _setup_battle( params )
  $BattleUI.setup_ui()
  _connect_signals()

func _setup_battle( params ):
  var _rivers_ = preload( "res://battles/rivers.gd" )

  var hero = preload( "res://characters/heroes/hero.gd" ).new(
    _rivers_.new( BM.HERO ),
    null # TODO minions
  )
  add_child( hero, BM.fighter_id_to_str( BM.HERO ) )

  var opponent = params.enemies.root.new(
    _rivers_.new( BM.CPU ),
    null # TODO minions
  )
  add_child( opponent, BM.fighter_id_to_str( BM.CPU ) )

func _connect_signals():
  connect( 'all_ready', self, '_start_turn' )

  # connect signals to/from hero
  var hero = get_fighter( BM.HERO )
  hero.connect( 'ready', self, '_ready_up' )
  hero.connect( 'end_turn', self, '_end_turn' )
  connect( 'turn_start', hero, '_on_turn_start' )
  connect( 'turn_end',   hero, '_on_turn_end' )

  # connect signals to/from enemy
  var enemy = get_fighter( BM.CPU )
  enemy.connect( 'ready', self, '_ready_up' )
  # connect( 'turn_start', enemy, '_on_turn_start' )
  connect( 'turn_end',   enemy, '_on_turn_end' )

# == PRIVATE CORE == #

func _ready_up( who ):
  ready_players[who] = true
  var ready = true
  for r in ready_players.values():
    ready = ready and r
  if ready:
    LOGGER.debug( self, 'all players ready' )
    emit_signal( 'all_ready' )

func _start_turn():
  turn += 1
  $BattleUI.MENU_BAR.get_node( 'TurnCounter' ).text = "Turn: %d" % turn
  print( '===================================================================' )
  LOGGER.info( self, 'starting turn %d...' % turn )
  for who in ready_players:
    ready_players[who] = false
  # this needs to be before the turn start signal emits
  # in order to guarantee the player has complete
  # information at the start of the turn timer
  # TODO make this more... elegant. currently, the enemy is disconnected from the turn_start signal, and decide_next_move() handles that instead
  get_fighter( BM.CPU ).decide_next_move( get_board() )
  emit_signal( 'turn_start', get_board() )

func _end_turn():
  # TODO 'game_over' should happen based on listening for a scenario-completion signal (i.e. character dies) rather than statically in this method
  var result = _resolve_all_moves()
  if result == null:
    emit_signal( 'turn_end', get_board() )
  else:
    emit_signal( 'game_over', result )

func _resolve_all_moves():
  """
  activates moves in each river, upstream, alternating between player and enemy
  if at any activation a winner is found (the scenario's win condition is reached), that winner is returned
  if no winner is resolved after all moves are exhausted, null is returned and the next turn starts
  """
  # iterate up the rivers
  # for each momentum M in 1..4
  #  resolve momentum M card for hero
  #  resolve momentum M card for enemy
  var move = null
  var winner = null

  for m in range( CUR_MOMENTUM ):
    # momentum methods are 1-indexed, and m will be reset at each iteration
    m += 1

    move = get_move_at_momentum( BM.HERO, m )
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

    move = get_move_at_momentum( BM.CPU, m )
    if move:
      # TEMP actually think though how this logics out
      move.card.activate( self, move.river )

# == FIGHTER MOVES == #

func play_card( card, river ):
  var who = card.get_owner_id()
  var _name = 'player' if who == BM.HERO else 'enemy'
  var fighter = get_fighter( who )

  LOGGER.debug( self, '%s is playing card %s into river %s...' % [fighter.name, card.name, river] )

  # this method will yield, and wait for the battle to confirm the move
  var play = fighter.play_card( card, river )
  # at the moment, only battle UI is connected to this
  emit_signal( 'card_played', card, river )
  play.resume()

# TODO
func pass_turn():
  pass # lol

# TODO
func swap_rivers():
  pass

func mulligan():
  var hero = get_fighter( BM.HERO )
  hero.clear_hand()
  hero.draw_hand()
  # TODO flag the mulligan for this turn

# == HELPERS == #

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
  return get_fighter( who ).validate_play( card, river )

# TODO
func test_move_outcome( who, card, river ):
  # copy board state, make test move, and calculate the resulting board state
  return null

# == GETTERS == #

func get_board():
  var board = {
    BM.HERO: get_node( BM.fighter_id_to_str( BM.HERO ) ),
    BM.CPU: get_node( BM.fighter_id_to_str( BM.CPU ) )
  }
  return board

func get_fighter( who ):
  return get_node( BM.fighter_id_to_str( who ) )

func get_active_moves( who ):
  return get_rivers( who ).get_active_moves()

func get_current_momentum( who ):
  return get_rivers( who ).get_active_momentum()

func get_rivers( who ):
  return get_fighter( who ).get_rivers()

# func get_minions( who ):
#   return BOARD[who].minions

func has_minions( who ):
  var minions = get_minions( who )

  for m in minions.values:
    if m != null:
      return true

  return false

# ==== GET by river

func get_minion_in_river( who, river ):
  return get_minions( who )[river]

# ==== GET by momentum

# the 'level' is 1-indexed
func get_move_at_momentum( who, level ):
  get_rivers( who ).get_move_at_momentum( level )

# the 'level' is 1-indexed
func get_active_river_at_momentum( who, level ):
  get_rivers( who ).get_active_river_at_momentum( level )

# the 'level' is 1-indexed
func get_card_at_momentum( who, level ):
  get_rivers( who ).get_card_at_momentum( level )

# == OVERRIDES == #

func add_child( child, name=null ):
  """
  Overridden Node.add_child() to also name the node being added
  """
  .add_child( child )
  if name:
    child.name = name
