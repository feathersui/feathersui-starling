/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

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
	import feathers.utils.display.stageToStarling;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.filters.FragmentFilter;
	import starling.rendering.BatchToken;
	import starling.rendering.Painter;

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
		 * Flag to indicate that the clipping has changed.
		 */
		protected static const INVALIDATION_FLAG_CLIPPING:String = "clipping";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.AutoSizeMode.STAGE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const AUTO_SIZE_MODE_STAGE:String = "stage";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.AutoSizeMode.CONTENT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
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
			if(!value)
			{
				this.mask = null;
			}
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
		protected var _autoSizeMode:String = AutoSizeMode.CONTENT;

		[Inspectable(type="String",enumeration="stage,content")]
		/**
		 * Determines how the layout group will set its own size when its
		 * dimensions (width and height) aren't set explicitly.
		 *
		 * <p>In the following example, the layout group will be sized to
		 * match the stage:</p>
		 *
		 * <listing version="3.0">
		 * group.autoSizeMode = AutoSizeMode.STAGE;</listing>
		 *
		 * <p>Usually defaults to <code>AutoSizeMode.CONTENT</code>. However, if
		 * this component is the root of the Starling display list, defaults to
		 * <code>AutoSizeMode.STAGE</code> instead.</p>
		 *
		 * @see feathers.controls.AutoSizeMode#STAGE
		 * @see feathers.controls.AutoSizeMode#CONTENT
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
				if(this._autoSizeMode == AutoSizeMode.STAGE)
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
				this.items.removeAt(oldIndex);
			}
			this.items.insertAt(index, child);
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
			return super.addChildAt(child, index);
		}

		/**
		 * @private
		 */
		override public function removeChildAt(index:int, dispose:Boolean = false):DisplayObject
		{
			if(index >= 0 && index < this.items.length)
			{
				this.items.removeAt(index);
			}
			var child:DisplayObject = super.removeChildAt(index, dispose);
			if(child is IFeathersControl)
			{
				child.removeEventListener(FeathersEventType.RESIZE, child_resizeHandler);
			}
			if(child is ILayoutDisplayObject)
			{
				child.removeEventListener(FeathersEventType.LAYOUT_DATA_CHANGE, child_layoutDataChangeHandler);
			}
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
			if(oldIndex === index)
			{
				return;
			}
			//the super function already checks if oldIndex < 0, and throws an
			//appropriate error, so no need to do it again!
			
			this.items.removeAt(oldIndex);
			this.items.insertAt(index, child);
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		override public function swapChildrenAt(index1:int, index2:int):void
		{
			super.swapChildrenAt(index1, index2);
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
		override public function hitTest(localPoint:Point):DisplayObject
		{
			var localX:Number = localPoint.x;
			var localY:Number = localPoint.y;
			var result:DisplayObject = super.hitTest(localPoint);
			if(result)
			{
				if(!this._isEnabled)
				{
					return this;
				}
				return result;
			}
			if(!this.visible || !this.touchable)
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
		override public function render(painter:Painter):void
		{
			if(this.requiresRedraw && this.currentBackgroundSkin !== null)
			{
				this.currentBackgroundSkin.setRequiresRedraw();
			}
			if(this.currentBackgroundSkin &&
				this.currentBackgroundSkin.visible &&
				this.currentBackgroundSkin.alpha > 0)
			{
				var mask:DisplayObject = this.currentBackgroundSkin.mask;
				var filter:FragmentFilter = this.currentBackgroundSkin.filter;
				painter.pushState();
				painter.setStateTo(this.currentBackgroundSkin.transformationMatrix, this.currentBackgroundSkin.alpha, this.currentBackgroundSkin.blendMode);
				if(mask !== null)
				{
					painter.drawMask(mask);
				}
				if(filter !== null)
				{
					filter.render(painter);
				}
				else
				{
					this.currentBackgroundSkin.render(painter);
				}
				if(mask !== null)
				{
					painter.eraseMask(mask);
				}
				painter.popState();
			}
			super.render(painter);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			if(this._backgroundSkin && this._backgroundSkin.parent !== this)
			{
				this._backgroundSkin.dispose();
			}
			if(this._backgroundDisabledSkin && this._backgroundDisabledSkin.parent !== this)
			{
				this._backgroundDisabledSkin.dispose();
			}
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
			if(this.stage !== null)
			{
				var starling:Starling = stageToStarling(this.stage);
				//we use starling.root because a pop-up's root and the stage
				//root may be different.
				if(starling.root === this)
				{
					this.autoSizeMode = AutoSizeMode.STAGE;
				}
			}
			super.initialize();
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
				this.handleLayoutResult();
				this.refreshBackgroundLayout();

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
			var oldBackgroundSkin:DisplayObject = this.currentBackgroundSkin;
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
			if(this.currentBackgroundSkin !== oldBackgroundSkin)
			{
				this.setRequiresRedraw();
			}
		}

		/**
		 * @private
		 */
		protected function refreshBackgroundLayout():void
		{
			if(this.currentBackgroundSkin === null)
			{
				return;
			}
			if(this.currentBackgroundSkin.width !== this.actualWidth ||
				this.currentBackgroundSkin.height !== this.actualHeight)
			{
				this.currentBackgroundSkin.width = this.actualWidth;
				this.currentBackgroundSkin.height = this.actualHeight;
				this.setRequiresRedraw();
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
			if(this._autoSizeMode === AutoSizeMode.STAGE &&
				this._explicitWidth !== this._explicitWidth)
			{
				this.viewPortBounds.explicitWidth = this.stage.stageWidth;
			}
			else
			{
				this.viewPortBounds.explicitWidth = this._explicitWidth;
			}
			if(this._autoSizeMode === AutoSizeMode.STAGE &&
					this._explicitHeight !== this._explicitHeight)
			{
				this.viewPortBounds.explicitHeight = this.stage.stageHeight;
			}
			else
			{
				this.viewPortBounds.explicitHeight = this._explicitHeight;
			}
			var minWidth:Number = this._explicitMinWidth;
			if(minWidth !== minWidth) //isNaN
			{
				minWidth = 0;
			}
			var minHeight:Number = this._explicitMinHeight;
			if(minHeight !== minHeight) //isNaN
			{
				minHeight = 0;
			}
			if(this.originalBackgroundWidth === this.originalBackgroundWidth && //!isNaN
				this.originalBackgroundWidth > minWidth)
			{
				minWidth = this.originalBackgroundWidth;
			}
			if(this.originalBackgroundHeight === this.originalBackgroundHeight && //!isNaN
				this.originalBackgroundHeight > minHeight)
			{
				minHeight = this.originalBackgroundHeight;
			}
			this.viewPortBounds.minWidth = minWidth;
			this.viewPortBounds.minHeight = minHeight;
			this.viewPortBounds.maxWidth = this._maxWidth;
			this.viewPortBounds.maxHeight = this._maxHeight;
		}

		/**
		 * @private
		 */
		protected function handleLayoutResult():void
		{
			this.setSizeInternal(this._layoutResult.viewPortWidth,
					this._layoutResult.viewPortHeight, false);
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
			var minWidth:Number = this.viewPortBounds.minWidth;
			var minHeight:Number = this.viewPortBounds.minHeight;
			if(maxX < minWidth)
			{
				maxX = minWidth;
			}
			if(maxY < minHeight)
			{
				maxY = minHeight;
			}
			var maxWidth:Number = this.viewPortBounds.maxWidth;
			var maxHeight:Number = this.viewPortBounds.maxHeight;
			if(maxX > maxWidth)
			{
				maxX = maxWidth;
			}
			if(maxY > maxHeight)
			{
				maxY = maxHeight;
			}
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
		protected function refreshClipRect():void
		{
			if(!this._clipContent)
			{
				return;
			}

			var mask:Quad = this.mask as Quad;
			if(mask)
			{
				mask.x = 0;
				mask.y = 0;
				mask.width = this.actualWidth;
				mask.height = this.actualHeight;
			}
			else
			{
				mask = new Quad(1, 1, 0xff00ff);
				//the initial dimensions cannot be 0 or there's a runtime error,
				//and these values might be 0
				mask.width = this.actualWidth;
				mask.height = this.actualHeight;
				this.mask = mask;
			}
		}

		/**
		 * @private
		 */
		protected function layoutGroup_addedToStageHandler(event:Event):void
		{
			if(this._autoSizeMode == AutoSizeMode.STAGE)
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
