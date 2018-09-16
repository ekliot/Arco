"""
a dump for cards, decks, and analyses on those

TODO will be worth breaking this up into a module
TODO load effects, cards, and/or decks from JSON data, define JSON format for those
TODO make a database or something for a card prototyping library -- the goal is
     to be able to draft up a card or deck, have it be slurped into the database,
     and run analysis on it
"""

from enum import Enum

class Suits(Enum):
  WILD = 0
  BLADES = 1
  BONES = 2
  STARS = 3
  STONES = 4

AFF_TEMPLATE = {
  Suits.WILD: 0,
  Suits.BLADES: 0,
  Suits.BONES: 0,
  Suits.STARS: 0,
  Suits.STONES: 0
}

def affinity_to_str(affinity, indent=1):
  str_l = []

  for suit, aff in affinity.items():
    str_l.append( "\t" * indent )
    str_l.append( "%s\t// %d\n" % (suit.name, aff) )

  return ''.join(str_l)


class Effect(object):
  def __init__(self, name, primary=Suits.WILD, secondary=Suits.WILD):
    self.name = name
    self.suit_primary = primary
    self.suit_secondary = secondary
    self.affinity = self.affinity()

  def affinity(self):
    aff = AFF_TEMPLATE.copy()
    for suit in Suits:
      a = 0
      if suit is self.suit_primary:
        a += 2
      elif suit is self.suit_secondary:
        a += 1
      aff[suit] = a
    return aff

EFFECTS = {
  'damage':   Effect( 'damage' ),
  'block':    Effect( 'block' ),

  'exploit':  Effect( 'exploit', Suits.BLADES ),
  'armour':   Effect( 'armour', Suits.BONES ),
  'draw':     Effect( 'draw', Suits.STARS ),
  'heal':     Effect( 'heal', Suits.STONES ),

  'focus':    Effect(   'focus', Suits.BLADES, Suits.BONES ),
  'pierce':   Effect(  'pierce', Suits.BLADES, Suits.STARS ),
  'bleed':    Effect(   'bleed', Suits.BLADES, Suits.STONES ),

  'pin':      Effect(     'pin', Suits.BONES, Suits.BLADES ),
  'reflect':  Effect( 'reflect', Suits.BONES, Suits.STARS ),
  'stun':     Effect(    'stun', Suits.BONES, Suits.STONES ),

  'shock':    Effect(   'shock', Suits.STARS, Suits.BLADES ),
  'burn':     Effect(    'burn', Suits.STARS, Suits.BONES ),
  'freeze':   Effect(  'freeze', Suits.STARS, Suits.STONES ),

  'poison':   Effect(  'poison', Suits.STONES, Suits.BLADES ),
  'minion':   Effect(  'minion', Suits.STONES, Suits.BONES ),
  'weak':     Effect(    'weak', Suits.STONES, Suits.STARS )
}

MULTS = {
  'aoe': 3
}

class Card(object):
  def __init__( self, name, suit, power, effects ):
    self.name = name
    self.suit = suit
    self.power = power
    self.effects = effects
    self.magnitude = self.calc_magnitude()
    self.affinity = self.calc_affinty()

  def calc_magnitude( self ):
    sum = 0

    for mag in self.effects.values():
      sum += mag

    return sum

  def calc_affinty( self ):
    aff = AFF_TEMPLATE.copy()

    for effect, magnitude in self.effects.items():
      if not effect in EFFECTS:
        effect, *mults = effect.split( '_' )

        mult = 0
        for m in mults:
          mult += MULTS[m]

        mult = mult if mult else 1 # if mult == 0 then mult = 1
        magnitude = magnitude * mult

      e_aff = EFFECTS[effect].affinity

      for suit in aff:
        aff[suit] += e_aff[suit] * magnitude

    return aff

class Deck(object):
  def __init__( self, cards ):
    self.cards = cards
    self.affinity = self.calc_affinty()

  def calc_affinty(self):
    aff = AFF_TEMPLATE.copy()
    for card in self.cards:
      aff_c = card.affinity
      for s, a in aff_c.items():
        aff[s] += a
    return aff

if __name__ == '__main__':
  deck01_cards = [
    Card(
      "Slash", Suits.BLADES, 1,
      {'damage': 2}
    ),
    Card(
      "Guarded Strike", Suits.BLADES, 1,
      { 'block': 2, 'damage': 1 }
    ),
    Card(
      "Observe", Suits.BLADES, 1,
      { 'exploit': 2, 'block': 1 }
    ),
    Card(
      "Setup", Suits.BLADES, 1,
      { 'block': 1, 'focus': 1, 'exploit': 2 }
    ),

    Card(
      "Thrust", Suits.BLADES, 2,
      { 'pierce': 3, 'damage': 2 }
    ),
    Card(
      "Razor's Edge", Suits.BLADES, 2,
      {'bleed': 2, 'block': 4}
    ),
    Card(
      "Guiding Slice", Suits.BLADES, 2,
      {'damage': 4, 'exploit': 2, 'focus': 1}
    ),

    Card(
      "Bait", Suits.BLADES, 3,
      {'block': 2, 'exploit': 3, 'focus': 3}
    ),
    Card(
      "Cleave", Suits.BLADES, 3,
      {'damage_aoe': 3}
    ),

    Card(
      "Vampiric Spear", Suits.BLADES, 4,
      {'heal': 2, 'focus': 2, 'damage': 5, 'pierce': 2}
    ),
  ]

  for card in deck01_cards:
    print( '%s =>\n%s' % ( card.name, affinity_to_str( card.affinity ) ) )

  deck01 = Deck( deck01_cards )
  print( affinity_to_str( deck01.affinity ) )
