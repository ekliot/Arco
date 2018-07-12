extends VBoxContainer

onready var DUEL_AREA = $DuelArea
onready var CARD_AREA = $CardArea

func setup_ui( params ):
  # TODO setup menu

  var sprite_hero  = params.player_data.hero.get_sprite() if params.player_data.hero else null
  var sprite_enemy = params.enemy_data.root.get_sprite() if params.enemy_data.root else null

  # setup duel
  for river in DUEL_AREA.get_node( 'HeroRivers' ).get_children():
    if river.get_child_count() > 0:
      for slot in river.get_children():
        print( river )
        print( river.get_rect() )
        print( slot.get_rect() )

  # setup hand

# ========== #
# UI CONTROL #
# ========== #

# # duel area

# hero river
# enemy river
# timer
# river swapping

# # card area

# end turn
# dragging cards
# mulligan
# deck
# hand
