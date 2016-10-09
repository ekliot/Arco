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

        select_defaults();

    } // onenter()

    public function select_name( name : String ): Void {

        selections.name = name;

        trace( "Selection :: selected name :> $name" );

    } // select_name()

    /**
     * <TODO>
     */
    /* <TODO> eventually this will take an Archetype instead of a String */
    public function select_class( class : String ): Void {

        selections.class = class;

        trace( "Selection :: selected class :> $class" );

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

        trace( "Selection :: selected ability :> $ability in slot :> $slot" );

    } // select_ability()

    /**
    * <TODO>
    */
    private function select_defaults(): Void {

        trace( "Selection :: selecting defaults" );

        /* <TODO> */
        select_name( view.input_name.textedit.text );
        // select_class( RANDOM DIRECTION OF COMPASS );
        // select_ability( first T1 ability of selections.class );
        // select_ability( first T2 ability of selections.class );
        // select_ability( first T3 ability of selections.class );

    } // select_defaults

    /**
     * when leaving this state, cleanup
     */
    override function onleave<T>( t : T ) {

        view.destroy()
        view = null;

        selections = null;

    } // onleave()

    /**
     * initializes a new Adversary
     *
     * @param :: AdversaryOptions :: opt :: the Options to use for the new Player
     *
     * @return :: Adversary :: the newly created Adversary
     */
    private static function init_adversary( opt : AdversaryOptions ): Adversary {

        trace( "Selection :: initializing adversary using options :> $opt" );

        var newAdv:Adversary = new Adversary( opt );

        if( newAdv != null ) {

            trace( "Selection :: adversary '$opt.name' initialization succeeded" );
            trace( newAdv.toString() );

        } else {

            trace( "Selection :: adversary '$opt.name' initialization failed" );

        } // if newAdv

        return newAdv;

    } // initAdversary()

    /**
     * key input handling
     */
    override function onkeyup( e : KeyEvent ) {

        trace( "Selection :: user pressed $e.keycode" );

        if ( e.keycode == Key.escape ) {

            machine.set( "state.main_menu" );

        } // if key == esc

        /* <TODO> implement keyboard controls here */

    } // onkeyup()


} // class Selection
