/** Copyright (c) 2015 Elijah Kliot*/

import Suits;
import Triggers;
import Actions;

import luxe.States;
import luxe.Scene;
import luxe.Sprite;
import luxe.Visual;
import luxe.Text;

import phoenix.Color;
import phoenix.geometry.*;
import phoenix.Rectangle;
import phoenix.Circle;
import phoenix.BitmapFont;

import luxe.Input;
import luxe.Events;

import luxe.Screen;
import luxe.Vector;

class Board extends State{
    private var _STATES:States;
        // in_progress
        // paused
        // '$_human' + '_active'
        // '$_opponent' + '_active'

    private var _TURN:Int = 0;
    private var _ROUND:Int = 0;
    private var STARTINGHANDSIZE:Int = 6;

    private var _SCENE:Scene;
    private var _UIScene:Scene;

    private var _players:Map< String, Player > = new Map< String, Player >();
    private var _human:String = "";
    private var _opponent:String = "";

        // < playerName, < cardRank, card > >
    private var _pFields:Map< String, Map< Int, Card > > = new Map< String, Map< Int, Card > >();
    private var _playerHand:Scene;
    private var _playerActive:Scene;
    private var _oppHand:Scene;
    private var _oppActive:Scene;

    private var _turnOrder:Array< String >;
    private var _curPlayer:String;
    private var _winner:String = "";

    private var totRNDS:Int = 0;

    // initializes the board
    public function new( /* gameType : String */ ){
        super( { name : "playing_field" } );
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

    // upon entering this State, set up the scenes and start the game
    // it is expected that before entering the State, the players are already initialized
    override function onenter< String >( gameType : String ){
        // place the barebones version of the Scene, without specific Sprites
        setBoard( /*gameType*/ );

        initUI( /*gameType*/ );

        // set up the player's Sprites
        setPlayer( _human );
        // set up the cpu's Sprites
        setPlayer( _opponent );

        // start the game
        playGame( /*gameType*/ );
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

    // returns true if the player can and did join the game, or false if not (the game is full)
    public function join( pl : Player ):Bool{
        if( !_players.exists( pl.getName() ) ){
            var check:Int = 0;
            for( name in _players.keys() ){ check += 1; }

            if( check < 2 ){
                _SCENE.add( pl );
                _players.set( pl.getName(), pl );
                _pFields.set( pl.getName(), new Map< Int, Card >() );
                trace( pl.getName() + " has joined the game..." );

                _STATES.add( new State( { name : pl.getName() + "_active" } ) );

                if( !pl.isCPU() && _human == "" ){ _human = pl.getName(); }
                else{ _opponent = pl.getName(); }
                return true;
            }
        }

        return false;
    }

    public function playGame( /*gType : String*/ ):Void{
        var names:Iterator< String > = _players.keys();

        var p1:String = names.next();
        var p2:String = names.next();

        if( Random.bool() ){
            _turnOrder = [ p1, p2 ];
        }
        else{
            _turnOrder = [ p2, p1 ];
        }

        _STATES.set( "in_progress" );

        while( _STATES.enabled( "in_progress" ) ){
            playTurn();
        };
    }

    public function playTurn():Void{
        _TURN += 1;
        _ROUND = 1;
        for( p in _turnOrder ){
            _STATES.enable( p + "_active" );
            _players.get( p ).newTurn( STARTINGHANDSIZE );
            _STATES.disable( p + "_active" );
        }

        var passed:Array< String > = new Array< String >();
        var isDead:Bool = false;
            var loser:String = "";

        while( passed.length < 2 ){
            var p1:String = _turnOrder[0];
            var p2:String = _turnOrder[1];

            //
            if( passed.indexOf( p1 ) != -1 ){
                playRound( p1 );
            }

            if( _players.get( p1 )._states.enabled( "_passed" ) ){
                passed.push( p1 );
            }

            // ##############
            // check for dead
            for( p in _players.keys() ){
                if( !_players.get( p )._states.enabled( "_living" ) ){
                    isDead = true;
                    loser = p;
                    break;
                }
            }
            // check for dead
            // ##############

            if( passed.indexOf( p2 ) != -1 ){
                playRound( p2 );
            }
            if( _players.get( p2 )._states.enabled( "_passed" ) ){
                passed.push( p2 );
            }

            // ##############
            // check for dead
            for( p in _players.keys() ){
                if( !_players.get( p )._states.enabled( "_living" ) ){
                    isDead = true;
                    loser = p;
                    break;
                }
            }
            // check for dead
            // ##############
        }

        // is someone dead?
            // if they are, declare the game won
        if( isDead ){
            _STATES.disable( "in_progress" );
            gameOver( decideOpp( loser ) );
            return;
        }
        // if no one is dead, clear the board for a new round
        clearBoard();
    }

    public function playRound( activePlayer : String ):Void{
        var p:Player = _players.get( activePlayer );

        _curPlayer = activePlayer;
        _STATES.enable( activePlayer + "_active" );

        p.events.listen( "Player." + activePlayer + ".move.*", processMove ); // listen for a move action from the active player

        while( _STATES.enabled( _turnOrder[0] + "_active" ) ){}

        p.events.unlisten( "Player." + activePlayer + ".move.*" );
    }

    private function processMove( mv : Dynamic ):Void{
        var cp:String = _curPlayer;

        if( mv.from.getName() == cp ){

        }
    }

    // validates whether a Move from a player is in line with the game's rules
    public function validateMove( mv : Move ):Bool{
        // switch( mv.getType().toUpperCase() ){
        // case "PLAY":
        //     return validatePlay( mv.getPlayer(), mv.getVal() );
        // case "DISCARD":
        //     return validateDiscard( mv.getPlayer(), mv.getVal() );
        // case "PASS":
        //     return validatePass( mv.getPlayer() );
        // case "QUIT":
        //     _players.get( mv.getPlayer() ).killMe();
        //     return true;
        // default:
        //     trace( "MOVE NOT RECOGNIZED" );
        //     return false;
        // }
        return false;
    }

    public function validatePlay( p : String, val : Int ):Bool{
        var player:Player = _players.get( p );
        if( player.getPower() >= val - 1 ){
            return true;
        }
        trace( "BOARD DOES NOT VALIDATE " + p + "'s PLAY MOVE" );
        return false;
    }

    public function validateDiscard( p : String, val : Int ):Bool{
        var player:Player = _players.get( p );
        if( player.getPower() <= val + 1 ){
            return true;
        }
        trace( "BOARD DOES NOT VALIDATE " + p + "'s DISCARD MOVE" );
        return false;
    }

    public function validatePass( p : String ):Bool{
        var player:Player = _players.get( p );

        // if the player has a card he can play...
        for( c in player.getHand() ){
            if( c.getRank() <= player.getPower() + 1 ){
                trace( "BOARD DOES NOT VALIDATE " + p + "'s PASS" );
                return false;
            }
        }

        // or if the player can discard cards...
        if( ( player.getHand().length >= player.getPower() - 1 ) &&
            ( player.getHand().length > 1 ) ){
            trace( "BOARD DOES NOT VALIDATE " + p + "'s PASS" );
            return false;
        }

        _players.get( p )._states.enable( "_passed" );
        return true;
    }

    // functions calling this should check this for whether the target player is killed if they have an additional effect on-kill
    private function dealDamage( targ : String, amt : Int ):Void{
        trace( targ + " is being dealt " + amt + " damage...");
        var target:Player = _players.get( targ );
        target.processEvent( Damage( amt ) );
    }

    // place the card in the player's field, and activate its onPlay trigger
    public function playCard( pl : String, subj : Card ):Void{

        trace( pl + " is playing: " + subj.toString() );
        _pFields.get( pl ).set( subj.getRank(), subj );

        activateCard( subj, onPlay );
    }

    public function activateCard( subj : Card, trig : EnumValue, ?target = "" ):Void{
        trace( "Activating " + subj + " with " + trig + "trigger..." );

        var eve:EnumValue = subj.activate( trig );

        trace( "Event occurred: " + eve );

        if( !_players.exists( target ) ){
            var pl:String = subj.getPlayer();
            var opp:String = decideOpp( pl );
            switch( eve ){
            case Damage( amount ):
                _players.get( opp ).processEvent( eve );
            case Heal( amount ):
                _players.get( pl ).processEvent( eve );
            case Discard( amount ):
                trimBoard( opp, 0, amount );
            case Draw( amount ):
                _players.get( pl ).processEvent( eve );
            default:
                trace( "Nothing happens" );
            }
        }

        else{
            _players.get( target ).processEvent( eve );
        }
    }

    // clears all cards on the board to appropriate players' discard piles
    // can specify which player's board to clear, or all boards if none specified
    // calls the trimBoard function with parameters to clear cards of all ranks
    private function clearBoard( ?name = "" ):Void{
        trimBoard( name, 0, -1 );

        // if( !_players.exists( name ) ){
        //     trace( "Clearing all boards!" );
        //
        //     // for every player...
        //     for( b in _players.keys() ){
        //         trace( "Clearing " + b + "'s field...");
        //         // for every card on their board...
        //         for( c in _pFields.get( b ) ){
        //             // push it to their discard pile...
        //             _players.get( b ).pushDiscard( c );
        //         }
        //
        //         // then replace their board with a fresh one
        //         _pFields.set( b, new Array< Card >() );
        //     }
        // }
        // else{
        //     trace( "Clearing " + name + "'s field...");
        //     for( c in _pFields.get( name ) ){
        //         _players.get( name ).pushDiscard( c );
        //     }
        //     _pFields.set( name, new Array< Card >() );
        // }
    }

    // clears all cards of rank in a certain range (inclusive) for either a certain player or both if no player is specified
    // any min value is valid. if the max is less than the min, there is no upper limit
    // by default the min is 0 and the max is -1
    // if min == max and min,max <= 0, no cards are discarded (unless the card's rank == max)
    public function trimBoard( ?name = "", ?threshMin : Int = 0, ?threshMax : Int = -1 ):Void{
        if( !_players.exists( name ) ){
            trace( "Trimming all cards in play between $threshMin and $threshMax" );

            // for every player...
            for( b in _players.keys() ){
                trace( "Trimming " + b + "'s field...");
                var rem:Array< Card > = new Array< Card >();

                // for every card on their board...
                for( c in _pFields.get(b).keys() ){
                    if( c >= threshMin && ( threshMax < threshMin || c <= threshMax ) ){
                        var card:Card = _pFields.get( b ).get( c );
                        if( card != null ){ rem.push( card ); }
                    }
                }

                // push it to their discard pile...
                for( c in rem ){
                    _pFields.get( b ).set( c.getRank(), null );
                    _players.get( b ).pushDiscard( c, true );
                }
            }
        }
        else{
            trace( "Trimming " + name + "'s cards in play between $threshMin and $threshMax" );
            var rem:Array< Card > = new Array< Card >();
            for( c in _pFields.get( name ).keys() ){
                if( c >= threshMin && ( threshMax < threshMin || c <= threshMax ) ){
                    var card:Card = _pFields.get( name ).get( c );
                    if( card != null ){ rem.push( card ); }
                }
            }
            for( c in rem ){
                _pFields.get( name ).set( c.getRank(), null );
                _players.get( name ).pushDiscard( c, true );
            }
        }
    }

    // given a map of the players in this card's game and this card's player, what is this card's player's opponent's name?
    public function decideOpp( pl : String ):String{
        var players:Iterator< String > = this._players.keys();
        var p1:String = players.next();
        var p2:String = players.next();
        if( p1 == pl ){
            return p2;
        }
        return p1;
    }

    // called to check if a player is dead, returns whether the death is true
    private function isKill( targ : String ):Bool{
        var ret:Bool = this._players.get( targ ).getDead();
        trace( "Is " + targ + " dead: " + ret );
        return ret;
    }

    // private function isWinner():String{
    //     for( cond in winConditions ){
    //         for( p in _turnOrder ){
    //             if( cond( p ) ){
    //                 return p;
    //             }
    //         }
    //     }
    // }

    private function gameOver( ?winner = "" ):String{
        if( winner.length == 0 ){
            return "The game ends in a tie";
        }

        else{
            _winner = winner;
            return "The winner is " + winner + "!";
        }
    }

// #########
// listeners
    override function onkeyup( ev:KeyEvent ){
        if( ev.keycode == Key.escape ){
            if( !_STATES.enabled( "paused" ) ){
                _STATES.enable( "paused" );
            }
            else{
                _STATES.disable( "paused" );
            }
        }
    }

    override public function onmousemove( e:MouseEvent ){

    }

    override public function onmouseup( e:MouseEvent ){
        var p:Player = _players.get( _curPlayer );

        if( _STATES.enabled( "in_progress" ) && !p.isCPU() ){
            if( _buttonPLAY.point_inside( e.pos ) ){
                p._pMove.set( "PLAY" );
                // change color
            }
            else if( _buttonDISCARD.point_inside( e.pos ) ){
                if( p._pMove.current_state.name == "DISCARD" ){
                    if( validateDiscard( _curPlayer, p.getDiscardSelection().length ) ){
                        p.moveDiscardCards();
                    }
                }
                else{
                    p._pMove.set( "DISCARD" );
                }
            }
            else if( _buttonPASS.point_inside( e.pos ) ){

            }
            else if( _buttonSORT.point_inside( e.pos ) ){

            }
        }
    }

        // listen for a card draw   \\
        // listen for a card play    \\
            // ^^ handle the card sprite arrangement here
            // hands will stay at the same vertical height and will start from an absolute point on the left-hand side

        // listen for a hand sort        \\
            // pull cards off screen, push new order back on screen

        // listen for a deck shuffle        \\
        // listen for a change in health     \\
        // listen for a change in power level \\

// listeners
// #########

    override public function update( dt:Float ){
        if( _STATES.enabled( "paused" ) ){
            return;
        }

    }

    override public function onreset(){

    }

    //TODO
    public function toString():String{
        return ""; // "\t{DESCRIPTION}"
    }

    public function getRound():Int{
        return this._ROUND;
    }

    public function getTurn():Int{
        return this._TURN;
    }

    public function getPlayer( name : String ):Player{
        return this._players.get( name );
    }

    public function getActiveCards( name : String ):Map< Int, Card >{
        return this._pFields.get( name );
    }

    // returns an Array, where [ height, width ]
    public function cardDim():Array< Float >{
        var h:Float = Luxe.screen.height * ( 5 / 24 );
        var w:Float = Luxe.screen.width * ( 21 / 256 );
        return [ h, w ];
    }


    // ##########
    // DEPRACATED

    // // starts playing the game
    // public function playGame( gameType : String ):Void{
    //     _TURN = 0;
    //     _ROUND = 0;
    //
    //     var names:Iterator< String > = _players.keys();
    //
    //     var p1:String = names.next();
    //     var p2:String = names.next();
    //
    //     if( Random.bool() ){
    //         _turnOrder = [ p1, p2 ];
    //     }
    //     else{
    //         _turnOrder = [ p2, p1 ];
    //     }
    //
    //     trace( "Turn order: " + _turnOrder.toString() );
    //
    //     var playing:Bool = true;
    //
    //     while( playing ){
    //         nextTurn();
    //
    //         for( p in _turnOrder ){
    //             trace( "Notifying " + p + " of new turn...");
    //             var player:Player = _players.get( p );
    //             player.newTurn( STARTINGHANDSIZE );
    //         }
    //
    //         // new turn begins
    //         cycleRounds(); // rounds for that turn are played
    //         // turn ends
    //
    //         // check that there are living players
    //         for( p in _turnOrder ){
    //             if( isKill( p ) ){
    //                 trace( gameOver( decideOpp( p ) ) );
    //                 playing = false;
    //                 break;
    //             }
    //         }
    //     }
    //
    //     trace( totRNDS + " ROUNDS PLAYED" );
    // }
    //
    // // restarts the round counter, increments the turn counter
    // private function nextTurn():Void{
    //     _TURN += 1;
    //     _ROUND = 1;
    //
    //     clearBoard();
    // }
    //
    // // play a single round, return false if a player dies or both have empty hands
    // private function playRound():Bool{
    //     totRNDS += 1;
    //
    //     var subjects:Array< String > = _turnOrder;
    //
    //     trace( "Turn " + _TURN + ", Round " + _ROUND + " participants: " + subjects.toString() );
    //
    //     var done:Int = 0;
    //
    //     for( p in subjects ){
    //         var player:Player = _players.get( p );
    //
    //         if( player.getHand().length > 0 ){
    //             trace( p + " is beginning their round..." );
    //
    //             var inPlay:Array< Card > = _pFields.get( p );
    //             trace( "\n" + p + "'s cards in play:\n\t" + inPlay );
    //
    //
    //             trace( "\nActivating " + p + "'s cards in play..." );
    //             for( c in inPlay ){
    //                 trace( "\tActivating " + c.toString() );
    //                 activateCard( c, onRound );
    //             }
    //
    //             var dr:Card = player.draw( 1 )[ 0 ];
    //             // if( dr != null ){
    //             //     trace( p + " has drawn " + dr.toString() );
    //             // }
    //
    //             trace( "Waiting for move..." );
    //             player.makeMove(); // will validate for each move command, when makeMove() is done it is assumed that the move made was validated, through this class, from within that function
    //
    //             for( q in subjects ){
    //                 if( isKill( q ) ){
    //                     return false;
    //                 }
    //             }
    //         }
    //
    //         else{
    //             trace( "Empty hand, do not pass GO, do not collect 200 dollars" );
    //             done += 1;
    //             player.chPower( 1 );
    //         }
    //
    //         // Sys.sleep( 2 );
    //     }
    //
    //     trace( "\n\nRound over, beginning next round...\n");
    //
    //     if( done >= _turnOrder.length ){
    //         return false;
    //     }
    //
    //     return true;
    // }
    //
    // // plays rounds until a player dies or both players have empty hands
    // private function cycleRounds():Void{
    //     var roundsActive:Bool = true;
    //
    //     while( roundsActive ){
    //         _ROUND += 1;
    //         trace( "\nTurn " + _TURN + ", Round " + _ROUND + "\n" );
    //         roundsActive = playRound();
    //     }
    // }

    // DEPRACATED
    // ##########
}