extends TextureRect

var _POINTER_ = preload( "res://cards/ui/card_pointer.gd" )

var CARD = null

var hovered = false
var bigger = false
var pointing = false

# == OVERRIDES == #

func _init():
  set_custom_minimum_size( texture.get_size() )

func _ready():
  connect( 'mouse_entered', self, '_on_mouse_enter' )
  connect( 'mouse_exited', self, '_on_mouse_exit' )

func _input( ev ):
  # Mouse in viewport coordinates
  if ev is InputEventMouseButton:
    if hovered:
      if ev.is_pressed():
        # make a new line pointer
        point()
    else:
      # if pointing:
      #   shrink()
      #   pointing = false
      if bigger and !ev.is_pressed():
        pointing = false
        shrink()

func _on_mouse_enter():
  hovered = true
  grow()

func _on_mouse_exit():
  hovered = false
  if !pointing:
    shrink()

# == ACTIONS == #

func build( card ):
  CARD = card
  # TODO actually overlay all the elements with data from the card
  return

func point():
  var ptr = _POINTER_.new( self, get_pointer_origin() )
  add_child( ptr )
  ptr.point_to( get_viewport().get_mouse_position() )
  pointing = true
  player_data.pick_up_card( CARD )

func grow():
  rect_size = rect_size * 2
  # print( rect_size )
  # print( margin_left, ' ', margin_top, ' ', margin_right, ' ', margin_bottom )
  bigger = true

func shrink():
  rect_size = rect_size / 2
  # print( rect_size )
  # print( margin_left, ' ', margin_top, ' ', margin_right, ' ', margin_bottom )
  bigger = false

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
