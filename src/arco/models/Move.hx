import Card;

typedef Move = {
        // name of the player making the move
    var name : String;
}

//     // either "PLAY" "PASS" "DISCARD" or "QUIT"
// var move_type : String;

typedef PlayMove = {
    > Move,

        // card that is being played
    var card : Card;
}

typedef PassMove = {
    > Move,
}

typedef DiscardMove = {
    > Move,

        // the cards that are being discarded
    var cards : Array< Card >;
}
