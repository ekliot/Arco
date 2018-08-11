extends CenterContainer

export (int) var MOMENTUM_LEVEL = -1

var MODEL = null

var active_card = null
var active_card_icon = null

# == CORE == #

func connect_to_model( step_model ):
  MODEL = step_model

func place_card( card ):
  if is_active():
    active_card_icon.queue_free()

  # TODO make CardIcon scene instead of using TextureRect
  var text_rect = TextureRect.new()
  text_rect.set_texture( card.get_icon() )

  add_child( text_rect )
  active_card = card
  active_card_icon = text_rect

func clear_card():
  if is_active():
    active_card = null
    active_card_icon.queue_free()

# == DnD API == #

func can_drop_data( pos, data ):
  print( 'can place?', pos )
  # TODO check with BATTLE if card is playable
  if MODEL.can_place_card( data.card ):
    print( 'can place' )
    data.pointer.lock_to( rect_global_position + get_center() )
    return true
  print( 'cannot place' )
  return false

func drop_data( pos, data ):
  # TODO actually place the card in and fire off the card play signals
  print( "card placed:", data.card )
  pass

func preview_icon( card ):
  # TODO
  # set a semi-transparent icon for the card to preview its placement
  pass

# == GETTERS == #

func is_active():
  return active_card != null

func get_active_card():
  return active_card

func get_center():
  return rect_size / 2
