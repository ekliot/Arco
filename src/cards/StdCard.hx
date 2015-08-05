/** Copyright (c) 2015 Elijah Kliot*/

import Suits;
import Triggers;
import Actions;

class StdCard extends Card{
    // private var _front:CardFace;
    // private var _back:CardFace;

    override public function activate( trig : EnumValue ):EnumValue{
        var eve:EnumValue = Actions.Nothing;

        switch( trig ){
            case Triggers.onPlay: eve = this.onPlay();
            case Triggers.onDraw: eve = this.onDraw();
            case Triggers.onFinish( dropVal ): eve = this.onFinish( dropVal );
            case Triggers.onRound: eve = this.onRound();
            case Triggers.onDiscard: eve = this.onDiscard();
            default: trace( "Invalid card trigger" );
        }

        return eve;
    }

    override public function onDraw():EnumValue{
        return Nothing;
    }

    override public function onPlay():EnumValue{
        return Nothing;
    }

    override public function onFinish( dropVal : Int ):EnumValue{
        switch( _suit ){
        // case Bones:
        //     return Discard( dropVal );
        // case Blades:
        //     return Damage( dropVal );
        // case Stars:
        //     return Draw( -dropVal );
        // case Stones:
        //     return Heal( dropVal );
        default:
            return Damage( dropVal );
        }
    }

    override public function onRound():EnumValue{
        switch( _suit ){
        // case Bones:
        //     return Discard( 1 );
        // case Blades:
        //     return Damage( 1 );
        // case Stars:
        //     return Draw( 1 );
        // case Stones:
        //     return Heal( 1 );
        default:
            return Nothing;
        }
    }

    override public function onDiscard():EnumValue{
        return Nothing;
    }

    //TODO
    override public function toString():String{
        return "STD_CARD{ " + _suit + ", " + _rank + " }";
    }

    // returns 0 if a == b, >0 if a > b, or <0 if a < b
    override public function compare( a : Card, b : Card ):Int{
        return ( a.getRank() - b.getRank() );
    }

    //TODO
    override public function equals( c : Card ):Bool{
        return false;
    }
}
