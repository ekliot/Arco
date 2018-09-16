extends 'enemy.gd'

func _init( rivers, minions ).( _build_data(), rivers, minions ):
  pass

func _build_data():
  var data = SPAWNER.enemy_template( "Skeleton" )
  data.sprite.texture = preload( "res://icon.png" )

  # TODO set stats

  return data

func decide_next_move( board ):
  .decide_next_move( board )
  var moves = get_valid_moves()
  if not moves.empty():
    var next = moves[ randi() % moves.size() ]
    var riv = BM.RIVER_IDS[ randi() % BM.RIVER_IDS.size() ]
    prints( ID, "// decided to play", next, 'in river', riv )
    BM.play_card( next, riv )
