extends CenterContainer

signal pointer_lockon # lock_position, river_step
signal pointer_unlock

export (int) var MOMENTUM_LEVEL = -1

var MODEL = null

var active_card = null
var active_card_icon = null

# == CORE == #

func _ready():
  connect( 'mouse_entered', self, '_pointer_lockon' )
  connect( 'mouse_exited', self, '_pointer_unlock' )

func connect_to_model( step_model ):
  MODEL = step_model

func _pointer_lockon():
  emit_signal( 'pointer_lockon', get_pointer_lock(), self )

func _pointer_unlock():
  emit_signal( 'pointer_unlock' )

func valid_for( card ):
  return MODEL.valid_for( card )

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

# == GETTERS == #

func is_active():
  return active_card != null

func get_active_card():
  return active_card

func get_momentum():
  return MOMENTUM_LEVEL

func get_center():
  return rect_size / 2

func get_pointer_lock():
  return rect_global_position + Vector2( rect_size.x / 2, rect_size.y )
