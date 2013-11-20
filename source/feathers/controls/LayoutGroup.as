/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.events.FeathersEventType;
	import feathers.layout.ILayout;
	import feathers.layout.ILayoutDisplayObject;
	import feathers.layout.IVirtualLayout;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.ViewPortBounds;

	import flash.geom.Rectangle;

	import starling.display.DisplayObject;
	import starling.events.Event;

	/**
	 * A generic container that supports layout. For a container that supports
	 * scrolling and more robust skinning options, see <code>ScrollContainer</code>.
	 *
	 * <p>The following example creates a layout group with a horizontal
	 * layout and adds two buttons to it:</p>
	 *
	 * <listing version="3.0">
	 * var group:LayoutGroup = new LayoutGroup();
	 * var layout:HorizontalLayout = new HorizontalLayout();
	 * layout.gap = 20;
	 * layout.padding = 20;
	 * group.layout = layout;
	 * this.addChild( group );
	 *
	 * var yesButton:Button = new Button();
	 * yesButton.label = "Yes";
	 * group.addChild( yesButton );
	 *
	 * var noButton:Button = new Button();
	 * noButton.label = "No";
	 * group.addChild( noButton );</listing>
	 *
	 * <p><strong>Beta Component:</strong> This is a new component, and its APIs
	 * may need some changes between now and the next version of Feathers to
	 * account for overlooked requirements or other issues. Upgrading to future
	 * versions of Feathers may involve manual changes to your code that uses
	 * this component. The
	 * <a href="http://wiki.starling-framework.org/feathers/deprecation-policy">Feathers deprecation policy</a>
	 * will not go into effect until this component's status is upgraded from
	 * beta to stable.</p>
	 *
	 * @see http://wiki.starling-framework.org/feathers/layout-group
	 * @see feathers.controls.ScrollContainer
	 */
	public class LayoutGroup extends FeathersControl
	{
		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_MXML_CONTENT:String = "mxmlContent";

		/**
		 * Flag to indicate that the clipping has changed.
		 */
		protected static const INVALIDATION_FLAG_CLIPPING:String = "clipping";

		/**
		 * Constructor.
		 */
		public function LayoutGroup()
		{
		}

		/**
		 * The items added to the group.
		 */
		protected var items:Vector.<DisplayObject> = new <DisplayObject>[];

		/**
		 * The view port bounds result object passed to the layout. Its values
		 * should be set in <code>refreshViewPortBounds()</code>.
		 */
		protected var viewPortBounds:ViewPortBounds = new ViewPortBounds();

		/**
		 * @private
		 */
		protected var _layoutResult:LayoutBoundsResult = new LayoutBoundsResult();

		/**
		 * @private
		 */
		protected var _layout:ILayout;

		/**
		 * Controls the way that the group's children are positioned and sized.
		 *
		 * <p>The following example tells the group to use a horizontal layout:</p>
		 *
		 * <listing version="3.0">
		 * var layout:HorizontalLayout = new HorizontalLayout();
		 * layout.gap = 20;
		 * layout.padding = 20;
		 * container.layout = layout;</listing>
		 *
		 * @default null
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
			if(this._layout)
			{
				this._layout.removeEventListener(Event.CHANGE, layout_changeHandler);
			}
			this._layout = value;
			if(this._layout)
			{
				if(this._layout is IVirtualLayout)
				{
					IVirtualLayout(this._layout).useVirtualLayout = false;
				}
				this._layout.addEventListener(Event.CHANGE, layout_changeHandler);
				//if we don't have a layout, nothing will need to be redrawn
				this.invalidate(INVALIDATION_FLAG_LAYOUT);
			}
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
				const childCount:int = this._mxmlContent.length;
				for(var i:int = 0; i < childCount; i++)
				{
					var child:DisplayObject = DisplayObject(this._mxmlContent[i]);
					this.removeChild(child, true);
				}
			}
			this._mxmlContent = value;
			this._mxmlContentIsReady = false;
			this.invalidate(INVALIDATION_FLAG_MXML_CONTENT);
		}

		/**
		 * @private
		 */
		protected var _clipContent:Boolean = false;

		/**
		 * If true, the group will be clipped to its bounds. In other words,
		 * anything appearing beyond the edges of the group will be masked or
		 * hidden.
		 *
		 * <p>Since <code>LayoutGroup</code> is designed to be a light
		 * container focused on performance, clipping is disabled by default.</p>
		 *
		 * <p>In the following example, clipping is enabled:</p>
		 *
		 * <listing version="3.0">
		 * scroller.clipContent = true;</listing>
		 *
		 * @default false
		 */
		public function get clipContent():Boolean
		{
			return this._clipContent;
		}

		/**
		 * @private
		 */
		public function set clipContent(value:Boolean):void
		{
			if(this._clipContent == value)
			{
				return;
			}
			this._clipContent = value;
			this.invalidate(INVALIDATION_FLAG_CLIPPING);
		}

		/**
		 * @private
		 */
		protected var _ignoreChildChanges:Boolean = false;

		/**
		 * @private
		 */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			if(child is IFeathersControl)
			{
				child.addEventListener(FeathersEventType.RESIZE, child_resizeHandler);
			}
			if(child is ILayoutDisplayObject)
			{
				child.addEventListener(FeathersEventType.LAYOUT_DATA_CHANGE, child_layoutDataChangeHandler);
			}
			this.items.splice(index, 0, child);
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
			return super.addChildAt(child, index);
		}

		/**
		 * @private
		 */
		override public function removeChildAt(index:int, dispose:Boolean = false):DisplayObject
		{
			const child:DisplayObject = super.removeChildAt(index, dispose);
			if(child is IFeathersControl)
			{
				child.removeEventListener(FeathersEventType.RESIZE, child_resizeHandler);
			}
			if(child is ILayoutDisplayObject)
			{
				child.removeEventListener(FeathersEventType.LAYOUT_DATA_CHANGE, child_layoutDataChangeHandler);
			}
			this.items.splice(index, 1);
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
			return child;
		}

		/**
		 * @private
		 */
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			super.setChildIndex(child, index);
			var oldIndex:int = this.items.indexOf(child);
			if(oldIndex == index)
			{
				return;
			}

			//the super function already checks if oldIndex < 0, and throws an
			//appropriate error, so no need to do it again!

			this.items.splice(oldIndex, 1);
			this.items.splice(index, 0, child);
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		override public function swapChildrenAt(index1:int, index2:int):void
		{
			super.swapChildrenAt(index1, index2)
			var child1:DisplayObject = this.items[index1];
			var child2:DisplayObject = this.items[index2];
			this.items[index1] = child2;
			this.items[index2] = child1;
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		override public function sortChildren(compareFunction:Function):void
		{
			super.sortChildren(compareFunction);
			this.items.sort(compareFunction);
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this.layout = null;
			super.dispose();
		}

		/**
		 * Readjusts the layout of the group according to its current content.
		 * Call this method when changes to the content cannot be automatically
		 * detected by the container. For instance, Feathers components dispatch
		 * <code>FeathersEventType.RESIZE</code> when their width and height
		 * values change, but standard Starling display objects like
		 * <code>Sprite</code> and <code>Image</code> do not.
		 */
		public function readjustLayout():void
		{
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			this.refreshMXMLContent();
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			const layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const clippingInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_CLIPPING);
			//we don't have scrolling, but a subclass might
			const scrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);

			if(scrollInvalid || sizeInvalid || layoutInvalid)
			{
				this.refreshViewPortBounds();
				if(this._layout)
				{
					this._ignoreChildChanges = true;
					this._layout.layout(this.items, this.viewPortBounds, this._layoutResult);
					this._ignoreChildChanges = false;
					sizeInvalid = this.setSizeInternal(this._layoutResult.contentWidth, this._layoutResult.contentHeight, false) || sizeInvalid;
				}
				else
				{
					sizeInvalid = this.handleManualLayout() || sizeInvalid;
				}
				//final validation to avoid juggler next frame issues
				this.validateChildren();
			}

			if(sizeInvalid || clippingInvalid)
			{
				this.refreshClipRect();
			}
		}

		/**
		 * Refreshes the values in the <code>viewPortBounds</code> variable that
		 * is passed to the layout.
		 */
		protected function refreshViewPortBounds():void
		{
			this.viewPortBounds.x = 0;
			this.viewPortBounds.y = 0;
			this.viewPortBounds.scrollX = 0;
			this.viewPortBounds.scrollY = 0;
			this.viewPortBounds.explicitWidth = this.explicitWidth;
			this.viewPortBounds.explicitHeight = this.explicitHeight;
			this.viewPortBounds.minWidth = this._minWidth;
			this.viewPortBounds.minHeight = this._minHeight;
			this.viewPortBounds.maxWidth = this._maxWidth;
			this.viewPortBounds.maxHeight = this._maxHeight;
		}

		/**
		 * @private
		 */
		protected function handleManualLayout():Boolean
		{
			var maxX:Number = isNaN(this.viewPortBounds.explicitWidth) ? 0 : this.viewPortBounds.explicitWidth;
			var maxY:Number = isNaN(this.viewPortBounds.explicitHeight) ? 0 : this.viewPortBounds.explicitHeight;
			this._ignoreChildChanges = true;
			const itemCount:int = this.items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = this.items[i];
				if(item is IFeathersControl)
				{
					IFeathersControl(item).validate();
				}
				var itemMaxX:Number = item.x + item.width;
				var itemMaxY:Number = item.y + item.height;
				if(!isNaN(itemMaxX) && itemMaxX > maxX)
				{
					maxX = itemMaxX;
				}
				if(!isNaN(itemMaxY) && itemMaxY > maxY)
				{
					maxY = itemMaxY;
				}
			}
			this._ignoreChildChanges = false;
			return this.setSizeInternal(maxX, maxY, false)
		}

		/**
		 * @private
		 */
		protected function validateChildren():void
		{
			const itemCount:int = this.items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = this.items[i];
				if(item is IFeathersControl)
				{
					IFeathersControl(item).validate();
				}
			}
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

		/**
		 * @private
		 */
		protected function refreshClipRect():void
		{
			if(this._clipContent)
			{
				if(!this.clipRect)
				{
					this.clipRect = new Rectangle();
				}

				const clipRect:Rectangle = this.clipRect;
				clipRect.x = 0;
				clipRect.y = 0;
				clipRect.width = this.actualWidth;
				clipRect.height = this.actualHeight;
				this.clipRect = clipRect;
			}
			else
			{
				this.clipRect = null;
			}
		}

		/**
		 * @private
		 */
		protected function layout_changeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		protected function child_resizeHandler(event:Event):void
		{
			if(this._ignoreChildChanges)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		protected function child_layoutDataChangeHandler(event:Event):void
		{
			if(this._ignoreChildChanges)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}
	}
}
