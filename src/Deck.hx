import Random;

@:abstract
abstract Deck( Array< Card > ){
    public function new( ?build = new Array< Card >() ){
        this = build;

    }

    public function shuffle():Deck{
        return Random.shuffle( this );
    }

    @:arrayAccess
    public function draw():Card{
        return this.shift();
    }

    // set deck to standard 52 card deck
    @:arrayAccess
    public function setDefault():Void{
        for( i in 1...14 ){
            // push Blades( i )
            // push Stones( i )
            // push Stars( i )
            // push Bones( i )
        }
        this.shuffle();
    }

    // push a card into the deck
    @:arrayAccess
    public function push( c : Card ):Void{
        this.push( c );
    }

    // append another array of cards
    @:arrayAccess
    public function concat( subj : Array< Card > ){
        this.concat( subj );
    }
}
