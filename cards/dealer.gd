# dealer.gd
# this will be an auto-loaded singleton to act as a card factory and/or card DB
# should be able to call something like, `dealer.deal( 'blades', 'slash' )`
# or `dealer.query_by_suit( 'blades' )` or `dealer.query_by_effect( 'heal' )`

extends Node
