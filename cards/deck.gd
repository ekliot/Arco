extends 'res://cards/card_set.gd'

func _init(cards=null).(cards):
  pass

func _enter_tree():
  if BM.is_player(get_parent()):
    connect('card_removed', self, 'update_deck_ui')
    connect('card_added', self, 'update_deck_ui')

func update_deck_ui(card, set):
  var ui = BM.get_battle_ui().get_deck()
  # print(str(set.size()))
  ui.get_node('DeckCount').text = str(set.size())
