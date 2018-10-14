extends 'res://cards/card_set.gd'

var _ui = null

func _init(cards=null).(cards):
  pass

func _enter_tree():
  var parent = get_parent()
  parent.connect('drew_card', self, 'add_card')

  if BM.is_player(parent):
    _ui = BM.get_hand_ui()
    parent.connect('play_card', _ui, '_on_card_played')
    parent.connect('discard_card', _ui, '_on_card_discarded')
    connect('card_added', _ui, '_on_hand_card_added')
