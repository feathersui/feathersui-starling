/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.supportClasses.LayoutViewPort;
	import feathers.core.IFeathersControl;
	import feathers.layout.ILayout;
	import feathers.layout.IVirtualLayout;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;

	/**
	 * Dispatched when the container is scrolled.
	 *
	 * @eventType starling.events.Event.SCROLL
	 */
	[Event(name="change",type="starling.events.Event")]

	[DefaultProperty("mxmlContent")]
	/**
	 * A generic container that supports layout and scrolling.
	 *
	 * @see http://wiki.starling-framework.org/feathers/scroll-container
	 */
	public class ScrollContainer extends Scroller
	{
		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_MXML_CONTENT:String = "mxmlContent";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_POLICY_AUTO
		 */
		public static const SCROLL_POLICY_AUTO:String = "auto";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_POLICY_ON
		 */
		public static const SCROLL_POLICY_ON:String = "on";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_POLICY_OFF
		 */
		public static const SCROLL_POLICY_OFF:String = "off";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FLOAT
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_FLOAT:String = "float";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FIXED
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_FIXED:String = "fixed";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_NONE
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_NONE:String = "none";

		/**
		 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH
		 */
		public static const INTERACTION_MODE_TOUCH:String = "touch";

		/**
		 * @copy feathers.controls.Scroller#INTERACTION_MODE_MOUSE
		 */
		public static const INTERACTION_MODE_MOUSE:String = "mouse";

		/**
		 * Constructor.
		 */
		public function ScrollContainer()
		{
			const oldDisplayListBypassEnabled:Boolean = this.displayListBypassEnabled;
			this.displayListBypassEnabled = false;

			super();
			this.layoutViewPort = new LayoutViewPort();
			this.viewPort = this.layoutViewPort;

			this.displayListBypassEnabled = oldDisplayListBypassEnabled;
		}

		protected var displayListBypassEnabled:Boolean = true;

		/**
		 * @private
		 */
		protected var layoutViewPort:LayoutViewPort;

		/**
		 * @private
		 */
		protected var _layout:ILayout;

		/**
		 * Controls the way that the container's children are positioned and
		 * sized.
		 */
		public function get layout():ILayout
		{
			return this._layout;
		}

		/**
		 * @private
		 */
		public function set layout(value:ILayout):void
		{
			if(this._layout == value)
			{
				return;
			}
			this._layout = value;
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		protected var _mxmlContentIsReady:Boolean = false;

		/**
		 * @private
		 */
		protected var _mxmlContent:Array;

		[ArrayElementType("feathers.core.IFeathersControl")]
		/**
		 * @private
		 */
		public function get mxmlContent():Array
		{
			return this._mxmlContent;
		}

		/**
		 * @private
		 */
		public function set mxmlContent(value:Array):void
		{
			if(this._mxmlContent == value)
			{
				return;
			}
			if(this._mxmlContent && this._mxmlContentIsReady)
			{
				for each(var child:IFeathersControl in this._mxmlContent)
				{
					this.removeChild(DisplayObject(child), true);
				}
			}
			this._mxmlContent = value;
			this._mxmlContentIsReady = false;
			this.invalidate(INVALIDATION_FLAG_MXML_CONTENT);
		}

		/**
		 * @private
		 */
		override public function set backgroundSkin(value:DisplayObject):void
		{
			const oldDisplayListBypassEnabled:Boolean = this.displayListBypassEnabled;
			this.displayListBypassEnabled = false;
			super.backgroundSkin = value;
			this.displayListBypassEnabled = oldDisplayListBypassEnabled;
		}

		/**
		 * @private
		 */
		override public function set backgroundDisabledSkin(value:DisplayObject):void
		{
			const oldDisplayListBypassEnabled:Boolean = this.displayListBypassEnabled;
			this.displayListBypassEnabled = false;
			super.backgroundDisabledSkin = value;
			this.displayListBypassEnabled = oldDisplayListBypassEnabled;
		}

		/**
		 * @private
		 */
		override public function get numChildren():int
		{
			if(!this.displayListBypassEnabled)
			{
				return super.numChildren;
			}
			return DisplayObjectContainer(this.viewPort).numChildren;
		}

		/**
		 * @private
		 */
		override public function getChildByName(name:String):DisplayObject
		{
			if(!this.displayListBypassEnabled)
			{
				return super.getChildByName(name);
			}
			return DisplayObjectContainer(this.viewPort).getChildByName(name);
		}

		/**
		 * @private
		 */
		override public function getChildAt(index:int):DisplayObject
		{
			if(!this.displayListBypassEnabled)
			{
				return super.getChildAt(index);
			}
			return DisplayObjectContainer(this.viewPort).getChildAt(index);
		}

		/**
		 * @private
		 */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			if(!this.displayListBypassEnabled)
			{
				return super.addChildAt(child, index);
			}
			return DisplayObjectContainer(this.viewPort).addChildAt(child, index);
		}

		/**
		 * @private
		 */
		override public function removeChildAt(index:int, dispose:Boolean = false):DisplayObject
		{
			if(!this.displayListBypassEnabled)
			{
				return super.removeChildAt(index, dispose);
			}
			return DisplayObjectContainer(this.viewPort).removeChildAt(index, dispose);
		}

		/**
		 * @private
		 */
		override public function getChildIndex(child:DisplayObject):int
		{
			if(!this.displayListBypassEnabled)
			{
				return super.getChildIndex(child);
			}
			return DisplayObjectContainer(this.viewPort).getChildIndex(child);
		}

		/**
		 * @private
		 */
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			if(!this.displayListBypassEnabled)
			{
				super.setChildIndex(child, index);
				return;
			}
			DisplayObjectContainer(this.viewPort).setChildIndex(child, index);
		}

		/**
		 * @private
		 */
		override public function swapChildrenAt(index1:int, index2:int):void
		{
			if(!this.displayListBypassEnabled)
			{
				super.swapChildrenAt(index1, index2);
				return;
			}
			DisplayObjectContainer(this.viewPort).swapChildrenAt(index1, index2);
		}

		/**
		 * @private
		 */
		override public function sortChildren(compareFunction:Function):void
		{
			if(!this.displayListBypassEnabled)
			{
				super.sortChildren(compareFunction);
				return;
			}
			DisplayObjectContainer(this.viewPort).sortChildren(compareFunction);
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			super.initialize();
			this.refreshMXMLContent();
		}

		override public function validate():void
		{
			const oldDisplayListBypassEnabled:Boolean = this.displayListBypassEnabled;
			this.displayListBypassEnabled = false;
			super.validate();
			this.displayListBypassEnabled = oldDisplayListBypassEnabled;
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			const sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			const layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
			const mxmlContentInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_MXML_CONTENT);

			if(mxmlContentInvalid)
			{
				this.refreshMXMLContent();
			}

			if(layoutInvalid)
			{
				if(this._layout is IVirtualLayout)
				{
					IVirtualLayout(this._layout).useVirtualLayout = false;
				}
				this.layoutViewPort.layout = this._layout;
			}

			super.draw();
		}

		/**
		 * @private
		 */
		protected function refreshMXMLContent():void
		{
			if(!this._mxmlContent || this._mxmlContentIsReady)
			{
				return;
			}
			const childCount:int = this._mxmlContent.length;
			for(var i:int = 0; i < childCount; i++)
			{
				var child:DisplayObject = DisplayObject(this._mxmlContent[i]);
				this.addChild(child);
			}
			this._mxmlContentIsReady = true;
		}
	}
}
