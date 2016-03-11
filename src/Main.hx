/** Copyright (c) 2015 Elijah Kliot*/

import luxe.Game;
import luxe.States;
import luxe.Scene;
import luxe.Color;
import luxe.Text;
import luxe.options.TextOptions;

import luxe.Input;

import luxe.Parcel;
import luxe.ParcelProgress;

// show a scene of the board
// bottom is player's side, top is CPU
// each player's side is divided into two, with active cards in middle half, and everything else in other half
// active cards has a Sprite representing each active card
// everything else has:
//      a number in a square Sprite for how many cards are in the deck
//      a number in a triangle for how many cards are in the discard pile
//      a number in a red circle for health
//      a number in a blue circle for power level
//      an area with Sprites for all of the cards in hand (Sprites go from left to right, same order as Array they are stored in)
//      a Sprite for the last-played card

// Card Sprite:
//      this is a rectangle with the ASCII suit and a number (rank) afterwards

// at the beginning of each round when a move is prompted, a player has a choice to click on "play" "discard" or "pass"
//      "play" lets a player click on a card in hand to play. only valid cards can be clicked
//      "discard" lets a player click which cards to discard, and then click on a discard button to validate the cards. if invalid, the selections are reset
//      "pass" will pass the move, but will only show if it is valid
//          after selecting "play" and "discard" there is a "back" button, which returns to the move selection


class Main extends Game{
    private var _SPLASH:State;
    private var _session:Board; // extends State

    private var state:States;

    private var _player1:Player;
    private var _player2:Player;


    override function ready(){
        state = new States( { name : "GameState" } );
        state.add( new Menu() );
        state.add( new Session() );
        state.add( new Options() );

        initGame();

        state.set( 'main_menu' );
    }

    public function initGame():Void{
        // make p1
        // make p1's deck
        var d1:Array< Card > = new Array< Card >();
        trace( "First player's name: ");
        // var p1:String = Sys.stdin().readLine();
        var p1:String = "YOU";
        this._player1 = initPlayer( p1, d1, false );

        // make p2
        // make p2's deck
        var d2:Array< Card > = new Array< Card >();
        trace( "Second player's name: ");
        // var p2:String = Sys.stdin().readLine();
        var p2:String = "CPU";
        this._player2 = initPlayer( p2, d2, true );

        this._session = new Board();

        _player1.joinGame( _session );
        _player2.joinGame( _session );

        state.add( this._session );
    }

    private static function initPlayer( name : String, deck : Array< Card >, cpu : Bool ):Player{
        var newP:Player = new Player( name, deck, cpu );

        trace( "Player " + name + " initialized" );
        trace( newP );

        return newP;
    }

}
