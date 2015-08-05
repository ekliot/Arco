import luxe.Input;
import luxe.States;
import luxe.Text;

import luxe.Sprite;
import luxe.Scene;

import luxe.Vector;
import luxe.Color;

class Splash extends State{
    private var _SCENE:Scene;

    public function new(){
        super( { name : "splash" } );
    }

    override function onleave<T>( t : T ){
        _SCENE.destroy();
    }

    override function onenter<T>( t : T ){
        this._SCENE = new Scene( "SPLASH" );

        _SCENE.add( new Sprite( { size : Luxe.screen.size,
                                  color : new Color( 1, 0, 0 ) } ) );

        _SCENE.add( new Text( { text: 'Press Enter to Continue',
                                align: center,
                                align_vertical: center,
                                pos: new Vector(Luxe.screen.mid.x, -171) } ) );
    }

    override function onkeyup( e:KeyEvent ){
        if( e.keycode == Key.escape ){
            Luxe.shutdown();
        }
        if( e.keycode == Key.enter ){
            machine.set( "playing_field" );
        }
    }
}
