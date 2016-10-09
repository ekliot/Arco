package arco.views;


import arco.entities.SelectionCompassSprite;
import arco.states.Selection;

import luxe.Color;

import phoenix.geometry.LineGeometry;

import mint.focus.Focus;
import mint.layout.margins.Margins;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Canvas;
import mint.render.luxe.Button;
import mint.render.luxe.TextEdit;


/**
 * <TODO>
 */
class SelectionView {

        /* <TODO> */
    public var destroyed : Bool = false;

        // a shortcut to getting the middle of the screen
    private var MID : Vector = Luxe.screen.mid;
        /* <TODO> */
    private var COMPASS_RADIUS : Int = 50;
        /* <TODO> */
    private var SELECTION : Selection;

        // uses the AutoCanvas from mint's test_luxe example for
        // compatibility b/w luxe and mint
    private var canvas : AutoCanvas;
        // the margins for mint's rendering
    private var layout : Margins;
        // the focus for this canvas
    private var focus : Focus;
        // use mint's luxe renderer
    private var rendering : LuxeMintRender;

        // the input for the player's name
    private var input_name (get) : TextEdit;
        // an object holding the eight points of the class selection compass
    private var class_compass (get) : ClassCompass;


    /**
     * <TODO>
     */
    public function new( selection : Selection ) {

        this.SELECTION = selection;

        rendering = new LuxeMintRender();
        layout    = new Margins();

        var canv_opt : CanvasOptions = {
            name : "canvas.selection",
            rendering : rendering,
            x : 0, w : Luxe.screen.w,
            y : 0, h : Luxe.screen.h,
            mouse_input : true,
            key_input   : true
            // visible     : true,  // this broke it...
        }; // canv_opt = { ... }

            /**
             * <TODO> watch out for updates to luxe/mint, that may change how this works,
             * or if it is even needed
             */
        canvas = new AutoCanvas( canv_opt );
        canvas.auto_listen();

            //this is required to handle input focus in the default way
        focus = new Focus( canvas );

            // init name box
        make_nameInput();
            // init class selection
        make_compass();
            // init start game button
        make_buttons();
            // select defaults
        selectDefaults();

    } // new()

    public function destroy(): Void {

        trace( "SelectionView.destroy() :: starting" )

        input_name.destroy();
        input_name = null;

        class_compass.destroy();
        class_compass = null;

        focus.destroy();
        focus = null;
        canvas.destroy();
        canvas = null;
        layout.destroy();
        layout = null;
        rendering.destroy();
        rendering = null;

        destroyed = true;

        trace( "SelectionView.destroy() :: finished" )

    } // destroy()

    /**
     * <TODO>
     */
    private function make_nameInput(): Void {

        trace( "SelectionView.make_nameInput() :: starting" );

        /**
         * <TODO> make a label for this input
         * i.e. "Enter player name:"
         */

        var input_opt : mint.TextEditOptions = {

                // ControlOptions
            name : "input.text.selection.name",
            rendering : rendering,

                /* <TODO> figure out decent vals for all these following options */
            x : MID.x - 50, w : 100,
            y : MID.y - 100, h : 30,

                // TextEditOptions
            text : "Challenger"
            // align : left,
            // align_vertical : center,
            // text_size : size,

                // LuxeMintTextEditOptions
            // color : XXXX;
            // color_hover : XXXX;
            // color_cursor : XXXX;
            // cursor_blink_rate : XXXX;

        }; // input_opt = { ... }

        trace( "SelectionView.make_nameInput() :: using text edit options :> $input_opt" );

        var control : mint.TextEdit = new mint.TextEdit( input_opt );
        this.input_name = new TextEdit( rendering, control );

        trace( "SelectionView.make_nameInput() :: finished" );

    } // make_nameInput()

    /**
     * <TODO>
     */
    private function make_compass(): Void {

        this.class_compass = new ClassCompass( COMPASS_RADIUS );

    } // make_compass()

    /**
     * <TODO>
     */
    private function make_buttons(): Void {

        /* <TODO> */

    } // make_buttons


} // class SelectionView


/**
 * <TODO>
 */
private class ClassCompass {


        /* <TODO> */
    public var destroyed : Bool = false;

        /* <TODO> */
    private var MID : Vector = Luxe.screen.mid;

        /* <TODO> */
    private var COMPASS_RADIUS: Int;

        // the north-facing class -- BLADES
    private var north : SelectionCompassSprite;
        // the south-facing class -- BONES
    private var south : SelectionCompassSprite;
        // the east-facing class -- STARS
    private var east : SelectionCompassSprite;
        // the west-facing class -- STONES
    private var west : SelectionCompassSprite;
        // the northeast-facing class -- BLADES/STARS
    private var northeast : SelectionCompassSprite;
        // the northwest-facing class -- BLADES/STONES
    private var northwest : SelectionCompassSprite;
        // the southeast-facing class -- BONES/STARS
    private var southeast : SelectionCompassSprite;
        // the southeast-facing class -- BONES/STONES
    private var southwest : SelectionCompassSprite;
        // the north-south line
    private var line_v : LineGeometry;
        // the east-west line
    private var line_h : LineGeometry;

    public function new( radius : Int ): Void {

        this.COMPASS_RADIUS = radius;

        this.north = make_compassButton( "north" );
        this.south = make_compassButton( "south" );
        this.east  = make_compassButton( "east" );
        this.west  = make_compassButton( "west" );
        this.northeast = make_compassButton( "northeast" );
        this.northwest = make_compassButton( "northwest" );
        this.southeast = make_compassButton( "southeast" );
        this.southwest = make_compassButton( "southwest" );

        /* <TODO> make vertical line */
        // this.line_v = ;
        /* <TODO> make horizontal line */
        // this.line_h = ;

    } // new()

    /**
     * <TODO>
     */
    private function make_compassButton( dir : String ): SelectionCompassSprite {

        trace( "ClassCompass.make_compassButton( $dir ) :: starting" );

        var posx : Int;
        var posy : Int;

        switch ( dir ) {

            case "north":
                posx = MID.x + 0;
                posy = MID.y + COMPASS_RADIUS;
            case "south":
                posx = MID.x + 0;
                posy = MID.y - COMPASS_RADIUS;
            case "east":
                posx = MID.x + COMPASS_RADIUS;
                posy = MID.y + 0;
            case "west":
                posx = MID.x - COMPASS_RADIUS;
                posy = MID.y + 0;
            case "northeast":
                posx = MID.x + COMPASS_RADIUS/Math.sqrt(2);
                posy = MID.y - COMPASS_RADIUS/Math.sqrt(2);
            case "northwest":
                posx = MID.x - COMPASS_RADIUS/Math.sqrt(2);
                posy = MID.y - COMPASS_RADIUS/Math.sqrt(2);
            case "southeast":
                posx = MID.x + COMPASS_RADIUS/Math.sqrt(2);
                posy = MID.y + COMPASS_RADIUS/Math.sqrt(2);
            case "southwest":
                posx = MID.x - COMPASS_RADIUS/Math.sqrt(2);
                posy = MID.y + COMPASS_RADIUS/Math.sqrt(2);

        } // switch ( dir )

        trace( "ClassCompass.make_compassButton( $dir ) :: (x,y) :> ($posx,$posy)" );

        var sprite_opt = {

                // TransformProperties
            pos : new Vector( posx, posy ),

                // EntityOptions
            name : "sprite.selection.compass." + dir,

                /* <TODO> figure out the proper vector size */
                // VisualOptions
            size : new Vector( 128, 128 ),
                /* <TODO> set the texture to the class sprite, remove the color option */
            // texture : ,
            color : new Color().rgb( 0xf94b04 );

                // SpriteOptions
            centered : true

        }; // sprite_opt = { ... }

        trace( "ClassCompass.make_compassButton( $dir ) :: using sprite options :> $sprite_opt" );

        var sprite = new SelectionCompassSprite( SELECTION, sprite_opt );

        trace( "ClassCompass.make_compassButton( $dir ) :: finished" );

        return sprite;

    } // make_compassButton()

    /**
     * <TODO>
     */
    public function destroy(): Void {

        trace( "ClassCompass.destroy() :: starting" );

        this.north.destroy();
        this.south.destroy();
        this.east.destroy();
        this.west.destroy();
        this.northeast.destroy();
        this.northwest.destroy();
        this.southeast.destroy();
        this.southwest.destroy();
        this.line_v.destroy();
        this.line_h.destroy();

        this.destroyed = true;

        trace( "ClassCompass.destroy() :: starting" );

    }


} // class ClassCompass
