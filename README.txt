A simple card game being actively developed in Haxe, intended for 2-players. Currently being developed as a desktop application, but a possibility of web and/or mobile release.

===MECHANICS

Each player has a certain amount of health, and a current power level, which starts at 1.

The game is divided into turns, which are likewise divided into rounds. At the beginning of each turn, a player's deck is shuffled and a hand of cards is drawn. Undesired cards in the hand can be discarded and redrawn. The first round of the turn then begins, with a randomly selected player going first. That player must choose either to discard a number of cards >= 2, or to play a single card. One may not choose to discard a number of cards less than his power level minus 1, nor may he play a card with a power level that is more than his power level plus 1. Afterwards, his round is over, and his power level is set to either the power level of the card he just played, or the number of cards he discarded. If he has at least one card in his hand, he draws another card. The next player then begins his round in a similar manner. If a player's hand is empty when his round begins, his round is instead skipped, his power level is set back to 1, and the next player's round begins. If three rounds are skipped in this manner, the turn ends, and the next turn begins, where all of a player's cards are shuffled back into his deck. This continues until a win condition is met.  Each card has a "finisher" effect. This is an effect that triggers if the card was last played before a controlling player's power level dropped. For example, card A has a power level of 7 and a finisher effect of "draw n cards," where n is the amount the player's power level dropped, and card B has a power level of 2 and a finisher effect of "deal n damage". If a player played card A last round, raising his power level to 7, and now plays card B, his power level will drop to 2 at the end of his turn, activating card A's finisher effect and prompting the player to draw 5 cards (7-2=5). An n-value that is less than 1 has no effect unless explicitly stated in a card's effect. The next round, the player has no more cards in his hand, so his power level is set to 1, triggering card B's finisher to deal 1 damage (2-1=1), and his round is thereafter skipped.

Cards may have other effects with certain triggers, such as a trigger when the card is drawn, played, discarded, etc. These are optional, but a card will always have a finisher effect.

A typical win condition is when a player reaches 0 health, which in most circumstances indicates a loss (certain player attributes, card effects, or game types may incur other effects, such as resurrection, transformation, damage reflection, etc.). Other win conditions may exist depending on cards and game types.


===ROADMAP
Establish MVP with two player entities with decks and playable cards
Establish mechanics utilizing a standard 52 card deck + two jokers
--Red joker can be played as power level 14 or power level 0, copies the last card played
--Black joker forces you to discard all your cards except for itself upon being drawn, sets your power level to 0 (activating a finisher) and ends your round
Design "generic" cards modelled after standard deck
Implement generics
Design "proper" cards to supplement generic cards
Implement propers
Design player characters (two per suit)
--Stars
----[stars] Scholar/Wizard
----[stars/bones] Forgemaster
--Stones
----[stones] Cleric/Druid
----[stones/blades] Monk
--Blades
----[blades] Duelist
----[blades/stars] Arcane Perfectionist/Sword-Saint
--Bones
----[bones] Savage/Barbarian
----[bones/stones] Necromancer/Cultist
Implement player characters
Design game modes
Implement game modes
