extends VBoxContainer

onready var DUEL_AREA = $DuelArea
onready var CARD_AREA = $CardArea

# ===== #
# SETUP #
# ===== #

func setup_ui():
  var board = get_parent()

  # TODO setup menu
  # setup_menu()
  setup_duel_area( board )
  setup_card_area( board )

# ========= #
# DUEL AREA #
# ========= #

func setup_duel_area( board ):
  setup_rivers( board )
  setup_sprites( board )
  setup_timer( board )

func setup_rivers( board ):
  pass

func setup_sprites( board ):
  var sprite_hero  = board.get_fighter( board.HERO ).get_sprite()
  var sprite_enemy = board.get_fighter( board.CPU ).get_sprite() if board.get_fighter( board.CPU ) else null

  place_hero_sprite( sprite_hero )
  place_enemy_sprite( sprite_enemy )

func setup_timer( board ):
  pass

# ========= #
# CARD AREA #
# ========= #

func setup_card_area( board ):
  # setup hand
  var card = preload( "res://cards/card.gd" ).new()
  add_card_to_hand( card )

# ========== #
# UI CONTROL #
# ========== #

# =
# # duel area
# =

# = =
# # # general
# = =

func position_fighter( who ):
  var placement = DUEL_AREA.get_node( who + "Placement" )
  if placement.get_child_count() == 0:
    return

  var sprite = placement.get_node( who + "Sprite" )
  sprite.set_position( placement.get_size() / 2 )

func place_card( who, card, river ):
  var rivers = DUEL_AREA.get_node( who + "Rivers" )
  rivers.play_card( card, river )

# = =
# # # hero
# = =

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

# = =
# # # enemy
# = =

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

# timer
# river swapping

# =
# # card area
# =

func add_card_to_hand( card ):
  var card_sprite = card.get_as_sprite()
  get_hand().add_child( card_sprite )

# end turn
# dragging cards
# mulligan
# deck
# hand

# ======= #
# GETTERS #
# ======= #

func get_hand():
  return CARD_AREA.get_node( 'Hand' )
