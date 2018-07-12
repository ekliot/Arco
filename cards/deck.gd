extends Node

var DECK = []

func set_deck( cards ):
  DECK = cards

func add_card( card ):
  DECK.push_back( card )

func remove_card( card ):
  DECK.erase( card )

func draw():
  return DECK.pop_front()

func shuffle():
  emit_signal( 'shuffle_deck', DECK )
  # TODO shuffle algo

func empty():
  return DECK.empty()

func get_cards():
  return DECK.duplicate()
