# DEALER.gd
# this will be an auto-loaded singleton to act as a card factory and/or card DB
# should be able to call something like, `DEALER.deal( 'blades', 'slash' )`
# or `DEALER.query_by_suit( 'blades' )` or `DEALER.query_by_effect( 'heal' )`

extends Node

const _DECK_ = preload( "res://cards/deck.gd" )

func _init():
  # TODO preload all cards? is this a performance hit?
  pass

func deal( owner_id, suit, power, name ):
  var card = load( "res://cards/library/%s/%s_%s.gd" % [suit, power, name] )
  return card.new( owner_id )

func new_deck():
  return _DECK_.new()
