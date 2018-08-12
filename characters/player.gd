extends Node

var PLAYER = {
  'id': '',
  'sprite': null,
  'stats': {
    'health': -1,
    'health_max': -1,
    'gold': -1,
    'draw_size': 4
  },
  'cards': {
    'deck': null,
    # idx [1:4] correspond to momentum levels 1-4 ; idx 0 unused
    'signature': []
  },
  'minions': {}
}

var held_card = null

func setup_test_player_data():
  print( "setting up test player data..." )
  PLAYER.id = 'TEST'
  PLAYER.stats.health = 100
  PLAYER.stats.health_max = 100
  PLAYER.cards.deck = preload( "res://cards/deck.gd" ).new()

  var tmp_deck = []
  for i in range(10):
    tmp_deck.push_back( preload( "res://cards/card.gd" ).new() )

  PLAYER.cards.deck.set_deck( tmp_deck )

  PLAYER.sprite = Sprite.new()
  PLAYER.sprite.set_name( 'HeroSprite' )
  PLAYER.sprite.set_texture( preload( "res://icon.png" ) )

  print( "player data:" )
  print( PLAYER )

func get_player_battle_data():
  return PLAYER

func pick_up_card( card ):
  held_card = card
  print( "PLAYER // picked up card ", card )

func drop_card():
  print( "PLAYER // dropping card ", held_card )
  held_card = null

func get_held_card():
  return held_card
