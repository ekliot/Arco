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


        // a shortcut to getting the middle of the screen
    private var MID : Vector = Luxe.screen.mid;
        //
    private var COMPASS_RADIUS : Int = 50;
        //
    private var SELECTION : Selection;

    public var destroyed : Bool = false;

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
    private var input_name : TextEdit;
        // an object holding the eight points of the class selection compass
    private var class_compass : ClassCompass;


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

        input_name.destroy();
        input_name = null;

        class_compass.north.destroy();
        class_compass.south.destroy();
        class_compass.east.destroy();
        class_compass.west.destroy();
        class_compass.northeast.destroy();
        class_compass.northwest.destroy();
        class_compass.southeast.destroy();
        class_compass.southwest.destroy();
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

    } // destroy()

    /**
     * <TODO>
     */
    private function make_nameInput(): Void {

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
            // color : PINK;
            // color_hover : PINK;
            // color_cursor : PURPLE;
            // cursor_blink_rate : PINK;

        }; // input_opt = { ... }

        var control : mint.TextEdit = new mint.TextEdit( input_opt );
        this.input_name = new TextEdit( rendering, control );

    } // make_nameInput()

    /**
     * <TODO>
     */
    private function make_compass(): Void {

        var comp : ClassCompass = {

                // the north-facing class -- BLADES
            north : make_compassButton( "north" ),
                // the south-facing class -- BONES
            south : make_compassButton( "south" ),
                // the east-facing class -- STARS
            east : make_compassButton( "east" ),
                // the west-facing class -- STONES
            west : make_compassButton( "west" ),
                // the northeast-facing class -- BLADES/STARS
            northeast : make_compassButton( "northeast" )
                // the northwest-facing class -- BLADES/STONES
            northwest : make_compassButton( "northwest" ),
                // the southeast-facing class -- BONES/STARS
            southeast : make_compassButton( "southeast" ),
                // the southeast-facing class -- BONES/STONES
            southwest : make_compassButton( "southwest" ),

            /* <TODO> make vertical line */
            // line_v : ,
            /* <TODO> make horizontal line */
            // line_h :

        }; // comp = { ... }

        this.class_compass = comp;

    } // make_compass()

    /**
     * <TODO>
     */
    private function make_compassButton( dir : String ): SelectionCompassSprite {

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

        var sprite_opt = {

                // TransformProperties
            pos : new Vector( posx, posy ),

                // EntityOptions
            name : "sprite.selection.compass." + dir,

                // VisualOptions
            size : new Vector( 128, 128 ),
                /* <TODO> set the texture to the class sprite, remove the color option */
            // texture : ,
            color : new Color().rgb( 0xf94b04 );

                // SpriteOptions
            centered : true

        }; // sprite_opt = { ... }

        var sprite = new SelectionCompassSprite( SELECTION, sprite_opt );

        return sprite;

    } // make_compassButton()

    /**
     * <TODO>
     */
    private function make_buttons(): Void {

        /* <TODO> */

    } // make_buttons

    /**
     * <TODO>
     */
    private function selectDefaults(): Void {

        /* <TODO> */

    } // selectDefaults


} // class SelectionView


/**
 * <TODO>
 */
typedef ClassCompass = {

        // the north-facing class -- BLADES
    var north : SelectionCompassSprite;
        // the south-facing class -- BONES
    var south : SelectionCompassSprite;
        // the east-facing class -- STARS
    var east : SelectionCompassSprite;
        // the west-facing class -- STONES
    var west : SelectionCompassSprite;
        // the northeast-facing class -- BLADES/STARS
    var northeast : SelectionCompassSprite;
        // the northwest-facing class -- BLADES/STONES
    var northwest : SelectionCompassSprite;
        // the southeast-facing class -- BONES/STARS
    var southeast : SelectionCompassSprite;
        // the southeast-facing class -- BONES/STONES
    var southwest : SelectionCompassSprite;

    var line_v : LineGeometry;
    var line_h : LineGeometry;

} // ClassCompass
