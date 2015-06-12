import Random;

class Player{
    private var _BOARD:Field;
    private var _NAME:String = "";

    private var _deck:Array< Card > = new Array< Card >();
    private var _discard:Array< Card > = new Array< Card >();
    private var _hand:Array< Card > = new Array< Card >();

    private var _health:Int;
    private var _power:Int;

    public function new( name : String, board : Field, deck : Array< Card > ){
        this._NAME = this._NAME + name;
        this._BOARD = board;
        this._deck = deck;
        this._health = 24;
        this._power = 1;
    }

    public function chHealth( mod : Int ):Void{
        this._health += mod;
    }

    public function getHealth():Int{
        return _health;
    }

    public function chPower( mod : Int ):Void{
        this._power += mod;
    }

    public function getPower():Int{
        return _power;
    }

    public function getHand():Array< Card >{
        var ret:Array< Card > = new Array< Card >();
        ret.concat( this._hand );
        return ret;
    }

    public function draw( ?i = 1 ):Array< Card >{
        var ret:Array< Card > = new Array< Card >();
        while( i > 0 ){
            var dr:Card = _deck.shift();
            if( dr == null ){
                this._hand.concat( ret );
                return ret;
            }
            else{
                this._BOARD.activateCard( dr, Triggers.onDraw );
                this.pushHand( dr );
                ret.push( dr );
            }
        }
        return ret;
    }

    public function playCard( subj : Card ):Void{
        var idx:Int = this._hand.indexOf( subj );
        if( idx >= 0 ){
            this._BOARD.playCard( this._NAME, subj );
        }
    }

    // i is how many cards to redraw, by default _hand.length
    public function redraw( ?i = -1 ):Array< Card >{
        if( i < 0 || i > this._hand.length ){
            i = this._hand.length;
        }

        while( i > 0 ){
            discard( this._hand[ 0 ] );
            i--;
            this.draw();
        }
        return this._hand;
    }

    public function discard( ?dCard = null ):Card{
        if( dCard == null ){
            var dCard:Card = Random.fromArray( this._hand );

            this._hand.remove( dCard );
            this.pushDiscard( dCard );

            return dCard;
        }
        else{
            var check:Bool = this._hand.remove( dCard );
            if( check ){
                this.pushDiscard( dCard );
                return dCard;
            }
            else{
                return null;
            }
        }
    }

    public function shuffleDeck():Array< Card >{
        return Random.shuffle( this._deck );
    }

    public function newTurn():Void{
        this._deck.concat( this._discard );
        this._deck.concat( this._hand );
        this._discard = new Array< Card >();
        this._hand = new Array< Card >();

        this._deck = shuffleDeck();

    }

    //TODO
    public function makeMove():Void{
        // draw a card, then either play a card, or redraw current cards
    }

    //TODO
    public function die():Bool{
        return false;
    }

    public function pushDiscard( c : Card ):Void{
        this._discard.push( c );
        this._BOARD.activateCard( c, Triggers.onDiscard );
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
