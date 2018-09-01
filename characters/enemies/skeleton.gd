extends 'enemy.gd'

func _init( rivers, minions ).( _build_data(), rivers, minions ):
  pass

func _build_data():
  var data = spawner.enemy_template( "Skeleton" )
  data.sprite.texture = preload( "res://icon.png" )

  # TODO set stats
  # TODO set cards

  return data
