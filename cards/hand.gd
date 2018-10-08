extends 'res://cards/card_set.gd'

func _init( cards=null ).(cards):
  pass

func _enter_tree():
  var parent = get_parent()
  parent.connect( 'drew_card', self, 'add_card' )
  # parent.connect( 'play_card', self, 'remove_card' )

  if BM.is_player( parent ):
    var hand_ui = BM.get_hand_ui()
    # print( hand_ui.get_script() )
    # for sig in hand_ui.get_method_list():
    #   if 'card' in sig['name']:
    #     print( sig['name'] )
    connect( 'card_added', hand_ui, '_on_hand_card_added' )
    connect( 'card_removed', hand_ui, '_on_hand_card_removed' )
    # hand_ui.connect( 'card_added', self, '_on_card_added_to_ui' )
