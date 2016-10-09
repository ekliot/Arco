package arco.entities;


import arco.states.Selection;

import luxe.Sprite;
import luxe.options.SpriteOptions;
import luxe.Input;


/**
 * <TODO>
 */
class SelectionCompassSprite extends Sprite {


        // the selection state instance this is bound to
    private var SELECTION : Selection;

    public var selected (get) : Bool;

    /**
     * <TODO>
     */
    function new( sel : Selection, options : SpriteOptions ) {

        super( options );
        this.SELECTION = sel;

    } // new()

    /**
     * <TODO>
     */
    public function select(): Void {

        selected = true;

        trace( "SelectionCompassSprite :: selected compass sprite $this.name" );

        /* <TODO> do selection visuals */

    } // select()

    /**
     * <TODO>
     */
    public function deselect(): Void {

        selected = false;

        trace( "SelectionCompassSprite :: deselected compass sprite $this.name" );

        /* <TODO> undo selection visuals */

    } // deselect()

    /**
     * <TODO>
     */
    override function onmouseup( e : MouseEvent ) {

        if( point_inside_AABB( e.pos ) ){
            sel.select_class( this.name );
        } // if event inside this

    } // onmouseup()


} // class SelectionCompassSprite
