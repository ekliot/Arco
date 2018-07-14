extends '../character.gd'

signal telegraph_move

func _init():
  ID += 'ENEMY_'
  SPRITE = Sprite.new()
  SPRITE.set_name( 'EnemySprite' )
  SPRITE.set_texture( preload( "res://icon.png" ) )

func decide_next_move( board ):
  pass
