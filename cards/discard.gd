extends 'res://cards/card_set.gd'

func _init( cards=null ).(cards):
  pass

func _enter_tree():
  if BM.is_player( get_parent() ):
    connect( 'card_removed', self, 'update_discard_ui' )
    connect( 'card_added', self, 'update_discard_ui' )

func update_discard_ui( card, set ):
  var ui = BM.get_battle_ui().get_discard()
  # print( str( set.size() ) )
  ui.get_node( 'DiscardCount' ).text = str( set.size() )
