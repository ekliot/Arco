ABOUT
===
What is Arco?
---
Arco is a collectable card game designed for two players. The mechanics are inspired by fighting and action games, and are built around the concept of building up combos, which replace the more typical mana resource systems in other popular card games.

How is Arco being made?
---
Arco is being developed in [Haxe][hx], a cross-platform toolkit featuring the Haxe language and a cross-compiler. In addition, the game is built using [snowkit][snow], a library of tools for Haxe. These tools allow the game to be simultaneously developed for desktop, web, and mobile environments, as well as offering a whole suite of fantastic libraries for game development.

Why is Arco being made?
---
This is my first shot at tackling a fully-featured game, and the objective is largely to learn as much as I can about the workflow and development process, as well as gaining proficiency in the [Haxe][hx] language and [snowkit][snow] libraries. Less formally, I had a burning desire to design and implement a card game that could take advantage of the medium of a video game rather than a board game, and in particular to have a card game that is fast-paced and more character-centric (rather than fielding a board of minions). The game is designed for this by attempting to keep turn times low (more actions per minute = faster pace) and designing cards to be things that the player does (i.e. throw a punch) rather than having cards that do things on behalf of the player

When will Arco be completed?
---
This is certainly not a small project, so there's not really any realistic date I can give for this except "eventually." As it stands, about a month's worth of work has gone into designing the mechanics, implementing a text-based version fo the game to be played in the command line, and then learning [snowkit][snow] and converting the logic and structure of the text-based version into the snowkit version.

About a month's worth of work is left to make the snowkit version fully-functional to bring it up to the functionality of the text-based version, and beyond that is the time needed to design and implement individual cards, plus the art assets involved. Beyond this is the work needed to make a working multiplayer model, as well as perhaps implementing character classes and other such features. Because of this large undertaking, the time I have to properly work on the game is limited to between school semesters. The hope is to have the MVP of the snowkit version complete at the end of 2016's summer.

DETAILS
===

Mechanics
---

The mechanics of Arco are simple enough that you can pick up two decks of regular playing cards and play a foundation version of the mechanics right now! Here's how the mechanics play out:

Each player will keep track of two values: his/her health points, and his/her combo counter. These start at 24 and 1, respectively.

A single game is split into turns, which are split into rounds. At the beginning of each turn, both players shuffle their decks and draw six cards, then whoever is chosen to go first starts the first round of the turn. In a round, each player will draw a single card and then make a move. This move can be one of three things.

The most straightforward move is a pass, in which the passing player will discard their entire hand, reset their combo counter to 1, and will not make any more moves on subsequent rounds until the next turn. When both players pass, the turn is over, and both players will shuffle their discarded cards back into their deck and begin the next turn.

The second move is to play a card. Any card can be played from a player's hand on their turn, given the card's rank is no more than their combo counter +1. So, if a player has a combo counter of 4, they may play any card from their hand with a rank of 5 or less. When a card is played, that player's combo counter will become that card's rank. The player will then place the played card on the board, making sure he only has one card of any rank on the board at a given time. If the rank he played is already represented on their board, the old card is discarded and the new card takes its place.

In the digital game, cards can have effects that trigger upon being played, but for playing with regular playing cards they only have effects on a combo finisher (more on that later). There are additional triggers in the digital game, such as on a round starting/ending, on a turn ending, on being drawn, or on being discarded.

The third move available to players is a discard action. A player may discard from their hand at least two cards, or one less than their combo, whichever minimum is greater. In doing so, their combo counter becomes the number of cards they discarded.

The core mechanic of the combo counter is one of the most intricate. Whenever the combo counter goes down (such as when playing a low-ranked card, or passing), a combo finisher is triggered. The effect of this finisher depends on the suit of the last card played by the player, and the effect's severity is determined by how much the combo counter dropped. For example, Rick has a combo of 6, and he plays a 2 of spades. His combo drops to 2, triggering a finisher with a severity of 4 (6-2). Spades cards deal damage on a finisher equal to the severity, so Rick's opponent will take 4 damage (which is subtracted from his health points). The effects of other suits are restoring health points equal to the severity for hearts, drawing half the severity (rounding down) worth of cards for diamonds, or forcing the opponent to discard half the severity (rounding down) worth of cards from their hand.

Aesthetic
===

Arco is designed as a duel between two fighters, whose fighting moves and abilities are represented by the cards being played. These cards fall into four types, that are parallel to standard playing card suits. These types, and the attributes they represent, are:

+ Stars (diamonds) :: Represent arcane magic, knowledge, and the unknown
+ Stones (hearts) :: Represent the natural world, regeneration, and renewal
+ Blades (spades) :: Represent finesse, skill, and speed
+ Bones (clubs) :: Represent brute force, aggression, and ancestry

The characters that a player plays as represent an archetype from one or two of these 'schools.' They are as follows, however these are placeholders until development of character classes starts:

+ Wizard [Stars]
+ Runeforger [Stars/Bones]
+ Druid [Stones]
+ Monk [Stones/Blades]
+ Duelist [Blades]
+ Arcane Swordsman [Blades/Stars]
+ Barbarian [Bones]
+ Necromancer [Bones/Stones]

ROADMAP
===
    [x] Design mechanics for play with standard playing cards

    [x] Implement an MVP to be played through the command line

    [x] Complete a playable CLI version

    [x] Transition logic into snowkit framework

    [ ] Make an MVP using snowkit

    [ ] Set up foundations for card event triggers

    [ ] Design and implement a cohesive and fluid UI

    [ ] Release a playable web version

    [ ] Design a core card library for each suit

    [ ] Design and implement character classes

    [ ] Design a card library unique to classes

    [ ] v1.0.0 Release

    [ ] Plan and design potential RPG and gear mechanics


[hx]:https://www.haxe.org/   "Haxe lang"
[snow]:http://snowkit.org/   "snowkit"
