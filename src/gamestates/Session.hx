package gamestates;

import gameunits.BoardModel;
import gameunits.Player;

import luxe.States;

class Session extends State{

    private var _players_:Map<String, Player>
                    = new Map<String, Player>();
    private var _board_:BoardModel;

    private var count:Int;

    /**
     *
     */
    public function new( /* single or multiplayer */ ){
        super( { name : "game_session" } );

        _board_ = new BoardModel();
        count = 0;
    }

    /**
     *
     *
     * @param  :: Player :: pl ::
     *
     * @return :: Bool :: false if the game is full, or the player already exists
     *                    true otherwise (player successfully joined)
     */
    public function enterPlayer( pl : Player, top : Bool ):Bool{
          // is the player already in the game?
        if( !_players_.exists( pl.name ) && count < 2 ){

              // add the player to the player Map
            _players_.set( pl.name, pl );
            _board_.add_player( pl, top );

            count++;

              // trace, THIS SHOULD BE DONE THROUGH A LOGGER
            trace( pl.name + " has joined the session..." );

            return true;
        }

        return false;
    }

      // upon entering this State, set up the scenes and start the game
      // it is expected that before entering the State, the players are already initialized
    override function onenter< String >( gameType : String ){
          // start the game
        _board_.setGame();
    }
}
