extends Node

signal card_added(card, hand)
signal card_removed(card, hand)

var hand = [] setget ,get_cards

func has( card ):
  return card in hand

func is_empty():
  return hand.empty()

func add_card( card ):
  if card:
    hand.push_back( card )
    add_child( card )
    emit_signal( 'card_added', card, get_cards() )
  else:
    prints( "\tDanger says", self.name ,"! Danger,", get_parent().name, '!' )

func remove_card( card ):
  if card:
    hand.erase( card )
    remove_child( card )
    emit_signal( 'card_removed', card, get_cards() )
  else:
    prints( "\tDanger says", self.name ,"! Danger,", get_parent().name, '!' )

func get_cards():
  return [] + hand # copy the array
