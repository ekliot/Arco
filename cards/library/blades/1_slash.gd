extends 'res://cards/card.gd'

var PARAMS = {
  'id': "BLADES_SLASH",
  'title': "Slash",
  'suit': card_suits.get_blades_id(),
  'power': 1,
  'icon': card_suits.get_blades_icon(),
  'illustration': null,
  'description': null
}

func _init( owner_id ).( owner_id, PARAMS ):
  pass
