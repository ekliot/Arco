extends VBoxContainer

onready var MENU_BAR = $MenuBar
onready var DUEL_AREA = $DuelArea
onready var CARD_AREA = $CardArea

# == SETUP == #

func setup_ui():
  var battle = get_parent()

  _setup_menu_area( battle )
  _setup_duel_area( battle )
  _setup_card_area( battle )

  _connect_signals( battle )

  _scaling()
  # QUESTION this doesn't work the way I want it to?
  # self.connect( 'resized', self, '_scaling' )

func _debug_size( ui, max_depth=0, cur_depth=0 ):
  if max_depth > 0 and cur_depth > max_depth:
    return

  if ui.has_method( 'get_rect' ):
    print( ui.get_name(), ui.get_rect() )
    for child in ui.get_children():
      _debug_size( child, max_depth, cur_depth+1 )

func _scaling():
  var vp_size = get_viewport().get_size()

  var d_h = DUEL_AREA.get_size().y * .4

  var riv_cont = get_rivers()
  var riv_size = riv_cont.get_minimum_size()
  riv_cont.set_custom_minimum_size( Vector2( riv_size.x, d_h ) )

  var h_place = get_placement( "Hero" )
  var h_place_size = h_place.get_minimum_size()
  h_place.set_custom_minimum_size( Vector2( h_place_size.x, d_h ) )

  var e_place = get_placement( "Enemy" )
  var e_place_size = e_place.get_minimum_size()
  e_place.set_custom_minimum_size( Vector2( e_place_size.x, d_h ) )

# ==== menu area

# TODO
func _setup_menu_area( battle ):
  pass

# ==== duel area

func _setup_duel_area( battle ):
  _setup_rivers( battle )
  _setup_sprites( battle )
  _setup_timer( battle )

func _setup_rivers( battle ):
  # first, connect the river UIs to their respective models
  var hero_rivers = battle.get_rivers( battle.HERO )
  get_rivers( "Hero" ).connect_to_model( hero_rivers )

  var enemy_rivers = battle.get_rivers( battle.CPU )
  get_rivers( "Enemy" ).connect_to_model( enemy_rivers )
  # get_rivers( "Enemy" ).reverse()

func _setup_sprites( battle ):
  var sprite_hero  = battle.get_fighter( battle.HERO ).get_sprite()
  var sprite_enemy = battle.get_fighter( battle.CPU ).get_sprite()

  place_hero_sprite( sprite_hero )
  place_enemy_sprite( sprite_enemy )

  # TODO minions

# TODO
func _setup_timer( battle ):
  pass

# ==== card area

func _setup_card_area( battle ):
  # setup hand
  pass

# == SIGNAL HANDLING == #

func _connect_signals( battle ):
  # battle state changes
  battle.connect( 'turn_start',     self, '_on_turn_start' )
  battle.connect( 'turn_end',       self, '_on_turn_end' )
  battle.connect( 'card_played',    self, '_on_card_played' )
  battle.connect( 'card_activated', self, '_on_card_activated' )
  battle.connect( 'card_removed',   self, '_on_card_removed' )

  # hero state changes
  var hero = battle.get_fighter( battle.HERO )
  hero.connect( 'draw_card',      self, '_on_hero_draw_card' )
  hero.connect( 'discard_card',   self, '_on_hero_discard_card' )
  hero.connect( 'take_damage',    self, '_on_hero_take_damage' )
  hero.connect( 'heal_damage',    self, '_on_hero_heal_damage' )
  hero.connect( 'died',           self, '_on_hero_died' )
  hero.connect( 'momentum_inc',   self, '_on_hero_momentum_inc' )
  hero.connect( 'momentum_dec',   self, '_on_hero_momentum_dec' )
  hero.connect( 'combo_activate', self, '_on_hero_combo_activate' )

  # enemy state changes
  var enemy = battle.get_fighter( battle.CPU )
  enemy.connect( 'draw_card',      self, '_on_enemy_draw_card' )
  enemy.connect( 'discard_card',   self, '_on_enemy_discard_card' )
  enemy.connect( 'take_damage',    self, '_on_enemy_take_damage' )
  enemy.connect( 'heal_damage',    self, '_on_enemy_heal_damage' )
  enemy.connect( 'died',           self, '_on_enemy_died' )
  enemy.connect( 'momentum_inc',   self, '_on_enemy_momentum_inc' )
  enemy.connect( 'momentum_dec',   self, '_on_enemy_momentum_dec' )
  enemy.connect( 'combo_activate', self, '_on_enemy_combo_activate' )

# ==== board

func _on_turn_start( battle ):
  # enable hero rivers
  # update timer
  pass

func _on_turn_end( battle ):
  # disable hero rivers
  pass

func _player_places_card( card, river_step ):
  pass

func _on_card_played( who, card, river ):
  pass

func _on_card_activated( who, card, river ):
  pass

func _on_card_removed( who, card, river ):
  pass

# ==== hero

func _on_hero_draw_card( card, hand, deck ):
  # TODO verify UI hand and hero hand are in sync
  var card_sprite = get_hand().add_card( card )
  # card_sprite.connect( 'card_placed', self, '_player_places_card' )
  # TODO update deck

func _on_hero_discard_card( card, hand, discard ):
  pass

func _on_hero_take_damage( new_hp, old_hp, max_hp ):
  pass

func _on_hero_heal_damage( new_hp, old_hp, max_hp ):
  pass

func _on_hero_died():
  pass

func _on_hero_momentum_inc( old_momentum, new_momentum ):
  pass

func _on_hero_momentum_dec( old_momentum, new_momentum ):
  pass

func _on_hero_combo_activate():
  pass

# ==== enemy

func _on_enemy_draw_card( card, hand, deck ):
  pass

func _on_enemy_discard_card( card, hand, discard ):
  pass

func _on_enemy_take_damage( new_hp, old_hp, max_hp ):
  pass

func _on_enemy_heal_damage( new_hp, old_hp, max_hp ):
  pass

func _on_enemy_died():
  pass

func _on_enemy_momentum_inc( old_momentum, new_momentum ):
  pass

func _on_enemy_momentum_dec( old_momentum, new_momentum ):
  pass

func _on_enemy_combo_activate():
  pass

# == UI CONTROL == #

# ==== input handling

func _input( ev ):
  # check for mouse shit
  pass

# ==== duel area

# ====== general

# set a fighter's sprite in the middle of its container
func position_fighter( who ):
  var placement = get_placement( who )
  if placement.get_child_count() > 0:
    var sprite = placement.get_node( who + "Sprite" )
    sprite.set_position( placement.get_size() / 2 )

func place_card_in_river( who, card, river ):
  var rivers = get_rivers( who )
  rivers.play_card( card, river )

# ====== hero

func place_hero_sprite( sprite ):
  var placement = DUEL_AREA.get_node( "HeroPlacement" )
  if placement.get_child_count() == 0:
    placement.add_child( sprite )
    position_hero_sprite()
    placement.connect( 'resized', self, 'position_hero_sprite' )

func position_hero_sprite():
  position_fighter( "Hero" )

func place_hero_card( card, river ):
  place_card_in_river( "Hero", card, river )

# ======= enemy

func place_enemy_sprite( sprite ):
  var placement = DUEL_AREA.get_node( "EnemyPlacement" )
  if placement.get_child_count() == 0:
    placement.add_child( sprite )
    position_hero_sprite()
    placement.connect( 'resized', self, 'position_enemy_sprite' )

func position_enemy_sprite():
  position_fighter( "Enemy" )

func place_enemy_card( card, river ):
  place_card_in_river( "Enemy", card, river )

# ====== timer

# TODO

# ====== river swapping

# TODO

# end turn
# dragging cards
# mulligan
# deck
# hand

# == GETTERS == #

func get_hand():
  return CARD_AREA.get_node( 'Hand' )

func get_placement( who ):
  return DUEL_AREA.get_node( "%sPlacement" % who )

func get_rivers( who=null ):
  return DUEL_AREA.get_node( "RiverContainer" + ("/%sRivers" % who if who else "") )
