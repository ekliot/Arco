extends VBoxContainer

func get_river_node( river, momentum ):
  return get_node( river.to_upper() ).get_node( String(momentum) )

func play_card( card, river ):
  var river_node = get_river_node( river, card.get_power() )

  var text_rect = TextureRect.new()
  text_rect.set_texture( card.get_icon() )

  if river_node.get_child_count() > 0:
    river_node.get_child( 0 ).queue_free()

  river_node.add_child( text_rect )
