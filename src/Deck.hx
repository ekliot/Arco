import Random;

@:abstract
abstract Deck( Array< Card > ){
    public function new(){
        this = buildDefault();
    }

    public inline function shuffle():Void{
        this = Random.shuffle( this );
    }

    @:arrayAccess
    public function draw():Card{
        return this.shift();
    }

    // set deck to standard 52 card deck
    @:arrayAccess
    public inline function setDefault():Void{
        this = buildDefault();
        shuffle();
    }

    private function buildDefault():Array< Card >{
        var ret:Array< Card > = new Array< Card >();
        // ret.push( new Blade1() );
        // ret.push( new Blade2() );
        // ret.push( new Blade3() );
        // ret.push( new Blade4() );
        // ret.push( new Blade5() );
        // ret.push( new Blade6() );
        // ret.push( new Blade7() );
        // ret.push( new Blade8() );
        // ret.push( new Blade9() );
        // ret.push( new Blade10() );
        // ret.push( new Blade11() );
        // ret.push( new Blade12() );
        // ret.push( new Blade13() );

        return ret;
    }

    // push a card into the deck
    @:arrayAccess
    public function push( c : Card ):Void{
        this.push( c );
    }

    // append another array of cards
    @:arrayAccess
    public function concat( subj : Array< Card > ):Void{
        this.concat( subj );
    }
}
