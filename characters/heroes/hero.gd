extends '../character.gd'

func _init(rivers, minions).(PLAYER_DATA.get_player_battle_data(), rivers, minions):
  pass

func end_turn():
  .end_turn()
  LOGGER.info(self, 'ending turn...')
  # _debug_cards()
  yield(BM.get_hand_ui(), 'empty')
  emit_signal('end_turn')
