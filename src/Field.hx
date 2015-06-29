import Suits;
import Triggers;
import Actions;

class Field{
    private var _players:Map< String, Player > = new Map< String, Player >();
    private var _pFields:Map< String, Array< Card > > = new Map< String, Array< Card > >();

    private var _TURN:Int = 1;
    private var _ROUND:Int = 1;

    private var _turnOrder:Array< String >;
    private var _curPlayer:String = "";

    private var STARTINGHANDSIZE:Int = 6;

    public function new( p1 : String, d1 : Array< Card >,
                         p2 : String, d2 : Array< Card > ){
        initPlayer( p1, d1 );
        initPlayer( p2, d2 );

        if( Random.bool() ){
            _turnOrder = [ p1, p2 ];
        }
        else{
            _turnOrder = [ p2, p1 ];
        }

        trace( "Turn order: " + _turnOrder.toString() );

        this._curPlayer = _turnOrder[ 0 ];

        // Play the first and any subsequent turns:
        this.playTurn();

        // Field instance then voids itself
        this.terminate();
    }

    private function initPlayer( name : String, deck : Array< Card > ):Player{
        var newP:Player = new Player( name, this, deck );
        this._players.set( name, newP );
        this._pFields.set( name, new Array< Card >() );

        trace( "Player " + name + " initialized" );
        return newP;
    }


    private function clearBoard( ?name = "" ):Void{
        if( !this._players.exists( name ) ){
            trace( "Clearing all boards!" );

            // for every player...
            for( b in this._players.keys() ){
                trace( "Clearing " + b + "'s field...");
                // for every card on their board...
                for( c in this._pFields.get( b ) ){
                    // push it to their discard pile...
                    this._players.get( b ).pushDiscard( c );
                }

                // then replace their board with a fresh one
                this._pFields.set( b, new Array< Card >() );
            }
        }
        else{
            trace( "Clearing " + name + "'s field...");
            for( c in this._pFields.get( name ) ){
                this._players.get( name ).pushDiscard( c );
            }
            this._pFields.set( name, new Array< Card >() );
        }
    }

    private function playTurn():Void{
        trace( "Turn " + _TURN + " starting...");
        // "I'M GOING TO READ OF THIS LIST OF NAMES"
        for( p in _turnOrder ){
            trace( "Notifying " + p + " of new turn...");
            // "EACH OF YOU MAGGOTS IS GOING TO WAKE THE FUCK UP WHEN YOUR NAME IS CALLED"
            var player:Player = this._players.get( p );
            player.newTurn( this.STARTINGHANDSIZE );
        }

        trace( "ROUND 1 START");
        // a call to play rounds until both players are out of cards
        this.playRounds();

        // rounds exhausted, turn ending...
        trace( "Checking for survivors...");
        for( p in this._players.keys() ){
            // "ARE YOU DEAD, MOTHERFUCKER? SPEAK UP, I CAN'T HEAR YOU BEG FOR MERCY"
            if( isKill( p ) ){
                // "SORRY, DID I JUST CRUSH YOU WITH MY TOE? MY BAD, BITCH."
                this._turnOrder.remove( p );
                trace( p + " has been eliminated...");
            }
            else{
                trace( p + " survives..." );
            }
        }

        // "THE FUCK IS ALL THIS GARBAGE LAYING AROUND HERE? SOMEONE GET THIS SHIT OUTTA HERE!"
        this.clearBoard();

        trace( "Turn " + _TURN + " is over, beginning transition to next turn..." );
        // "Okay, let's clean this shit up so we can figure out if someone's gotta die. THAT'S A FUCKING ORDER!"
        this.nextTurn();

        // "We done here? Jesus, my throat is killing me, let's go."
    }

    // mark player as current player, trigger his active cards' round effects,
    // player makes move, onto next player. then start next round
    private function playRounds():Void{
        // "Let's see who showed up..."
        var subjects:Array< String > = this._turnOrder;

        // [drill sergeant]"Now, so long as there is at least one of you, I will put you through this exercise until there are none of you by the start of the next exercise:"
        while( subjects.length != 0 ){

            trace( "Turn " + _TURN + ", Round " + _ROUND + " participants: " + subjects.toString() );

            // "These are the people that pass"
            var newOrder:Array< String > = new Array< String >();

            // "Now, I will read of this list of names. When your name is called, perform this drill:"
            for( p in subjects ){
                // "YOUR NAME HAS BEEN CALLED, NOW LISTEN UP:"
                this._curPlayer = p;
                trace( _curPlayer + " is beginning their round..." );

                // "YEAH, YOU, GET OVER HERE!"
                var player:Player = this._players.get( p );

                // "I WANT TO SEE YOU DRAW A GODDAMNED CARD!"
                var dr:Card = player.draw( 1 )[ 0 ];
                if( dr != null ){
                    trace( _curPlayer + " has drawn " + dr.toString() );
                }

                trace( "Activating " + _curPlayer + "'s cards in play..." );
                // "LOOK AT THIS PILE OF YOUR SHITY CARDS. [WATCH ME] ACTIVATE EACH CARD WITH A ROUND WAKEUP CALL"
                for( c in this._pFields.get( p ) ){
                    trace( "Activating " + c.toString() );
                    // "IT'S A NEW ROUND YOU FILTHY EXCUSE FOR AN ACCIDENT OF NATURE, WHAT DO YOU HAVE TO SAY FOR YOURSELF I WANT TO HEAR IT!"
                    this.activateCard( c, onRound );
                }

                trace( "Waiting for move..." );
                // "NOW WHAT DO YOU HAVE TO SAY FOR YOURSELF, PRIVATE? GIMME ALL YOU GOT"
                player.makeMove();

                trace( "Checking if hand is empty...");
                // "GIMME YOUR HAND, I WANT TO SEE IF IT'S LONGER THAN YOUR COCK."
                if( player.getHand().length > 0 ){
                    trace( _curPlayer + " passes to the next round");
                    // "IMPRESSIVE, YOUR HAND ISN'T NONEXISTANT! YOU PASS THE EXCERCISE, FAGGOT!"
                    newOrder.push( _curPlayer );
                }
                else{
                    trace( "Empty hand, do not pass GO, do not collect 200 dollars" );
                }
            }

            trace( "Players moving on: " + newOrder.toString() );
            // "NOW, ALL YOU DUMBASS GOODFORNOTHING EXCUSES FOR CUMSTAINS, GET THE FUCK OUT OF HERE."
            subjects = newOrder;

            trace( "Round over, beginning next round...");
            //"Hmm, okay, let's see if some of you are still left. Now, let's see you try that again..."
            this.nextRound;
        }

        trace( "Turn order exhausted, ending at Round " + _ROUND + "..." );
    }

    private function nextRound():Void{
        this._ROUND++;
        trace( "Turn " + _TURN + ", Round " + _ROUND );
    }

    // restarts the round counter, increments the turn counter, rerolls
    // the turn order, then starts the turn
    private function nextTurn():Void{
        // if only one person is left, the game ends

        // "Oh, you're the last one? Well congratu-fucking-lations, you're the winner!"
        if( this._turnOrder.length == 1 ){
            trace( "Only one player left..." );
            // "IT'S A FUCKING WRAP GUYS, LET'S GO BACK HOME FROM THIS BULLSHIT."
            trace( gameOver( this._turnOrder[ 0 ] ) );
        }

        // "Oh, it... It's not over yet. Fine - NEXT TURN, COMING RIGHT UP!"
        else{
            var p1:Player = this._players.get( this._turnOrder[ 0 ] );
            var p2:Player = this._players.get( this._turnOrder[ 1 ] );

            // "You assholes have no cards left? GET THE FUCK OUT OF MY SIGHT!"
            if( p1.isDeckEmpty() && p1.getHand().length == 0 &&
                p2.isDeckEmpty() && p2.getHand().length == 0 ){
                    trace( gameOver() );
                }

            else{
                // "NEXT ROUND COMING UP"
                this._TURN++;
                this._ROUND = 1;

                trace( "Preparing: Turn " + _TURN + ", Round " + _ROUND );

                // "LET'S SEE WHO'S ON THE CHOPPING BLOCK:"
                var names:Iterator< String > = this._players.keys();

                // "WE'VE GOT TWO SHITSTAINS! THAT'LL HAVE TOO DO."
                var p1:String = names.next();
                var p2:String = names.next();

                // "NOW WHOEVER CAN GUESS HOW MANY SECONDS BETWEEN THE TIME I FINISH THIS SENTENCE AND WHEN I'M WIPING YOU OFF MY BOOT GETS IT FIRST!"
                if( Random.bool() ){
                    this._turnOrder = [ p1, p2 ];
                }
                else{
                    this._turnOrder = [ p2, p1 ];
                }

                trace( "Turn order: " + _turnOrder.toString() );

                // "YOU'RE THE FIRST ONE, EH?"
                this._curPlayer = _turnOrder[ 0 ];

                // "LET'S GET THIS SHIT STARTED!"
                this.playTurn();
            }
        }
    }

    // functions calling this should check this for whether the target player is killed if they have an additional effect on-kill
    private function dealDamage( targ : String, amt : Int ):Void{
        trace( targ + " is being dealt " + amt + " damage...");
        var target:Player = this._players.get( targ );
        target.processEvent( Damage( amt ) );
    }

    public function playCard( pl : String, subj : Card ):Void{
        // place the card in the player's field, and activate its onPlay trigger

        trace( pl + " is playing: " + subj.toString() );
        // "GIMME THAT CARD, I'MMA SHOVE IT IN THAT PILE"
        this._pFields.get( pl ).push( subj );

        // "YOU GOT SOMETHING TO SAY FOR YOURSE-- Oh, you're white? Carry on then, do what you want and bugger off"
        this.activateCard( subj, onPlay );
    }

    public function activateCard( subj : Card, trig : EnumValue, ?target = "" ):Void{
        trace( "Activating " + subj + " with " + trig + "trigger..." );

        var eve:EnumValue = subj.activate( trig, target );

        trace( "Event occurred: " + eve );

        if( !this._players.exists( target ) ){
            var pl:String = subj.getPlayer();
            var opp:String = decideOpp( pl );
            switch( eve ){
                case Damage( amount ): this._players.get( opp ).processEvent( eve );
                case Heal( amount ): this._players.get( pl ).processEvent( eve );
                case Discard( amount ): this._players.get( opp ).processEvent( eve );
                case Draw( amount ): this._players.get( pl ).processEvent( eve );
                default: trace( "Nothing happens" );
            }
        }

        else{
            this._players.get( target ).processEvent( eve );
        }
    }

    // given a map of the players in this card's game and this card's player, what is this card's player's opponent's name?
    public function decideOpp( pl : String ):String{
        var players:Iterator< String > = this._players.keys();
        var p1:String = players.next();
        var p2:String = players.next();
        if( p1 == pl ){
            return p2;
        }
        return p1;
    }

    // called to check if a player is dead, returns whether the death is true
    private function isKill( targ : String ):Bool{
        var ret:Bool = this._players.get( targ ).getDead();
        trace( "Is " + targ + " dead: " + ret );
        return ret;
    }

    // private function isWinner():String{
    //     for( cond in winConditions ){
    //         for( p in _turnOrder ){
    //             if( cond( p ) ){
    //                 return p;
    //             }
    //         }
    //     }
    // }

    private function gameOver( ?winner = "" ):String{
        if( winner.length == 0 ){
            return "The game ends in a tie";
        }

        else{
            return "The winner is " + winner + "!";
        }
    }

    public function terminate():Void{
        // SHUT EVERYTHING DOWN
    }

    //TODO
    public function toString():String{
        return "";
    }

    public function getRound():Int{
        return this._ROUND;
    }

    public function getTurn():Int{
        return this._TURN;
    }

    public function getPlayer( name : String ):Player{
        return this._players.get( name );
    }

    public function getActiveCards( name : String ):Array< Card >{
        return this._pFields.get( name );
    }
}
