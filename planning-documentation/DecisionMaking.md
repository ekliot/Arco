Proposed problem:
===
Given a set of non-unique positive integers (card ranks in hand) and another positive integer, D (combo counter), is assigned to you. You can spend integers from your set (playing or discarding cards). If you spend one integer (playing a card), X (played card's rank), D becomes X. You can only spend D if D = X + 1. Alternatively, you can spend N integers (discarding N cards), and D becomes N, regardless of which integers you spent. Your goal is for D to be the biggest value possible given the set of integers. What is the first move you make to achieve that goal?

More succinctly... how does an AI decide the best sequence of moves to make?

Brainstorming:
===
Analysis of terms
---
Each time you have the option to make a move, you have three things to consider: Acceleration, Potential, and Cards per Increment.

Acceleration is how much power you gain by playing that move. i.e. playing a 5 while at a power of 4 is an Acceleration of 1. This can be negative, such as when playing a 2 while at a power of 6 gives an Acceleration of -4.

Potential is how severe the biggest power drop on the next turn is going to be. e.g. you have five cards, if you discard all five your Potential is now 4, because no matter what you will drop power by 4 when it is your next turn. If in addition to those five cards you also have a 3 (so a hand of six cards, with one of them a 3), then your Potential is 2 because you must play the 3 before being able to drop to a 1. However, in this scenario your Potential may also be 5, because you may discard all six cards and then drop by 5 the next turn.

Cards per Increment (CpI) is how many cards you need to use to change your power by a certain amount. i.e. at a power level P, holding a card P+1, it will cost 1 card to increment by 1, giving a CpI of 1. Alternatively, at a power level of 9, holding a 4 card, it will cost 1 card to decrement by 5, giving a CpI of -(1/5). The closer the CpI is to zero, the more desirable.

Maybe there is also Absolute Potential, which is the amount of Potential the last move in a series of guaranteed moves can offer. Basically, AP is looking at the cards currently in hand, and seeing what the total Potential is in a sequence of moves using these cards.

Discarding cards has:
+ high Acceleration (>= -1)
+ mid-to-high potential (>= #cards discarded - 1)
+ and always either:
 + a CpI ratio >1 (bad... e.g. discarding five cards to go from a power level of 1 to a 5 is a 5:4 ratio)
 + or a ratio of 1:0 (discarding 5 cards at a power of 5).

Playing a card has
+ an Acceleration <=1
+ a Potential equal to the card's rank minus one
+ and
 + at worst a CpI of 1:0 (playing a card of rank equal to power)
 + but usually a CpI <=1 (good... e.g. playing a 1 while at a 6 is a CpI of -(1/5))

Now that I'm looking over it, it seems CpI is just Acceleration per Card, which means that maybe the terminology could be better named Velocity, Potential, and Acceleration, respectively

Application of terms to AI decision making
---
This means that for the AI, it ought to be playing the move that has the best of all attributes

Unfortunately, discarding all cards immediately may end up being the only move an AI makes, because it has a high Velocity (always 5, given a starting hand of six cards), high Potential (always 5), high AbsPotential (also 5), and the best possible Acceleration for a discard action (6:5, not counting a 1:0 ratio)

It's only if an AI draws a hand of 2,3,4,5,6,7 that it may consider playing a card, as playing the 2 for the first round in this case has an AbsPotential of 6, but the Velocity and Acceleration are both 1

Perhaps if there were another value, Cards per AbsPotential, which would be how many cards you are using with a certain move compared to the highest possible AbsPotential of that move (in the last case of a straight 2-to-7, the CpAP is 1:6)

Also, calculating the AbsPotential can be memory intensive, having to simulate every possible sequence of moves with a given hand...

Maybe there can be a rule that you can never discard your entire hand? although that will mean that there isn't any way to "cash out" later on in a turn

Maybe you can't discard your whole hand only on the first turn? This feels like the wrong solution, to be constraining possible moves for something that can be solved by good decision making for the AI.

Another way of determining the value of a card is that at the beginning of a player's turn, they have a set of moves they can make given a hand of cards. each move has one or more cards attributed to it. Cards that are in the least number of moves, or in the least valuable of moves, are the least valuable cards to play, but the most valuable cards to discard. The reverse means that the most valuable cards to play are the least valuable to discard, those cards being in either the most number of moves or the most valuable of moves. The set of moves can be trimmed to remove any moves that are just not valuable enough to consider, which gives a smaller set of moves to decide from (making it an easier decision).

This brings up the issue of determining the value of a move, and whether the quality of a move is translatable to the quantity of moves available

However it may solve the issue of an AI discarding its entire hand by making each card dynamically valuable in two measures, discarding and playing
