class Field{
    private var _players:Map< String, Player >;
    private var _pFields:Map< String, Array< Card > >;

    private var _TURN:Int = 1;
    private var _ROUND:Int = 1;

    private var _turnOrder:Array< String >;
    private var _curPlayer:String;

    private static var STARTINGHANDSIZE:Int = 6;

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

        this._curPlayer = _turnOrder[ 0 ];

        this.playTurn();
    }

    private function initPlayer( name : String, deck : Array< Card > ):Player{
        var newP:Player = new Player( name, this, deck );
        this._players.set( name, newP );
        this._pFields.set( name, new Array< Card >() );
        return newP;
    }


    private function clearBoard( ?name = "" ):Void{
        if( name.length == 0 ){
            // for every player...
            for( b in this._turnOrder ){
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
            for( c in this._pFields.get( name ) ){
                this._players.get( name ).pushDiscard( c );
            }
            this._pFields.set( name, new Array< Card >() );
        }
    }

    private function playTurn():Void{
        for( p in _turnOrder ){
            var player:Player = this._players.get( p );
            player.newTurn();
            player.draw( this.STARTINGHANDSIZE );
        }

        // a recursive call to play rounds until both players are out of cards
        this.playRound();

        for( p in this._turnOrder ){
            if( isKill( p ) ){

            }
        }

        this.clearBoard();

        this.nextTurn();
    }

    // mark player as current player, trigger his active cards' round effects,
    // player makes move, onto next player. then start next round
    private function playRound():Void{
        if( this._turnOrder.length != 0 ){
            var newOrder:Array< String > = new Array< String >();

            for( p in this._turnOrder ){
                this._curPlayer = p;
                var player:Player = this._players.get( p );
                player.draw( 1 );

                for( c in this._pFields.get( p ) ){
                    this.activateCard( c, Triggers.onRound );
                }

                player.makeMove();

                if( player.getHand().length > 0 ){
                    newOrder.push( player.getName() );
                }
            }

            this._turnOrder = newOrder;

            this.nextRound;
        }
    }

    private function nextRound():Void{
        this._ROUND++;
        this.playRound();
    }

    // restarts the round counter, increments the turn counter, rerolls
    // the turn order, then starts the turn
    private function nextTurn():Void{
        this._TURN++;
        this._ROUND = 1;

        var names:Iterator< String > = this._players.keys();

        var p1:String = names.next();
        var p2:String = names.next();

        if( Random.bool() ){
            this._turnOrder = [ p1, p2 ];
        }
        else{
            this._turnOrder = [ p2, p1 ];
        }

        this._curPlayer = _turnOrder[ 0 ];

        this.playTurn();
    }

    // returns Bool for whether the target player is killed
    // functions calling this should check this Bool if they have an additional effect on-kill
    private function dealDamage( targ : String, amt : Int ):Bool{
        var target:Player = this._players.get( targ );
        target.chHealth( amt );
        if( target.getHealth() < 1 ){
            target.kill();
        }
        return false;
    }

    public function playCard( pl : String, subj : Card ):Void{
        // place the card in the player's field, and activate its onPlay trigger
        this._pFields.get( pl ).push( subj );
        this.activateCard( subj, Triggers.onPlay );
    }

    private function activateCard( subj : Card, trig : EnumValue, ?target = "" ):Void{
        subj.activate( trig, this._players, target );
    }

    // called to check if a player is dead, returns whether the death is true
    private function isKill( targ : String ):Bool{
        return this._players.get( targ ).getDead();
    }

    private function isWinner():String{
        // for( cond in winConditions ){
        //     for( p in _turnOrder ){
        //         if( cond( p ) ){
        //             return p;
        //         }
        //     }
        // }
        return "";
    }

    private function gameOver( ?winner = "" ):String{
        if( winner.length = 0 ){
            return "The game ends in a tie";
        }

        else{
            return "The winner is " + winner + "!";
        }
    }

    //TODO
    public function toString():String{

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
