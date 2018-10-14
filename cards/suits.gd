extends Node

enum SUITS { BLADES, BONES, STARS, STONES }

const NAMES = {
  BLADES: 'blades',
  BONES:  'bones',
  STARS:  'stars',
  STONES: 'stones'
}

const ICONS = { # TODO
  BLADES: preload("res://cards/assets/blades.png"),
  BONES:  preload("res://cards/assets/bones.png"),
  STARS:  preload("res://cards/assets/stars.png"),
  STONES: preload("res://cards/assets/stones.png")
}

func get_blades_str():
  return get_str_by_id(BLADES)

func get_bones_str():
  return get_str_by_id(BONES)

func get_stars_str():
  return get_str_by_id(STARS)

func get_stones_str():
  return get_str_by_id(STONES)

func get_blades_id():
  return BLADES

func get_bones_id():
  return BONES

func get_stars_id():
  return STARS

func get_stones_id():
  return STONES

func get_blades_icon():
  return ICONS[BLADES]

func get_bones_icon():
  return ICONS[BONES]

func get_stars_icon():
  return ICONS[STARS]

func get_stones_icon():
  return ICONS[STONES]

func get_icon_by_id(id):
  return ICONS[id]

func get_str_by_id(id):
  return NAMES[id]

func get_id_by_str(s):
  match(s):
    'blades':
      return BLADES
    'bones':
      return BONES
    'stars':
      return STARS
    'stones':
      return STONES

func get_icon_by_str(s):
  var id = get_id_by_str(s)
  return ICONS[id]
