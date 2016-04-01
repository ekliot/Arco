package gamestates;

import gameunits.BoardModel;
import gameunits.Player;

import luxe.States;

/**
 * manages the relationship between Players and the Board
 * will handle multiplayer connectivity in the future
 */
class Session extends State{

    private var _players_:Map<String, Player>
                    = new Map<String, Player>();
    private var _board_:BoardModel;

      // a value to keep track of how many Players have joined the game
    private var count:Int;

    /**
     * initializes the BoardModel for Players to join
     */
    public function new( /* single or multiplayer */ ){
        super( { name : "game_session" } );

        _board_ = new BoardModel();
        count = 0;
    }

    /**
     * set up the scenes and start the game
     * it is expected that before entering the State, the players
     * are already initialized
     *
     * @param :: String :: gameType :: what kind of game rules to use, currently
     *                                 not implemented/used
     */
    override function onenter< String >( gameType : String ){
          // start the game
        _board_.setGame();
    }

    /**
     * adds the Player to this Session and the Board
     *
     * @param :: Player :: pl :: the player to add to the Board
     * @param :: Bool :: top :: whether the Player is to be rendered at the top
     *                          of the Board or not
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
}
