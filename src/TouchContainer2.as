package  
{
	import com.gestureworks.cml.element.TouchContainer;
	import com.gestureworks.events.GWGestureEvent;
	
	/**
	 * ...
	 * @author Ideum
	 */
	public class TouchContainer2 extends TouchContainer 
	{
		
		public function TouchContainer2() 
		{
			super();
		}
		
		override public function init():void 
		{
			addEventListener(GWGestureEvent.DRAG, onDrag);
			super.init();
		}
		
		private function onDrag(e:GWGestureEvent):void
		{	
			TouchContainer(parent).$x += e.value.drag_dx;
			TouchContainer(parent).$y += e.value.drag_dy;
		}
		
		
	}

}