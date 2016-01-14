/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.renderers
{
	import feathers.controls.GroupedList;
	import feathers.events.FeathersEventType;
	import feathers.skins.IStyleProvider;

	/**
	 * The default item renderer for a GroupedList control. Supports up to three
	 * optional sub-views, including a label to display text, an icon to display
	 * an image, and an "accessory" to display a UI control or another display
	 * object (with shortcuts for including a second image or a second label).
	 * 
	 * @see feathers.controls.GroupedList
	 */
	public class DefaultGroupedListItemRenderer extends BaseDefaultItemRenderer implements IGroupedListItemRenderer
	{
		/**
		 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#ALTERNATE_STYLE_NAME_DRILL_DOWN
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const ALTERNATE_STYLE_NAME_DRILL_DOWN:String = "feathers-drill-down-item-renderer";

		/**
		 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#ALTERNATE_STYLE_NAME_CHECK
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const ALTERNATE_STYLE_NAME_CHECK:String = "feathers-check-item-renderer";

		/**
		 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#DEFAULT_CHILD_STYLE_NAME_LABEL
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_LABEL:String = "feathers-item-renderer-label";

		/**
		 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#DEFAULT_CHILD_STYLE_NAME_ICON_LABEL
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_ICON_LABEL:String = "feathers-item-renderer-icon-label";

		/**
		 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL
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
		 * @copy feathers.controls.Button#ICON_POSITION_TOP
		 *
		 * @see feathers.controls.Button#iconPosition
		 */
		public static const ICON_POSITION_TOP:String = "top";

		/**
		 * @copy feathers.controls.Button#ICON_POSITION_RIGHT
		 *
		 * @see feathers.controls.Button#iconPosition
		 */
		public static const ICON_POSITION_RIGHT:String = "right";

		/**
		 * @copy feathers.controls.Button#ICON_POSITION_BOTTOM
		 *
		 * @see feathers.controls.Button#iconPosition
		 */
		public static const ICON_POSITION_BOTTOM:String = "bottom";

		/**
		 * @copy feathers.controls.Button#ICON_POSITION_LEFT
		 *
		 * @see feathers.controls.Button#iconPosition
		 */
		public static const ICON_POSITION_LEFT:String = "left";

		/**
		 * @copy feathers.controls.Button#ICON_POSITION_MANUAL
		 *
		 * @see feathers.controls.Button#iconPosition
		 * @see feathers.controls.Button#iconOffsetX
		 * @see feathers.controls.Button#iconOffsetY
		 */
		public static const ICON_POSITION_MANUAL:String = "manual";

		/**
		 * @copy feathers.controls.Button#ICON_POSITION_LEFT_BASELINE
		 *
		 * @see feathers.controls.Button#iconPosition
		 */
		public static const ICON_POSITION_LEFT_BASELINE:String = "leftBaseline";

		/**
		 * @copy feathers.controls.Button#ICON_POSITION_RIGHT_BASELINE
		 *
		 * @see feathers.controls.Button#iconPosition
		 */
		public static const ICON_POSITION_RIGHT_BASELINE:String = "rightBaseline";

		/**
		 * @copy feathers.controls.Button#HORIZONTAL_ALIGN_LEFT
		 *
		 * @see feathers.controls.Button#horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_LEFT:String = "left";

		/**
		 * @copy feathers.controls.Button#HORIZONTAL_ALIGN_CENTER
		 *
		 * @see feathers.controls.Button#horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_CENTER:String = "center";

		/**
		 * @copy feathers.controls.Button#HORIZONTAL_ALIGN_RIGHT
		 *
		 * @see feathers.controls.Button#horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_RIGHT:String = "right";

		/**
		 * @copy feathers.controls.Button#VERTICAL_ALIGN_TOP
		 *
		 * @see feathers.controls.Button#verticalAlign
		 */
		public static const VERTICAL_ALIGN_TOP:String = "top";

		/**
		 * @copy feathers.controls.Button#VERTICAL_ALIGN_MIDDLE
		 *
		 * @see feathers.controls.Button#verticalAlign
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";

		/**
		 * @copy feathers.controls.Button#VERTICAL_ALIGN_BOTTOM
		 *
		 * @see feathers.controls.Button#verticalAlign
		 */
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";

		/**
		 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#ACCESSORY_POSITION_TOP
		 *
		 * @see feathers.controls.renderers.BaseDefaultItemRenderer#accessoryPosition
		 */
		public static const ACCESSORY_POSITION_TOP:String = "top";

		/**
		 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#ACCESSORY_POSITION_RIGHT
		 *
		 * @see feathers.controls.renderers.BaseDefaultItemRenderer#accessoryPosition
		 */
		public static const ACCESSORY_POSITION_RIGHT:String = "right";

		/**
		 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#ACCESSORY_POSITION_BOTTOM
		 *
		 * @see feathers.controls.renderers.BaseDefaultItemRenderer#accessoryPosition
		 */
		public static const ACCESSORY_POSITION_BOTTOM:String = "bottom";

		/**
		 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#ACCESSORY_POSITION_LEFT
		 *
		 * @see feathers.controls.renderers.BaseDefaultItemRenderer#accessoryPosition
		 */
		public static const ACCESSORY_POSITION_LEFT:String = "left";

		/**
		 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#ACCESSORY_POSITION_MANUAL
		 *
		 * @see feathers.controls.renderers.BaseDefaultItemRenderer#accessoryPosition
		 * @see feathers.controls.renderers.BaseDefaultItemRenderer#accessoryOffsetX
		 * @see feathers.controls.renderers.BaseDefaultItemRenderer#accessoryOffsetY
		 */
		public static const ACCESSORY_POSITION_MANUAL:String = "manual";

		/**
		 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#LAYOUT_ORDER_LABEL_ACCESSORY_ICON
		 *
		 * @see feathers.controls.renderers.BaseDefaultItemRenderer#layoutOrder
		 */
		public static const LAYOUT_ORDER_LABEL_ACCESSORY_ICON:String = "labelAccessoryIcon";

		/**
		 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#LAYOUT_ORDER_LABEL_ICON_ACCESSORY
		 *
		 * @see feathers.controls.renderers.BaseDefaultItemRenderer#layoutOrder
		 */
		public static const LAYOUT_ORDER_LABEL_ICON_ACCESSORY:String = "labelIconAccessory";

		/**
		 * The default <code>IStyleProvider</code> for all <code>DefaultGroupedListItemRenderer</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function DefaultGroupedListItemRenderer()
		{
			super();
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return DefaultGroupedListItemRenderer.globalStyleProvider;
		}
		
		/**
		 * @private
		 */
		protected var _groupIndex:int = -1;
		
		/**
		 * @inheritDoc
		 */
		public function get groupIndex():int
		{
			return this._groupIndex;
		}
		
		/**
		 * @private
		 */
		public function set groupIndex(value:int):void
		{
			this._groupIndex = value;
		}

		/**
		 * @private
		 */
		protected var _itemIndex:int = -1;

		/**
		 * @inheritDoc
		 */
		public function get itemIndex():int
		{
			return this._itemIndex;
		}

		/**
		 * @private
		 */
		public function set itemIndex(value:int):void
		{
			this._itemIndex = value;
		}

		/**
		 * @private
		 */
		protected var _layoutIndex:int = -1;

		/**
		 * @inheritDoc
		 */
		public function get layoutIndex():int
		{
			return this._layoutIndex;
		}

		/**
		 * @private
		 */
		public function set layoutIndex(value:int):void
		{
			this._layoutIndex = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get owner():GroupedList
		{
			return GroupedList(this._owner);
		}
		
		/**
		 * @private
		 */
		public function set owner(value:GroupedList):void
		{
			if(this._owner == value)
			{
				return;
			}
			if(this._owner)
			{
				this._owner.removeEventListener(FeathersEventType.SCROLL_START, owner_scrollStartHandler);
				this._owner.removeEventListener(FeathersEventType.SCROLL_COMPLETE, owner_scrollCompleteHandler);
			}
			this._owner = value;
			if(this._owner)
			{
				var list:GroupedList = GroupedList(this._owner);
				this.isSelectableWithoutToggle = list.isSelectable;
				this._owner.addEventListener(FeathersEventType.SCROLL_START, owner_scrollStartHandler);
				this._owner.addEventListener(FeathersEventType.SCROLL_COMPLETE, owner_scrollCompleteHandler);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this.owner = null;
			super.dispose();
		}
	}
}