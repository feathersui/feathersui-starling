/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.utils.math.clamp;

	import starling.display.DisplayObject;

	/**
	 * Displays the progress of a task over time. Non-interactive.
	 *
	 * @see http://wiki.starling-framework.org/feathers/progress-bar
	 */
	public class ProgressBar extends FeathersControl
	{
		/**
		 * The progress bar fills horizontally (on the x-axis).
		 */
		public static const DIRECTION_HORIZONTAL:String = "horizontal";

		/**
		 * The progress bar fills vertically (on the y-axis).
		 */
		public static const DIRECTION_VERTICAL:String = "vertical";

		/**
		 * Constructor.
		 */
		public function ProgressBar()
		{
		}

		/**
		 * @private
		 */
		protected var _direction:String = DIRECTION_HORIZONTAL;

		[Inspectable(type="String",enumeration="horizontal,vertical")]
		/**
		 * Determines the direction that the progress bar fills. When this value
		 * changes, the progress bar's width and height values do not change
		 * automatically.
		 */
		public function get direction():String
		{
			return this._direction;
		}

		/**
		 * @private
		 */
		public function set direction(value:String):void
		{
			if(this._direction == value)
			{
				return;
			}
			this._direction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _value:Number = 0;

		/**
		 * The value of the progress bar, between the minimum and maximum.
		 */
		public function get value():Number
		{
			return this._value;
		}

		/**
		 * @private
		 */
		public function set value(newValue:Number):void
		{
			newValue = clamp(newValue, this._minimum, this._maximum);
			if(this._value == newValue)
			{
				return;
			}
			this._value = newValue;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _minimum:Number = 0;

		/**
		 * The progress bar's value will not go lower than the minimum.
		 */
		public function get minimum():Number
		{
			return this._minimum;
		}

		/**
		 * @private
		 */
		public function set minimum(value:Number):void
		{
			if(this._minimum == value)
			{
				return;
			}
			this._minimum = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _maximum:Number = 1;

		/**
		 * The progress bar's value will not go higher than the maximum.
		 */
		public function get maximum():Number
		{
			return this._maximum;
		}

		/**
		 * @private
		 */
		public function set maximum(value:Number):void
		{
			if(this._maximum == value)
			{
				return;
			}
			this._maximum = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _originalBackgroundWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var _originalBackgroundHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var currentBackground:DisplayObject;

		/**
		 * @private
		 */
		protected var _backgroundSkin:DisplayObject;

		/**
		 * The primary background to display.
		 */
		public function get backgroundSkin():DisplayObject
		{
			return this._backgroundSkin;
		}

		/**
		 * @private
		 */
		public function set backgroundSkin(value:DisplayObject):void
		{
			if(this._backgroundSkin == value)
			{
				return;
			}

			if(this._backgroundSkin && this._backgroundSkin != this._backgroundDisabledSkin)
			{
				this.removeChild(this._backgroundSkin);
			}
			this._backgroundSkin = value;
			if(this._backgroundSkin && this._backgroundSkin.parent != this)
			{
				this._backgroundSkin.visible = false;
				this._backgroundSkin.touchable = false;
				this.addChildAt(this._backgroundSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _backgroundDisabledSkin:DisplayObject;

		/**
		 * A background to display when the progress bar is disabled.
		 */
		public function get backgroundDisabledSkin():DisplayObject
		{
			return this._backgroundDisabledSkin;
		}

		/**
		 * @private
		 */
		public function set backgroundDisabledSkin(value:DisplayObject):void
		{
			if(this._backgroundDisabledSkin == value)
			{
				return;
			}

			if(this._backgroundDisabledSkin && this._backgroundDisabledSkin != this._backgroundSkin)
			{
				this.removeChild(this._backgroundDisabledSkin);
			}
			this._backgroundDisabledSkin = value;
			if(this._backgroundDisabledSkin && this._backgroundDisabledSkin.parent != this)
			{
				this._backgroundDisabledSkin.visible = false;
				this._backgroundDisabledSkin.touchable = false;
				this.addChildAt(this._backgroundDisabledSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _originalFillWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var _originalFillHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var currentFill:DisplayObject;

		/**
		 * @private
		 */
		protected var _fillSkin:DisplayObject;

		/**
		 * The primary fill to display.
		 *
		 * <p>Note: The size of the <code>fillSkin</code>, at the time that it
		 * is passed to the setter, will be used used as the size of the fill
		 * when the progress bar is set to the minimum value. In other words,
		 * if the fill of a horizontal progress bar with a value from 0 to 100
		 * should be virtually invisible when the value is 0, then the
		 * <code>fillSkin</code> should have a width of 0 when you pass it in.
		 * On the other hand, if you're using a <code>Scale9Image</code> as the
		 * skin, it may require a minimum width before the image parts begin to
		 * overlap. In that case, the <code>Scale9Image</code> instance passed
		 * to the <code>fillSkin</code> setter should have a <code>width</code>
		 * value that is the same as that minimum width value where the image
		 * parts do not overlap.</p>
		 */
		public function get fillSkin():DisplayObject
		{
			return this._fillSkin;
		}

		/**
		 * @private
		 */
		public function set fillSkin(value:DisplayObject):void
		{
			if(this._fillSkin == value)
			{
				return;
			}

			if(this._fillSkin && this._fillSkin != this._fillDisabledSkin)
			{
				this.removeChild(this._fillSkin);
			}
			this._fillSkin = value;
			if(this._fillSkin && this._fillSkin.parent != this)
			{
				this._fillSkin.visible = false;
				this._fillSkin.touchable = false;
				this.addChild(this._fillSkin);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _fillDisabledSkin:DisplayObject;

		/**
		 * A fill to display when the progress bar is disabled.
		 */
		public function get fillDisabledSkin():DisplayObject
		{
			return this._fillDisabledSkin;
		}

		/**
		 * @private
		 */
		public function set fillDisabledSkin(value:DisplayObject):void
		{
			if(this._fillDisabledSkin == value)
			{
				return;
			}

			if(this._fillDisabledSkin && this._fillDisabledSkin != this._fillSkin)
			{
				this.removeChild(this._fillDisabledSkin);
			}
			this._fillDisabledSkin = value;
			if(this._fillDisabledSkin && this._fillDisabledSkin.parent != this)
			{
				this._fillDisabledSkin.visible = false;
				this._fillDisabledSkin.touchable = false;
				this.addChild(this._fillDisabledSkin);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingTop:Number = 0;

		/**
		 * The minimum space, in pixels, between the progress bar's top edge and
		 * the progress bar's content.
		 */
		public function get paddingTop():Number
		{
			return this._paddingTop;
		}

		/**
		 * @private
		 */
		public function set paddingTop(value:Number):void
		{
			if(this._paddingTop == value)
			{
				return;
			}
			this._paddingTop = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingRight:Number = 0;

		/**
		 * The minimum space, in pixels, between the progress bar's right edge
		 * and the progress bar's content.
		 */
		public function get paddingRight():Number
		{
			return this._paddingRight;
		}

		/**
		 * @private
		 */
		public function set paddingRight(value:Number):void
		{
			if(this._paddingRight == value)
			{
				return;
			}
			this._paddingRight = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingBottom:Number = 0;

		/**
		 * The minimum space, in pixels, between the progress bar's bottom edge
		 * and the progress bar's content.
		 */
		public function get paddingBottom():Number
		{
			return this._paddingBottom;
		}

		/**
		 * @private
		 */
		public function set paddingBottom(value:Number):void
		{
			if(this._paddingBottom == value)
			{
				return;
			}
			this._paddingBottom = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingLeft:Number = 0;

		/**
		 * The minimum space, in pixels, between the progress bar's left edge
		 * and the progress bar's content.
		 */
		public function get paddingLeft():Number
		{
			return this._paddingLeft;
		}

		/**
		 * @private
		 */
		public function set paddingLeft(value:Number):void
		{
			if(this._paddingLeft == value)
			{
				return;
			}
			this._paddingLeft = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);

			if(stylesInvalid || stateInvalid)
			{
				this.refreshBackground();
				this.refreshFill();
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(sizeInvalid || stylesInvalid || stateInvalid)
			{
				if(this.currentBackground)
				{
					this.currentBackground.width = this.actualWidth;
					this.currentBackground.height = this.actualHeight;
				}
			}

			if(dataInvalid || sizeInvalid || stateInvalid || stylesInvalid)
			{
				this.currentFill.x = this._paddingLeft;
				this.currentFill.y = this._paddingTop;
				const percentage:Number = (this._value - this._minimum) / (this._maximum - this._minimum);
				if(this._direction == DIRECTION_VERTICAL)
				{
					this.currentFill.width = this.actualWidth - this._paddingLeft - this._paddingRight;
					this.currentFill.height = this._originalFillHeight + percentage * (this.actualHeight - this._paddingTop - this._paddingBottom - this._originalFillHeight);
				}
				else
				{
					this.currentFill.width = this._originalFillWidth + percentage * (this.actualWidth - this._paddingLeft - this._paddingRight - this._originalFillWidth);
					this.currentFill.height = this.actualHeight - this._paddingTop - this._paddingBottom;
				}
			}

		}

		/**
		 * @private
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			var newWidth:Number = needsWidth ? this._originalBackgroundWidth : this.explicitWidth;
			var newHeight:Number = needsHeight ? this._originalBackgroundHeight  : this.explicitHeight;
			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		protected function refreshBackground():void
		{
			this.currentBackground = this._backgroundSkin;
			if(this._backgroundDisabledSkin)
			{
				if(this._isEnabled)
				{
					this._backgroundDisabledSkin.visible = false;
				}
				else
				{
					this.currentBackground = this._backgroundDisabledSkin;
					if(this._backgroundSkin)
					{
						this._backgroundSkin.visible = false;
					}
				}
			}
			if(this.currentBackground)
			{
				if(isNaN(this._originalBackgroundWidth))
				{
					this._originalBackgroundWidth = this.currentBackground.width;
				}
				if(isNaN(this._originalBackgroundHeight))
				{
					this._originalBackgroundHeight = this.currentBackground.height;
				}
				this.currentBackground.visible = true;
			}
		}

		/**
		 * @private
		 */
		protected function refreshFill():void
		{
			this.currentFill = this._fillSkin;
			if(this._fillDisabledSkin)
			{
				if(this._isEnabled)
				{
					this._fillDisabledSkin.visible = false;
				}
				else
				{
					this.currentFill = this._fillDisabledSkin;
					if(this._backgroundSkin)
					{
						this._fillSkin.visible = false;
					}
				}
			}
			if(this.currentFill)
			{
				if(isNaN(this._originalFillWidth))
				{
					this._originalFillWidth = this.currentFill.width;
				}
				if(isNaN(this._originalFillHeight))
				{
					this._originalFillHeight = this.currentFill.height;
				}
				this.currentFill.visible = true;
			}
		}


	}
}
