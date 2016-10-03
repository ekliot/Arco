package arco.views;


import arco.states.Menu;

import luxe.Text;
import luxe.Vector;

import mint.focus.Focus;
import mint.layout.margins.Margins;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Canvas;
import mint.render.luxe.List;
import mint.render.luxe.Button;


class MenuView {


        // a shortcut to getting the middle of the screen
    private var MID : Vector = Luxe.screen.mid;
        // the Menu State that this view is attached to
    private var MENU : Menu;
        // the string to use for the main menu title
        /* <TODO> get the title text from a string container */
    private static var TITLE : String = "ARCO";

    private destroyed : Bool = false;

        // uses the AutoCanvas from mint's test_luxe example for
        // compatibility b/w luxe and mint
    private var canvas : AutoCanvas;
        // the margins for mint's rendering
    private var layout : Margins;
        // the focus for this canvas
    private var focus : Focus;
        // use mint's luxe renderer
    private var rendering : LuxeMintRender;

        // the title text on the main menu
    private var text_title : Text;
        // a mint List to hold all the menu items
    private var list_menu : List;


    /**
     * initializes the menu view
     */
    public function new( menu : Menu ) {

        this.MENU = menu;

        rendering = new LuxeMintRender();
        layout    = new Margins();

        var canv_opt : CanvasOptions = {
            name : "canvas.main_menu",
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

            // generate the title text
        make_title();
            // generate the actual menu, and its buttons
        make_menu();

    } // new()

    /**
     * <TODO>
     */
    public function destroy(): Void {

        menu.destroy();
        menu = null;
        text_title.destroy();
        text_title = null;

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
    private function make_title(): Void {

            /**
             * <TODO> we want these values to be more programmatic when we decide on a main menu arrangement
             * namely: pos, point_size
             */
        var text_opt : TextOptions = {
            name : "text.main_menu.title",
            pos : new Vector( mid.x, mid.y - 200 ),
            align : luxe.TextAlign.center,
            point_size : 72,
            text : TITLE
        } // text_opt = { ... }

        text_title = new Text( text_opt ); // text_title = new Text()

    } // make_title()

    /**
     *  initializes the menu and its buttons
     */
    private function make_menu(): Void {

        var list_opt = {
                /* <TODO> okay, these really need to not be hardcoded... */
                /* <TODO> divide these into option sections */
            parent : canvas,
            name   : "list.main_menu.menu",

            x : mid.x - 120, w : 240,
            y : mid.y - 42,  h : ( 48 + 24 ) * 4,

        } // list_opt = { ... }

        var list_control : mint.List = new mint.List( list_opt );
        list_menu = new List( rendering, list_control );

            /* <TODO> have these strings be pulled from a string container */
        var btn_names  : Array<String> = [ "button.main_menu.single", "button.main_menu.multi", "button.main_menu.chars", "button.main_menu.opt", "button.main_menu.exit" ];
        var btn_labels : Array<String> = [           "Single Player",            "Multiplayer",             "Characters",              "Options",                  "Exit" ];

        var btn_opt : ButtonOptions;
        var btn_control : mint.Button;
        var y_offset : Int;

        for( i in 0 ... 5 ){

                // compose the options
            btn_opt = {

                /* <TODO> divide these into option sections */
                /* <TODO> double check these are valid, and nothing is missing */

                parent : list_menu,
                name   : btn_names[i],
                text   : btn_labels[i],

                text_size : 36,
                align : 3, // TextAlign.center,

                w : 240,
                h : 48,

                onclick : function( e, c ){

                    var idx : Int = btn_names[i].lastIndexOf( "." );
                    MENU.handle_menuButton( btn_names[i].substr( idx + 1 ) );

                } // btn_opt.onclick

            } // btn_opt = { ... }

            btn_control = new mint.Button( btn_opt );

              // this helps add a little extra spacing between list elements
              /* <TODO> replace 24 with something more programmatic */
            y_offset = ( i == 0 ) ? 0 : 24;

                // add the button to the menu
            list_menu.add_item( new Button( rendering, btn_control ), 0, y_offset );

        } // for( i in 0 ... 5 )

    } // make_menu()


} // class MenuView
