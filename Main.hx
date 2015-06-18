class Main{
    public static function main():Void{
        // make p1
        // make p1's deck
        var d1:Deck = new Deck();
        d1.setDefault();
        var p1:Player = new Player();

        // make p2
        // make p2's deck
        var d2:Deck = new Deck();
        d2.setDefault();
        var p2:Player = new Player();

        var game:Field = new Field( p1, d1, p2, d2 );
    }
}
