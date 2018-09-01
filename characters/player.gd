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

func _init():
  setup_test_player_data()

func setup_test_player_data():
  print( "setting up test player data..." )

  var hero_battle_id = battlemaster.HERO

  PLAYER.id = 'TEST'
  PLAYER.stats.health = 100
  PLAYER.stats.health_max = 100
  PLAYER.cards.deck = dealer.new_deck()

  var tmp_deck = []
  var card = null
  for i in range(10):
    card = dealer.deal(
      hero_battle_id,
      card_suits.get_blades_str(),
      1,
      "slash"
    )
    tmp_deck.push_back( card )

  PLAYER.cards.deck.set_deck( tmp_deck )

  PLAYER.sprite = Sprite.new()
  PLAYER.sprite.name = 'HeroSprite'
  PLAYER.sprite.texture = preload( "res://icon.png" )

  print( "player data:" )
  print( PLAYER )

func get_player_battle_data():
  return PLAYER

# == BATTLE LOGIC == #

var held_card = null

func pick_up_card( card ):
  held_card = card
  print( "PLAYER // picked up card ", card )

func drop_card():
  print( "PLAYER // dropping card ", held_card )
  held_card = null

func get_held_card():
  return held_card

func can_hold( card ):
  return held_card == card or held_card == null

func is_holding_card():
  return held_card != null
