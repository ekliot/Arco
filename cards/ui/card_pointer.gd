extends Line2D

var source = null
var origin = null
var lockon = null

func _ready():
  source = get_parent()
  origin = source.get_pointer_origin()
  add_point( origin )

func _input( ev ):
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

func lock_to( pos, node ):
  if !is_locked():
    lockon = node
    point_to( pos )

func unlock():
  if is_locked():
    lockon = null
    point_to( get_viewport().get_mouse_position() )

func is_locked():
  return lockon != null

func get_lockon():
  return lockon
