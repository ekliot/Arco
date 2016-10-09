start with a main menu State, transition to a Session State (fomerly Board)
Session has a Board object, with two Player objects
Session State takes care of laying out the visual elements, by listening to the Board for changes in state

How? The Board listens for Events from Players. The Board validates these Events, and then upon validation will tell the Session what changes ought to be made to the visuals by putting the Event into a queue within the Session. The Session will make these changes and send an Event that a change was made

**MVC**

| Model | View | Controller |
| :
| BoardModel | BoardView | Adversary |
| DeckModel  | DeckView  |   Board   |

user selects GameType from Menu, which initializes a SelectionState. the user chooses a name, a class, and abilities in the SelectionState. on confirmation, this information is passed to a PlayState, which is switched to. another user in a PlayState for that GameType is found. between the two a Room is made, and each one's Adversary joins the Room. enable the RoomView (hit the lights!), which will initialize a Board with Rules, BoardModel, and BoardView.

    bool Adversary.sendMove( move ){
      return self.room.parseMove( move )
    }

    bool Room.parseMove( move ){
      //
    }

    throw Adversary.joinRoom( room ){
      if room.join( self ) ? self.room = room : throw
    }

    bool Room.join( adversary ){
      full ? return false : self.addAdversary( adversary )
      return true
    }

    Room.addAdversary( adversary ){
      self.adversaries[adversary.name] = adversary
      self.Board.addAdversary( adversary )
    }

    Board.addAdversary( adversary ){
      self.adversaries[adversary.name] = adversary
    }

    throw Board.addDeck( deck ){
      self.opponents.contains?( deck.user ) ?: return
      self.opponent_decks[deck.user] = deck
      self.board_model.addDeckModel( deck.getModel() )
      self.board_view.addDeckView( deck.getView() )
    }
