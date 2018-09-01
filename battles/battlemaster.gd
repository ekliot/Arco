extends Node

func get_battle():
  return get_node( "/root/Battle" )

func get_battle_ui():
  return get_battle().get_node( "BattleUI" )

func get_rivers_ui( who ):
  return get_battle_ui().get_rivers( who )

func get_river_ui( who, river_id ):
  get_rivers_ui( who ).get_river( river_id )

func get_river_step_ui( who, river_id, level ):
  get_river_ui( who, river_id ).get_step( level )

func get_hero_id():
  return get_battle().HERO

func get_cpu_id():
  return get_battle().CPU

func hero_id_to_str( id ):
  # NOTE match doesn't work here for some reason
  if id == get_hero_id():
    return "Hero"
  elif id == get_cpu_id():
    return "CPU"
  return ""
