package gamestates;

class Session extends State{

    private var _players:Map<String, Player>
                   = new Map<String, Player>();
    private var _pFields:Map<String, Map<Int, Card>>
                   = new Map<String, Map<Int, Card>>();

    private var _BOARD:Board;

    private var _STATES:States;
        // in_progress
        // paused
        // '$_human' + '_active'
        // '$_opponent' + '_active'

    private var _SCENE:Scene;
    private var _UIScene:Scene;

      // THESE NEED TO BE IN THE PLAYERS
    private var _playerHand:Scene;
    private var _playerActive:Scene;
    private var _oppHand:Scene;
    private var _oppActive:Scene;

    /**
     *
     */
    public function new( /* single or multiplayer */ ){
        super( { name : "game_session" } );

        this._BOARD = new Board();

        this._SCENE = new Scene( "board" );
        this._UIScene = new Scene( "UI" );

        this._playerHand = new Scene( "playerHand" );
        this._playerActive = new Scene( "playerActive" );
        this._oppHand = new Scene( "oppHand" );
        this._oppActive = new Scene( "oppActive" );

        this._STATES = new States( { name : "field states" } );
        _STATES.add( new State( { name : "in_progress" } ) );
        _STATES.add( new State( { name : "paused" } ) );
    }

    /**
     *
     *
     * @param  :: Player :: pl ::
     *
     * @return :: Bool :: false if the game is full, or the player already exists
     *                    true otherwise (player successfully joined)
     */
    public function join( pl : Player ):Bool{
          // is the player already in the game?
        if( !_players.exists( pl.getName() ) ){

                // Maps don't have a size method, nor do Iterators, which is
                // the return of keys()... so unfortunately this is necessary
            var check:Int = 0;
            for( name in _players.keys() ){ check += 1; }

              // if there aren''t already two players...
            if( check < 2 ){
                  // add the player to the scene
                _SCENE.add( pl );

                  // add the player to the player Map
                _players.set( pl.getName(), pl );
                  // add the player's card stack
                _pFields.set( pl.getName(), new Map<Int, Card>() );

                  // trace, THIS SHOULD BE DONE THROUGH A LOGGER
                trace( pl.getName() + " has joined the game..." );

                  // add the active state for this player
                _STATES.add( new State( { name : pl.getName() + "_active" } ) );

                return true;
            }
        }

        return false;
    }

      // upon entering this State, set up the scenes and start the game
      // it is expected that before entering the State, the players are already initialized
    override function onenter< String >( gameType : String ){
          // place the barebones version of the Scene, without specific Sprites
        setBoard();

        initUI();

          // set up the player's Sprites
        setPlayer( _human );
          // set up the cpu's Sprites
        setPlayer( _opponent );

          // start the game
        _BOARD.playGame( /*gameType*/ );
    }

    // lays out everything to be a game session sans cards and player values
    //      this includes what are basically templates for HP, Pow, and Deck
    // the way these are set can vary by gameType
    // this is (can be) called before Players are set up
    private function setBoard( /*gameType : String*/ ):Void{
        _SCENE.add( new Sprite( { name : "boardBack", size : Luxe.screen.size,
                                  color : new Color( 1, 0, 1 ),
                                  pos: new Vector(Luxe.screen.mid.x, Luxe.screen.mid.y),
                                  depth : -100 } ) );
    }

    private var _playerHP:Sprite;
    private var _playerPow:Sprite;
    private var _playerDeck:Sprite;

    private var _oppHP:Sprite;
    private var _oppPow:Sprite;
    private var _oppDeck:Sprite;

    private var _FONT:BitmapFont;

    private var _buttonPLAY:Sprite;
    private var _buttonDISCARD:Sprite;
    private var _buttonPASS:Sprite;
    private var _buttonSORT:Sprite;

    private function initUI( /*gameType : String*/ ):Void{
        this._FONT = Luxe.renderer.font;
        trace( _FONT );

        var dims:Array< Float > = cardDim();
        trace( "card dims :: " + dims );
        var cardH:Float = dims[ 0 ];
        var cardW:Float = dims[ 1 ];

                // the smallest y-val that the player active area permeates to (the border between the active area and the player-hand area)
            var pActiveBounds:Float = Luxe.screen.height - ( Luxe.screen.height * ( 5 / 18 ) );
        trace( "pActiveBounds :: " + pActiveBounds );

                // the biggest y-val the opponent's active area permeates to
            var oActiveBounds:Float = Luxe.screen.height * ( 2 / 9 );
        trace( "oActiveBounds :: " + oActiveBounds );

                // the smallest x-val both players' vitals will permeate to
            var vitalsBounds:Float = Luxe.screen.width - ( Luxe.screen.width * ( 1 / 16 ) );
        trace( "vitalsBounds :: " + vitalsBounds );

                // vitals are vitalsDims x vitalsDims in size
            var vitalsDims:Float = Luxe.screen.width * ( 1 / 16 );
        trace( "vitalsDims :: " + vitalsDims );

        Luxe.draw.line( { p0 : new Vector( 0, pActiveBounds ), p1 : new Vector( Luxe.screen.width, pActiveBounds ) } );
        Luxe.draw.line( { p0 : new Vector( 0, oActiveBounds ), p1 : new Vector( Luxe.screen.width, oActiveBounds ) } );



        // PLAYER UI ELEMENTS
        // ##################

            // var hpGeom:CircleGeometry = new CircleGeometry( { id : "hpVitalGeom",
            //                                                   x : vitalsBounds,
            //                                                   y : pActiveBounds,
            //                                                   r : 40,
            //                                                   color : new Color( 1, 0, 0 ) } );

            // HPVital sprite will have a 5px buffer for a total 80x80px
            _playerHP = new Sprite( { name : "playerHP", scene : _UIScene,
                                      size : new Vector( vitalsDims - 10, vitalsDims - 10 ),
                                      centered : false,
                                      pos : new Vector( vitalsBounds + 5, pActiveBounds + 5 ),
                                      depth : 1.1,
                                      color : new Color( 1, 0, 0 ) } );
            trace( "new _playerHP ping" );

            // var powGeom:CircleGeometry = new CircleGeometry( { id : "powVitalGeom",
            //                                                    x : vitalsBounds,
            //                                                    y : pActiveBounds + vitalsBounds,
            //                                                    color : new Color( 0, 1, 0 ) } );

            // PowerVital sprite will have a 5px buffer for a total 80x80px
            _playerPow = new Sprite( { name : "playerPow", scene : _UIScene,
                                       size : new Vector( vitalsDims - 10, vitalsDims - 10 ),
                                       centered : false,
                                       pos : new Vector( vitalsBounds + 5, pActiveBounds + vitalsDims + 5 ),
                                       depth : 1.1,
                                       color : new Color( 0, 1, 0 ) } );
            trace( "new _playerPow ping" );

            // Deck sprite will have a 5px buffer for a total 115x160px
            _playerDeck = new Sprite( { name : "playerDeck", scene : _UIScene,
                                        size : new Vector( cardW, cardH ),
                                        centered : false,
                                        pos : new Vector( 5, pActiveBounds + 5 ),
                                        depth : 1.1,
                                        color : new Color( 0, 0, 1 ) } );
                                        // geometry : new RectangleGeometry( { x : 0,
                                        //                                     y : pActiveBounds,
                                        //                                     w : cardW,
                                        //                                     h : cardH,
                                        //                                     color : new Color( 0, 0, 1 ) } ) } );
            trace( "new _playerDeck ping" );
        // ##################
        // PLAYER UI ELEMENTS

        // OPPONENT UI ELEMENTS
        // ####################

            // var o_hpGeom:CircleGeometry = new CircleGeometry( { id : "o_hpVitalGeom",
            //                                                     x : vitalsBounds,
            //                                                     y : oActiveBounds,
            //                                                     r : 40,
            //                                                     color : new Color( 1, 0, 0 ) } );

            // HPVital sprite will have a 5px buffer for a total 80x80px
            _oppHP = new Sprite( { name : "oppHP", scene : _UIScene,
                                   size : new Vector( vitalsDims - 10, vitalsDims - 10 ),
                                   centered : false,
                                   pos : new Vector( vitalsBounds + 5, 5 ),
                                   depth : 1.1,
                                   color : new Color( 1, 0, 0 ) } );
            trace( "new _oppHP ping" );

            // var o_powGeom:CircleGeometry = new CircleGeometry( { id : "o_powVitalGeom",
            //                                                      x : vitalsBounds,
            //                                                      y : pActiveBounds + vitalsBounds,
            //                                                      color : new Color( 0, 1, 0 ) } );

            // PowerVital sprite will have a 5px buffer for a total 80x80px
            _oppPow = new Sprite( { name : "oppPow", scene : _UIScene,
                                    size : new Vector( vitalsDims - 10, vitalsDims - 10 ),
                                    centered : false,
                                    pos : new Vector( vitalsBounds + 5, vitalsDims + 5 ),
                                    depth : 1.1,
                                    color : new Color( 0, 1, 0 ) } );
            trace( "new _oppPow ping" );

            // Deck sprite will have a 5px buffer for a total 115x160px
            _oppDeck = new Sprite( { name : "oppDeck", scene : _UIScene,
                                     size : new Vector( cardW, cardH ),
                                     centered : false,
                                     pos : new Vector( 5, 5 ),
                                     depth : 1.1,
                                     color : new Color( 0, 0, 1 ) } );
                                    //  geometry : new RectangleGeometry( { x : 0,
                                    //                                      y : 0,
                                    //                                      w : cardW,
                                    //                                      h : cardH,
                                    //                                      color : new Color( 0, 0, 1 ) } ) } );
            trace( "new _oppDeck ping" );
        // ####################
        // OPPONENT UI ELEMENTS

        // BUTTONS
        // #######

            var pointSize:Float = 30 * ( _FONT.info.point_size / _FONT.info.line_height ); // _FONT.line_height_to_point_height( 30, 0 )

            var widthPLAY:Float    = Math.fround( _FONT.width_of_line( "PLAY", pointSize ) );
            var widthDISCARD:Float = Math.fround( _FONT.width_of_line( "DISCARD", pointSize ) );
            var widthPASS:Float    = Math.fround( _FONT.width_of_line( "PASS", pointSize ) );
            var widthSORT:Float    = Math.fround( _FONT.width_of_line( "SORT", pointSize ) );

            trace( [ widthPLAY, widthDISCARD, widthPASS, widthSORT ] );

            _buttonPLAY     = new Sprite( { name : "buttonPLAY", scene : _UIScene,
                                            size : new Vector( widthPLAY, 30 ),
                                            pos : new Vector( 5, Luxe.screen.height - 35 ),
                                            centered : false,
                                            depth : 1.31,
                                            color : new Color( 1, 1, 0 ) } );
            _buttonDISCARD  = new Sprite( { name : "buttonDISCARD", scene : _UIScene,
                                            size : new Vector( widthDISCARD, 30 ),
                                            pos : new Vector( _buttonPLAY.pos.x + _buttonPLAY.size.x + 10, Luxe.screen.height - 35 ),
                                            centered : false,
                                            depth : 1.31,
                                            color : new Color( 1, 1, 0 ) } );
            _buttonPASS     = new Sprite( { name : "buttonPASS", scene : _UIScene,
                                            size : new Vector( widthPASS, 30 ),
                                            pos : new Vector( _buttonDISCARD.pos.x + _buttonDISCARD.size.x + 10, Luxe.screen.height - 35 ),
                                            centered : false,
                                            depth : 1.31,
                                            color : new Color( 1, 1, 0 ) } );
            _buttonSORT     = new Sprite( { name : "buttonSORT", scene : _UIScene,
                                            size : new Vector( widthSORT, 30 ),
                                            pos : new Vector( _buttonPASS.pos.x + _buttonPASS.size.x + 10, Luxe.screen.height - 35 ),
                                            centered : false,
                                            depth : 1.31,
                                            color : new Color( 1, 1, 0 ) } );

            // each button has a 5px buffer for a total height of 40px
            // the text bounds are assuming each character has a width of 20px, with 10px added to the total for the buffer space
            var buttonTextPlay:Text =    new Text( { name : "textPLAY", text : "PLAY", font : _FONT,
                                                     parent : _buttonPLAY,
                                                     point_size : pointSize, letter_spacing : 0.0,
                                                     depth : 1.32 } );
            var buttonTextDiscard:Text = new Text( { name : "textDISCARD", text : "DISCARD", font : _FONT,
                                                     parent : _buttonDISCARD,
                                                     point_size : pointSize, letter_spacing : 0.0,
                                                     depth : 1.32 } );
            var buttonTextPass:Text =    new Text( { name : "textPASS", text : "PASS", font : _FONT,
                                                     parent : _buttonPASS,
                                                     point_size : pointSize, letter_spacing : 0.0,
                                                     depth : 1.32 } );
            var buttonTextSort:Text =    new Text( { name : "textSORT", text : "SORT", font : _FONT,
                                                     parent : _buttonSORT,
                                                     point_size : pointSize, letter_spacing : 0.0,
                                                     depth : 1.32 } );

        // #######
        // BUTTONS
    }

    private var _playerHPText:Text;
    private var _playerPowText:Text;
    private var _playerDeckText:Text;

    private var _oppHPText:Text;
    private var _oppPowText:Text;
    private var _oppDeckText:Text;

    // connects the Scene Sprites with the appropriate player's values
    private function setPlayer( name : String ):Void{
        if( name != "" ){
            var pl:Player = _players.get( name );
            if( name == _human ){
                _playerHPText   = new Text( { name : "playerHPText",
                                              text : Std.string( pl.getHealth() ),
                                              parent : _playerHP,
                                              depth : 1.2 } );
                _playerPowText  = new Text( { name : "playerPowText",
                                              text : Std.string( pl.getPower() ),
                                              parent : _playerPow,
                                              depth : 1.2 } );
                _playerDeckText = new Text( { name : "playerDeckText",
                                              text : Std.string( pl.getDeck().length ),
                                              parent : _playerDeck,
                                              depth : 1.2 } );

                // set up listeners :: HP Change, Pow Change, Deck Change \\
            }
            else if( name == _opponent ){
                _oppHPText   = new Text( { name : "oppHPText",
                                           text : Std.string( pl.getHealth() ),
                                           depth : 1.2,
                                           parent : _oppHP } );
                _oppPowText  = new Text( { name : "oppPowText",
                                           text : Std.string( pl.getPower() ),
                                           depth : 1.2,
                                           parent : _oppPow } );
                _oppDeckText = new Text( { name : "oppDeckText",
                                           text : Std.string( pl.getDeck().length ),
                                           depth : 1.2,
                                           parent : _oppDeck } );

                // set up listeners :: HP Change, Pow Change, Deck Change \\
            }
        }
    }


}
