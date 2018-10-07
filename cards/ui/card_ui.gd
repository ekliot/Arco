extends TextureRect

signal card_played(card, sprite)
signal card_discarded(card, sprite)

var _POINTER_ = preload( "res://cards/ui/CardPointer.tscn" )
# var _POINTER_ = preload( "res://cards/ui/card_pointer.gd" ) # this doesn't work for some reason

var CARD = null setget ,get_card

var shrink_size = null
var grow_size = null

var pointer = null

var flipped = false setget, is_flipped
var hovered = false setget ,is_hovered
var bigger = false setget ,is_bigger
var pointing = false setget ,is_pointing

# == OVERRIDES == #

func _init():
  # TODO set size proportional to UI
  # TODO connect to UI resizing and set size based on that
  set_size_params()
  set_custom_minimum_size( shrink_size )

func _ready():
  $Tween.connect( 'tween_completed', self, '_on_tween_complete' )

func _input( ev ):
  if ev is InputEventMouseMotion and player_data.can_hold( CARD ):
    hovered = ui_helper.is_mouse_inside( get_global_rect() )
    if hovered: # and not get_parent().is_examining():
      grow()
      # get_parent().examine_card( self )
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

func _on_card_played( card ):
  emit_signal( 'card_played', card, self )

func _on_card_discarded( card ):
  emit_signal( 'card_discarded', card, self )

func _on_tween_complete( obj, key ):
  if key == "set_custom_minimum_size":
    if get_custom_minimum_size() == shrink_size:
      bigger = false
    elif get_custom_minimum_size() == grow_size:
      bigger = true

# == ACTIONS == #

func build( card ):
  CARD = card
  self.name = card.get_title() + "_UI"
  # TODO actually overlay all the elements with data from the card
  return self

func pick_up():
  player_data.pick_up_card( CARD )
  pointer = point()

func drop_me():
  player_data.drop_card()

  if pointer.is_locked():
    if BM.validate_play( CARD, pointer.lockon.get_river_id() ):
      BM.play_card( CARD, pointer.lockon.get_river_id() )

  else:
    reset()

func reset():
  pointer.queue_free()
  pointing = false
  shrink()

func point():
  # var ptr = _POINTER_.new( self, get_pointer_origin() )
  var ptr = _POINTER_.instance()
  add_child( ptr )
  ptr.point_to( get_viewport().get_mouse_position() )
  pointing = true

  # connect pointer to valid river nodes
  BM.get_rivers_ui( 'Hero' ).connect_to_card_pointer( CARD, ptr )

  return ptr

func grow():
  if not bigger:
    $Tween.interpolate_method(
      self, 'set_custom_minimum_size',
      get_custom_minimum_size(), grow_size,
      0.1, 0, 0
    )
    $Tween.start()

func shrink():
  if bigger:
    $Tween.interpolate_method(
      self, 'set_custom_minimum_size',
      get_custom_minimum_size(), shrink_size,
      0.1, 0, 0
    )
    $Tween.start()

# == SETTERS == #

func set_size_params( _min=null, _max=null ):
  if _min:
    shrink_size = _min
  else:
    shrink_size = texture.get_size()

  if _max:
    grow_size = _max
  else:
    grow_size = shrink_size * 2

# == GETTERS == #

func get_card():
  return CARD

func get_pointer_origin():
  return Vector2( rect_size.x / 2, 0 )

func is_hovered():
  return hovered

func is_bigger():
  return bigger

func is_pointing():
  return pointing

func is_flipped():
  return flipped
