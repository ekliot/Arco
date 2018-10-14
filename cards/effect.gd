extends Object

const NAME = "" setget ,get_name
const DESCRIPTION = "" setget ,get_description
const SUIT_PRIMARY = null setget ,get_primary
const SUIT_SECONDARY = null setget ,get_secondary

var magnitude = -1 setget ,get_magnitude


func _init(mag):
  self.magnitude = mag


func _on_activate(a, b, c):
  pass


func _on_trigger(a, b, c):
  pass


func _on_play(a, b, c):
  pass


func get_name():
  return NAME


func get_description():
  return DESCRIPTION


func get_primary():
  return SUIT_PRIMARY


func get_secondary():
  return SUIT_SECONDARY


func get_magnitude():
  return magnitude
