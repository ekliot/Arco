extends TextureRect

var _POINTER_ = preload( "res://cards/ui/card_pointer.gd" )

var hovered = false
var bigger = false

func _init():
  set_custom_minimum_size( texture.get_size() )

func _ready():
  connect( 'mouse_entered', self, '_on_mouse_enter' )
  connect( 'mouse_exited', self, '_on_mouse_exit' )

func _input( ev ):
  print( rect_size )
  print( rect_global_position )
  # Mouse in viewport coordinates
  if ev is InputEventMouseButton:
    if hovered and ev.is_pressed():
      # make a new line pointer
      var ptr = _POINTER_.new( self, get_pointer_origin() )
      add_child( ptr )
      ptr.point_to( get_viewport().get_mouse_position() )
    if bigger and !ev.is_pressed():
      shrink()

func _on_mouse_enter():
  hovered = true
  grow()

func _on_mouse_exit():
  hovered = false
  shrink()

func grow():
  rect_size = rect_size * 2
  bigger = true

func shrink():
  rect_size = rect_size / 2
  bigger = false

func get_pointer_origin():
  return Vector2( rect_size.x / 2, 0 )
