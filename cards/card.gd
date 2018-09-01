extends Node

signal played
signal activated
signal discarded

var _TEMPLATE_ = preload( "res://cards/ui/CardUI.tscn" )

var OWNER_ID = null

var ID = "CARD_"        # unique ID for the card, going CARD_<SUIT>_<NAME>
var TITLE = ""          # human-readable display name
var SUIT = -1           # corresponds to SUITS enum in cards/suits.gd
var POWER = -1          # power level of the card
var ICON = null         # Texture for the card's icon (typically, the suit icon)
var ILLUSTRATION = null # Texture for the card's illustration
var DESCRIPTION = ""    # long string of this card's description (QUESTION should/can this be marked up?)

func _init( owner_id, card_params ):
  self.OWNER_ID = owner_id
  slurp_params( card_params )

func slurp_params( params ):
  # TODO make params a class in dealer
  if params.has( 'id' ):
    self.ID += params['id']

  if params.has( 'title' ):
    self.TITLE += params['title']

  if params.has( 'suit' ):
    self.SUIT = params['suit']

  if params.has( 'power' ):
    self.POWER = params['power']

  if params.has( 'icon' ):
    self.ICON= params['icon']

  if params.has( 'illustration' ):
    self.ILLUSTRATION= params['illustration']

  if params.has( 'description' ):
    self.DESCRIPTION= params['description']

func play( board, river ):
  _onplay( board, river )
  emit_signal( 'played', self )

func activate( board, river ):
  _onactivate( board, river )
  emit_signal( 'activated', self )

func discard( board, river ):
  _ondiscard( board, river )
  emit_signal( 'discarded', self )

# ============= #
# OVERRIDEABLES #
# ============= #

func _onplay( board ):
  pass

func _onactivate( board ):
  pass

func _ondiscard( board ):
  pass

func _load_template():
  var template = _TEMPLATE_.instance()
  # set up template instance
  # this means overlaying the template with card data, image, modifiers, etc.
  template.build( self )
  return template

# == GETTERS == #

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
  return card_suits.NAMES[SUIT]

func get_power():
  return POWER

func get_icon():
  return ICON

func get_description():
  return DESCRIPTION
