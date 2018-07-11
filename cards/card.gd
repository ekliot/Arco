extends Node

signal played
signal activated
signal discarded

var POWER = -1

var EFFECTS = {
  'onplay': {},
  'onactivate': {},
  'ondiscard': {}
}

func play():
  emit_signal( played, self )
