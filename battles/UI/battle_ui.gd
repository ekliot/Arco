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
  for river in DUEL_AREA.get_node( 'HeroRivers' ).get_children():
    if river.get_child_count() > 0:
      for slot in river.get_children():
        print( river )
        # print( river.get_rect() )
        # print( slot.get_rect() )

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
  pass

# ========== #
# UI CONTROL #
# ========== #

# # duel area

# hero river
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

# enemy river
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

func position_fighter( who ):
  var placement = DUEL_AREA.get_node( who + "Placement" )
  if placement.get_child_count() == 0:
    return

  var sprite = placement.get_node( who + "Sprite" )
  sprite.set_position( placement.get_size() / 2 )

func place_card( who, card, river ):
  var rivers = DUEL_AREA.get_node( who + "Rivers" )
  var _river = rivers.get_node( river.to_upper() )

  var power = card.get_power()
  var river_node = _river.get_node( String(power) )

  var text_rect = TextureRect.new()
  text_rect.set_texture( card.get_icon() )

  if river_node.get_child_count() > 0:
    river_node.get_child( 0 ).queue_free()

  river_node.add_child( text_rect )

# timer
# river swapping

# # card area

# end turn
# dragging cards
# mulligan
# deck
# hand
