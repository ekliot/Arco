extends Node

signal shuffled(new_deck)

var cards = [] setget ,get_cards

func set_deck( _cards ):
  cards = _cards

func add_card( card ):
  cards.push_back( card )

func remove_card( card ):
  cards.erase( card )

func draw():
  return cards.pop_front()

func shuffle():
  emit_signal( 'shuffled', get_cards() )
  # TODO shuffle algo

func is_empty():
  return cards.empty()

func get_cards():
  return [] + cards
