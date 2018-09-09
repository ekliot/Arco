extends Node

signal card_added(card, hand)
signal card_removed(card, hand)

var cards = [] setget ,get_cards

func has( card ):
  return card in cards

func is_empty():
  return cards.empty()

func add_card( card ):
  cards.push_back( card )
  emit_signal( 'card_added', card, get_cards() )

func remove_card( card ):
  cards.erase( card )
  emit_signal( 'card_removed', card, get_cards() )

func get_cards():
  return [] + cards # copy the array
