/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.renderers
{
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Scroller;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.core.PropertyProxy;
	import feathers.events.FeathersEventType;

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
	public class BaseDefaultItemRenderer extends Button
	{
		/**
		 * The default value added to the <code>nameList</code> of the accessory
		 * label.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		public static const DEFAULT_CHILD_NAME_ACCESSORY_LABEL:String = "feathers-item-renderer-accessory-label";

		/**
		 * The accessory will be positioned above its origin.
		 *
		 * @see #accessoryPosition
		 */
		public static const ACCESSORY_POSITION_TOP:String = "top";

		/**
		 * The accessory will be positioned to the right of its origin.
		 *
		 * @see #accessoryPosition
		 */
		public static const ACCESSORY_POSITION_RIGHT:String = "right";

		/**
		 * The accessory will be positioned below its origin.
		 *
		 * @see #accessoryPosition
		 */
		public static const ACCESSORY_POSITION_BOTTOM:String = "bottom";

		/**
		 * The accessory will be positioned to the left of its origin.
		 *
		 * @see #accessoryPosition
		 */
		public static const ACCESSORY_POSITION_LEFT:String = "left";

		/**
		 * The accessory will be positioned manually with no relation to another
		 * child. Use <code>accessoryOffsetX</code> and <code>accessoryOffsetY</code>
		 * to set the accessory position.
		 *
		 * <p>The <code>accessoryPositionOrigin</code> property will be ignored
		 * if <code>accessoryPosition</code> is set to <code>ACCESSORY_POSITION_MANUAL</code>.</p>
		 *
		 * @see #accessoryPosition
		 * @see #accessoryOffsetX
		 * @see #accessoryOffsetY
		 */
		public static const ACCESSORY_POSITION_MANUAL:String = "manual";

		/**
		 * The layout order will be the label first, then the accessory relative
		 * to the label, then the icon relative to both. Best used when the
		 * accessory should be between the label and the icon or when the icon
		 * position shouldn't be affected by the accessory.
		 *
		 * @see #layoutOrder
		 */
		public static const LAYOUT_ORDER_LABEL_ACCESSORY_ICON:String = "labelAccessoryIcon";

		/**
		 * The layout order will be the label first, then the icon relative to
		 * label, then the accessory relative to both.
		 *
		 * @see #layoutOrder
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
			this.isFocusEnabled = false;
			this.isQuickHitAreaEnabled = false;
			this.addEventListener(Event.TRIGGERED, itemRenderer_triggeredHandler);
		}

		/**
		 * The value added to the <code>nameList</code> of the accessory label.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		protected var accessoryLabelName:String = DEFAULT_CHILD_NAME_ACCESSORY_LABEL;

		/**
		 * @private
		 */
		protected var iconImage:ImageLoader;

		/**
		 * @private
		 */
		protected var accessoryImage:ImageLoader;

		/**
		 * @private
		 */
		protected var accessoryLabel:ITextRenderer;

		/**
		 * @private
		 */
		protected var accessory:DisplayObject;

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
			if(this._data == value)
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
		protected var _accessoryPosition:String = ACCESSORY_POSITION_RIGHT;

		[Inspectable(type="String",enumeration="top,right,bottom,left,manual")]
		/**
		 * The location of the accessory, relative to one of the other children.
		 * Use <code>ACCESSORY_POSITION_MANUAL</code> to position the accessory
		 * from the top-left corner.
		 *
		 * <p>In the following example, the accessory is placed on the bottom:</p>
		 *
		 * <listing version="3.0">
		 * renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_BOTTOM;</listing>
		 *
		 * @default BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT
		 *
		 * @see #ACCESSORY_POSITION_TOP
		 * @see #ACCESSORY_POSITION_RIGHT
		 * @see #ACCESSORY_POSITION_BOTTOM
		 * @see #ACCESSORY_POSITION_LEFT
		 * @see #ACCESSORY_POSITION_MANUAL
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
		protected var _layoutOrder:String = LAYOUT_ORDER_LABEL_ICON_ACCESSORY;

		[Inspectable(type="String",enumeration="labelIconAccessory,labelAccessoryIcon")]
		/**
		 * The accessory's position will be based on which other child (the
		 * label or the icon) the accessory should be relative to.
		 *
		 * <p>The <code>accessoryPositionOrigin</code> property will be ignored
		 * if <code>accessoryPosition</code> is set to <code>ACCESSORY_POSITION_MANUAL</code>.</p>
		 *
		 * <p>In the following example, the layout order is changed:</p>
		 *
		 * <listing version="3.0">
		 * renderer.layoutOrder = BaseDefaultItemRenderer.LAYOUT_ORDER_LABEL_ACCESSORY_ICON;</listing>
		 *
		 * @default BaseDefaultItemRenderer.LAYOUT_ORDER_LABEL_ICON_ACCESSORY
		 *
		 * @see LAYOUT_ORDER_LABEL_ICON_ACCESSORY
		 * @see LAYOUT_ORDER_LABEL_ACCESSORY_ICON
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
		override protected function set currentState(value:String):void
		{
			if(!this._isToggle && !this.isSelectableWithoutToggle)
			{
				value = STATE_UP;
			}
			if(this._useStateDelayTimer)
			{
				if(this._stateDelayTimer && this._stateDelayTimer.running)
				{
					this._delayedCurrentState = value;
					return;
				}

				if(value == Button.STATE_DOWN)
				{
					if(this._currentState == value)
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
			super.currentState = value;
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
		 * <p>All of the icon fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>iconSourceFunction</code></li>
		 *     <li><code>iconSourceField</code></li>
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
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:Object ):DisplayObject</pre>
		 *
		 * <p>All of the icon fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>iconSourceFunction</code></li>
		 *     <li><code>iconSourceField</code></li>
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
		protected var _accessoryField:String = "accessory";

		/**
		 * The field in the item that contains a display object to be positioned
		 * in the accessory position of the renderer. If you wish to display an
		 * <code>Image</code> in the accessory position, it's better for
		 * performance to use <code>accessorySourceField</code> instead.
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
		 *
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
		 * renderer-managed <code>Label</code> in the accessory position of the
		 * renderer. The renderer will automatically reuse an internal
		 * <code>Label</code> and swap the text when the data changes. This
		 * <code>Label</code> may be skinned by changing the
		 * <code>accessoryLabelFactory</code>.
		 *
		 * <p>Using an accessory label will result in better performance than
		 * passing in a <code>Label</code> through a <code>accessoryField</code>
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
		 *
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
		 * renderer-managed <code>Label</code> in the accessory position of the
		 * renderer. The renderer will automatically reuse an internal
		 * <code>Label</code> and swap the text when the data changes. This
		 * <code>Label</code> may be skinned by changing the
		 * <code>accessoryLabelFactory</code>.
		 *
		 * <p>Using an accessory label will result in better performance than
		 * passing in a <code>Label</code> through a <code>accessoryField</code>
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
		 *
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
		protected var _iconLoaderFactory:Function = defaultLoaderFactory;

		/**
		 * A function that generates an <code>ImageLoader</code> that uses the result
		 * of <code>iconSourceField</code> or <code>iconSourceFunction</code>.
		 * Useful for transforming the <code>ImageLoader</code> in some way. For
		 * example, you might want to scale the texture for current DPI or apply
		 * pixel snapping.
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
		 *    loader.snapToPixels = true;
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
			this.replaceIcon(null);
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _accessoryLoaderFactory:Function = defaultLoaderFactory;

		/**
		 * A function that generates an <code>ImageLoader</code> that uses the result
		 * of <code>accessorySourceField</code> or <code>accessorySourceFunction</code>.
		 * Useful for transforming the <code>ImageLoader</code> in some way. For
		 * example, you might want to scale the texture for current DPI or apply
		 * pixel snapping.
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
		 *    loader.snapToPixels = true;
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
			this.replaceAccessory(null);
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _accessoryLabelProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to a label accessory. The
		 * title is an <code>ITextRenderer</code> instance. The available
		 * properties depend on which <code>ITextRenderer</code> implementation
		 * is used.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
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
				this._accessoryLabelProperties = new PropertyProxy(accessoryLabelProperties_onChange);
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
				const newValue:PropertyProxy = new PropertyProxy();
				for(var propertyName:String in value)
				{
					newValue[propertyName] = value[propertyName];
				}
				value = newValue;
			}
			if(this._accessoryLabelProperties)
			{
				this._accessoryLabelProperties.removeOnChangeCallback(accessoryLabelProperties_onChange);
			}
			this._accessoryLabelProperties = PropertyProxy(value);
			if(this._accessoryLabelProperties)
			{
				this._accessoryLabelProperties.addOnChangeCallback(accessoryLabelProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
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
			this.replaceIcon(null);
			this.replaceAccessory(null);
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
			if(this._labelFunction != null)
			{
				var labelResult:Object = this._labelFunction(item);
				if(labelResult is String)
				{
					return labelResult as String;
				}
				return labelResult.toString();
			}
			else if(this._labelField != null && item && item.hasOwnProperty(this._labelField))
			{
				labelResult = item[this._labelField];
				if(labelResult is String)
				{
					return labelResult as String;
				}
				return labelResult.toString();
			}
			else if(item is String)
			{
				return item as String;
			}
			else if(item)
			{
				return item.toString();
			}
			return "";
		}

		/**
		 * Uses the icon fields and functions to generate an icon for a specific
		 * item.
		 *
		 * <p>All of the icon fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>iconSourceFunction</code></li>
		 *     <li><code>iconSourceField</code></li>
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
				return this.iconImage;
			}
			else if(this._iconSourceField != null && item && item.hasOwnProperty(this._iconSourceField))
			{
				source = item[this._iconSourceField];
				this.refreshIconSource(source);
				return this.iconImage;
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
				return this.accessoryImage;
			}
			else if(this._accessorySourceField != null && item && item.hasOwnProperty(this._accessorySourceField))
			{
				source = item[this._accessorySourceField];
				this.refreshAccessorySource(source);
				return this.accessoryImage;
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
		 * @private
		 */
		override protected function draw():void
		{
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
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
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			const oldIgnoreAccessoryResizes:Boolean = this._ignoreAccessoryResizes;
			this._ignoreAccessoryResizes = true;
			this.refreshMaxLabelWidth(true);
			this.labelTextRenderer.measureText(HELPER_POINT);
			if(this.accessory is IFeathersControl)
			{
				IFeathersControl(this.accessory).validate();
			}
			if(this.currentIcon is IFeathersControl)
			{
				IFeathersControl(this.currentIcon).validate();
			}
			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				if(this._label)
				{
					newWidth = HELPER_POINT.x;
				}
				var adjustedGap:Number = this._gap == Number.POSITIVE_INFINITY ? Math.min(this._paddingLeft, this._paddingRight) : this._gap;
				if(this._layoutOrder == LAYOUT_ORDER_LABEL_ACCESSORY_ICON)
				{
					newWidth = this.addAccessoryWidth(newWidth, adjustedGap);
					newWidth = this.addIconWidth(newWidth, adjustedGap);
				}
				else
				{
					newWidth = this.addIconWidth(newWidth, adjustedGap);
					newWidth = this.addAccessoryWidth(newWidth, adjustedGap);
				}
				newWidth += this._paddingLeft + this._paddingRight;
				if(isNaN(newWidth))
				{
					newWidth = this._originalSkinWidth;
				}
				else if(!isNaN(this._originalSkinWidth))
				{
					newWidth = Math.max(newWidth, this._originalSkinWidth);
				}
				if(isNaN(newWidth))
				{
					newWidth = 0;
				}
			}

			var newHeight:Number = this.explicitHeight;
			if(needsHeight)
			{
				if(this._label)
				{
					newHeight = HELPER_POINT.y;
				}
				adjustedGap = this._gap == Number.POSITIVE_INFINITY ? Math.min(this._paddingTop, this._paddingBottom) : this._gap;
				if(this._layoutOrder == LAYOUT_ORDER_LABEL_ACCESSORY_ICON)
				{
					newHeight = this.addAccessoryHeight(newHeight, adjustedGap);
					newHeight = this.addIconHeight(newHeight, adjustedGap);
				}
				else
				{
					newHeight = this.addIconHeight(newHeight, adjustedGap);
					newHeight = this.addAccessoryHeight(newHeight, adjustedGap);
				}
				newHeight += this._paddingTop + this._paddingBottom;
				if(isNaN(newHeight))
				{
					newHeight = this._originalSkinHeight;
				}
				else if(!isNaN(this._originalSkinHeight))
				{
					newHeight = Math.max(newHeight, this._originalSkinHeight);
				}
				if(isNaN(newHeight))
				{
					newHeight = 0;
				}
			}
			this._ignoreAccessoryResizes = oldIgnoreAccessoryResizes;

			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		protected function addIconWidth(width:Number, gap:Number):Number
		{
			if(!this.currentIcon || isNaN(this.currentIcon.width))
			{
				return width;
			}

			var hasPreviousItem:Boolean = !isNaN(width);
			if(!hasPreviousItem)
			{
				width = 0;
			}

			if(this._iconPosition == ICON_POSITION_LEFT || this._iconPosition == ICON_POSITION_LEFT_BASELINE || this._iconPosition == ICON_POSITION_RIGHT || this._iconPosition == ICON_POSITION_RIGHT_BASELINE)
			{
				if(hasPreviousItem)
				{
					width += gap;
				}
				width += this.currentIcon.width;
			}
			else
			{
				width = Math.max(width, this.currentIcon.width);
			}
			return width;
		}

		/**
		 * @private
		 */
		protected function addAccessoryWidth(width:Number, gap:Number):Number
		{
			if(!this.accessory || isNaN(this.accessory.width))
			{
				return width;
			}

			var hasPreviousItem:Boolean = !isNaN(width);
			if(!hasPreviousItem)
			{
				width = 0;
			}

			if(this._accessoryPosition == ACCESSORY_POSITION_LEFT || this._accessoryPosition == ACCESSORY_POSITION_RIGHT)
			{
				if(hasPreviousItem)
				{
					var adjustedAccessoryGap:Number = isNaN(this._accessoryGap) ? gap : this._accessoryGap;
					if(adjustedAccessoryGap == Number.POSITIVE_INFINITY)
					{
						adjustedAccessoryGap = Math.min(this._paddingLeft, this._paddingRight, this._gap);
					}
					width += adjustedAccessoryGap;
				}
				width += this.accessory.width;
			}
			else
			{
				width = Math.max(width, this.accessory.width);
			}
			return width;
		}


		/**
		 * @private
		 */
		protected function addIconHeight(height:Number, gap:Number):Number
		{
			if(!this.currentIcon || isNaN(this.currentIcon.height))
			{
				return height;
			}

			var hasPreviousItem:Boolean = !isNaN(height);
			if(!hasPreviousItem)
			{
				height = 0;
			}

			if(this._iconPosition == ICON_POSITION_TOP || this._iconPosition == ICON_POSITION_BOTTOM)
			{
				if(hasPreviousItem)
				{
					height += gap;
				}
				height += this.currentIcon.height;
			}
			else
			{
				height = Math.max(height, this.currentIcon.height);
			}
			return height;
		}

		/**
		 * @private
		 */
		protected function addAccessoryHeight(height:Number, gap:Number):Number
		{
			if(!this.accessory || isNaN(this.accessory.height))
			{
				return height;
			}

			var hasPreviousItem:Boolean = !isNaN(height);
			if(!hasPreviousItem)
			{
				height = 0;
			}

			if(this._accessoryPosition == ACCESSORY_POSITION_TOP || this._accessoryPosition == ACCESSORY_POSITION_BOTTOM)
			{
				if(hasPreviousItem)
				{
					var adjustedAccessoryGap:Number = isNaN(this._accessoryGap) ? gap : this._accessoryGap;
					if(adjustedAccessoryGap == Number.POSITIVE_INFINITY)
					{
						adjustedAccessoryGap = Math.min(this._paddingTop, this._paddingBottom, this._gap);
					}
					height += adjustedAccessoryGap;
				}
				height += this.accessory.height;
			}
			else
			{
				height = Math.max(height, this.accessory.height);
			}
			return height;
		}

		/**
		 * @private
		 */
		protected function commitData():void
		{
			if(this._data && this._owner)
			{
				if(this._itemHasLabel)
				{
					this._label = this.itemToLabel(this._data);
					//we don't need to invalidate because the label setter
					//uses the same data invalidation flag that triggered this
					//call to commitData(), so we're already properly invalid.
				}
				if(this._itemHasIcon)
				{
					const newIcon:DisplayObject = this.itemToIcon(this._data);
					this.replaceIcon(newIcon);
				}
				if(this._itemHasAccessory)
				{
					const newAccessory:DisplayObject = this.itemToAccessory(this._data);
					this.replaceAccessory(newAccessory);
				}
				else
				{
					this.replaceAccessory(null);
				}
			}
			else
			{
				if(this._itemHasLabel)
				{
					this._label = "";
				}
				if(this._itemHasIcon)
				{
					this.replaceIcon(null);
				}
				if(this._itemHasAccessory)
				{
					this.replaceAccessory(null);
				}
			}
		}

		/**
		 * @private
		 */
		protected function replaceIcon(newIcon:DisplayObject):void
		{
			if(this.iconImage && this.iconImage != newIcon)
			{
				this.iconImage.removeEventListener(Event.COMPLETE, loader_completeOrErrorHandler);
				this.iconImage.removeEventListener(FeathersEventType.ERROR, loader_completeOrErrorHandler);
				this.iconImage.dispose();
				this.iconImage = null;
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
			if(this._iconSelector.defaultValue != newIcon)
			{
				this._iconSelector.defaultValue = newIcon;
				//we don't need to do a full invalidation. the superclass will
				//correctly see this flag when we call super.draw().
				this.setInvalidationFlag(INVALIDATION_FLAG_STYLES);
			}

			if(this.iconImage)
			{
				this.iconImage.delayTextureCreation = this._delayTextureCreationOnScroll && this._owner.isScrolling;
			}
		}

		/**
		 * @private
		 */
		protected function replaceAccessory(newAccessory:DisplayObject):void
		{
			if(this.accessory == newAccessory)
			{
				return;
			}

			if(this.accessory)
			{
				this.accessory.removeEventListener(FeathersEventType.RESIZE, accessory_resizeHandler);
				this.accessory.removeEventListener(TouchEvent.TOUCH, accessory_touchHandler);

				if(this.accessory.parent == this)
				{
					//the accessory may have come from outside of this class. it's
					//up to that code to dispose of the accessory. in fact, if we
					//disposed of it here, we will probably screw something up, so
					//let's just remove it.
					this.accessory.removeFromParent(false);
				}
			}

			if(this.accessoryLabel && this.accessoryLabel != newAccessory)
			{
				//we can dispose this one, though, since we created it
				this.accessoryLabel.dispose();
				this.accessoryLabel = null;
			}

			if(this.accessoryImage && this.accessoryImage != newAccessory)
			{
				this.accessoryImage.removeEventListener(Event.COMPLETE, loader_completeOrErrorHandler);
				this.accessoryImage.removeEventListener(FeathersEventType.ERROR, loader_completeOrErrorHandler);

				//same ability to dispose here
				this.accessoryImage.dispose();
				this.accessoryImage = null;
			}

			this.accessory = newAccessory;

			if(this.accessory)
			{
				if(this.accessory is IFeathersControl)
				{
					if(!(this.accessory is BitmapFontTextRenderer))
					{
						this.accessory.addEventListener(TouchEvent.TOUCH, accessory_touchHandler);
					}
					this.accessory.addEventListener(FeathersEventType.RESIZE, accessory_resizeHandler);
				}
				this.addChild(this.accessory);
			}
			
			if(this.accessoryImage)
			{
				this.accessoryImage.delayTextureCreation = this._delayTextureCreationOnScroll && this._owner.isScrolling;
			}
		}

		/**
		 * @private
		 */
		protected function refreshAccessory():void
		{
			if(this.accessory is IFeathersControl)
			{
				IFeathersControl(this.accessory).isEnabled = this._isEnabled;
			}
			if(this.accessoryLabel)
			{
				const displayAccessoryLabel:DisplayObject = DisplayObject(this.accessoryLabel);
				for(var propertyName:String in this._accessoryLabelProperties)
				{
					if(displayAccessoryLabel.hasOwnProperty(propertyName))
					{
						var propertyValue:Object = this._accessoryLabelProperties[propertyName];
						displayAccessoryLabel[propertyName] = propertyValue;
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function refreshIconSource(source:Object):void
		{
			if(!this.iconImage)
			{
				this.iconImage = this._iconLoaderFactory();
				this.iconImage.addEventListener(Event.COMPLETE, loader_completeOrErrorHandler);
				this.iconImage.addEventListener(FeathersEventType.ERROR, loader_completeOrErrorHandler);
			}
			this.iconImage.source = source;
		}

		/**
		 * @private
		 */
		protected function refreshAccessorySource(source:Object):void
		{
			if(!this.accessoryImage)
			{
				this.accessoryImage = this._accessoryLoaderFactory();
				this.accessoryImage.addEventListener(Event.COMPLETE, loader_completeOrErrorHandler);
				this.accessoryImage.addEventListener(FeathersEventType.ERROR, loader_completeOrErrorHandler);
			}
			this.accessoryImage.source = source;
		}

		/**
		 * @private
		 */
		protected function refreshAccessoryLabel(label:String):void
		{
			if(!this.accessoryLabel)
			{
				const factory:Function = this._accessoryLabelFactory != null ? this._accessoryLabelFactory : FeathersControl.defaultTextRendererFactory;
				this.accessoryLabel = ITextRenderer(factory());
				this.accessoryLabel.nameList.add(this.accessoryLabelName);
			}
			this.accessoryLabel.text = label;
		}

		/**
		 * @private
		 */
		override protected function layoutContent():void
		{
			const oldIgnoreAccessoryResizes:Boolean = this._ignoreAccessoryResizes;
			this._ignoreAccessoryResizes = true;
			this.refreshMaxLabelWidth(false);
			if(this._label)
			{
				this.labelTextRenderer.validate();
				const labelRenderer:DisplayObject = DisplayObject(this.labelTextRenderer);
			}
			if(this.accessory is IFeathersControl)
			{
				IFeathersControl(this.accessory).validate();
			}
			if(this.currentIcon is IFeathersControl)
			{
				IFeathersControl(this.currentIcon).validate();
			}

			const iconIsInLayout:Boolean = this.currentIcon && this._iconPosition != ICON_POSITION_MANUAL;
			const accessoryIsInLayout:Boolean = this.accessory && this._accessoryPosition != ACCESSORY_POSITION_MANUAL;
			const accessoryGap:Number = isNaN(this._accessoryGap) ? this._gap : this._accessoryGap;
			if(this._label && iconIsInLayout && accessoryIsInLayout)
			{
				this.positionSingleChild(labelRenderer);
				if(this._layoutOrder == LAYOUT_ORDER_LABEL_ACCESSORY_ICON)
				{
					this.positionRelativeToOthers(this.accessory, labelRenderer, null, this._accessoryPosition, accessoryGap, null, 0);
					var iconPosition:String = this._iconPosition;
					if(iconPosition == ICON_POSITION_LEFT_BASELINE)
					{
						iconPosition = ICON_POSITION_LEFT;
					}
					else if(iconPosition == ICON_POSITION_RIGHT_BASELINE)
					{
						iconPosition = ICON_POSITION_RIGHT;
					}
					this.positionRelativeToOthers(this.currentIcon, labelRenderer, this.accessory, iconPosition, this._gap, this._accessoryPosition, accessoryGap);
				}
				else
				{
					this.positionLabelAndIcon();
					this.positionRelativeToOthers(this.accessory, labelRenderer, this.currentIcon, this._accessoryPosition, accessoryGap, this._iconPosition, this._gap);
				}
			}
			else if(this._label)
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
					this.positionRelativeToOthers(this.accessory, labelRenderer, null, this._accessoryPosition, accessoryGap, null, 0);
				}
			}
			else if(iconIsInLayout)
			{
				this.positionSingleChild(this.currentIcon);
				if(accessoryIsInLayout)
				{
					this.positionRelativeToOthers(this.accessory, this.currentIcon, null, this._accessoryPosition, accessoryGap, null, 0);
				}
			}
			else if(accessoryIsInLayout)
			{
				this.positionSingleChild(this.accessory);
			}

			if(this.accessory)
			{
				if(!accessoryIsInLayout)
				{
					this.accessory.x = this._paddingLeft;
					this.accessory.y = this._paddingTop;
				}
				this.accessory.x += this._accessoryOffsetX;
				this.accessory.y += this._accessoryOffsetY;
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
			if(this._label)
			{
				this.labelTextRenderer.x += this._labelOffsetX;
				this.labelTextRenderer.y += this._labelOffsetY;
			}
			this._ignoreAccessoryResizes = oldIgnoreAccessoryResizes;
		}

		/**
		 * @private
		 */
		override protected function refreshMaxLabelWidth(forMeasurement:Boolean):void
		{
			if(!this._label)
			{
				return;
			}
			var calculatedWidth:Number = this.actualWidth;
			if(forMeasurement)
			{
				calculatedWidth = isNaN(this.explicitWidth) ? this._maxWidth : this.explicitWidth;
			}
			if(this.accessory is IFeathersControl)
			{
				IFeathersControl(this.accessory).validate();
			}
			const adjustedGap:Number = this._gap == Number.POSITIVE_INFINITY ? Math.min(this._paddingLeft, this._paddingRight) : this._gap;
			if(this.currentIcon && (this._iconPosition == ICON_POSITION_LEFT || this._iconPosition == ICON_POSITION_LEFT_BASELINE ||
				this._iconPosition == ICON_POSITION_RIGHT || this._iconPosition == ICON_POSITION_RIGHT_BASELINE))
			{
				calculatedWidth -= (adjustedGap + this.currentIcon.width);
			}

			if(this.accessory && (this._accessoryPosition == ACCESSORY_POSITION_LEFT || this._accessoryPosition == ACCESSORY_POSITION_RIGHT))
			{
				const accessoryGap:Number = (isNaN(this._accessoryGap) || this._accessoryGap == Number.POSITIVE_INFINITY) ? adjustedGap : this._accessoryGap;
				calculatedWidth -= (accessoryGap + this.accessory.width);
			}

			this.labelTextRenderer.maxWidth = calculatedWidth - this._paddingLeft - this._paddingRight;
		}

		/**
		 * @private
		 */
		protected function positionRelativeToOthers(object:DisplayObject, relativeTo:DisplayObject, relativeTo2:DisplayObject, position:String, gap:Number, otherPosition:String, otherGap:Number):void
		{
			const relativeToX:Number = relativeTo2 ? Math.min(relativeTo.x, relativeTo2.x) : relativeTo.x;
			const relativeToY:Number = relativeTo2 ? Math.min(relativeTo.y, relativeTo2.y) : relativeTo.y;
			const relativeToWidth:Number = relativeTo2 ? (Math.max(relativeTo.x + relativeTo.width, relativeTo2.x + relativeTo2.width) - relativeToX) : relativeTo.width;
			const relativeToHeight:Number = relativeTo2 ? (Math.max(relativeTo.y + relativeTo.height, relativeTo2.y + relativeTo2.height) - relativeToY) : relativeTo.height;
			var newRelativeToX:Number = relativeToX;
			var newRelativeToY:Number = relativeToY;
			if(position == ACCESSORY_POSITION_TOP)
			{
				if(gap == Number.POSITIVE_INFINITY)
				{
					object.y = this._paddingTop;
					newRelativeToY = this.actualHeight - this._paddingBottom - relativeToHeight;
				}
				else
				{
					if(this._verticalAlign == VERTICAL_ALIGN_TOP)
					{
						newRelativeToY += object.height + gap;
					}
					else if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
					{
						newRelativeToY += (object.height + gap) / 2;
					}
					if(relativeTo2)
					{
						newRelativeToY = Math.max(newRelativeToY, this._paddingTop + object.height + gap);
					}
					object.y = newRelativeToY - object.height - gap;
				}
			}
			else if(position == ACCESSORY_POSITION_RIGHT)
			{
				if(gap == Number.POSITIVE_INFINITY)
				{
					newRelativeToX = this._paddingLeft;
					object.x = this.actualWidth - this._paddingRight - object.width;
				}
				else
				{
					if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
					{
						newRelativeToX -= (object.width + gap);
					}
					else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
					{
						newRelativeToX -= (object.width + gap) / 2;
					}
					if(relativeTo2)
					{
						newRelativeToX = Math.min(newRelativeToX, this.actualWidth - this._paddingRight - object.width - relativeToWidth - gap);
					}
					object.x = newRelativeToX + relativeToWidth + gap;
				}
			}
			else if(position == ACCESSORY_POSITION_BOTTOM)
			{
				if(gap == Number.POSITIVE_INFINITY)
				{
					newRelativeToY = this._paddingTop;
					object.y = this.actualHeight - this._paddingBottom - object.height;
				}
				else
				{
					if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
					{
						newRelativeToY -= (object.height + gap);
					}
					else if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
					{
						newRelativeToY -= (object.height + gap) / 2;
					}
					if(relativeTo2)
					{
						newRelativeToY = Math.min(newRelativeToY, this.actualHeight - this._paddingBottom - object.height - relativeToHeight - gap);
					}
					object.y = newRelativeToY + relativeToHeight + gap;
				}
			}
			else if(position == ACCESSORY_POSITION_LEFT)
			{
				if(gap == Number.POSITIVE_INFINITY)
				{
					object.x = this._paddingLeft;
					newRelativeToX = this.actualWidth - this._paddingRight - relativeToWidth;
				}
				else
				{
					if(this._horizontalAlign == HORIZONTAL_ALIGN_LEFT)
					{
						newRelativeToX += gap + object.width;
					}
					else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
					{
						newRelativeToX += (gap + object.width) / 2;
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
				(position == ACCESSORY_POSITION_TOP && otherPosition == ACCESSORY_POSITION_TOP) ||
				(position == ACCESSORY_POSITION_RIGHT && otherPosition == ACCESSORY_POSITION_RIGHT) ||
				(position == ACCESSORY_POSITION_BOTTOM && otherPosition == ACCESSORY_POSITION_BOTTOM) ||
				(position == ACCESSORY_POSITION_LEFT && otherPosition == ACCESSORY_POSITION_LEFT)
			))
			{
				relativeTo.x += offsetX;
				relativeTo.y += offsetY;
			}
			if(relativeTo2)
			{
				if(otherGap != Number.POSITIVE_INFINITY || !(
					(position == ACCESSORY_POSITION_LEFT && otherPosition == ACCESSORY_POSITION_RIGHT) ||
					(position == ACCESSORY_POSITION_RIGHT && otherPosition == ACCESSORY_POSITION_LEFT) ||
					(position == ACCESSORY_POSITION_TOP && otherPosition == ACCESSORY_POSITION_BOTTOM) ||
					(position == ACCESSORY_POSITION_BOTTOM && otherPosition == ACCESSORY_POSITION_TOP)
				))
				{
					relativeTo2.x += offsetX;
					relativeTo2.y += offsetY;
				}
				if(gap == Number.POSITIVE_INFINITY && otherGap == Number.POSITIVE_INFINITY)
				{
					if(position == ACCESSORY_POSITION_RIGHT && otherPosition == ACCESSORY_POSITION_LEFT)
					{
						relativeTo.x = relativeTo2.x + (object.x - relativeTo2.x + relativeTo2.width - relativeTo.width) / 2;
					}
					else if(position == ACCESSORY_POSITION_LEFT && otherPosition == ACCESSORY_POSITION_RIGHT)
					{
						relativeTo.x = object.x + (relativeTo2.x - object.x + object.width - relativeTo.width) / 2;
					}
					else if(position == ACCESSORY_POSITION_RIGHT && otherPosition == ACCESSORY_POSITION_RIGHT)
					{
						relativeTo2.x = relativeTo.x + (object.x - relativeTo.x + relativeTo.width - relativeTo2.width) / 2;
					}
					else if(position == ACCESSORY_POSITION_LEFT && otherPosition == ACCESSORY_POSITION_LEFT)
					{
						relativeTo2.x = object.x + (relativeTo.x - object.x + object.width - relativeTo2.width) / 2;
					}
					else if(position == ACCESSORY_POSITION_BOTTOM && otherPosition == ACCESSORY_POSITION_TOP)
					{
						relativeTo.y = relativeTo2.y + (object.y - relativeTo2.y + relativeTo2.height - relativeTo.height) / 2;
					}
					else if(position == ACCESSORY_POSITION_TOP && otherPosition == ACCESSORY_POSITION_BOTTOM)
					{
						relativeTo.y = object.y + (relativeTo2.y - object.y + object.height - relativeTo.height) / 2;
					}
					else if(position == ACCESSORY_POSITION_BOTTOM && otherPosition == ACCESSORY_POSITION_BOTTOM)
					{
						relativeTo2.y = relativeTo.y + (object.y - relativeTo.y + relativeTo.height - relativeTo2.height) / 2;
					}
					else if(position == ACCESSORY_POSITION_TOP && otherPosition == ACCESSORY_POSITION_TOP)
					{
						relativeTo2.y = object.y + (relativeTo.y - object.y + object.height - relativeTo2.height) / 2;
					}
				}
			}

			if(position == ACCESSORY_POSITION_LEFT || position == ACCESSORY_POSITION_RIGHT)
			{
				if(this._verticalAlign == VERTICAL_ALIGN_TOP)
				{
					object.y = this._paddingTop;
				}
				else if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
				{
					object.y = this.actualHeight - this._paddingBottom - object.height;
				}
				else
				{
					object.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - object.height) / 2;
				}
			}
			else if(position == ACCESSORY_POSITION_TOP || position == ACCESSORY_POSITION_BOTTOM)
			{
				if(this._horizontalAlign == HORIZONTAL_ALIGN_LEFT)
				{
					object.x = this._paddingLeft;
				}
				else if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
				{
					object.x = this.actualWidth - this._paddingRight - object.width;
				}
				else
				{
					object.x = this._paddingLeft + (this.actualWidth - this._paddingLeft - this._paddingRight - object.width) / 2;
				}
			}
		}

		/**
		 * @private
		 */
		protected function owner_scrollStartHandler(event:Event):void
		{
			if(this._delayTextureCreationOnScroll)
			{
				if(this.accessoryImage)
				{
					this.accessoryImage.delayTextureCreation = true;
				}
				if(this.iconImage)
				{
					this.iconImage.delayTextureCreation = true;
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
				if(this.accessoryImage)
				{
					this.accessoryImage.delayTextureCreation = false;
				}
				if(this.iconImage)
				{
					this.iconImage.delayTextureCreation = false;
				}
			}
		}

		/**
		 * @private
		 */
		override protected function button_removedFromStageHandler(event:Event):void
		{
			super.button_removedFromStageHandler(event);
			this.accessoryTouchPointID = -1;
		}

		/**
		 * @private
		 */
		protected function itemRenderer_triggeredHandler(event:Event):void
		{
			if(this._isToggle || !this.isSelectableWithoutToggle)
			{
				return;
			}
			this.isSelected = true;
		}

		/**
		 * @private
		 */
		protected function accessoryLabelProperties_onChange(proxy:PropertyProxy, name:String):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function stateDelayTimer_timerCompleteHandler(event:TimerEvent):void
		{
			super.currentState = this._delayedCurrentState;
			this._delayedCurrentState = null;
		}

		/**
		 * @private
		 */
		override protected function button_touchHandler(event:TouchEvent):void
		{
			if(this.accessory && this.touchPointID < 0)
			{
				//ignore all touches on accessory. return to up state.
				var touch:Touch = event.getTouch(this.accessory);
				if(touch)
				{
					this.currentState = Button.STATE_UP;
					return;
				}
			}
			super.button_touchHandler(event);
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
			if(!this.stopScrollingOnAccessoryTouch ||
				this.accessory == this.accessoryLabel ||
				this.accessory == this.accessoryImage)
			{
				//do nothing
				return;
			}

			if(this.accessoryTouchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this.accessory, TouchPhase.ENDED, this.accessoryTouchPointID);
				if(!touch)
				{
					return;
				}
				this.accessoryTouchPointID = -1;
			}
			else //if we get here, we don't have a saved touch ID yet
			{
				touch = event.getTouch(this.accessory, TouchPhase.BEGAN);
				if(!touch)
				{
					return;
				}
				this.accessoryTouchPointID = touch.id;
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