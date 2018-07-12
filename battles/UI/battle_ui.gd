extends VBoxContainer

onready var DUEL_AREA = $DuelArea
onready var CARD_AREA = $CardArea

func setup_ui( params ):
  # TODO setup menu

  var sprite_hero  = params.player_data.hero.get_sprite() if params.player_data.hero else null
  var sprite_enemy = params.enemy_data.root.get_sprite() if params.enemy_data.root else null

  # setup duel
  for child in DUEL_AREA.get_node( 'HeroRivers' ).get_children():
    if child.get_child( 0 ):
      for river in child.get_children():
        if river.get_child( 0 ):
          print( river )
          print( river.get_rect() )
          print( river.get_child( 0 ).get_rect() )

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
