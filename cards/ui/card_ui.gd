extends Control

signal tween_complete(key)
signal card_played(card, sprite)
signal card_discarded(card, sprite)

var _PIP_ = preload("res://cards/ui/Pip.tscn")
var _POINTER_ = preload("res://cards/ui/CardPointer.tscn")
var _DUMMY_ILLUSTRATION_ = preload("res://cards/assets/dummy_illustration.png")

var CARD = null setget ,get_card

var shrink_size = null
var grow_size = null

var pointer = null

var flipped = false setget, is_flipped
var hovered = false setget ,is_hovered
var bigger = false setget ,is_bigger
var pointing = false setget ,is_pointing

var last_pos
var in_position = false
var discard = false


# == OVERRIDES == #


func _init():
  # Set invisible for draw tween effect
  self.visible = false


func _ready():
  # TODO set size proportional to UI
  # TODO connect to UI resizing and set size based on that
  # DEV see hand_ui.add_card()
  set_size_params()
  set_custom_minimum_size(shrink_size)

  $Tween.connect('tween_completed', self, '_on_tween_complete')
  # $Tween.connect('tween_step', self, 'debug_tween')
  get_parent().connect('sort_children', self, '_on_sorted')


func debug_tween(o, k, e, v):
  if k == ":set_global_position":
    LOGGER.debug($Tween, o.name)
    LOGGER.debug($Tween, k)
    LOGGER.debug($Tween, e)
    LOGGER.debug($Tween, v)


func _input(ev):
  if ev is InputEventMouseMotion and PLAYER_DATA.can_hold(CARD):
    hovered = UI_HELPER.is_mouse_inside(get_global_rect())
    if hovered: # and not get_parent().is_examining():
      grow()
      # get_parent().examine_card(self)
    elif not pointing:
      shrink()

  # Mouse in viewport coordinates
  if ev is InputEventMouseButton:
    # TODO filtering based on which button
    if hovered:
      if not pointing and ev.is_pressed():
        pick_up()
    else:
      if pointing and not ev.is_pressed():
        drop_me()


func _on_tween_complete(obj, key):
  if key == ":set_custom_minimum_size":
    if get_custom_minimum_size() == shrink_size:
      bigger = false
    elif get_custom_minimum_size() == grow_size:
      bigger = true
  elif key == ":set_global_position": # and not in_position:
    if discard:
      emit_signal('tween_complete', key)
    elif not in_position:
      in_position = true
      emit_signal('tween_complete', key)
  elif key == ":set_modulate":
    if discard:
      emit_signal('tween_complete', key)


func _on_sorted():
  if not in_position and not discard:
    var start = BM.get_deck_ui().get_global_position()
    var final = get_global_position()
    $Tween.interpolate_method(
      self, 'set_global_position',
      start, final,
      0.3, 0, 0
    )
    self.visible = true
    $Tween.start()


# == ACTIONS == #


func build(card):
  CARD = card
  self.name = card.name + "_UI"
  # TODO actually overlay all the elements with data from the card

  var pips = get_pips()
  for i in range(card.POWER):
    var pip = _PIP_.instance()
    pip.texture = card.ICON
    pips.add_child(pip)

  var illustration = get_illustration()
  illustration.texture = card.ILLUSTRATION if card.ILLUSTRATION else _DUMMY_ILLUSTRATION_

  var desc = get_description()
  for effect in card.EFFECTS:
    desc.text += effect.get_desc_text() + "\n"

  return self


func pick_up():
  PLAYER_DATA.pick_up_card(CARD)
  pointer = point()


func drop_me():
  PLAYER_DATA.drop_card()

  if pointer.is_locked():
    if BM.validate_play(CARD, pointer.lockon.get_river_id()):
      BM.play_card(CARD, pointer.lockon.get_river_id())

  else:
    reset()


func reset():
  pointer.queue_free()
  pointing = false
  shrink()


func point():
  # var ptr = _POINTER_.new(self, get_pointer_origin())
  var ptr = _POINTER_.instance()
  add_child(ptr)
  ptr.point_to(get_viewport().get_mouse_position())
  pointing = true

  # connect pointer to valid river nodes
  BM.get_rivers_ui('Hero').connect_to_card_pointer(CARD, ptr)

  return ptr


func grow():
  if not bigger:
    $Tween.interpolate_method(
      self, 'set_custom_minimum_size',
      get_custom_minimum_size(), grow_size,
      0.05, 0, 0 # TODO refine these vals
    )
    $Tween.start()


func shrink():
  if bigger:
    $Tween.interpolate_method(
      self, 'set_custom_minimum_size',
      get_custom_minimum_size(), shrink_size,
      0.05, 0, 0 # TODO refine these vals
    )
    $Tween.start()


func remove(reason):
  var method = null
  var start = null
  var final = null
  var dur = null
  discard = true

  match reason:
    'discarded':
      start = get_global_position()
      final = BM.get_discard_ui().get_global_position()
      method = 'set_global_position'
      dur = 0.3
    'played':
      start = get_modulate()
      final = Color(1.0, 1.0, 1.0, 0.0)
      method = 'set_modulate'
      dur = 0.3

  $Tween.interpolate_method(
    self, method,
    start, final,
    dur, 0, 0
  )

  $Tween.start()


# == SETTERS == #


func set_size_params():
  var texture_size = get_node("Template").texture.get_size()
  shrink_size = texture_size
  grow_size = shrink_size * 2


"""
==== GETTERS == #
"""


func get_card():
  return CARD


func get_pointer_origin():
  return Vector2(rect_size.x / 2, 0)


# func get_margins():
#   return $Margins


func get_contents():
  # return get_margins().get_node("Contents")
  return get_node("Contents")


func get_pips():
  return get_contents().get_node("Pips")


func get_illustration():
  return get_contents().get_node("Illustration")


func get_description():
  return get_contents().get_node("DescriptionContainer/Description")


func is_hovered():
  return hovered


func is_bigger():
  return bigger


func is_pointing():
  return pointing


func is_flipped():
  return flipped
