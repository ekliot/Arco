package arco.states;


import arco.beings.Adversary;

import luxe.States;


/**
 * <TODO>
 */
class Selection extends State {


        // the associated view for the selection state
    private var view : SelectionView;
        // the selections that the user makes before starting a game
    private var selections : AdversaryOptions;

    /**
     * <TODO>
     */
    public function new() {

        super( { name : "state.selection" } );

    } // new()

    override function onenter<T>( t : T ){

        view = new SelectionView( this );

    } // onenter()

    public function select_name( name : String ): Void {

        selections.name = name;

    } // select_name()

    /**
     * <TODO>
     */
    public function select_class( class : String ): Void {

        selections.class = class;

    } // select_class()

    /**
     * <TODO>
     */
    public function select_ability( ability : String, slot : Int ): Void {

        switch slot {
            case 1:
                selections.ability1 = ability;
            case 2:
                selections.ability2 = ability;
            case 3:
                selections.ability3 = ability;
        } // switch slot

    } // select_ability()


    /**
     * when leaving this state, cleanup all the menu elements
     */
    override function onleave<T>( t : T ) {

        view.destroy()
        view = null;

    } // onleave()

    /**
     * initializes a new Adversary
     *
     * @param :: AdversaryOptions :: opt :: the Options to use for the new Player
     *
     * @return :: Adversary :: the newly created Adversary
     */
    private static function init_adversary( opt : AdversaryOptions ): Adversary {

        trace( "Selection :: Initializing Adversary using options:" );
        trace( opt.toString() );

        var newAdv:Adversary = new Adversary( opt );

        if( newAdv != null ) {

            trace( "Selection :: Adversary " + opt.name + " initialized:" );
            trace( newAdv.toString() );

        } else {

            trace( "Selection :: Adversary initialization failed" );

        } // if newAdv

        return newAdv;

    } // initAdversary()

    /**
     * key input handling
     */
    override function onkeyup( e : KeyEvent ) {

        trace( "Selection :: User pressed " + e.keycode );

        if ( e.keycode == Key.escape ) {

            machine.set( "state.main_menu" );

        } // if key == esc

    } // onkeyup()


} // class Selection
