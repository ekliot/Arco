package gameunits;

import luxe.States;

import luxe.Scene;
import luxe.Sprite;
import luxe.Vector;
import luxe.Visual;
import luxe.Text;

import phoenix.Color;
import phoenix.geometry.*;
import phoenix.Rectangle;
import phoenix.Circle;
import phoenix.BitmapFont;

class BoardView extends Scene{

      // the top-most y-val that the player active area permeates to
      // (the border between the active area and the player-hand area)
    var _pActiveBounds_:Float;

      // the bottom-most y-val the opponent's active area permeates to
    var _oActiveBounds_:Float;

      // the left-most x-val both players' vitals will permeate to
    var _vitalsBounds_:Float;

      // vitals are vitalsDims x vitalsDims in size (this includes buffer space)
    var _vitalsDims_:Float;

    var _cardDims_:Vector;

    var _ui_scene_:Scene;
    var _card_scene_:Scene;

    private var _font_:BitmapFont;

    private var _playerHP_:Sprite;
    private var _playerPow_:Sprite;
    private var _playerDeck_:Sprite;

    private var _playerHPText_:Text;
    private var _playerPowText_:Text;
    private var _playerDeckText_:Text;

    private var _oppHP_:Sprite;
    private var _oppPow_:Sprite;
    private var _oppDeck_:Sprite;

    private var _oppHPText_:Text;
    private var _oppPowText_:Text;
    private var _oppDeckText_:Text;

    public function new( p1 : Player, p2 : Player ){
        super( "board_view" );

        _ui_scene_ = new Scene( 'ui_scene' );
        _card_scene_ = new Scene( 'card_scene' );
        setBoard( p1, p2 );
    }

    // lays out everything to be a game session sans cards and player values
    //      this includes what are basically templates for HP, Pow, and Deck
    // the way these are set can vary by gameType
    // this is (can be) called before Players are set up
    private function setBoard( p1 : Player, p2 : Player /*, gameType : String*/ ):Void{
        var _2deep4me = -999;

        var bg:Sprite = new Sprite( {
                    name : "boardBack",
                    texture : Luxe.resources.texture( 'assets/blue-grid-720.png' ),
                    centered : false,
                    depth : _2deep4me } );

        initUI();
        
        // setPlayer( p1, false );
        // setPlayer( p2, true );
    }

    private function initUI( /*gameType : String*/ ):Void{
        this._font_ = Luxe.renderer.font;

        _cardDims_ = cardDim();
        trace( "card dims :: " + dims );

        var cardW:Float = _cardDims_.x;
        var cardH:Float = _cardDims_.y;


        /**********************
            -----------  0
            opp
            5   (buffer)
            150 (card)
            5   (buffer)
            -----------  160
            opp-field
            10  (buffer)
            150 (card)
            10  (buffer)
            -----------  330
            pla-field
            10  (buffer)
            150 (card)
            10  (buffer)
            -----------  500
            player
            50  (buffer)
            150 (card)
            20  (buffer)
            ----------  720
        ***********************/


        // the top-most y-val that the player active area permeates to
        // (the border between the active area and the player-hand area)
        _pActiveBounds_ = Luxe.screen.height * ( 25 / 36 );
        trace( "pActiveBounds :: " + _pActiveBounds_ );

        // the bottom-most y-val the opponent's active area permeates to
        _oActiveBounds_ = Luxe.screen.height * ( 2 / 9 );
        trace( "oActiveBounds :: " + _oActiveBounds_ );

        // vitals are vitalsDims x vitalsDims in size
        _vitalsDims_ = Luxe.screen.width * ( 1 / 16 );
        trace( "vitalsDims :: " + _vitalsDims_ );

        // the left-most x-val both players' vitals will permeate to
        _vitalsBounds_ = Luxe.screen.width - _vitalsDims_;
        trace( "vitalsBounds :: " + _vitalsBounds_ );

        Luxe.draw.line( {
            p0 : new Vector( 0, _pActiveBounds_ ),
            p1 : new Vector( Luxe.screen.width, _pActiveBounds_ ) } );
        Luxe.draw.line( {
            p0 : new Vector( 0, _oActiveBounds_ ),
            p1 : new Vector( Luxe.screen.width, _oActiveBounds_ ) } );

        // PLAYER UI ELEMENTS
        // ##################

            // var hpGeom:CircleGeometry = new CircleGeometry( { id : "hpVitalGeom",
            //                                                   x : vitalsBounds,
            //                                                   y : pActiveBounds,
            //                                                   r : 40,
            //                                                   color : new Color( 1, 0, 0 ) } );

            // HPVital sprite will have a 5px buffer for a total 80x80px
            _playerHP_ = new Sprite( { name : "playerHP", scene : _ui_scene_,
                                      size : new Vector( _vitalsDims_ - 10, _vitalsDims_ - 10 ),
                                      centered : false,
                                      pos : new Vector( _vitalsBounds_ + 5, _pActiveBounds_ + 5 ),
                                      color : new Color( 1, 0, 0 ) } );
            trace( "new _playerHP ping" );

            // var powGeom:CircleGeometry = new CircleGeometry( { id : "powVitalGeom",
            //                                                    x : vitalsBounds,
            //                                                    y : pActiveBounds + vitalsBounds,
            //                                                    color : new Color( 0, 1, 0 ) } );

            // PowerVital sprite will have a 5px buffer for a total 80x80px
            _playerPow_ = new Sprite( { name : "playerPow", scene : _ui_scene_,
                                       size : new Vector( _vitalsDims_ - 10, _vitalsDims_ - 10 ),
                                       centered : false,
                                       pos : new Vector( _vitalsBounds_ + 5, _pActiveBounds_ + _vitalsDims_ + 5 ),
                                       color : new Color( 0, 1, 0 ) } );
            trace( "new _playerPow ping" );

            // Deck sprite will have a 5px buffer for a total 115x160px
            _playerDeck_ = new Sprite( { name : "playerDeck", scene : _ui_scene_,
                                        size : _cardDims_,
                                        centered : false,
                                        pos : new Vector( 5, _pActiveBounds_ + 5 ),
                                        color : new Color( 0, 0, 1 ) } );
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
            _oppHP_ = new Sprite( { name : "oppHP", scene : _ui_scene_,
                                   size : new Vector( _vitalsDims_ - 10, _vitalsDims_ - 10 ),
                                   centered : false,
                                   pos : new Vector( _vitalsBounds_ + 5, 5 ),
                                   color : new Color( 1, 0, 0 ) } );
            trace( "new _oppHP ping" );

            // var o_powGeom:CircleGeometry = new CircleGeometry( { id : "o_powVitalGeom",
            //                                                      x : vitalsBounds,
            //                                                      y : pActiveBounds + vitalsBounds,
            //                                                      color : new Color( 0, 1, 0 ) } );

            // PowerVital sprite will have a 5px buffer for a total 80x80px
            _oppPow_ = new Sprite( { name : "oppPow", scene : _ui_scene_,
                                    size : new Vector( _vitalsDims_ - 10, _vitalsDims_ - 10 ),
                                    centered : false,
                                    pos : new Vector( _vitalsBounds_ + 5, _vitalsDims_ + 5 ),
                                    color : new Color( 0, 1, 0 ) } );
            trace( "new _oppPow ping" );

            // Deck sprite will have a 5px buffer for a total 115x160px
            _oppDeck_ = new Sprite( { name : "oppDeck", scene : _ui_scene_,
                                     size : _cardDims_,
                                     centered : false,
                                     pos : new Vector( 5, 5 ),
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

            // var pointSize:Float = 30 * ( _FONT.info.point_size / _FONT.info.line_height ); // _FONT.line_height_to_point_height( 30, 0 )
            //
            // var widthPLAY:Float    = Math.fround( _FONT.width_of_line( "PLAY", pointSize ) );
            // var widthDISCARD:Float = Math.fround( _FONT.width_of_line( "DISCARD", pointSize ) );
            // var widthPASS:Float    = Math.fround( _FONT.width_of_line( "PASS", pointSize ) );
            // var widthSORT:Float    = Math.fround( _FONT.width_of_line( "SORT", pointSize ) );
            //
            // trace( [ widthPLAY, widthDISCARD, widthPASS, widthSORT ] );
            //
            // _buttonPLAY     = new Sprite( { name : "buttonPLAY", scene : _ui_scene_,
            //                                 size : new Vector( widthPLAY, 30 ),
            //                                 pos : new Vector( 5, Luxe.screen.height - 35 ),
            //                                 centered : false,
            //                                 depth : 1.31,
            //                                 color : new Color( 1, 1, 0 ) } );
            // _buttonDISCARD  = new Sprite( { name : "buttonDISCARD", scene : _ui_scene_,
            //                                 size : new Vector( widthDISCARD, 30 ),
            //                                 pos : new Vector( _buttonPLAY.pos.x + _buttonPLAY.size.x + 10, Luxe.screen.height - 35 ),
            //                                 centered : false,
            //                                 depth : 1.31,
            //                                 color : new Color( 1, 1, 0 ) } );
            // _buttonPASS     = new Sprite( { name : "buttonPASS", scene : _ui_scene_,
            //                                 size : new Vector( widthPASS, 30 ),
            //                                 pos : new Vector( _buttonDISCARD.pos.x + _buttonDISCARD.size.x + 10, Luxe.screen.height - 35 ),
            //                                 centered : false,
            //                                 depth : 1.31,
            //                                 color : new Color( 1, 1, 0 ) } );
            // _buttonSORT     = new Sprite( { name : "buttonSORT", scene : _ui_scene_,
            //                                 size : new Vector( widthSORT, 30 ),
            //                                 pos : new Vector( _buttonPASS.pos.x + _buttonPASS.size.x + 10, Luxe.screen.height - 35 ),
            //                                 centered : false,
            //                                 depth : 1.31,
            //                                 color : new Color( 1, 1, 0 ) } );
            //
            // // each button has a 5px buffer for a total height of 40px
            // // the text bounds are assuming each character has a width of 20px, with 10px added to the total for the buffer space
            // var buttonTextPlay:Text =    new Text( { name : "textPLAY", text : "PLAY", font : _FONT,
            //                                          parent : _buttonPLAY,
            //                                          point_size : pointSize, letter_spacing : 0.0,
            //                                          depth : 1.32 } );
            // var buttonTextDiscard:Text = new Text( { name : "textDISCARD", text : "DISCARD", font : _FONT,
            //                                          parent : _buttonDISCARD,
            //                                          point_size : pointSize, letter_spacing : 0.0,
            //                                          depth : 1.32 } );
            // var buttonTextPass:Text =    new Text( { name : "textPASS", text : "PASS", font : _FONT,
            //                                          parent : _buttonPASS,
            //                                          point_size : pointSize, letter_spacing : 0.0,
            //                                          depth : 1.32 } );
            // var buttonTextSort:Text =    new Text( { name : "textSORT", text : "SORT", font : _FONT,
            //                                          parent : _buttonSORT,
            //                                          point_size : pointSize, letter_spacing : 0.0,
            //                                          depth : 1.32 } );

        // #######
        // BUTTONS
    }

    // // connects the Scene Sprites with the appropriate player's values
    // private function setPlayer( name : String, top : Bool ):Void{
    //     if( name != "" ){
    //         var pl:Player = _players.get( name );
    //         if( name == _human ){
    //             _playerHPText   = new Text( { name : "playerHPText",
    //                                           text : Std.string( pl.getHealth() ),
    //                                           parent : _playerHP,
    //                                           depth : 1.2 } );
    //             _playerPowText  = new Text( { name : "playerPowText",
    //                                           text : Std.string( pl.getPower() ),
    //                                           parent : _playerPow,
    //                                           depth : 1.2 } );
    //             _playerDeckText = new Text( { name : "playerDeckText",
    //                                           text : Std.string( pl.getDeck().length ),
    //                                           parent : _playerDeck,
    //                                           depth : 1.2 } );
    //
    //             // set up listeners :: HP Change, Pow Change, Deck Change \\
    //         }
    //         else if( name == _opponent ){
    //             _oppHPText   = new Text( { name : "oppHPText",
    //                                        text : Std.string( pl.getHealth() ),
    //                                        depth : 1.2,
    //                                        parent : _oppHP } );
    //             _oppPowText  = new Text( { name : "oppPowText",
    //                                        text : Std.string( pl.getPower() ),
    //                                        depth : 1.2,
    //                                        parent : _oppPow } );
    //             _oppDeckText = new Text( { name : "oppDeckText",
    //                                        text : Std.string( pl.getDeck().length ),
    //                                        depth : 1.2,
    //                                        parent : _oppDeck } );
    //
    //             // set up listeners :: HP Change, Pow Change, Deck Change \\
    //         }
    //     }
    // }


    // returns an Array, where [ height, width ]
    public function cardDim():Vector{
        var w:Float = Luxe.screen.width * ( 21 / 256 );
        var h:Float = Luxe.screen.height * ( 5 / 24 );
        return new Vector( w, h );
    }
}
