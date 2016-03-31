/** Copyright (c) 2015 Elijah Kliot*/

import gamestates.Menu;
import gamestates.Session;
// import gamestates.Options;

import luxe.Game;
import luxe.States;
import luxe.Color;

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
    private var state:States;

    override function ready(){
        Luxe.renderer.clear_color.rgb(0x121219);

        state = new States( { name : "MAIN" } );
        state.add( new Menu() );
        state.add( new Session() );
        // state.add( new Options() );

        state.set( 'main_menu' );
    }

    override function config(config:luxe.AppConfig) {

        config.preload.textures.push({ id:'assets/blue-grid-720.png' });

        return config;

    }
}
