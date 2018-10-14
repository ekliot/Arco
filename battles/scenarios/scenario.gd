"""
Here a framework is defined for scenarios, including parameter structure, signals, and methods
"""

extends Object

const enemy_root = null
const enemy_minion_a = null
const enemy_minion_b = null
const enemy_minion_c = null
const enemy_minion_d = null

func _init():
  pass

func get_enemies():
  return {'root': self.enemy_root, 'minions': self.get_enemy_minions()}

func get_enemy_root():
  return self.enemy_root

func get_enemy_minions():
  return {
    'a': enemy_minion_a,
    'b': enemy_minion_b,
    'c': enemy_minion_c,
    'd': enemy_minion_d
  }
