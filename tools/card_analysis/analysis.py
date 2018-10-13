from decks import *

"""
a dump for cards, decks, and analyses on those

TODO will be worth breaking this up into a module
TODO load effects, cards, and/or decks from JSON data, define JSON format for those
TODO make a database or something for a card prototyping library -- the goal is
     to be able to draft up a card or deck, have it be slurped into the database,
     and run analysis on it
"""

if __name__ == '__main__':
  import os
  pwd = os.path.dirname(os.path.realpath(__file__))
  deck01 = Deck.from_json(os.path.join(pwd, 'decks/blades_01.json'))

  print(affinity_to_str(deck01.affinity))

  # for card in deck01_cards:
  #   print( '%s =>\n%s' % ( card.name, affinity_to_str( card.affinity ) ) )
