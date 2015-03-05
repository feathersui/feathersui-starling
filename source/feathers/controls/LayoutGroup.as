/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.IValidating;
	import feathers.events.FeathersEventType;
	import feathers.layout.ILayout;
	import feathers.layout.ILayoutDisplayObject;
	import feathers.layout.IVirtualLayout;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.ViewPortBounds;
	import feathers.skins.IStyleProvider;

	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[DefaultProperty("mxmlContent")]
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
	 * @see ../../../help/layout-group.html How to use the Feathers LayoutGroup component
	 * @see feathers.controls.ScrollContainer
	 */
	public class LayoutGroup extends FeathersControl
	{
		/**
		 * @private
		 */
		private static const HELPER_RECTANGLE:Rectangle = new Rectangle();

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_MXML_CONTENT:String = "mxmlContent";

		/**
		 * Flag to indicate that the clipping has changed.
		 */
		protected static const INVALIDATION_FLAG_CLIPPING:String = "clipping";

		/**
		 * The layout group will auto size itself to fill the entire stage.
		 *
		 * @see #autoSizeMode
		 */
		public static const AUTO_SIZE_MODE_STAGE:String = "stage";

		/**
		 * The layout group will auto size itself to fit its content.
		 *
		 * @see #autoSizeMode
		 */
		public static const AUTO_SIZE_MODE_CONTENT:String = "content";

		/**
		 * An alternate style name to use with <code>LayoutGroup</code> to
		 * allow a theme to give it a toolbar style. If a theme does not provide
		 * a style for the toolbar container, the theme will automatically fall
		 * back to using the default scroll container skin.
		 *
		 * <p>An alternate style name should always be added to a component's
		 * <code>styleNameList</code> before the component is initialized. If
		 * the style name is added later, it will be ignored.</p>
		 *
		 * <p>In the following example, the toolbar style is applied to a layout
		 * group:</p>
		 *
		 * <listing version="3.0">
		 * var group:LayoutGroup = new LayoutGroup();
		 * group.styleNameList.add( LayoutGroup.ALTERNATE_STYLE_NAME_TOOLBAR );
		 * this.addChild( group );</listing>
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const ALTERNATE_STYLE_NAME_TOOLBAR:String = "feathers-toolbar-layout-group";

		/**
		 * The default <code>IStyleProvider</code> for all <code>LayoutGroup</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function LayoutGroup()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, layoutGroup_addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, layoutGroup_removedFromStageHandler);
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
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return LayoutGroup.globalStyleProvider;
		}

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
				var childCount:int = this._mxmlContent.length;
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
		 * group.clipContent = true;</listing>
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
		protected var originalBackgroundWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var originalBackgroundHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var currentBackgroundSkin:DisplayObject;

		/**
		 * @private
		 */
		protected var _backgroundSkin:DisplayObject;

		/**
		 * The default background to display behind all content. The background
		 * skin is resized to fill the full width and height of the layout
		 * group.
		 *
		 * <p>In the following example, the group is given a background skin:</p>
		 *
		 * <listing version="3.0">
		 * group.backgroundSkin = new Image( texture );</listing>
		 *
		 * @default null
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
			if(value && value.parent)
			{
				value.removeFromParent();
			}
			this._backgroundSkin = value;
			this.invalidate(INVALIDATION_FLAG_SKIN);
		}

		/**
		 * @private
		 */
		protected var _backgroundDisabledSkin:DisplayObject;

		/**
		 * The background to display behind all content when the layout group is
		 * disabled. The background skin is resized to fill the full width and
		 * height of the layout group.
		 *
		 * <p>In the following example, the group is given a background skin:</p>
		 *
		 * <listing version="3.0">
		 * group.backgroundDisabledSkin = new Image( texture );</listing>
		 *
		 * @default null
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
			if(value && value.parent)
			{
				value.removeFromParent();
			}
			this._backgroundDisabledSkin = value;
			this.invalidate(INVALIDATION_FLAG_SKIN);
		}

		/**
		 * @private
		 */
		protected var _autoSizeMode:String = AUTO_SIZE_MODE_CONTENT;

		[Inspectable(type="String",enumeration="stage,content")]
		/**
		 * Determines how the layout group will set its own size when its
		 * dimensions (width and height) aren't set explicitly.
		 *
		 * <p>In the following example, the layout group will be sized to
		 * match the stage:</p>
		 *
		 * <listing version="3.0">
		 * group.autoSizeMode = LayoutGroup.AUTO_SIZE_MODE_STAGE;</listing>
		 *
		 * @default LayoutGroup.AUTO_SIZE_MODE_CONTENT
		 *
		 * @see #AUTO_SIZE_MODE_STAGE
		 * @see #AUTO_SIZE_MODE_CONTENT
		 */
		public function get autoSizeMode():String
		{
			return this._autoSizeMode;
		}

		/**
		 * @private
		 */
		public function set autoSizeMode(value:String):void
		{
			if(this._autoSizeMode == value)
			{
				return;
			}
			this._autoSizeMode = value;
			if(this.stage)
			{
				if(this._autoSizeMode == AUTO_SIZE_MODE_STAGE)
				{
					this.stage.addEventListener(Event.RESIZE, stage_resizeHandler);
				}
				else
				{
					this.stage.removeEventListener(Event.RESIZE, stage_resizeHandler);
				}
			}
			this.invalidate(INVALIDATION_FLAG_SIZE);
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
			var oldIndex:int = this.items.indexOf(child);
			if(oldIndex == index)
			{
				return child;
			}
			if(oldIndex >= 0)
			{
				this.items.splice(oldIndex, 1);
			}
			var itemCount:int = this.items.length;
			if(index == itemCount)
			{
				//faster than splice because it avoids gc
				this.items[index] = child;
			}
			else
			{
				this.items.splice(index, 0, child);
			}
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
			return super.addChildAt(child, index);
		}

		/**
		 * @private
		 */
		override public function removeChildAt(index:int, dispose:Boolean = false):DisplayObject
		{
			var child:DisplayObject = super.removeChildAt(index, dispose);
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
		override public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			var localX:Number = localPoint.x;
			var localY:Number = localPoint.y;
			var result:DisplayObject = super.hitTest(localPoint, forTouch);
			if(result)
			{
				if(!this._isEnabled)
				{
					return this;
				}
				return result;
			}
			if(forTouch && (!this.visible || !this.touchable))
			{
				return null;
			}
			if(this.currentBackgroundSkin && this._hitArea.contains(localX, localY))
			{
				return this;
			}
			return null;
		}

		/**
		 * @private
		 */
		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			if(this.currentBackgroundSkin && this.currentBackgroundSkin.hasVisibleArea)
			{
				var clipRect:Rectangle = this.clipRect;
				if(clipRect)
				{
					clipRect = support.pushClipRect(this.getClipRect(stage, HELPER_RECTANGLE));
					if(clipRect.isEmpty())
					{
						// empty clipping bounds - no need to render children.
						support.popClipRect();
						return;
					}
				}
				var blendMode:String = this.blendMode;
				support.pushMatrix();
				support.transformMatrix(this.currentBackgroundSkin);
				support.blendMode = this.currentBackgroundSkin.blendMode;
				this.currentBackgroundSkin.render(support, parentAlpha * this.alpha);
				support.blendMode = blendMode;
				support.popMatrix();
				if(clipRect)
				{
					support.popClipRect();
				}
			}
			super.render(support, parentAlpha);
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
			var layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var clippingInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_CLIPPING);
			//we don't have scrolling, but a subclass might
			var scrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
			var skinInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SKIN);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var mxmlContentInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_MXML_CONTENT);

			if(mxmlContentInvalid)
			{
				this.refreshMXMLContent();
			}

			//scrolling only affects the layout is requiresLayoutOnScroll is true
			if(!layoutInvalid && scrollInvalid && this._layout && this._layout.requiresLayoutOnScroll)
			{
				layoutInvalid = true;
			}

			if(skinInvalid || stateInvalid)
			{
				this.refreshBackgroundSkin();
			}

			if(sizeInvalid || layoutInvalid || skinInvalid || stateInvalid)
			{
				this.refreshViewPortBounds();
				if(this._layout)
				{
					var oldIgnoreChildChanges:Boolean = this._ignoreChildChanges;
					this._ignoreChildChanges = true;
					this._layout.layout(this.items, this.viewPortBounds, this._layoutResult);
					this._ignoreChildChanges = oldIgnoreChildChanges;
				}
				else
				{
					this.handleManualLayout();
				}
				var width:Number = this._layoutResult.contentWidth;
				if(this.originalBackgroundWidth === this.originalBackgroundWidth && //!isNaN
					this.originalBackgroundWidth > width)
				{
					width = this.originalBackgroundWidth;
				}
				var height:Number = this._layoutResult.contentHeight;
				if(this.originalBackgroundHeight === this.originalBackgroundHeight && //!isNaN
					this.originalBackgroundHeight > height)
				{
					height = this.originalBackgroundHeight;
				}
				if(this._autoSizeMode == AUTO_SIZE_MODE_STAGE)
				{
					width = this.stage.stageWidth;
					height = this.stage.stageHeight;
				}
				sizeInvalid = this.setSizeInternal(width, height, false) || sizeInvalid;
				if(this.currentBackgroundSkin)
				{
					this.currentBackgroundSkin.width = this.actualWidth;
					this.currentBackgroundSkin.height = this.actualHeight;
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
		 * Choose the appropriate background skin based on the control's current
		 * state.
		 */
		protected function refreshBackgroundSkin():void
		{
			if(!this._isEnabled && this._backgroundDisabledSkin)
			{
				this.currentBackgroundSkin = this._backgroundDisabledSkin;
			}
			else
			{
				this.currentBackgroundSkin = this._backgroundSkin
			}
			if(this.currentBackgroundSkin)
			{
				if(this.originalBackgroundWidth !== this.originalBackgroundWidth ||
					this.originalBackgroundHeight !== this.originalBackgroundHeight) //isNaN
				{
					if(this.currentBackgroundSkin is IValidating)
					{
						IValidating(this.currentBackgroundSkin).validate();
					}
					this.originalBackgroundWidth = this.currentBackgroundSkin.width;
					this.originalBackgroundHeight = this.currentBackgroundSkin.height;
				}
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
			if(this._autoSizeMode == AUTO_SIZE_MODE_STAGE &&
				this.explicitWidth !== this.explicitWidth)
			{
				this.viewPortBounds.explicitWidth = this.stage.stageWidth;
			}
			else
			{
				this.viewPortBounds.explicitWidth = this.explicitWidth;
			}
			if(this._autoSizeMode == AUTO_SIZE_MODE_STAGE &&
					this.explicitHeight !== this.explicitHeight)
			{
				this.viewPortBounds.explicitHeight = this.stage.stageHeight;
			}
			else
			{
				this.viewPortBounds.explicitHeight = this.explicitHeight;
			}
			this.viewPortBounds.minWidth = this._minWidth;
			this.viewPortBounds.minHeight = this._minHeight;
			this.viewPortBounds.maxWidth = this._maxWidth;
			this.viewPortBounds.maxHeight = this._maxHeight;
		}

		/**
		 * @private
		 */
		protected function handleManualLayout():void
		{
			var maxX:Number = this.viewPortBounds.explicitWidth;
			if(maxX !== maxX) //isNaN
			{
				maxX = 0;
			}
			var maxY:Number = this.viewPortBounds.explicitHeight;
			if(maxY !== maxY) //isNaN
			{
				maxY = 0;
			}
			var oldIgnoreChildChanges:Boolean = this._ignoreChildChanges;
			this._ignoreChildChanges = true;
			var itemCount:int = this.items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = this.items[i];
				if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
				{
					continue;
				}
				if(item is IValidating)
				{
					IValidating(item).validate();
				}
				var itemMaxX:Number = item.x + item.width;
				var itemMaxY:Number = item.y + item.height;
				if(itemMaxX === itemMaxX && //!isNaN
					itemMaxX > maxX)
				{
					maxX = itemMaxX;
				}
				if(itemMaxY === itemMaxY && //!isNaN
					itemMaxY > maxY)
				{
					maxY = itemMaxY;
				}
			}
			this._ignoreChildChanges = oldIgnoreChildChanges;
			this._layoutResult.contentX = 0;
			this._layoutResult.contentY = 0;
			this._layoutResult.contentWidth = maxX;
			this._layoutResult.contentHeight = maxY;
			this._layoutResult.viewPortWidth = maxX;
			this._layoutResult.viewPortHeight = maxY;
		}

		/**
		 * @private
		 */
		protected function validateChildren():void
		{
			if(this.currentBackgroundSkin is IValidating)
			{
				IValidating(this.currentBackgroundSkin).validate();
			}
			var itemCount:int = this.items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = this.items[i];
				if(item is IValidating)
				{
					IValidating(item).validate();
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
			var childCount:int = this._mxmlContent.length;
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

				var clipRect:Rectangle = this.clipRect;
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
		protected function layoutGroup_addedToStageHandler(event:Event):void
		{
			if(this._autoSizeMode == AUTO_SIZE_MODE_STAGE)
			{
				this.stage.addEventListener(Event.RESIZE, stage_resizeHandler);
			}
		}

		/**
		 * @private
		 */
		protected function layoutGroup_removedFromStageHandler(event:Event):void
		{
			this.stage.removeEventListener(Event.RESIZE, stage_resizeHandler);
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

		/**
		 * @private
		 */
		protected function stage_resizeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}
	}
}
