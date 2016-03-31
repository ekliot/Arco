/* https://github.com/Zielak/4Simon/blob/master/src/components/Clickable.hx */

package components;

import luxe.Component;
import luxe.Color;
import luxe.Input.MouseEvent;
import luxe.Rectangle;
import luxe.Vector;
import luxe.Visual;

import luxe.options.ComponentOptions;


class Clickable extends Component{

    var bounds:Rectangle;
    var eventName:String;

    public var isOver:Bool = false;
    public var isDown:Bool = false;
    public var justClicked:Bool = false;
    public var enabled:Bool = true;


    override public function new( options : ClickableComponentOptions ):Void{
        super(options);

        bounds = options.bounds;
        eventName = options.eventName;
    }

    override function init():Void{}

    override function update( dt : Float ):Void{
        if( justClicked && isDown ){
            justClicked = false;
        }
    }

    override public function onmousemove( event : MouseEvent ):Void{
        if( bounds.point_inside( event.pos ) && !isOver ){
            onover();
        }
        if( !bounds.point_inside( event.pos ) && isOver ){
            onout();
        }
    }

    override public function onmousedown( event : MouseEvent ):Void{
        if(isOver){
            justClicked = true;
            Luxe.events.fire(eventName+'.mouseclick', entity);
            isDown = true;
        }
    }

    override public function onmouseup( event : MouseEvent ):Void{
        if( isDown ){
            Luxe.events.fire( eventName + '.mouseup', entity );
            isDown = false;
        }
    }

    function onover():Void{
        isOver = true;
    }


    function onout():Void{
        isOver = false;
    }
}


typedef ClickableComponentOptions = {

    > ComponentOptions,

    var bounds:Rectangle;
    var eventName:String;
}
