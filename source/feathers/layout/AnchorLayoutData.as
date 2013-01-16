/*
 Feathers
 Copyright (c) 2012 Josh Tynjala. All Rights Reserved.

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
	 * @see http://wiki.starling-framework.org/feathers/anchor-layout
	 * @see AnchorLayout
	 * @see ILayoutDisplayObject
	 */
	public class AnchorLayoutData extends EventDispatcher implements ILayoutData
	{
		/**
		 * Constructor.
		 */
		public function AnchorLayoutData()
		{
		}

		/**
		 * @private
		 */
		protected var _topAnchorDisplayObject:DisplayObject;

		/**
		 * The top edge of the layout object will be relative to this anchor.
		 * If there is no anchor, the top edge of the parent container will be
		 * the anchor.
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

		/**
		 * The position, in pixels, of the top edge relative to <code>topAnchor</code>.
		 * If there is no top anchor, then the position is relative to the top
		 * edge of the parent container.
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

		/**
		 * The right edge of the layout object will be relative to this anchor.
		 * If there is no anchor, the right edge of the parent container will be
		 * the anchor.
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

		/**
		 * The position, in pixels, of the right edge relative to <code>rightAnchor</code>.
		 * If there is no right anchor, then the position is relative to the right
		 * edge of the parent container.
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

		/**
		 * The bottom edge of the layout object will be relative to this anchor.
		 * If there is no anchor, the bottom edge of the parent container will be
		 * the anchor.
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

		/**
		 * The position, in pixels, of the bottom edge relative to <code>bottomAnchor</code>.
		 * If there is no bottom anchor, then the position is relative to the bottom
		 * edge of the parent container.
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

		/**
		 * The left edge of the layout object will be relative to this anchor.
		 * If there is no anchor, the left edge of the parent container will be
		 * the anchor.
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

		/**
		 * The position, in pixels, of the left edge relative to <code>leftAnchor</code>.
		 * If there is no left anchor, then the position is relative to the left
		 * edge of the parent container.
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
	}
}
