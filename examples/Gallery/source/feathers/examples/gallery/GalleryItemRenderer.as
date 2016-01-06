package feathers.examples.gallery
{
	import feathers.controls.ImageLoader;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.events.FeathersEventType;

	import flash.geom.Point;
	import flash.utils.Dictionary;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class GalleryItemRenderer extends FeathersControl implements IListItemRenderer
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * @private
		 */
		private static const HELPER_TOUCHES_VECTOR:Vector.<Touch> = new <Touch>[];

		/**
		 * @private
		 * This will only work in a single list. If this item renderer needs to
		 * be used by multiple lists, this data should be stored differently.
		 */
		private static const CACHED_BOUNDS:Dictionary = new Dictionary(false);

		/**
		 * Constructor.
		 */
		public function GalleryItemRenderer()
		{
			this.isQuickHitAreaEnabled = true;
			this.addEventListener(TouchEvent.TOUCH, touchHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler)
		}

		/**
		 * @private
		 */
		protected var image:ImageLoader;

		/**
		 * @private
		 */
		protected var touchPointID:int = -1;

		/**
		 * @private
		 */
		protected var fadeTween:Tween;

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
		private var _factoryID:String;

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
		protected var _owner:List;

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
			if(this._owner)
			{
				this._owner.removeEventListener(FeathersEventType.SCROLL_START, owner_scrollStartHandler);
				this._owner.removeEventListener(FeathersEventType.SCROLL_COMPLETE, owner_scrollCompleteHandler);
			}
			this._owner = value;
			if(this._owner)
			{
				if(this.image)
				{
					this.image.delayTextureCreation = this._owner.isScrolling;
				}
				this._owner.addEventListener(FeathersEventType.SCROLL_START, owner_scrollStartHandler);
				this._owner.addEventListener(FeathersEventType.SCROLL_COMPLETE, owner_scrollCompleteHandler);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		private var _data:GalleryItem;

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
			this.touchPointID = -1;
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
		 */
		override protected function initialize():void
		{
			this.image = new ImageLoader();
			this.image.textureQueueDuration = 0.25;
			this.image.addEventListener(Event.COMPLETE, image_completeHandler);
			this.image.addEventListener(FeathersEventType.ERROR, image_errorHandler);
			this.addChild(this.image);
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);

			if(dataInvalid)
			{
				if(this.fadeTween)
				{
					this.fadeTween.advanceTime(Number.MAX_VALUE);
				}
				if(this._data)
				{
					this.image.visible = false;
					this.image.source = this._data.thumbURL;
				}
				else
				{
					this.image.source = null;
				}
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(sizeInvalid)
			{
				this.image.width = this.actualWidth;
				this.image.height = this.actualHeight;
			}
		}

		/**
		 * @private
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			var needsWidth:Boolean = isNaN(this._explicitWidth);
			var needsHeight:Boolean = isNaN(this._explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}

			this.image.width = this.image.height = NaN;
			this.image.validate();
			var newWidth:Number = this._explicitWidth;
			if(needsWidth)
			{
				if(this.image.isLoaded)
				{
					if(!CACHED_BOUNDS.hasOwnProperty(this._index))
					{
						CACHED_BOUNDS[this._index] = new Point();
					}
					var boundsFromCache:Point = Point(CACHED_BOUNDS[this._index]);
					//also save it to a cache so that we can reuse the width and
					//height values later if the same image needs to be loaded
					//again.
					newWidth = boundsFromCache.x = this.image.width;
				}
				else
				{
					if(CACHED_BOUNDS.hasOwnProperty(this._index))
					{
						//if the image isn't loaded yet, but we've loaded it at
						//least once before, we can use a cached value to avoid
						//jittering when the image resizes
						boundsFromCache = Point(CACHED_BOUNDS[this._index]);
						newWidth = boundsFromCache.x;
					}
					else
					{
						//default to 100 if we've never displayed an image for
						//this index yet.
						newWidth = 100;
					}

				}
			}
			var newHeight:Number = this._explicitHeight;
			if(needsHeight)
			{
				if(this.image.isLoaded)
				{
					if(!CACHED_BOUNDS.hasOwnProperty(this._index))
					{
						CACHED_BOUNDS[this._index] = new Point();
					}
					boundsFromCache = Point(CACHED_BOUNDS[this._index]);
					newHeight = boundsFromCache.y = this.image.height;
				}
				else
				{
					if(CACHED_BOUNDS.hasOwnProperty(this._index))
					{
						boundsFromCache = Point(CACHED_BOUNDS[this._index]);
						newHeight = boundsFromCache.y;
					}
					else
					{
						newHeight = 100;
					}
				}
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		protected function fadeTween_onComplete():void
		{
			this.fadeTween = null;
		}

		/**
		 * @private
		 */
		protected function removedFromStageHandler(event:Event):void
		{
			this.touchPointID = -1;
		}

		/**
		 * @private
		 */
		protected function touchHandler(event:TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(this, null, HELPER_TOUCHES_VECTOR);
			if(touches.length == 0)
			{
				return;
			}
			if(this.touchPointID >= 0)
			{
				var touch:Touch;
				for each(var currentTouch:Touch in touches)
				{
					if(currentTouch.id == this.touchPointID)
					{
						touch = currentTouch;
						break;
					}
				}
				if(!touch)
				{
					HELPER_TOUCHES_VECTOR.length = 0;
					return;
				}
				if(touch.phase == TouchPhase.ENDED)
				{
					this.touchPointID = -1;

					touch.getLocation(this, HELPER_POINT);
					if(this.hitTest(HELPER_POINT) !== null && !this._isSelected)
					{
						this.isSelected = true;
					}
				}
			}
			else
			{
				for each(touch in touches)
				{
					if(touch.phase == TouchPhase.BEGAN)
					{
						this.touchPointID = touch.id;
						break;
					}
				}
			}
			HELPER_TOUCHES_VECTOR.length = 0;
		}

		/**
		 * @private
		 */
		protected function owner_scrollStartHandler(event:Event):void
		{
			this.touchPointID = -1;
			this.image.delayTextureCreation = true;
		}

		/**
		 * @private
		 */
		protected function owner_scrollCompleteHandler(event:Event):void
		{
			this.image.delayTextureCreation = false;
		}

		/**
		 * @private
		 */
		protected function image_completeHandler(event:Event):void
		{
			this.image.alpha = 0;
			this.image.visible = true;
			this.fadeTween = new Tween(this.image, 1, Transitions.EASE_OUT);
			this.fadeTween.fadeTo(1);
			this.fadeTween.onComplete = fadeTween_onComplete;
			Starling.juggler.add(this.fadeTween);
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		protected function image_errorHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

	}
}
