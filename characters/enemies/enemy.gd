extends '../character.gd'

signal telegraph_move

func _init( data, river, minions ).( data, river, minions ):
  pass

func decide_next_move( board ):
  """
  here, the enemy's AI decides on a move to make based on the board state
  it is expected that classes extending this one override this method
  """
  _on_turn_start( board ) # HACK see battle._start_turn()
  pass
