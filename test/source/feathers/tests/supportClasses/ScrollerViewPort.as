package feathers.tests.supportClasses
{
	import feathers.core.FeathersControl;
	import feathers.controls.supportClasses.IViewPort;

	public class ScrollerViewPort extends FeathersControl implements IViewPort
	{
		public function ScrollerViewPort()
		{
		}

		private var _actualMinVisibleWidth:Number = 0;

		private var _explicitMinVisibleWidth:Number;

		public function get minVisibleWidth():Number
		{
			if(this._explicitMinWidth === this._explicitMinWidth) //!isNaN
			{
				return this._explicitMinWidth;
			}
			if(this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth) //isNaN
			{
				return this._actualMinVisibleWidth;
			}
			return this._explicitMinVisibleWidth;
		}

		public function set minVisibleWidth(value:Number):void
		{
			if(this._explicitMinVisibleWidth == value ||
				(value !== value && this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth)) //isNaN
			{
				return;
			}
			this._explicitMinVisibleWidth = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var _maxVisibleWidth:Number = Number.POSITIVE_INFINITY;

		public function get maxVisibleWidth():Number
		{
			return this._maxVisibleWidth;
		}

		public function set maxVisibleWidth(value:Number):void
		{
			if(this._maxVisibleWidth == value)
			{
				return;
			}
			if(value !== value) //isNaN
			{
				throw new ArgumentError("maxVisibleWidth cannot be NaN");
			}
			this._maxVisibleWidth = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var _actualVisibleWidth:Number = 0;

		private var _explicitVisibleWidth:Number = NaN;

		public function get visibleWidth():Number
		{
			if(this._explicitVisibleWidth !== this._explicitVisibleWidth) //isNaN
			{
				return this._actualVisibleWidth;
			}
			return this._explicitVisibleWidth;
		}

		public function set visibleWidth(value:Number):void
		{
			if(this._explicitVisibleWidth == value ||
			(value !== value && this._explicitVisibleWidth !== this._explicitVisibleWidth)) //isNaN
			{
				return;
			}
			this._explicitVisibleWidth = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var _actualMinVisibleHeight:Number = 0;

		private var _explicitMinVisibleHeight:Number;

		public function get minVisibleHeight():Number
		{
			if(this._explicitMinHeight === this._explicitMinHeight) //!isNaN
			{
				return this._explicitMinHeight;
			}
			if(this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight) //isNaN
			{
				return this._actualMinVisibleHeight;
			}
			return this._explicitMinVisibleHeight;
		}

		public function set minVisibleHeight(value:Number):void
		{
			if(this._explicitMinVisibleHeight == value ||
				(value !== value && this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight)) //isNaN
			{
				return;
			}
			this._explicitMinVisibleHeight = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var _maxVisibleHeight:Number = Number.POSITIVE_INFINITY;

		public function get maxVisibleHeight():Number
		{
			return this._maxVisibleHeight;
		}

		public function set maxVisibleHeight(value:Number):void
		{
			if(this._maxVisibleHeight == value)
			{
				return;
			}
			if(value !== value) //isNaN
			{
				throw new ArgumentError("maxVisibleHeight cannot be NaN");
			}
			this._maxVisibleHeight = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var _actualVisibleHeight:Number = 0;

		private var _explicitVisibleHeight:Number = NaN;

		public function get visibleHeight():Number
		{
			if(this._explicitVisibleHeight !== this._explicitVisibleHeight) //isNaN
			{
				return this._actualVisibleHeight;
			}
			return this._explicitVisibleHeight;
		}

		public function set visibleHeight(value:Number):void
		{
			if(this._explicitVisibleHeight == value ||
				(value !== value && this._explicitVisibleHeight !== this._explicitVisibleHeight)) //isNaN
			{
				return;
			}
			this._explicitVisibleHeight = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var _contentX:Number = 0;

		public function get contentX():Number
		{
			return this._contentX;
		}

		public function set contentX(value:Number):void
		{
			this._contentX = value;
		}

		private var _contentY:Number = 0;

		public function get contentY():Number
		{
			return this._contentY;
		}

		public function set contentY(value:Number):void
		{
			this._contentY = value;
		}
		
		private var _horizontalScrollStep:Number = 1;

		public function get horizontalScrollStep():Number
		{
			return this._horizontalScrollStep;
		}

		public function set horizontalScrollStep(value:Number):void
		{
			this._horizontalScrollStep = value;
		}

		private var _verticalScrollStep:Number = 1;

		public function get verticalScrollStep():Number
		{
			return this._verticalScrollStep;
		}

		public function set verticalScrollStep(value:Number):void
		{
			this._verticalScrollStep = value;
		}

		private var _horizontalScrollPosition:Number = 0;

		public function get horizontalScrollPosition():Number
		{
			return this._horizontalScrollPosition;
		}

		public function set horizontalScrollPosition(value:Number):void
		{
			if(this._horizontalScrollPosition == value)
			{
				return;
			}
			this._horizontalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		private var _verticalScrollPosition:Number = 0;

		public function get verticalScrollPosition():Number
		{
			return this._verticalScrollPosition;
		}

		public function set verticalScrollPosition(value:Number):void
		{
			if(this._verticalScrollPosition == value)
			{
				return;
			}
			this._verticalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		override public function set width(value:Number):void
		{
			super.width = value;
			this._actualVisibleWidth = value;
		}

		override public function set height(value:Number):void
		{
			super.height = value;
			this._actualVisibleHeight = value;
		}

		private var _requiresMeasurementOnScroll:Boolean = false;

		public function get requiresMeasurementOnScroll():Boolean
		{
			return this._requiresMeasurementOnScroll;
		}

		public function set requiresMeasurementOnScroll(value:Boolean):void
		{
			this._requiresMeasurementOnScroll = value;
		}

		private var _resizeOnScroll:Boolean = false;

		public function get resizeOnScroll():Boolean
		{
			return this._resizeOnScroll;
		}

		public function set resizeOnScroll(value:Boolean):void
		{
			this._resizeOnScroll = value;
		}
		
		override protected function draw():void
		{
			if(this._resizeOnScroll && this.isInvalid(INVALIDATION_FLAG_SCROLL))
			{
				super.width = this.width + 1;
				super.height = this.height + 1;
			}
			super.draw();
		}
	}
}
