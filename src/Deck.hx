import Random;

@:abstract
abstract Deck( Array< Card > ){
    public function new(){
        this = new Array< Card >();
    }

    public function shuffle():Void{
        Random.shuffle( this );
    }

    public function draw():Card{

    }
}
