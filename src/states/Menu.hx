package gamestates;

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
    private var MID : Vector = Luxe.screen.mid;

      // uses the AutoCanvas from mint's test_luxe example for
      // compatibility b/w luxe and mint
    private var canvas_ : AutoCanvas;
      // the margins for mint's rendering
    private var layout_ : Margins;
      // the focus for this canvas
    private var focus_ : Focus;
    // use mint's luxe renderer
    private var rendering_ : LuxeMintRender;

      // a mint List to hold all the menu items
    private var menu_ : List;

    private static var TITLE : String = "ARCO";
      // the title text on the main menu
    private var text_title_ : Text =

    /**
     * just here to initialize the State with the name, nothing special
     */
    public function new(){
        super( { name : "MAIN_MENU" } );
    }

    /**
     * initialize all the main menu elements and the mint classes to manage them
     */
    override function onenter<T>( t : T ){
        rendering_ = new LuxeMintRender();
        layout_ = new Margins();

        var canv_opt:CanvasOptions = {
            name : "canv.mainmenu",
            rendering : rendering_,
            x : 0,         y : 0,
            w : Luxe.screen.w, h : Luxe.screen.h,
            // visible     : true,  // this broke it...
            mouse_input : true,
            key_input   : true
        };

        canvas_ = new AutoCanvas( canv_opt );

        canvas_.auto_listen();

          //this is required to handle input focus in the default way
        focus_ = new Focus( canvas_ );

        text_title = new Text( {
            name : "text.mainmenu.title",
            pos : new Vector( mid.x, mid.y - 200 ),
            align : luxe.TextAlign.center,
            point_size : 72,
            text : TITLE
        } );

        make_buttons();
    }

    /**
     *  initializes the menu and its buttons
     */
    private function make_buttons():Void{

        menu_ = new List( {
            parent : _canvas_,
            name   : 'mainmenu_list',
            x : mid.x - 120,  y : mid.y-42,
            w : 240, h : (48+24)*4
        } );

        var btn_names:Array<String>  = [ 'btn.mainmenu.single', 'btn.mainmenu.multi', 'btn.mainmenu.chars', 'btn.mainmenu.opt', 'btn.mainmenu.exit' ];
        var btn_labels:Array<String> = [ 'Single Player', 'Multiplayer', 'Characters', 'Options', 'Exit' ];

        for( i in 0 ... 4 ){
            var btn_opt:ButtonOptions = {
                parent : menu_,
                name : bttn_names[i],
                text : bttn_labels[i],
                text_size : 36,
                align : 3, // TextAlign.center,
                w : 240,
                h : 48,
                onclick : function(e,c) {
                    var idx:Int = btn_labels[i].lastIndexOf( "." );
                    button_handle( btn_labels[i].substr( idx + 1 ) );
                }
            }

            menu_.add_item( new Button( btn_opt ), 0, (i == 0) ? 0 : 24 );
        }

    }

    /**
     * a handler for what each button does
     *
     * @param :: String :: id :: which button logic to execute
     */
    private function button_handle( id : String ):Void{
        switch ( id ) {
            case "single":
                trace( "Main menu button selected :: Singleplayer" );
                initGame( false );
            case "multi":
                trace( "Main menu button selected :: Multiplayer" );
                // initGame( true );
            case "chars":
                trace( "Main menu button selected :: Characters" );
            case "opt":
                trace( "Main menu button selected :: Options" );
            case "exit":
                Luxe.shutdown();
        }

    }

    /**
     * user selects a game type, a class, and abilities, then either a local room
     * is made with a CPU Adversary, or the server is told to either make a Room
     * which the user's Adversary joins and waits for another Adversary, or find
     * a Room for that gametype waiting for another Adversary
     *
     * @param :: Bool :: multi :: whether or not the game to be initialized is
     *                            multiplayer or not
     */
    public function initGame( multi : Bool ):Void{
        machine.set( "SELECTION", multi );
    }

    /**
     * initializes a new Adversary
     *
     * @param :: AdversaryOptions :: opt :: the Options to use for the new Player
     *
     * @return :: Adversary :: the newly created Adversary
     */
    private static function initAdversary( opt : AdversaryOptions ):Adversary{
        var newAdv:Adversary = new Adversary( opt );

        trace( "Adversary " + opt.name + " initialized:" );
        trace( newAdv.toString() );

        return newAdv;
    }

    /**
     * when leaving this state, cleanup all the menu elements
     */
    override function onleave<T>( t : T ){
        menu_.destroy();
        menu_      = null;

        text_title.destroy();
        text_title = null;

        focus_.destroy();
        focus_     = null;

        rendering_ = null;
        layout_    = null;
        canvas_    = null;
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
