Card Ranks
---

Limit max card rank to something small, like 6, but keep distinct tiers of attacks for each of the 6 ranks. In addition, smaller more focused decks. However, to balance the loss of power scale (no crazy 10-momentum combo finishers), say every round you don't drop from the max momentum, increases your momentum by another X, where X is:

  + A flat 1
  + Flat increment, i.e X=# of turns at max momentum
  + The last two momentum gains' sum (i.e. Fibonachi seq., could give advantage to a strat of discarding a bunch of cards but a couple of max-rank cards, then getting a very sudden spike in momentum, although it would take work to get that move in position)

This also leads to the possibility (because of smaller decks) of adding eight common pools of cards (blades(+), stones(+), bones(+), stars(+)), which is more feasible (and perhaps necessary) if the class pools are limited

However, having individualized decks for each of the classes seems more appealing than the common decks, although it could be worth investing the time and effort into both (in this case, class decks come first, and common decks should be added only if they offer something of value)

Signature Moves (SM)
---

Right now, it is possible to discard a number of cards no more than one greater than your current momentum, and no less than two, in order to set your momentum to that amount. However, this is unfulfilling, as it is hard to understand how this abstraction translates into your own character's action, and it is generally an awkward thing to do. Instead, each player could have SMs. There are many variables as to what these are and how that is determined, but how they work is straightforward. whereas before, the number of cards one could discard was dynamic, and the effect static, here it is the opposite. That SM has a cost, where the cost:power ration directly correlates to that of a regular card's momentum:power ratio. Upon paying this cost, the player's momentum is set to that cost, with all the effects that come with it, and the SM takes its place in the player's combo sequence as any regular card does. The SM is, for all intents and purposes, a regular card, that can be played at any time, so long as the cost can be paid.

The benefits of using SM is to provide individuality to a player's class, that which would otherwise be represented in deck building (which is significantly dampened by restricting deck size and card ranks, as above).

There are a few variables to take care of with this, however. They are: how is a SM determined, how much does it cost, how is its cost paid, how frequently can it be used, and how many SMs does a player have.

**Where is the SM coming from?**
  + <SIMPLE> An SM is chosen from a card in the player's deck
      - The card would act exactly as before, and its cost is equal to its momentum
      - Is this card only from the deck they use, or can it be any card in the class' card pool?
  + <COMPLEX> Each class has a SM
      - This is either a single move, or a selection of moves per class
      - Perhaps moves are based on suit, so multiple classes can choose the same move
      - Perhaps, if a player is to have only a single SM, it is "constructed" in pieces, which is what determines its cost. i.e. 
          - Each trigger point (onPlay, onRound, etc.) has a handful of options, and each option increases the card's cost corresponding to its power. these options could even be suit based (i.e. "deal 1 damage on round" as a Blades trigger), so that multiple events for each trigger don't need to be designed for each class...
          - The card art and name are the hardest and easiest parts
              - For the name, it could be done like aRPG loot generation (prefixes and suffixes, "*Slashing* Strike *of Suffering*"), with a selection of "root" names (Strike, Blow, Missile, etc.).
                - This idea could also be combined with each class having discrete SMs, where a class has, say, three "core" SMs with a single, simple effect (probably the finisher effect... and single, simple name, like "Strike"), which can then be built upon by adding triggers
                - Perhaps each of cost 1, or maybe of variable cost -- meaning, a player can take a weak, cost 1 SM and personalize it to be stronger (and more expensive), or use a cost 3 SM and personalize it just a little bit (or not at all), because it has a unique and/or valuable core effect
              - For the art, it can be done where each class has a selection of a few personalized card arts to use, and the player selects one for the card. Perhaps triggers will modify it somehow (i.e. "of Burning" makes it more red or adds embers or something), but that seems more trouble than it's worth
                - If going with each class having "core" SMs to build off of, this becomes easier -- each core SM has a single card art

**How much does an SM cost?**
  + Ideally, it should cost in line with a regular card in terms of momentum:power
  + Could an SM cost more than 6? This means that it would be possible to get a spike in the maximum momentum a player can normally have, and then 

**How is the SM cost paid?**
  + Discard cards equal to the cost. Keeps the motives of the original discard mechanic
  + Discard cards with the sum of momentum equal to the cost (i.e. discard cards of momentum 2 and 3 to use a cost 5 SM). This means a player will spend less cards to use an SM, which becomes more of a placeholder card than a distinct action
  + Pay health equal to the cost. This is an interesting mechanic that could/should be explored in other contexts as well, but in this one it negates the whole point of using several cards to achieve the effect of one. However, it does keep the intention of having a card to play, even when no other card may be played... Yet, it complicated things, as one could technically lose all the cards in their hand (normally, at this point the player would need to forfeit their turn until the next round), and then keep playing their SM costing themselves only hp. If their particular SM was also able to restore hp, this could be a balance issue.
  + Drop momentum equal to the cost. This overturns the mechanic of having the SM used as a regular card, since the player's momentum would drop below the "momentum" of the card, and it would just raise the momentum back up. However, this means that, instead of spending cards from their hand, the player is spending cards from their current combo (since, when your momentum goes down to, say, 2, all cards you have on the board of momentum 3 or more are discarded)

**How frequently can SMs be used?**
  + A cooldown ought to be considered for SMs, in order to prevent excessive use. For example, an SM with cost 1 could very easily be used rapidly. Obviously, it will hamstring the player by "capping" their momentum at 1 until they use another card, and the card itself will not be powerful, but it could potentially be imbalancing (ex: SM that draws 1 card, costs 1 card. Player's class grants an ability to deal 1 damage for every card drawn. The player is now dealing 2 damage every turn, and their hand is growing by 1 every turn, since they are already drawing a card at the start of each turn, and effectively playing 0).
    + How will this cooldown work? The most straightforward answer is: can only be used once every $cost turns
    + The question of fun should be considered -- it is not fun to play as or against someone that plays the same card over and over again. By implementing a cooldown, the use rate is staggered and alternative strategies have to be employed.
	+ Also, without a cooldown, it wouldn't be a *signature* move, would it?
  + Alternatively, they could have charges, so that it may only be used X amount of times.

**How many SMs does a player have?**
  + Having more than 1 SM could be fun, but also boring. The SM should not be the core of one's arsenal (deck), but rather a supplement or augmentation.
  + If multiple SMs are used, then this should only be done if SMs are used based on cards from the player's deck, so that it may represent a handful of moves that the player character has "memorized" well enough to not rely on drawing the card at random

Status Effects
---

In order to make cards more diverse and interesting, and to make their effects actually, you know, colourful, I think status effects are a critically important addition. This also exponentially increases the amount of thought, planning, ad strategy that goes into arranging a deck, picking abilities, and finding synergies, thus making the game more engaging, increasing permutations of matchups and counters, and potentially prolonging the lifespan of the game's experience.

Each player can be inflicted with zero or more status effects, which are similar to cards in that they have triggers:
  + onMove
  + onHeal
  + onDraw
  + onRound
  + onDamage
  + onDiscard
  + onFinisher
  
Status effects can be beneficial or detrimental (de/buffs). Some may be both, or maybe abilities can make debuffs beneficial (draw 1 extra card while burning) or vice versa (while blocking, don't draw cards)

Status effects are inflicted on a player by abilities or card effects, and are removed either by a timer (effectively, a countdown that happens onRound), or another trigger (after taking X damage, after healing X amount, after drawing X cards, etc.)

Can status effects stack? i.e. if a player is burned twice, how is that resolved? two separate effects or replace with the newest one?

Thinking... Are status effects counters to the four core mechanics (draw, damage, discard, d... uh, dheal)? Perhaps, when thinking of the core status effects there ought to be something to inhibit and enhance each of the four. For example, blocking inhibits an enemy's damage, while shock enhances your damage. So:
  + Blades
      - Protect vs damage (counter) -> block
      - Increase damage (enhance) -> lightning
  + Bones
      - Protect vs discard (counter) -> ???
      - Increase discard (enhance) -> poison
  + Stars
      - Reduce draws (counter) -> cold
      - Increase draws (enhance) -> ???
  + Stones
      - Reduce healing (counter) -> fire
      - Increase healing (enhance) -> ???

Ideas for status effects:
  + Debuff
      - "Elemental" effects have a lesser/greater version (additive/multiplicative?)
          - Singe/Burn (damage each turn, something else?)
          - Sicken/Poison (increase cards discarded, +/\*)
          - Chill/Freeze (reduce cards drawn, +/\*)
          - Jolt/Shock (increase damage taken, +/\*)
      - MORE
  + Buff
      - Block (reduce damage taken, reduce discard)
      - Haste (draw extra cards? double a move?)
      - MORE
      
Cancels
---

Should there be a way to cancel your combo? I can see this being useful if, say, your current combo is ineffective or is helping the other player (i.e. if you are affected with "take 1 damage for each card drawn" and your combo is draw-heavy, it would be helpful to reset the combo and start from the bottom to try counter it).

I guess as it is right now, the idea is to just play a low-rank card to bring your combo down low. This can be done with a lucky draw, or perhaps the strategy of it is to use a low cost SM in order to always have that "emergency reset button". But it could be valuable to have a permanent button like that, which is effectively playing a rank-0 card with no effects.
