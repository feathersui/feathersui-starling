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
	import feathers.core.IMeasureDisplayObject;
	import feathers.core.IValidating;
	import feathers.events.FeathersEventType;
	import feathers.layout.ILayout;
	import feathers.layout.ILayoutDisplayObject;
	import feathers.layout.IVirtualLayout;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.ViewPortBounds;
	import feathers.skins.IStyleProvider;
	import feathers.utils.display.stageToStarling;
	import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;

	import flash.geom.Point;

	import starling.core.Starling;
	import starling.core.starling_internal;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.filters.FragmentFilter;
	import starling.rendering.Painter;

	[DefaultProperty("mxmlContent")]
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
	 * 
	 * @see #style:backgroundSkin
	 */
	[Style(name="backgroundDisabledSkin",type="starling.display.DisplayObject")]

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
	 * 
	 * @see #style:backgroundDisabledSkin
	 */
	[Style(name="backgroundSkin",type="starling.display.DisplayObject")]

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
	[Style(name="clipContent",type="Boolean")]

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
	[Style(name="layout",type="feathers.layout.ILayout")]

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
		protected static const INVALIDATION_FLAG_MXML_CONTENT:String = "mxmlContent";

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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._clipContent === value)
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
		protected var _explicitBackgroundWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundMinWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundMinHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundMaxWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundMaxHeight:Number;

		/**
		 * @private
		 */
		protected var currentBackgroundSkin:DisplayObject;

		/**
		 * @private
		 */
		protected var _backgroundSkin:DisplayObject;

		/**
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._backgroundSkin === value)
			{
				return;
			}
			if(value !== null && value.parent !== null)
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._backgroundDisabledSkin === value)
			{
				return;
			}
			if(value !== null && value.parent !== null)
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
			if(this.stage !== null)
			{
				if(this._autoSizeMode === AutoSizeMode.STAGE)
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
			if(this.currentBackgroundSkin !== null &&
				this.currentBackgroundSkin.visible &&
				this.currentBackgroundSkin.alpha > 0)
			{
				//render() won't be called unless the LayoutGroup requires a
				//redraw, so it's not a performance issue to set this flag on
				//the background skin.
				//this is needed to ensure that the background skin position and
				//things are properly updated when the LayoutGroup is
				//transformed
				this.currentBackgroundSkin.setRequiresRedraw();
				
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
			if(this.currentBackgroundSkin !== null)
			{
				this.currentBackgroundSkin.starling_internal::setParent(null);
			}
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
			this.currentBackgroundSkin = this.getCurrentBackgroundSkin();
			if(this.currentBackgroundSkin !== oldBackgroundSkin)
			{
				this.setRequiresRedraw();
				if(oldBackgroundSkin !== null)
				{
					oldBackgroundSkin.starling_internal::setParent(null);
				}
				if(this.currentBackgroundSkin !== null)
				{
					this.currentBackgroundSkin.starling_internal::setParent(this);
					if(this.currentBackgroundSkin is IFeathersControl)
					{
						IFeathersControl(this.currentBackgroundSkin).initializeNow();
					}
					if(this.currentBackgroundSkin is IMeasureDisplayObject)
					{
						var measureSkin:IMeasureDisplayObject = IMeasureDisplayObject(this.currentBackgroundSkin);
						this._explicitBackgroundWidth = measureSkin.explicitWidth;
						this._explicitBackgroundHeight = measureSkin.explicitHeight;
						this._explicitBackgroundMinWidth = measureSkin.explicitMinWidth;
						this._explicitBackgroundMinHeight = measureSkin.explicitMinHeight;
						this._explicitBackgroundMaxWidth = measureSkin.explicitMaxWidth;
						this._explicitBackgroundMaxHeight = measureSkin.explicitMaxHeight;
					}
					else
					{
						this._explicitBackgroundWidth = this.currentBackgroundSkin.width;
						this._explicitBackgroundHeight = this.currentBackgroundSkin.height;
						this._explicitBackgroundMinWidth = this._explicitBackgroundWidth;
						this._explicitBackgroundMinHeight = this._explicitBackgroundHeight;
						this._explicitBackgroundMaxWidth = this._explicitBackgroundWidth;
						this._explicitBackgroundMaxHeight = this._explicitBackgroundHeight;
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function getCurrentBackgroundSkin():DisplayObject
		{
			if(!this._isEnabled && this._backgroundDisabledSkin !== null)
			{
				return this._backgroundDisabledSkin;
			}
			return this._backgroundSkin;
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
			}
		}

		/**
		 * Refreshes the values in the <code>viewPortBounds</code> variable that
		 * is passed to the layout.
		 */
		protected function refreshViewPortBounds():void
		{
			var needsWidth:Boolean = this._explicitWidth !== this._explicitWidth;
			var needsHeight:Boolean = this._explicitHeight !== this._explicitHeight;
			var needsMinWidth:Boolean = this._explicitMinWidth !== this._explicitMinWidth;
			var needsMinHeight:Boolean = this._explicitMinHeight !== this._explicitMinHeight;

			resetFluidChildDimensionsForMeasurement(this.currentBackgroundSkin,
				this._explicitWidth, this._explicitHeight,
				this._explicitMinWidth, this._explicitMinHeight,
				this._explicitMaxWidth, this._explicitMaxHeight,
				this._explicitBackgroundWidth, this._explicitBackgroundHeight,
				this._explicitBackgroundMinWidth, this._explicitBackgroundMinHeight,
				this._explicitBackgroundMaxWidth, this._explicitBackgroundMaxHeight);
			
			this.viewPortBounds.x = 0;
			this.viewPortBounds.y = 0;
			this.viewPortBounds.scrollX = 0;
			this.viewPortBounds.scrollY = 0;
			if(needsWidth && this._autoSizeMode === AutoSizeMode.STAGE &&
				this.stage !== null)
			{
				this.viewPortBounds.explicitWidth = this.stage.stageWidth;
			}
			else
			{
				this.viewPortBounds.explicitWidth = this._explicitWidth;
			}
			if(needsHeight && this._autoSizeMode === AutoSizeMode.STAGE &&
				this.stage !== null)
			{
				this.viewPortBounds.explicitHeight = this.stage.stageHeight;
			}
			else
			{
				this.viewPortBounds.explicitHeight = this._explicitHeight;
			}
			var viewPortMinWidth:Number = this._explicitMinWidth;
			if(needsMinWidth)
			{
				viewPortMinWidth = 0;
			}
			var viewPortMinHeight:Number = this._explicitMinHeight;
			if(needsMinHeight)
			{
				viewPortMinHeight = 0;
			}
			if(this.currentBackgroundSkin !== null)
			{
				//because the layout might need it, we account for the
				//dimensions of the background skin when determining the minimum
				//dimensions of the view port.
				//we can't use the minimum dimensions of the background skin
				if(this.currentBackgroundSkin.width > viewPortMinWidth)
				{
					viewPortMinWidth = this.currentBackgroundSkin.width;
				}
				if(this.currentBackgroundSkin.height > viewPortMinHeight)
				{
					viewPortMinHeight = this.currentBackgroundSkin.height;
				}
			}
			this.viewPortBounds.minWidth = viewPortMinWidth;
			this.viewPortBounds.minHeight = viewPortMinHeight;
			this.viewPortBounds.maxWidth = this._explicitMaxWidth;
			this.viewPortBounds.maxHeight = this._explicitMaxHeight;
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
		protected function handleLayoutResult():void
		{
			//the layout's dimensions are also the minimum dimensions
			//we calculate the minimum dimensions for the background skin in 
			//refreshViewPortBounds() and let the layout handle it
			var viewPortWidth:Number = this._layoutResult.viewPortWidth;
			var viewPortHeight:Number = this._layoutResult.viewPortHeight;
			this.saveMeasurements(viewPortWidth, viewPortHeight,
				viewPortWidth, viewPortHeight);
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
				var itemMaxX:Number = item.x - item.pivotX + item.width;
				var itemMaxY:Number = item.y - item.pivotY + item.height;
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
			var viewPortMinWidth:Number = this.viewPortBounds.minWidth;
			var viewPortMinHeight:Number = this.viewPortBounds.minHeight;
			if(maxX < viewPortMinWidth)
			{
				maxX = viewPortMinWidth;
			}
			if(maxY < viewPortMinHeight)
			{
				maxY = viewPortMinHeight;
			}
			var viewPortMaxWidth:Number = this.viewPortBounds.maxWidth;
			var viewPortMaxHeight:Number = this.viewPortBounds.maxHeight;
			if(maxX > viewPortMaxWidth)
			{
				maxX = viewPortMaxWidth;
			}
			if(maxY > viewPortMaxHeight)
			{
				maxY = viewPortMaxHeight;
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
			if(this._autoSizeMode === AutoSizeMode.STAGE)
			{
				//if we validated before being added to the stage, or if we've
				//been removed from stage and added again, we need to be sure
				//that the new stage dimensions are accounted for.
				this.invalidate(INVALIDATION_FLAG_SIZE);

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
