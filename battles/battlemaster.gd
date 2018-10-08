"""
provides constants used across all classes
provides functionality for all other classes to access and interact the Battle scene
(in effect, an MVC controller)
"""

extends Node

enum FIGHTERS { HERO, CPU }
enum MOVES { PLAY, SWAP, PASS }

const MAX_MOMENTUM = 4

const RIVER_IDS = [ 'a', 'b', 'c', 'd' ]

const _HERO_ = preload( "res://characters/heroes/hero.gd" )

# == RULES == #

# QUESTION is it worth including global interpreters and queries for game rules here?
# e.g. what momentums is a card valid for?
# NOTE yes, yes it is
# TODO rule handling

func validate_play( card, river_id ):
  var who = card.OWNER_ID
  return get_battle().can_place_card( who, card, river_id )

# == MOVES == #

func play_card( card, river_id ):
  return get_battle().play_card( card, river_id )

func enemy_move( card, river_id ):
  """
  tell Battle that the enemy wants to make this move
  the Battle is expected to
  """
  # TODO do this
  pass

# == HELPERS == #

func is_player( who ):
  return who is _HERO_ # lol

# == MODELS == #

func get_battle():
  return get_node( "/root/Battle" )

func get_board():
  return get_battle().get_board()

func get_hero():
  return get_battle().get_fighter( HERO )

func get_enemy():
  return get_battle().get_fighter( CPU )

func fighter_id_to_str( id ):
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

func get_deck_ui():
  return get_battle_ui().get_deck()

func get_hand_ui():
  return get_battle_ui().get_hand()

func get_rivers_ui( who ):
  return get_battle_ui().get_rivers( who )

func get_river_ui( who, river_id ):
  get_rivers_ui( who ).get_river( river_id )

func get_river_step_ui( who, river_id, level ):
  get_river_ui( who, river_id ).get_step( level )
