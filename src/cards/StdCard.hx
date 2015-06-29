import Suits;
import Triggers;
import Actions;

class StdCard implements Card{
    // private var _front:CardFace;
    // private var _back:CardFace;

    private var _suit:EnumValue;
    private var _rank:Int;

    private var _PLAYER:String;

    public function new( pl : String, suit : EnumValue, rank : Int ){
        this._PLAYER = pl;
        this._suit = suit;
        this._rank = rank;
    }

    // activate can be called with or without a valid target. if without, each event has a default target for this card
    public function activate( trig : EnumValue, target : String ):EnumValue{
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

    public function onDraw():EnumValue{
        return Nothing;
    }

    public function onPlay():EnumValue{
        return Nothing;
    }

    public function onFinish( dropVal : Int ):EnumValue{
        return Damage( dropVal );
    }

    public function onRound():EnumValue{
        return Nothing;
    }
    public function onDiscard():EnumValue{
        return Nothing;
    }

    public function getSuit():EnumValue{
        return this._suit;
    }

    public function getRank():Int{
        return this._rank;
    }

    public function getPlayer():String{
        return this._PLAYER;
    }

    //TODO
    public function toString():String{
        var ret:String = "CARD{ " + _suit + ", " + _rank + " }";
        return ret;
    }

    //TODO
    public function equals( c : Card ):Bool{
        return false;
    }
}
