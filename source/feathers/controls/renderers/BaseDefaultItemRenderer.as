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
	import starling.events.TouchEvent;
	import starling.textures.Texture;

	/**
	 * An abstract class for item renderer implementations.
	 */
	public class BaseDefaultItemRenderer extends Button
	{
		/**
		 * The default value added to the <code>nameList</code> of the accessory
		 * label.
		 */
		public static const DEFAULT_CHILD_NAME_ACCESSORY_LABEL:String = "feathers-item-renderer-accessory-label";

		/**
		 * The accessory will be positioned above its origin.
		 */
		public static const ACCESSORY_POSITION_TOP:String = "top";

		/**
		 * The accessory will be positioned to the right of its origin.
		 */
		public static const ACCESSORY_POSITION_RIGHT:String = "right";

		/**
		 * The accessory will be positioned below its origin.
		 */
		public static const ACCESSORY_POSITION_BOTTOM:String = "bottom";

		/**
		 * The accessory will be positioned to the left of its origin.
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
		 * @see #accessoryOffsetX
		 * @see #accessoryOffsetY
		 */
		public static const ACCESSORY_POSITION_MANUAL:String = "manual";

		/**
		 * The layout order will be the label first, then the accessory relative
		 * to the label, then the icon relative to both. Best used when the
		 * accessory should be between the label and the icon or when the icon
		 * position shouldn't be affected by the accessory.
		 */
		public static const LAYOUT_ORDER_LABEL_ACCESSORY_ICON:String = "labelAccessoryIcon";

		/**
		 * The layout order will be the label first, then the icon relative to
		 * label, then the accessory relative to both.
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
			this.isQuickHitAreaEnabled = false;
		}

		/**
		 * The value added to the <code>nameList</code> of the accessory label.
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
		 * The item displayed by this renderer.
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
		protected var _owner:IFeathersControl;

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
		 * @private
		 */
		protected var _itemHasLabel:Boolean = true;

		/**
		 * If true, the label will come from the renderer's item using the
		 * appropriate field or function for the label. If false, the label may
		 * be set externally.
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
			this._itemHasLabel = value;
		}

		/**
		 * @private
		 */
		protected var _itemHasIcon:Boolean = true;

		/**
		 * If true, the icon will come from the renderer's item using the
		 * appropriate field or function for the icon. If false, the icon may
		 * be skinned for each state externally.
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
			this._itemHasIcon = value;
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
		 * @see #accessoryPosition
		 * @see #iconPosition
		 * @see LAYOUT_ORDER_LABEL_ICON_ACCESSORY
		 * @see LAYOUT_ORDER_LABEL_ACCESSORY_ICON
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
			if(!this._isToggle)
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
		 * example, you might want to scale the texture for current DPI or apply
		 * pixel snapping.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function():ImageLoader</pre>
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
			this.invalidate(INVALIDATION_FLAG_STYLES);
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
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _accessoryLabelProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to a label accessory.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * @see feathers.core.ITextRenderer
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
		override public function dispose():void
		{
			this.replaceIcon(null);
			this.replaceAccessory(null);
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
				return this._labelFunction(item) as String;
			}
			else if(this._labelField != null && item && item.hasOwnProperty(this._labelField))
			{
				return item[this._labelField] as String;
			}
			else if(item is Object)
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
				var source:Texture = this._accessorySourceFunction(item);
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
				var label:String = this._accessoryLabelFunction(item) as String;
				this.refreshAccessoryLabel(label);
				return DisplayObject(this.accessoryLabel);
			}
			else if(this._accessoryLabelField != null && item && item.hasOwnProperty(this._accessoryLabelField))
			{
				label = item[this._accessoryLabelField] as String;
				this.refreshAccessoryLabel(label);
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
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			if(dataInvalid)
			{
				this.commitData();
			}
			if(dataInvalid || stylesInvalid)
			{
				this.refreshAccessoryLabelStyles();
			}
			super.draw();
		}

		/**
		 * @private
		 */
		override protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
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
			if(this._iconPosition == ICON_POSITION_LEFT || this._iconPosition == ICON_POSITION_LEFT_BASELINE || this._iconPosition == ICON_POSITION_RIGHT || this._iconPosition == ICON_POSITION_RIGHT_BASELINE)
			{
				width += this.currentIcon.width + gap;
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

			if(this._accessoryPosition == ACCESSORY_POSITION_LEFT || this._accessoryPosition == ACCESSORY_POSITION_RIGHT)
			{
				var adjustedAccessoryGap:Number = isNaN(this._accessoryGap) ? gap : this._accessoryGap;
				if(adjustedAccessoryGap == Number.POSITIVE_INFINITY)
				{
					adjustedAccessoryGap = Math.min(this._paddingLeft, this._paddingRight, this._gap);
				}
				width += this.accessory.width + adjustedAccessoryGap;
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
			if(this._iconPosition == ICON_POSITION_TOP || this._iconPosition == ICON_POSITION_BOTTOM)
			{
				height += this.currentIcon.height + gap;
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
			if(this._accessoryPosition == ACCESSORY_POSITION_TOP || this._accessoryPosition == ACCESSORY_POSITION_BOTTOM)
			{
				var adjustedAccessoryGap:Number = isNaN(this._accessoryGap) ? gap : this._accessoryGap;
				if(adjustedAccessoryGap == Number.POSITIVE_INFINITY)
				{
					adjustedAccessoryGap = Math.min(this._paddingTop, this._paddingBottom, this._gap);
				}
				height += this.accessory.height + adjustedAccessoryGap;
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
			if(this._owner)
			{
				if(this._itemHasLabel)
				{
					this._label = this.itemToLabel(this._data);
				}
				if(this._itemHasIcon)
				{
					const newIcon:DisplayObject = this.itemToIcon(this._data);
					this.replaceIcon(newIcon);
				}
				const newAccessory:DisplayObject = this.itemToAccessory(this._data);
				this.replaceAccessory(newAccessory);
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
				if(this.accessory)
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

			this.defaultIcon = newIcon;
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
				this.accessory.removeEventListener(TouchEvent.TOUCH, accessory_touchHandler);

				//the accessory may have come from outside of this class. it's
				//up to that code to dispose of the accessory. in fact, if we
				//disposed of it here, we will probably screw something up, so
				//let's just remove it.
				this.accessory.removeFromParent();
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
				if(this.accessory is IFeathersControl && !(this.accessory is BitmapFontTextRenderer))
				{
					this.accessory.addEventListener(TouchEvent.TOUCH, accessory_touchHandler);
				}
				this.addChild(this.accessory);
			}
		}

		/**
		 * @private
		 */
		protected function refreshAccessoryLabelStyles():void
		{
			if(!this.accessoryLabel)
			{
				return;
			}
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
					this.positionRelativeToOthers(this.accessory, labelRenderer, null, this._accessoryPosition, accessoryGap);
					var iconPosition:String = this._iconPosition;
					if(iconPosition == ICON_POSITION_LEFT_BASELINE)
					{
						iconPosition = ICON_POSITION_LEFT;
					}
					else if(iconPosition == ICON_POSITION_RIGHT_BASELINE)
					{
						iconPosition = ICON_POSITION_RIGHT;
					}
					this.positionRelativeToOthers(this.currentIcon, labelRenderer, this.accessory, iconPosition, this._gap);
				}
				else
				{
					this.positionLabelAndIcon();
					this.positionRelativeToOthers(this.accessory, labelRenderer, this.currentIcon, this._accessoryPosition, accessoryGap);
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
					this.positionRelativeToOthers(this.accessory, labelRenderer, null, this._accessoryPosition, accessoryGap);
				}
			}
			else if(iconIsInLayout)
			{
				this.positionSingleChild(this.currentIcon);
				if(accessoryIsInLayout)
				{
					this.positionRelativeToOthers(this.accessory, this.currentIcon, null, this._accessoryPosition, accessoryGap);
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
			if(this.currentIcon && (this._iconPosition == ICON_POSITION_LEFT || this._iconPosition == ICON_POSITION_LEFT_BASELINE ||
				this._iconPosition == ICON_POSITION_RIGHT || this._iconPosition == ICON_POSITION_RIGHT_BASELINE))
			{
				calculatedWidth -= (this._gap + this.currentIcon.width);
			}

			if(this.accessory && (this._accessoryPosition == ACCESSORY_POSITION_LEFT || this._accessoryPosition == ACCESSORY_POSITION_RIGHT))
			{
				var accessoryGap:Number = (isNaN(this._accessoryGap) || this._accessoryGap == Number.POSITIVE_INFINITY) ? this._gap : this._accessoryGap;
				calculatedWidth -= (accessoryGap + this.accessory.width);
			}

			this.labelTextRenderer.maxWidth = calculatedWidth - this._paddingLeft - this._paddingRight;
		}

		/**
		 * @private
		 */
		protected function positionRelativeToOthers(object:DisplayObject, relativeTo:DisplayObject, relativeTo2:DisplayObject, position:String, gap:Number):void
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
					object.x = newRelativeToX - gap - object.width;
				}
			}

			var offsetX:Number = newRelativeToX - relativeToX;
			var offsetY:Number = newRelativeToY - relativeToY;
			relativeTo.x += offsetX;
			relativeTo.y += offsetY;
			if(relativeTo2)
			{
				relativeTo2.x += offsetX;
				relativeTo2.y += offsetY;
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
		protected function handleOwnerScroll():void
		{
			this._touchPointID = -1;
			if(this._stateDelayTimer && this._stateDelayTimer.running)
			{
				this._stateDelayTimer.stop();
			}
			this._delayedCurrentState = null;
			if(this._currentState != Button.STATE_UP)
			{
				super.currentState = Button.STATE_UP;
			}
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
		protected function accessory_touchHandler(event:TouchEvent):void
		{
			if(this.accessory == this.accessoryLabel ||
				this.accessory == this.accessoryImage)
			{
				//do nothing
				return;
			}
			event.stopPropagation();
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