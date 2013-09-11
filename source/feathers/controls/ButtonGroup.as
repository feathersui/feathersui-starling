/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.PropertyProxy;
	import feathers.data.ListCollection;

	import starling.events.Event;

	/**
	 * Dispatched when one of the buttons is triggered. The <code>data</code>
	 * property of the event contains the item from the data provider that is
	 * associated with the button that was triggered.
	 *
	 * <p>The following example listens to <code>Event.TRIGGERED</code> on the
	 * button group instead of on individual buttons:</p>
	 *
	 * <listing version="3.0">
	 * group.dataProvider = new ListCollection(
	 * [
	 *     { label: "Yes" },
	 *     { label: "No" },
	 *     { label: "Cancel" },
	 * ]);
	 * group.addEventListener( Event.TRIGGERED, function( event:Event, data:Object ):void
	 * {
	 *    trace( "The button with label \"" + data.label + "\" was triggered." );
	 * }</listing>
	 *
	 * @eventType starling.events.Event.TRIGGERED
	 */
	[Event(name="triggered", type="starling.events.Event")]

	[DefaultProperty("dataProvider")]
	/**
	 * A set of related buttons with layout, customized using a data provider.
	 *
	 * <p>The following example creates a button group with a few buttons:</p>
	 *
	 * <listing version="3.0">
	 * var group:ButtonGroup = new ButtonGroup();
	 * group.dataProvider = new ListCollection(
	 * [
	 *     { label: "Yes", triggered: yesButton_triggeredHandler },
	 *     { label: "No", triggered: noButton_triggeredHandler },
	 *     { label: "Cancel", triggered: cancelButton_triggeredHandler },
	 * ]);
	 * this.addChild( group );</listing>
	 *
	 * @see http://wiki.starling-framework.org/feathers/button-group
	 */
	public class ButtonGroup extends FeathersControl
	{
		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_BUTTON_FACTORY:String = "buttonFactory";

		/**
		 * @private
		 */
		private static const DEFAULT_BUTTON_FIELDS:Vector.<String> = new <String>
		[
			"defaultIcon",
			"upIcon",
			"downIcon",
			"hoverIcon",
			"disabledIcon",
			"defaultSelectedIcon",
			"selectedUpIcon",
			"selectedDownIcon",
			"selectedHoverIcon",
			"selectedDisabledIcon",
			"isSelected",
			"isToggle",
		];

		/**
		 * @private
		 */
		private static const DEFAULT_BUTTON_EVENTS:Vector.<String> = new <String>
		[
			Event.TRIGGERED,
			Event.CHANGE,
		];

		/**
		 * The buttons are displayed in order from left to right.
		 *
		 * @see #direction
		 */
		public static const DIRECTION_HORIZONTAL:String = "horizontal";

		/**
		 * The buttons are displayed in order from top to bottom.
		 *
		 * @see #direction
		 */
		public static const DIRECTION_VERTICAL:String = "vertical";

		/**
		 * The buttons will be aligned horizontally to the left edge of the
		 * button group.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_LEFT:String = "left";

		/**
		 * The buttons will be aligned horizontally to the center of the
		 * button group.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_CENTER:String = "center";

		/**
		 * The buttons will be aligned horizontally to the right edge of the
		 * button group.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_RIGHT:String = "right";

		/**
		 * If the direction is vertical, each button will fill the entire
		 * width of the button group, and if the direction is horizontal, the
		 * width of the button group will be divided so that each button will
		 * each have an equal width, and the total width of all buttons will
		 * fill the entire space.
		 *
		 * @see #horizontalAlign
		 * @see #direction
		 */
		public static const HORIZONTAL_ALIGN_JUSTIFY:String = "justify";

		/**
		 * The buttons will be aligned vertically to the top edge of the
		 * button group.
		 */
		public static const VERTICAL_ALIGN_TOP:String = "top";

		/**
		 * The buttons will be aligned vertically to the middle of the
		 * button group.
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";

		/**
		 * The buttons will be aligned vertically to the bottom edge of the
		 * button group.
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";

		/**
		 * If the direction is horizontal, each button will fill the entire
		 * height of the button group, and if the direction is vertical, the
		 * height of the button group will be divided so that each button will
		 * each have an equal height, and the total height of all buttons will
		 * fill the entire space.
		 *
		 * @see #verticalAlign
		 * @see #direction
		 */
		public static const VERTICAL_ALIGN_JUSTIFY:String = "justify";

		/**
		 * The default value added to the <code>nameList</code> of the buttons.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		public static const DEFAULT_CHILD_NAME_BUTTON:String = "feathers-button-group-button";

		/**
		 * @private
		 */
		protected static function defaultButtonFactory():Button
		{
			return new Button();
		}

		/**
		 * Constructor.
		 */
		public function ButtonGroup()
		{
		}

		/**
		 * The value added to the <code>nameList</code> of the buttons. This
		 * variable is <code>protected</code> so that sub-classes can customize
		 * the button name in their constructors instead of using the default
		 * name defined by <code>DEFAULT_CHILD_NAME_BUTTON</code>.
		 *
		 * <p>To customize the button name without subclassing, see
		 * <code>customButtonName</code>.</p>
		 *
		 * @see #customButtonName
		 * @see feathers.core.IFeathersControl#nameList
		 */
		protected var buttonName:String = DEFAULT_CHILD_NAME_BUTTON;

		/**
		 * The value added to the <code>nameList</code> of the first button.
		 *
		 * <p>To customize the first button name without subclassing, see
		 * <code>customFirstButtonName</code>.</p>
		 *
		 * @see #customFirstButtonName
		 * @see feathers.core.IFeathersControl#nameList
		 */
		protected var firstButtonName:String = DEFAULT_CHILD_NAME_BUTTON;

		/**
		 * The value added to the <code>nameList</code> of the last button.
		 *
		 * <p>To customize the last button name without subclassing, see
		 * <code>customLastButtonName</code>.</p>
		 *
		 * @see #customLastButtonName
		 * @see feathers.core.IFeathersControl#nameList
		 */
		protected var lastButtonName:String = DEFAULT_CHILD_NAME_BUTTON;

		/**
		 * @private
		 */
		protected var activeFirstButton:Button;

		/**
		 * @private
		 */
		protected var inactiveFirstButton:Button;

		/**
		 * @private
		 */
		protected var activeLastButton:Button;

		/**
		 * @private
		 */
		protected var inactiveLastButton:Button;

		/**
		 * @private
		 */
		protected var activeButtons:Vector.<Button> = new <Button>[];

		/**
		 * @private
		 */
		protected var inactiveButtons:Vector.<Button> = new <Button>[];

		/**
		 * @private
		 */
		protected var _dataProvider:ListCollection;

		/**
		 * The collection of data to be displayed with buttons.
		 *
		 * <p>The following example sets the button group's data provider:</p>
		 *
		 * <listing version="3.0">
		 * group.dataProvider = new ListCollection(
		 * [
		 *     { label: "Yes", triggered: yesButton_triggeredHandler },
		 *     { label: "No", triggered: noButton_triggeredHandler },
		 *     { label: "Cancel", triggered: cancelButton_triggeredHandler },
		 * ]);</listing>
		 *
		 * <p>By default, items in the data provider support the following
		 * properties from <code>Button</code></p>
		 *
		 * <ul>
		 *     <li>label</li>
		 *     <li>defaultIcon</li>
		 *     <li>upIcon</li>
		 *     <li>downIcon</li>
		 *     <li>hoverIcon</li>
		 *     <li>disabledIcon</li>
		 *     <li>defaultSelectedIcon</li>
		 *     <li>selectedUpIcon</li>
		 *     <li>selectedDownIcon</li>
		 *     <li>selectedHoverIcon</li>
		 *     <li>selectedDisabledIcon</li>
		 *     <li>isSelected</li>
		 *     <li>isToggle</li>
		 *     <li>isEnabled</li>
		 * </ul>
		 *
		 * <p>Additionally, you can add the following event listeners:</p>
		 *
		 * <ul>
		 *     <li>Event.TRIGGERED</li>
		 *     <li>Event.CHANGE</li>
		 * </ul>
		 *
		 * <p>You can pass a function to the <code>buttonInitializer</code>
		 * property that can provide custom logic to interpret each item in the
		 * data provider differently.</p>
		 *
		 * @default null
		 *
		 * @see Button
		 * @see #buttonInitializer
		 */
		public function get dataProvider():ListCollection
		{
			return this._dataProvider;
		}

		/**
		 * @private
		 */
		public function set dataProvider(value:ListCollection):void
		{
			if(this._dataProvider == value)
			{
				return;
			}
			if(this._dataProvider)
			{
				this._dataProvider.removeEventListener(Event.CHANGE, dataProvider_changeHandler);
			}
			this._dataProvider = value;
			if(this._dataProvider)
			{
				this._dataProvider.addEventListener(Event.CHANGE, dataProvider_changeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _direction:String = DIRECTION_VERTICAL;

		[Inspectable(type="String",enumeration="horizontal,vertical")]
		/**
		 * The button group layout is either vertical or horizontal.
		 *
		 * <p>The following example sets the layout direction of the buttons
		 * to line them up horizontally:</p>
		 *
		 * <listing version="3.0">
		 * group.direction = ButtonGroup.DIRECTION_HORIZONTAL;</listing>
		 *
		 * @default ButtonGroup.DIRECTION_VERTICAL
		 *
		 * @see #DIRECTION_HORIZONTAL
		 * @see #DIRECTION_VERTICAL
		 */
		public function get direction():String
		{
			return _direction;
		}

		/**
		 * @private
		 */
		public function set direction(value:String):void
		{
			if(this._direction == value)
			{
				return;
			}
			this._direction = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _horizontalAlign:String = HORIZONTAL_ALIGN_JUSTIFY;

		[Inspectable(type="String",enumeration="left,center,right,justify")]
		/**
		 * Determines how the buttons are horizontally aligned within the bounds
		 * of the button group (on the x-axis).
		 *
		 * <p>The following example aligns the group's content to the left:</p>
		 *
		 * <listing version="3.0">
		 * group.horizontalAlign = ButtonGroup.HORIZONTAL_ALIGN_LEFT;</listing>
		 *
		 * @default ButtonGroup.HORIZONTAL_ALIGN_JUSTIFY
		 *
		 * @see #HORIZONTAL_ALIGN_LEFT
		 * @see #HORIZONTAL_ALIGN_CENTER
		 * @see #HORIZONTAL_ALIGN_RIGHT
		 * @see #HORIZONTAL_ALIGN_JUSTIFY
		 */
		public function get horizontalAlign():String
		{
			return this._horizontalAlign;
		}

		/**
		 * @private
		 */
		public function set horizontalAlign(value:String):void
		{
			if(this._horizontalAlign == value)
			{
				return;
			}
			this._horizontalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _verticalAlign:String = VERTICAL_ALIGN_JUSTIFY;

		[Inspectable(type="String",enumeration="top,middle,bottom,justify")]
		/**
		 * Determines how the buttons are vertically aligned within the bounds
		 * of the button group (on the y-axis).
		 *
		 * <p>The following example aligns the group's content to the top:</p>
		 *
		 * <listing version="3.0">
		 * group.verticalAlign = ButtonGroup.VERTICAL_ALIGN_TOP;</listing>
		 *
		 * @default ButtonGroup.VERTICAL_ALIGN_JUSTIFY
		 *
		 * @see #VERTICAL_ALIGN_TOP
		 * @see #VERTICAL_ALIGN_MIDDLE
		 * @see #VERTICAL_ALIGN_RIGHT
		 * @see #VERTICAL_ALIGN_JUSTIFY
		 */
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}

		/**
		 * @private
		 */
		public function set verticalAlign(value:String):void
		{
			if(this._verticalAlign == value)
			{
				return;
			}
			this._verticalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _gap:Number = 0;

		/**
		 * Space, in pixels, between buttons.
		 *
		 * <p>The following example sets the gap used for the button layout to
		 * 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * group.gap = 20;</listing>
		 *
		 * @default 0
		 */
		public function get gap():Number
		{
			return this._gap;
		}

		/**
		 * @private
		 */
		public function set gap(value:Number):void
		{
			if(this._gap == value)
			{
				return;
			}
			this._gap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _firstGap:Number = NaN;

		/**
		 * Space, in pixels, between the first two buttons. If <code>NaN</code>,
		 * the default <code>gap</code> property will be used.
		 *
		 * <p>The following example sets the gap between the first and second
		 * button to a different value than the standard gap:</p>
		 *
		 * <listing version="3.0">
		 * group.firstGap = 30;
		 * group.gap = 20;</listing>
		 *
		 * @default NaN
		 *
		 * @see #gap
		 * @see #lastGap
		 */
		public function get firstGap():Number
		{
			return this._firstGap;
		}

		/**
		 * @private
		 */
		public function set firstGap(value:Number):void
		{
			if(this._firstGap == value)
			{
				return;
			}
			this._firstGap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _lastGap:Number = NaN;

		/**
		 * Space, in pixels, between the last two buttons. If <code>NaN</code>,
		 * the default <code>gap</code> property will be used.
		 *
		 * <p>The following example sets the gap between the last and next to last
		 * button to a different value than the standard gap:</p>
		 *
		 * <listing version="3.0">
		 * group.lastGap = 30;
		 * group.gap = 20;</listing>
		 *
		 * @default NaN
		 *
		 * @see #gap
		 * @see #firstGap
		 */
		public function get lastGap():Number
		{
			return this._lastGap;
		}

		/**
		 * @private
		 */
		public function set lastGap(value:Number):void
		{
			if(this._lastGap == value)
			{
				return;
			}
			this._lastGap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * Quickly sets all padding properties to the same value. The
		 * <code>padding</code> getter always returns the value of
		 * <code>paddingTop</code>, but the other padding values may be
		 * different.
		 *
		 * <p>In the following example, the padding of all sides of the group
		 * is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * group.padding = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #paddingTop
		 * @see #paddingRight
		 * @see #paddingBottom
		 * @see #paddingLeft
		 */
		public function get padding():Number
		{
			return this._paddingTop;
		}

		/**
		 * @private
		 */
		public function set padding(value:Number):void
		{
			this.paddingTop = value;
			this.paddingRight = value;
			this.paddingBottom = value;
			this.paddingLeft = value;
		}

		/**
		 * @private
		 */
		protected var _paddingTop:Number = 0;

		/**
		 * The minimum space, in pixels, between the group's top edge and the
		 * group's buttons.
		 *
		 * <p>In the following example, the padding on the top edge of the
		 * group is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * group.paddingTop = 20;</listing>
		 *
		 * @default 0
		 */
		public function get paddingTop():Number
		{
			return this._paddingTop;
		}

		/**
		 * @private
		 */
		public function set paddingTop(value:Number):void
		{
			if(this._paddingTop == value)
			{
				return;
			}
			this._paddingTop = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingRight:Number = 0;

		/**
		 * The minimum space, in pixels, between the group's right edge and the
		 * group's buttons.
		 *
		 * <p>In the following example, the padding on the right edge of the
		 * group is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * group.paddingRight = 20;</listing>
		 *
		 * @default 0
		 */
		public function get paddingRight():Number
		{
			return this._paddingRight;
		}

		/**
		 * @private
		 */
		public function set paddingRight(value:Number):void
		{
			if(this._paddingRight == value)
			{
				return;
			}
			this._paddingRight = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingBottom:Number = 0;

		/**
		 * The minimum space, in pixels, between the group's bottom edge and the
		 * group's buttons.
		 *
		 * <p>In the following example, the padding on the bottom edge of the
		 * group is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * group.paddingBottom = 20;</listing>
		 *
		 * @default 0
		 */
		public function get paddingBottom():Number
		{
			return this._paddingBottom;
		}

		/**
		 * @private
		 */
		public function set paddingBottom(value:Number):void
		{
			if(this._paddingBottom == value)
			{
				return;
			}
			this._paddingBottom = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingLeft:Number = 0;

		/**
		 * The minimum space, in pixels, between the group's left edge and the
		 * group's buttons.
		 *
		 * <p>In the following example, the padding on the left edge of the
		 * group is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * group.paddingLeft = 20;</listing>
		 *
		 * @default 0
		 */
		public function get paddingLeft():Number
		{
			return this._paddingLeft;
		}

		/**
		 * @private
		 */
		public function set paddingLeft(value:Number):void
		{
			if(this._paddingLeft == value)
			{
				return;
			}
			this._paddingLeft = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _buttonFactory:Function = defaultButtonFactory;

		/**
		 * Creates a new button. A button must be an instance of <code>Button</code>.
		 * This factory can be used to change properties on the buttons when
		 * they are first created. For instance, if you are skinning Feathers
		 * components without a theme, you might use this factory to set skins
		 * and other styles on a button.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 *
		 * <pre>function():Button</pre>
		 *
		 * <p>The following example skins the buttons using a custom button
		 * factory:</p>
		 *
		 * <listing version="3.0">
		 * group.buttonFactory = function():Button
		 * {
		 *     var button:Button = new Button();
		 *     button.defaultSkin = new Image( texture );
		 *     return button;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.Button
		 * @see #firstButtonFactory
		 * @see #lastButtonFactory
		 */
		public function get buttonFactory():Function
		{
			return this._buttonFactory;
		}

		/**
		 * @private
		 */
		public function set buttonFactory(value:Function):void
		{
			if(this._buttonFactory == value)
			{
				return;
			}
			this._buttonFactory = value;
			this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _firstButtonFactory:Function;

		/**
		 * Creates a new first button. If the <code>firstButtonFactory</code> is
		 * <code>null</code>, then the button group will use the <code>buttonFactory</code>.
		 * The first button must be an instance of <code>Button</code>. This
		 * factory can be used to change properties on the first button when
		 * it is first created. For instance, if you are skinning Feathers
		 * components without a theme, you might use this factory to set skins
		 * and other styles on the first button.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 *
		 * <pre>function():Button</pre>
		 *
		 * <p>The following example skins the first button using a custom
		 * factory:</p>
		 *
		 * <listing version="3.0">
		 * group.firstButtonFactory = function():Button
		 * {
		 *     var button:Button = new Button();
		 *     button.defaultSkin = new Image( texture );
		 *     return button;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.Button
		 * @see #buttonFactory
		 * @see #lastButtonFactory
		 */
		public function get firstButtonFactory():Function
		{
			return this._firstButtonFactory;
		}

		/**
		 * @private
		 */
		public function set firstButtonFactory(value:Function):void
		{
			if(this._firstButtonFactory == value)
			{
				return;
			}
			this._firstButtonFactory = value;
			this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _lastButtonFactory:Function;

		/**
		 * Creates a new last button. If the <code>lastButtonFactory</code> is
		 * <code>null</code>, then the button group will use the <code>buttonFactory</code>.
		 * The last button must be an instance of <code>Button</code>. This
		 * factory can be used to change properties on the last button when
		 * it is first created. For instance, if you are skinning Feathers
		 * components without a theme, you might use this factory to set skins
		 * and other styles on the last button.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 *
		 * <pre>function():Button</pre>
		 *
		 * <p>The following example skins the last button using a custom
		 * factory:</p>
		 *
		 * <listing version="3.0">
		 * group.lastButtonFactory = function():Button
		 * {
		 *     var button:Button = new Button();
		 *     button.defaultSkin = new Image( texture );
		 *     return button;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.Button
		 * @see #buttonFactory
		 * @see #firstButtonFactory
		 */
		public function get lastButtonFactory():Function
		{
			return this._lastButtonFactory;
		}

		/**
		 * @private
		 */
		public function set lastButtonFactory(value:Function):void
		{
			if(this._lastButtonFactory == value)
			{
				return;
			}
			this._lastButtonFactory = value;
			this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _buttonInitializer:Function = defaultButtonInitializer;

		/**
		 * Modifies a button, perhaps by changing its label and icons, based on the
		 * item from the data provider that the button is meant to represent. The
		 * default buttonInitializer function can set the button's label and icons if
		 * <code>label</code> and/or any of the <code>Button</code> icon fields
		 * (<code>defaultIcon</code>, <code>upIcon</code>, etc.) are present in
		 * the item. You can listen to <code>Event.TRIGGERED</code> and
		 * <code>Event.CHANGE</code> by passing in functions for each.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 *
		 * <pre>function( button:Button, item:Object ):void</pre>
		 *
		 * <p>The following example provides a custom button initializer:</p>
		 *
		 * <listing version="3.0">
		 * group.buttonInitializer = function( button:Button, item:Object ):void
		 * {
		 *     button.label = item.label;
		 * };</listing>
		 *
		 * @see #dataProvider
		 */
		public function get buttonInitializer():Function
		{
			return this._buttonInitializer;
		}

		/**
		 * @private
		 */
		public function set buttonInitializer(value:Function):void
		{
			if(this._buttonInitializer == value)
			{
				return;
			}
			this._buttonInitializer = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _customButtonName:String;

		/**
		 * A name to add to all buttons in this button group. Typically used by
		 * a theme to provide different skins to different button groups.
		 *
		 * <p>The following example provides a custom button name:</p>
		 *
		 * <listing version="3.0">
		 * group.customButtonName = "my-custom-button";</listing>
		 *
		 * <p>In your theme, you can target this sub-component name to provide
		 * different skins than the default style:</p>
		 *
		 * <listing version="3.0">
		 * setInitializerForClass( Button, customButtonInitializer, "my-custom-button");</listing>
		 *
		 * @default null
		 *
		 * @see #DEFAULT_CHILD_NAME_BUTTON
		 * @see feathers.core.FeathersControl#nameList
		 * @see feathers.core.DisplayListWatcher
		 * @see http://wiki.starling-framework.org/feathers/custom-themes
		 */
		public function get customButtonName():String
		{
			return this._customButtonName;
		}

		/**
		 * @private
		 */
		public function set customButtonName(value:String):void
		{
			if(this._customButtonName == value)
			{
				return;
			}
			this._customButtonName = value;
			this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customFirstButtonName:String;

		/**
		 * A name to add to the first button in this button group. Typically
		 * used by a theme to provide different skins to the first button.
		 *
		 * <p>The following example provides a custom first button name:</p>
		 *
		 * <listing version="3.0">
		 * group.customFirstButtonName = "my-custom-first-button";</listing>
		 *
		 * <p>In your theme, you can target this sub-component name to provide
		 * different skins than the default style:</p>
		 *
		 * <listing version="3.0">
		 * setInitializerForClass( Button, customFirstButtonInitializer, "my-custom-first-button");</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.FeathersControl#nameList
		 * @see feathers.core.DisplayListWatcher
		 * @see http://wiki.starling-framework.org/feathers/custom-themes
		 */
		public function get customFirstButtonName():String
		{
			return this._customFirstButtonName;
		}

		/**
		 * @private
		 */
		public function set customFirstButtonName(value:String):void
		{
			if(this._customFirstButtonName == value)
			{
				return;
			}
			this._customFirstButtonName = value;
			this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customLastButtonName:String;

		/**
		 * A name to add to the last button in this button group. Typically used
		 * by a theme to provide different skins to the last button.
		 *
		 * <p>The following example provides a custom last button name:</p>
		 *
		 * <listing version="3.0">
		 * group.customLastButtonName = "my-custom-last-button";</listing>
		 *
		 * <p>In your theme, you can target this sub-component name to provide
		 * different skins than the default style:</p>
		 *
		 * <listing version="3.0">
		 * setInitializerForClass( Button, customLastButtonInitializer, "my-custom-last-button");</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.FeathersControl#nameList
		 * @see feathers.core.DisplayListWatcher
		 * @see http://wiki.starling-framework.org/feathers/custom-themes
		 */
		public function get customLastButtonName():String
		{
			return this._customLastButtonName;
		}

		/**
		 * @private
		 */
		public function set customLastButtonName(value:String):void
		{
			if(this._customLastButtonName == value)
			{
				return;
			}
			this._customLastButtonName = value;
			this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _buttonProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to all of the button
		 * group's buttons. These values are shared by each button, so values
		 * that cannot be shared (such as display objects that need to be added
		 * to the display list) should be passed to buttons using the
		 * <code>buttonFactory</code> or in a theme. The buttons in a button
		 * group are instances of <code>feathers.controls.Button</code>.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>The following example sets some properties on all of the buttons:</p>
		 *
		 * <listing version="3.0">
		 * group.buttonProperties.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
		 * group.buttonProperties.verticalAlign = Button.VERTICAL_ALIGN_TOP;</listing>
		 *
		 * <p>Setting properties in a <code>buttonFactory</code> function instead
		 * of using <code>buttonProperties</code> will result in better
		 * performance.</p>
		 *
		 * @default null
		 *
		 * @see #buttonFactory
		 * @see #firstButtonFactory
		 * @see #lastButtonFactory
		 * @see feathers.controls.Button
		 */
		public function get buttonProperties():Object
		{
			if(!this._buttonProperties)
			{
				this._buttonProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._buttonProperties;
		}

		/**
		 * @private
		 */
		public function set buttonProperties(value:Object):void
		{
			if(this._buttonProperties == value)
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
			if(this._buttonProperties)
			{
				this._buttonProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._buttonProperties = PropertyProxy(value);
			if(this._buttonProperties)
			{
				this._buttonProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this.dataProvider = null;
			super.dispose();
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			const buttonFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_BUTTON_FACTORY);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);

			if(dataInvalid || stateInvalid || buttonFactoryInvalid)
			{
				this.refreshButtons(buttonFactoryInvalid);
			}

			if(dataInvalid || buttonFactoryInvalid || stylesInvalid)
			{
				this.refreshButtonStyles();
			}

			if(dataInvalid || stateInvalid || buttonFactoryInvalid)
			{
				this.commitEnabled();
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(sizeInvalid || dataInvalid || buttonFactoryInvalid || stylesInvalid)
			{
				this.layoutButtons();
			}
		}

		/**
		 * @private
		 */
		protected function commitEnabled():void
		{
			const buttonCount:int = this.activeButtons.length;
			for(var i:int = 0; i < buttonCount; i++)
			{
				var button:Button = this.activeButtons[i];
				button.isEnabled &&= this._isEnabled;
			}
		}

		/**
		 * @private
		 */
		protected function refreshButtonStyles():void
		{
			for each(var button:Button in this.activeButtons)
			{
				for(var propertyName:String in this._buttonProperties)
				{
					var propertyValue:Object = this._buttonProperties[propertyName];
					if(button.hasOwnProperty(propertyName))
					{
						button[propertyName] = propertyValue;
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function defaultButtonInitializer(button:Button, item:Object):void
		{
			if(item is Object)
			{
				if(item.hasOwnProperty("label"))
				{
					button.label = item.label as String;
				}
				else
				{
					button.label = item.toString();
				}
				if(item.hasOwnProperty("isEnabled"))
				{
					button.isEnabled = item.isEnabled as Boolean;
				}
				for each(var field:String in DEFAULT_BUTTON_FIELDS)
				{
					if(item.hasOwnProperty(field))
					{
						button[field] = item[field];
					}
				}
				for each(field in DEFAULT_BUTTON_EVENTS)
				{
					if(item.hasOwnProperty(field))
					{
						button.addEventListener(field, item[field] as Function);
					}
				}
			}
			else
			{
				button.label = "";
			}

		}

		/**
		 * @private
		 */
		protected function refreshButtons(isFactoryInvalid:Boolean):void
		{
			var temp:Vector.<Button> = this.inactiveButtons;
			this.inactiveButtons = this.activeButtons;
			this.activeButtons = temp;
			this.activeButtons.length = 0;
			temp = null;
			if(isFactoryInvalid)
			{
				this.clearInactiveButtons();
			}
			else
			{
				if(this.activeFirstButton)
				{
					this.inactiveButtons.shift();
				}
				this.inactiveFirstButton = this.activeFirstButton;

				if(this.activeLastButton)
				{
					this.inactiveButtons.pop();
				}
				this.inactiveLastButton = this.activeLastButton;
			}
			this.activeFirstButton = null;
			this.activeLastButton = null;

			const itemCount:int = this._dataProvider ? this._dataProvider.length : 0;
			const lastItemIndex:int = itemCount - 1;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = this._dataProvider.getItemAt(i);
				if(i == 0)
				{
					var button:Button = this.activeFirstButton = this.createFirstButton(item);
				}
				else if(i == lastItemIndex)
				{
					button = this.activeLastButton = this.createLastButton(item);
				}
				else
				{
					button = this.createButton(item);
				}
				this.activeButtons.push(button);
			}
			this.clearInactiveButtons();
		}

		/**
		 * @private
		 */
		protected function clearInactiveButtons():void
		{
			const itemCount:int = this.inactiveButtons.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var button:Button = this.inactiveButtons.shift();
				this.destroyButton(button);
			}

			if(this.inactiveFirstButton)
			{
				this.destroyButton(this.inactiveFirstButton);
				this.inactiveFirstButton = null;
			}

			if(this.inactiveLastButton)
			{
				this.destroyButton(this.inactiveLastButton);
				this.inactiveLastButton = null;
			}
		}

		/**
		 * @private
		 */
		protected function createFirstButton(item:Object):Button
		{
			if(this.inactiveFirstButton)
			{
				var button:Button = this.inactiveFirstButton;
				this.inactiveFirstButton = null;
			}
			else
			{
				const factory:Function = this._firstButtonFactory != null ? this._firstButtonFactory : this._buttonFactory;
				button = Button(factory());
				if(this._customFirstButtonName)
				{
					button.nameList.add(this._customFirstButtonName);
				}
				else if(this._customButtonName)
				{
					button.nameList.add(this._customButtonName);
				}
				else
				{
					button.nameList.add(this.firstButtonName);
				}
				button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
				this.addChild(button);
			}
			this._buttonInitializer(button, item);
			return button;
		}

		/**
		 * @private
		 */
		protected function createLastButton(item:Object):Button
		{
			if(this.inactiveLastButton)
			{
				var button:Button = this.inactiveLastButton;
				this.inactiveLastButton = null;
			}
			else
			{
				const factory:Function = this._lastButtonFactory != null ? this._lastButtonFactory : this._buttonFactory;
				button = Button(factory());
				if(this._customLastButtonName)
				{
					button.nameList.add(this._customLastButtonName);
				}
				else if(this._customButtonName)
				{
					button.nameList.add(this._customButtonName);
				}
				else
				{
					button.nameList.add(this.lastButtonName);
				}
				button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
				this.addChild(button);
			}
			this._buttonInitializer(button, item);
			return button;
		}

		/**
		 * @private
		 */
		protected function createButton(item:Object):Button
		{
			if(this.inactiveButtons.length == 0)
			{
				var button:Button = this._buttonFactory();
				if(this._customButtonName)
				{
					button.nameList.add(this._customButtonName);
				}
				else
				{
					button.nameList.add(this.buttonName);
				}
				button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
				this.addChild(button);
			}
			else
			{
				button = this.inactiveButtons.shift();
			}
			this._buttonInitializer(button, item);
			return button;
		}

		/**
		 * @private
		 */
		protected function destroyButton(button:Button):void
		{
			button.removeEventListener(Event.TRIGGERED, button_triggeredHandler);
			this.removeChild(button, true);
		}

		/**
		 * If the component's dimensions have not been set explicitly, it will
		 * measure its content and determine an ideal size for itself. If the
		 * <code>explicitWidth</code> or <code>explicitHeight</code> member
		 * variables are set, those value will be used without additional
		 * measurement. If one is set, but not the other, the dimension with the
		 * explicit value will not be measured, but the other non-explicit
		 * dimension will still need measurement.
		 *
		 * <p>Calls <code>setSizeInternal()</code> to set up the
		 * <code>actualWidth</code> and <code>actualHeight</code> member
		 * variables used for layout.</p>
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}

			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth)
			{
				newWidth = 0;
				for each(var button:Button in this.activeButtons)
				{
					button.setSize(NaN, NaN);
					button.validate();
					newWidth = Math.max(button.width, newWidth);
				}
				if(this._direction == DIRECTION_HORIZONTAL)
				{
					var buttonCount:int = this.activeButtons.length;
					newWidth = buttonCount * (newWidth + this._gap) - this._gap;
					if(!isNaN(this._firstGap) && buttonCount > 1)
					{
						newWidth -= this._gap;
						newWidth += this._firstGap;
					}
					if(!isNaN(this._lastGap) && buttonCount > 2)
					{
						newWidth -= this._gap;
						newWidth += this._lastGap;
					}
				}
				newWidth += this._paddingLeft + this._paddingRight;
			}

			if(needsHeight)
			{
				newHeight = 0;
				for each(button in this.activeButtons)
				{
					button.validate();
					newHeight = Math.max(button.height, newHeight);
				}
				if(this._direction != DIRECTION_HORIZONTAL)
				{
					buttonCount = this.activeButtons.length;
					newHeight = buttonCount * (newHeight + this._gap) - this._gap;
					if(!isNaN(this._firstGap) && buttonCount > 1)
					{
						newHeight -= this._gap;
						newHeight += this._firstGap;
					}
					if(!isNaN(this._lastGap) && buttonCount > 2)
					{
						newHeight -= this._gap;
						newHeight += this._lastGap;
					}
				}
				newHeight += this._paddingTop + this._paddingBottom;
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		protected function layoutButtons():void
		{
			const hasFirstGap:Boolean = !isNaN(this._firstGap);
			const hasLastGap:Boolean = !isNaN(this._lastGap);
			const buttonCount:int = this.activeButtons.length;
			const secondToLastIndex:int = buttonCount - 2;
			if(this._direction == DIRECTION_VERTICAL)
			{
				var maxButtonSize:Number = this.actualHeight - this._paddingTop - this._paddingBottom;
				var oppositeSize:Number = this.actualWidth - this._paddingLeft - this._paddingRight;
			}
			else
			{
				maxButtonSize = this.actualWidth - this._paddingLeft - this._paddingRight;
				oppositeSize = this.actualHeight - this._paddingTop - this._paddingBottom;
			}
			maxButtonSize -= (this._gap * (buttonCount - 1));
			if(hasFirstGap)
			{
				maxButtonSize += this._gap - this._firstGap;
			}
			if(hasLastGap)
			{
				maxButtonSize += this._gap - this._lastGap;
			}
			maxButtonSize /= buttonCount;

			var position:Number = this._direction == DIRECTION_VERTICAL ? this._paddingTop : this._paddingLeft;
			if((this._horizontalAlign == HORIZONTAL_ALIGN_JUSTIFY && this._direction == DIRECTION_HORIZONTAL) ||
				(this._verticalAlign == VERTICAL_ALIGN_JUSTIFY && this._direction == DIRECTION_VERTICAL))
			{
				var buttonSize:Number = maxButtonSize;
			}
			else
			{
				buttonSize = 0;
				for(var i:int = 0; i < buttonCount; i++)
				{
					var button:Button = this.activeButtons[i];
					button.validate();
					if(this._direction == DIRECTION_VERTICAL)
					{
						var currentButtonSize:Number = button.height;
						if(!isNaN(currentButtonSize) && currentButtonSize > buttonSize)
						{
							buttonSize = currentButtonSize;
						}
					}
					else //horizontal
					{
						currentButtonSize = button.width;
						if(!isNaN(currentButtonSize) && currentButtonSize > buttonSize)
						{
							buttonSize = currentButtonSize;
						}
					}
				}
				if(buttonSize > maxButtonSize)
				{
					buttonSize = maxButtonSize;
				}
				var totalContentSize:Number = (buttonSize + this._gap) * buttonCount - this._gap;
				if(hasFirstGap)
				{
					totalContentSize = totalContentSize - this._gap + this._firstGap;
				}
				if(hasLastGap)
				{
					totalContentSize = totalContentSize - this._gap + this._lastGap;
				}
				if(this._direction == DIRECTION_VERTICAL)
				{
					if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
					{
						position = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - totalContentSize) / 2;
					}
					else if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
					{
						position = this.actualHeight - this._paddingBottom - totalContentSize;
					}
				}
				else //horizontal
				{
					if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
					{
						position = this._paddingLeft + (this.actualWidth - this._paddingLeft - this._paddingRight - totalContentSize) / 2;
					}
					else if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
					{
						position = this.actualWidth - this._paddingRight - totalContentSize;
					}
				}
			}
			for(i = 0; i < buttonCount; i++)
			{
				button = this.activeButtons[i];
				if(this._direction == DIRECTION_VERTICAL)
				{
					button.height = buttonSize;
					button.y = position;
					button.validate();
					switch(this._horizontalAlign)
					{
						case HORIZONTAL_ALIGN_CENTER:
						{
							button.x = this._paddingLeft + (oppositeSize - button.width) / 2;
							break;
						}
						case HORIZONTAL_ALIGN_RIGHT:
						{
							button.x = this._paddingLeft + oppositeSize - button.width;
							break;
						}
						case HORIZONTAL_ALIGN_LEFT:
						{
							button.x = this._paddingLeft;
							break;
						}
						default: //justify
						{
							button.x = this._paddingLeft;
							button.width = oppositeSize;
							break;
						}
					}
					position += buttonSize;
				}
				else //horizontal
				{
					button.x = position;
					button.width = buttonSize;
					button.validate();
					switch(this._verticalAlign)
					{
						case VERTICAL_ALIGN_MIDDLE:
						{
							button.y = this._paddingTop + (oppositeSize - button.height) / 2;
							break;
						}
						case VERTICAL_ALIGN_BOTTOM:
						{
							button.y = this._paddingTop + oppositeSize - button.height;
							break;
						}
						case VERTICAL_ALIGN_TOP:
						{
							button.y = this._paddingTop;
							break;
						}
						default: //justify
						{
							button.y = this._paddingTop;
							button.height = oppositeSize;
							break;
						}
					}
					position += buttonSize;
				}

				if(hasFirstGap && i == 0)
				{
					position += this._firstGap;
				}
				else if(hasLastGap && i == secondToLastIndex)
				{
					position += this._lastGap;
				}
				else
				{
					position += this._gap;
				}
			}
		}

		/**
		 * @private
		 */
		protected function childProperties_onChange(proxy:PropertyProxy, name:String):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function dataProvider_changeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected function button_triggeredHandler(event:Event):void
		{
			var button:Button = Button(event.currentTarget);
			var index:int = this.activeButtons.indexOf(button);
			var item:Object = this._dataProvider.getItemAt(index);
			this.dispatchEventWith(Event.TRIGGERED, false, item);
		}
	}
}
