extends '../character.gd'

signal telegraph_move

func _init():
  ID += 'ENEMY_'
  ._init()

func decide_next_move( board ):
  pass
