import beings.Adversary;

import models.BoardModel;

class Room {

      // semaphore to make sure only one player tries to join at a time
    // private var joining:Bool = false

    private var game_type_:String;
    // private var game_type_:Enum;

    private var adversaries_:Map<String, Adversary> = new Map<String, Adversary>();
    private var board_:BoardModel;

      // a value to keep track of how many Players have joined the game
    private var count:Int;

    /**
     * initializes a Room for a certain gametype, sets up the Board, and is ready
     * for Adversaries to join
     */
    public function new( game_type : String ) {
        game_type_ = game_type;
    }

    /**
     * adds an Adversary to this Room and seats them at the Board
     *
     * @param :: Adversary :: adv :: the Adversary that wishes to join
     *
     * @return :: Bool :: false if the game is full, or the playername already exists
     *                    true otherwise (player successfully joined)
     */
    public function enter( adv : Adversary ):Bool{

        // while( joining ){ wait }

        if( canEnter( adv ) ){
            // joining = true

              // add the player to the player Map
            adversaries_.set( adv.name, adv );
            board_.add_player( adv );

            count++;

              // trace, THIS SHOULD BE DONE THROUGH A LOGGER
            trace( adv.name + " has joined the room..." );

            // joining = false

            return true;
        }

        return false;
    }

    private function canEnter( adv : Adversary ):Bool{
        // return ( count_ < game_type_.getMaxsize() && !adversaries_.exists( adv.getName() ) );
        return ( count_ < 2 && !adversaries_.exists( adv.getName() ) );
    }
}
