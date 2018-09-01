extends CenterContainer

signal pointer_lockon # lock_position, river_step
signal pointer_unlock

var MODEL = null
var MOMENTUM_LEVEL = -1 setget ,get_momentum

var active_card = null setget ,get_active_card
onready var active_card_icon = $Icon

var hovered = false setget ,is_hovered

# == CORE == #

func _ready():
  connect( 'mouse_entered', self, '_pointer_lockon' )
  connect( 'mouse_exited', self, '_pointer_unlock' )

func _input( ev ):
  if ev is InputEventMouseMotion:
    var inside = ui_helper.is_mouse_inside( get_global_rect() )
    if inside and !is_hovered():
      hovered = true
      _pointer_lockon()
    elif !inside and is_hovered():
      hovered = false
      _pointer_unlock()

func connect_to_model( step_model ):
  MODEL = step_model
  MOMENTUM_LEVEL = MODEL.get_momentum()

# NOTE for some reason, these signals are being emitted twice if the child
# TextureRect mouse filter is set to Ignore. This must be done, or else the
# child will block mouse events (even if set to pass)

func _pointer_lockon():
  emit_signal( 'pointer_lockon', get_pointer_lock(), self )

func _pointer_unlock():
  emit_signal( 'pointer_unlock' )

func valid_for( card ):
  return MODEL.valid_for( card )

func place_card( card ):
  # MODEL.place_card( card )
  active_card = card
  replace_icon( card.get_icon() )

func clear_card():
  if is_active():
    active_card = null
    active_card_icon.queue_free()

# == TEXTURE CONTROL == #

func replace_icon( texture ):
  # TODO
  # if is_active():
  #   active_card_icon.queue_free()

  active_card_icon.queue_free()
  # TODO make CardIcon scene instead of using TextureRect
  var trect = TextureRect.new()
  trect.texture = texture
  add_child( trect )
  trect.name = "Icon"

# == GETTERS == #

func is_active():
  return active_card != null

func is_hovered():
  return hovered

func get_active_card():
  return active_card

func get_momentum():
  return MOMENTUM_LEVEL

func get_center():
  return rect_size / 2

func get_pointer_lock():
  return rect_global_position + Vector2( rect_size.x / 2, rect_size.y )
