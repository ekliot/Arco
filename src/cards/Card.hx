class Card{
    // private var _front:CardFace;
    // private var _back:CardFace;

    public static var _suit:EnumValue;
    public static var _rank:Int;

    public static var _triggers:Array< EnumValue >;

    public function new(){}

    public function getTriggers():Array< EnumValue >{
        return this._triggers;
    }

    public function activate( trig : EnumValue ):Void{
        switch( trig ){
            case onPlay: this.onPlay();
            case onDraw: this.onDraw();
            case onFinish: this.onFinish();
            case onRound: this.onRound();
            case onDiscard: this.onDiscard();
            default: trace( "Invalid card trigger" );
        }
    }

    private function onDraw():EnumValue{}

    private function onPlay():EnumValue{}

    private function onFinish():EnumValue{}

    private function onRound():EnumValue{}

    private function onDiscard():EnumValue{}

    //TODO
    public function toString():String{

    }

    //TODO
    public function equals( c : Card ):Bool{

    }
}
