import luxe.Input;
import luxe.States;
import luxe.Text;

import luxe.Sprite;
import luxe.Scene;

import luxe.Vector;
import luxe.Color;

import mint.Button;

class Menu extends State{
    private var _SCENE:Scene;

    public function new(){
        super( { name : "main_menu" } );
    }

    public function initGame( /* gametype : Bool */ ):Void{

        /*
          trace( "First player's name: ");
          var p1:String = Sys.stdin().readLine();

          PROMPT FOR PLAYER NAME
         */
        var p1:String = "YOU";

          // make p1's deck
        var d1:Array< Card > = new Array< Card >();

          // make p1
        var _player1:Player = initPlayer( p1, d1, false );

        /*
            if multiplayer, PROMPT FOR
            trace( "Second player's name: ");
         */
          // var p2:String = Sys.stdin().readLine();
        var p2:String = "CPU";

          // make p2's deck
        var d2:Array< Card > = new Array< Card >();

          // make p2
        var _player2:Player = initPlayer( p2, d2, true );

        var _session:Session = new Session();

        _player1.joinGame( _session );
        _player2.joinGame( _session );

        state.add( this._session );
    }

    override function onleave<T>( t : T ){
        _SCENE.destroy();
    }

    override function onenter<T>( t : T ){
        this._SCENE = new Scene( "MENU" );

        _SCENE.add( new Sprite( { size : Luxe.screen.size,
                                  color : new Color( 1, 0, 0 ),
                                  pos: new Vector(Luxe.screen.mid.x, Luxe.screen.mid.y) } ) );
/*
          // Single-Player
        _SCENE.add( new Sprite( { text: 'Single-Player',
                                  size:
                                  pos:
                                }) );
          // Multi-Player
        _SCENE.add( new Sprite( { text: 'Multiplayer',
                                  size:
                                  pos:
                                }) );
          // Options
        _SCENE.add( new Sprite( { text: 'Options',
                                  size:
                                  pos:
                                }) );
          // Exit
        _SCENE.add( new Sprite( { text: 'Exit',
                                  size:
                                  pos:
                                }) );

*/
        _SCENE.add( new Text( { text: 'Press Enter to Continue',
                                align: center,
                                align_vertical: center,
                                pos: new Vector(Luxe.screen.mid.x, Luxe.screen.mid.y) } ) );
    }

    override function onkeyup( e:KeyEvent ){
        if( e.keycode == Key.escape ){
            /* CONFIRM EXIT? */
            Luxe.shutdown();
        }
        if( e.keycode == Key.enter ){
            machine.set( "playing_field" );
        }
    }
}
