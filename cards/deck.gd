extends Node

signal shuffled(new_deck)

var deck = [] setget ,get_cards

func set_deck( _cards ):
  for c in _cards:
    add_card( c )

func add_card( card ):
  if card:
    deck.push_back( card )
    add_child( card )
  else:
    prints( "\tDanger says", self.name ,"! Danger,", get_parent().name, '!' )

func remove_card( card ):
  if card and card in deck:
    deck.erase( card )
    remove_child( card )
  else:
    prints( "\tDanger says", self.name ,"! Danger,", get_parent().name, '!' )
  return card

func draw():
  if is_empty():
    prints( self.name, '// I got nuttin!' )
    return null
  var draw = deck.front()
  return remove_card( draw )

func shuffle():
  emit_signal( 'shuffled', get_cards() )
  # TODO shuffle algo

func is_empty():
  return deck.empty()

func get_cards():
  return [] + deck
