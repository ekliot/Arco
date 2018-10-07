extends 'res://cards/card_set.gd'

func _init( cards=null ).(cards):
  pass

func _enter_tree():
  var parent = get_parent()
  parent.connect( 'drew_card', self, 'add_card' )
  # parent.connect( 'play_card', self, 'remove_card' )
  # parent.connect( 'discard_card', self, 'remove_card' )
