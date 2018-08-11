extends TextureRect

var _POINTER_ = preload( "res://cards/ui/card_pointer.gd" )
onready var pointer_orig = Vector2( rect_size.x / 2, 0 )

func _ready():
  # connect( 'mouse_entered', self, '_on_mouse_enter' )
  pass

func get_drag_data( pos ):
  # make a new line pointer
  var ptr = _POINTER_.new( self, pointer_orig )
  add_child( ptr )
  ptr.point_to( get_viewport().get_mouse_position() )
  return { 'card': null, 'pointer': ptr }
