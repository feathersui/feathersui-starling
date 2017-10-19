/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.supportClasses.LayoutViewPort;
	import feathers.core.IFeathersControl;
	import feathers.core.IFocusContainer;
	import feathers.events.FeathersEventType;
	import feathers.layout.ILayout;
	import feathers.layout.ILayoutDisplayObject;
	import feathers.layout.IVirtualLayout;
	import feathers.skins.IStyleProvider;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	/**
	 * Controls the way that the container's children are positioned and
	 * sized.
	 *
	 * <p>The following example tells the container to use a horizontal layout:</p>
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

	[DefaultProperty("mxmlContent")]
	/**
	 * A generic container that supports layout, scrolling, and a background
	 * skin. For a lighter container, see <code>LayoutGroup</code>, which
	 * focuses specifically on layout without scrolling.
	 *
	 * <p>The following example creates a scroll container with a horizontal
	 * layout and adds two buttons to it:</p>
	 *
	 * <listing version="3.0">
	 * var container:ScrollContainer = new ScrollContainer();
	 * var layout:HorizontalLayout = new HorizontalLayout();
	 * layout.gap = 20;
	 * layout.padding = 20;
	 * container.layout = layout;
	 * this.addChild( container );
	 * 
	 * var yesButton:Button = new Button();
	 * yesButton.label = "Yes";
	 * container.addChild( yesButton );
	 * 
	 * var noButton:Button = new Button();
	 * noButton.label = "No";
	 * container.addChild( noButton );</listing>
	 *
	 * @see ../../../help/scroll-container.html How to use the Feathers ScrollContainer component
	 * @see feathers.controls.LayoutGroup
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class ScrollContainer extends Scroller implements IScrollContainer, IFocusContainer
	{
		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_MXML_CONTENT:String = "mxmlContent";
		
		/**
		 * An alternate style name to use with <code>ScrollContainer</code> to
		 * allow a theme to give it a toolbar style. If a theme does not provide
		 * a style for the toolbar container, the theme will automatically fall
		 * back to using the default scroll container skin.
		 *
		 * <p>An alternate style name should always be added to a component's
		 * <code>styleNameList</code> before the component is initialized. If
		 * the style name is added later, it will be ignored.</p>
		 *
		 * <p>In the following example, the toolbar style is applied to a scroll
		 * container:</p>
		 *
		 * <listing version="3.0">
		 * var container:ScrollContainer = new ScrollContainer();
		 * container.styleNameList.add( ScrollContainer.ALTERNATE_STYLE_NAME_TOOLBAR );
		 * this.addChild( container );</listing>
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const ALTERNATE_STYLE_NAME_TOOLBAR:String = "feathers-toolbar-scroll-container";

		[Deprecated(replacement="feathers.controls.ScrollPolicy.AUTO",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ScrollPolicy.AUTO</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const SCROLL_POLICY_AUTO:String = "auto";

		[Deprecated(replacement="feathers.controls.ScrollPolicy.ON",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ScrollPolicy.ON</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const SCROLL_POLICY_ON:String = "on";

		[Deprecated(replacement="feathers.controls.ScrollPolicy.OFF",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ScrollPolicy.OFF</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const SCROLL_POLICY_OFF:String = "off";

		[Deprecated(replacement="feathers.controls.ScrollBarDisplayMode.FLOAT",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ScrollBarDisplayMode.FLOAT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_FLOAT:String = "float";

		[Deprecated(replacement="feathers.controls.ScrollBarDisplayMode.FIXED",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ScrollBarDisplayMode.FIXED</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_FIXED:String = "fixed";

		[Deprecated(replacement="feathers.controls.ScrollBarDisplayMode.FIXED_FLOAT",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ScrollBarDisplayMode.FIXED_FLOAT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_FIXED_FLOAT:String = "fixedFloat";

		[Deprecated(replacement="feathers.controls.ScrollBarDisplayMode.NONE",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ScrollBarDisplayMode.NONE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_NONE:String = "none";

		[Deprecated(replacement="feathers.layout.RelativePosition.RIGHT",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.RIGHT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const VERTICAL_SCROLL_BAR_POSITION_RIGHT:String = "right";

		[Deprecated(replacement="feathers.layout.RelativePosition.LEFT",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.LEFT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const VERTICAL_SCROLL_BAR_POSITION_LEFT:String = "left";

		[Deprecated(replacement="feathers.controls.ScrollInteractionMode.TOUCH",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ScrollInteractionMode.TOUCH</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const INTERACTION_MODE_TOUCH:String = "touch";

		[Deprecated(replacement="feathers.controls.ScrollInteractionMode.MOUSE",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ScrollInteractionMode.MOUSE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const INTERACTION_MODE_MOUSE:String = "mouse";

		[Deprecated(replacement="feathers.controls.ScrollInteractionMode.TOUCH_AND_SCROLL_BARS",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ScrollInteractionMode.TOUCH_AND_SCROLL_BARS</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const INTERACTION_MODE_TOUCH_AND_SCROLL_BARS:String = "touchAndScrollBars";

		[Deprecated(replacement="feathers.layout.Direction.VERTICAL",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.Direction.VERTICAL</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL:String = "vertical";

		[Deprecated(replacement="feathers.layout.Direction.HORIZONTAL",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.Direction.HORIZONTAL</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL:String = "horizontal";

		[Deprecated(replacement="feathers.controls.DecelerationRate.NORMAL",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.DecelerationRate.NORMAL</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DECELERATION_RATE_NORMAL:Number = 0.998;

		[Deprecated(replacement="feathers.controls.DecelerationRate.FAST",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.DecelerationRate.FAST</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DECELERATION_RATE_FAST:Number = 0.99;

		[Deprecated(replacement="feathers.controls.AutoSizeMode.STAGE",since="3.0.0")]
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

		[Deprecated(replacement="feathers.controls.AutoSizeMode.CONTENT",since="3.0.0")]
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
		 * The default <code>IStyleProvider</code> for all <code>ScrollContainer</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function ScrollContainer()
		{
			super();
			this.layoutViewPort = new LayoutViewPort();
			this.viewPort = this.layoutViewPort;
			this.addEventListener(Event.ADDED_TO_STAGE, scrollContainer_addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, scrollContainer_removedFromStageHandler);
		}

		/**
		 * A flag that indicates if the display list functions like <code>addChild()</code>
		 * and <code>removeChild()</code> will be passed to the internal view
		 * port.
		 */
		protected var displayListBypassEnabled:Boolean = true;

		/**
		 * @private
		 */
		protected var layoutViewPort:LayoutViewPort;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return ScrollContainer.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _isChildFocusEnabled:Boolean = true;

		/**
		 * @copy feathers.core.IFocusContainer#isChildFocusEnabled
		 *
		 * @default true
		 *
		 * @see #isFocusEnabled
		 */
		public function get isChildFocusEnabled():Boolean
		{
			return this._isEnabled && this._isChildFocusEnabled;
		}

		/**
		 * @private
		 */
		public function set isChildFocusEnabled(value:Boolean):void
		{
			this._isChildFocusEnabled = value;
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
			if(this._layout === value)
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
		protected var _autoSizeMode:String = AutoSizeMode.CONTENT;

		[Inspectable(type="String",enumeration="stage,content")]
		/**
		 * Determines how the container will set its own size when its
		 * dimensions (width and height) aren't set explicitly.
		 *
		 * <p>In the following example, the container will be sized to
		 * match the stage:</p>
		 *
		 * <listing version="3.0">
		 * container.autoSizeMode = AutoSizeMode.STAGE;</listing>
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
			this._measureViewPort = this._autoSizeMode != AutoSizeMode.STAGE;
			if(this.stage !== null)
			{
				if(this._autoSizeMode === AutoSizeMode.STAGE)
				{
					this.stage.addEventListener(Event.RESIZE, scrollContainer_stage_resizeHandler);
				}
				else
				{
					this.stage.removeEventListener(Event.RESIZE, scrollContainer_stage_resizeHandler);
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
		 * This is similar to _ignoreChildChanges, but setInvalidationFlag()
		 * may still be called.
		 */
		protected var _ignoreChildChangesButSetFlags:Boolean = false;

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
		 * @inheritDoc
		 */
		public function get numRawChildren():int
		{
			var oldBypass:Boolean = this.displayListBypassEnabled;
			this.displayListBypassEnabled = false;
			var result:int = super.numChildren;
			this.displayListBypassEnabled = oldBypass;
			return result;
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
		 * @inheritDoc
		 */
		public function getRawChildByName(name:String):DisplayObject
		{
			var oldBypass:Boolean = this.displayListBypassEnabled;
			this.displayListBypassEnabled = false;
			var child:DisplayObject = super.getChildByName(name);
			this.displayListBypassEnabled = oldBypass;
			return child;
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
		 * @inheritDoc
		 */
		public function getRawChildAt(index:int):DisplayObject
		{
			var oldBypass:Boolean = this.displayListBypassEnabled;
			this.displayListBypassEnabled = false;
			var child:DisplayObject = super.getChildAt(index);
			this.displayListBypassEnabled = oldBypass;
			return child;
		}

		/**
		 * @inheritDoc
		 */
		public function addRawChild(child:DisplayObject):DisplayObject
		{
			var oldBypass:Boolean = this.displayListBypassEnabled;
			this.displayListBypassEnabled = false;
			if(child.parent == this)
			{
				super.setChildIndex(child, super.numChildren);
			}
			else
			{
				child = super.addChildAt(child, super.numChildren);
			}
			this.displayListBypassEnabled = oldBypass;
			return child;
		}

		/**
		 * @private
		 */
		override public function addChild(child:DisplayObject):DisplayObject
		{
			return this.addChildAt(child, this.numChildren);
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
			var result:DisplayObject = DisplayObjectContainer(this.viewPort).addChildAt(child, index);
			if(result is IFeathersControl)
			{
				result.addEventListener(Event.RESIZE, child_resizeHandler);
			}
			if(result is ILayoutDisplayObject)
			{
				result.addEventListener(FeathersEventType.LAYOUT_DATA_CHANGE, child_layoutDataChangeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_SIZE);
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function addRawChildAt(child:DisplayObject, index:int):DisplayObject
		{
			var oldBypass:Boolean = this.displayListBypassEnabled;
			this.displayListBypassEnabled = false;
			child = super.addChildAt(child, index);
			this.displayListBypassEnabled = oldBypass;
			return child;
		}

		/**
		 * @inheritDoc
		 */
		public function removeRawChild(child:DisplayObject, dispose:Boolean = false):DisplayObject
		{
			var oldBypass:Boolean = this.displayListBypassEnabled;
			this.displayListBypassEnabled = false;
			var index:int = super.getChildIndex(child);
			if(index >= 0)
			{
				super.removeChildAt(index, dispose);
			}
			this.displayListBypassEnabled = oldBypass;
			return child;
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
			var result:DisplayObject = DisplayObjectContainer(this.viewPort).removeChildAt(index, dispose);
			if(result is IFeathersControl)
			{
				result.removeEventListener(Event.RESIZE, child_resizeHandler);
			}
			if(result is ILayoutDisplayObject)
			{
				result.removeEventListener(FeathersEventType.LAYOUT_DATA_CHANGE, child_layoutDataChangeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_SIZE);
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function removeRawChildAt(index:int, dispose:Boolean = false):DisplayObject
		{
			var oldBypass:Boolean = this.displayListBypassEnabled;
			this.displayListBypassEnabled = false;
			var child:DisplayObject =  super.removeChildAt(index, dispose);
			this.displayListBypassEnabled = oldBypass;
			return child;
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
		 * @inheritDoc
		 */
		public function getRawChildIndex(child:DisplayObject):int
		{
			var oldBypass:Boolean = this.displayListBypassEnabled;
			this.displayListBypassEnabled = false;
			var index:int = super.getChildIndex(child);
			this.displayListBypassEnabled = oldBypass;
			return index;
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
		 * @inheritDoc
		 */
		public function setRawChildIndex(child:DisplayObject, index:int):void
		{
			var oldBypass:Boolean = this.displayListBypassEnabled;
			this.displayListBypassEnabled = false;
			super.setChildIndex(child, index);
			this.displayListBypassEnabled = oldBypass;
		}

		/**
		 * @inheritDoc
		 */
		public function swapRawChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			var index1:int = this.getRawChildIndex(child1);
			var index2:int = this.getRawChildIndex(child2);
			if(index1 < 0 || index2 < 0)
			{
				throw new ArgumentError("Not a child of this container");
			}
			var oldBypass:Boolean = this.displayListBypassEnabled;
			this.displayListBypassEnabled = false;
			this.swapRawChildrenAt(index1, index2);
			this.displayListBypassEnabled = oldBypass;
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
		 * @inheritDoc
		 */
		public function swapRawChildrenAt(index1:int, index2:int):void
		{
			var oldBypass:Boolean = this.displayListBypassEnabled;
			this.displayListBypassEnabled = false;
			super.swapChildrenAt(index1, index2);
			this.displayListBypassEnabled = oldBypass;
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
		 * @inheritDoc
		 */
		public function sortRawChildren(compareFunction:Function):void
		{
			var oldBypass:Boolean = this.displayListBypassEnabled;
			this.displayListBypassEnabled = false;
			super.sortChildren(compareFunction);
			this.displayListBypassEnabled = oldBypass;
		}

		/**
		 * Readjusts the layout of the container according to its current
		 * content. Call this method when changes to the content cannot be
		 * automatically detected by the container. For instance, Feathers
		 * components dispatch <code>FeathersEventType.RESIZE</code> when their
		 * width and height values change, but standard Starling display objects
		 * like <code>Sprite</code> and <code>Image</code> do not.
		 */
		public function readjustLayout():void
		{
			this.layoutViewPort.readjustLayout();
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		override public function validate():void
		{
			//for the start of validation, we're going to ignore when children
			//resize or dispatch changes to layout data. this allows subclasses
			//to modify children in draw() before the layout is applied.
			var oldIgnoreChildChanges:Boolean = this._ignoreChildChangesButSetFlags;
			this._ignoreChildChangesButSetFlags = true;
			super.validate();
			//if super.validate() returns without calling draw(), the flag
			//won't be reset before layout is called, so we need reset manually.
			this._ignoreChildChangesButSetFlags = oldIgnoreChildChanges;
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(this.stage !== null)
			{
				//we use starling.root because a pop-up's root and the stage
				//root may be different.
				if(this.stage.starling.root === this)
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
			//children are allowed to change during draw() in a subclass up
			//until it calls super.draw().
			this._ignoreChildChangesButSetFlags = false;

			var layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
			var mxmlContentInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_MXML_CONTENT);

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

			var oldIgnoreChildChanges:Boolean = this._ignoreChildChanges;
			this._ignoreChildChanges = true;
			super.draw();
			this._ignoreChildChanges = oldIgnoreChildChanges;
		}

		/**
		 * @private
		 */
		override protected function autoSizeIfNeeded():Boolean
		{
			var needsWidth:Boolean = this._explicitWidth !== this._explicitWidth; //isNaN
			var needsHeight:Boolean = this._explicitHeight !== this._explicitHeight; //isNaN
			var needsMinWidth:Boolean = this._explicitMinWidth !== this._explicitMinWidth; //isNaN
			var needsMinHeight:Boolean = this._explicitMinHeight !== this._explicitMinHeight; //isNaN
			if(!needsWidth && !needsHeight && !needsMinWidth && !needsMinHeight)
			{
				return false;
			}
			if(this._autoSizeMode === AutoSizeMode.STAGE &&
				this.stage !== null)
			{
				var newWidth:Number = this.stage.stageWidth;
				var newHeight:Number = this.stage.stageHeight;
				return this.saveMeasurements(newWidth, newHeight, newWidth, newHeight);
			}
			return super.autoSizeIfNeeded();
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
		protected function scrollContainer_addedToStageHandler(event:Event):void
		{
			if(this._autoSizeMode === AutoSizeMode.STAGE)
			{
				//if we validated before being added to the stage, or if we've
				//been removed from stage and added again, we need to be sure
				//that the new stage dimensions are accounted for.
				this.invalidate(INVALIDATION_FLAG_SIZE);

				this.stage.addEventListener(Event.RESIZE, scrollContainer_stage_resizeHandler);
			}
		}

		/**
		 * @private
		 */
		protected function scrollContainer_removedFromStageHandler(event:Event):void
		{
			this.stage.removeEventListener(Event.RESIZE, scrollContainer_stage_resizeHandler);
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
			if(this._ignoreChildChangesButSetFlags)
			{
				this.setInvalidationFlag(INVALIDATION_FLAG_SIZE);
				return;
			}
			this.invalidate(INVALIDATION_FLAG_SIZE);
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
			if(this._ignoreChildChangesButSetFlags)
			{
				this.setInvalidationFlag(INVALIDATION_FLAG_SIZE);
				return;
			}
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		protected function scrollContainer_stage_resizeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}
	}
}
