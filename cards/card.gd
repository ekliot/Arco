extends Node

signal played(card)
signal activated(card)
signal cleared(card)

var _TEMPLATE_ = preload("res://cards/ui/CardUI.tscn")

var OWNER_ID = null

var ID = "CARD_" setget ,get_card_id # unique ID for the card, going CARD_<SUIT>_<NAME>
var TITLE = "" setget ,get_title # human-readable display name
var SUIT = -1 setget ,get_suit # corresponds to SUITS enum in cards/suits.gd
var POWER = -1 setget ,get_power # power level of the card
var ICON = null setget ,get_icon # Texture for the card's icon (typically, the suit icon)
var ILLUSTRATION = null setget ,get_illustration # Texture for the card's illustration
var DESCRIPTION = "" setget ,get_description # long string of this card's description (QUESTION should/can this be marked up?)

var EFFECTS = [] setget ,get_effects


func _init(owner_id, card_params):
  self.OWNER_ID = owner_id
  slurp_params(card_params)


func slurp_params(params):
  # TODO make params a class in dealer
  if 'id' in params:
    self.ID += params['id']

  if 'title' in params:
    self.TITLE += params['title']

  if 'suit' in params:
    self.SUIT = params['suit']

  if 'power' in params:
    self.POWER = params['power']

  if 'icon' in params:
    self.ICON= params['icon']

  if 'illustration' in params:
    self.ILLUSTRATION = params['illustration']

  if 'description' in params:
    self.DESCRIPTION = params['description']

  if 'effects' in params:
    self.EFFECTS = params['effects']


func play(board, river):
  _onplay(board, river)
  emit_signal('played', self)


func activate(board, river, against):
  _onactivate(board, river, against)
  emit_signal('activated', self)


func cleared(board, river):
  _onclear(board, river)
  emit_signal('cleared', self)


"""
==== OVERRIDEABLES
"""


func _onplay(board, river):
  pass


func _onactivate(board, river, against):
  pass


func _onclear(board, river):
  pass


func _load_template():
  var template = _TEMPLATE_.instance()
  # set up template instance
  # this means overlaying the template with card data, image, modifiers, etc.
  return template.build(self)


"""
==== GETTERS
"""


func get_packed_data():
  var data = {
    'owner_id':    get_owner_id(),
    'id':          get_card_id(),
    'title':       get_title(),
    'suit':        get_suit(),
    'power':       get_power(),
    'icon':        get_icon(),
    'description': get_description()
  }
  return data


func get_as_ui_element():
  return _load_template()


func get_owner_id():
  return OWNER_ID


func get_card_id():
  return ID


func get_title():
  return TITLE


func get_suit():
  return SUIT


func get_suit_as_str():
  return CARD_SUITS.NAMES[SUIT]


func get_power():
  return POWER


func get_icon():
  return ICON


func get_illustration():
  return ILLUSTRATION


func get_description():
  return DESCRIPTION


func get_effects():
  return EFFECTS
