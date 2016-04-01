package gamestates;

import gameunits.Player;
import gameunits.cards.Card;

import luxe.Input;
import luxe.States;
import luxe.Text;

import luxe.Sprite;
import luxe.Scene;

import luxe.Vector;
import luxe.Color;

import mint.core.Signal;
import mint.Canvas;
import mint.layout.margins.Margins;
import mint.focus.Focus;
import mint.List;
import mint.Button;

import mint.render.luxe.LuxeMintRender;

/**
 * the main menu for the game, offers a choice of single-player, multiplayer,
 * options, and exiting the game
 * utilizes mint to render the menu
 */
class Menu extends State{

      // a shortcut to getting the middle of the screen
    private var mid : Vector = Luxe.screen.mid;

      // uses the AutoCanvas from mint's test_luxe example for
      // compatibility b/w luxe and mint
    private var _canvas_ : AutoCanvas;
      // the margins for mint's rendering
    private var _layout_ : Margins;
      // the focus for this canvas
    private var  _focus_ : Focus;

      // use mint's luxe renderer
    private var _rendering_ : LuxeMintRender;

      // a mint List to hold all the menu items
    private var _menu_ : List;
      // the title text on the main menu
    private var text_title : Text;

      /**
       * just here to initialize the State with the name, nothing special
       */
    public function new(){
        super( { name : "main_menu" } );
    }

    /**
     * initialize all the main menu elements and the mint classes to manage them
     */
    override function onenter<T>( t : T ){
        _rendering_ = new LuxeMintRender();
        _layout_ = new Margins();

        var canv_opt:CanvasOptions = {
            name : "main_menu",
            rendering : _rendering_,
            x : 0,         y : 0,
            w : Luxe.screen.w, h : Luxe.screen.h,
            // visible     : true,  // this broke it...
            mouse_input : true,
            key_input   : true };

        _canvas_ = new AutoCanvas( canv_opt );

        _canvas_.auto_listen();

          //this is required to handle input focus in the default way
        _focus_ = new Focus( _canvas_ );

        text_title = new Text( {
            name : "title-text",
            pos : new Vector( mid.x, mid.y - 200 ),
            align : luxe.TextAlign.center,
            point_size : 72,
            text : "ARCO" } );

        make_buttons();
    }

    /**
     *  initializes the menu and its buttons
     */
    private function make_buttons():Void{

        _menu_ = new List( {
            parent : _canvas_,
            name   : 'main_menu_list',
            x : mid.x - 120,  y : mid.y-42,
            w : 240, h : (48+24)*4 } );

        var bttn_names  = [ 'bttn_sngl', 'bttn_mult', 'bttn_opt', 'bttn_exit' ];
        var bttn_labels = [ 'Single Player', 'Multiplayer', 'Options', 'Exit' ];

        for( i in 0 ... 4){
            var bttn_opt:ButtonOptions = {
                parent : _menu_,
                name : bttn_names[i],
                text : bttn_labels[i],
                text_size : 36,
                align : 3, // TextAlign.center,
                w : 240,        h : 48,
                onclick : function(e,c) { button_handle( i ); }
            }

            _menu_.add_item( new Button( bttn_opt ), 0, (i == 0) ? 0 : 24 );
        }

    }

    /**
     * a handler for what each button does
     *
     * @param :: Int :: id :: which button logic to execute
     */
    private function button_handle( id : Int ):Void{
        switch ( id ) {
            case 0:
                trace( "BEEPBOOP SINGLEPLAYER" );
                initGame( false );
            case 1:
                trace( "BEEPBOOP MULTIPLAYER" );
                // initGame( true );
            case 2:
                trace( "BEEPBOOP OPTIONS" );
            case 3:
                Luxe.shutdown();
        }

    }

    /**
     * initializes players and their decks, then initializes a Session and
     * adds the players
     *
     * @param :: Bool :: multi :: whether or not the game to be initialized is
     *                            multiplayer or not
     */
    public function initGame( multi : Bool ):Void{

        /*
          trace( "First player's name: ");
          var p1:String = Sys.stdin().readLine();

          PROMPT FOR PLAYER NAME
         */

          // replace this with a text input prompt
        var p1:String = "YOU";

          // make p1's deck
        var d1:Array<Card> = new Array<Card>();

          // make p1
        var player1:Player = initPlayer( { n : p1, deck : d1, cpu : false } );

        var p2:String;
        var d2:Array<Card>;

        if( multi ){
            /* multiplayer logic */

            p2 = "CPU";

              // make p2's deck
            d2 = new Array<Card>();
        } else{
            p2 = "CPU";

              // make p2's deck
            d2 = new Array<Card>();
        }

          // make p2
        var player2:Player = initPlayer( { n : p2, deck : d2, cpu : true } );

          // unsafe cast from State to Session
        var session:Session = cast this.machine._states.get( 'game_session' );

          // check that both players joined without problem
        if( session.enterPlayer( player1, false ) &&
            session.enterPlayer( player2, true  ) ){
            this.machine.set( 'game_session' );
        } else{
            trace( "players could not join game, destroying Session")
            session.destroy();
        }
    }

    /**
     * initializes a new Player
     *
     * @param :: PlayerOptions :: opt :: the Options to use for the new Player
     *
     * @return :: Player :: the newly created Player
     */
    private static function initPlayer( opt : PlayerOptions ):Player{
        var newP:Player = new Player( opt );

        trace( "Player " + opt.n + " initialized" );
        trace( newP );

        return newP;
    }

    /**
     * when leaving this state, cleanup all the menu elements
     */
    override function onleave<T>( t : T ){
        _menu_.destroy();
        _menu_      = null;

        text_title.destroy();
        text_title  = null;

        _focus_.destroy();
        _focus_     = null;

        _rendering_ = null;
        _layout_    = null;
        _canvas_    = null;
    }

    /**
     * key input handling
     */
    override function onkeyup( e:KeyEvent ){
        if( e.keycode == Key.escape ){
            /* CONFIRM EXIT? */
            Luxe.shutdown();
        }
    }
}
