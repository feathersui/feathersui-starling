/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.supportClasses.BaseScrollContainer;
	import feathers.controls.supportClasses.LayoutViewPort;
	import feathers.core.IFeathersControl;
	import feathers.events.FeathersEventType;
	import feathers.layout.ILayout;
	import feathers.layout.IVirtualLayout;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

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
	public class ScrollContainer extends BaseScrollContainer
	{
		/**
		 * The default value added to the <code>nameList</code> of the scroller.
		 */
		public static const DEFAULT_CHILD_NAME_SCROLLER:String = "feathers-scroll-container-scroller";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_MXML_CONTENT:String = "mxmlContent";

		/**
		 * Constructor.
		 */
		public function ScrollContainer()
		{
			this.scrollerName = DEFAULT_CHILD_NAME_SCROLLER;
			this.viewPort = this.layoutViewPort = new LayoutViewPort();
		}


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
			if(this._backgroundSkin == value)
			{
				return;
			}

			if(this._backgroundSkin && this._backgroundSkin != this._backgroundDisabledSkin)
			{
				this.$removeChild(this._backgroundSkin);
			}
			this._backgroundSkin = value;
			if(this._backgroundSkin && this._backgroundSkin.parent != this)
			{
				this._backgroundSkin.visible = false;
				this.$addChildAt(this._backgroundSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override public function set backgroundDisabledSkin(value:DisplayObject):void
		{
			if(this._backgroundDisabledSkin == value)
			{
				return;
			}

			if(this._backgroundDisabledSkin && this._backgroundDisabledSkin != this._backgroundSkin)
			{
				this.$removeChild(this._backgroundDisabledSkin);
			}
			this._backgroundDisabledSkin = value;
			if(this._backgroundDisabledSkin && this._backgroundDisabledSkin.parent != this)
			{
				this._backgroundDisabledSkin.visible = false;
				this.$addChildAt(this._backgroundDisabledSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override public function get numChildren():int
		{
			return DisplayObjectContainer(this.viewPort).numChildren;
		}

		/**
		 * @private
		 */
		protected function get $numChildren():int
		{
			return super.numChildren;
		}

		/**
		 * @private
		 */
		override public function getChildByName(name:String):DisplayObject
		{
			return DisplayObjectContainer(this.viewPort).getChildByName(name);
		}

		/**
		 * @private
		 */
		protected function $getChildByName(name:String):DisplayObject
		{
			return super.getChildByName(name);
		}

		/**
		 * @private
		 */
		override public function getChildAt(index:int):DisplayObject
		{
			return DisplayObjectContainer(this.viewPort).getChildAt(index);
		}

		/**
		 * @private
		 */
		protected function $getChildAt(index:int):DisplayObject
		{
			return super.getChildAt(index);
		}

		/**
		 * @private
		 */
		protected function $addChild(child:DisplayObject):DisplayObject
		{
			return super.addChildAt(child, super.numChildren);
		}

		/**
		 * @private
		 */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return DisplayObjectContainer(this.viewPort).addChildAt(child, index);
		}

		/**
		 * @private
		 */
		protected function $addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return super.addChildAt(child, index);
		}

		/**
		 * @private
		 */
		protected function $removeChild(child:DisplayObject, dispose:Boolean = false):DisplayObject
		{
			const childIndex:int = this.$getChildIndex(child);
			if(childIndex >= 0)
			{
				super.removeChildAt(childIndex, dispose);
			}
			return child;
		}

		/**
		 * @private
		 */
		override public function removeChildAt(index:int, dispose:Boolean = false):DisplayObject
		{
			return DisplayObjectContainer(this.viewPort).removeChildAt(index, dispose);
		}

		/**
		 * @private
		 */
		protected function $removeChildAt(index:int):DisplayObject
		{
			return super.removeChildAt(index);
		}

		/**
		 * @private
		 */
		override public function getChildIndex(child:DisplayObject):int
		{
			return DisplayObjectContainer(this.viewPort).getChildIndex(child);
		}

		/**
		 * @private
		 */
		protected function $getChildIndex(child:DisplayObject):int
		{
			return super.getChildIndex(child);
		}

		/**
		 * @private
		 */
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			DisplayObjectContainer(this.viewPort).setChildIndex(child, index);
		}

		/**
		 * @private
		 */
		protected function $setChildIndex(child:DisplayObject, index:int):void
		{
			this.$removeChild(child);
			this.$addChildAt(child, index);
		}

		/**
		 * @private
		 */
		protected function $swapChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			const index1:int = this.$getChildIndex(child1);
			const index2:int = this.$getChildIndex(child2);
			if (index1 < 0 || index2 < 0)
			{
				throw new ArgumentError("Not a child of this container");
			}
			this.$swapChildrenAt(index1, index2);
		}

		/**
		 * @private
		 */
		override public function swapChildrenAt(index1:int, index2:int):void
		{
			DisplayObjectContainer(this.viewPort).swapChildrenAt(index1, index2);
		}

		/**
		 * @private
		 */
		protected function $swapChildrenAt(index1:int, index2:int):void
		{
			const child1:DisplayObject = this.$getChildAt(index1);
			const child2:DisplayObject = this.$getChildAt(index2);
			this.$removeChild(child1);
			this.$removeChild(child2);
			this.$addChildAt(child2, index1);
			this.$addChildAt(child1, index2);
		}

		/**
		 * @private
		 */
		override public function sortChildren(compareFunction:Function):void
		{
			DisplayObjectContainer(this.viewPort).sortChildren(compareFunction);
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(!this.scroller)
			{
				this.scroller = new Scroller();
				this.scroller.viewPort = this.viewPort;
				this.scroller.nameList.add(this.scrollerName);
				this.scroller.addEventListener(Event.SCROLL, scroller_scrollHandler);
				this.scroller.addEventListener(FeathersEventType.SCROLL_COMPLETE, scroller_scrollCompleteHandler);
				this.scroller.addEventListener(FeathersEventType.RESIZE, scroller_resizeHandler);
				this.$addChildAt(this.scroller, this.$numChildren);
			}

			this.refreshMXMLContent();
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
