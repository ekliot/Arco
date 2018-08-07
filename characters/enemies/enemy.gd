extends '../character.gd'

signal telegraph_move

# TODO eliminate _init(), make Character._init() build common data via passed in options struct a la luxe

func _init():
  ID += 'ENEMY_'
  SPRITE = Sprite.new()
  SPRITE.set_name( 'EnemySprite' )
  SPRITE.set_texture( preload( "res://icon.png" ) )

func decide_next_move( board ):
  pass
