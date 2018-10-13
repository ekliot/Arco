import json

from suits import *
from effects import *
from cards import *

class Deck(object):
  def __init__(self, name, cards):
    self.name = name
    self.cards = cards
    self.affinity = self.calc_affinty()

  @staticmethod
  def from_json(json_uri):
    deck = None

    with open(json_uri, 'r') as deck_json:
      data = json.load(deck_json)
      cards = data.get('cards')
      for idx, card in enumerate(cards):
        card['suit'] = str_to_suit(card['suit'])
        # card['effects'] = [CARD_EFFECTS.get(effect): magnitude for effect, magnitude in card['effects'].items()]
        cards[idx] = Card.from_dict(**card)
      deck = Deck(data.get('name'), cards)

    return deck

  def calc_affinty(self):
    aff = AFF_TEMPLATE.copy()
    for card in self.cards:
      aff_c = card.affinity
      for s, a in aff_c.items():
        aff[s] += a
    return aff
