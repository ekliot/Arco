extends '../character.gd'

func _init( rivers, minions ).( player_data.get_player_battle_data(), rivers, minions ):
  pass

func end_turn():
  .end_turn()
  prints( ID, '// ending turn...' )
  emit_signal( 'end_turn' )
