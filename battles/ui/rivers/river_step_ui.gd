extends CenterContainer

signal pointer_lockon(pos, river)
signal pointer_unlock()

var MODEL = null
var MOMENTUM_LEVEL = -1 setget ,get_momentum

var active_card = null setget ,get_active_card
onready var active_card_icon = $Icon

var hovered = false setget ,is_hovered


"""
==== OVERRIDES
"""


func _ready():
  connect('mouse_entered', self, '_pointer_lockon')
  connect('mouse_exited', self, '_pointer_unlock')


func _input(ev):
  if ev is InputEventMouseMotion:
    var inside = UI_HELPER.is_mouse_inside(get_global_rect())
    if inside and !is_hovered():
      hovered = true
      _pointer_lockon()
    elif !inside and is_hovered():
      hovered = false
      _pointer_unlock()


"""
==== SIGNALS
"""


func connect_to_model(step_model):
  MODEL = step_model
  MOMENTUM_LEVEL = MODEL.get_momentum()
  MODEL.connect('card_placed', self, '_on_model_card_placed')
  MODEL.connect('card_cleared', self, '_on_model_card_cleared')
  MODEL.connect('card_activated', self, '_on_model_card_activated')


func _on_model_card_placed(card):
  clear_card()
  active_card = card
  replace_icon(card.get_icon())


func _on_model_card_cleared(card):
  clear_card()


func _on_model_card_activated(card):
  # TODO fancy graphical effects
  pass


# NOTE for some reason, these signals are being emitted twice if the child
# TextureRect mouse filter is set to Ignore. This must be done, or else the
# child will block mouse events (even if set to pass)


func _pointer_lockon():
  emit_signal('pointer_lockon', get_pointer_lock(), self)


func _pointer_unlock():
  emit_signal('pointer_unlock')


"""
==== CORE
"""


func valid_for(card):
  return MODEL.valid_for(card)


func clear_card():
  if is_active():
    active_card = null
    active_card_icon.texture = null


func replace_icon(texture):
  $Icon.texture = texture


"""
==== GETTERS
"""


func is_active():
  return active_card != null


func is_hovered():
  return hovered


func get_river_id():
  return MODEL.RIVER.RIVER_ID


func get_active_card():
  return active_card


func get_momentum():
  return MOMENTUM_LEVEL


func get_center():
  return rect_size / 2


func get_pointer_lock():
  return rect_global_position + Vector2(rect_size.x / 2, rect_size.y)
