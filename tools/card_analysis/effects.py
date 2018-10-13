from suits import *

class Effect(object):
  def __init__(self, name, primary=Suits.WILD, secondary=Suits.WILD):
    self.name = name
    self.suit_primary = primary if primary in Suits else str_to_suit(primary)
    self.suit_secondary = secondary if secondary in Suits else str_to_suit(secondary)
    self.affinity = self.affinity()

  def affinity(self):
    aff = AFF_TEMPLATE.copy()
    for suit in aff:
      if suit is self.suit_primary:
        aff[suit] += 2
      elif suit is self.suit_secondary:
        aff[suit] += 1
    return aff

CARD_EFFECTS = {
  'damage':   Effect('damage'),
  'guard':    Effect('guard'),

  'exploit':  Effect('exploit'), #, Suits.BLADES),
  'armour':   Effect( 'armour'), #, Suits.BONES),
  'draw':     Effect(   'draw'), #, Suits.STARS),
  'heal':     Effect(   'heal'), #, Suits.STONES),

  'pierce':   Effect( 'pierce', Suits.BLADES, Suits.STARS),
  'bleed':    Effect(  'bleed', Suits.BLADES, Suits.STONES),

  'reflect':  Effect('reflect', Suits.BONES, Suits.STARS),
  'stun':     Effect(   'stun', Suits.BONES, Suits.STONES),

  'freeze':   Effect( 'freeze', Suits.STARS, Suits.BLADES),
  'burn':     Effect(   'burn', Suits.STARS, Suits.BONES),

  'poison':   Effect( 'poison', Suits.STONES, Suits.BONES),
  'weak':     Effect(   'weak', Suits.STONES, Suits.BLADES )
}

SIGNATURE_EFFECTS = {
  'focus':    Effect(  'focus', Suits.BLADES, Suits.BONES),
  'pin':      Effect(    'pin', Suits.BONES, Suits.BLADES),
  'shock':    Effect(  'shock', Suits.STARS, Suits.BLADES),
  'minion':   Effect( 'minion', Suits.STONES, Suits.BONES )
}

MULTS = {
  'aoe': 3
}
