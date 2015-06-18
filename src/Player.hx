import Random;

class Player{
    private var _BOARD:Field;
    private var _NAME:String = "";

    private var _deck:Deck;
    private var _discard:Array< Card > = new Array< Card >();
    private var _hand:Array< Card > = new Array< Card >();

    private var _health:Int;
    private var _power:Int;
    private var _dead:Bool = false;

    private var _lastPlayed:Card;

    public function new( name : String, board : Field, deck : Deck ){
        this._NAME = this._NAME + name;
        this._BOARD = board;
        this._deck = deck;
        this._health = 24;
        this._power = 1;
    }

    public function getDead():Bool{ return this._dead; }

    public function kill():Void{ this._dead = true; }

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
            var dr:Card = _deck.draw();
            if( dr == null ){
                this._hand.concat( ret );
                return ret;
            }
            else{
                this._BOARD.activateCard( dr, Triggers.onDraw );
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
            this._BOARD.playCard( this._NAME, subj );
            this._lastPlayed = subj;
        }
    }

    // i is how many cards to redraw, by default _hand.length
    public function redraw( ?i = -1 ):Array< Card >{
        // you can't redraw less than 0 cards, or more cards than are in
        // your hand, so just asssume as many cards as possible/are in your hand
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

    public function discard( ?dCard = null ):Void{
        if( dCard == null ){
            var dCard:Card = Random.fromArray( this._hand );

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
            if( check ){
                this.pushDiscard( dCard );
            }
        }
    }

    public function shuffleDeck():Deck{
        return this._deck.shuffle();
    }

    public function newTurn():Void{
        // get ready for the next turn, put every thing into your deck and shuffle it
        this._deck.concat( this._discard );
        this._deck.concat( this._hand );
        this._discard = new Array< Card >();
        this._hand = new Array< Card >();

        this._deck = shuffleDeck();
        this._power = 1;
    }

    //TODO
    public function makeMove():Void{
        // draw a card, then either play a card, or discard cards
        this.draw();
        /**
            Play card => Which card? => Validate power level => activate current finisher (if card power < player power) => playCard( card )
            Discard cards => Which cards? => Validate amount vs power level => discard cards => activate current finisher (if #cards < player power)
         */
    }

    public function activateFinisher( curCard : Card ):Void{
        var drop:Int = this._power - curCard.getRank();
        this._BOARD.activateCard( this._lastPlayed, Triggers.onFinisher( this._power - this._lastPlayed) );
    }

    public function processEvent( eve : EnumValue ):Void{
        switch( trig ){
            case Nothing: trace( "Empty event" );
            case Damage( amount ): this._BOARD.dealDamage( _NAME, amount );
            case Draw( amount ): this.draw( amount );
            case Heal( amount ): this.chHealth( amount );
            case Discard( amount ): for( i in 0...amount ){ this.discard(); };
            default: trace( "Invalid event" );
        }
    }

    //TODO
    public function die():Bool{
        return false;
    }

    public function pushDiscard( c : Card ):Void{
        this._BOARD.activateCard( c, Triggers.onDiscard );
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
