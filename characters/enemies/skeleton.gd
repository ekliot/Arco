extends 'enemy.gd'

func _init( rivers, minions ).( _build_data(), rivers, minions ):
  pass

func _build_data():
  var data = spawner.enemy_template( "Skeleton" )
  data.sprite.texture = preload( "res://icon.png" )

  # TODO set stats

  var tmp_deck = []
  var card = null
  for i in range(20):
    card = dealer.deal(
      battlemaster.CPU,
      card_suits.get_blades_str(),
      1,
      "slash"
    )
    tmp_deck.push_back( card )

  data.cards.deck.set_deck( tmp_deck )

  return data
