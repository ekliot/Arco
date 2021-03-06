extends Node

signal card_added(card, set)
signal card_removed(card, set)
signal shuffled(new_set)

var cards = [] setget set_cards,get_cards

func _init(_cards=null ):
  if _cards:
    set_cards(_cards)

func transfer(dest):
  for card in cards:
    remove_card(card)
    dest.add_card(card)

func add_card(card):
  if card:
    cards.push_back(card)
    add_child(card)
    # LOGGER.info(self, '%s added %s' % [get_parent().name if get_parent() else '', card.name])
    emit_signal('card_added', card, get_cards())
  else:
    LOGGER.error(self, "%s can't add null" % get_parent().name())
  return card

func remove_card(card):
  if has(card):
    cards.erase(card)
    remove_child(card)
    # LOGGER.info(self, "removed %s's card %s" % [get_parent().name, card.name])
    emit_signal('card_removed', card, cards)
  else:
    LOGGER.warn(self, "%s can't remove %s (not in set)" % [get_parent().name, card.name])
  return card

func draw():
  if is_empty():
    LOGGER.warn(self, "%s can't draw from an empty set!")
    return null
  var draw = cards.front()
  return remove_card(draw)

func shuffle():
  emit_signal('shuffled', get_cards())
  # TODO shuffle algo

func sample():
  # TODO pick random idx
  if not is_empty():
    var idx = 0
    var card = cards[idx]
    return remove_card(card)
  else:
    return null

func is_empty():
  return cards.empty()

func has(card):
  return card and card in cards

func clear():
  for c in cards:
    remove_card(c)

func set_cards(_cards):
  for c in _cards:
    add_card(c)

func get_cards():
  return [] + cards

func to_s():
  var out = "<"
  for c in cards:
    if cards.find(c): # basically, "if c not first in cards"
      out += ", "
    out += c.name
  out += ">"
  return out
