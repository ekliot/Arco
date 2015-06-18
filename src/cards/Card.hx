interface Card{

    public var SUITS:Enum = Suits;
    public var TRIGGERS:Enum = Triggers;
    public var EVENTS:Enum = Actions;

    // private var _front:CardFace;
    // private var _back:CardFace;

    private var _suit:SUITS.EnumValue;
    private var _rank:Int;

    private var _PLAYER:String;

    public function new( player : String ){}

    // activate can be called with or without a target. if without, each event has a default target for this card
    public function activate( trig : TRIGGERS.EnumValue, players : Map< String, Player >, target : String ):Void{
                // var eve:EVENTS.EnumValue = EVENTS.Nothing;
        //
        // switch( trig ){
        //     case onPlay: eve = this.onPlay();
        //     case onDraw: eve = this.onDraw();
        //     case onFinish( dropVal ): eve = this.onFinish( dropVal );
        //     case onRound: eve = this.onRound();
        //     case onDiscard: eve = this.onDiscard();
        //     default: trace( "Invalid card trigger" );
        // }
        //
        // if( target == "" ){
        //     var opp:String = decideOpp( players );
        //     switch( eve ){
        //         case Damage( amount ): players.get( opp ).processEvent( eve );
        //         case Heal( amount ): players.get( _PLAYER ).processEvent( eve );
        //         case Discard( amount ): players.get( opp ).processEvent( eve );
        //         case Draw( amount ): players.get( _PLAYER ).processEvent( eve );
        //         default: trace( "Nothing happens" );
        //     }
        // }
        //
        // else{
        //     players.get( target ).processEvent( eve );
        // }
    }

    // given a map of the players in this card's game and this card's player, what is this card's player's opponent's name?
    private function decideOpp( map : Map< String, Player > ):String{
        // var players:Iterator< String > = map.keys();
        // for( p in players ){
        //     if( p == this._PLAYER ){
        //         return p;
        //     }
        //     else{
        //         return players.next();
        //     }
        // }
    }

    public function onDraw():EVENTS.EnumValue{}

    public function onPlay():EVENTS.EnumValue{}

    public function onFinish( dropVal : Int ):EVENTS.EnumValue{}

    public function onRound():EVENTS.EnumValue{}

    public function onDiscard():EVENTS.EnumValue{}

    public function getSuit():EVENTS.EnumValue{}

    public function getRank():Int{}

    public function getPlayer():String{}

    //TODO
    public function toString():String{

    }

    //TODO
    public function equals( c : Card ):Bool{

    }
}
