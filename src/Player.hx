/** Copyright (c) 2015 Elijah Kliot*/

import Suits;
import Triggers;
import Actions;

import Random;

import luxe.Events;
import luxe.States;
import luxe.Entity;

import luxe.Input;

class Player extends Entity{
    private var _BOARD:Board;
    private var _NAME:String;
    private var _CPU:Bool;

    private var _deck:Array< Card >;
    private var _discard:Array< Card > = new Array< Card >();
    private var _hand:Array< Card > = new Array< Card >();

    public var _states:States;
        // _playing
        // _living
        // _passed
    public var _pMove:States;
        // PLAY
        // DISCARD
        // DECIDING

    private var _health:Int;
    private var _power:Int;

    public var _toDiscard:Array< Card > = new Array< Card >();
    private var _lastPlayed:Card;

    public function new( n : String, deck:Array< Card >, cpu:Bool ){
        super( { name : n, no_scene : true } );
        this._NAME = n;

        if( deck.length < 50 ){
            deck = deck.concat( this.stdDeck() );
        }
        this._deck = deck;
        trace( this._deck );

        this._health = 12; // 24hp default, 12 for testing
        this._power = 1;

        this._CPU = cpu;

        initStates();
    }

    private function initStates():Void{
        this._states = new States( { name : _NAME + "::player_states" } );
        _states.add( new State( { name : "LIVING" } ) );
        _states.add( new State( { name : "PLAYING" } ) );
        _states.add( new State( { name : "PASSED" } ) );

        _states.enable( "LIVING" );

        this._pMove = new States( { name : _NAME + "::move_states" } );
        _pMove.add( new State( { name : "PLAY" } ) );
        _pMove.add( new State( { name : "DISCARD" } ) );
        _pMove.add( new State( { name : "DECIDING" } ) );
    }

    public function joinGame( game : Board ):Void{
        trace( _NAME + " is trying to join the game...");
        if( game.join( this ) ){
            trace( _NAME + " has joined the game..." );
            this._BOARD = game;
        }
        else{ trace( _NAME + " could not join the game" ); }
    }

    public function stdDeck():Array< Card >{
        trace( "Building standard deck..." );
        var ret:Array< Card > = new Array< Card >();
        for( i in 1...14 ){
            var temp:Array< Card > = new Array< Card >();
            temp.push( new StdCard( { rank : i, suit : Blades, played_from : _NAME } ) );
            temp.push( new StdCard( { rank : i, suit : Stars, played_from : _NAME } ) );
            temp.push( new StdCard( { rank : i, suit : Stones, played_from : _NAME } ) );
            temp.push( new StdCard( { rank : i, suit : Bones, played_from : _NAME } ) );
            trace( temp.toString() );
            ret = ret.concat( temp );
            trace( i );
        }
        trace( "Shuffling deck..." );
        Random.shuffle( ret );
        trace( "Deck shuffled" );
        return ret;
    }

    // draws i number of cards (default is 1) and pushes them into the hand
    public function draw( ?i = 1 ):Array< Card >{
        trace( _NAME + " is drawing " + i + " card(s)..." );
        var ret:Array< Card > = new Array< Card >();
        while( i > 0 ){
            var dr:Card = _deck.shift();
            if( dr == null ){
                trace( "\t" + _NAME + "'s deck is empty" );
                _hand = _hand.concat( ret );
                return ret;
            }
            else{
                trace( "\t" + _NAME + " draws " + dr.toString() );
                this._BOARD.activateCard( dr, onDraw );
                ret.push( dr );
            }
            i--;
        }
        _hand = _hand.concat( ret );
        return ret;
    }

    // called once a card is validated by the board
    public function playCard( subj : Card ):Void{
        // if you can remove this card from the hand (i.e. it IS in your hand, isn't it?)
        if( _hand.remove( subj ) ){
            trace( _NAME + " has chosen to play " + subj.toString() );
            _BOARD.playCard( _NAME, subj );
            trace( _NAME + "'s last card played is " + subj.toString() );
            _lastPlayed = subj;
            chPower( subj.getRank() );
        }
    }

    // i is how many cards to redraw, by default _hand.length
    public function redraw( ?i = -1 ):Array< Card >{
        trace( _NAME + " is redrawing " + i + " cards..." );
        // you can't redraw less than 0 cards, or more cards than are in
        // your hand, so just asssume as many cards as possible/are in your hand
        if( i < 0 || i > _hand.length ){
            trace( "parameter for redraw() invalid, defaulting to entire hand...");
            i = _hand.length;
        }

        while( i > 0 ){
            discard( _hand[ 0 ] );
            i--;
            draw();
        }
        return _hand;
    }

    // discard a specified or random card from the hand without triggering onDiscard
    public function discard( ?dCard = null ):Void{
        // if no card is specified, pick a random card from this player's hand
        if( dCard == null ){
            if( _hand.length == 0 ){
                trace( _NAME + " does not have any cards to discard" );
            }
            else{
                trace( "Discarding random card from " + _NAME + "'s hand..." );
                var dCard:Card = Random.fromArray( _hand );

                trace( "Discarded: " + dCard.toString() );
                if( this._hand.remove( dCard ) ){
                    pushDiscard( dCard, false );
                }
            }
        }
        else{
            // this check is for the case when the function is called and
            // passed a dCard that isn't actually in the hand.
            // this is like when you pay a cashier with a credit card, and if
            // the card isn't valid (not in card-company's directory) then it is not charged
            var check:Bool = _hand.remove( dCard );
            trace( "Is " + dCard.toString() + " in " + _NAME + "'s hand: " + check );
            if( check ){
                trace( _NAME + "is discarding " + dCard.toString() + "..." );
                pushDiscard( dCard, false );
            }
        }
    }

    public function shuffleDeck():Void{
        trace( _NAME + " is shuffling their deck... " );
        Random.shuffle( _deck );
    }

    public function newTurn( handSize : Int ):Void{
        // get ready for the next turn, put every thing into your deck and shuffle it
        trace( _NAME + " is getting ready for a new turn..." );
        _deck = _deck.concat( _discard );
        _deck = _deck.concat( _hand );
        _discard = new Array< Card >();
        _hand = new Array< Card >();

        shuffleDeck();

        trace( _NAME + " is drawing a starting hand of size " + handSize );
        for( i in 0...handSize ){
            pushHand( _deck.shift() ); // the draw() function is not used here in order to avoid activating onDraw effects
        }

        _states.disable( "_passed" );
        _states.enable( "_playing" );



        // ########################
        // AI decisions begin
        if( _CPU ){
            var count:Int = 0;
            var outgoing:Array< Card > = new Array< Card >();

            for( c in _hand ){
                if( c.getRank() > handSize ){
                    _hand.remove( c );
                    outgoing.push( c );
                    count++;
                }
            }

            for( d in outgoing ){
                discard( d );
            }

            // the removal and addition are separated so that cards that have been redrawn can't be selected for withdrawal again

            for( i in 0...count ){
                pushHand( _deck.shift() ); // the draw() function is not used here in order to avoid activating onDraw effects
            }
        }
        // AI decisions end
        // ########################

        // ########################
        // Player decisions begin
            else{
                // displayHand();
                //
                // trace( "WOULD YOU LIKE TO REDRAW ANY CARDS? Y/N" );
                // var response:String = Sys.stdin().readLine();
                //
                // if( response == "Y" || response == "y" ){
                //     trace( "Select card indices separated by spaces");
                //     var indices:Array< String > = Sys.stdin().readLine().split( " " );
                //     var record:Array< Int > = new Array< Int >();
                //     var outgoing:Array< Card > = new Array< Card >();
                //
                //     for( i in 0...indices.length ){
                //         var ind:String = indices[i];
                //         var n:Int = Std.parseInt( ind );
                //         if( n >= 0 && n < _hand.length && !Std.is( n, null ) ){
                //             if( record.remove( n ) ){
                //                 trace( "\tRepeated index " + ind + " invalid" );
                //             }
                //             else{
                //                 trace( "\t" + _hand[n] + " at index " + ind + " will be redrawn" );
                //                 outgoing.push( _hand[n] );
                //             }
                //             record.push( n );
                //         }
                //         else{
                //             trace( "\tInput " + ind + " is invalid" );
                //         }
                //     }
                //
                //     for( c in outgoing ){
                //         discard( c );
                //
                //         var drCard:Card = _deck.shift();
                //         pushHand( drCard ); // the draw() function is not used here in order to avoid activating onDraw effects
                //         trace( "\tDrawing " + drCard + " to replace " + c );
                //     }
                //
                //     trace( "NEW STARTING HAND:" );
                //     for( i in 0..._hand.length ){
                //         var c:Card = _hand[i];
                //         trace( "\t[" + i + "] " + c.getSuit() + " " + c.getRank() );
                //     }
                //
                //     trace( "PRESS ENTER TO CONTINUE" );
                //     Sys.stdin().readLine();
                // }
                // else{
                //     trace( "VERY WELL" );
                // }
            }
        // ########################
        // Player decisions end

        _states.disable( "_playing" );

        trace( _NAME + " status... Health:" + _health + " -- Power:" + _power );
    }

    // this is assuming that a card has been drawn at the beginning of the round
    public function makeMove():Bool{
        /**
            Play card => Which card? => Validate power level => activate current finisher (if card power < player power) => playCard( card )
            Discard cards => Which cards? => Validate amount vs power level => discard cards => activate current finisher (if #cards < player power)
         */

        var moveMade:Bool = false;
        var ret:Move;

        _states.enable( "_playing" );

        // ########################
        // AI decisions begin
        if( _CPU ){
            moveMade = decidePlay();

            if( !moveMade ){
                var val:Int = decideDiscard();
                if( ( val >= 2 ) && ( val >= ( this._power - 1 ) ) ){
                    chPower( val );
                    moveMade = true;
                }
            }

            // if a move hasn't been made, power drops down to 1 and all cards in hand are discarded
            if( !moveMade ){
                moveMade = _BOARD.validatePass( _NAME );
                if( _states.enabled( "_passed" ) ){
                    chPower( 1 );
                    _discard = _discard.concat( _hand );
                    _hand = new Array< Card >();
                }
                else{
                    trace( _NAME + " COULD NOT MAKE A DECISION, THE PUNISHMENT IS DEATH" );
                    killMe();
                }
            }
        }
        // AI decisions end
        // ########################

        // ########################
        // Player decisions begin
        else{
            _pMove.enable( "DECIDING" );
            while( _pMove.enabled( "DECIDING" ) ){}
            // while( !moveMade ){
            //     displayStatus();
            //     displayHand();
            //
            //     trace( "DECLARE A MOVE TO MAKE" );
            //     trace( "AVAILABLE COMMANDS ARE: ");
            //     trace( "\tplay");
            //     trace( "\tdiscard");
            //     trace( "\tpass" );
            //     trace( "\tsort" );
            //     trace( "\tquit" );
            //
            //     var cmd:String = Sys.stdin().readLine();
            //
            //     switch( cmd ){
            //     case "play":
            //         moveMade = playCMD();
            //     case "discard":
            //         moveMade = discardCMD();
            //     case "pass":
            //         moveMade = passCMD();
            //     case "sort":
            //         sortCMD();
            //     case "quit":
            //         moveMade = quitCMD();
            //     default:
            //         trace( "INVALID INPUT" );
            //     }
            // }

            // Sys.stdin().readLine();
        }
        // ########################
        // Player decisions end

        _states.disable( "_playing" );

        return true;
    }

    // return false if a play is impossible or decided against, true if play is made
    private function playCMD():Bool{
        // var playable:Array< Card > = checkPlayable();
        //
        // if( playable.length == 0 ){
        //     trace( "NO CARDS IN HAND AVAILABLE TO PLAY" );
        //     return false;
        // }
        //
        // trace( "CARDS AVAILABLE TO PLAY:" );
        // for( i in 0...playable.length ){
        //     var c:Card = playable[i];
        //     trace( "\t[" + i + "] " + c.getSuit() + " " + c.getRank() );
        // }
        //
        // // enter index of card or 'back'
        //
        // trace( "Enter the index of the card to play, or press enter to return to move selection" );
        // var resp:Array< String > = Sys.stdin().readLine().split( " " );
        // if( resp.length == 0 ){
        //     return false;
        // }
        //
        // if( Std.parseInt( resp[0] ) == null ){
        //     trace( "INVALID INPUT" );
        //     return false;
        // }
        //
        // var ind:Int = Std.parseInt( resp[0] );
        //
        // if( ( ind < 0 ) || ( ind >= playable.length ) ){
        //     trace( "INVALID INDEX" );
        //     return false;
        // }
        //
        // else{
        //     if( _BOARD.validateMove( new Move( _NAME, "PLAY", playable[ind].getRank() ) ) ){
        //         playCard( playable[ind] );
        //         return true;
        //     }
        // }
        //
        return false;
    }

    // return an array of the cards in hand that are valid to play
    public function checkPlayable():Array< Card >{
        var ret:Array< Card > = new Array< Card >();
        for( c in _hand ){
            if( c.getRank() <= _power + 1 ){
                ret.push( c );
            }
        }
        return ret;
    }

    // return false if a discard is impossible or decided against, true if discard is made
    private function discardCMD():Bool{
        // // if not enough cards to make a valid discard, declare this and return false
        // if( !checkDiscard() ){
        //     trace( "NOT ENOUGH CARDS IN HAND TO MAKE DISCARD" );
        //     return false;
        // }
        //
        // // otherwise, show hand, declare the minimum number of cards you can discard
        // // prompt for indices, or for back
        // var min:Int = _power - 1;
        // if( min < 2 ){
        //     min = 2;
        // }
        //
        // while( "pigs" != "can fly" ){
        //     trace( "CHOOSE AT LEAST " + min + " CARDS TO DISCARD" );
        //     displayHand();
        //
        //     trace( "Select card indices separated by spaces, or press enter to return to move selection");
        //     var resp:String = Sys.stdin().readLine();
        //
        //     if( resp == ""){
        //         return false;
        //     }
        //
        //     else{
        //         // validateInput( resp )
        //         var indices:Array< String > = resp.split( " " );
        //
        //         if( indices.length < min ){
        //             trace( "NOT ENOUGH ARGUMENTS (" + indices.length + " given)" );
        //         }
        //
        //         else{
        //             var record:Array< Int > = new Array< Int >();
        //             var outgoing:Array< Card > = new Array< Card >();
        //
        //             for( ind in indices ){
        //                 var n:Int = Std.parseInt( ind );
        //                 if( n >= 0 && n < _hand.length && !Std.is( n, null ) ){
        //                     if( record.remove( n ) ){
        //                         trace( "\tRepeated index " + ind + " invalid" );
        //                     }
        //                     else{
        //                         trace( "\t" + _hand[n] + " at index " + ind + " will be discarded" );
        //                         outgoing.push( _hand[n] );
        //                     }
        //                     record.push( n );
        //                 }
        //                 else{
        //                     trace( "\tInput " + ind + " is invalid" );
        //                 }
        //             }
        //
        //             if( _BOARD.validateDiscard( _NAME, outgoing.length ) ){
        //                 for( c in outgoing ){
        //                     discard( c );
        //                 }
        //
        //                 chPower( outgoing.length );
        //
        //                 return true;
        //             }
        //         }
        //     }
        // }

        return false;
    }

    // check that there are 2+ cards in the hand, or at least _power-1 cards, whichever is greater
    public function checkDiscard():Bool{
        if( ( _hand.length >= 2 ) && ( _hand.length >= ( _power - 1 ) ) ){
            return true;
        }
        return false;
    }

    // return true if passing is the only valid move
    private function passCMD():Bool{
        // check that no cards are playable
        // check that no discards are possible
        // if both are impossible, set power to 1, discard all cards, return true
        if( !checkDiscard() && checkPlayable().length == 0 ){
            if( _BOARD.validatePass( _NAME ) ){
                chPower( 1 );
                _discard = _discard.concat( _hand );
                _hand = new Array< Card >();
            }
            return _states.enabled( "_passed" );
        }

        // otherwise, declare that passing is invalid, return false
        trace( "VALID MOVES STILL AVAILABLE, PASSING IS INVALID" );
        return false;
    }

    // parse a sort command
    private function sortCMD():Void{
        // // prompt to sort by rank or suit, descending or ascending
        // // call sortRank();
        // trace( "SORT HAND BY DESCENDING OR ASCENDING RANK?" );
        // trace( "\t'a' for ascending" );
        // trace( "\t'd' for descending" );
        // trace( "\tPress enter to return to move selection" );
        // switch( Sys.stdin().readLine() ){
        // case "a":
        //     sortRank( false );
        // case "d":
        //     sortRank( true );
        // default:
        //     trace( "RETURNING" );
        // }
    }

    private function quitCMD():Void{
        return killMe();
    }

    // logic for AI to decide which card to play
    private function decidePlay():Bool{
        sortRank( true );
        for( c in _hand ){
            if( c.getRank() == ( _power + 1 ) ){
                playCard( c );
                return true;
            }
        }
        return false;
    }


    // 2^k possible discard moves, with k == hand size
    // of these, which moves do we care to consider, and what characteristic do they ALL have that all OTHER moves don't

    // when deciding to discard cards...
    // do I have a sequence of cards which I will be able to play given I discard n cards?
    // will discarding n cards potentially discard cards of that sequence?
    // i.e. hand[ 1 2 3 4 5 6 7 ], discarding n cards guarantees you can play a sequence from n+1 to 7, 0 <= n <= 7
    //      hand[ 1 2 3 5 5 6 7 ], discarding <3 cards doesn't let you start the sequence up to seven, however 4+ does
    //      hand[ 1 1 1 1 5 6 7 ], discarding <4 cards doesn't let you start the sequence up to seven, however 4+ does
    //      hand[ 1 4 5 6 7 ], you can discard 3 (1,6,7) or 4 (1,4,6,7) cards and get up to a five, or discard all five immediately.
    //                         the optimal is 3 cards, because that is more opportunity for cards to activate onRound as well as the chance to draw more cards on a round
    //                         however discarding all five will let you activate the onDiscard effect of all cards, immediately
    //      hand[ 1 4 5 6 8 9 10 ], discard all for a max of 7, 3 for 6, 4 for 6

    // ideally, you want to spend as little cards as possible for the highest potential power level. you can cash in and play your whole hand for 1:1, or try to optimize a sequence of card ranks

    // function for AI to decide what discard move to make
    private function decideDiscard():Int{
        // minimum number of cards to discard
        var min:Int = _power - 1;
        if( min < 2 ){ min = 2; }

        // cards already parsed in a streak
        // i.e. in hand[ 1 2 3 ], after 1 is parsed (not in ignore list), 2 and 3 are added because they are part of 1's streak. this eliminates overlaps between streaks
        var ignore:Array< Card > = new Array< Card >();
        // streaks of cards available in the hand
        // < K = streak root, V = highest rank in streak >
        var streaks:Map< Card, Int > = new Map< Card, Int >();

        sortRank( false );

        // for every card in the hand...
        for( c in _hand ){
            // if it is not already part of a streak, and it is a valid root (any root <= _power + 1 can simply be played)...
            if( ignore.indexOf(c) >= 0 && c.getRank() > _power + 1 ){
                // what is its rank?
                var tRank:Int = c.getRank();
                // what is its index?
                var idx:Int = _hand.indexOf( c );
                // the root's rank is (for now) the highest rank in the streak
                streaks.set( c, tRank );

                // if this isn't the last card of the hand...
                if( idx + 1 != _hand.length ){
                    // for every card of higher rank... (_hand is sorted in asccending order)
                    for( i in (idx+1)..._hand.length ){
                        // if that card's rank allows it to be played after the highest rank of the streak...
                        if( _hand[i].getRank() == streaks.get( c ) ){
                            // this card's rank is now the highest of the streak
                            streaks.set( c, _hand[i].getRank() );
                            // and this card is not to be counted again in other streaks
                            ignore.push( _hand[i] );
                        }
                        // or if that card is greater than the next playable rank (not equal to the highest rank)...
                        else if( _hand[i].getRank() > streaks.get( c ) + 1 ){
                            // the streak has ended
                            break;
                        }
                    }
                }
            }
        }

        // what do we want to find out from the streaks Map?
        // the number of cards in each streak is V - K.getRank() + 1
        // we want the streak that reaches the highest rank (so, a root with as high of a V)
        // check if we can discard enough cards that AREN'T part of that streak to play the root the next turn
        // the cards that ARE part of the streak are those with a rank r, where K.getRank() <= r <= V
        // if not, find the next highest streak

        var rootHierarchy:Array< Array< Card > > = new Array< Array< Card > >();

        for( root in streaks.keys() ){
            var max:Int = streaks.get( root );
            while( rootHierarchy.length - 1 <= max ){
                rootHierarchy.push( new Array< Card >() );
            }
            rootHierarchy[max].push( root );
        }

        // for each streak length...
        for( i in ( rootHierarchy.length - 1 )...-1 ){
            if( rootHierarchy[i] != null ){
                // for each root for the streaks of length i...
                for( root in rootHierarchy[i] ){
                    // i is the max for that root
                    // root.get
                    var trash:Array< Card > = new Array< Card >();
                    // count how many cards in the hand are okay to discard to start that streak
                    for( c in _hand ){
                        if( c.getRank() > i || c.getRank() < root.getRank() ){
                            trash.push( c );
                        }
                        else{
                            for( d in _hand ){
                                if( trash.indexOf( d ) != -1 && c.getRank() == d.getRank() ){
                                    trash.push( c );
                                }
                            }
                        }
                    }
                    var amt:Int = root.getRank() - 1;
                    if( trash.length >= amt ){
                        var count:Int = 0;
                        while( count < amt ){
                            var dCard:Card = trash[ count ];
                            discard( dCard );
                            count += 1;
                        }
                        return amt;
                    }
                }
            }
        }

        // if none of the streaks can be achieved without discarding cards that are part of it, given that a valid discard move is possible (which it should be, it is a prereq to call this function)...
        // discard the minimum number of cards (2, or _power-1, whichever is higher), starting with those of a rank farthest from the minimum

        // assign an Int to each card in the hand of Math.abs( min - card.getRank() )
        var trash:Array< Card > = new Array< Card >();

        for( c in _hand ){
            var idx:Int = 0;
            var diff:Int = Std.int( Math.abs( min - c.getRank() ) );
            while( idx < trash.length ){
                var d:Card = trash[idx];
                if( Std.int( Math.abs( min - d.getRank() ) ) >= diff ){
                    idx += 1;
                }
                else{
                    break;
                }
            }
            trash.insert( idx, c );
        }

        var count:Int = 0;
        while( count < min ){
            var dCard:Card = trash[ count ];
            discard( dCard );
            count += 1;
        }


        // return that min
        return min;
    }

    public function activateFinisher( drop : Int ):Void{
        if( _lastPlayed != null ){
            Luxe.events.fire( "Player." + _NAME + ".finisher", { name : _NAME, card : _lastPlayed, val : drop } );
            // _BOARD.activateCard( _lastPlayed, onFinish( drop ) );
        }
        else{
            trace( "LAST PLAYED CARD IS NULL" );
        }
    }

    // function that is called when something is happening to this player
    public function processEvent( eve : EnumValue ):Void{
        switch( eve ){
        case Nothing:
            trace( "Empty event" );
        case Damage( amount ):
            chHealth( amount );
        case Draw( amount ):
            draw( amount );
        case Heal( amount ):
            chHealth( amount );
        case Discard( amount ):
            _BOARD.trimBoard( _NAME, amount );
        default:
            trace( "Invalid event" );
        }
    }

    public function getDead():Bool{ return !_states.enabled( "_living" ); }

    public function killMe():Void{
        trace( _NAME + " has been killed!" );
        _states.disable( "_living" );
    }

    // sorts the player's hand in place using insertion sort, with choice of ascending or descending rank
    public function sortRank( down:Bool ):Void{
        if( down ){
            trace( "sorting hand by descending rank" );
        }
        else{
            trace( "sorting hand by increasing rank" );
        }
        trace( _hand );
        for( i in 0..._hand.length ){
            var c:Card = _hand[ i ];
            var j:Int = i;
            while( j > 0 &&
                    ( ( down && c.compare( c, _hand[ j - 1 ] ) > 0 )
                  || ( !down && c.compare( c, _hand[ j - 1 ] ) < 1 ) ) ){
                _hand[ j ] = _hand[ j - 1 ];
                j -= 1;
            }
            _hand[ j ] = c;
        }
        trace( _hand );
    }

    public function chHealth( mod : Int ):Void{
        trace( _NAME + "'s health is being modified by " + mod );
        var old:Int = _health;
        _health += mod;

        Luxe.events.fire( "Player." + _NAME + ".health_change", { amount : mod } );

        trace( "New health: " + _health + "; Old health: " + old );
        // if the player is taking damage while their health is <= 0, they are killed
        // note that this means that a player can remain alive at <1 health, so long as they aren't taking damage
        if( ( mod < 0 ) && ( _health < 1 ) ){
            killMe();
        }
    }

    public function getHealth():Int{ return _health; }

    public function chPower( updPow : Int ):Void{
        trace( "New power level: " + updPow + "; Old power level: " + _power );
        // diff is <0 if power is decreasing, or vice versa if >0
        var diff:Int = updPow - _power;

        if( updPow < _power ){
            trace( "Power level modified by " + diff );
            activateFinisher( diff );
        }
        _power = updPow;

        Luxe.events.fire( "Player." + _NAME + ".power_change", { amount : diff } );

        // clear all cards on board that are greater than the new power level
        _BOARD.trimBoard( _NAME, _power );
    }

    public function getPower():Int{ return _power; }

    public function isDeckEmpty():Bool{ return ( _deck.length == 0 ); }

    public function isCPU():Bool{ return _CPU; }

    public function getHand():Array< Card >{
        var ret:Array< Card > = new Array< Card >();
        ret = ret.concat( _hand );
        return ret;
    }

    public function getName():String{ return _NAME; }

    public function getPass():Bool{ return _states.enabled( "_passed" ); }

    public function getDeck():Array< Card >{
        var ret:Array< Card > = new Array< Card >();
        ret = ret.concat( _deck );
        return ret;
    }

    // if discarding a card from the hand, it must be removed prior to calling this function
    // if that is the case, call discard( Card ), unless the onDiscard trigger is to be activated
    public function pushDiscard( c : Card, trig : Bool ):Void{
        _discard.push( c );
        if( trig ){ _BOARD.activateCard( c, onDiscard ); }
    }

    public function pushHand( c : Card ):Void{ _hand.push( c ); }

    public function pushDeck( c : Card ):Void{ _deck.push( c ); }

    public function displayHand():Void{
        trace( "\nTHESE ARE THE CARDS IN YOUR HAND:" );
        for( i in 0..._hand.length ){
            var c:Card = _hand[i];
            trace( "\t[" + i + "] " + c.getSuit() + " " + c.getRank() );
        }
    }

    public function displayStatus():Void{
        trace( "\nYOU HAVE " + _health + "hp AND " + _power + " POWER" );
        trace( "YOUR LAST CARD PLAYED IS:\t" + _lastPlayed );
    }

    public function toString():String{
        return "PLAYER{ " + _NAME + "; Health: " + _health + "; Power: " + _power + "; Hand Size: " + _hand.length + "; Deck Size: " + _deck.length + " }";
    }

    override public function update( dt:Float ){
        if( _toDiscard.length > 0 ){

        }
    }

    public function onmouseevent( e:MouseEvent ){
        // if the MouseEvent happened in the player area...
        if( e.pos.y > 519 ){
            // if the event is in the button area...
            if( e.pos.y > 579 ){
                // do shit
            }

            // instead of this for statement below, check instead the cursor's
            // horizontal coordinate and select the card at the approptiate index in the hand
                // i.e. if cards are 20px wide and the card at index 0 starts at a pos.x of 0, a MouseEvent with pos.x of 46 will be selecting the third card

            for( card in _hand ){
                // if it's inside a card...
                if( card.point_inside( e.pos ) ){
                    // and the game is waiting for an action from this player...
                    if( _pMove.enabled( "DECIDING" ) ){
                        switch( _pMove.current_state.name ){
                        case "PLAY":
                            playCard( card ); return;
                        case "DISCARD":
                            process_discard_command( card );
                        }
                    }
                }
            }
        }
    }

    private function process_discard_command( card : Card ):Void{
        if( _toDiscard.indexOf( card ) != -1){
            _toDiscard.remove( card );
        }
        else{
            _toDiscard.push( card );
        }
    }
}
