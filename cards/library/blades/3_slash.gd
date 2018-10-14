extends 'res://cards/card.gd'

var PARAMS = {
  'id': "BLADES_SLASH",
  'title': "Slash",
  'suit': CARD_SUITS.get_blades_id(),
  'power': 3,
  'icon': CARD_SUITS.get_blades_icon(),
  'illustration': null,
  'description': null,
  'effects': []
}

func _init(owner_id).(owner_id, PARAMS):
  pass
