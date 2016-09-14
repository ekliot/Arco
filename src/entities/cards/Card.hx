package gameunits.cards;

// import Suits;
// import Triggers;
// import Actions;

// import CardOptions;

import luxe.Sprite;
import luxe.options.SpriteOptions;

// typedef CardOptions = {
//     > SpriteOptions,
//
//     var rank : Int;
//
//     var suit : EnumValue;
//
//     var played_from : String;
// }


class Card extends Sprite{
    // private var _front:CardFace;
    // private var _back:CardFace;

    // private var _suit:EnumValue;
    // private var _rank:Int;
    //
    // private var _PLAYER:String;
    //
    public function new( options : SpriteOptions ){
        super( options );
        // this._PLAYER = options.played_from;
        // this._suit = options.suit;
        // this._rank = options.rank;
    }
    //
    // public function activate( trig : EnumValue ):EnumValue{
    //     var eve:EnumValue = Actions.Nothing;
    //
    //     switch( trig ){
    //         case Triggers.onPlay: eve = this.onPlay();
    //         case Triggers.onDraw: eve = this.onDraw();
    //         case Triggers.onFinish( dropVal ): eve = this.onFinish( dropVal );
    //         case Triggers.onRound: eve = this.onRound();
    //         case Triggers.onDiscard: eve = this.onDiscard();
    //         default: trace( "Invalid card trigger" );
    //     }
    //
    //     return eve;
    // }
    //
    // public function onDraw():EnumValue{
    //     return Nothing;
    // }
    //
    // public function onPlay():EnumValue{
    //     return Nothing;
    // }
    //
    // public function onFinish( dropVal : Int ):EnumValue{
    //     return Nothing;
    // }
    //
    // public function onRound():EnumValue{
    //     return Nothing;
    // }
    //
    // public function onDiscard():EnumValue{
    //     return Nothing;
    // }
    //
    // public function getSuit():EnumValue{
    //     return _suit;
    // }
    //
    // public function getRank():Int{
    //     return _rank;
    // }
    //
    // public function getPlayer():String{
    //     return _PLAYER;
    // }
    //
    // //TODO
    // public function toString():String{
    //     return "CARD{ " + _suit + ", " + _rank + " }";
    // }
    //
    // // returns 0 if a == b, >0 if a > b, or <0 if a < b
    // // returns 0 if a == b, >0 if a > b, or <0 if a < b
    // public function compare( a : Card, b : Card ):Int{
    //     return ( a.getRank() - b.getRank() );
    // }
    //
    // //TODO
    // public function equals( c : Card ):Bool{
    //     return false;
    // }
    //
}
