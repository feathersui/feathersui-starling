package feathers.examples.gallery.controls
{
	import feathers.controls.ImageLoader;
	import feathers.controls.List;
	import feathers.controls.ScrollBarDisplayMode;
	import feathers.controls.ScrollContainer;
	import feathers.controls.ScrollPolicy;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.events.FeathersEventType;
	import feathers.examples.gallery.data.GalleryItem;
	import feathers.examples.gallery.layout.GalleryItemRendererLayout;
	import feathers.layout.ILayout;
	import feathers.utils.display.calculateScaleRatioToFit;
	import feathers.utils.touch.TapToSelect;
	import feathers.utils.touch.TouchSheet;

	import flash.geom.Point;
	import flash.utils.Dictionary;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * A list item renderer that displays an image that may be zoomed.
	 */
	public class GalleryItemRenderer extends ScrollContainer implements IListItemRenderer
	{
		/**
		 * Constructor.
		 */
		public function GalleryItemRenderer()
		{
			super();
			//the default layout for a scroll container doesn't work well when
			//TouchSheet gestures move it into negative coordinates.
			this.layout = new GalleryItemRendererLayout();
			//when we reach the edge, we want to stop without elasticity
			this.hasElasticEdges = false;
		}

		/**
		 * @private
		 */
		protected var touchSheet:TouchSheet = null;

		/**
		 * @private
		 */
		protected var image:ImageLoader = null;

		/**
		 * @private
		 */
		private var _index:int = -1;

		/**
		 * @inheritDoc
		 */
		public function get index():int
		{
			return this._index;
		}

		/**
		 * @private
		 */
		public function set index(value:int):void
		{
			if(this._index == value)
			{
				return;
			}
			this._index = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		private var _factoryID:String = null;

		/**
		 * @inheritDoc
		 */
		public function get factoryID():String
		{
			return this._factoryID;
		}

		/**
		 * @private
		 */
		public function set factoryID(value:String):void
		{
			this._factoryID = value;
		}

		/**
		 * @private
		 */
		protected var _owner:List = null;

		/**
		 * @inheritDoc
		 */
		public function get owner():List
		{
			return List(this._owner);
		}

		/**
		 * @private
		 */
		public function set owner(value:List):void
		{
			if(this._owner == value)
			{
				return;
			}
			if(this._owner !== null)
			{
				this._owner.removeEventListener(FeathersEventType.SCROLL_COMPLETE, owner_scrollCompleteHandler);
			}
			this._owner = value;
			if(this._owner !== null)
			{
				this._owner.addEventListener(FeathersEventType.SCROLL_COMPLETE, owner_scrollCompleteHandler);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		private var _data:GalleryItem = null;

		/**
		 * @inheritDoc
		 */
		public function get data():Object
		{
			return this._data;
		}

		/**
		 * @private
		 */
		public function set data(value:Object):void
		{
			if(this._data == value)
			{
				return;
			}
			this._data = GalleryItem(value);
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		private var _isSelected:Boolean;

		/**
		 * @inheritDoc
		 */
		public function get isSelected():Boolean
		{
			return this._isSelected;
		}

		/**
		 * @private
		 */
		public function set isSelected(value:Boolean):void
		{
			if(this._isSelected == value)
			{
				return;
			}
			this._isSelected = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 * If the scale value is less than this after a zoom gesture ends, the
		 * scale will be animated back to this value. The default scale may be
		 * updated when a new texture is loaded.
		 */
		protected var _defaultScale:Number = 1;

		/**
		 * @private
		 */
        protected var _gestureCompleteTween:Tween = null;

		/**
		 * @private
		 */
		override public function hitTest(localPoint:Point):DisplayObject
		{
			var target:DisplayObject = super.hitTest(localPoint);
			if(target === this)
			{
				//the TouchSheet may not fill the entire width and height of
				//the item renderer, but we want the gestures to work from
				//anywhere within the item renderer's bounds.
				return this.touchSheet;
			}
			return target;
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			super.initialize();

			this.image = new ImageLoader();
			this.image.addEventListener(Event.COMPLETE, image_completeHandler);
			this.image.addEventListener(FeathersEventType.ERROR, image_errorHandler);

			//this is a custom version of TouchSheet designed to work better
			//with Feathers scrolling containers
			this.touchSheet = new TouchSheet(this.image);
			//you can disable certain features of this TouchSheet
			this.touchSheet.zoomEnabled = true;
			this.touchSheet.rotateEnabled = false;
			this.touchSheet.moveEnabled = false;
			//and events are dispatched when any of the gestures are performed
			this.touchSheet.addEventListener(TouchSheet.MOVE, touchSheet_gestureHandler);
			this.touchSheet.addEventListener(TouchSheet.ROTATE, touchSheet_gestureHandler);
			this.touchSheet.addEventListener(TouchSheet.ZOOM, touchSheet_gestureHandler);
			//on TouchPhase.ENDED, any gestures performed are complete
			this.touchSheet.addEventListener(TouchEvent.TOUCH, touchSheet_touchHandler);
			this.addChild(this.touchSheet);
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(dataInvalid)
			{
				if(this._data !== null)
				{
					if(this.image.source !== this._data.url)
					{
						//hide until the image finishes loading
						this.touchSheet.visible = false;
					}
					this.image.source = this._data.url;
				}
				else
				{
					this.image.source = null;
				}
				//stop any active animations because it's a new image
				if(this._gestureCompleteTween !== null)
				{
					this.stage.starling.juggler.remove(this._gestureCompleteTween);
					this._gestureCompleteTween = null;
				}
				//reset all of the transformations because it's a new image
				this._defaultScale = 1;
				this.resetTransformation();
			}

			super.draw();
		}

		/**
		 * @private
		 */
		protected function resetTransformation():void
		{
			this.touchSheet.rotation = 0;
			this.touchSheet.scale = this._defaultScale;
			this.touchSheet.pivotX = 0;
			this.touchSheet.pivotY = 0;
			this.touchSheet.x = 0;
			this.touchSheet.y = 0;
		}

		/**
		 * @private
		 */
		protected function image_completeHandler(event:Event):void
		{
			//when an image first loads, we want it to fill the width and height
			//of the item renderer, without being larger than the item renderer
			this._defaultScale = calculateScaleRatioToFit(
				this.image.originalSourceWidth, this.image.originalSourceHeight,
				this.viewPort.visibleWidth, this.viewPort.visibleHeight);
			if(this._defaultScale > 1)
			{
				//however, we only want to make large images smaller. small
				//images should not be made larger because they'll get blurry.
				//the user can zoom in, if desired.
				this._defaultScale = 1;
			}
			this.touchSheet.scale = this._defaultScale;
			this.touchSheet.visible = true;
		}

		/**
		 * @private
		 */
		protected function image_errorHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		protected function touchSheet_touchHandler(event:TouchEvent):void
		{
			//the current gesture is complete on TouchPhase.ENDED
			var touch:Touch = event.getTouch(this.touchSheet, TouchPhase.ENDED);
			if(touch === null)
			{
				return;
			}

			//if the scale is smaller than the default, animate it back
			var targetScale:Number = this.touchSheet.scale;
			if(targetScale < this._defaultScale)
			{
				targetScale = this._defaultScale;
			}
			if(this.touchSheet.scale !== targetScale)
			{
				this._gestureCompleteTween = new Tween(this.touchSheet, 0.15, Transitions.EASE_OUT);
				this._gestureCompleteTween.scaleTo(targetScale);
				this._gestureCompleteTween.onComplete = this.gestureCompleteTween_onComplete;
				this.stage.starling.juggler.add(this._gestureCompleteTween);
			}
		}

		/**
		 * @private
		 */
		protected function touchSheet_gestureHandler(event:Event):void
		{
			//if the animation from the previous gesture is still active, stop
			//it immediately when a new gesture starts
			if(this._gestureCompleteTween !== null)
			{
				this.stage.starling.juggler.remove(this._gestureCompleteTween);
				this._gestureCompleteTween = null;
			}
		}

		/**
		 * @private
		 */
		protected function gestureCompleteTween_onComplete():void
		{
			this._gestureCompleteTween = null;
		}

		/**
		 * @private
		 */
		protected function owner_scrollCompleteHandler(event:Event):void
		{
			if(this._owner.horizontalPageIndex === this._index)
			{
				return;
			}
			this.resetTransformation();
		}
	}
}