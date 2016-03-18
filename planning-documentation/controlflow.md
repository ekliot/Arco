start with a main menu State, transition to a Session State (fomerly Board)
Session has a Board object, with two Player objects
Session State takes care of laying out the visual elements, by listening to the Board for changes in state
How? The Board listens for Events from Players. The Board validates these Events, and then upon validation will tell the Session what changes ought to be made to the visuals by putting the Event into a queue within the Session. The Session will make these changes and send an Event that a change was made


**MVC**

| Model | View | Controller |
| :
| Board | Session | Player |

user selects game from Menu, which initializes two Players, then a Session, then adds the players to the Session and switches to the Session State
