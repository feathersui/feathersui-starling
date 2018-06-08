/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.ITextBaselineControl;
	import feathers.core.PropertyProxy;
	import feathers.data.IListCollection;
	import feathers.events.CollectionEventType;
	import feathers.events.FeathersEventType;
	import feathers.layout.Direction;
	import feathers.layout.FlowLayout;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.ILayout;
	import feathers.layout.IVirtualLayout;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.VerticalAlign;
	import feathers.layout.VerticalLayout;
	import feathers.layout.ViewPortBounds;
	import feathers.skins.IStyleProvider;

	import flash.utils.Dictionary;

	import starling.display.DisplayObject;
	import starling.events.Event;

	/**
	 * A style name to add to all buttons in this button group. Typically
	 * used by a theme to provide different styles to different button groups.
	 *
	 * <p>The following example provides a custom button style name:</p>
	 *
	 * <listing version="3.0">
	 * group.customButtonStyleName = "my-custom-button";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( Button ).setFunctionForStyleName( "my-custom-button", setCustomButtonStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_BUTTON
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	[Style(name="customButtonStyleName",type="String")]

	/**
	 * A style name to add to the first button in this button group.
	 * Typically used by a theme to provide different styles to the first
	 * button.
	 *
	 * <p>The following example provides a custom first button style name:</p>
	 *
	 * <listing version="3.0">
	 * group.customFirstButtonStyleName = "my-custom-first-button";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( Button ).setFunctionForStyleName( "my-custom-first-button", setCustomFirstButtonStyles );</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	[Style(name="customFirstButtonStyleName",type="String")]

	/**
	 * A style name to add to the last button in this button group.
	 * Typically used by a theme to provide different styles to the last
	 * button.
	 *
	 * <p>The following example provides a custom last button style name:</p>
	 *
	 * <listing version="3.0">
	 * group.customLastButtonStyleName = "my-custom-last-button";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( Button ).setFunctionForStyleName( "my-custom-last-button", setCustomLastButtonStyles );</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	[Style(name="customLastButtonStyleName",type="String")]

	/**
	 * The button group layout is either vertical or horizontal.
	 *
	 * <p>If the <code>direction</code> is
	 * <code>Direction.HORIZONTAL</code> and
	 * <code>distributeButtonSizes</code> is <code>false</code>, the buttons
	 * may be displayed in multiple rows, if they won't fit in one row
	 * horizontally.</p>
	 *
	 * <p>The following example sets the layout direction of the buttons
	 * to line them up horizontally:</p>
	 *
	 * <listing version="3.0">
	 * group.direction = Direction.HORIZONTAL;</listing>
	 * 
	 * <p><strong>Note:</strong> The <code>Direction.NONE</code>
	 * constant is not supported.</p>
	 *
	 * @default feathers.layout.Direction.VERTICAL
	 *
	 * @see feathers.layout.Direction#HORIZONTAL
	 * @see feathers.layout.Direction#VERTICAL
	 */
	[Style(name="direction",type="String")]

	/**
	 * If <code>true</code>, the buttons will be equally sized in the
	 * direction of the layout. In other words, if the button group is
	 * horizontal, each button will have the same width, and if the button
	 * group is vertical, each button will have the same height. If
	 * <code>false</code>, the buttons will be sized to their ideal
	 * dimensions.
	 *
	 * <p>The following example doesn't distribute the button sizes:</p>
	 *
	 * <listing version="3.0">
	 * group.distributeButtonSizes = false;</listing>
	 *
	 * @default true
	 */
	[Style(name="distributeButtonSizes",type="Boolean")]

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
	 * @see #style:gap
	 * @see #style:lastGap
	 */
	[Style(name="firstGap",type="Number")]

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
	 * 
	 * @see #style:firstGap
	 * @see #style:lastGap
	 */
	[Style(name="gap",type="Number")]

	/**
	 * Determines how the buttons are horizontally aligned within the bounds
	 * of the button group (on the x-axis).
	 *
	 * <p>The following example aligns the group's content to the left:</p>
	 *
	 * <listing version="3.0">
	 * group.horizontalAlign = HorizontalAlign.LEFT;</listing>
	 *
	 * @default feathers.layout.HorizontalAlign.JUSTIFY
	 *
	 * @see feathers.layout.HorizontalAlign#LEFT
	 * @see feathers.layout.HorizontalAlign#CENTER
	 * @see feathers.layout.HorizontalAlign#RIGHT
	 * @see feathers.layout.HorizontalAlign#JUSTIFY
	 */
	[Style(name="horizontalAlign",type="String")]

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
	 * @see #style:gap
	 * @see #style:firstGap
	 */
	[Style(name="lastGap",type="Number")]

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
	 * @see #style:paddingTop
	 * @see #style:paddingRight
	 * @see #style:paddingBottom
	 * @see #style:paddingLeft
	 */
	[Style(name="padding",type="Number")]

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
	 * 
	 * @see #style:padding
	 */
	[Style(name="paddingTop",type="Number")]

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
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingRight",type="Number")]

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
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingBottom",type="Number")]

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
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingLeft",type="Number")]

	/**
	 * Determines how the buttons are vertically aligned within the bounds
	 * of the button group (on the y-axis).
	 *
	 * <p>The following example aligns the group's content to the top:</p>
	 *
	 * <listing version="3.0">
	 * group.verticalAlign = VerticalAlign.TOP;</listing>
	 *
	 * @default feathers.layout.VerticalAlign.JUSTIFY
	 *
	 * @see feathers.layout.VerticalAlign#TOP
	 * @see feathers.layout.VerticalAlign#MIDDLE
	 * @see feathers.layout.VerticalAlign#BOTTOM
	 * @see feathers.layout.VerticalAlign#JUSTIFY
	 */
	[Style(name="verticalAlign",type="String")]

	/**
	 * Dispatched when one of the buttons is triggered. The <code>data</code>
	 * property of the event contains the item from the data provider that is
	 * associated with the button that was triggered.
	 *
	 * <p>The following example listens to <code>Event.TRIGGERED</code> on the
	 * button group instead of on individual buttons:</p>
	 *
	 * <listing version="3.0">
	 * group.dataProvider = new ArrayCollection(
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
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The item associated with the button
	 *   that was triggered.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.TRIGGERED
	 */
	[Event(name="triggered", type="starling.events.Event")]

	/**
	 * A set of related buttons with layout, customized using a data provider.
	 *
	 * <p>The following example creates a button group with a few buttons:</p>
	 *
	 * <listing version="3.0">
	 * var group:ButtonGroup = new ButtonGroup();
	 * group.dataProvider = new ArrayCollection(
	 * [
	 *     { label: "Yes", triggered: yesButton_triggeredHandler },
	 *     { label: "No", triggered: noButton_triggeredHandler },
	 *     { label: "Cancel", triggered: cancelButton_triggeredHandler },
	 * ]);
	 * this.addChild( group );</listing>
	 *
	 * @see ../../../help/button-group.html How to use the Feathers ButtonGroup component
	 * @see feathers.controls.TabBar
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class ButtonGroup extends FeathersControl implements ITextBaselineControl
	{
		/**
		 * The default <code>IStyleProvider</code> for all <code>ButtonGroup</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_BUTTON_FACTORY:String = "buttonFactory";

		/**
		 * @private
		 */
		protected static const LABEL_FIELD:String = "label";

		/**
		 * @private
		 */
		protected static const ENABLED_FIELD:String = "isEnabled";

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
			"isLongPressEnabled",
			"name",
		];

		/**
		 * @private
		 */
		private static const DEFAULT_BUTTON_EVENTS:Vector.<String> = new <String>
		[
			Event.TRIGGERED,
			Event.CHANGE,
			FeathersEventType.LONG_PRESS,
		];

		/**
		 * The default value added to the <code>styleNameList</code> of the buttons.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_BUTTON:String = "feathers-button-group-button";

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
			super();
		}

		/**
		 * The value added to the <code>styleNameList</code> of the buttons.
		 * This variable is <code>protected</code> so that sub-classes can
		 * customize the button style name in their constructors instead of
		 * using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_BUTTON</code>.
		 *
		 * <p>To customize the button style name without subclassing, see
		 * <code>customButtonStyleName</code>.</p>
		 *
		 * @see #style:customButtonStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var buttonStyleName:String = DEFAULT_CHILD_STYLE_NAME_BUTTON;

		/**
		 * The value added to the <code>styleNameList</code> of the first button.
		 *
		 * <p>To customize the first button name without subclassing, see
		 * <code>customFirstButtonStyleName</code>.</p>
		 *
		 * @see #style:customFirstButtonStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var firstButtonStyleName:String = DEFAULT_CHILD_STYLE_NAME_BUTTON;

		/**
		 * The value added to the <code>styleNameList</code> of the last button.
		 *
		 * <p>To customize the last button style name without subclassing, see
		 * <code>customLastButtonStyleName</code>.</p>
		 *
		 * @see #style:customLastButtonStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var lastButtonStyleName:String = DEFAULT_CHILD_STYLE_NAME_BUTTON;

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
		protected var _layoutItems:Vector.<DisplayObject> = new <DisplayObject>[];

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
		protected var _buttonToItem:Dictionary = new Dictionary(true);

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return ButtonGroup.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _dataProvider:IListCollection;

		/**
		 * The collection of data to be displayed with buttons.
		 *
		 * <p>The following example sets the button group's data provider:</p>
		 *
		 * <listing version="3.0">
		 * group.dataProvider = new ArrayCollection(
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
		 *     <li>isSelected (only supported by <code>ToggleButton</code>)</li>
		 *     <li>isToggle (only supported by <code>ToggleButton</code>)</li>
		 *     <li>isEnabled</li>
		 *     <li>name</li>
		 * </ul>
		 *
		 * <p>Additionally, you can add the following event listeners:</p>
		 *
		 * <ul>
		 *     <li>Event.TRIGGERED</li>
		 *     <li>Event.CHANGE (only supported by <code>ToggleButton</code>)</li>
		 * </ul>
		 * 
		 * <p>Event listeners may have one of the following signatures:</p>
		 * <pre>function(event:Event):void</pre>
		 * <pre>function(event:Event, eventData:Object):void</pre>
		 * <pre>function(event:Event, eventData:Object, dataProviderItem:Object):void</pre>
		 *
		 * <p>To use properties and events that are only supported by
		 * <code>ToggleButton</code>, you must provide a <code>buttonFactory</code>
		 * that returns a <code>ToggleButton</code> instead of a <code>Button</code>.</p>
		 *
		 * <p>You can pass a function to the <code>buttonInitializer</code>
		 * property that can provide custom logic to interpret each item in the
		 * data provider differently. For example, you could use it to support
		 * additional properties or events.</p>
		 *
		 * @default null
		 *
		 * @see feathers.controls.Button
		 * @see #buttonInitializer
		 * @see feathers.data.ArrayCollection
		 * @see feathers.data.VectorCollection
		 * @see feathers.data.XMLListCollection
		 */
		public function get dataProvider():IListCollection
		{
			return this._dataProvider;
		}

		/**
		 * @private
		 */
		public function set dataProvider(value:IListCollection):void
		{
			if(this._dataProvider == value)
			{
				return;
			}
			if(this._dataProvider)
			{
				this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ALL, dataProvider_updateAllHandler);
				this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ITEM, dataProvider_updateItemHandler);
				this._dataProvider.removeEventListener(Event.CHANGE, dataProvider_changeHandler);
			}
			this._dataProvider = value;
			if(this._dataProvider)
			{
				this._dataProvider.addEventListener(CollectionEventType.UPDATE_ALL, dataProvider_updateAllHandler);
				this._dataProvider.addEventListener(CollectionEventType.UPDATE_ITEM, dataProvider_updateItemHandler);
				this._dataProvider.addEventListener(Event.CHANGE, dataProvider_changeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var layout:ILayout;

		/**
		 * @private
		 */
		protected var _viewPortBounds:ViewPortBounds = new ViewPortBounds();

		/**
		 * @private
		 */
		protected var _layoutResult:LayoutBoundsResult = new LayoutBoundsResult();

		/**
		 * @private
		 */
		protected var _direction:String = Direction.VERTICAL;

		[Inspectable(type="String",enumeration="horizontal,vertical")]
		/**
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._direction === value)
			{
				return;
			}
			this._direction = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _horizontalAlign:String = HorizontalAlign.JUSTIFY;

		[Inspectable(type="String",enumeration="left,center,right,justify")]
		/**
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._horizontalAlign === value)
			{
				return;
			}
			this._horizontalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _verticalAlign:String = VerticalAlign.JUSTIFY;

		[Inspectable(type="String",enumeration="top,middle,bottom,justify")]
		/**
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._verticalAlign === value)
			{
				return;
			}
			this._verticalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _distributeButtonSizes:Boolean = true;

		/**
		 * @private
		 */
		public function get distributeButtonSizes():Boolean
		{
			return this._distributeButtonSizes;
		}

		/**
		 * @private
		 */
		public function set distributeButtonSizes(value:Boolean):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._distributeButtonSizes === value)
			{
				return;
			}
			this._distributeButtonSizes = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _gap:Number = 0;

		/**
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._lastGap == value)
			{
				return;
			}
			this._lastGap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
		 * Creates each button in the group. A button must be an instance of
		 * <code>Button</code>. This factory can be used to change properties on
		 * the buttons when they are first created. For instance, if you are
		 * skinning Feathers components without a theme, you might use this
		 * factory to set skins and other styles on a button.
		 *
		 * <p>Optionally, the first button and the last button may be different
		 * than the other buttons that are in the middle. Use the
		 * <code>firstButtonFactory</code> and/or the
		 * <code>lastButtonFactory</code> to customize one or both of these
		 * buttons.</p>
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
		 * If not <code>null</code>, creates the first button. If the
		 * <code>firstButtonFactory</code> is <code>null</code>, then the button
		 * group will use the <code>buttonFactory</code>. The first button must
		 * be an instance of <code>Button</code>. This factory can be used to
		 * change properties on the first button when it is initially created.
		 * For instance, if you are skinning Feathers components without a
		 * theme, you might use this factory to set skins and other styles on
		 * the first button.
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
		 * If not <code>null</code>, creates the last button. If the
		 * <code>lastButtonFactory</code> is <code>null</code>, then the button
		 * group will use the <code>buttonFactory</code>. The last button must
		 * be an instance of <code>Button</code>. This factory can be used to
		 * change properties on the last button when it is initially created.
		 * For instance, if you are skinning Feathers components without a
		 * theme, you might use this factory to set skins and other styles on
		 * the last button.
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
			this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _buttonReleaser:Function = defaultButtonReleaser;

		/**
		 * Resets the properties of an individual button, using the item from the
		 * data provider that was associated with the button.
		 *
		 * <p>This function is expected to have one of the following signatures:</p>
		 * <pre>function( tab:Button ):void</pre>
		 * <pre>function( tab:Button, oldItem:Object ):void</pre>
		 *
		 * <p>In the following example, a custom button releaser is passed to the
		 * button group:</p>
		 *
		 * <listing version="3.0">
		 * group.buttonReleaser = function( button:Button, oldItem:Object ):void
		 * {
		 *     button.label = null;
		 * };</listing>
		 *
		 * @see #buttonInitializer
		 */
		public function get buttonReleaser():Function
		{
			return this._buttonReleaser;
		}

		/**
		 * @private
		 */
		public function set buttonReleaser(value:Function):void
		{
			if(this._buttonReleaser == value)
			{
				return;
			}
			this._buttonReleaser = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _customButtonStyleName:String;

		/**
		 * @private
		 */
		public function get customButtonStyleName():String
		{
			return this._customButtonStyleName;
		}

		/**
		 * @private
		 */
		public function set customButtonStyleName(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customButtonStyleName === value)
			{
				return;
			}
			this._customButtonStyleName = value;
			this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customFirstButtonStyleName:String;

		/**
		 * @private
		 */
		public function get customFirstButtonStyleName():String
		{
			return this._customFirstButtonStyleName;
		}

		/**
		 * @private
		 */
		public function set customFirstButtonStyleName(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customFirstButtonStyleName === value)
			{
				return;
			}
			this._customFirstButtonStyleName = value;
			this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customLastButtonStyleName:String;

		/**
		 * @private
		 */
		public function get customLastButtonStyleName():String
		{
			return this._customLastButtonStyleName;
		}

		/**
		 * @private
		 */
		public function set customLastButtonStyleName(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customLastButtonStyleName === value)
			{
				return;
			}
			this._customLastButtonStyleName = value;
			this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _buttonProperties:PropertyProxy;

		/**
		 * An object that stores properties for all of the button group's
		 * buttons, and the properties will be passed down to every button when
		 * the button group validates. For a list of available properties,
		 * refer to <a href="Button.html"><code>feathers.controls.Button</code></a>.
		 * 
		 * <p>These properties are shared by every button, so anything that cannot
		 * be shared (such as display objects, which cannot be added to multiple
		 * parents) should be passed to buttons using the
		 * <code>buttonFactory</code> or in the theme.</p>
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>The following example sets some properties on all of the buttons:</p>
		 *
		 * <listing version="3.0">
		 * group.buttonProperties.horizontalAlign = HorizontalAlign.LEFT;
		 * group.buttonProperties.verticalAlign = VerticalAlign.TOP;</listing>
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
				var newValue:PropertyProxy = new PropertyProxy();
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
		 * @inheritDoc
		 */
		public function get baseline():Number
		{
			if(!this.activeButtons || this.activeButtons.length == 0)
			{
				return this.scaledActualHeight;
			}
			var firstButton:Button = this.activeButtons[0];
			return this.scaleY * (firstButton.y + firstButton.baseline);
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
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var buttonFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_BUTTON_FACTORY);
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

			if(stylesInvalid)
			{
				this.refreshLayoutStyles();
			}

			this.layoutButtons();
		}

		/**
		 * @private
		 */
		protected function commitEnabled():void
		{
			var buttonCount:int = this.activeButtons.length;
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
			for(var propertyName:String in this._buttonProperties)
			{
				var propertyValue:Object = this._buttonProperties[propertyName];
				for each(var button:Button in this.activeButtons)
				{
					button[propertyName] = propertyValue;
				}
			}
		}

		/**
		 * @private
		 */
		protected function refreshLayoutStyles():void
		{
			if(this._direction == Direction.VERTICAL)
			{
				var verticalLayout:VerticalLayout = this.layout as VerticalLayout;
				if(!verticalLayout)
				{
					this.layout = verticalLayout = new VerticalLayout();
				}
				verticalLayout.distributeHeights = this._distributeButtonSizes;
				verticalLayout.horizontalAlign = this._horizontalAlign;
				verticalLayout.verticalAlign = (this._verticalAlign == VerticalAlign.JUSTIFY) ? VerticalAlign.TOP : this._verticalAlign;
				verticalLayout.gap = this._gap;
				verticalLayout.firstGap = this._firstGap;
				verticalLayout.lastGap = this._lastGap;
				verticalLayout.paddingTop = this._paddingTop;
				verticalLayout.paddingRight = this._paddingRight;
				verticalLayout.paddingBottom = this._paddingBottom;
				verticalLayout.paddingLeft = this._paddingLeft;
			}
			else //horizontal
			{
				if(this._distributeButtonSizes)
				{
					var horizontalLayout:HorizontalLayout = this.layout as HorizontalLayout;
					if(!horizontalLayout)
					{
						this.layout = horizontalLayout = new HorizontalLayout();
					}
					horizontalLayout.distributeWidths = true;
					horizontalLayout.horizontalAlign = (this._horizontalAlign == HorizontalAlign.JUSTIFY) ? HorizontalAlign.LEFT : this._horizontalAlign;
					horizontalLayout.verticalAlign = this._verticalAlign;
					horizontalLayout.gap = this._gap;
					horizontalLayout.firstGap = this._firstGap;
					horizontalLayout.lastGap = this._lastGap;
					horizontalLayout.paddingTop = this._paddingTop;
					horizontalLayout.paddingRight = this._paddingRight;
					horizontalLayout.paddingBottom = this._paddingBottom;
					horizontalLayout.paddingLeft = this._paddingLeft;
				}
				else
				{
					var flowLayout:FlowLayout = this.layout as FlowLayout;
					if(!flowLayout)
					{
						this.layout = flowLayout = new FlowLayout();
					}
					flowLayout.horizontalAlign = (this._horizontalAlign == HorizontalAlign.JUSTIFY) ? HorizontalAlign.LEFT : this._horizontalAlign;
					flowLayout.verticalAlign = this._verticalAlign;
					flowLayout.gap = this._gap;
					flowLayout.firstHorizontalGap = this._firstGap;
					flowLayout.lastHorizontalGap = this._lastGap;
					flowLayout.paddingTop = this._paddingTop;
					flowLayout.paddingRight = this._paddingRight;
					flowLayout.paddingBottom = this._paddingBottom;
					flowLayout.paddingLeft = this._paddingLeft;
				}
			}
			if(layout is IVirtualLayout)
			{
				IVirtualLayout(layout).useVirtualLayout = false;
			}
		}

		/**
		 * @private
		 */
		protected function defaultButtonInitializer(button:Button, item:Object):void
		{
			if(item is Object)
			{
				if(item.hasOwnProperty(LABEL_FIELD))
				{
					button.label = item.label as String;
				}
				else
				{
					button.label = item.toString();
				}
				if(item.hasOwnProperty(ENABLED_FIELD))
				{
					button.isEnabled = item.isEnabled as Boolean;
				}
				else
				{
					button.isEnabled = this._isEnabled;
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
					var removeListener:Boolean = true;
					if(item.hasOwnProperty(field))
					{
						var listener:Function = item[field] as Function;
						if(listener === null)
						{
							continue;
						}
						removeListener = false;
						//we can't add the listener directly because we don't
						//know how to remove it later if the data provider
						//changes and we lose the old item. we'll use another
						//event listener that we control as a delegate, and
						//we'll be able to remove it later.
						button.addEventListener(field, defaultButtonEventsListener);
					}
					if(removeListener)
					{
						button.removeEventListener(field, defaultButtonEventsListener);
					}
				}
			}
			else
			{
				button.label = "";
				button.isEnabled = this._isEnabled;
			}
		}

		/**
		 * @private
		 */
		protected function defaultButtonReleaser(button:Button, oldItem:Object):void
		{
			button.label = null;
			for each(var field:String in DEFAULT_BUTTON_FIELDS)
			{
				if(oldItem.hasOwnProperty(field))
				{
					button[field] = null;
				}
			}
			for each(field in DEFAULT_BUTTON_EVENTS)
			{
				var removeListener:Boolean = true;
				if(oldItem.hasOwnProperty(field))
				{
					var listener:Function = oldItem[field] as Function;
					if(listener === null)
					{
						continue;
					}
					button.removeEventListener(field, defaultButtonEventsListener);
				}
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
			this._layoutItems.length = 0;
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

			var pushIndex:int = 0;
			var itemCount:int = this._dataProvider ? this._dataProvider.length : 0;
			var lastItemIndex:int = itemCount - 1;
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
				this.activeButtons[pushIndex] = button;
				this._layoutItems[pushIndex] = button;
				pushIndex++;
			}
			this.clearInactiveButtons();
		}

		/**
		 * @private
		 */
		protected function clearInactiveButtons():void
		{
			var itemCount:int = this.inactiveButtons.length;
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
			var isNewInstance:Boolean = false;
			if(this.inactiveFirstButton !== null)
			{
				var button:Button = this.inactiveFirstButton;
				this.releaseButton(button);
				this.inactiveFirstButton = null;
			}
			else
			{
				isNewInstance = true;
				var factory:Function = this._firstButtonFactory != null ? this._firstButtonFactory : this._buttonFactory;
				button = Button(factory());
				if(this._customFirstButtonStyleName)
				{
					button.styleNameList.add(this._customFirstButtonStyleName);
				}
				else if(this._customButtonStyleName)
				{
					button.styleNameList.add(this._customButtonStyleName);
				}
				else
				{
					button.styleNameList.add(this.firstButtonStyleName);
				}
				this.addChild(button);
			}
			this._buttonInitializer(button, item);
			this._buttonToItem[button] = item;
			if(isNewInstance)
			{
				//we need to listen for Event.TRIGGERED after the initializer
				//is called to avoid runtime errors because the button may be
				//disposed by the time listeners in the initializer are called.
				button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			}
			return button;
		}

		/**
		 * @private
		 */
		protected function createLastButton(item:Object):Button
		{
			var isNewInstance:Boolean = false;
			if(this.inactiveLastButton !== null)
			{
				var button:Button = this.inactiveLastButton;
				this.releaseButton(button);
				this.inactiveLastButton = null;
			}
			else
			{
				isNewInstance = true;
				var factory:Function = this._lastButtonFactory != null ? this._lastButtonFactory : this._buttonFactory;
				button = Button(factory());
				if(this._customLastButtonStyleName)
				{
					button.styleNameList.add(this._customLastButtonStyleName);
				}
				else if(this._customButtonStyleName)
				{
					button.styleNameList.add(this._customButtonStyleName);
				}
				else
				{
					button.styleNameList.add(this.lastButtonStyleName);
				}
				this.addChild(button);
			}
			this._buttonInitializer(button, item);
			this._buttonToItem[button] = item;
			if(isNewInstance)
			{
				//we need to listen for Event.TRIGGERED after the initializer
				//is called to avoid runtime errors because the button may be
				//disposed by the time listeners in the initializer are called.
				button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			}
			return button;
		}

		/**
		 * @private
		 */
		protected function createButton(item:Object):Button
		{
			var isNewInstance:Boolean = false;
			if(this.inactiveButtons.length == 0)
			{
				isNewInstance = true;
				var button:Button = this._buttonFactory();
				if(this._customButtonStyleName)
				{
					button.styleNameList.add(this._customButtonStyleName);
				}
				else
				{
					button.styleNameList.add(this.buttonStyleName);
				}
				this.addChild(button);
			}
			else
			{
				button = this.inactiveButtons.shift();
				this.releaseButton(button);
			}
			this._buttonInitializer(button, item);
			this._buttonToItem[button] = item;
			if(isNewInstance)
			{
				//we need to listen for Event.TRIGGERED after the initializer
				//is called to avoid runtime errors because the button may be
				//disposed by the time listeners in the initializer are called.
				button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			}
			return button;
		}

		/**
		 * @private
		 */
		protected function releaseButton(button:Button):void
		{
			var item:Object = this._buttonToItem[button];
			delete this._buttonToItem[button];
			if(this._buttonReleaser.length == 1)
			{
				this._buttonReleaser(button);
			}
			else
			{
				this._buttonReleaser(button, item);
			}
		}

		/**
		 * @private
		 */
		protected function destroyButton(button:Button):void
		{
			button.removeEventListener(Event.TRIGGERED, button_triggeredHandler);
			this.releaseButton(button);
			this.removeChild(button, true);
		}

		/**
		 * @private
		 */
		protected function layoutButtons():void
		{
			this._viewPortBounds.x = 0;
			this._viewPortBounds.y = 0;
			this._viewPortBounds.scrollX = 0;
			this._viewPortBounds.scrollY = 0;
			this._viewPortBounds.explicitWidth = this._explicitWidth;
			this._viewPortBounds.explicitHeight = this._explicitHeight;
			this._viewPortBounds.minWidth = this._explicitMinWidth;
			this._viewPortBounds.minHeight = this._explicitMinHeight;
			this._viewPortBounds.maxWidth = this._explicitMaxWidth;
			this._viewPortBounds.maxHeight = this._explicitMaxHeight;
			this.layout.layout(this._layoutItems, this._viewPortBounds, this._layoutResult);
			
			var contentWidth:Number = this._layoutResult.contentWidth;
			var contentHeight:Number = this._layoutResult.contentHeight;
			//minimum dimensions are the same as the measured dimensions
			this.saveMeasurements(contentWidth, contentHeight, contentWidth, contentHeight);
			
			//final validation to avoid juggler next frame issues
			for each(var button:Button in this.activeButtons)
			{
				button.validate();
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
		protected function dataProvider_updateAllHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected function dataProvider_updateItemHandler(event:Event, index:int):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected function button_triggeredHandler(event:Event):void
		{
			//if this was called after dispose, ignore it
			if(!this._dataProvider || !this.activeButtons)
			{
				return;
			}
			var button:Button = Button(event.currentTarget);
			var index:int = this.activeButtons.indexOf(button);
			var item:Object = this._dataProvider.getItemAt(index);
			this.dispatchEventWith(Event.TRIGGERED, false, item);
		}

		/**
		 * @private
		 */
		protected function defaultButtonEventsListener(event:Event):void
		{
			var button:Button = Button(event.currentTarget);
			var index:int = this.activeButtons.indexOf(button);
			var item:Object = this._dataProvider.getItemAt(index);
			var field:String = event.type;
			if(item.hasOwnProperty(field))
			{
				var listener:Function = item[field] as Function;
				if(listener == null)
				{
					return;
				}
				var argCount:int = listener.length;
				switch(argCount)
				{
					case 3:
					{
						listener(event, event.data, item);
						break;
					}
					case 2:
					{
						listener(event, event.data);
						break;
					}
					case 1:
					{
						listener(event);
						break;
					}
					default:
					{
						listener();
					}
				}
			}
		}
	}
}
