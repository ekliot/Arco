# dealer.gd
# this will be an auto-loaded singleton to act as a card factory and/or card DB
# should be able to call something like, `dealer.deal( 'blades', 'slash' )`
# or `dealer.query_by_suit( 'blades' )` or `dealer.query_by_effect( 'heal' )`

extends Node

func _init():
  # TODO preload all cards? is this a performance hit?
  pass

func deal( owner_id, suit, power, name ):
  var card = load( "res://cards/library/%s/%s_%s.gd" % [suit, power, name] )
  return card.new( owner_id )
