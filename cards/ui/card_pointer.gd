extends Line2D

var source = null
var origin = null
var locked = false

func  _init( src, orig ):
  origin = orig
  source = src
  add_point( orig )

func _input( ev ):
  if ev is InputEventMouseButton:
    # delete the node when the mouse is released
    if !source.is_hovered() and !ev.is_pressed():
      queue_free()

  if ev is InputEventMouseMotion:
    if !is_locked():
      point_to( ev.position )

func point_to( dest ):
  clear_points()
  # TODO make a fancier line
  add_point( dest - source.get_global_position() )

func clear_points():
  while get_point_count() > 1:
    remove_point( 1 )

func lock_to( pos ):
  locked = true
  point_to( pos )

func unlock():
  locked = false

func is_locked():
  return locked
