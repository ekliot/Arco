extends '../character.gd'

func _in
  init_from_player_data()

func init_from_player_data():
  var p_data = player_data.get_player_battle_data()
  var stats = p_data.stats
  var cards = p_data.cards

  HEALTH = stats.health
  HEALTH_MAX = stats.health_max
  DRAW_SIZE = stats.draw_size

  DECK = cards.deck
  SIGNATURE = cards.signature

  MINIONS = p_data.minions
  SPRITE = p_data.sprite
