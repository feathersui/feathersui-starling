/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.renderers
{
	import feathers.controls.ButtonState;
	import feathers.controls.ImageLoader;
	import feathers.controls.ItemRendererLayoutOrder;
	import feathers.controls.Scroller;
	import feathers.controls.ToggleButton;
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.IFocusContainer;
	import feathers.core.IMeasureDisplayObject;
	import feathers.core.IStateObserver;
	import feathers.core.ITextRenderer;
	import feathers.core.IValidating;
	import feathers.core.PropertyProxy;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.RelativePosition;
	import feathers.layout.VerticalAlign;
	import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;

	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * An abstract class for item renderer implementations.
	 */
	public class BaseDefaultItemRenderer extends ToggleButton implements IFocusContainer
	{
		/**
		 * An alternate style name to use with the default item renderer to
		 * allow a theme to give it a "drill-down" style. If a theme
		 * does not provide a style for a drill-down item renderer, the theme
		 * will automatically fall back to using the default item renderer
		 * style.
		 *
		 * <p>An alternate style name should always be added to a component's
		 * <code>styleNameList</code> before the component is initialized. If
		 * the style name is added later, it will be ignored.</p>
		 *
		 * <p>In the following example, the drill-down style is applied to
		 * a list's item renderers:</p>
		 *
		 * <listing version="3.0">
		 * list.itemRendererFactory = function():IListItemRenderer
		 * {
		 *     var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
		 *     itemRenderer.styleNameList.add( DefaultListItemRenderer.ALTERNATE_STYLE_NAME_DRILL_DOWN );
		 *     return itemRenderer;
		 * };</listing>
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const ALTERNATE_STYLE_NAME_DRILL_DOWN:String = "feathers-drill-down-item-renderer";
		
		/**
		 * An alternate style name to use with the default item renderer to
		 * allow a theme to give it a "check" style. If a theme does not provide
		 * a style for a check item renderer, the theme will automatically fall
		 * back to using the default item renderer style.
		 *
		 * <p>An alternate style name should always be added to a component's
		 * <code>styleNameList</code> before the component is initialized. If
		 * the style name is added later, it will be ignored.</p>
		 *
		 * <p>In the following example, the check item renderer style is applied
		 * to a list's item renderers:</p>
		 *
		 * <listing version="3.0">
		 * list.itemRendererFactory = function():IListItemRenderer
		 * {
		 *     var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
		 *     itemRenderer.styleNameList.add( DefaultListItemRenderer.ALTERNATE_STYLE_NAME_CHECK );
		 *     return itemRenderer;
		 * };</listing>
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const ALTERNATE_STYLE_NAME_CHECK:String = "feathers-check-item-renderer";
		
		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * primary label.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_LABEL:String = "feathers-item-renderer-label";
		
		/**
		 * The default value added to the <code>styleNameList</code> of the icon
		 * label, if it exists.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_ICON_LABEL:String = "feathers-item-renderer-icon-label";

		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * accessory label, if it exists.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL:String = "feathers-item-renderer-accessory-label";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.UP</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_UP:String = "up";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.DOWN</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_DOWN:String = "down";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.HOVER</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_HOVER:String = "hover";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.DISABLED</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_DISABLED:String = "disabled";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.UP_AND_SELECTED</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_UP_AND_SELECTED:String = "upAndSelected";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.DOWN_AND_SELECTED</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_DOWN_AND_SELECTED:String = "downAndSelected";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.HOVER_AND_SELECTED</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_HOVER_AND_SELECTED:String = "hoverAndSelected";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.DISABLED_AND_SELECTED</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_DISABLED_AND_SELECTED:String = "disabledAndSelected";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.TOP</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ICON_POSITION_TOP:String = "top";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.RIGHT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ICON_POSITION_RIGHT:String = "right";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.BOTTOM</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ICON_POSITION_BOTTOM:String = "bottom";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.LEFT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ICON_POSITION_LEFT:String = "left";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.MANUAL</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ICON_POSITION_MANUAL:String = "manual";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.LEFT_BASELINE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ICON_POSITION_LEFT_BASELINE:String = "leftBaseline";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.RIGHT_BASELINE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ICON_POSITION_RIGHT_BASELINE:String = "rightBaseline";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.HorizontalAlign.LEFT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const HORIZONTAL_ALIGN_LEFT:String = "left";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.HorizontalAlign.CENTER</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const HORIZONTAL_ALIGN_CENTER:String = "center";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.HorizontalAlign.RIGHT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const HORIZONTAL_ALIGN_RIGHT:String = "right";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.VerticalAlign.TOP</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const VERTICAL_ALIGN_TOP:String = "top";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.VerticalAlign.MIDDLE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.VerticalAlign.BOTTOM</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.TOP</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ACCESSORY_POSITION_TOP:String = "top";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.RIGHT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ACCESSORY_POSITION_RIGHT:String = "right";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.BOTTOM</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ACCESSORY_POSITION_BOTTOM:String = "bottom";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.LEFT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ACCESSORY_POSITION_LEFT:String = "left";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.MANUAL</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ACCESSORY_POSITION_MANUAL:String = "manual";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ItemRendererLayoutOrder.LABEL_ACCESSORY_ICON</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const LAYOUT_ORDER_LABEL_ACCESSORY_ICON:String = "labelAccessoryIcon";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ItemRendererLayoutOrder.LABEL_ICON_ACCESSORY</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const LAYOUT_ORDER_LABEL_ICON_ACCESSORY:String = "labelIconAccessory";

		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * @private
		 */
		protected static var DOWN_STATE_DELAY_MS:int = 250;

		/**
		 * @private
		 */
		protected static function defaultLoaderFactory():ImageLoader
		{
			return new ImageLoader();
		}

		/**
		 * Constructor.
		 */
		public function BaseDefaultItemRenderer()
		{
			super();
			this._explicitIsEnabled = this._isEnabled;
			this.labelStyleName = DEFAULT_CHILD_STYLE_NAME_LABEL;
			this.isFocusEnabled = false;
			this.isQuickHitAreaEnabled = false;
			this.addEventListener(Event.REMOVED_FROM_STAGE, itemRenderer_removedFromStageHandler);
		}

		/**
		 * The value added to the <code>styleNameList</code> of the icon label
		 * text renderer, if it exists.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var iconLabelStyleName:String = DEFAULT_CHILD_STYLE_NAME_ICON_LABEL;

		/**
		 * The value added to the <code>styleNameList</code> of the accessory
		 * label text renderer, if it exists.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var accessoryLabelStyleName:String = DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL;

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
		protected var skinLoader:ImageLoader;

		/**
		 * @private
		 */
		protected var iconLoader:ImageLoader;

		/**
		 * @private
		 */
		protected var iconLabel:ITextRenderer;

		/**
		 * @private
		 */
		protected var accessoryLoader:ImageLoader;

		/**
		 * @private
		 */
		protected var accessoryLabel:ITextRenderer;

		/**
		 * @private
		 */
		protected var currentAccessory:DisplayObject;

		/**
		 * @private
		 */
		protected var _skinIsFromItem:Boolean = false;

		/**
		 * @private
		 */
		protected var _iconIsFromItem:Boolean = false;

		/**
		 * @private
		 */
		protected var _accessoryIsFromItem:Boolean = false;

		/**
		 * @private
		 */
		override public function set defaultIcon(value:DisplayObject):void
		{
			if(this._defaultIcon === value)
			{
				return;
			}
			this.replaceIcon(null);
			this._iconIsFromItem = false;
			super.defaultIcon = value;
		}

		/**
		 * @private
		 */
		override public function set defaultSkin(value:DisplayObject):void
		{
			if(this._defaultSkin === value)
			{
				return;
			}
			this.replaceSkin(null);
			this._skinIsFromItem = false;
			super.defaultSkin = value;
		}

		/**
		 * @private
		 */
		protected var _data:Object;

		/**
		 * The item displayed by this renderer. This property is set by the
		 * list, and should not be set manually.
		 */
		public function get data():Object
		{
			return this._data;
		}

		/**
		 * @private
		 */
		public function set data(value:Object):void
		{
			//we need to use strict equality here because the data can be
			//non-strictly equal to null
			if(this._data === value)
			{
				return;
			}
			this._data = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _owner:Scroller;

		/**
		 * @private
		 */
		protected var _factoryID:String;

		/**
		 * @inheritDoc
		 */
		public function get factoryID():String
		{
			return this._factoryID;
		}

		/**
		 * @private
		 */
		public function set factoryID(value:String):void
		{
			this._factoryID = value;
		}

		/**
		 * @private
		 */
		protected var _delayedCurrentState:String;

		/**
		 * @private
		 */
		protected var _stateDelayTimer:Timer;

		/**
		 * @private
		 */
		protected var _useStateDelayTimer:Boolean = true;

		/**
		 * If true, the down state (and subsequent state changes) will be
		 * delayed to make scrolling look nicer.
		 *
		 * <p>In the following example, the state delay timer is disabled:</p>
		 *
		 * <listing version="3.0">
		 * renderer.useStateDelayTimer = false;</listing>
		 *
		 * @default true
		 */
		public function get useStateDelayTimer():Boolean
		{
			return this._useStateDelayTimer;
		}

		/**
		 * @private
		 */
		public function set useStateDelayTimer(value:Boolean):void
		{
			this._useStateDelayTimer = value;
		}

		/**
		 * Determines if the item renderer can be selected even if
		 * <code>isToggle</code> is set to <code>false</code>. Subclasses are
		 * expected to change this value, if required.
		 */
		protected var isSelectableWithoutToggle:Boolean = true;

		/**
		 * @private
		 */
		protected var _itemHasLabel:Boolean = true;

		/**
		 * If true, the label will come from the renderer's item using the
		 * appropriate field or function for the label. If false, the label may
		 * be set externally.
		 *
		 * <p>In the following example, the item doesn't have a label:</p>
		 *
		 * <listing version="3.0">
		 * renderer.itemHasLabel = false;</listing>
		 *
		 * @default true
		 */
		public function get itemHasLabel():Boolean
		{
			return this._itemHasLabel;
		}

		/**
		 * @private
		 */
		public function set itemHasLabel(value:Boolean):void
		{
			if(this._itemHasLabel == value)
			{
				return;
			}
			this._itemHasLabel = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _itemHasIcon:Boolean = true;

		/**
		 * If true, the icon will come from the renderer's item using the
		 * appropriate field or function for the icon. If false, the icon may
		 * be skinned for each state externally.
		 *
		 * <p>In the following example, the item doesn't have an icon:</p>
		 *
		 * <listing version="3.0">
		 * renderer.itemHasIcon = false;</listing>
		 *
		 * @default true
		 */
		public function get itemHasIcon():Boolean
		{
			return this._itemHasIcon;
		}

		/**
		 * @private
		 */
		public function set itemHasIcon(value:Boolean):void
		{
			if(this._itemHasIcon == value)
			{
				return;
			}
			this._itemHasIcon = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _itemHasAccessory:Boolean = true;

		/**
		 * If true, the accessory will come from the renderer's item using the
		 * appropriate field or function for the accessory. If false, the
		 * accessory may be set using other means.
		 *
		 * <p>In the following example, the item doesn't have an accessory:</p>
		 *
		 * <listing version="3.0">
		 * renderer.itemHasAccessory = false;</listing>
		 *
		 * @default true
		 */
		public function get itemHasAccessory():Boolean
		{
			return this._itemHasAccessory;
		}

		/**
		 * @private
		 */
		public function set itemHasAccessory(value:Boolean):void
		{
			if(this._itemHasAccessory == value)
			{
				return;
			}
			this._itemHasAccessory = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _itemHasSkin:Boolean = false;

		/**
		 * If true, the skin will come from the renderer's item using the
		 * appropriate field or function for the skin. If false, the skin may
		 * be set for each state externally.
		 *
		 * <p>In the following example, the item has a skin:</p>
		 *
		 * <listing version="3.0">
		 * renderer.itemHasSkin = true;
		 * renderer.skinField = "background";</listing>
		 *
		 * @default false
		 */
		public function get itemHasSkin():Boolean
		{
			return this._itemHasSkin;
		}

		/**
		 * @private
		 */
		public function set itemHasSkin(value:Boolean):void
		{
			if(this._itemHasSkin == value)
			{
				return;
			}
			this._itemHasSkin = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _itemHasSelectable:Boolean = false;

		/**
		 * If true, the ability to select the renderer will come from the
		 * renderer's item using the appropriate field or function for
		 * selectable. If false, the renderer will be selectable if its owner
		 * is selectable.
		 *
		 * <p>In the following example, the item doesn't have an accessory:</p>
		 *
		 * <listing version="3.0">
		 * renderer.itemHasSelectable = true;</listing>
		 *
		 * @default false
		 */
		public function get itemHasSelectable():Boolean
		{
			return this._itemHasSelectable;
		}

		/**
		 * @private
		 */
		public function set itemHasSelectable(value:Boolean):void
		{
			if(this._itemHasSelectable == value)
			{
				return;
			}
			this._itemHasSelectable = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _itemHasEnabled:Boolean = false;

		/**
		 * If true, the renderer's enabled state will come from the renderer's
		 * item using the appropriate field or function for enabled. If false,
		 * the renderer will be enabled if its owner is enabled.
		 *
		 * <p>In the following example, the item doesn't have an accessory:</p>
		 *
		 * <listing version="3.0">
		 * renderer.itemHasEnabled = true;</listing>
		 *
		 * @default false
		 */
		public function get itemHasEnabled():Boolean
		{
			return this._itemHasEnabled;
		}

		/**
		 * @private
		 */
		public function set itemHasEnabled(value:Boolean):void
		{
			if(this._itemHasEnabled == value)
			{
				return;
			}
			this._itemHasEnabled = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _accessoryPosition:String = RelativePosition.RIGHT;

		[Inspectable(type="String",enumeration="top,right,bottom,left,manual")]
		/**
		 * The location of the accessory, relative to one of the other children.
		 * Use <code>RelativePosition.MANUAL</code> to position the accessory
		 * from the top-left corner.
		 *
		 * <p>In the following example, the accessory is placed on the bottom:</p>
		 *
		 * <listing version="3.0">
		 * renderer.accessoryPosition = RelativePosition.BOTTOM;</listing>
		 *
		 * @default feathers.layout.RelativePosition.RIGHT
		 *
		 * @see feathers.layout.RelativePosition#TOP
		 * @see feathers.layout.RelativePosition#RIGHT
		 * @see feathers.layout.RelativePosition#BOTTOM
		 * @see feathers.layout.RelativePosition#LEFT
		 * @see feathers.layout.RelativePosition#MANUAL
		 * @see #layoutOrder
		 */
		public function get accessoryPosition():String
		{
			return this._accessoryPosition;
		}

		/**
		 * @private
		 */
		public function set accessoryPosition(value:String):void
		{
			if(this._accessoryPosition == value)
			{
				return;
			}
			this._accessoryPosition = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _layoutOrder:String = ItemRendererLayoutOrder.LABEL_ICON_ACCESSORY;

		[Inspectable(type="String",enumeration="labelIconAccessory,labelAccessoryIcon")]
		/**
		 * The accessory's position will be based on which other child (the
		 * label or the icon) the accessory should be relative to.
		 *
		 * <p>The <code>accessoryPositionOrigin</code> property will be ignored
		 * if <code>accessoryPosition</code> is set to <code>RelativePosition.MANUAL</code>.</p>
		 *
		 * <p>In the following example, the layout order is changed:</p>
		 *
		 * <listing version="3.0">
		 * renderer.layoutOrder = ItemRendererLayoutOrder.LABEL_ACCESSORY_ICON;</listing>
		 *
		 * @default feathers.controls.ItemRendererLayoutOrder.LABEL_ICON_ACCESSORY
		 *
		 * @see feathers.controls.ItemRendererLayoutOrder#LABEL_ICON_ACCESSORY
		 * @see feathers.controls.ItemRendererLayoutOrder#LABEL_ACCESSORY_ICON
		 * @see #accessoryPosition
		 * @see #iconPosition
		 */
		public function get layoutOrder():String
		{
			return this._layoutOrder;
		}

		/**
		 * @private
		 */
		public function set layoutOrder(value:String):void
		{
			if(this._layoutOrder == value)
			{
				return;
			}
			this._layoutOrder = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _accessoryOffsetX:Number = 0;

		/**
		 * Offsets the x position of the accessory by a certain number of pixels.
		 *
		 * <p>In the following example, the accessory x position is adjusted by 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * renderer.accessoryOffsetX = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #accessoryOffsetY
		 */
		public function get accessoryOffsetX():Number
		{
			return this._accessoryOffsetX;
		}

		/**
		 * @private
		 */
		public function set accessoryOffsetX(value:Number):void
		{
			if(this._accessoryOffsetX == value)
			{
				return;
			}
			this._accessoryOffsetX = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _accessoryOffsetY:Number = 0;

		/**
		 * Offsets the y position of the accessory by a certain number of pixels.
		 *
		 * <p>In the following example, the accessory y position is adjusted by 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * renderer.accessoryOffsetY = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #accessoryOffsetX
		 */
		public function get accessoryOffsetY():Number
		{
			return this._accessoryOffsetY;
		}

		/**
		 * @private
		 */
		public function set accessoryOffsetY(value:Number):void
		{
			if(this._accessoryOffsetY == value)
			{
				return;
			}
			this._accessoryOffsetY = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _accessoryGap:Number = NaN;

		/**
		 * The space, in pixels, between the accessory and the other child it is
		 * positioned relative to. Applies to either horizontal or vertical
		 * spacing, depending on the value of <code>accessoryPosition</code>. If
		 * the value is <code>NaN</code>, the value of the <code>gap</code>
		 * property will be used instead.
		 *
		 * <p>If <code>accessoryGap</code> is set to <code>Number.POSITIVE_INFINITY</code>,
		 * the accessory and the component it is relative to will be positioned
		 * as far apart as possible.</p>
		 *
		 * <p>In the following example, the accessory gap is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * renderer.accessoryGap = 20;</listing>
		 *
		 * @default NaN
		 *
		 * @see #gap
		 * @see #accessoryPosition
		 */
		public function get accessoryGap():Number
		{
			return this._accessoryGap;
		}

		/**
		 * @private
		 */
		public function set accessoryGap(value:Number):void
		{
			if(this._accessoryGap == value)
			{
				return;
			}
			this._accessoryGap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _minAccessoryGap:Number = NaN;

		/**
		 * If the value of the <code>accessoryGap</code> property is
		 * <code>Number.POSITIVE_INFINITY</code>, meaning that the gap will
		 * fill as much space as possible, the final calculated value will not be
		 * smaller than the value of the <code>minAccessoryGap</code> property.
		 * If the value of <code>minAccessoryGap</code> is <code>NaN</code>, the
		 * value of the <code>minGap</code> property will be used instead.
		 *
		 * <p>The following example ensures that the gap is never smaller than
		 * 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * button.gap = Number.POSITIVE_INFINITY;
		 * button.minGap = 20;</listing>
		 *
		 * <listing version="3.0">
		 * renderer.accessoryGap = 20;</listing>
		 *
		 * @default NaN
		 *
		 * @see #accessoryGap
		 */
		public function get minAccessoryGap():Number
		{
			return this._minAccessoryGap;
		}

		/**
		 * @private
		 */
		public function set minAccessoryGap(value:Number):void
		{
			if(this._minAccessoryGap == value)
			{
				return;
			}
			this._minAccessoryGap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _defaultAccessory:DisplayObject;

		/**
		 * The accessory used when no other accessory is defined for the current
		 * state. Intended to be used when multiple states should share the same
		 * accessory.
		 *
		 * <p>This property will be ignored if a function is passed to the
		 * <code>stateToAccessoryFunction</code> property. This property may be
		 * ignored if the <code>itemHasAccessory</code> property is
		 * <code>true</code>.</p>
		 *
		 * <p>The following example gives the item renderer a default accessory
		 * to use for all states when no specific accessory is available:</p>
		 *
		 * <listing version="3.0">
		 * itemRenderer.defaultAccessory = new Image( texture );</listing>
		 *
		 * @default null
		 *
		 * @see #setAccessoryForState()
		 * @see #itemHasAccessory
		 */
		public function get defaultAccessory():DisplayObject
		{
			return this._defaultAccessory;
		}

		/**
		 * @private
		 */
		public function set defaultAccessory(value:DisplayObject):void
		{
			if(this._defaultAccessory === value)
			{
				return;
			}
			this.replaceAccessory(null);
			this._accessoryIsFromItem = false;
			this._defaultAccessory = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _stateToAccessory:Object = {};

		/**
		 * @private
		 */
		protected var _stateToAccessoryFunction:Function;

		/**
		 * DEPRECATED: Create a <code>feathers.skins.ImageSkin</code> instead,
		 * and pass to the <code>defaultAccessory</code> property.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public function get stateToAccessoryFunction():Function
		{
			return this._stateToAccessoryFunction;
		}

		/**
		 * @private
		 */
		public function set stateToAccessoryFunction(value:Function):void
		{
			if(this._stateToAccessoryFunction == value)
			{
				return;
			}
			this._stateToAccessoryFunction = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var accessoryTouchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _stopScrollingOnAccessoryTouch:Boolean = true;

		/**
		 * If enabled, calls owner.stopScrolling() when TouchEvents are
		 * dispatched by the accessory.
		 *
		 * <p>In the following example, the list won't stop scrolling when the
		 * accessory is touched:</p>
		 *
		 * <listing version="3.0">
		 * renderer.stopScrollingOnAccessoryTouch = false;</listing>
		 *
		 * @default true
		 */
		public function get stopScrollingOnAccessoryTouch():Boolean
		{
			return this._stopScrollingOnAccessoryTouch;
		}

		/**
		 * @private
		 */
		public function set stopScrollingOnAccessoryTouch(value:Boolean):void
		{
			this._stopScrollingOnAccessoryTouch = value;
		}

		/**
		 * @private
		 */
		protected var _isSelectableOnAccessoryTouch:Boolean = false;

		/**
		 * If enabled, the item renderer may be selected by touching the
		 * accessory. By default, the accessory will not trigger selection when
		 * using <code>defaultAccessory</code>, <code>accessoryField</code>, or
		 * <code>accessoryFunction</code> and the accessory is a Feathers
		 * component.
		 *
		 * <p>In the following example, the item renderer can be selected when
		 * the accessory is touched:</p>
		 *
		 * <listing version="3.0">
		 * renderer.isSelectableOnAccessoryTouch = true;</listing>
		 *
		 * @default false
		 */
		public function get isSelectableOnAccessoryTouch():Boolean
		{
			return this._isSelectableOnAccessoryTouch;
		}

		/**
		 * @private
		 */
		public function set isSelectableOnAccessoryTouch(value:Boolean):void
		{
			this._isSelectableOnAccessoryTouch = value;
		}

		/**
		 * @private
		 */
		protected var _delayTextureCreationOnScroll:Boolean = false;

		/**
		 * If enabled, automatically manages the <code>delayTextureCreation</code>
		 * property on accessory and icon <code>ImageLoader</code> instances
		 * when the owner scrolls. This applies to the loaders created when the
		 * following properties are set: <code>accessorySourceField</code>,
		 * <code>accessorySourceFunction</code>, <code>iconSourceField</code>,
		 * and <code>iconSourceFunction</code>.
		 *
		 * <p>In the following example, any loaded textures won't be uploaded to
		 * the GPU until the owner stops scrolling:</p>
		 *
		 * <listing version="3.0">
		 * renderer.delayTextureCreationOnScroll = true;</listing>
		 *
		 * @default false
		 */
		public function get delayTextureCreationOnScroll():Boolean
		{
			return this._delayTextureCreationOnScroll;
		}

		/**
		 * @private
		 */
		public function set delayTextureCreationOnScroll(value:Boolean):void
		{
			this._delayTextureCreationOnScroll = value;
		}

		/**
		 * @private
		 */
		protected var _labelField:String = "label";

		/**
		 * The field in the item that contains the label text to be displayed by
		 * the renderer. If the item does not have this field, and a
		 * <code>labelFunction</code> is not defined, then the renderer will
		 * default to calling <code>toString()</code> on the item. To omit the
		 * label completely, either provide a custom item renderer without a
		 * label or define a <code>labelFunction</code> that returns an empty
		 * string.
		 *
		 * <p>All of the label fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>labelFunction</code></li>
		 *     <li><code>labelField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the label field is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.labelField = "text";</listing>
		 *
		 * @default "label"
		 *
		 * @see #labelFunction
		 */
		public function get labelField():String
		{
			return this._labelField;
		}

		/**
		 * @private
		 */
		public function set labelField(value:String):void
		{
			if(this._labelField == value)
			{
				return;
			}
			this._labelField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _labelFunction:Function;

		/**
		 * A function used to generate label text for a specific item. If this
		 * function is not null, then the <code>labelField</code> will be
		 * ignored.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:Object ):String</pre>
		 *
		 * <p>All of the label fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>labelFunction</code></li>
		 *     <li><code>labelField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the label function is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.labelFunction = function( item:Object ):String
		 * {
		 *    return item.firstName + " " + item.lastName;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see #labelField
		 */
		public function get labelFunction():Function
		{
			return this._labelFunction;
		}

		/**
		 * @private
		 */
		public function set labelFunction(value:Function):void
		{
			if(this._labelFunction == value)
			{
				return;
			}
			this._labelFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _iconField:String = "icon";

		/**
		 * The field in the item that contains a display object to be displayed
		 * as an icon or other graphic next to the label in the renderer.
		 *
		 * <p>Warning: It is your responsibility to dispose all icons
		 * included in the data provider and accessed with <code>iconField</code>,
		 * or any display objects returned by <code>iconFunction</code>.
		 * These display objects will not be disposed when the list is disposed.
		 * Not disposing an icon may result in a memory leak.</p>
		 *
		 * <p>All of the icon fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>iconSourceFunction</code></li>
		 *     <li><code>iconSourceField</code></li>
		 *     <li><code>iconLabelFunction</code></li>
		 *     <li><code>iconLabelField</code></li>
		 *     <li><code>iconFunction</code></li>
		 *     <li><code>iconField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the icon field is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.iconField = "photo";</listing>
		 *
		 * @default "icon"
		 *
		 * @see #itemHasIcon
		 * @see #iconFunction
		 * @see #iconSourceField
		 * @see #iconSourceFunction
		 */
		public function get iconField():String
		{
			return this._iconField;
		}

		/**
		 * @private
		 */
		public function set iconField(value:String):void
		{
			if(this._iconField == value)
			{
				return;
			}
			this._iconField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _iconFunction:Function;

		/**
		 * A function used to generate an icon for a specific item.
		 *
		 * <p>Note: As the list scrolls, this function will almost always be
		 * called more than once for each individual item in the list's data
		 * provider. Your function should not simply return a new icon every
		 * time. This will result in the unnecessary creation and destruction of
		 * many icons, which will overwork the garbage collector and hurt
		 * performance. It's better to return a new icon the first time this
		 * function is called for a particular item and then return the same
		 * icon if that item is passed to this function again.</p>
		 *
		 * <p>Warning: It is your responsibility to dispose all icons
		 * included in the data provider and accessed with <code>iconField</code>,
		 * or any display objects returned by <code>iconFunction</code>.
		 * These display objects will not be disposed when the list is disposed.
		 * Not disposing an icon may result in a memory leak.</p>
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:Object ):DisplayObject</pre>
		 *
		 * <p>All of the icon fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>iconSourceFunction</code></li>
		 *     <li><code>iconSourceField</code></li>
		 *     <li><code>iconLabelFunction</code></li>
		 *     <li><code>iconLabelField</code></li>
		 *     <li><code>iconFunction</code></li>
		 *     <li><code>iconField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the icon function is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.iconFunction = function( item:Object ):DisplayObject
		 * {
		 *    if(item in cachedIcons)
		 *    {
		 *        return cachedIcons[item];
		 *    }
		 *    var icon:Image = new Image( textureAtlas.getTexture( item.textureName ) );
		 *    cachedIcons[item] = icon;
		 *    return icon;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see #itemHasIcon
		 * @see #iconField
		 * @see #iconSourceField
		 * @see #iconSourceFunction
		 */
		public function get iconFunction():Function
		{
			return this._iconFunction;
		}

		/**
		 * @private
		 */
		public function set iconFunction(value:Function):void
		{
			if(this._iconFunction == value)
			{
				return;
			}
			this._iconFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _iconSourceField:String = "iconSource";

		/**
		 * The field in the item that contains a <code>starling.textures.Texture</code>
		 * or a URL that points to a bitmap to be used as the item renderer's
		 * icon. The renderer will automatically manage and reuse an internal
		 * <code>ImageLoader</code> sub-component and this value will be passed
		 * to the <code>source</code> property. The <code>ImageLoader</code> may
		 * be customized by changing the <code>iconLoaderFactory</code>.
		 *
		 * <p>Using an icon source will result in better performance than
		 * passing in an <code>ImageLoader</code> or <code>Image</code> through
		 * a <code>iconField</code> or <code>iconFunction</code>
		 * because the renderer can avoid costly display list manipulation.</p>
		 *
		 * <p>All of the icon fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>iconSourceFunction</code></li>
		 *     <li><code>iconSourceField</code></li>
		 *     <li><code>iconLabelFunction</code></li>
		 *     <li><code>iconLabelField</code></li>
		 *     <li><code>iconFunction</code></li>
		 *     <li><code>iconField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the icon source field is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.iconSourceField = "texture";</listing>
		 *
		 * @default "iconSource"
		 *
		 * @see feathers.controls.ImageLoader#source
		 * @see #itemHasIcon
		 * @see #iconLoaderFactory
		 * @see #iconSourceFunction
		 * @see #iconField
		 * @see #iconFunction
		 */
		public function get iconSourceField():String
		{
			return this._iconSourceField;
		}

		/**
		 * @private
		 */
		public function set iconSourceField(value:String):void
		{
			if(this._iconSourceField == value)
			{
				return;
			}
			this._iconSourceField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _iconSourceFunction:Function;

		/**
		 * A function used to generate a <code>starling.textures.Texture</code>
		 * or a URL that points to a bitmap to be used as the item renderer's
		 * icon. The renderer will automatically manage and reuse an internal
		 * <code>ImageLoader</code> sub-component and this value will be passed
		 * to the <code>source</code> property. The <code>ImageLoader</code> may
		 * be customized by changing the <code>iconLoaderFactory</code>.
		 *
		 * <p>Using an icon source will result in better performance than
		 * passing in an <code>ImageLoader</code> or <code>Image</code> through
		 * a <code>iconField</code> or <code>iconFunction</code>
		 * because the renderer can avoid costly display list manipulation.</p>
		 *
		 * <p>Note: As the list scrolls, this function will almost always be
		 * called more than once for each individual item in the list's data
		 * provider. Your function should not simply return a new texture every
		 * time. This will result in the unnecessary creation and destruction of
		 * many textures, which will overwork the garbage collector and hurt
		 * performance. Creating a new texture at all is dangerous, unless you
		 * are absolutely sure to dispose it when necessary because neither the
		 * list nor its item renderer will dispose of the texture for you. If
		 * you are absolutely sure that you are managing the texture memory with
		 * proper disposal, it's better to return a new texture the first
		 * time this function is called for a particular item and then return
		 * the same texture if that item is passed to this function again.</p>
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:Object ):Object</pre>
		 *
		 * <p>The return value is a valid value for the <code>source</code>
		 * property of an <code>ImageLoader</code> component.</p>
		 *
		 * <p>All of the icon fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>iconSourceFunction</code></li>
		 *     <li><code>iconSourceField</code></li>
		 *     <li><code>iconLabelFunction</code></li>
		 *     <li><code>iconLabelField</code></li>
		 *     <li><code>iconFunction</code></li>
		 *     <li><code>iconField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the icon source function is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.iconSourceFunction = function( item:Object ):Object
		 * {
		 *    return "http://www.example.com/thumbs/" + item.name + "-thumb.png";
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.ImageLoader#source
		 * @see #itemHasIcon
		 * @see #iconLoaderFactory
		 * @see #iconSourceField
		 * @see #iconField
		 * @see #iconFunction
		 */
		public function get iconSourceFunction():Function
		{
			return this._iconSourceFunction;
		}

		/**
		 * @private
		 */
		public function set iconSourceFunction(value:Function):void
		{
			if(this._iconSourceFunction == value)
			{
				return;
			}
			this._iconSourceFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _iconLabelField:String = "iconLabel";

		/**
		 * The field in the item that contains a string to be displayed in a
		 * renderer-managed <code>ITextRenderer</code> in the icon position of
		 * the renderer. The renderer will automatically reuse an internal
		 * <code>ITextRenderer</code> and swap the text when the data changes.
		 * This <code>ITextRenderer</code> may be skinned by changing the
		 * <code>iconLabelFactory</code>.
		 *
		 * <p>Using an icon label will result in better performance than
		 * passing in an <code>ITextRenderer</code> through a <code>iconField</code>
		 * or <code>iconFunction</code> because the renderer can avoid
		 * costly display list manipulation.</p>
		 *
		 * <p>All of the icon fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>iconSourceFunction</code></li>
		 *     <li><code>iconSourceField</code></li>
		 *     <li><code>iconLabelFunction</code></li>
		 *     <li><code>iconLabelField</code></li>
		 *     <li><code>iconFunction</code></li>
		 *     <li><code>iconField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the icon label field is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.iconLabelField = "text";</listing>
		 *
		 * @default "iconLabel"
		 *
		 * @see #itemHasIcon
		 * @see #iconLabelFactory
		 * @see #iconLabelFunction
		 * @see #iconField
		 * @see #iconFunction
		 * @see #iconySourceField
		 * @see #iconSourceFunction
		 */
		public function get iconLabelField():String
		{
			return this._iconLabelField;
		}

		/**
		 * @private
		 */
		public function set iconLabelField(value:String):void
		{
			if(this._iconLabelField == value)
			{
				return;
			}
			this._iconLabelField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _iconLabelFunction:Function;

		/**
		 * A function that returns a string to be displayed in a
		 * renderer-managed <code>ITextRenderer</code> in the icon position of
		 * the renderer. The renderer will automatically reuse an internal
		 * <code>ITextRenderer</code> and swap the text when the data changes.
		 * This <code>ITextRenderer</code> may be skinned by changing the
		 * <code>iconLabelFactory</code>.
		 *
		 * <p>Using an icon label will result in better performance than
		 * passing in an <code>ITextRenderer</code> through a <code>iconField</code>
		 * or <code>iconFunction</code> because the renderer can avoid costly
		 * display list manipulation.</p>
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:Object ):String</pre>
		 *
		 * <p>All of the icon fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>iconSourceFunction</code></li>
		 *     <li><code>iconSourceField</code></li>
		 *     <li><code>iconLabelFunction</code></li>
		 *     <li><code>iconLabelField</code></li>
		 *     <li><code>iconFunction</code></li>
		 *     <li><code>iconField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the icon label function is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.iconLabelFunction = function( item:Object ):String
		 * {
		 *    return item.firstName + " " + item.lastName;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see #itemHasIcon
		 * @see #iconLabelFactory
		 * @see #iconLabelField
		 * @see #iconField
		 * @see #iconFunction
		 * @see #iconSourceField
		 * @see #iconSourceFunction
		 */
		public function get iconLabelFunction():Function
		{
			return this._iconLabelFunction;
		}

		/**
		 * @private
		 */
		public function set iconLabelFunction(value:Function):void
		{
			if(this._iconLabelFunction == value)
			{
				return;
			}
			this._iconLabelFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _customIconLabelStyleName:String;

		/**
		 * A style name to add to the item renderer's icon label text renderer
		 * sub-component. Typically used by a theme to provide  different styles
		 * to different item renderers.
		 *
		 * <p>In the following example, a custom icon label style name is passed
		 * to the item renderer:</p>
		 *
		 * <listing version="3.0">
		 * itemRenderer.customIconLabelStyleName = "my-custom-icon-label";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to
		 * provide different styles than the default:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( BitmapFontTextRenderer ).setFunctionForStyleName( "my-custom-icon-label", setCustomIconLabelStyles );</listing>
		 *
		 * @default null
		 *
		 * @see #DEFAULT_CHILD_STYLE_NAME_ICON_LABEL
		 * @see feathers.core.FeathersControl#styleNameList
		 * @see #iconLabelFactory
		 */
		public function get customIconLabelStyleName():String
		{
			return this._customIconLabelStyleName;
		}

		/**
		 * @private
		 */
		public function set customIconLabelStyleName(value:String):void
		{
			if(this._customIconLabelStyleName == value)
			{
				return;
			}
			this._customIconLabelStyleName = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _accessoryField:String = "accessory";

		/**
		 * The field in the item that contains a display object to be positioned
		 * in the accessory position of the renderer. If you wish to display an
		 * <code>Image</code> in the accessory position, it's better for
		 * performance to use <code>accessorySourceField</code> instead.
		 *
		 * <p>Warning: It is your responsibility to dispose all accessories
		 * included in the data provider and accessed with <code>accessoryField</code>,
		 * or any display objects returned by <code>accessoryFunction</code>.
		 * These display objects will not be disposed when the list is disposed.
		 * Not disposing an accessory may result in a memory leak.</p>
		 *
		 * <p>All of the accessory fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>accessorySourceFunction</code></li>
		 *     <li><code>accessorySourceField</code></li>
		 *     <li><code>accessoryLabelFunction</code></li>
		 *     <li><code>accessoryLabelField</code></li>
		 *     <li><code>accessoryFunction</code></li>
		 *     <li><code>accessoryField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the accessory field is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.accessoryField = "component";</listing>
		 *
		 * @default "accessory"
		 *
		 * @see #itemHasAccessory
		 * @see #accessorySourceField
		 * @see #accessoryFunction
		 * @see #accessorySourceFunction
		 * @see #accessoryLabelField
		 * @see #accessoryLabelFunction
		 */
		public function get accessoryField():String
		{
			return this._accessoryField;
		}

		/**
		 * @private
		 */
		public function set accessoryField(value:String):void
		{
			if(this._accessoryField == value)
			{
				return;
			}
			this._accessoryField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _accessoryFunction:Function;

		/**
		 * A function that returns a display object to be positioned in the
		 * accessory position of the renderer. If you wish to display an
		 * <code>Image</code> in the accessory position, it's better for
		 * performance to use <code>accessorySourceFunction</code> instead.
		 *
		 * <p>Note: As the list scrolls, this function will almost always be
		 * called more than once for each individual item in the list's data
		 * provider. Your function should not simply return a new accessory
		 * every time. This will result in the unnecessary creation and
		 * destruction of many icons, which will overwork the garbage collector
		 * and hurt performance. It's better to return a new accessory the first
		 * time this function is called for a particular item and then return
		 * the same accessory if that item is passed to this function again.</p>
		 *
		 * <p>Warning: It is your responsibility to dispose all accessories
		 * included in the data provider and accessed with <code>accessoryField</code>,
		 * or any display objects returned by <code>accessoryFunction</code>.
		 * These display objects will not be disposed when the list is disposed.
		 * Not disposing an accessory may result in a memory leak.</p>
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:Object ):DisplayObject</pre>
		 *
		 * <p>All of the accessory fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>accessorySourceFunction</code></li>
		 *     <li><code>accessorySourceField</code></li>
		 *     <li><code>accessoryLabelFunction</code></li>
		 *     <li><code>accessoryLabelField</code></li>
		 *     <li><code>accessoryFunction</code></li>
		 *     <li><code>accessoryField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the accessory function is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.accessoryFunction = function( item:Object ):DisplayObject
		 * {
		 *    if(item in cachedAccessories)
		 *    {
		 *        return cachedAccessories[item];
		 *    }
		 *    var accessory:DisplayObject = createAccessoryForItem( item );
		 *    cachedAccessories[item] = accessory;
		 *    return accessory;
		 * };</listing>
		 *
		 * @default null
		 **
		 * @see #itemHasAccessory
		 * @see #accessoryField
		 * @see #accessorySourceField
		 * @see #accessorySourceFunction
		 * @see #accessoryLabelField
		 * @see #accessoryLabelFunction
		 */
		public function get accessoryFunction():Function
		{
			return this._accessoryFunction;
		}

		/**
		 * @private
		 */
		public function set accessoryFunction(value:Function):void
		{
			if(this._accessoryFunction == value)
			{
				return;
			}
			this._accessoryFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _accessorySourceField:String = "accessorySource";

		/**
		 * A field in the item that contains a <code>starling.textures.Texture</code>
		 * or a URL that points to a bitmap to be used as the item renderer's
		 * accessory. The renderer will automatically manage and reuse an internal
		 * <code>ImageLoader</code> sub-component and this value will be passed
		 * to the <code>source</code> property. The <code>ImageLoader</code> may
		 * be customized by changing the <code>accessoryLoaderFactory</code>.
		 *
		 * <p>Using an accessory source will result in better performance than
		 * passing in an <code>ImageLoader</code> or <code>Image</code> through
		 * a <code>accessoryField</code> or <code>accessoryFunction</code> because
		 * the renderer can avoid costly display list manipulation.</p>
		 *
		 * <p>All of the accessory fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>accessorySourceFunction</code></li>
		 *     <li><code>accessorySourceField</code></li>
		 *     <li><code>accessoryLabelFunction</code></li>
		 *     <li><code>accessoryLabelField</code></li>
		 *     <li><code>accessoryFunction</code></li>
		 *     <li><code>accessoryField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the accessory source field is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.accessorySourceField = "texture";</listing>
		 *
		 * @default "accessorySource"
		 *
		 * @see feathers.controls.ImageLoader#source
		 * @see #itemHasAccessory
		 * @see #accessoryLoaderFactory
		 * @see #accessorySourceFunction
		 * @see #accessoryField
		 * @see #accessoryFunction
		 * @see #accessoryLabelField
		 * @see #accessoryLabelFunction
		 */
		public function get accessorySourceField():String
		{
			return this._accessorySourceField;
		}

		/**
		 * @private
		 */
		public function set accessorySourceField(value:String):void
		{
			if(this._accessorySourceField == value)
			{
				return;
			}
			this._accessorySourceField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _accessorySourceFunction:Function;

		/**
		 * A function that generates a <code>starling.textures.Texture</code>
		 * or a URL that points to a bitmap to be used as the item renderer's
		 * accessory. The renderer will automatically manage and reuse an internal
		 * <code>ImageLoader</code> sub-component and this value will be passed
		 * to the <code>source</code> property. The <code>ImageLoader</code> may
		 * be customized by changing the <code>accessoryLoaderFactory</code>.
		 *
		 * <p>Using an accessory source will result in better performance than
		 * passing in an <code>ImageLoader</code> or <code>Image</code> through
		 * a <code>accessoryField</code> or <code>accessoryFunction</code>
		 * because the renderer can avoid costly display list manipulation.</p>
		 *
		 * <p>Note: As the list scrolls, this function will almost always be
		 * called more than once for each individual item in the list's data
		 * provider. Your function should not simply return a new texture every
		 * time. This will result in the unnecessary creation and destruction of
		 * many textures, which will overwork the garbage collector and hurt
		 * performance. Creating a new texture at all is dangerous, unless you
		 * are absolutely sure to dispose it when necessary because neither the
		 * list nor its item renderer will dispose of the texture for you. If
		 * you are absolutely sure that you are managing the texture memory with
		 * proper disposal, it's better to return a new texture the first
		 * time this function is called for a particular item and then return
		 * the same texture if that item is passed to this function again.</p>
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:Object ):Object</pre>
		 *
		 * <p>The return value is a valid value for the <code>source</code>
		 * property of an <code>ImageLoader</code> component.</p>
		 *
		 * <p>All of the accessory fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>accessorySourceFunction</code></li>
		 *     <li><code>accessorySourceField</code></li>
		 *     <li><code>accessoryLabelFunction</code></li>
		 *     <li><code>accessoryLabelField</code></li>
		 *     <li><code>accessoryFunction</code></li>
		 *     <li><code>accessoryField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the accessory source function is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.accessorySourceFunction = function( item:Object ):Object
		 * {
		 *    return "http://www.example.com/thumbs/" + item.name + "-thumb.png";
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.ImageLoader#source
		 * @see #itemHasAccessory
		 * @see #accessoryLoaderFactory
		 * @see #accessorySourceField
		 * @see #accessoryField
		 * @see #accessoryFunction
		 * @see #accessoryLabelField
		 * @see #accessoryLabelFunction
		 */
		public function get accessorySourceFunction():Function
		{
			return this._accessorySourceFunction;
		}

		/**
		 * @private
		 */
		public function set accessorySourceFunction(value:Function):void
		{
			if(this._accessorySourceFunction == value)
			{
				return;
			}
			this._accessorySourceFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _accessoryLabelField:String = "accessoryLabel";

		/**
		 * The field in the item that contains a string to be displayed in a
		 * renderer-managed <code>ITextRenderer</code> in the accessory position
		 * of the renderer. The renderer will automatically reuse an internal
		 * <code>ITextRenderer</code> and swap the text when the data changes.
		 * This <code>ITextRenderer</code> may be skinned by changing the
		 * <code>accessoryLabelFactory</code>.
		 *
		 * <p>Using an accessory label will result in better performance than
		 * passing in a <code>ITextRenderer</code> through an <code>accessoryField</code>
		 * or <code>accessoryFunction</code> because the renderer can avoid
		 * costly display list manipulation.</p>
		 *
		 * <p>All of the accessory fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>accessorySourceFunction</code></li>
		 *     <li><code>accessorySourceField</code></li>
		 *     <li><code>accessoryLabelFunction</code></li>
		 *     <li><code>accessoryLabelField</code></li>
		 *     <li><code>accessoryFunction</code></li>
		 *     <li><code>accessoryField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the accessory label field is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.accessoryLabelField = "text";</listing>
		 *
		 * @default "accessoryLabel"
		 **
		 * @see #itemHasAccessory
		 * @see #accessoryLabelFactory
		 * @see #accessoryLabelFunction
		 * @see #accessoryField
		 * @see #accessoryFunction
		 * @see #accessorySourceField
		 * @see #accessorySourceFunction
		 */
		public function get accessoryLabelField():String
		{
			return this._accessoryLabelField;
		}

		/**
		 * @private
		 */
		public function set accessoryLabelField(value:String):void
		{
			if(this._accessoryLabelField == value)
			{
				return;
			}
			this._accessoryLabelField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _accessoryLabelFunction:Function;

		/**
		 * A function that returns a string to be displayed in a
		 * renderer-managed <code>ITextRenderer</code> in the accessory position
		 * of the renderer. The renderer will automatically reuse an internal
		 * <code>ITextRenderer</code> and swap the text when the data changes.
		 * This <code>ITextRenderer</code> may be skinned by changing the
		 * <code>accessoryLabelFactory</code>.
		 *
		 * <p>Using an accessory label will result in better performance than
		 * passing in an <code>ITextRenderer</code> through an <code>accessoryField</code>
		 * or <code>accessoryFunction</code> because the renderer can avoid
		 * costly display list manipulation.</p>
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:Object ):String</pre>
		 *
		 * <p>All of the accessory fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>accessorySourceFunction</code></li>
		 *     <li><code>accessorySourceField</code></li>
		 *     <li><code>accessoryLabelFunction</code></li>
		 *     <li><code>accessoryLabelField</code></li>
		 *     <li><code>accessoryFunction</code></li>
		 *     <li><code>accessoryField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the accessory label function is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.accessoryLabelFunction = function( item:Object ):String
		 * {
		 *    return item.firstName + " " + item.lastName;
		 * };</listing>
		 *
		 * @default null
		 **
		 * @see #itemHasAccessory
		 * @see #accessoryLabelFactory
		 * @see #accessoryLabelField
		 * @see #accessoryField
		 * @see #accessoryFunction
		 * @see #accessorySourceField
		 * @see #accessorySourceFunction
		 */
		public function get accessoryLabelFunction():Function
		{
			return this._accessoryLabelFunction;
		}

		/**
		 * @private
		 */
		public function set accessoryLabelFunction(value:Function):void
		{
			if(this._accessoryLabelFunction == value)
			{
				return;
			}
			this._accessoryLabelFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _customAccessoryLabelStyleName:String;

		/**
		 * A style name to add to the item renderer's accessory label text
		 * renderer sub-component. Typically used by a theme to provide
		 * different styles to different item renderers.
		 *
		 * <p>In the following example, a custom accessory label style name is
		 * passed to the item renderer:</p>
		 *
		 * <listing version="3.0">
		 * itemRenderer.customAccessoryLabelStyleName = "my-custom-accessory-label";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to
		 * provide different styles than the default:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( BitmapFontTextRenderer ).setFunctionForStyleName( "my-custom-accessory-label", setCustomAccessoryLabelStyles );</listing>
		 *
		 * @default null
		 *
		 * @see #DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL
		 * @see feathers.core.FeathersControl#styleNameList
		 * @see #accessoryLabelFactory
		 */
		public function get customAccessoryLabelStyleName():String
		{
			return this._customAccessoryLabelStyleName;
		}

		/**
		 * @private
		 */
		public function set customAccessoryLabelStyleName(value:String):void
		{
			if(this._customAccessoryLabelStyleName == value)
			{
				return;
			}
			this._customAccessoryLabelStyleName = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _skinField:String = "skin";

		/**
		 * The field in the item that contains a display object to be displayed
		 * as a background skin.
		 *
		 * <p>All of the icon fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>skinSourceFunction</code></li>
		 *     <li><code>skinSourceField</code></li>
		 *     <li><code>skinFunction</code></li>
		 *     <li><code>skinField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the skin field is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.itemHasSkin = true;
		 * renderer.skinField = "background";</listing>
		 *
		 * @default "skin"
		 *
		 * @see #itemHasSkin
		 * @see #skinFunction
		 * @see #skinSourceField
		 * @see #skinSourceFunction
		 */
		public function get skinField():String
		{
			return this._skinField;
		}

		/**
		 * @private
		 */
		public function set skinField(value:String):void
		{
			if(this._skinField == value)
			{
				return;
			}
			this._skinField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _skinFunction:Function;

		/**
		 * A function used to generate a background skin for a specific item.
		 *
		 * <p>Note: As the list scrolls, this function will almost always be
		 * called more than once for each individual item in the list's data
		 * provider. Your function should not simply return a new display object
		 * every time. This will result in the unnecessary creation and
		 * destruction of many skins, which will overwork the garbage collector
		 * and hurt performance. It's better to return a new skin the first time
		 * this function is called for a particular item and then return the same
		 * skin if that item is passed to this function again.</p>
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:Object ):DisplayObject</pre>
		 *
		 * <p>All of the skin fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>skinSourceFunction</code></li>
		 *     <li><code>skinSourceField</code></li>
		 *     <li><code>skinFunction</code></li>
		 *     <li><code>skinField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the skin function is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.itemHasSkin = true;
		 * renderer.skinFunction = function( item:Object ):DisplayObject
		 * {
		 *    if(item in cachedSkin)
		 *    {
		 *        return cachedSkin[item];
		 *    }
		 *    var skin:Image = new Image( textureAtlas.getTexture( item.textureName ) );
		 *    cachedSkin[item] = skin;
		 *    return skin;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see #itemHasSkin
		 * @see #skinField
		 * @see #skinSourceField
		 * @see #skinSourceFunction
		 */
		public function get skinFunction():Function
		{
			return this._skinFunction;
		}

		/**
		 * @private
		 */
		public function set skinFunction(value:Function):void
		{
			if(this._skinFunction == value)
			{
				return;
			}
			this._skinFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _skinSourceField:String = "skinSource";

		/**
		 * The field in the item that contains a <code>starling.textures.Texture</code>
		 * or a URL that points to a bitmap to be used as the item renderer's
		 * skin. The renderer will automatically manage and reuse an internal
		 * <code>ImageLoader</code> sub-component and this value will be passed
		 * to the <code>source</code> property. The <code>ImageLoader</code> may
		 * be customized by changing the <code>skinLoaderFactory</code>.
		 *
		 * <p>Using a skin source will result in better performance than
		 * passing in an <code>ImageLoader</code> or <code>Image</code> through
		 * a <code>skinField</code> or <code>skinFunction</code>
		 * because the renderer can avoid costly display list manipulation.</p>
		 *
		 * <p>All of the skin fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>skinSourceFunction</code></li>
		 *     <li><code>skinSourceField</code></li>
		 *     <li><code>skinFunction</code></li>
		 *     <li><code>skinField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the skin source field is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.itemHasSkin = true;
		 * renderer.skinSourceField = "texture";</listing>
		 *
		 * @default "skinSource"
		 *
		 * @see feathers.controls.ImageLoader#source
		 * @see #itemHasSkin
		 * @see #skinLoaderFactory
		 * @see #skinSourceFunction
		 * @see #skinField
		 * @see #skinFunction
		 */
		public function get skinSourceField():String
		{
			return this._skinSourceField;
		}

		/**
		 * @private
		 */
		public function set skinSourceField(value:String):void
		{
			if(this._iconSourceField == value)
			{
				return;
			}
			this._skinSourceField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _skinSourceFunction:Function;

		/**
		 * A function used to generate a <code>starling.textures.Texture</code>
		 * or a URL that points to a bitmap to be used as the item renderer's
		 * skin. The renderer will automatically manage and reuse an internal
		 * <code>ImageLoader</code> sub-component and this value will be passed
		 * to the <code>source</code> property. The <code>ImageLoader</code> may
		 * be customized by changing the <code>skinLoaderFactory</code>.
		 *
		 * <p>Using a skin source will result in better performance than
		 * passing in an <code>ImageLoader</code> or <code>Image</code> through
		 * a <code>skinField</code> or <code>skinnFunction</code>
		 * because the renderer can avoid costly display list manipulation.</p>
		 *
		 * <p>Note: As the list scrolls, this function will almost always be
		 * called more than once for each individual item in the list's data
		 * provider. Your function should not simply return a new texture every
		 * time. This will result in the unnecessary creation and destruction of
		 * many textures, which will overwork the garbage collector and hurt
		 * performance. Creating a new texture at all is dangerous, unless you
		 * are absolutely sure to dispose it when necessary because neither the
		 * list nor its item renderer will dispose of the texture for you. If
		 * you are absolutely sure that you are managing the texture memory with
		 * proper disposal, it's better to return a new texture the first
		 * time this function is called for a particular item and then return
		 * the same texture if that item is passed to this function again.</p>
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:Object ):Object</pre>
		 *
		 * <p>The return value is a valid value for the <code>source</code>
		 * property of an <code>ImageLoader</code> component.</p>
		 *
		 * <p>All of the skin fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>skinSourceFunction</code></li>
		 *     <li><code>skinSourceField</code></li>
		 *     <li><code>skinFunction</code></li>
		 *     <li><code>skinField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the skin source function is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.itemHasSkin = true;
		 * renderer.skinSourceFunction = function( item:Object ):Object
		 * {
		 *    return "http://www.example.com/images/" + item.name + "-skin.png";
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.ImageLoader#source
		 * @see #itemHasSkin
		 * @see #skinLoaderFactory
		 * @see #skinSourceField
		 * @see #skinField
		 * @see #skinFunction
		 */
		public function get skinSourceFunction():Function
		{
			return this._skinSourceFunction;
		}

		/**
		 * @private
		 */
		public function set skinSourceFunction(value:Function):void
		{
			if(this._skinSourceFunction == value)
			{
				return;
			}
			this._skinSourceFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _selectableField:String = "selectable";

		/**
		 * The field in the item that determines if the item renderer can be
		 * selected, if the list allows selection. If the item does not have
		 * this field, and a <code>selectableFunction</code> is not defined,
		 * then the renderer will default to being selectable.
		 *
		 * <p>All of the label fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>selectableFunction</code></li>
		 *     <li><code>selectableField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the selectable field is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.itemHasSelectable = true;
		 * renderer.selectableField = "isSelectable";</listing>
		 *
		 * @default "selectable"
		 *
		 * @see #selectableFunction
		 */
		public function get selectableField():String
		{
			return this._selectableField;
		}

		/**
		 * @private
		 */
		public function set selectableField(value:String):void
		{
			if(this._selectableField == value)
			{
				return;
			}
			this._selectableField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _selectableFunction:Function;

		/**
		 * A function used to determine if a specific item is selectable. If this
		 * function is not null, then the <code>selectableField</code> will be
		 * ignored.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:Object ):Boolean</pre>
		 *
		 * <p>All of the selectable fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>selectableFunction</code></li>
		 *     <li><code>selectableField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the selectable function is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.itemHasSelectable = true;
		 * renderer.selectableFunction = function( item:Object ):Boolean
		 * {
		 *    return item.isSelectable;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see #selectableField
		 */
		public function get selectableFunction():Function
		{
			return this._selectableFunction;
		}

		/**
		 * @private
		 */
		public function set selectableFunction(value:Function):void
		{
			if(this._selectableFunction == value)
			{
				return;
			}
			this._selectableFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _enabledField:String = "enabled";

		/**
		 * The field in the item that determines if the item renderer is
		 * enabled, if the list is enabled. If the item does not have
		 * this field, and a <code>enabledFunction</code> is not defined,
		 * then the renderer will default to being enabled.
		 *
		 * <p>All of the label fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>enabledFunction</code></li>
		 *     <li><code>enabledField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the enabled field is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.itemHasEnabled = true;
		 * renderer.enabledField = "isEnabled";</listing>
		 *
		 * @default "enabled"
		 *
		 * @see #enabledFunction
		 */
		public function get enabledField():String
		{
			return this._enabledField;
		}

		/**
		 * @private
		 */
		public function set enabledField(value:String):void
		{
			if(this._enabledField == value)
			{
				return;
			}
			this._enabledField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _enabledFunction:Function;

		/**
		 * A function used to determine if a specific item is enabled. If this
		 * function is not null, then the <code>enabledField</code> will be
		 * ignored.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:Object ):Boolean</pre>
		 *
		 * <p>All of the enabled fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>enabledFunction</code></li>
		 *     <li><code>enabledField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the enabled function is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.itemHasEnabled = true;
		 * renderer.enabledFunction = function( item:Object ):Boolean
		 * {
		 *    return item.isEnabled;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see #enabledField
		 */
		public function get enabledFunction():Function
		{
			return this._enabledFunction;
		}

		/**
		 * @private
		 */
		public function set enabledFunction(value:Function):void
		{
			if(this._enabledFunction == value)
			{
				return;
			}
			this._enabledFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _explicitIsToggle:Boolean = false;

		/**
		 * @private
		 */
		override public function set isToggle(value:Boolean):void
		{
			if(this._explicitIsToggle == value)
			{
				return;
			}
			super.isToggle = value;
			this._explicitIsToggle = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _explicitIsEnabled:Boolean;

		/**
		 * @private
		 */
		override public function set isEnabled(value:Boolean):void
		{
			if(this._explicitIsEnabled == value)
			{
				return;
			}
			this._explicitIsEnabled = value;
			super.isEnabled = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _iconLoaderFactory:Function = defaultLoaderFactory;

		/**
		 * A function that generates an <code>ImageLoader</code> that uses the result
		 * of <code>iconSourceField</code> or <code>iconSourceFunction</code>.
		 * Useful for transforming the <code>ImageLoader</code> in some way. For
		 * example, you might want to scale the texture for current screen
		 * density or apply pixel snapping.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function():ImageLoader</pre>
		 *
		 * <p>In the following example, the loader factory is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.iconLoaderFactory = function():ImageLoader
		 * {
		 *    var loader:ImageLoader = new ImageLoader();
		 *    loader.scaleFactor = 2;
		 *    return loader;
		 * };</listing>
		 *
		 * @default function():ImageLoader { return new ImageLoader(); }
		 *
		 * @see feathers.controls.ImageLoader
		 * @see #iconSourceField
		 * @see #iconSourceFunction
		 */
		public function get iconLoaderFactory():Function
		{
			return this._iconLoaderFactory;
		}

		/**
		 * @private
		 */
		public function set iconLoaderFactory(value:Function):void
		{
			if(this._iconLoaderFactory == value)
			{
				return;
			}
			this._iconLoaderFactory = value;
			this._iconIsFromItem = false;
			this.replaceIcon(null);
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _iconLabelFactory:Function;

		/**
		 * A function that generates <code>ITextRenderer</code> that uses the result
		 * of <code>iconLabelField</code> or <code>iconLabelFunction</code>.
		 * CAn be used to set properties on the <code>ITextRenderer</code>.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function():ITextRenderer</pre>
		 *
		 * <p>In the following example, the icon label factory is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.iconLabelFactory = function():ITextRenderer
		 * {
		 *    var renderer:TextFieldTextRenderer = new TextFieldTextRenderer();
		 *    renderer.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333 );
		 *    renderer.embedFonts = true;
		 *    return renderer;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.ITextRenderer
		 * @see feathers.core.FeathersControl#defaultTextRendererFactory
		 * @see #iconLabelField
		 * @see #iconLabelFunction
		 */
		public function get iconLabelFactory():Function
		{
			return this._iconLabelFactory;
		}

		/**
		 * @private
		 */
		public function set iconLabelFactory(value:Function):void
		{
			if(this._iconLabelFactory == value)
			{
				return;
			}
			this._iconLabelFactory = value;
			this._iconIsFromItem = false;
			this.replaceIcon(null);
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _iconLabelProperties:PropertyProxy;

		/**
		 * An object that stores properties for the icon label text renderer
		 * sub-component (if using <code>iconLabelField</code> or
		 * <code>iconLabelFunction</code>), and the properties will be passed
		 * down to the text renderer when this component validates. The
		 * available properties depend on which <code>ITextRenderer</code>
		 * implementation is returned by <code>iconLabelFactory</code>. Refer to
		 * <a href="../../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
		 * for a list of available text renderer implementations.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>iconLabelFactory</code>
		 * function instead of using <code>iconLabelProperties</code> will
		 * result in better performance.</p>
		 *
		 * <p>In the following example, the icon label properties are customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.&#64;iconLabelProperties.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333 );
		 * renderer.&#64;iconLabelProperties.embedFonts = true;</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.ITextRenderer
		 * @see #iconLabelFactory
		 * @see #iconLabelField
		 * @see #iconLabelFunction
		 */
		public function get iconLabelProperties():Object
		{
			if(!this._iconLabelProperties)
			{
				this._iconLabelProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._iconLabelProperties;
		}

		/**
		 * @private
		 */
		public function set iconLabelProperties(value:Object):void
		{
			if(this._iconLabelProperties == value)
			{
				return;
			}
			if(!value)
			{
				value = new PropertyProxy();
			}
			if(!(value is PropertyProxy))
			{
				var newValue:PropertyProxy = new PropertyProxy();
				for(var propertyName:String in value)
				{
					newValue[propertyName] = value[propertyName];
				}
				value = newValue;
			}
			if(this._iconLabelProperties)
			{
				this._iconLabelProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._iconLabelProperties = PropertyProxy(value);
			if(this._iconLabelProperties)
			{
				this._iconLabelProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _accessoryLoaderFactory:Function = defaultLoaderFactory;

		/**
		 * A function that generates an <code>ImageLoader</code> that uses the result
		 * of <code>accessorySourceField</code> or <code>accessorySourceFunction</code>.
		 * Useful for transforming the <code>ImageLoader</code> in some way. For
		 * example, you might want to scale the texture for current screen
		 * density or apply pixel snapping.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function():ImageLoader</pre>
		 *
		 * <p>In the following example, the loader factory is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.accessoryLoaderFactory = function():ImageLoader
		 * {
		 *    var loader:ImageLoader = new ImageLoader();
		 *    loader.scaleFactor = 2;
		 *    return loader;
		 * };</listing>
		 *
		 * @default function():ImageLoader { return new ImageLoader(); }
		 *
		 * @see feathers.controls.ImageLoader
		 * @see #accessorySourceField;
		 * @see #accessorySourceFunction;
		 */
		public function get accessoryLoaderFactory():Function
		{
			return this._accessoryLoaderFactory;
		}

		/**
		 * @private
		 */
		public function set accessoryLoaderFactory(value:Function):void
		{
			if(this._accessoryLoaderFactory == value)
			{
				return;
			}
			this._accessoryLoaderFactory = value;
			this._accessoryIsFromItem = false;
			this.replaceAccessory(null);
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _accessoryLabelFactory:Function;

		/**
		 * A function that generates <code>ITextRenderer</code> that uses the result
		 * of <code>accessoryLabelField</code> or <code>accessoryLabelFunction</code>.
		 * CAn be used to set properties on the <code>ITextRenderer</code>.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function():ITextRenderer</pre>
		 *
		 * <p>In the following example, the accessory label factory is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.accessoryLabelFactory = function():ITextRenderer
		 * {
		 *    var renderer:TextFieldTextRenderer = new TextFieldTextRenderer();
		 *    renderer.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333 );
		 *    renderer.embedFonts = true;
		 *    return renderer;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.ITextRenderer
		 * @see feathers.core.FeathersControl#defaultTextRendererFactory
		 * @see #accessoryLabelField
		 * @see #accessoryLabelFunction
		 */
		public function get accessoryLabelFactory():Function
		{
			return this._accessoryLabelFactory;
		}

		/**
		 * @private
		 */
		public function set accessoryLabelFactory(value:Function):void
		{
			if(this._accessoryLabelFactory == value)
			{
				return;
			}
			this._accessoryLabelFactory = value;
			this._accessoryIsFromItem = false;
			this.replaceAccessory(null);
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _accessoryLabelProperties:PropertyProxy;

		/**
		 * An object that stores properties for the accessory label text
		 * renderer sub-component (if using <code>accessoryLabelField</code> or
		 * <code>accessoryLabelFunction</code>), and the properties will be
		 * passed down to the text renderer when this component validates. The
		 * available properties depend on which <code>ITextRenderer</code>
		 * implementation is returned by <code>accessoryLabelFactory</code>.
		 * Refer to <a href="../../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
		 * for a list of available text renderer implementations.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>accessoryLabelFactory</code>
		 * function instead of using <code>accessoryLabelProperties</code> will
		 * result in better performance.</p>
		 *
		 * <p>In the following example, the accessory label properties are customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.&#64;accessoryLabelProperties.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333 );
		 * renderer.&#64;accessoryLabelProperties.embedFonts = true;</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.ITextRenderer
		 * @see #accessoryLabelFactory
		 * @see #accessoryLabelField
		 * @see #accessoryLabelFunction
		 */
		public function get accessoryLabelProperties():Object
		{
			if(!this._accessoryLabelProperties)
			{
				this._accessoryLabelProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._accessoryLabelProperties;
		}

		/**
		 * @private
		 */
		public function set accessoryLabelProperties(value:Object):void
		{
			if(this._accessoryLabelProperties == value)
			{
				return;
			}
			if(!value)
			{
				value = new PropertyProxy();
			}
			if(!(value is PropertyProxy))
			{
				var newValue:PropertyProxy = new PropertyProxy();
				for(var propertyName:String in value)
				{
					newValue[propertyName] = value[propertyName];
				}
				value = newValue;
			}
			if(this._accessoryLabelProperties)
			{
				this._accessoryLabelProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._accessoryLabelProperties = PropertyProxy(value);
			if(this._accessoryLabelProperties)
			{
				this._accessoryLabelProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _skinLoaderFactory:Function = defaultLoaderFactory;

		/**
		 * A function that generates an <code>ImageLoader</code> that uses the result
		 * of <code>skinSourceField</code> or <code>skinSourceFunction</code>.
		 * Useful for transforming the <code>ImageLoader</code> in some way. For
		 * example, you might want to scale the texture for current screen
		 * density or apply pixel snapping.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function():ImageLoader</pre>
		 *
		 * <p>In the following example, the loader factory is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.skinLoaderFactory = function():ImageLoader
		 * {
		 *    var loader:ImageLoader = new ImageLoader();
		 *    loader.scaleFactor = 2;
		 *    return loader;
		 * };</listing>
		 *
		 * @default function():ImageLoader { return new ImageLoader(); }
		 *
		 * @see feathers.controls.ImageLoader
		 * @see #skinSourceField
		 * @see #skinSourceFunction
		 */
		public function get skinLoaderFactory():Function
		{
			return this._skinLoaderFactory;
		}

		/**
		 * @private
		 */
		public function set skinLoaderFactory(value:Function):void
		{
			if(this._skinLoaderFactory == value)
			{
				return;
			}
			this._skinLoaderFactory = value;
			this._skinIsFromItem = false;
			this.replaceSkin(null);
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _ignoreAccessoryResizes:Boolean = false;

		/**
		 * @private
		 */
		override public function dispose():void
		{
			if(this._iconIsFromItem)
			{
				this.replaceIcon(null);
			}
			if(this._accessoryIsFromItem)
			{
				this.replaceAccessory(null);
			}
			if(this._skinIsFromItem)
			{
				this.replaceSkin(null);
			}
			if(this._stateDelayTimer)
			{
				if(this._stateDelayTimer.running)
				{
					this._stateDelayTimer.stop();
				}
				this._stateDelayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, stateDelayTimer_timerCompleteHandler);
				this._stateDelayTimer = null;
			}
			super.dispose();
		}

		/**
		 * Using <code>labelField</code> and <code>labelFunction</code>,
		 * generates a label from the item.
		 *
		 * <p>All of the label fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>labelFunction</code></li>
		 *     <li><code>labelField</code></li>
		 * </ol>
		 */
		public function itemToLabel(item:Object):String
		{
			if(this._labelFunction !== null)
			{
				var labelResult:Object = this._labelFunction(item);
				if(labelResult is String)
				{
					return labelResult as String;
				}
				else if(labelResult !== null)
				{
					return labelResult.toString();
				}
			}
			else if(this._labelField !== null && item !== null && item.hasOwnProperty(this._labelField))
			{
				labelResult = item[this._labelField];
				if(labelResult is String)
				{
					return labelResult as String;
				}
				else if(labelResult !== null)
				{
					return labelResult.toString();
				}
			}
			else if(item is String)
			{
				return item as String;
			}
			else if(item !== null)
			{
				//we need to use strict equality here because the data can be
				//non-strictly equal to null
				return item.toString();
			}
			return null;
		}

		/**
		 * Uses the icon fields and functions to generate an icon for a specific
		 * item.
		 *
		 * <p>All of the icon fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>iconSourceFunction</code></li>
		 *     <li><code>iconSourceField</code></li>
		 *     <li><code>iconLabelFunction</code></li>
		 *     <li><code>iconLabelField</code></li>
		 *     <li><code>iconFunction</code></li>
		 *     <li><code>iconField</code></li>
		 * </ol>
		 */
		protected function itemToIcon(item:Object):DisplayObject
		{
			if(this._iconSourceFunction != null)
			{
				var source:Object = this._iconSourceFunction(item);
				this.refreshIconSource(source);
				return this.iconLoader;
			}
			else if(this._iconSourceField != null && item && item.hasOwnProperty(this._iconSourceField))
			{
				source = item[this._iconSourceField];
				this.refreshIconSource(source);
				return this.iconLoader;
			}
			else if(this._iconLabelFunction != null)
			{
				var labelResult:Object = this._iconLabelFunction(item);
				if(labelResult is String)
				{
					this.refreshIconLabel(labelResult as String);
				}
				else
				{
					this.refreshIconLabel(labelResult.toString());
				}
				return DisplayObject(this.iconLabel);
			}
			else if(this._iconLabelField != null && item && item.hasOwnProperty(this._iconLabelField))
			{
				labelResult = item[this._iconLabelField];
				if(labelResult is String)
				{
					this.refreshIconLabel(labelResult as String);
				}
				else
				{
					this.refreshIconLabel(labelResult.toString());
				}
				return DisplayObject(this.iconLabel);
			}
			else if(this._iconFunction != null)
			{
				return this._iconFunction(item) as DisplayObject;
			}
			else if(this._iconField != null && item && item.hasOwnProperty(this._iconField))
			{
				return item[this._iconField] as DisplayObject;
			}

			return null;
		}

		/**
		 * Uses the accessory fields and functions to generate an accessory for
		 * a specific item.
		 *
		 * <p>All of the accessory fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>accessorySourceFunction</code></li>
		 *     <li><code>accessorySourceField</code></li>
		 *     <li><code>accessoryLabelFunction</code></li>
		 *     <li><code>accessoryLabelField</code></li>
		 *     <li><code>accessoryFunction</code></li>
		 *     <li><code>accessoryField</code></li>
		 * </ol>
		 */
		protected function itemToAccessory(item:Object):DisplayObject
		{
			if(this._accessorySourceFunction != null)
			{
				var source:Object = this._accessorySourceFunction(item);
				this.refreshAccessorySource(source);
				return this.accessoryLoader;
			}
			else if(this._accessorySourceField != null && item && item.hasOwnProperty(this._accessorySourceField))
			{
				source = item[this._accessorySourceField];
				this.refreshAccessorySource(source);
				return this.accessoryLoader;
			}
			else if(this._accessoryLabelFunction != null)
			{
				var labelResult:Object = this._accessoryLabelFunction(item);
				if(labelResult is String)
				{
					this.refreshAccessoryLabel(labelResult as String);
				}
				else
				{
					this.refreshAccessoryLabel(labelResult.toString());
				}
				return DisplayObject(this.accessoryLabel);
			}
			else if(this._accessoryLabelField != null && item && item.hasOwnProperty(this._accessoryLabelField))
			{
				labelResult = item[this._accessoryLabelField];
				if(labelResult is String)
				{
					this.refreshAccessoryLabel(labelResult as String);
				}
				else
				{
					this.refreshAccessoryLabel(labelResult.toString());
				}
				return DisplayObject(this.accessoryLabel);
			}
			else if(this._accessoryFunction != null)
			{
				return this._accessoryFunction(item) as DisplayObject;
			}
			else if(this._accessoryField != null && item && item.hasOwnProperty(this._accessoryField))
			{
				return item[this._accessoryField] as DisplayObject;
			}

			return null;
		}

		/**
		 * Uses the skin fields and functions to generate a skin for a specific
		 * item.
		 *
		 * <p>All of the skin fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>skinSourceFunction</code></li>
		 *     <li><code>skinSourceField</code></li>
		 *     <li><code>skinFunction</code></li>
		 *     <li><code>skinField</code></li>
		 * </ol>
		 */
		protected function itemToSkin(item:Object):DisplayObject
		{
			if(this._skinSourceFunction != null)
			{
				var source:Object = this._skinSourceFunction(item);
				this.refreshSkinSource(source);
				return this.skinLoader;
			}
			else if(this._skinSourceField != null && item && item.hasOwnProperty(this._skinSourceField))
			{
				source = item[this._skinSourceField];
				this.refreshSkinSource(source);
				return this.skinLoader;
			}
			else if(this._skinFunction != null)
			{
				return this._skinFunction(item) as DisplayObject;
			}
			else if(this._skinField != null && item && item.hasOwnProperty(this._skinField))
			{
				return item[this._skinField] as DisplayObject;
			}

			return null;
		}

		/**
		 * Uses the selectable fields and functions to generate a selectable
		 * value for a specific item.
		 *
		 * <p>All of the selectable fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>selectableFunction</code></li>
		 *     <li><code>selectableField</code></li>
		 * </ol>
		 */
		protected function itemToSelectable(item:Object):Boolean
		{
			if(this._selectableFunction != null)
			{
				return this._selectableFunction(item) as Boolean;
			}
			else if(this._selectableField != null && item && item.hasOwnProperty(this._selectableField))
			{
				return item[this._selectableField] as Boolean;
			}

			return true;
		}

		/**
		 * Uses the enabled fields and functions to generate a enabled value for
		 * a specific item.
		 *
		 * <p>All of the enabled fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>enabledFunction</code></li>
		 *     <li><code>enabledField</code></li>
		 * </ol>
		 */
		protected function itemToEnabled(item:Object):Boolean
		{
			if(this._enabledFunction != null)
			{
				return this._enabledFunction(item) as Boolean;
			}
			else if(this._enabledField != null && item && item.hasOwnProperty(this._enabledField))
			{
				return item[this._enabledField] as Boolean;
			}

			return true;
		}

		/**
		 * Gets the accessory to be used by the button when its
		 * <code>currentState</code> property matches the specified state value.
		 *
		 * <p>If a accessory is not defined for a specific state, returns
		 * <code>null</code>.</p>
		 *
		 * @see #setAccessoryForState()
		 */
		public function getAccessoryForState(state:String):DisplayObject
		{
			return this._stateToAccessory[state] as DisplayObject;
		}

		/**
		 * Sets the accessory to be used by the item renderer when its
		 * <code>currentState</code> property matches the specified state value.
		 *
		 * <p>If an accessory is not defined for a specific state, the value of
		 * the <code>defaultAccessory</code> property will be used instead.</p>
		 *
		 * @see #defaultAccessory
		 */
		public function setAccessoryForState(state:String, accessory:DisplayObject):void
		{
			if(accessory !== null)
			{
				this._stateToAccessory[state] = accessory;
			}
			else
			{
				delete this._stateToAccessory[state];
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			if(dataInvalid)
			{
				this.commitData();
			}
			if(stateInvalid || dataInvalid || stylesInvalid)
			{
				this.refreshAccessory();
			}
			super.draw();
		}

		/**
		 * @inheritDoc
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

			var oldIgnoreAccessoryResizes:Boolean = this._ignoreAccessoryResizes;
			this._ignoreAccessoryResizes = true;
			var labelRenderer:ITextRenderer = null;
			if(this._label !== null && this.labelTextRenderer)
			{
				labelRenderer = this.labelTextRenderer;
				this.refreshMaxLabelSize(true);
				this.labelTextRenderer.measureText(HELPER_POINT);
			}
			
			resetFluidChildDimensionsForMeasurement(this.currentSkin,
				this._explicitWidth, this._explicitHeight,
				this._explicitMinWidth, this._explicitMinHeight,
				this._explicitSkinWidth, this._explicitSkinHeight,
				this._explicitSkinMinWidth, this._explicitSkinMinHeight);
			var measureSkin:IMeasureDisplayObject = this.currentSkin as IMeasureDisplayObject;
			
			var newWidth:Number = this._explicitWidth;
			if(needsWidth)
			{
				if(labelRenderer !== null)
				{
					newWidth = HELPER_POINT.x;
				}
				else
				{
					newWidth = 0;
				}
				if(this._layoutOrder === ItemRendererLayoutOrder.LABEL_ACCESSORY_ICON)
				{
					newWidth = this.addAccessoryWidth(newWidth);
					newWidth = this.addIconWidth(newWidth);
				}
				else
				{
					newWidth = this.addIconWidth(newWidth);
					newWidth = this.addAccessoryWidth(newWidth);
				}
				newWidth += this._paddingLeft + this._paddingRight;
				if(this.currentSkin !== null &&
					this.currentSkin.width > newWidth)
				{
					newWidth = this.currentSkin.width;
				}
			}

			var newHeight:Number = this._explicitHeight;
			if(needsHeight)
			{
				if(labelRenderer !== null)
				{
					newHeight = HELPER_POINT.y;
				}
				else
				{
					newHeight = 0;
				}
				if(this._layoutOrder === ItemRendererLayoutOrder.LABEL_ACCESSORY_ICON)
				{
					newHeight = this.addAccessoryHeight(newHeight);
					newHeight = this.addIconHeight(newHeight);
				}
				else
				{
					newHeight = this.addIconHeight(newHeight);
					newHeight = this.addAccessoryHeight(newHeight);
				}
				newHeight += this._paddingTop + this._paddingBottom;
				if(this.currentSkin !== null &&
					this.currentSkin.height > newHeight)
				{
					newHeight = this.currentSkin.height;
				}
			}

			var newMinWidth:Number = this._explicitMinWidth;
			if(needsMinWidth)
			{
				if(labelRenderer !== null)
				{
					newMinWidth = HELPER_POINT.x;
				}
				else
				{
					newMinWidth = 0;
				}
				if(this._layoutOrder === ItemRendererLayoutOrder.LABEL_ACCESSORY_ICON)
				{
					newMinWidth = this.addAccessoryWidth(newMinWidth);
					newMinWidth = this.addIconWidth(newMinWidth);
				}
				else
				{
					newMinWidth = this.addIconWidth(newMinWidth);
					newMinWidth = this.addAccessoryWidth(newMinWidth);
				}
				newMinWidth += this._paddingLeft + this._paddingRight;
				if(this.currentSkin !== null)
				{
					if(measureSkin !== null)
					{
						if(measureSkin.minWidth > newMinWidth)
						{
							newMinWidth = measureSkin.minWidth;
						}
					}
					else if(this._explicitSkinMinWidth > newMinWidth)
					{
						newMinWidth = this._explicitSkinMinWidth;
					}
				}
			}

			var newMinHeight:Number = this._explicitMinHeight;
			if(needsMinHeight)
			{
				if(labelRenderer !== null)
				{
					newMinHeight = HELPER_POINT.y;
				}
				else
				{
					newMinHeight = 0;
				}
				if(this._layoutOrder === ItemRendererLayoutOrder.LABEL_ACCESSORY_ICON)
				{
					newMinHeight = this.addAccessoryHeight(newMinHeight);
					newMinHeight = this.addIconHeight(newMinHeight);
				}
				else
				{
					newMinHeight = this.addIconHeight(newMinHeight);
					newMinHeight = this.addAccessoryHeight(newMinHeight);
				}
				newMinHeight += this._paddingTop + this._paddingBottom;
				if(this.currentSkin !== null)
				{
					if(measureSkin !== null)
					{
						if(measureSkin.minHeight > newMinHeight)
						{
							newMinHeight = measureSkin.minHeight;
						}
					}
					else if(this._explicitSkinMinHeight > newMinHeight)
					{
						newMinHeight = this._explicitSkinMinHeight;
					}
				}
			}
			this._ignoreAccessoryResizes = oldIgnoreAccessoryResizes;

			return this.saveMeasurements(newWidth, newHeight, newMinWidth, newMinHeight);
		}

		/**
		 * @private
		 */
		override protected function changeState(value:String):void
		{
			if(this._isEnabled && !this._isToggle && (!this.isSelectableWithoutToggle || (this._itemHasSelectable && !this.itemToSelectable(this._data))))
			{
				value = ButtonState.UP;
			}
			if(this._useStateDelayTimer)
			{
				if(this._stateDelayTimer && this._stateDelayTimer.running)
				{
					this._delayedCurrentState = value;
					return;
				}

				if(value == ButtonState.DOWN)
				{
					if(this._currentState === value)
					{
						return;
					}
					this._delayedCurrentState = value;
					if(this._stateDelayTimer)
					{
						this._stateDelayTimer.reset();
					}
					else
					{
						this._stateDelayTimer = new Timer(DOWN_STATE_DELAY_MS, 1);
						this._stateDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, stateDelayTimer_timerCompleteHandler);
					}
					this._stateDelayTimer.start();
					return;
				}
			}
			super.changeState(value);
		}

		/**
		 * @private
		 */
		protected function addIconWidth(width:Number):Number
		{
			if(!this.currentIcon)
			{
				return width;
			}
			var iconWidth:Number = this.currentIcon.width;
			if(iconWidth !== iconWidth) //isNaN
			{
				return width;
			}

			var hasPreviousItem:Boolean = width === width; //!isNaN
			if(!hasPreviousItem)
			{
				width = 0;
			}

			if(this._iconPosition == RelativePosition.LEFT || this._iconPosition == RelativePosition.LEFT_BASELINE || this._iconPosition == RelativePosition.RIGHT || this._iconPosition == RelativePosition.RIGHT_BASELINE)
			{
				if(hasPreviousItem)
				{
					var adjustedGap:Number = this._gap;
					if(this._gap == Number.POSITIVE_INFINITY)
					{
						adjustedGap = this._minGap;
					}
					width += adjustedGap;
				}
				width += iconWidth;
			}
			else if(iconWidth > width)
			{
				width = iconWidth;
			}
			return width;
		}

		/**
		 * @private
		 */
		protected function addAccessoryWidth(width:Number):Number
		{
			if(!this.currentAccessory)
			{
				return width;
			}
			var accessoryWidth:Number = this.currentAccessory.width;
			if(accessoryWidth !== accessoryWidth) //isNaN
			{
				return width;
			}

			var hasPreviousItem:Boolean = width === width; //!isNaN;
			if(!hasPreviousItem)
			{
				width = 0;
			}

			if(this._accessoryPosition == RelativePosition.LEFT || this._accessoryPosition == RelativePosition.RIGHT)
			{
				if(hasPreviousItem)
				{
					var adjustedAccessoryGap:Number = this._accessoryGap;
					//for some reason, if we do the !== check on a local variable right
					//here, compiling with the flex 4.6 SDK will throw a VerifyError
					//for a stack overflow.
					//we could change the !== check back to isNaN() instead, but
					//isNaN() can allocate an object that needs garbage collection.
					if(this._accessoryGap !== this._accessoryGap) //isNaN
					{
						adjustedAccessoryGap = this._gap;
					}
					if(adjustedAccessoryGap == Number.POSITIVE_INFINITY)
					{
						if(this._minAccessoryGap !== this._minAccessoryGap) //isNaN
						{
							adjustedAccessoryGap = this._minGap;
						}
						else
						{
							adjustedAccessoryGap = this._minAccessoryGap;
						}
					}
					width += adjustedAccessoryGap;
				}
				width += accessoryWidth;
			}
			else if(accessoryWidth > width)
			{
				width = accessoryWidth;
			}
			return width;
		}


		/**
		 * @private
		 */
		protected function addIconHeight(height:Number):Number
		{
			if(this.currentIcon === null)
			{
				return height;
			}
			var iconHeight:Number = this.currentIcon.height;
			if(iconHeight !== iconHeight) //isNaN
			{
				return height;
			}

			var hasPreviousItem:Boolean = height === height; //!isNaN
			if(!hasPreviousItem)
			{
				height = 0;
			}

			if(this._iconPosition === RelativePosition.TOP || this._iconPosition === RelativePosition.BOTTOM)
			{
				if(hasPreviousItem)
				{
					var adjustedGap:Number = this._gap;
					if(this._gap === Number.POSITIVE_INFINITY)
					{
						adjustedGap = this._minGap;
					}
					height += adjustedGap;
				}
				height += iconHeight;
			}
			else if(iconHeight > height)
			{
				height = iconHeight;
			}
			return height;
		}

		/**
		 * @private
		 */
		protected function addAccessoryHeight(height:Number):Number
		{
			if(this.currentAccessory === null)
			{
				return height;
			}
			var accessoryHeight:Number = this.currentAccessory.height;
			if(accessoryHeight !== accessoryHeight) //isNaN
			{
				return height;
			}

			var hasPreviousItem:Boolean = height === height; //!isNaN
			if(!hasPreviousItem)
			{
				height = 0;
			}

			if(this._accessoryPosition === RelativePosition.TOP || this._accessoryPosition === RelativePosition.BOTTOM)
			{
				if(hasPreviousItem)
				{
					var adjustedAccessoryGap:Number = this._accessoryGap;
					//for some reason, if we do the !== check on a local variable right
					//here, compiling with the flex 4.6 SDK will throw a VerifyError
					//for a stack overflow.
					//we could change the !== check back to isNaN() instead, but
					//isNaN() can allocate an object that needs garbage collection.
					if(this._accessoryGap !== this._accessoryGap) //isNaN
					{
						adjustedAccessoryGap =  this._gap;
					}
					if(adjustedAccessoryGap === Number.POSITIVE_INFINITY)
					{
						if(this._minAccessoryGap !== this._minAccessoryGap) //isNaN
						{
							adjustedAccessoryGap = this._minGap;
						}
						else
						{
							adjustedAccessoryGap = this._minAccessoryGap;
						}
					}
					height += adjustedAccessoryGap;
				}
				height += accessoryHeight;
			}
			else if(accessoryHeight > height)
			{
				height = accessoryHeight;
			}
			return height;
		}

		/**
		 * Updates the renderer to display the item's data. Override this
		 * function to pass data to sub-components and react to data changes.
		 *
		 * <p>Don't forget to handle the case where the data is <code>null</code>.</p>
		 */
		protected function commitData():void
		{
			//we need to use strict equality here because the data can be
			//non-strictly equal to null
			if(this._data !== null && this._owner)
			{
				if(this._itemHasLabel)
				{
					this._label = this.itemToLabel(this._data);
					//we don't need to invalidate because the label setter
					//uses the same data invalidation flag that triggered this
					//call to commitData(), so we're already properly invalid.
				}
				if(this._itemHasSkin)
				{
					var newSkin:DisplayObject = this.itemToSkin(this._data);
					this._skinIsFromItem = newSkin != null;
					this.replaceSkin(newSkin);
				}
				else if(this._skinIsFromItem)
				{
					this._skinIsFromItem = false;
					this.replaceSkin(null);
				}
				if(this._itemHasIcon)
				{
					var newIcon:DisplayObject = this.itemToIcon(this._data);
					this._iconIsFromItem = newIcon != null;
					this.replaceIcon(newIcon);
				}
				else if(this._iconIsFromItem)
				{
					this._iconIsFromItem = false;
					this.replaceIcon(null);
				}
				if(this._itemHasAccessory)
				{
					var newAccessory:DisplayObject = this.itemToAccessory(this._data);
					this._accessoryIsFromItem = newAccessory != null;
					this.replaceAccessory(newAccessory);
				}
				else if(this._accessoryIsFromItem)
				{
					this._accessoryIsFromItem = false;
					this.replaceAccessory(null);
				}
				if(this._itemHasSelectable)
				{
					this._isToggle = this._explicitIsToggle && this.itemToSelectable(this._data);
				}
				else
				{
					this._isToggle = this._explicitIsToggle;
				}
				if(this._itemHasEnabled)
				{
					this.refreshIsEnabled(this._explicitIsEnabled && this.itemToEnabled(this._data));
				}
				else
				{
					this.refreshIsEnabled(this._explicitIsEnabled);
				}
			}
			else
			{
				if(this._itemHasLabel)
				{
					this._label = "";
				}
				if(this._itemHasIcon || this._iconIsFromItem)
				{
					this._iconIsFromItem = false;
					this.replaceIcon(null);
				}
				if(this._itemHasSkin || this._skinIsFromItem)
				{
					this._skinIsFromItem = false;
					this.replaceSkin(null);
				}
				if(this._itemHasAccessory || this._accessoryIsFromItem)
				{
					this._accessoryIsFromItem = false;
					this.replaceAccessory(null);
				}
				if(this._itemHasSelectable)
				{
					this._isToggle = this._explicitIsToggle;
				}
				if(this._itemHasEnabled)
				{
					this.refreshIsEnabled(this._explicitIsEnabled);
				}
			}
		}

		/**
		 * @private
		 */
		protected function refreshIsEnabled(value:Boolean):void
		{
			if(this._isEnabled == value)
			{
				return;
			}
			this._isEnabled = value;
			if(!this._isEnabled)
			{
				this.touchable = false;
				this._currentState = ButtonState.DISABLED;
				this.touchPointID = -1;
			}
			else
			{
				//might be in another state for some reason
				//let's only change to up if needed
				if(this._currentState == ButtonState.DISABLED)
				{
					this._currentState = ButtonState.UP;
				}
				this.touchable = true;
			}
			this.setInvalidationFlag(INVALIDATION_FLAG_STATE);
			this.dispatchEventWith(FeathersEventType.STATE_CHANGE);
		}

		/**
		 * @private
		 */
		protected function replaceIcon(newIcon:DisplayObject):void
		{
			if(this.iconLoader && this.iconLoader != newIcon)
			{
				this.iconLoader.removeEventListener(Event.COMPLETE, loader_completeOrErrorHandler);
				this.iconLoader.removeEventListener(FeathersEventType.ERROR, loader_completeOrErrorHandler);
				this.iconLoader.dispose();
				this.iconLoader = null;
			}

			if(this.iconLabel && this.iconLabel != newIcon)
			{
				//we can dispose this one, though, since we created it
				this.iconLabel.dispose();
				this.iconLabel = null;
			}

			if(this._itemHasIcon && this.currentIcon && this.currentIcon != newIcon && this.currentIcon.parent == this)
			{
				//the icon is created using the data provider, and it is not
				//created inside this class, so it is not our responsibility to
				//dispose the icon. if we dispose it, it may break something.
				this.currentIcon.removeFromParent(false);
				this.currentIcon = null;
			}
			//we're using currentIcon above, but we're emulating calling the
			//defaultIcon setter here. the Button class sets the currentIcon
			//elsewhere, so we want to take advantage of that exisiting code.

			//we're not calling the defaultIcon setter directly because we're in
			//the middle of validating, and it will just invalidate, which will
			//require another validation later. we want the Button class to
			//process the new icon immediately when we call super.draw().
			if(this._defaultIcon !== newIcon)
			{
				this._defaultIcon = newIcon;
				//we don't want this taking precedence over our icon from the
				//data provider.
				this._stateToIconFunction = null;
				//we don't need to do a full invalidation. the superclass will
				//correctly see this flag when we call super.draw().
				this.setInvalidationFlag(INVALIDATION_FLAG_STYLES);
			}

			if(this.iconLoader)
			{
				this.iconLoader.delayTextureCreation = this._delayTextureCreationOnScroll && this._owner.isScrolling;
			}
		}

		/**
		 * @private
		 */
		protected function replaceAccessory(newAccessory:DisplayObject):void
		{
			if(this.accessoryLoader && this.accessoryLoader != newAccessory)
			{
				this.accessoryLoader.removeEventListener(Event.COMPLETE, loader_completeOrErrorHandler);
				this.accessoryLoader.removeEventListener(FeathersEventType.ERROR, loader_completeOrErrorHandler);
				this.accessoryLoader.dispose();
				this.accessoryLoader = null;
			}

			if(this.accessoryLabel && this.accessoryLabel != newAccessory)
			{
				//we can dispose this one, though, since we created it
				this.accessoryLabel.dispose();
				this.accessoryLabel = null;
			}

			if(this._itemHasAccessory && this.currentAccessory && this.currentAccessory != newAccessory && this.currentAccessory.parent == this)
			{
				//the icon is created using the data provider, and it is not
				//created inside this class, so it is not our responsibility to
				//dispose the icon. if we dispose it, it may break something.
				this.currentAccessory.removeFromParent(false);
				this.currentAccessory = null;
			}
			//we're using currentIcon above, but we're emulating calling the
			//defaultIcon setter here. the Button class sets the currentIcon
			//elsewhere, so we want to take advantage of that exisiting code.

			//we're not calling the defaultIcon setter directly because we're in
			//the middle of validating, and it will just invalidate, which will
			//require another validation later. we want the Button class to
			//process the new icon immediately when we call super.draw().
			if(this._defaultAccessory !== newAccessory)
			{
				this._defaultAccessory = newAccessory;
				//we don't want this taking precedence over our icon from the
				//data provider.
				this._stateToAccessoryFunction = null;
				//we don't need to do a full invalidation. the superclass will
				//correctly see this flag when we call super.draw().
				this.setInvalidationFlag(INVALIDATION_FLAG_STYLES);
			}

			if(this.accessoryLoader)
			{
				this.accessoryLoader.delayTextureCreation = this._delayTextureCreationOnScroll && this._owner.isScrolling;
			}
		}

		/**
		 * @private
		 */
		protected function replaceSkin(newSkin:DisplayObject):void
		{
			if(this.skinLoader && this.skinLoader != newSkin)
			{
				this.skinLoader.removeEventListener(Event.COMPLETE, loader_completeOrErrorHandler);
				this.skinLoader.removeEventListener(FeathersEventType.ERROR, loader_completeOrErrorHandler);
				this.skinLoader.dispose();
				this.skinLoader = null;
			}

			if(this._itemHasSkin && this.currentSkin && this.currentSkin != newSkin && this.currentSkin.parent == this)
			{
				//the icon is created using the data provider, and it is not
				//created inside this class, so it is not our responsibility to
				//dispose the icon. if we dispose it, it may break something.
				this.currentSkin.removeFromParent(false);
				this.currentSkin = null;
			}
			//we're using currentIcon above, but we're emulating calling the
			//defaultIcon setter here. the Button class sets the currentIcon
			//elsewhere, so we want to take advantage of that exisiting code.

			//we're not calling the defaultSkin setter directly because we're in
			//the middle of validating, and it will just invalidate, which will
			//require another validation later. we want the Button class to
			//process the new skin immediately when we call super.draw().
			if(this._defaultSkin !== newSkin)
			{
				this._defaultSkin = newSkin;
				//we don't want this taking precedence over our skin from the
				//data provider.
				this._stateToSkinFunction = null;
				//we don't need to do a full invalidation. the superclass will
				//correctly see this flag when we call super.draw().
				this.setInvalidationFlag(INVALIDATION_FLAG_STYLES);
			}

			if(this.skinLoader)
			{
				this.skinLoader.delayTextureCreation = this._delayTextureCreationOnScroll && this._owner.isScrolling;
			}
		}

		/**
		 * @private
		 */
		override protected function refreshIcon():void
		{
			super.refreshIcon();
			if(this.iconLabel)
			{
				var displayIconLabel:DisplayObject = DisplayObject(this.iconLabel);
				for(var propertyName:String in this._iconLabelProperties)
				{
					var propertyValue:Object = this._iconLabelProperties[propertyName];
					displayIconLabel[propertyName] = propertyValue;
				}
			}
		}

		/**
		 * @private
		 */
		protected function refreshAccessory():void
		{
			var oldAccessory:DisplayObject = this.currentAccessory;
			this.currentAccessory = this.getCurrentAccessory();
			if(this.currentAccessory is IFeathersControl)
			{
				IFeathersControl(this.currentAccessory).isEnabled = this._isEnabled;
			}
			if(this.currentAccessory != oldAccessory)
			{
				if(oldAccessory)
				{
					if(oldAccessory is IStateObserver)
					{
						IStateObserver(oldAccessory).stateContext = null;
					}
					if(oldAccessory is IFeathersControl)
					{
						IFeathersControl(oldAccessory).removeEventListener(FeathersEventType.RESIZE, accessory_resizeHandler);
						IFeathersControl(oldAccessory).removeEventListener(TouchEvent.TOUCH, accessory_touchHandler);
					}
					this.removeChild(oldAccessory, false);
				}
				if(this.currentAccessory)
				{
					if(this.currentAccessory is IStateObserver)
					{
						IStateObserver(this.currentAccessory).stateContext = this;
					}
					this.addChild(this.currentAccessory);
					if(this.currentAccessory is IFeathersControl)
					{
						IFeathersControl(this.currentAccessory).addEventListener(FeathersEventType.RESIZE, accessory_resizeHandler);
						IFeathersControl(this.currentAccessory).addEventListener(TouchEvent.TOUCH, accessory_touchHandler);
					}
				}
			}
			if(this.accessoryLabel)
			{
				var displayAccessoryLabel:DisplayObject = DisplayObject(this.accessoryLabel);
				for(var propertyName:String in this._accessoryLabelProperties)
				{
					var propertyValue:Object = this._accessoryLabelProperties[propertyName];
					displayAccessoryLabel[propertyName] = propertyValue;
				}
			}
		}

		/**
		 * @private
		 */
		protected function getCurrentAccessory():DisplayObject
		{
			if(this._stateToAccessoryFunction !== null)
			{
				return DisplayObject(this._stateToAccessoryFunction(this, this._currentState, this.currentAccessory));
			}
			var result:DisplayObject = this._stateToAccessory[this._currentState] as DisplayObject;
			if(result !== null)
			{
				return result;
			}
			return this._defaultAccessory;
		}

		/**
		 * @private
		 */
		protected function refreshIconSource(source:Object):void
		{
			if(!this.iconLoader)
			{
				this.iconLoader = this._iconLoaderFactory();
				this.iconLoader.addEventListener(Event.COMPLETE, loader_completeOrErrorHandler);
				this.iconLoader.addEventListener(FeathersEventType.ERROR, loader_completeOrErrorHandler);
			}
			this.iconLoader.source = source;
		}

		/**
		 * @private
		 */
		protected function refreshIconLabel(label:String):void
		{
			if(!this.iconLabel)
			{
				var factory:Function = this._iconLabelFactory != null ? this._iconLabelFactory : FeathersControl.defaultTextRendererFactory;
				this.iconLabel = ITextRenderer(factory());
				if(this.iconLabel is IStateObserver)
				{
					IStateObserver(this.iconLabel).stateContext = this;
				}
				var iconLabelStyleName:String = this._customIconLabelStyleName != null ? this._customIconLabelStyleName : this.iconLabelStyleName;
				this.iconLabel.styleNameList.add(iconLabelStyleName);
			}
			this.iconLabel.text = label;
		}

		/**
		 * @private
		 */
		protected function refreshAccessorySource(source:Object):void
		{
			if(!this.accessoryLoader)
			{
				this.accessoryLoader = this._accessoryLoaderFactory();
				this.accessoryLoader.addEventListener(Event.COMPLETE, loader_completeOrErrorHandler);
				this.accessoryLoader.addEventListener(FeathersEventType.ERROR, loader_completeOrErrorHandler);
			}
			this.accessoryLoader.source = source;
		}

		/**
		 * @private
		 */
		protected function refreshAccessoryLabel(label:String):void
		{
			if(!this.accessoryLabel)
			{
				var factory:Function = this._accessoryLabelFactory != null ? this._accessoryLabelFactory : FeathersControl.defaultTextRendererFactory;
				this.accessoryLabel = ITextRenderer(factory());
				if(this.accessoryLabel is IStateObserver)
				{
					IStateObserver(this.accessoryLabel).stateContext = this;
				}
				var accessoryLabelStyleName:String = this._customAccessoryLabelStyleName != null ? this._customAccessoryLabelStyleName : this.accessoryLabelStyleName;
				this.accessoryLabel.styleNameList.add(accessoryLabelStyleName);
			}
			this.accessoryLabel.text = label;
		}

		/**
		 * @private
		 */
		protected function refreshSkinSource(source:Object):void
		{
			if(!this.skinLoader)
			{
				this.skinLoader = this._skinLoaderFactory();
				this.skinLoader.addEventListener(Event.COMPLETE, loader_completeOrErrorHandler);
				this.skinLoader.addEventListener(FeathersEventType.ERROR, loader_completeOrErrorHandler);
			}
			this.skinLoader.source = source;
		}

		/**
		 * @private
		 */
		override protected function layoutContent():void
		{
			var oldIgnoreAccessoryResizes:Boolean = this._ignoreAccessoryResizes;
			this._ignoreAccessoryResizes = true;
			var oldIgnoreIconResizes:Boolean = this._ignoreIconResizes;
			this._ignoreIconResizes = true;
			this.refreshMaxLabelSize(false);
			var labelRenderer:DisplayObject = null;
			if(this._label !== null && this.labelTextRenderer)
			{
				this.labelTextRenderer.validate();
				labelRenderer = DisplayObject(this.labelTextRenderer);
			}
			var iconIsInLayout:Boolean = this.currentIcon && this._iconPosition != RelativePosition.MANUAL;
			var accessoryIsInLayout:Boolean = this.currentAccessory && this._accessoryPosition != RelativePosition.MANUAL;
			var accessoryGap:Number = this._accessoryGap;
			if(accessoryGap !== accessoryGap) //isNaN
			{
				accessoryGap = this._gap;
			}
			if(labelRenderer && iconIsInLayout && accessoryIsInLayout)
			{
				this.positionSingleChild(labelRenderer);
				if(this._layoutOrder == ItemRendererLayoutOrder.LABEL_ACCESSORY_ICON)
				{
					this.positionRelativeToOthers(this.currentAccessory, labelRenderer, null, this._accessoryPosition, accessoryGap, null, 0);
					var iconPosition:String = this._iconPosition;
					if(iconPosition == RelativePosition.LEFT_BASELINE)
					{
						iconPosition = RelativePosition.LEFT;
					}
					else if(iconPosition == RelativePosition.RIGHT_BASELINE)
					{
						iconPosition = RelativePosition.RIGHT;
					}
					this.positionRelativeToOthers(this.currentIcon, labelRenderer, this.currentAccessory, iconPosition, this._gap, this._accessoryPosition, accessoryGap);
				}
				else
				{
					this.positionLabelAndIcon();
					this.positionRelativeToOthers(this.currentAccessory, labelRenderer, this.currentIcon, this._accessoryPosition, accessoryGap, this._iconPosition, this._gap);
				}
			}
			else if(labelRenderer)
			{
				this.positionSingleChild(labelRenderer);
				//we won't position both the icon and accessory here, otherwise
				//we would have gone into the previous conditional
				if(iconIsInLayout)
				{
					this.positionLabelAndIcon();
				}
				else if(accessoryIsInLayout)
				{
					this.positionRelativeToOthers(this.currentAccessory, labelRenderer, null, this._accessoryPosition, accessoryGap, null, 0);
				}
			}
			else if(iconIsInLayout)
			{
				this.positionSingleChild(this.currentIcon);
				if(accessoryIsInLayout)
				{
					this.positionRelativeToOthers(this.currentAccessory, this.currentIcon, null, this._accessoryPosition, accessoryGap, null, 0);
				}
			}
			else if(accessoryIsInLayout)
			{
				this.positionSingleChild(this.currentAccessory);
			}

			if(this.currentAccessory)
			{
				if(!accessoryIsInLayout)
				{
					this.currentAccessory.x = this._paddingLeft;
					this.currentAccessory.y = this._paddingTop;
				}
				this.currentAccessory.x += this._accessoryOffsetX;
				this.currentAccessory.y += this._accessoryOffsetY;
			}
			if(this.currentIcon)
			{
				if(!iconIsInLayout)
				{
					this.currentIcon.x = this._paddingLeft;
					this.currentIcon.y = this._paddingTop;
				}
				this.currentIcon.x += this._iconOffsetX;
				this.currentIcon.y += this._iconOffsetY;
			}
			if(labelRenderer)
			{
				this.labelTextRenderer.x += this._labelOffsetX;
				this.labelTextRenderer.y += this._labelOffsetY;
			}
			this._ignoreIconResizes = oldIgnoreIconResizes;
			this._ignoreAccessoryResizes = oldIgnoreAccessoryResizes;
		}

		/**
		 * @private
		 */
		override protected function refreshMaxLabelSize(forMeasurement:Boolean):void
		{
			var calculatedWidth:Number = this.actualWidth;
			if(forMeasurement)
			{
				calculatedWidth = this._explicitWidth;
				if(calculatedWidth !== calculatedWidth) //isNaN
				{
					calculatedWidth = this._explicitMaxWidth;
				}
			}
			calculatedWidth -= (this._paddingLeft + this._paddingRight);
			var calculatedHeight:Number = this.actualHeight;
			if(forMeasurement)
			{
				calculatedHeight = this._explicitHeight;
				if(calculatedHeight !== calculatedHeight) //isNaN
				{
					calculatedHeight = this._explicitMaxHeight;
				}
			}
			calculatedHeight -= (this._paddingTop + this._paddingBottom);

			var adjustedGap:Number = this._gap;
			if(adjustedGap == Number.POSITIVE_INFINITY)
			{
				adjustedGap = this._minGap;
			}
			var adjustedAccessoryGap:Number = this._accessoryGap;
			if(adjustedAccessoryGap !== adjustedAccessoryGap) //isNaN
			{
				adjustedAccessoryGap = this._gap;
			}
			if(adjustedAccessoryGap == Number.POSITIVE_INFINITY)
			{
				adjustedAccessoryGap = this._minAccessoryGap;
				if(adjustedAccessoryGap !== adjustedAccessoryGap) //isNaN
				{
					adjustedAccessoryGap = this._minGap;
				}
			}

			var hasIconToLeftOrRight:Boolean = this.currentIcon && (this._iconPosition == RelativePosition.LEFT || this._iconPosition == RelativePosition.LEFT_BASELINE ||
				this._iconPosition == RelativePosition.RIGHT || this._iconPosition == RelativePosition.RIGHT_BASELINE);
			var hasIconToTopOrBottom:Boolean = this.currentIcon && (this._iconPosition == RelativePosition.TOP || this._iconPosition == RelativePosition.BOTTOM);
			var hasAccessoryToLeftOrRight:Boolean = this.currentAccessory && (this._accessoryPosition == RelativePosition.LEFT || this._accessoryPosition == RelativePosition.RIGHT);
			var hasAccessoryToTopOrBottom:Boolean = this.currentAccessory && (this._accessoryPosition == RelativePosition.TOP || this._accessoryPosition == RelativePosition.BOTTOM);

			if(this.accessoryLabel)
			{
				var iconAffectsAccessoryLabelMaxWidth:Boolean = hasIconToLeftOrRight &&
					(hasAccessoryToLeftOrRight || this._layoutOrder === ItemRendererLayoutOrder.LABEL_ACCESSORY_ICON);
				if(this.iconLabel)
				{
					this.iconLabel.maxWidth = calculatedWidth - adjustedGap;
					if(this.iconLabel.maxWidth < 0)
					{
						this.iconLabel.maxWidth = 0;
					}
				}
				if(this.currentIcon is IValidating)
				{
					IValidating(this.currentIcon).validate();
				}
				if(iconAffectsAccessoryLabelMaxWidth)
				{
					calculatedWidth -= (this.currentIcon.width + adjustedGap);
				}
				if(calculatedWidth < 0)
				{
					calculatedWidth = 0;
				}
				this.accessoryLabel.maxWidth = calculatedWidth;
				this.accessoryLabel.maxHeight = calculatedHeight;
				if(hasIconToLeftOrRight && this.currentIcon && !iconAffectsAccessoryLabelMaxWidth)
				{
					calculatedWidth -= (this.currentIcon.width + adjustedGap);
				}
				if(this.currentAccessory is IValidating)
				{
					IValidating(this.currentAccessory).validate();
				}
				if(hasAccessoryToLeftOrRight)
				{
					calculatedWidth -= (this.currentAccessory.width + adjustedAccessoryGap);
				}
				if(hasAccessoryToTopOrBottom)
				{
					calculatedHeight -= (this.currentAccessory.height + adjustedAccessoryGap);
				}
			}
			else if(this.iconLabel)
			{
				var accessoryAffectsIconLabelMaxWidth:Boolean = hasAccessoryToLeftOrRight &&
					(hasIconToLeftOrRight || this._layoutOrder === ItemRendererLayoutOrder.LABEL_ICON_ACCESSORY);
				if(this.currentAccessory is IValidating)
				{
					IValidating(this.currentAccessory).validate();
				}
				if(accessoryAffectsIconLabelMaxWidth)
				{
					calculatedWidth -= (adjustedAccessoryGap + this.currentAccessory.width);
				}
				if(calculatedWidth < 0)
				{
					calculatedWidth = 0;
				}
				this.iconLabel.maxWidth = calculatedWidth;
				this.iconLabel.maxHeight = calculatedHeight;
				if(hasAccessoryToLeftOrRight && this.currentAccessory && !accessoryAffectsIconLabelMaxWidth)
				{
					calculatedWidth -= (adjustedAccessoryGap + this.currentAccessory.width);
				}
				if(this.currentIcon is IValidating)
				{
					IValidating(this.currentIcon).validate();
				}
				if(hasIconToLeftOrRight)
				{
					calculatedWidth -= (this.currentIcon.width + adjustedGap);
				}
				if(hasIconToTopOrBottom)
				{
					calculatedHeight -= (this.currentIcon.height + adjustedGap);
				}
			}
			else
			{
				if(this.currentIcon is IValidating)
				{
					IValidating(this.currentIcon).validate();
				}
				if(hasIconToLeftOrRight)
				{
					calculatedWidth -= (adjustedGap + this.currentIcon.width);
				}
				if(hasIconToTopOrBottom)
				{
					calculatedHeight -= (adjustedGap + this.currentIcon.height);
				}
				if(this.currentAccessory is IValidating)
				{
					IValidating(this.currentAccessory).validate();
				}
				if(hasAccessoryToLeftOrRight)
				{
					calculatedWidth -= (adjustedAccessoryGap + this.currentAccessory.width);
				}
				if(hasAccessoryToTopOrBottom)
				{
					calculatedHeight -= (adjustedAccessoryGap + this.currentAccessory.height);
				}
			}
			if(calculatedWidth < 0)
			{
				calculatedWidth = 0;
			}
			if(calculatedHeight < 0)
			{
				calculatedHeight = 0;
			}
			if(this.labelTextRenderer)
			{
				this.labelTextRenderer.maxWidth = calculatedWidth;
				this.labelTextRenderer.maxHeight = calculatedHeight;
			}
		}

		/**
		 * @private
		 */
		protected function positionRelativeToOthers(object:DisplayObject, relativeTo:DisplayObject, relativeTo2:DisplayObject, position:String, gap:Number, otherPosition:String, otherGap:Number):void
		{
			var relativeToX:Number = relativeTo2 ? Math.min(relativeTo.x, relativeTo2.x) : relativeTo.x;
			var relativeToY:Number = relativeTo2 ? Math.min(relativeTo.y, relativeTo2.y) : relativeTo.y;
			var relativeToWidth:Number = relativeTo2 ? (Math.max(relativeTo.x + relativeTo.width, relativeTo2.x + relativeTo2.width) - relativeToX) : relativeTo.width;
			var relativeToHeight:Number = relativeTo2 ? (Math.max(relativeTo.y + relativeTo.height, relativeTo2.y + relativeTo2.height) - relativeToY) : relativeTo.height;
			var newRelativeToX:Number = relativeToX;
			var newRelativeToY:Number = relativeToY;
			if(position == RelativePosition.TOP)
			{
				if(gap == Number.POSITIVE_INFINITY)
				{
					object.y = this._paddingTop;
					newRelativeToY = this.actualHeight - this._paddingBottom - relativeToHeight;
				}
				else
				{
					if(this._verticalAlign == VerticalAlign.TOP)
					{
						newRelativeToY += object.height + gap;
					}
					else if(this._verticalAlign == VerticalAlign.MIDDLE)
					{
						newRelativeToY += Math.round((object.height + gap) / 2);
					}
					if(relativeTo2)
					{
						newRelativeToY = Math.max(newRelativeToY, this._paddingTop + object.height + gap);
					}
					object.y = newRelativeToY - object.height - gap;
				}
			}
			else if(position == RelativePosition.RIGHT)
			{
				if(gap == Number.POSITIVE_INFINITY)
				{
					newRelativeToX = this._paddingLeft;
					object.x = this.actualWidth - this._paddingRight - object.width;
				}
				else
				{
					if(this._horizontalAlign == HorizontalAlign.RIGHT)
					{
						newRelativeToX -= (object.width + gap);
					}
					else if(this._horizontalAlign == HorizontalAlign.CENTER)
					{
						newRelativeToX -= Math.round((object.width + gap) / 2);
					}
					if(relativeTo2)
					{
						newRelativeToX = Math.min(newRelativeToX, this.actualWidth - this._paddingRight - object.width - relativeToWidth - gap);
					}
					object.x = newRelativeToX + relativeToWidth + gap;
				}
			}
			else if(position == RelativePosition.BOTTOM)
			{
				if(gap == Number.POSITIVE_INFINITY)
				{
					newRelativeToY = this._paddingTop;
					object.y = this.actualHeight - this._paddingBottom - object.height;
				}
				else
				{
					if(this._verticalAlign == VerticalAlign.BOTTOM)
					{
						newRelativeToY -= (object.height + gap);
					}
					else if(this._verticalAlign == VerticalAlign.MIDDLE)
					{
						newRelativeToY -= Math.round((object.height + gap) / 2);
					}
					if(relativeTo2)
					{
						newRelativeToY = Math.min(newRelativeToY, this.actualHeight - this._paddingBottom - object.height - relativeToHeight - gap);
					}
					object.y = newRelativeToY + relativeToHeight + gap;
				}
			}
			else if(position == RelativePosition.LEFT)
			{
				if(gap == Number.POSITIVE_INFINITY)
				{
					object.x = this._paddingLeft;
					newRelativeToX = this.actualWidth - this._paddingRight - relativeToWidth;
				}
				else
				{
					if(this._horizontalAlign == HorizontalAlign.LEFT)
					{
						newRelativeToX += gap + object.width;
					}
					else if(this._horizontalAlign == HorizontalAlign.CENTER)
					{
						newRelativeToX += Math.round((gap + object.width) / 2);
					}
					if(relativeTo2)
					{
						newRelativeToX = Math.max(newRelativeToX, this._paddingLeft + object.width + gap);
					}
					object.x = newRelativeToX - gap - object.width;
				}
			}

			var offsetX:Number = newRelativeToX - relativeToX;
			var offsetY:Number = newRelativeToY - relativeToY;
			if(!relativeTo2 || otherGap != Number.POSITIVE_INFINITY || !(
				(position == RelativePosition.TOP && otherPosition == RelativePosition.TOP) ||
				(position == RelativePosition.RIGHT && otherPosition == RelativePosition.RIGHT) ||
				(position == RelativePosition.BOTTOM && otherPosition == RelativePosition.BOTTOM) ||
				(position == RelativePosition.LEFT && otherPosition == RelativePosition.LEFT)
			))
			{
				relativeTo.x += offsetX;
				relativeTo.y += offsetY;
			}
			if(relativeTo2)
			{
				if(otherGap != Number.POSITIVE_INFINITY || !(
					(position == RelativePosition.LEFT && otherPosition == RelativePosition.RIGHT) ||
					(position == RelativePosition.RIGHT && otherPosition == RelativePosition.LEFT) ||
					(position == RelativePosition.TOP && otherPosition == RelativePosition.BOTTOM) ||
					(position == RelativePosition.BOTTOM && otherPosition == RelativePosition.TOP)
				))
				{
					relativeTo2.x += offsetX;
					relativeTo2.y += offsetY;
				}
				if(gap == Number.POSITIVE_INFINITY && otherGap == Number.POSITIVE_INFINITY)
				{
					if(position == RelativePosition.RIGHT && otherPosition == RelativePosition.LEFT)
					{
						relativeTo.x = relativeTo2.x + Math.round((object.x - relativeTo2.x + relativeTo2.width - relativeTo.width) / 2);
					}
					else if(position == RelativePosition.LEFT && otherPosition == RelativePosition.RIGHT)
					{
						relativeTo.x = object.x + Math.round((relativeTo2.x - object.x + object.width - relativeTo.width) / 2);
					}
					else if(position == RelativePosition.RIGHT && otherPosition == RelativePosition.RIGHT)
					{
						relativeTo2.x = relativeTo.x + Math.round((object.x - relativeTo.x + relativeTo.width - relativeTo2.width) / 2);
					}
					else if(position == RelativePosition.LEFT && otherPosition == RelativePosition.LEFT)
					{
						relativeTo2.x = object.x + Math.round((relativeTo.x - object.x + object.width - relativeTo2.width) / 2);
					}
					else if(position == RelativePosition.BOTTOM && otherPosition == RelativePosition.TOP)
					{
						relativeTo.y = relativeTo2.y + Math.round((object.y - relativeTo2.y + relativeTo2.height - relativeTo.height) / 2);
					}
					else if(position == RelativePosition.TOP && otherPosition == RelativePosition.BOTTOM)
					{
						relativeTo.y = object.y + Math.round((relativeTo2.y - object.y + object.height - relativeTo.height) / 2);
					}
					else if(position == RelativePosition.BOTTOM && otherPosition == RelativePosition.BOTTOM)
					{
						relativeTo2.y = relativeTo.y + Math.round((object.y - relativeTo.y + relativeTo.height - relativeTo2.height) / 2);
					}
					else if(position == RelativePosition.TOP && otherPosition == RelativePosition.TOP)
					{
						relativeTo2.y = object.y + Math.round((relativeTo.y - object.y + object.height - relativeTo2.height) / 2);
					}
				}
			}

			if(position == RelativePosition.LEFT || position == RelativePosition.RIGHT)
			{
				if(this._verticalAlign == VerticalAlign.TOP)
				{
					object.y = this._paddingTop;
				}
				else if(this._verticalAlign == VerticalAlign.BOTTOM)
				{
					object.y = this.actualHeight - this._paddingBottom - object.height;
				}
				else //middle
				{
					object.y = this._paddingTop + Math.round((this.actualHeight - this._paddingTop - this._paddingBottom - object.height) / 2);
				}
			}
			else if(position == RelativePosition.TOP || position == RelativePosition.BOTTOM)
			{
				if(this._horizontalAlign == HorizontalAlign.LEFT)
				{
					object.x = this._paddingLeft;
				}
				else if(this._horizontalAlign == HorizontalAlign.RIGHT)
				{
					object.x = this.actualWidth - this._paddingRight - object.width;
				}
				else //center
				{
					object.x = this._paddingLeft + Math.round((this.actualWidth - this._paddingLeft - this._paddingRight - object.width) / 2);
				}
			}
		}

		/**
		 * @private
		 */
		override protected function refreshSelectionEvents():void
		{
			var selectionEnabled:Boolean = this._isEnabled &&
				(this._isToggle || this.isSelectableWithoutToggle);
			if(this._itemHasSelectable)
			{
				selectionEnabled &&= this.itemToSelectable(this._data);
			}
			if(this.accessoryTouchPointID >= 0)
			{
				selectionEnabled &&= this._isSelectableOnAccessoryTouch;
			}
			this.tapToSelect.isEnabled = selectionEnabled;
			this.tapToSelect.tapToDeselect = this._isToggle;
			this.keyToSelect.isEnabled = false;
		}

		/**
		 * @private
		 */
		protected function owner_scrollStartHandler(event:Event):void
		{
			if(this._delayTextureCreationOnScroll)
			{
				if(this.accessoryLoader)
				{
					this.accessoryLoader.delayTextureCreation = true;
				}
				if(this.iconLoader)
				{
					this.iconLoader.delayTextureCreation = true;
				}
			}

			if(this.touchPointID < 0 && this.accessoryTouchPointID < 0)
			{
				return;
			}
			this.resetTouchState();
			if(this._stateDelayTimer && this._stateDelayTimer.running)
			{
				this._stateDelayTimer.stop();
			}
			this._delayedCurrentState = null;

			if(this.accessoryTouchPointID >= 0)
			{
				this._owner.stopScrolling();
			}
		}

		/**
		 * @private
		 */
		protected function owner_scrollCompleteHandler(event:Event):void
		{
			if(this._delayTextureCreationOnScroll)
			{
				if(this.accessoryLoader)
				{
					this.accessoryLoader.delayTextureCreation = false;
				}
				if(this.iconLoader)
				{
					this.iconLoader.delayTextureCreation = false;
				}
			}
		}

		/**
		 * @private
		 */
		protected function itemRenderer_removedFromStageHandler(event:Event):void
		{
			this.accessoryTouchPointID = -1;
		}

		/**
		 * @private
		 */
		protected function stateDelayTimer_timerCompleteHandler(event:TimerEvent):void
		{
			super.changeState(this._delayedCurrentState);
			this._delayedCurrentState = null;
		}

		/**
		 * @private
		 */
		override protected function basicButton_touchHandler(event:TouchEvent):void
		{
			if(this.currentAccessory && !this._isSelectableOnAccessoryTouch && this.currentAccessory != this.accessoryLabel && this.currentAccessory != this.accessoryLoader && this.touchPointID < 0)
			{
				//ignore all touches on accessories that are not labels or
				//loaders. return to up state.
				var touch:Touch = event.getTouch(this.currentAccessory);
				if(touch)
				{
					this.changeState(ButtonState.UP);
					return;
				}
			}
			super.basicButton_touchHandler(event);
		}

		/**
		 * @private
		 */
		protected function accessory_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				this.accessoryTouchPointID = -1;
				return;
			}
			if(!this._stopScrollingOnAccessoryTouch ||
				this.currentAccessory === this.accessoryLabel ||
				this.currentAccessory === this.accessoryLoader)
			{
				//do nothing
				return;
			}

			if(this.accessoryTouchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this.currentAccessory, TouchPhase.ENDED, this.accessoryTouchPointID);
				if(!touch)
				{
					return;
				}
				this.accessoryTouchPointID = -1;
				this.refreshSelectionEvents();
			}
			else //if we get here, we don't have a saved touch ID yet
			{
				touch = event.getTouch(this.currentAccessory, TouchPhase.BEGAN);
				if(!touch)
				{
					return;
				}
				this.accessoryTouchPointID = touch.id;
				this.refreshSelectionEvents();
			}
		}

		/**
		 * @private
		 */
		protected function accessory_resizeHandler(event:Event):void
		{
			if(this._ignoreAccessoryResizes)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		protected function loader_completeOrErrorHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}
	}
}