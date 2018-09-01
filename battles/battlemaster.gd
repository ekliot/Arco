extends Node

enum FIGHTERS { HERO, CPU }
enum MOVES { PLAY, SWAP, PASS }
const MAX_MOMENTUM = 4

# == MODELS == #

func get_battle():
  return get_node( "/root/Battle" )

func hero_id_to_str( id ):
  # NOTE match doesn't work here for some reason
  match(id):
    HERO:
      return "Hero"
    CPU:
      return "Enemy"
  return ""

# == VIEWS == #

func get_battle_ui():
  return get_battle().get_node( "BattleUI" )

func get_rivers_ui( who ):
  return get_battle_ui().get_rivers( who )

func get_river_ui( who, river_id ):
  get_rivers_ui( who ).get_river( river_id )

func get_river_step_ui( who, river_id, level ):
  get_river_ui( who, river_id ).get_step( level )
