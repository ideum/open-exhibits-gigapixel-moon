package  
{
	import com.gestureworks.cml.components.AlbumViewer;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.element.Media;
	import com.gestureworks.cml.element.TouchContainer;
	import com.gestureworks.cml.element.Video;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.utils.DisplayUtils;
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.events.GWGestureEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author 
	 */
	public class OEAlbumViewer extends AlbumViewer
	{		
		
		private var videos:Dictionary = new Dictionary();
		private var panels:Array;
		private var timer:Timer;
		private var _resetTime:Number = 0;
		private var _videoScrollAction:String = "pause";
		
		public function OEAlbumViewer() 
		{
			super();
			//addEventListener(GWGestureEvent.MANIPULATE, updateAngle);
			addEventListener(StateEvent.CHANGE, resetVideo);
			addEventListener(GWGestureEvent.SCALE, onScale);
			disableAffineTransform = false;
			disableNativeTransform = true;
		}
		
		override public function init():void 
		{
			super.init();
			
			
			addEventListener(TouchEvent.TOUCH_BEGIN, resetTimer);
			front.addEventListener(TouchEvent.TOUCH_BEGIN, resetTimer);
			
			var f:Function = videoScrollAction == "stop" ? stop : pause;
			front.addEventListener(StateEvent.CHANGE, f);			
			panels = front.childList.getCSSClass("panel-container").getValueArray();

			for each(var panel:TouchContainer in panels) {
				panel.addEventListener(GWGestureEvent.TAP, play);						
				var media:Array = panel.searchChildren(Media, Array);
				for each(var m:Media in media)
				{
					m.addEventListener(Event.COMPLETE, function(e:Event):void {
						e.target.parent.applyLayout(new PanelLayout());
						if (e.target.current is Video)
						{		
							var vid:Video = Video(e.target.current);
							videos[e.target.parent] = vid;
						}
					});
				}
			}
						
			if (resetTime)
			{
				timer = new Timer(resetTime * 1000);	
				timer.start();
				timer.addEventListener(TimerEvent.TIMER, timeExpired);			
			}
			
			CMLParser.addEventListener(CMLParser.COMPLETE, cmlInit);
		}
		
		private var tsArray:Array = [];
		private function cmlInit(e:Event):void 
		{
			CMLParser.removeEventListener(CMLParser.COMPLETE, cmlInit);			
			tsArray = DisplayUtils.getAllChildrenByType(this, TouchSprite);	
			for each (var ts:TouchSprite in tsArray) {
				ts.addEventListener(GWGestureEvent.RELEASE, onRelease);
			}			
		}
		
		
		public function onRelease(e:GWGestureEvent=null):void {
			cO.pointArray.length = 0;			
			for each (var ts:TouchSprite in tsArray) {
				ts.cO.pointArray.length = 0;
			}			
		}
		
		
		
		public function get resetTime():Number { return _resetTime; }
		public function set resetTime(t:Number):void
		{
			_resetTime = t;
		}
		
		public function get videoScrollAction():String { return _videoScrollAction; }
		public function set videoScrollAction(a:String):void
		{
			_videoScrollAction = a;
		}
		
		/**
		 * Play the tapped Video
		 * @param	e
		 */
		private function play(e:GWGestureEvent):void
		{
			if (videos[e.target])
			{
				var video:Video = Video(videos[e.target]);
				video.resume();
			}
		}
		
		/**
		 * Pause all Video objects on Album state change
		 * @param	e
		 */
		private function pause(e:StateEvent = null):void
		{
			var video:Video;
			for each(var panel:TouchContainer in panels)
			{
				video = videos[panel];
				if (video)			
					video.pause();
			}
		}		
		
		/**
		 * Stop all Video objects on Album state change
		 * @param	e
		 */
		private function stop(e:StateEvent = null):void
		{
			var video:Video;
			for each(var panel:TouchContainer in panels)
			{				
				video = videos[panel];
				if (video)					
					video.stop();
			}
		}				
		
		/**
		 * Reset albums to initial frame
		 * @param	e
		 */
		private function timeExpired(e:TimerEvent):void
		{
			front.belt.x = 0;
			pause();
			
			if (front)
				front.visible = true;		
		}
		
		/**
		 * Reset the activity timer
		 * @param	e
		 */
		private function resetTimer(e:* = null):void
		{
			if (!timer) return;
			timer.reset();
			timer.start();
		}
		
		/**
		 * Resets video to first frame on each album close
		 * @param	e
		 */
		private function resetVideo(e:StateEvent):void
		{
			if (e.property == "visible" && !e.value)
				stop();
		}
		
	   /**
		* Updates the angle of the album element
		
		private function updateAngle(e:GWGestureEvent):void
		{
			if (album) album.dragAngle = rotation;
			if (linkAlbums && back) back.dragAngle = rotation;							
		}*/		
			
		
	   /**
		* Scale event handler
		*/
		private function onScale(e:GWGestureEvent):void
		{			
			if (e.target.$scaleX + e.value.scale_dsx <= 1 || e.target.$scaleY + e.value.scale_dsy <= 1) {			
				e.target.$scaleX = 1;
				e.target.$scaleY = 1;			
			}
			else if (e.target.$scaleX + e.value.scale_dsx >= 1.5 || e.target.$scaleY + e.value.scale_dsy >= 1.5) {			
				e.target.$scaleX = 1.5;
				e.target.$scaleY = 1.5;			
			}
			else {			
				e.target.$scaleX += e.value.scale_dsx;
				e.target.$scaleY += e.value.scale_dsy;			
			}			
		}			
		
	}

}