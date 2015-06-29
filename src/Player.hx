import Suits;
import Triggers;
import Actions;

import Random;

class Player{
    private var _BOARD:Field;
    private var _NAME:String = "";

    private var _deck:Array< Card >;
    private var _discard:Array< Card > = new Array< Card >();
    private var _hand:Array< Card > = new Array< Card >();

    private var _health:Int;
    private var _power:Int;
    private var _dead:Bool = false;

    private var _lastPlayed:Card;

    public function new( name : String, board : Field, deck:Array< Card > ){
        this._NAME = this._NAME + name;
        this._BOARD = board;
        if( deck.length == 0 ){
            this._deck = this.stdDeck();
        }
        else{
            this._deck = deck;
        }
        trace( this._deck );
        this._health = 24;
        this._power = 1;
    }

    public function stdDeck():Array< Card >{
        trace( "Building standard deck..." );
        var ret:Array< Card > = new Array< Card >();
        for( i in 1...14 ){
            var temp:Array< Card > = new Array< Card >();
            temp.push( new StdCard( this._NAME, Blades, i ) );
            temp.push( new StdCard( this._NAME, Stars, i ) );
            temp.push( new StdCard( this._NAME, Stones, i ) );
            temp.push( new StdCard( this._NAME, Bones, i ) );
            trace( temp.toString() );
            ret = ret.concat( temp );
            trace( i );
        }
        trace( "Shuffling deck..." );
        Random.shuffle( ret );
        trace( "Deck shuffled" );
        return ret;
    }

    public function draw( ?i = 1 ):Array< Card >{
        trace( _NAME + " is drawing " + i + " card(s)..." );
        var ret:Array< Card > = new Array< Card >();
        while( i > 0 ){
            var dr:Card = _deck.shift();
            if( dr == null ){
                trace( _NAME + "'s deck is empty" );
                this._hand.concat( ret );
                return ret;
            }
            else{
                trace( _NAME + " draws " + dr.toString() );
                this._BOARD.activateCard( dr, onDraw );
                this.pushHand( dr );
                ret.push( dr );
            }
            i--;
        }
        return ret;
    }

    public function playCard( subj : Card ):Void{
        // if you can remove this card from the hand (i.e. it IS in your hand, isn't it?)
        if( this._hand.remove( subj ) ){
            trace( _NAME + " has chosen to play " + subj.toString() );
            this._BOARD.playCard( this._NAME, subj );
            trace( _NAME + "'s last card played is " + subj.toString() );
            this._lastPlayed = subj;
            this._power = subj.getRank();
        }
    }

    // i is how many cards to redraw, by default _hand.length
    public function redraw( ?i = -1 ):Array< Card >{
        trace( _NAME + " is redrawing " + i + " cards..." );
        // you can't redraw less than 0 cards, or more cards than are in
        // your hand, so just asssume as many cards as possible/are in your hand
        if( i < 0 || i > this._hand.length ){
            trace( "parameter for redraw() invalid, defaulting to entire hand...");
            i = this._hand.length;
        }

        while( i > 0 ){
            discard( this._hand[ 0 ] );
            i--;
            this.draw();
        }
        return this._hand;
    }

    public function discard( ?dCard = null ):Void{
        // if no card is specified, pick a random card from this player's hand
        if( dCard == null ){
            trace( "Discarding random card from " + _NAME + "'s hand..." );
            var dCard:Card = Random.fromArray( this._hand );

            trace( "Discarded: " + dCard.toString() );
            if( this._hand.remove( dCard ) ){
                this.pushDiscard( dCard );
            }
        }
        else{
            // this check is for the case when the function is called and
            // passed a dCard that isn't actually in the hand.
            // this is like when you pay a cashier with a credit card, and if
            // the card isn't valid (not in card-company's directory) then it is not charged
            var check:Bool = this._hand.remove( dCard );
            trace( "Is " + dCard.toString() + " in " + _NAME + "'s hand: " + check );
            if( check ){
                trace( "Discarding " + dCard.toString() + "..." );
                this.pushDiscard( dCard );
            }
        }
    }

    public function shuffleDeck():Void{
        trace( _NAME + " is shuffling their deck... " );
        Random.shuffle( this._deck );
    }

    public function newTurn( handSize : Int ):Void{
        // get ready for the next turn, put every thing into your deck and shuffle it
        trace( _NAME + " is getting ready for a new turn..." );
        this._deck = this._deck.concat( this._discard );
        this._deck = this._deck.concat( this._hand );
        this._discard = new Array< Card >();
        this._hand = new Array< Card >();

        this.shuffleDeck();
        this._power = 1;

        this.draw( handSize );

        // ########################
        // AI decisions begin

        var count:Int = 0;

        for( c in this._hand ){
            if( c.getRank() > handSize ){
                discard( c );
                count++;
            }
        }

        draw( count );

        // AI decisions end
        // ########################

        trace( _NAME + " status... Health:" + _health + " -- Power:" + _power );
    }

    //TODO
    // this is assuming that a card has been drawn at the beginning of the round
    public function makeMove():Void{
        /**
            Play card => Which card? => Validate power level => activate current finisher (if card power < player power) => playCard( card )
            Discard cards => Which cards? => Validate amount vs power level => discard cards => activate current finisher (if #cards < player power)
         */

        var moveMade:Bool = false;

        moveMade = decidePlay();

        if( !moveMade ){
            var val:Int = decideDiscard();
            if( val > 0 ){
                chPower( val );
                moveMade = true;
            }
        }

        if( !moveMade ){
            chPower( 1 );
            var trash:Array< Card > = this._hand;
            for( c in trash ){
                this._hand.remove( c );
                pushDiscard( c );
            }
        }
    }

    private function decidePlay():Bool{
        for( c in this._hand ){
            if( c.getRank() == ( this._power + 1 ) ){
                playCard( c );
                return true;
            }
        }
        return false;
    }

    // NEEDS WORK
    private function decideDiscard():Int{
        if( this._hand.length > this._power ){
            sortRank( true );
            for( i in 0...this._hand.length ){
                var tCard:Card = this._hand[ i ];
                // check if the given card has a higher rank than the maximum that can be played
                if( tCard.getRank() > ( this._power + 1 ) ){
                    // cards worth throwing away
                    var count:Int = 0;
                    // number of cards needed to throw away to be able to play tCard on the next round
                    var targ:Int = tCard.getRank() - 1;
                    // cards marked to discard
                    var arr:Array< Card > = new Array< Card >();

                    // if targ + 1 (# of cards to discard + tCard itself) is at most the number of cards left to iterate over....
                    if( ( this._hand.length - i - 1 ) >= targ ){
                        for( c in this._hand ){
                            if( c.getRank() < targ ){
                                arr.push( c );
                                count++;
                                if( count == targ ){
                                    for( d in arr ){
                                        discard( d );
                                    }
                                    return count;
                                }
                            }
                        }
                    }
                }
                else{
                    break;
                }
            }
        }

        return 0;
    }

    public function activateFinisher( drop : Int ):Void{
        this._BOARD.activateCard( this._lastPlayed, onFinish( drop ) );
    }

    // function that is called when something is happening to this player
    public function processEvent( eve : EnumValue ):Void{
        switch( eve ){
            case Nothing: trace( "Empty event" );
            case Damage( amount ): this.chHealth( amount );
            case Draw( amount ): this.draw( amount );
            case Heal( amount ): this.chHealth( amount );
            case Discard( amount ): for( i in 0...amount ){ this.discard(); };
            default: trace( "Invalid event" );
        }
    }

    public function getDead():Bool{ return this._dead; }

    public function kill():Void{ this._dead = true; }

    // TODO
    public function sortRank( down:Bool ):Void{
        if( down ){
            trace( "sorting hand by descending rank" );
        }
        else{
            trace( "sorting hand by increasing rank" );
        }
    }

    public function chHealth( mod : Int ):Void{
        this._health += mod;
        if( ( mod < 0 ) && ( this._health < 1 ) ){
            kill();
        }
    }

    public function getHealth():Int{
        return _health;
    }

    public function chPower( updPow : Int ):Void{
        if( updPow < this._power ){
            activateFinisher( this._power - updPow );
        }
        this._power = updPow;
    }

    public function getPower():Int{
        return _power;
    }

    public function isDeckEmpty():Bool{
        return ( this._deck.length == 0 );
    }

    public function getHand():Array< Card >{
        var ret:Array< Card > = new Array< Card >();
        ret = ret.concat( this._hand );
        return ret;
    }

    public function getName():String{ return this._NAME; }

    public function pushDiscard( c : Card ):Void{
        this._BOARD.activateCard( c, onDiscard );
        this._discard.push( c );
    }

    public function pushHand( c : Card ):Void{
        this._hand.push( c );
    }

    public function pushDeck( c : Card ):Void{
        this._deck.push( c );
    }

    //TODO
    public function toString():String{
        return "";
    }
}
