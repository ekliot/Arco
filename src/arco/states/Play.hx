import luxe.States;

/**
 * initializes logic for starting a new game
 */
class Play extends State {

    /**
     *
     */
    public function new( /* single or multiplayer */ ){
        super( { name : "PLAY" } );
    }
}
