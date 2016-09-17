import states.Menu;
import states.Play;
import states.Pause;
import states.Options;

import luxe.Game;
import luxe.States;
import luxe.Color;

/**
 * Main class encapsulates the game, manages the overarching states
 * and hangles congigs
 */
class Main extends Game{
    private var state:States;
      // main_menu
      // game_session
      // game_options (not implemented)

    /**
     * the logic to run when the game starts, initializes
     * States and enters main menu
     */
    override function ready(){
        Luxe.renderer.clear_color.rgb(0x121219);

        state = new States( { name : "MAIN" } );
        state.add( new Menu() );
        state.add( new Selection() );
        state.add( new Pause() );
        state.add( new Options() );

        state.set( 'MAIN_MENU' );
    }

    /**
     * currently just manages the preloading of assets
     */
    override function config( config: luxe.AppConfig ) {

        config.preload.textures.push( { id:'assets/blue-grid-720.png' } );

        return config;
    }
}
