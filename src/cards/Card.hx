import Suits;
import Triggers;
import Actions;

interface Card{
    // private var _front:CardFace;
    // private var _back:CardFace;

    private var _suit:EnumValue;
    private var _rank:Int;

    private var _PLAYER:String;

    // public function new( pl : String, suit : EnumValue, ?rank : Int = -1 ){
    //     this._PLAYER = pl;
    //     this._suit = suit;
    //     if( rank < 0 ){
    //         this._rank = suit.enumParameters()[ 0 ];
    //     }
    //     else{
    //         this._rank = rank;
    //     }
    // }

    // activate can be called with or without a target. if without, each event has a default target for this card
    public function activate( trig : EnumValue, target : String ):EnumValue;
        // var eve:EnumValue = Nothing;
        //
        // switch( trig ){
        //     case Triggers.onPlay: eve = this.onPlay();
        //     case Triggers.onDraw: eve = this.onDraw();
        //     case Triggers.onFinish( dropVal ): eve = this.onFinish( dropVal );
        //     case Triggers.onRound: eve = this.onRound();
        //     case Triggers.onDiscard: eve = this.onDiscard();
        //     default: trace( "Invalid card trigger" );
        // }
        //
        // return eve;


    public function onDraw():EnumValue;

    public function onPlay():EnumValue;

    public function onFinish( dropVal : Int ):EnumValue;

    public function onRound():EnumValue;

    public function onDiscard():EnumValue;

    public function getSuit():EnumValue;

    public function getRank():Int;

    public function getPlayer():String;

    //TODO
    public function toString():String;

    //TODO
    public function equals( c : Card ):Bool;
}
