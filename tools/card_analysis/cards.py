from suits import *
from effects import *

class Card(object):
  def __init__(self, name, suit, power, effects):
    self.name = name
    self.suit = suit
    self.power = power
    self.effects = effects
    self.magnitude = self.calc_magnitude()
    self.affinity = self.calc_affinty()

  @staticmethod
  def from_dict(**kwargs):
    args = ['name', 'suit', 'power', 'effects']
    args = {k: v for k, v in kwargs.items() if k in args}
    return Card(args['name'], args['suit'], args['power'], args['effects'])

  def calc_magnitude( self ):
    sum = 0

    for mag in self.effects.values():
      sum += mag

    return sum

  def calc_affinty( self ):
    aff = AFF_TEMPLATE.copy()

    for effect, magnitude in self.effects.items():
      if not effect in CARD_EFFECTS:
        effect, *mults = effect.split( '_' )

        mult = 0
        for m in mults:
          mult += MULTS[m]

        mult = mult if mult else 1 # if mult == 0 then mult = 1
        magnitude = magnitude * mult

      e_aff = CARD_EFFECTS[effect].affinity

      for suit in aff:
        aff[suit] += e_aff[suit] * magnitude

    return aff
