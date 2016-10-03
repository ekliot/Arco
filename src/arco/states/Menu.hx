package arco.states;


import arco.views.MenuView;

import luxe.Input;
import luxe.States;


/**
 * the main menu for the game, offers a choice of single-player, multiplayer,
 * customization, options, and exiting the game
 * utilizes mint to render the menu
 */
class Menu extends State {


        // the view associated with this menu state
    private var view : MenuView;


    /**
     * just here to initialize the State with the name, nothing special
     */
    public function new() {

        super( { name : "state.main_menu" } );

    } // new()

    /**
     * initialize all the main menu elements and the mint classes to manage them
     */
    override function onenter<T>( t : T ) {

        view = new MenuView( this );

    } // onenter()

    /**
     * when leaving this state, cleanup all the menu elements
     */
    override function onleave<T>( t : T ) {

        view.destroy()
        view = null;

    } // onleave()

    /**
     * user selects a game type, a class, and abilities, then either a local room
     * is made with a CPU Adversary, or the server is told to either make a Room
     * which the user's Adversary joins and waits for another Adversary, or find
     * a Room for that gametype waiting for another Adversary
     *
     * @param :: Bool :: multi :: whether or not the game to be initialized is
     *                            multiplayer or not
     */
    public function init_game( multi : Bool ): Void {

        trace( "Menu.initGame( multi = $multi ) :: Switching to Selection State..." );
        machine.set( "state.selection", multi );

    } // init_game()

    private function handle_shutdown(): Void {

            /* <TODO> confirm shutdown/exit? */
        if ( true ) {

            trace( "Shutting down..." );
            Luxe.shutdown();

        } else {

            trace( "User denied shutdown" );

        }

    } // handle_shutdown()

    /**
     * a handler for what each button does
     *
     * @param :: String :: id :: which button logic to execute
     */
    private function handle_menuButton( id : String ): Void {

            /* <TODO> the switch cases ought to be matching to a string container */
        switch ( id ) {

            case "single":
                trace( "Main menu button selected :: Singleplayer" );
                init_game( false );
            case "multi":
                trace( "Main menu button selected :: Multiplayer" );
                // init_game( true );
            case "chars":
                trace( "Main menu button selected :: Characters" );
            case "opt":
                trace( "Main menu button selected :: Options" );
            case "exit":
                trace( "Main menu button selected :: Shutdown" );
                handle_shutdown();

        } // switch ( id )

    } // handle_menuButton()

    /**
     * key input handling
     */
    override function onkeyup( e : KeyEvent ) {

        trace( "Menu :: User pressed " + e.keycode );

        if ( e.keycode == Key.escape ) {

            handle_shutdown();

        } // if key == esc

        /**
         * <TODO> implement input handling for keyboard navigation:
         *   - arrow keys
         *     + up => view.cursor_up()
         *     + down => view.cursor_down()
         *     + left => view.cursor_left()
         *     + right => view.cursor_right()
         *   - enter/space => view.cursor_select()
         */

    } // onkeyup()


} // class Menu
