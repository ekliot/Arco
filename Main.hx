class Main{
    public static function main():Void{
        // make p1
        // make p1's deck
        var d1:Array< Card > = new Array< Card >();
        var p1:String = "Player1";

        // make p2
        // make p2's deck
        var d2:Array< Card > = new Array< Card >();
        var p2:String = "Player2";

        var game:Field = new Field( p1, d1, p2, d2 );
    }
}
