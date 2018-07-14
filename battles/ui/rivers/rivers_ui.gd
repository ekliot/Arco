extends VBoxContainer

func reverse():
  # reverse each river
  pass

func play_card( card, river ):
  var river_node = get_river_node( river, card.get_power() )
  river_node.play_card( card )

func get_river( river ):
  return get_node( river.to_upper() )

func get_river_node( river, momentum ):
  return get_river( river ).get_step( momentum )
