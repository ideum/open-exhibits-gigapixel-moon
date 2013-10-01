package 
{
	import com.gestureworks.cml.element.Gigapixel;
	import com.gestureworks.cml.element.Hotspot;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.factories.ElementFactory;
	import flash.events.*;
	import flash.geom.*;
	import org.openzoom.flash.components.MultiScaleImage;
	import org.openzoom.flash.components.SceneNavigator;
	import org.openzoom.flash.descriptors.IMultiScaleImageDescriptor;
	import org.openzoom.flash.viewport.constraints.CenterConstraint;
	import org.openzoom.flash.viewport.constraints.CompositeConstraint;
	import org.openzoom.flash.viewport.constraints.FillConstraint;
	import org.openzoom.flash.viewport.constraints.ScaleConstraint;
	import org.openzoom.flash.viewport.constraints.VisibilityConstraint;
	import org.openzoom.flash.viewport.constraints.ZoomConstraint;
	import org.openzoom.flash.viewport.controllers.TouchController;
	import org.openzoom.flash.viewport.transformers.TweenerTransformer;
	 
	/**
	 * 
	 * 
	 * @author Josh
	 */
	public class OEGigapixel extends Gigapixel
	{
		private var _clickZoomInFactor:Number = 1.7
		private var _scaleZoomFactor:Number = 1.4
		private var image2:MultiScaleImage;
    	private var sceneNavigator:SceneNavigator;
    	private var scaleConstraint:ScaleConstraint;
		private var _hotspots:Array = [];
		
		private var images:Array = [];
		private var _currentImage:int = 0;
		
		/**
		 * Constructor
		 */
		public function OEGigapixel()
		{
			super();
		}
		
		private var _src:String = "";
		/**
		 * Sets the src xml file
		 */		
		override public function get src():String{return _src;}
		override public function set src(value:String):void
		{			
			_src = value;
			images = _src.split(",");
		}

		private var _loaded:Boolean;
		/**
		 * Indicated whether the gigaPixel image is loaded
		 */
		override public function get loaded():Boolean { return _loaded; }
		
		override public function get sceneWidth():Number { return images[_currentImage].sceneWidth; }
		override public function get sceneHeight():Number { return images[_currentImage].sceneHeight; }
		
		override public function get viewportWidth():Number { return images[_currentImage].viewportWidth; }
		override public function get viewportHeight():Number { return images[_currentImage].viewportHeight; }
		
		private var _toggleHotspots:Boolean = true;
		/**
		 * Set the visibility of hotspots.
		 */
		override public function get toggleHotspots():Boolean { return _toggleHotspots; }
		override public function set toggleHotspots(value:Boolean):void {
			_toggleHotspots = value;
			flipHotspots(_toggleHotspots);
		}
		
		private var _viewportX:Number;
		override public function get viewportX():Number { 
			if (loaded) return images[_currentImage].viewportX;
			else return _viewportX;
		}
		override public function set viewportX(value:Number):void {
			_viewportX = value;
			if (loaded)
				panTo(value, images[_currentImage].viewportX);
		}
		
		private var _viewportY:Number;
		override public function get viewportY():Number { 
			if (loaded) return images[_currentImage].viewportY;
			else return _viewportY;
		}
		override public function set viewportY(value:Number):void {
			_viewportY = value;
			if (loaded)
				panTo(images[_currentImage].viewportY, value);
		}
		
		private var _zoom:Number;
		override public function get zoom():Number {
			if (loaded) return images[_currentImage].zoom;
			else return _zoom;
		}
		override public function set zoom(value:Number):void {
			_zoom = value;
			if (loaded)
				images[_currentImage].zoomTo(_zoom);
		}
		
		override public function localToScene(p:Point):Point {
			return images[_currentImage].localToScene(p);
		}
		
		public function set currentImage(value:Number):void {
			if (value == _currentImage) return;
			
			images[_currentImage].visible = false;
			var startX:Number = images[_currentImage].viewportX;
			var startY:Number = images[_currentImage].viewportY;
			var startZ:Number = images[_currentImage].zoom;
			
			_currentImage = value;
			images[_currentImage].visible = true;
			images[_currentImage].zoomTo(startZ);
			MultiScaleImage(images[_currentImage]).panTo(startX, startY, true);
		}
		
		override public function get hotspots():Array { return _hotspots; }
		override public function set hotspots(value:Array):void {
			_hotspots = value;
		}
		
		/**
		 * CML call back Initialisation
		 */
		override public function displayComplete():void
		{			
			while (this.numChildren > 0) {
				if (this.getChildAt(0) is Hotspot) {
					_hotspots.push(this.getChildAt(0));
				}
				removeChildAt(0);
				//trace("Clearing markers to put them back later.");
			}
			
			if (!src || images.length < 1) return;
			
			image = new MultiScaleImage();
			image.mouseChildren = true;
			if (!image.hasEventListener(Event.COMPLETE))
				image.addEventListener(Event.COMPLETE, image_completeHandler);
				
			image2 = new MultiScaleImage();
			image2.mouseChildren = true;
			if (!image2.hasEventListener(Event.COMPLETE))
				image2.addEventListener(Event.COMPLETE, image2_completeHandler)
			
			// Add transformer for smooth zooming
			var transformer:TweenerTransformer = new TweenerTransformer()
			transformer.easing = "EaseOut";
			transformer.duration = 1 // seconds
			
			var transformer2:TweenerTransformer = new TweenerTransformer()
			transformer2.easing = "EaseOut";
			transformer2.duration = 1 // seconds
			
			image.transformer = transformer;
			image.controllers = [new TouchController()]
	
			image2.transformer = transformer2;
			image2.controllers = [new TouchController()]
			
			var constraint:CompositeConstraint = new CompositeConstraint()
			var zoomConstraint:ZoomConstraint = new ZoomConstraint()
			zoomConstraint.minZoom = 0.1;
			
			scaleConstraint = new ScaleConstraint()
			scaleConstraint.minScale = minScaleConstraint;
				
			var centerConstraint:CenterConstraint = new CenterConstraint()
			var visibilityConstraint:VisibilityConstraint = new VisibilityConstraint()
			visibilityConstraint.visibilityRatio = visibilityRatio;
			constraint.constraints = [zoomConstraint, scaleConstraint, centerConstraint, visibilityConstraint];
	
			image.constraint = constraint;
			image2.constraint = constraint;
			image.source = images[0];
			image2.source = images[1];
			
			if (width != 0 && height == 0) {
				var aspectW:Number = image.sceneHeight / image.sceneWidth;
				height = aspectW * width;
			} else if (height !=0 && width == 0) {
				var aspectH:Number = image.sceneWidth / image.sceneHeight;
				width = height * aspectH;
			}
			
			image.width = width;
			image2.width = width;
			image.height = height;
			image2.height = height;
			
			addChild(image2);
			addChild(image);
			
			for (var i:Number = 0; i < _hotspots.length; i++) {
				if (!(contains(_hotspots[i])))
					addChild(_hotspots[i]);
				var point:Point = image.sceneToLocal(new Point(_hotspots[i].sceneX, _hotspots[i].sceneY));
				_hotspots[i].x = point.x;
				_hotspots[i].y = point.y;
				//trace("Adding hotspot:", i, hotspots[i].x, hotspots[i].y);
			}
			
			if (_hotspots.length > 0 && !hasEventListener(Event.ENTER_FRAME)) {
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			
			//_loaded = true;
			
		}
		
		private function onEnterFrame(e:Event):void {
			if (!loaded) return;
			
			for (var i:Number = 0; i < _hotspots.length; i++) {
				if (!(contains(_hotspots[i])))
					addChild(_hotspots[i]);
				var point:Point = images[_currentImage].sceneToLocal(new Point(_hotspots[i].sceneX, _hotspots[i].sceneY));
				_hotspots[i].x = point.x;
				_hotspots[i].y = point.y;
				//trace("Adding hotspot:", i, hotspots[i].x, hotspots[i].y);
			}
		}
		
		private function flipHotspots(onOff:Boolean):void {
			
			for (var i:int = 0; i < _hotspots.length; i++) 
			{
				_hotspots[i].visible = onOff;
			}
		}
		
		/**
		 * Initialisation method
		 */
		override public function init():void
		{ 
			displayComplete();
		}
		
		
		private function image_completeHandler(event:Event):void
		{
			var descriptor:IMultiScaleImageDescriptor = image.source as IMultiScaleImageDescriptor;
			if (descriptor)
				scaleConstraint.maxScale = descriptor.width / image.sceneWidth;
			
			if (isNaN(_zoom)) {
				_zoom = image.zoom;
			}
			else zoom = _zoom;
			
			if (_viewportX && _viewportY) {
				panTo(_viewportX, _viewportY, true);
			}
			else if (_viewportX && !_viewportY)
				panTo(_viewportX, image.viewportY, true);
			else if (_viewportY && !_viewportX)
				panTo(image.viewportX, _viewportY, true);
			
			images[0] = image;
			if (images[1] is MultiScaleImage) {
				_loaded = true;
				trace("loaded in first handler");
				dispatchEvent(new StateEvent(StateEvent.CHANGE, this.id, "loaded", loaded));
			}
		}
		
		private function image2_completeHandler(event:Event):void
		{
			var descriptor:IMultiScaleImageDescriptor = image2.source as IMultiScaleImageDescriptor;
			if (descriptor)
				scaleConstraint.maxScale = descriptor.width / image2.sceneWidth;
				
			image2.visible = false;
			images[1] = image2;
			if (images[0] is MultiScaleImage) {
				_loaded = true;
				trace("loaded in second handler");
				dispatchEvent(new StateEvent(StateEvent.CHANGE, this.id, "loaded", loaded));
			}
		}
		
		override public function panTo(x:Number, y:Number, immediately:Boolean = false):void {
			images[_currentImage].panTo(x, y, immediately);
		}
		
		/**
		 * Dispose method and remove listener
		 */
		override public function dispose():void
		{
			super.dispose();
			scaleConstraint = null;
			
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			while (this.numChildren > 0){
				this.removeChildAt(0);
			}
			
			if (image)
			{
				image.removeEventListener(Event.COMPLETE, image_completeHandler);
				//image.dispose();
				image = null;
			}	
		}
	}
}