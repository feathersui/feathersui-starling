/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	/**
	 * @inheritDoc
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Extra, optional data used by an <code>AnchorLayout</code> instance to
	 * position and size a display object.
	 *
	 * @see AnchorLayout
	 * @see ILayoutDisplayObject
	 *
	 * @productversion Feathers 1.1.0
	 */
	public class AnchorLayoutData extends EventDispatcher implements ILayoutData
	{
		/**
		 * Constructor.
		 */
		public function AnchorLayoutData(top:Number = NaN, right:Number = NaN,
			bottom:Number = NaN, left:Number = NaN, horizontalCenter:Number = NaN,
			verticalCenter:Number = NaN)
		{
			this.top = top;
			this.right = right;
			this.bottom = bottom;
			this.left = left;
			this.horizontalCenter = horizontalCenter;
			this.verticalCenter = verticalCenter;
		}

		/**
		 * @private
		 */
		protected var _percentWidth:Number = NaN;

		[Bindable(event="change")]
		/**
		 * The width of the layout object, as a percentage of the container's
		 * width.
		 *
		 * <p>If the value is <code>NaN</code>, this property is ignored.</p>
		 *
		 * @default NaN
		 */
		public function get percentWidth():Number
		{
			return this._percentWidth;
		}

		/**
		 * @private
		 */
		public function set percentWidth(value:Number):void
		{
			if(this._percentWidth == value)
			{
				return;
			}
			this._percentWidth = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _percentHeight:Number = NaN;

		[Bindable(event="change")]
		/**
		 * The height of the layout object, as a percentage of the container's
		 * height.
		 *
		 * <p>If the value is <code>NaN</code>, this property is ignored.</p>
		 *
		 * @default NaN
		 */
		public function get percentHeight():Number
		{
			return this._percentHeight;
		}

		/**
		 * @private
		 */
		public function set percentHeight(value:Number):void
		{
			if(this._percentHeight == value)
			{
				return;
			}
			this._percentHeight = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _topAnchorDisplayObject:DisplayObject;

		[Bindable(event="change")]
		/**
		 * The top edge of the layout object will be relative to this anchor.
		 * If there is no anchor, the top edge of the parent container will be
		 * the anchor.
		 *
		 * @default null
		 *
		 * @see #top
		 */
		public function get topAnchorDisplayObject():DisplayObject
		{
			return this._topAnchorDisplayObject;
		}

		/**
		 * @private
		 */
		public function set topAnchorDisplayObject(value:DisplayObject):void
		{
			if(this._topAnchorDisplayObject == value)
			{
				return;
			}
			this._topAnchorDisplayObject = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _top:Number = NaN;

		[Bindable(event="change")]
		/**
		 * The position, in pixels, of the top edge relative to the top
		 * anchor, or, if there is no top anchor, then the position is relative
		 * to the top edge of the parent container. If this value is
		 * <code>NaN</code>, the object's top edge will not be anchored.
		 *
		 * @default NaN
		 *
		 * @see #topAnchorDisplayObject
		 */
		public function get top():Number
		{
			return this._top;
		}

		/**
		 * @private
		 */
		public function set top(value:Number):void
		{
			if(this._top == value)
			{
				return;
			}
			this._top = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _rightAnchorDisplayObject:DisplayObject;

		[Bindable(event="change")]
		/**
		 * The right edge of the layout object will be relative to this anchor.
		 * If there is no anchor, the right edge of the parent container will be
		 * the anchor.
		 *
		 * @default null
		 *
		 * @see #right
		 */
		public function get rightAnchorDisplayObject():DisplayObject
		{
			return this._rightAnchorDisplayObject;
		}

		/**
		 * @private
		 */
		public function set rightAnchorDisplayObject(value:DisplayObject):void
		{
			if(this._rightAnchorDisplayObject == value)
			{
				return;
			}
			this._rightAnchorDisplayObject = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _right:Number = NaN;

		[Bindable(event="change")]
		/**
		 * The position, in pixels, of the right edge relative to the right
		 * anchor, or, if there is no right anchor, then the position is relative
		 * to the right edge of the parent container. If this value is
		 * <code>NaN</code>, the object's right edge will not be anchored.
		 *
		 * @default NaN
		 *
		 * @see #rightAnchorDisplayObject
		 */
		public function get right():Number
		{
			return this._right;
		}

		/**
		 * @private
		 */
		public function set right(value:Number):void
		{
			if(this._right == value)
			{
				return;
			}
			this._right = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _bottomAnchorDisplayObject:DisplayObject;

		[Bindable(event="change")]
		/**
		 * The bottom edge of the layout object will be relative to this anchor.
		 * If there is no anchor, the bottom edge of the parent container will be
		 * the anchor.
		 *
		 * @default null
		 *
		 * @see #bottom
		 */
		public function get bottomAnchorDisplayObject():DisplayObject
		{
			return this._bottomAnchorDisplayObject;
		}

		/**
		 * @private
		 */
		public function set bottomAnchorDisplayObject(value:DisplayObject):void
		{
			if(this._bottomAnchorDisplayObject == value)
			{
				return;
			}
			this._bottomAnchorDisplayObject = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _bottom:Number = NaN;

		[Bindable(event="change")]
		/**
		 * The position, in pixels, of the bottom edge relative to the bottom
		 * anchor, or, if there is no bottom anchor, then the position is relative
		 * to the bottom edge of the parent container. If this value is
		 * <code>NaN</code>, the object's bottom edge will not be anchored.
		 *
		 * @default NaN
		 *
		 * @see #bottomAnchorDisplayObject
		 */
		public function get bottom():Number
		{
			return this._bottom;
		}

		/**
		 * @private
		 */
		public function set bottom(value:Number):void
		{
			if(this._bottom == value)
			{
				return;
			}
			this._bottom = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _leftAnchorDisplayObject:DisplayObject;

		[Bindable(event="change")]
		/**
		 * The left edge of the layout object will be relative to this anchor.
		 * If there is no anchor, the left edge of the parent container will be
		 * the anchor.
		 *
		 * @default null
		 *
		 * @see #left
		 */
		public function get leftAnchorDisplayObject():DisplayObject
		{
			return this._leftAnchorDisplayObject;
		}

		/**
		 * @private
		 */
		public function set leftAnchorDisplayObject(value:DisplayObject):void
		{
			if(this._leftAnchorDisplayObject == value)
			{
				return;
			}
			this._leftAnchorDisplayObject = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _left:Number = NaN;

		[Bindable(event="change")]
		/**
		 * The position, in pixels, of the left edge relative to the left
		 * anchor, or, if there is no left anchor, then the position is relative
		 * to the left edge of the parent container. If this value is
		 * <code>NaN</code>, the object's left edge will not be anchored.
		 *
		 * @default NaN
		 *
		 * @see #leftAnchorDisplayObject
		 */
		public function get left():Number
		{
			return this._left;
		}

		/**
		 * @private
		 */
		public function set left(value:Number):void
		{
			if(this._left == value)
			{
				return;
			}
			this._left = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _horizontalCenterAnchorDisplayObject:DisplayObject;

		[Bindable(event="change")]
		/**
		 * The horizontal center of the layout object will be relative to this
		 * anchor. If there is no anchor, the horizontal center of the parent
		 * container will be the anchor.
		 *
		 * @default null
		 *
		 * @see #horizontalCenter
		 */
		public function get horizontalCenterAnchorDisplayObject():DisplayObject
		{
			return this._horizontalCenterAnchorDisplayObject;
		}

		/**
		 * @private
		 */
		public function set horizontalCenterAnchorDisplayObject(value:DisplayObject):void
		{
			if(this._horizontalCenterAnchorDisplayObject == value)
			{
				return;
			}
			this._horizontalCenterAnchorDisplayObject = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _horizontalCenter:Number = NaN;

		[Bindable(event="change")]
		/**
		 * The position, in pixels, of the horizontal center relative to the
		 * horizontal center anchor, or, if there is no horizontal center
		 * anchor, then the position is relative to the horizontal center of the
		 * parent container. If this value is <code>NaN</code>, the object's
		 * horizontal center will not be anchored.
		 *
		 * @default NaN
		 *
		 * @see #horizontalCenterAnchorDisplayObject
		 */
		public function get horizontalCenter():Number
		{
			return this._horizontalCenter;
		}

		/**
		 * @private
		 */
		public function set horizontalCenter(value:Number):void
		{
			if(this._horizontalCenter == value)
			{
				return;
			}
			this._horizontalCenter = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _verticalCenterAnchorDisplayObject:DisplayObject;

		[Bindable(event="change")]
		/**
		 * The vertical center of the layout object will be relative to this
		 * anchor. If there is no anchor, the vertical center of the parent
		 * container will be the anchor.
		 *
		 * @default null
		 *
		 * @see #verticalCenter
		 */
		public function get verticalCenterAnchorDisplayObject():DisplayObject
		{
			return this._verticalCenterAnchorDisplayObject;
		}

		/**
		 * @private
		 */
		public function set verticalCenterAnchorDisplayObject(value:DisplayObject):void
		{
			if(this._verticalCenterAnchorDisplayObject == value)
			{
				return;
			}
			this._verticalCenterAnchorDisplayObject = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _verticalCenter:Number = NaN;

		[Bindable(event="change")]
		/**
		 * The position, in pixels, of the vertical center relative to the
		 * vertical center anchor, or, if there is no vertical center anchor,
		 * then the position is relative to the vertical center of the parent
		 * container. If this value is <code>NaN</code>, the object's vertical
		 * center will not be anchored.
		 *
		 * @default NaN
		 *
		 * @see #verticalCenterAnchorDisplayObject
		 */
		public function get verticalCenter():Number
		{
			return this._verticalCenter;
		}

		/**
		 * @private
		 */
		public function set verticalCenter(value:Number):void
		{
			if(this._verticalCenter == value)
			{
				return;
			}
			this._verticalCenter = value;
			this.dispatchEventWith(Event.CHANGE);
		}
	}
}
