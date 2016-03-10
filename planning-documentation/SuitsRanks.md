So, a good balance between the effects of suits at all ranks is important. What is also important is which triggers are better for a certain suit (such as drawing a card each time a Stars card is discarded), as well as which trigger is more powerful at a certain rank (such as onRound triggers are drastically more potent for low-rank cards than high-rank cards).

**TO CONSIDER**: completely removing onDraw effects, which could lead to an opponent knowing your drawn card based on the effect that it has onDraw. on one hand this adds an extra strategic layer, but could also be annoying knowing your hand is basically already known. Although, the synergy between Stars cards and onDraw effects are really cool, so it could be something to consider for very powerful/rare cards

An analysis of each suits effect for each trigger in proportion to what they are affecting:

Blades
---
**Primary Effect :: Damage**

+ __onFinisher__
 + _Effect_: 1:1 ratio of dmg:{DROP}
 + _Details_: This is fair, it takes X cards over X rounds to deal X-1 damage.
+ __onPlay__
 + _Effect_: 1 dmg on play
 + _Details_: This is fair, playing low-ranking cards is now meaningful other than building a combo, and it means that ending a blades combo with another blades card lets you deal one extra damage (i.e. on Round N you play Blades(7), dealing 1 damage that round, then the next round you play Blades(3), dealing 1 damage, plus 4 damage for the finisher, for a total of 5 damage on Round N+1, and an extra point of damage on Round N)
+ __onDraw__
 + _Effect_: N/A
 + _Details_: Having damage on draw means potential synergy with Stars cards, though it also means the most effective strategy is to build a deck of exclusively blades cards and passively deal 1 or more damage each turn.
+ __onDiscard__
 + _Effect_: Special
 + _Details_: Being able to damage an opponent by removing cards is counterintuitive to both the Blades aesthetic and the overall balance (Although, it will be an effective counter to Bones cards, if certain Blades cards could damage on discard but lack other triggers, something like a trap card. Perhaps there could be a "spikey armour" card which deals damage when discarded, but only on the opponent's turn)
+ __onRound__
 + _Effect_: {RANK} dmg/rnd
 + _Details_: The options here are for a flat 1dmg/rnd, or for the dmg to scale with rank. The former means that building up a combo chain isn't as effective as simply stacking a field of rank 1 cards which will deal a total of 1 damage on round 2, 2 on round 3, 3 on 4, etc. This can be countered with a board clearing effect from Bones cards, or by restricting the onRound damage to high-rank cards (although this is counterintuitive, as higher ranked cards will rarely stay on the board for long, so in that case it is better to have damage scale with rank). A third option to balance the flat dmg/rnd is to restrict how many cards can be in play of a certain rank/suit (i.e. only one card of each rank can be on the board at a time **CONSIDER THIS**).

Bones
---
**Primary Effect :: Discard (cards in play, not hand)**

+ __onFinisher__
 + _Effect_: cards in play of rank {DROP} or less are discarded **OR** top {DROP} cards in play are discarded
 + _Details_: Any opponent cards in play of a rank less than or equal to the drop value are discarded. **OR** cards in play work like a stack, and {DROP} cards are popped off. The first means the opponent will end up with high-ranking cards consistently in play, while the second means the opponent can build up a buffer of higher rank cards to protect valuable lower ranking cards. Also, the latter effect is easier to implement
+ __onPlay__
 + _Effect_: cards of rank {RANK}/2 or less are discarded
 + _Details_: Any card in play of rank equivalent to half the played card's (round down) is discarded. So if Bones(5) is played, cards of rank 2 are discarded. This effect ought to be explored more in depth, as it could lead to some messy stuff.
+ __onDraw__
 + _Effect_: N/A
 + _Details_: The aesthetic of bones is based on action, or brute force, and having draw effects goes against that (too passive).
+ __onDiscard__
 + _Effect_: 1 dmg on discard
 + _Details_: This has multiple flavours. One is that a combo with Bones cards expresses to some extent an all-out attack where the player finally cashes in on all the spent energy in one burst (onDiscard triggers when your own cards are removed from play when dropping power level). On the other hand it also expresses the volatility of fighting fire with fire, where two Bones-dominant players will need to calculate the risk of beating each other up (since forcing the opponent to discard cards leads to damaging yourself).
+ __onRound__
 + _Effect_: Special
 + _Details_: Doesn't fit the Bones aesthetic. Perhaps there can be rare/expensive blocker cards which discard any card played of a certain rank (i.e. a certain Rank X blocker, as long as it is in play, will discard a random opponent card of rank X or less each round)

Stars
---
**Primary Effect :: Draw**

+ __onFinisher__
 + _Effect_: draw {DROP}/2 cards
 + _Details_: Round up, so that a drop of 1 isn't entirely worthless
+ __onPlay__
 + _Effect_: {RANK}/2 dmg
 + _Details_: Round down, Stars-only decks need some way to deal damage. This emphasizes Stars' more arcana-oriented approach of successive, big hits, but the truly damage dealing cards need to be built-up towards.
+ __onDraw__
 + _Effect_: N/A
 + _Details_: This can very easily be abused and lead to simply drawing the entire deck in one round... onDraw should at most be restricted to just high-ranking stars cards
+ __onDiscard__
 + _Effect_: 1:4 ratio of draw:rank
 + _Details_: A good effect for discarding cards is difficult, given the Stars effect could make it possible to keep drawing whole hands without a strict (and convoluted) equation. The easiest solution is to simply have no effect, but more thought ought to be put into this in order to give
+ __onRound__
 + _Effect_: {RANK}/3 dmg/card drawn
 + _Details_: Round down. Each time you draw a card with a Stars card on the board, one third of that card's rank's worth of damage is dealt to the opponent.

Stones
---
**Primary Effect :: Heal (Maximum health capacity?)**

+ __onFinisher__
 + _Effect_: 1:1 ratio of heal:rank
 + _Details_: Ought to be 1:1 in order to balance evenly with Blades finisher effects
+ __onPlay__
 + _Effect_:
 + _Details_:
+ __onDraw__
 + _Effect_:
 + _Details_:
+ __onDiscard__
 + _Effect_:
 + _Details_: 
+ __onRound__
 + _Effect_: 1 hp per round
 + _Details_: round up?
