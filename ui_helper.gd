extends Node

func is_mouse_inside(rect):
  var mpos = get_viewport().get_mouse_position()
  var mrect = Rect2(mpos, Vector2(1, 1))
  return rect.encloses(mrect)
