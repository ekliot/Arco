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

class Menu extends State{

    private var mid : Vector = Luxe.screen.mid;

    private var _canvas_ : AutoCanvas;
    private var _layout_ : Margins;
    private var  _focus_ : Focus;

    private var _rendering_ : LuxeMintRender;

    private var text_title : Text;

    public function new(){
        super( { name : "main_menu" } );
    }

    override function onenter<T>( t : T ){
        _rendering_ = new LuxeMintRender();
        _layout_ = new Margins();

        var canv_opt:CanvasOptions = {
            name : "main_menu",
            rendering : _rendering_,
            x : 0,         y : 0,
            w : Luxe.screen.w, h : Luxe.screen.h,
            // visible     : true,
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

    private function make_buttons():Void{

        var _menu = new List( {
            parent : _canvas_,
            name   : 'main_menu_list',
            x : mid.x - 120,  y : mid.y-42,
            w : 240, h : (48+24)*4 } );

        var bttn_names  = [ 'bttn_sngl', 'bttn_mult', 'bttn_opt', 'bttn_exit' ];
        var bttn_labels = [ 'Single Player', 'Multiplayer', 'Options', 'Exit' ];

        for( i in 0 ... 4){
            var bttn_opt:ButtonOptions = {
                parent : _menu,
                name : bttn_names[i],
                text : bttn_labels[i],
                text_size : 36,
                align : 3, // TextAlign.center,
                w : 240,        h : 48,
                onclick : function(e,c) { button_handle( i ); }
            }

            _menu.add_item( new Button( bttn_opt ), 0, (i == 0) ? 0 : 24 );
        }

    }

    private function button_handle( id : Int ):Void{
        switch ( id ) {
            case 0:
                // initGame( /* false */ );
                trace( "BEEPBOOP SINGLEPLAYER" );
            case 1:
                // initGame( /* true */ );
                trace( "BEEPBOOP MULTIPLAYER" );
            case 2:
                trace( "BEEPBOOP OPTIONS" );
            case 3:
                Luxe.shutdown();
        }

    }

    // public function initGame( /* gametype : Bool */ ):Void{
    //
    //     /*
    //       trace( "First player's name: ");
    //       var p1:String = Sys.stdin().readLine();
    //
    //       PROMPT FOR PLAYER NAME
    //      */
    //
    //     var p1:String = "YOU";
    //
    //       // make p1's deck
    //     var d1:Array< Card > = new Array< Card >();
    //
    //       // make p1
    //     var player1:Player = initPlayer( p1, d1, false );
    //
    //     /*
    //         if multiplayer, PROMPT FOR
    //         trace( "Second player's name: ");
    //      */
    //       // var p2:String = Sys.stdin().readLine();
    //     var p2:String = "CPU";
    //
    //       // make p2's deck
    //     var d2:Array< Card > = new Array< Card >();
    //
    //       // make p2
    //     var player2:Player = initPlayer( p2, d2, true );
    //
    //     var session:Session = this.machine._states.get( 'game_session' );
    //
    //     player1.joinGame( session );
    //     player2.joinGame( session );
    //
    //     this.machine.set( 'game_session' );
    // }
    //
    // private static function initPlayer( name : String, deck : Array< Card >, cpu : Bool ):Player{
    //     var newP:Player = new Player( name, deck, cpu );
    //
    //     trace( "Player " + name + " initialized" );
    //     trace( newP );
    //
    //     return newP;
    // }

    override function onleave<T>( t : T ){
        // _scene_.destroy();
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
