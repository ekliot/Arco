extends 'enemy.gd'

func _init( rivers, minions ).( _build_data(), rivers, minions ):
  pass

func _build_data():
  var data = SPAWNER.enemy_template( "Skeleton" )
  data.sprite.texture = preload( "res://icon.png" )

  # TODO set stats

  var tmp_deck = []
  var card = null
  for i in range(20):
    card = DEALER.deal(
      BM.CPU,
      card_suits.get_blades_str(),
      1,
      "slash"
    )
    card.name = 'slash%d' % i
    tmp_deck.push_back( card )

  data.cards.deck.set_deck( tmp_deck )
  data.cards.deck.shuffle()

  return data

func decide_next_move( board ):
  .decide_next_move( board )
  var moves = get_valid_moves()
  var next = moves[ randi() % moves.size() ]
  var riv = BM.RIVER_IDS[ randi() % BM.RIVER_IDS.size() ]
  prints( ID, "// decided to play", next, 'in river', riv )
  BM.play_card( next, riv )
