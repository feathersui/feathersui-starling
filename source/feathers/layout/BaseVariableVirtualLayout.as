/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import starling.events.EventDispatcher;
	import starling.errors.AbstractClassError;
	import starling.display.DisplayObject;
	import starling.events.Event;

	/**
	 * Dispatched when a property of the layout changes, indicating that a
	 * redraw is probably needed.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>null</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Dispatched when the layout would like to adjust the container's scroll
	 * position. Typically, this is used when the virtual dimensions of an item
	 * differ from its real dimensions. This event allows the container to
	 * adjust scrolling so that it appears smooth, without jarring jumps or
	 * shifts when an item resizes.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>A <code>flash.geom.Point</code> object
	 *   representing how much the scroll position should be adjusted in both
	 *   horizontal and vertical directions. Measured in pixels.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.SCROLL
	 */
	[Event(name="scroll",type="starling.events.Event")]

	public class BaseVariableVirtualLayout extends EventDispatcher
	{
		/**
		 * Constructor.
		 */
		public function BaseVariableVirtualLayout()
		{
			super();
			if(Object(this).constructor == BaseLinearLayout)
			{
				throw new AbstractClassError()
			}
		}

		/**
		 * @private
		 */
		protected var _virtualCache:Array = [];

		/**
		 * @private
		 */
		protected var _useVirtualLayout:Boolean = true;

		/**
		 * @copy feathers.layout.IVirtualLayout#useVirtualLayout
		 *
		 * @default true
		 */
		public function get useVirtualLayout():Boolean
		{
			return this._useVirtualLayout;
		}

		/**
		 * @private
		 */
		public function set useVirtualLayout(value:Boolean):void
		{
			if(this._useVirtualLayout == value)
			{
				return;
			}
			this._useVirtualLayout = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _typicalItem:DisplayObject;

		/**
		 * @copy feathers.layout.IVirtualLayout#typicalItem
		 *
		 * @see #resetTypicalItemDimensionsOnMeasure
		 * @see #typicalItemWidth
		 * @see #typicalItemHeight
		 */
		public function get typicalItem():DisplayObject
		{
			return this._typicalItem;
		}

		/**
		 * @private
		 */
		public function set typicalItem(value:DisplayObject):void
		{
			if(this._typicalItem == value)
			{
				return;
			}
			this._typicalItem = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _hasVariableItemDimensions:Boolean = false;

		/**
		 * When the layout is virtualized, and this value is true, the items
		 * may have variable dimensions. If false, the items will all share
		 * the same dimensions with the typical item.
		 *
		 * @default false
		 */
		public function get hasVariableItemDimensions():Boolean
		{
			return this._hasVariableItemDimensions;
		}

		/**
		 * @private
		 */
		public function set hasVariableItemDimensions(value:Boolean):void
		{
			if(this._hasVariableItemDimensions == value)
			{
				return;
			}
			this._hasVariableItemDimensions = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @copy feathers.layout.ILayout#requiresLayoutOnScroll
		 */
		public function get requiresLayoutOnScroll():Boolean
		{
			return this._useVirtualLayout;
		}

		/**
		 * @copy feathers.layout.IVariableVirtualLayout#resetVariableVirtualCache()
		 */
		public function resetVariableVirtualCache():void
		{
			this._virtualCache.length = 0;
		}

		/**
		 * @copy feathers.layout.IVariableVirtualLayout#resetVariableVirtualCacheAtIndex()
		 */
		public function resetVariableVirtualCacheAtIndex(index:int, item:DisplayObject = null):void
		{
			delete this._virtualCache[index];
			if(item)
			{
				this._virtualCache[index] = item.height;
				this.dispatchEventWith(Event.CHANGE);
			}
		}

		/**
		 * @copy feathers.layout.IVariableVirtualLayout#addToVariableVirtualCacheAtIndex()
		 */
		public function addToVariableVirtualCacheAtIndex(index:int, item:DisplayObject = null):void
		{
			var heightValue:* = item ? item.height : undefined;
			this._virtualCache.insertAt(index, heightValue);
		}

		/**
		 * @copy feathers.layout.IVariableVirtualLayout#removeFromVariableVirtualCacheAtIndex()
		 */
		public function removeFromVariableVirtualCacheAtIndex(index:int):void
		{
			this._virtualCache.removeAt(index);
		}
	}
}