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

func setup_test_player_data():
  PLAYER.id = 'TEST'
  PLAYER.stats.health = 100
  PLAYER.stats.health_max = 100
  PLAYER.cards.deck = preload( "res://cards/deck.gd" ).new()
  PLAYER.cards.deck.set_deck( [ 'x','x','x','x','x','x','x','x','x','x' ] ) # 10 x's

  PLAYER.sprite = Sprite.new()
  PLAYER.sprite.set_name( 'HeroSprite' )
  PLAYER.sprite.set_texture( preload( "res://icon.png" ) )

func get_player_battle_data():
  return PLAYER
