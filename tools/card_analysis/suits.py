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

SUIT_STRINGS = {
  'wild': Suits.WILD,
  'blades': Suits.BLADES,
  'bones': Suits.BONES,
  'stars': Suits.STARS,
  'stones': Suits.STONES
}

def str_to_suit(suit_str):
  return SUIT_STRINGS.get(suit_str, None)

def affinity_to_str(affinity, indent=1):
  str_l = []

  for suit, aff in affinity.items():
    str_l.append( "\t" * indent )
    str_l.append( "%s\t// %d\n" % (suit.name, aff) )

  return ''.join(str_l)
