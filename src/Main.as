package 
{
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.core.GestureWorks;
	import flash.events.Event;
	import com.gestureworks.cml.components.*;
	import com.gestureworks.cml.core.*;
	import com.gestureworks.cml.element.*;
	import com.gestureworks.cml.events.*;
	import com.gestureworks.cml.managers.*;
	import com.gestureworks.cml.utils.*;
	import com.gestureworks.core.*;
	import com.gestureworks.events.*;
	import com.greensock.TweenMax;
	import flash.events.*;
	import flash.geom.Point;
	import flash.net.*;
	import flash.ui.Mouse;
	import flash.utils.*;
	import OEGigapixel; OEGigapixel;
	import OEAlbumViewer; OEAlbumViewer;
	import OEAlbum; OEAlbum;
	import TouchContainer2; TouchContainer2;
	import PanelLayout; PanelLayout;



	[SWF(width = "1920", height = "1080", backgroundColor = "0x000000", frameRate = "30")]

	public class Main extends GestureWorks
	{
		
		private var gigapixel:OEGigapixel;
		
		public function Main() 
		{			
			super();	
			cml = "library/cml/base.cml";
			gml = "library/gml/my_gestures.gml";
			CMLParser.debug = false;
			CMLParser.addEventListener(CMLParser.COMPLETE, cmlInit);
			Mouse.hide();

		}
	
		override protected function gestureworksInit():void
 		{
			trace("gestureWorksInit()");			
		}
		
		private function cmlInit(event:Event):void
		{
			trace("cmlInit()");
			CMLParser.removeEventListener(CMLParser.COMPLETE, cmlInit);
			
		}
	}
	
}

