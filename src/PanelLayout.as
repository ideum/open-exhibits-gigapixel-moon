package  
{
	import com.gestureworks.cml.element.Media;
	import com.gestureworks.cml.element.Text;
	import com.gestureworks.cml.element.TouchContainer;
	import com.gestureworks.cml.factories.LayoutFactory;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;

	public class PanelLayout extends LayoutFactory
	{
	
		private var _padding:Number = 20;
		
		public function get padding():Number { return _padding; }
		public function set padding(p:Number):void
		{
			_padding = p;
		}
		
		public function PanelLayout() 
		{
			super();			
			marginX = 20;
			continuousTransform = false;
		}
		
		override public function layout(container:DisplayObjectContainer):void 
		{
			var c:TouchContainer = TouchContainer(container);
			
			var media:* = c.searchChildren(Media).current;
			var scale:Number = c.height/media.height;
			var mMat:Matrix = media.transform.matrix;
			translateTransform(mMat, padding, 0);
			scaleTransform(mMat, scale);
			childTransformations.push(mMat);
			
			var text:Text = c.searchChildren(Text);
			
			var bmp:Boolean = text.textBitmap;
			text.textBitmap = false;

			var tMat:Matrix = text.transform.matrix;
			var xVal:Number = media.width * scale + (marginX * 2);
			translateTransform(tMat, xVal, -4);
			text.height = c.height;
			text.width = c.width - xVal - padding*2;
			childTransformations.push(tMat);
			
			super.layout(container);
		}
		
		override public function dispose():void 
		{
			super.dispose();
		}
		
	}

}