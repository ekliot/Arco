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
    var next_c = next['card']
    var next_r = next['river']
    LOGGER.debug( self, "decided to play %s into river %s" % [next_c.name, next_r] )
    BM.play_card( next_c, next_r )
