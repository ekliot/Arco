extends '../character.gd'

func _init():
  init_from_player_data()

func init_from_player_data():
  var p_data = player_data.get_player_battle_data()
  var stats = p_data.stats
  var cards = p_data.cards

  ID += "HERO_" + p_data.id

  HEALTH = stats.health
  HEALTH_MAX = stats.health_max
  DRAW_SIZE = stats.draw_size

  DECK = cards.deck
  SIGNATURE = cards.signature

  SPRITE = p_data.sprite
