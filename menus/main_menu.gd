extends MarginContainer

const MARGIN_V = 0.1
const MARGIN_H = 0.1

func _init():
  pass


func _ready():
  var vp = UI_HELPER.get_root_vp()
  vp.connect('size_changed', self, '_on_resize')
  get_start_button().connect('pressed', self, '_on_press_start')
  get_quit_button().connect('pressed', self, '_on_press_quit')


func _on_resize():
  var vp_size = UI_HELPER.get_root_vp().size
  self.margin_left = floor(MARGIN_H * vp_size.x)
  self.margin_right = -self.margin_left
  self.margin_top = floor(MARGIN_V * vp_size.y)
  self.margin_bottom = -self.margin_top


func _on_press_start():
  BM.load_battle()


func _on_press_quit():
  get_tree().quit()


func get_start_button():
  return get_node("ScreenSplit/Menu/Start")


func get_quit_button():
  return get_node("ScreenSplit/Menu/Quit")
