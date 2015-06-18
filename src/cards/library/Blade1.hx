class Blade1 implements Card{
    public var SUITS:Enum = Suits;
    public var TRIGGERS:Enum = Triggers;
    public var EVENTS:Enum = Actions;

    // private var _front:CardFace;
    // private var _back:CardFace;

    private var _suit:EnumValue = SUITS.Blades( 1 );
    private var _rank:Int = 1;

    private var _PLAYER:String;

    public function new( player : String ){
        this._PLAYER = player;
    }

    // activate can be called with or without a target. if without, each event has a default target for this card
    public function activate( trig : TRIGGERS.EnumValue, players : Map< String, Player >, target : String ):Void{
        var eve:EVENTS.EnumValue = EVENTS.Nothing;

        switch( trig ){
            case onPlay: eve = this.onPlay();
            case onDraw: eve = this.onDraw();
            case onFinish( dropVal ): eve = this.onFinish( dropVal );
            case onRound: eve = this.onRound();
            case onDiscard: eve = this.onDiscard();
            default: trace( "Invalid card trigger" );
        }

        if( target == "" ){
            var opp:String = decideOpp( players );
            switch( eve ){
                case Damage( amount ): players.get( opp ).processEvent( eve );
                case Heal( amount ): players.get( _PLAYER ).processEvent( eve );
                case Discard( amount ): players.get( opp ).processEvent( eve );
                case Draw( amount ): players.get( _PLAYER ).processEvent( eve );
                default: trace( "Nothing happens" );
            }
        }

        else{
            players.get( target ).processEvent( eve );
        }
    }

    private function decideOpp( map : Map< String, Player > ):String{
        var players:Iterator< String > = map.keys();
        for( p in players ){
            if( p == this._PLAYER ){
                return p;
            }
            else{
                return players.next();
            }
        }
    }

    public function onDraw():EVENTS.EnumValue{
        return Nothing;
    }

    public function onPlay():EVENTS.EnumValue{
        return Nothing;
    }

    public function onFinish( dropVal : Int ):EVENTS.EnumValue{
        return Damage( dropVal );
    }

    public function onRound():EVENTS.EnumValue{
        return Nothing;
    }

    public function onDiscard():EVENTS.EnumValue{
        return Nothing;
    }

    public function getSuit():SUITS.EnumValue{
        return this._suit;
    }

    public function getRank():Int{
        return this._rank;
    }

    public function getTriggers():Array< EnumValue >{
        return this._triggers;
    }

    public function getPlayer():String{
        return this._PLAYER;
    }

    public function toString():String{
        return "Card[ Blades, 1 ]"
    }

    //TODO
    public function equals( c : Card ):Bool{

    }
}
