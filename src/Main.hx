

import arco.states.Menu;
import arco.states.Selection;
import arco.states.Play;
import arco.states.Pause;
import arco.states.Options;

import luxe.Game;
import luxe.States;


/**
 * Main class encapsulates the game, manages the overarching states
 * and hangles congigs
 */
class Main extends Game{


    private var state:States;


    /**
     * the logic to run when the game starts, initializes
     * States and enters main menu
     */
    override function ready(){

            // <TODO> what is this for?
        Luxe.renderer.clear_color.rgb(0x121219);

        state = new States( { name : "machine.core" } );
        state.add( new Menu() );
        state.add( new Selection() );
        state.add( new Play() );
        state.add( new Options() );
        state.add( new Pause() );

        state.set( 'state.main_menu' );

    } // ready()

    /**
     * currently just manages the preloading of assets
     */
    override function config( config: luxe.AppConfig ) {

        config.preload.textures.push( { id:'assets/blue-grid-720.png' } );

        return config;

    } // config()


} // Main
