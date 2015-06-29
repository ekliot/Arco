import Suits;
import Triggers;
import Actions;

class Blade1 implements Card{
    // private var _front:CardFace;
    // private var _back:CardFace;

    private var _suit:EnumValue = Blades;
    private var _rank:Int = 1;

    private var _PLAYER:String;

    public function new( /* cardType : EnumValue, */ player : String ){
        this._PLAYER = player;
        // switch( cardType ){
        //     case Blades( rank ): this._suit = "BLADES"; this._rank = rank;
        //     case Bones( rank ): this._suit = "BONES"; this._rank = rank;
        //     case Stars( rank ): this._suit = "STARS"; this._rank = rank;
        //     case Stones( rank ): this._suit = "STONES"; this._rank = rank;
        //     case Joker: this._suit = "JOKER";
        // }
    }

    // activate can be called with or without a target. if without, each event has a default target for this card
    public function activate( trig : EnumValue, players : Map< String, Player >, target : String ):EnumValue{
        var eve:EnumValue = Nothing;

        switch( trig ){
            case onPlay: eve = this.onPlay();
            case onDraw: eve = this.onDraw();
            case onFinish( dropVal ): eve = this.onFinish( dropVal );
            case onRound: eve = this.onRound();
            case onDiscard: eve = this.onDiscard();
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

    public function toString():String{
        return "Card[ Blades, 1 ]";
    }

    //TODO
    public function equals( c : Card ):Bool{
        return false;
    }
}
