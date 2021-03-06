extends Node

# TODO make this template into a class a la spawner.gd
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
  setup_test_PLAYER_DATA()

func setup_test_PLAYER_DATA():
  PLAYER.id = 'HERO_TEST'
  PLAYER.stats.health = 100
  PLAYER.stats.health_max = 100

  PLAYER.cards.deck = DEALER.tmp_deck(BM.HERO)

  PLAYER.sprite = Sprite.new()
  PLAYER.sprite.name = "%sSprite" % BM.fighter_id_to_str(BM.HERO)
  PLAYER.sprite.texture = preload("res://icon.png")

func get_player_battle_data():
  return PLAYER

# == BATTLE LOGIC == #

var held_card = null

func pick_up_card(card):
  held_card = card
  # print("PLAYER // picked up card ", card)

func drop_card():
  # print("PLAYER // dropping card ", held_card)
  held_card = null

func get_held_card():
  return held_card

func can_hold(card):
  return held_card == card or held_card == null

func is_holding_card():
  return held_card != null
