/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.IMeasureDisplayObject;
	import feathers.core.IValidating;
	import feathers.data.IListCollection;
	import feathers.data.VectorCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalAlign;
	import feathers.skins.IStyleProvider;
	import feathers.utils.math.roundDownToNearest;
	import feathers.utils.math.roundUpToNearest;
	import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;

	import flash.globalization.DateTimeFormatter;
	import flash.globalization.DateTimeNameStyle;
	import flash.globalization.DateTimeStyle;
	import flash.globalization.LocaleID;

	import starling.display.DisplayObject;
	import starling.events.Event;

	/**
	 * The background to display behind all content when the date time spinner
	 * is disabled. The background skin is resized to fill the full width and
	 * height of the date time spinner, and the lists are centered.
	 *
	 * <p>In the following example, the spinner is given a background skin:</p>
	 *
	 * <listing version="3.0">
	 * spinner.backgroundDisabledSkin = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #style:backgroundSkin
	 */
	[Style(name="backgroundDisabledSkin",type="starling.display.DisplayObject")]

	/**
	 * The default background to display behind all content. The background
	 * skin is resized to fill the full width and height of the date time
	 * spinner, and the lists are centered.
	 *
	 * <p>In the following example, the spinner is given a background skin:</p>
	 *
	 * <listing version="3.0">
	 * spinner.backgroundSkin = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #style:backgroundDisabledSkin
	 */
	[Style(name="backgroundSkin",type="starling.display.DisplayObject")]

	/**
	 * A style name to add to the date time spinner's item renderer
	 * sub-components. Typically used by a theme to provide different styles to
	 * different date time spinners.
	 *
	 * <p>In the following example, a custom item renderer style name is passed
	 * to the date time spinner:</p>
	 *
	 * <listing version="3.0">
	 * spinner.customItemRendererStyleName = "my-custom-date-time-spinner-item-renderer";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( DefaultListItemRenderer ).setFunctionForStyleName( "my-custom-date-time-spinner-item-renderer", setCustomDateTimeSpinnerItemRendererStyles );</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #itemRendererFactory
	 */
	[Style(name="customItemRendererStyleName",type="String")]

	/**
	 * A style name to add to the date time spinner's list sub-components.
	 * Typically used by a theme to provide different styles to different
	 * date time spinners.
	 *
	 * <p>In the following example, a custom list style name is passed to
	 * the date time spinner:</p>
	 *
	 * <listing version="3.0">
	 * spinner.customListStyleName = "my-custom-spinner-list";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( SpinnerList ).setFunctionForStyleName( "my-custom-spinner-list", setCustomSpinnerListStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_LIST
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #listFactory
	 */
	[Style(name="customListStyleName",type="String")]

	/**
	 * Quickly sets all padding properties to the same value. The
	 * <code>padding</code> getter always returns the value of
	 * <code>paddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * <p>In the following example, the padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * spinner.padding = 20;</listing>
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
	 * The minimum space, in pixels, between the date time spinner's top edge and
	 * the its content.
	 *
	 * <p>In the following example, the top padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * spinner.paddingTop = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingTop",type="Number")]

	/**
	 * The minimum space, in pixels, between the date time spinner's right edge
	 * and the its content.
	 *
	 * <p>In the following example, the right padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * spinner.paddingRight = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingRight",type="Number")]

	/**
	 * The minimum space, in pixels, between the date time spinner's bottom edge
	 * and the its content.
	 *
	 * <p>In the following example, the bottom padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * spinner.paddingBottom = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingBottom",type="Number")]

	/**
	 * The minimum space, in pixels, between the date time spinner's left edge
	 * and the its content.
	 *
	 * <p>In the following example, the left padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * spinner.paddingLeft = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingLeft",type="Number")]

	/**
	 * The duration, in seconds, of the animation when the
	 * <code>scrollToDate()</code> function is called, or when an invalid
	 * date is selected.
	 *
	 * <p>In the following example, the duration of the animation that
	 * changes the page when thrown is set to 250 milliseconds:</p>
	 *
	 * <listing version="3.0">
	 * spinner.scrollDuration = 0.25;</listing>
	 *
	 * @default 0.5
	 *
	 * @see #scrollToDate()
	 */
	[Style(name="scrollDuration",type="Number")]

	/**
	 * Dispatched when the spinner's value changes.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>null</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 * 
	 * @see #value
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * A set of <code>SpinnerList</code> components that allow you to select the
	 * date, the time, or the date and time.
	 *
	 * <p>The following example sets the date spinner's range and listens for
	 * when the value changes:</p>
	 *
	 * <listing version="3.0">
	 * var spinner:DateTimeSpinner = new DateTimeSpinner();
	 * spinner.editingMode = DateTimeMode.DATE;
	 * spinner.minimum = new Date(1970, 0, 1);
	 * spinner.maximum = new Date(2050, 11, 31);
	 * spinner.value = new Date();
	 * spinner.addEventListener( Event.CHANGE, spinner_changeHandler );
	 * this.addChild( spinner );</listing>
	 *
	 * @see ../../../help/date-time-spinner.html How to use the Feathers DateTimeSpinner component
	 *
	 * @productversion Feathers 2.3.0
	 */
	public class DateTimeSpinner extends FeathersControl
	{
		/**
		 * The default name to use with lists.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_LIST:String = "feathers-date-time-spinner-list";

		[Deprecated(replacement="feathers.controls.DateTimeMode.DATE_AND_TIME",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.DateTimeMode.DATE_AND_TIME</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const EDITING_MODE_DATE_AND_TIME:String = "dateAndTime";

		[Deprecated(replacement="feathers.controls.DateTimeMode.TIME",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.DateTimeMode.TIME</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const EDITING_MODE_TIME:String = "time";

		[Deprecated(replacement="feathers.controls.DateTimeMode.DATE",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.DateTimeMode.DATE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const EDITING_MODE_DATE:String = "date";

		/**
		 * @private
		 */
		private static const MS_PER_DAY:int = 86400000;

		/**
		 * @private
		 */
		private static const MIN_MONTH_VALUE:int = 0;

		/**
		 * @private
		 */
		private static const MAX_MONTH_VALUE:int = 11;

		/**
		 * @private
		 */
		private static const MIN_DATE_VALUE:int = 1;

		/**
		 * @private
		 */
		private static const MAX_DATE_VALUE:int = 31;

		/**
		 * @private
		 */
		private static const MIN_HOURS_VALUE:int = 0;

		/**
		 * @private
		 */
		private static const MAX_HOURS_VALUE_12HOURS:int = 11;

		/**
		 * @private
		 */
		private static const MAX_HOURS_VALUE_24HOURS:int = 23;

		/**
		 * @private
		 */
		private static const MIN_MINUTES_VALUE:int = 0;

		/**
		 * @private
		 */
		private static const MAX_MINUTES_VALUE:int = 59;

		/**
		 * @private
		 */
		private static const HELPER_DATE:Date = new Date();

		/**
		 * @private
		 */
		private static const DAYS_IN_MONTH:Vector.<int> = new <int>[];

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_LOCALE:String = "locale";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_EDITING_MODE:String = "editingMode";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_PENDING_SCROLL:String = "pendingScroll";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_SPINNER_LIST_FACTORY:String = "spinnerListFactory";

		/**
		 * The default <code>IStyleProvider</code> for all <code>DateTimeSpinner</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * @private
		 */
		protected static function defaultListFactory():SpinnerList
		{
			return new SpinnerList();
		}

		/**
		 * Constructor.
		 */
		public function DateTimeSpinner()
		{
			super();
			if(DAYS_IN_MONTH.length === 0)
			{
				HELPER_DATE.setFullYear(2015); //this is pretty arbitrary
				for(var i:int = MIN_MONTH_VALUE; i <= MAX_MONTH_VALUE; i++)
				{
					//subtract one date from the 1st of next month to figure out
					//the last date of the current month
					HELPER_DATE.setMonth(i + 1, -1);
					DAYS_IN_MONTH[i] = HELPER_DATE.date + 1;
				}
				DAYS_IN_MONTH.fixed = true;
			}
		}

		/**
		 * The value added to the <code>styleNameList</code> of the lists. This
		 * variable is <code>protected</code> so that sub-classes can customize
		 * the list style name in their constructors instead of using the
		 * default style name defined by <code>DEFAULT_CHILD_STYLE_NAME_LIST</code>.
		 *
		 * <p>To customize the list style name without subclassing, see
		 * <code>customListStyleName</code>.</p>
		 *
		 * @see #style:customListStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var listStyleName:String = DEFAULT_CHILD_STYLE_NAME_LIST;

		/**
		 * @private
		 */
		protected var monthsList:SpinnerList;

		/**
		 * @private
		 */
		protected var datesList:SpinnerList;

		/**
		 * @private
		 */
		protected var yearsList:SpinnerList;

		/**
		 * @private
		 */
		protected var dateAndTimeDatesList:SpinnerList;

		/**
		 * @private
		 */
		protected var hoursList:SpinnerList;

		/**
		 * @private
		 */
		protected var minutesList:SpinnerList;

		/**
		 * @private
		 */
		protected var meridiemList:SpinnerList;
		
		/**
		 * @private
		 */
		protected var listGroup:LayoutGroup;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return DateTimeSpinner.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _locale:String = LocaleID.DEFAULT;

		/**
		 * The locale used to display the date. Supports values defined by
		 * Unicode Technical Standard #35, such as <code>"en_US"</code>,
		 * <code>"fr_FR"</code> or <code>"ru_RU"</code>.
		 * 
		 * @default flash.globalization.LocaleID.DEFAULT
		 * 
		 * @see http://unicode.org/reports/tr35/ Unicode Technical Standard #35
		 */
		public function get locale():String
		{
			return this._locale;
		}

		/**
		 * @private
		 */
		public function set locale(value:String):void
		{
			if(this._locale == value)
			{
				return;
			}
			this._locale = value;
			this._formatter = null;
			this.invalidate(INVALIDATION_FLAG_LOCALE);
		}

		/**
		 * @private
		 */
		protected var _value:Date;

		/**
		 * The value of the date time spinner, between the minimum and maximum.
		 *
		 * <p>In the following example, the value is changed to a date:</p>
		 *
		 * <listing version="3.0">
		 * stepper.minimum = new Date(1970, 0, 1);
		 * stepper.maximum = new Date(2050, 11, 31);
		 * stepper.value = new Date(1995, 2, 7);</listing>
		 *
		 * @default 0
		 *
		 * @see #minimum
		 * @see #maximum
		 * @see #event:change
		 */
		public function get value():Date
		{
			return this._value;
		}

		/**
		 * @private
		 */
		public function set value(value:Date):void
		{
			var time:Number = value.time;
			if(this._minimum && this._minimum.time > time)
			{
				time = this._minimum.time;
			}
			if(this._maximum && this._maximum.time < time)
			{
				time = this._maximum.time;
			}
			if(this._value && this._value.time === time)
			{
				return;
			}
			this._value = new Date(time);
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _minimum:Date;

		/**
		 * The date time spinner's value will not go lower than the minimum.
		 *
		 * <p>In the following example, the minimum is changed:</p>
		 *
		 * <listing version="3.0">
		 * spinner.minimum = new Date(1970, 0, 1);</listing>
		 *
		 * @see #value
		 * @see #maximum
		 */
		public function get minimum():Date
		{
			return this._minimum;
		}

		/**
		 * @private
		 */
		public function set minimum(value:Date):void
		{
			if(this._minimum == value)
			{
				return;
			}
			this._minimum = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _maximum:Date;

		/**
		 * The date time spinner's value will not go higher than the maximum.
		 *
		 * <p>In the following example, the maximum is changed:</p>
		 *
		 * <listing version="3.0">
		 * spinner.maximum = new Date(2050, 11, 31);</listing>
		 *
		 * @see #value
		 * @see #minimum
		 */
		public function get maximum():Date
		{
			return this._maximum;
		}

		/**
		 * @private
		 */
		public function set maximum(value:Date):void
		{
			if(this._maximum == value)
			{
				return;
			}
			this._maximum = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _minuteStep:int = 1;

		/**
		 * In the list that allows selection of minutes, customizes the number
		 * of minutes between each item. For instance, one might choose 15 or
		 * 30 minute increments.
		 *
		 * <p>In the following example, the spinner uses 15 minute increments:</p>
		 *
		 * <listing version="3.0">
		 * spinner.minuteStep = 15;</listing>
		 * 
		 * @default 1
		 */
		public function get minuteStep():int
		{
			return this._minuteStep;
		}

		/**
		 * @private
		 */
		public function set minuteStep(value:int):void
		{
			if(60 % value !== 0)
			{
				throw new ArgumentError("minuteStep must evenly divide into 60.");
			}
			if(this._minuteStep == value)
			{
				return;
			}
			this._minuteStep = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _editingMode:String = DateTimeMode.DATE_AND_TIME;

		/**
		 * Determines which parts of the <code>Date</code> value may be edited.
		 * 
		 * @default feathers.controls.DateTimeMode.DATE_AND_TIME
		 * 
		 * @see feathers.controls.DateTimeMode#DATE_AND_TIME
		 * @see feathers.controls.DateTimeMode#DATE
		 * @see feathers.controls.DateTimeMode#TIME
		 */
		public function get editingMode():String
		{
			return this._editingMode;
		}

		/**
		 * @private
		 */
		public function set editingMode(value:String):void
		{
			if(this._editingMode == value)
			{
				return;
			}
			this._editingMode = value;
			this.invalidate(INVALIDATION_FLAG_EDITING_MODE);
		}

		/**
		 * @private
		 */
		protected var _formatter:DateTimeFormatter;

		/**
		 * @private
		 */
		protected var _longestMonthNameIndex:int;

		/**
		 * @private
		 */
		protected var _localeMonthNames:Vector.<String>;

		/**
		 * @private
		 */
		protected var _localeWeekdayNames:Vector.<String>;

		/**
		 * @private
		 */
		protected var _ignoreListChanges:Boolean = false;

		/**
		 * @private
		 */
		protected var _monthFirst:Boolean = true;

		/**
		 * @private
		 */
		protected var _showMeridiem:Boolean = true;

		/**
		 * @private
		 */
		protected var _lastMeridiemValue:int = 0;

		/**
		 * @private
		 */
		protected var _listMinYear:int;

		/**
		 * @private
		 */
		protected var _listMaxYear:int;

		/**
		 * @private
		 */
		protected var _minYear:int;

		/**
		 * @private
		 */
		protected var _maxYear:int;

		/**
		 * @private
		 */
		protected var _minMonth:int;

		/**
		 * @private
		 */
		protected var _maxMonth:int;

		/**
		 * @private
		 */
		protected var _minDate:int;

		/**
		 * @private
		 */
		protected var _maxDate:int;

		/**
		 * @private
		 */
		protected var _minHours:int;

		/**
		 * @private
		 */
		protected var _maxHours:int;

		/**
		 * @private
		 */
		protected var _minMinute:int;

		/**
		 * @private
		 */
		protected var _maxMinute:int;

		/**
		 * @private
		 */
		protected var _scrollDuration:Number = 0.5;

		/**
		 * @private
		 */
		public function get scrollDuration():Number
		{
			return this._scrollDuration;
		}

		/**
		 * @private
		 */
		public function set scrollDuration(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._scrollDuration === value)
			{
				return;
			}
			this._scrollDuration = value;
		}

		/**
		 * @private
		 */
		protected var _itemRendererFactory:Function = null;

		/**
		 * A function used to instantiate the date time spinner's item renderer
		 * sub-components. A single factory will be shared by all
		 * <code>SpinnerList</code> sub-components displayed by the
		 * <code>DateTimeSpinner</code>. The item renderers must be instances of
		 * <code>DefaultListItemRenderer</code>. This factory can be used to
		 * change properties of the item renderer sub-components when they are
		 * first created. For instance, if you are skinning Feathers components
		 * without a theme, you might use this factory to style the item
		 * renderer sub-components.
		 *
		 * <p>The factory should have the following function signature:</p>
		 * <pre>function():DefaultListItemRenderer</pre>
		 *
		 * <p>In the following example, the date time spinner uses a custom item
		 * renderer factory:</p>
		 *
		 * <listing version="3.0">
		 * spinner.itemRendererFactory = function():DefaultListItemRenderer
		 * {
		 *     var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
		 *     // set properties
		 *     return itemRenderer;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.renderers.DefaultListItemRenderer
		 * @see #itemRendererFactory
		 */
		public function get itemRendererFactory():Function
		{
			return this._itemRendererFactory;
		}

		/**
		 * @private
		 */
		public function set itemRendererFactory(value:Function):void
		{
			if(this._itemRendererFactory === value)
			{
				return;
			}
			this._itemRendererFactory = value;
			this.invalidate(INVALIDATION_FLAG_SPINNER_LIST_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _listFactory:Function;

		/**
		 * A function used to instantiate the date time spinner's list
		 * sub-components. The lists must be instances of
		 * <code>SpinnerList</code>. This factory can be used to change
		 * properties of the list sub-components when they are first created.
		 * For instance, if you are skinning Feathers components without a
		 * theme, you might use this factory to style the list sub-components.
		 * 
		 * <p><strong>Warning:</strong> The <code>itemRendererFactory</code>
		 * and <code>customItemRendererStyleName</code> properties of the
		 * <code>SpinnerList</code> should not be set in the
		 * <code>listFactory</code>. Instead, set the
		 * <code>itemRendererFactory</code> and
		 * <code>customItemRendererStyleName</code> properties of the
		 * <code>DateTimeSpinner</code>.</p>
		 *
		 * <p>The factory should have the following function signature:</p>
		 * <pre>function():SpinnerList</pre>
		 *
		 * <p>In the following example, the date time spinner uses a custom list
		 * factory:</p>
		 *
		 * <listing version="3.0">
		 * spinner.listFactory = function():SpinnerList
		 * {
		 *     var list:SpinnerList = new SpinnerList();
		 *     // set properties
		 *     return list;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.SpinnerList
		 * @see #itemRendererFactory
		 */
		public function get listFactory():Function
		{
			return this._listFactory;
		}

		/**
		 * @private
		 */
		public function set listFactory(value:Function):void
		{
			if(this._listFactory == value)
			{
				return;
			}
			this._listFactory = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _customListStyleName:String;

		/**
		 * @private
		 */
		public function get customListStyleName():String
		{
			return this._customListStyleName;
		}

		/**
		 * @private
		 */
		public function set customListStyleName(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customListStyleName === value)
			{
				return;
			}
			this._customListStyleName = value;
			this.invalidate(INVALIDATION_FLAG_SPINNER_LIST_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customItemRendererStyleName:String;

		/**
		 * @private
		 */
		public function get customItemRendererStyleName():String
		{
			return this._customItemRendererStyleName;
		}

		/**
		 * @private
		 */
		public function set customItemRendererStyleName(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customItemRendererStyleName === value)
			{
				return;
			}
			this._customItemRendererStyleName = value;
			this.invalidate(INVALIDATION_FLAG_SPINNER_LIST_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _lastValidate:Date;

		/**
		 * @private
		 */
		protected var _todayLabel:String = null;

		/**
		 * If not <code>null</code>, and the <code>editingMode</code> property
		 * is set to <code>DateTimeMode.DATE_AND_TIME</code> the date matching
		 * today's current date will display this label instead of the date.
		 *
		 * <p>In the following example, the label for today is set:</p>
		 *
		 * <listing version="3.0">
		 * spinner.todayLabel = "Today";</listing>
		 *
		 * @default null
		 */
		public function get todayLabel():String
		{
			return this._todayLabel;
		}

		/**
		 * @private
		 */
		public function set todayLabel(value:String):void
		{
			if(this._todayLabel == value)
			{
				return;
			}
			this._todayLabel = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
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
			if(this._backgroundSkin !== null &&
				this.currentBackgroundSkin === this._backgroundSkin)
			{
				this.removeCurrentBackgroundSkin(this._backgroundSkin);
				this.currentBackgroundSkin = null;
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
			if(this._backgroundDisabledSkin !== null &&
				this.currentBackgroundSkin === this._backgroundDisabledSkin)
			{
				this.removeCurrentBackgroundSkin(this._backgroundDisabledSkin);
				this.currentBackgroundSkin = null;
			}
			this._backgroundDisabledSkin = value;
			this.invalidate(INVALIDATION_FLAG_SKIN);
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
			if(this._paddingTop === value)
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
			if(this._paddingRight === value)
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
			if(this._paddingBottom === value)
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
			if(this._paddingLeft === value)
			{
				return;
			}
			this._paddingLeft = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _amString:String;

		/**
		 * @private
		 */
		protected var _pmString:String;

		/**
		 * @private
		 */
		protected var pendingScrollToDate:Date;

		/**
		 * @private
		 */
		protected var pendingScrollDuration:Number;

		/**
		 * After the next validation, animates the scroll positions of the lists
		 * to a specific date. If the <code>animationDuration</code> argument is
		 * <code>NaN</code> (the default value), the value of the
		 * <code>scrollDuration</code> property is used instead. The duration is
		 * measured in seconds.
		 *
		 * <p>Note: The <code>value</code> property will not be updated
		 * immediately when calling <code>scrollToDate()</code>. Similar to how
		 * the animation won't start until the next validation, the
		 * <code>value</code> property will be updated at the same time.</p>
		 *
		 * <p>In the following example, we scroll to a specific date with
		 * animation of 1.5 seconds:</p>
		 *
		 * <listing version="3.0">
		 * spinner.scrollToDate( new Date(2016, 0, 1), 1.5 );</listing>
		 * 
		 * @see #style:scrollDuration
		 */
		public function scrollToDate(date:Date, animationDuration:Number = NaN):void
		{
			if(this.pendingScrollToDate && this.pendingScrollToDate.time === date.time &&
				this.pendingScrollDuration === animationDuration)
			{
				return;
			}
			this.pendingScrollToDate = date;
			this.pendingScrollDuration = animationDuration;
			this.invalidate(INVALIDATION_FLAG_PENDING_SCROLL);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			//we don't dispose it if the group is the parent because it'll
			//already get disposed in super.dispose()
			if(this._backgroundSkin !== null && this._backgroundSkin.parent !== this)
			{
				this._backgroundSkin.dispose();
			}
			if(this._backgroundDisabledSkin !== null && this._backgroundDisabledSkin.parent !== this)
			{
				this._backgroundDisabledSkin.dispose();
			}
			super.dispose();
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(this.listGroup === null)
			{
				var groupLayout:HorizontalLayout = new HorizontalLayout();
				groupLayout.horizontalAlign = HorizontalAlign.CENTER;
				groupLayout.verticalAlign = VerticalAlign.JUSTIFY;
				this.listGroup = new LayoutGroup();
				this.listGroup.layout = groupLayout;
				this.addChild(this.listGroup);
			}
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var skinInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SKIN);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var editingModeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_EDITING_MODE);
			var localeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LOCALE);
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var pendingScrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_PENDING_SCROLL);
			var spinnerListFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SPINNER_LIST_FACTORY);

			if(this._todayLabel)
			{
				this._lastValidate = new Date();
			}

			if(skinInvalid || stateInvalid)
			{
				this.refreshBackgroundSkin();
			}

			if(localeInvalid || editingModeInvalid)
			{
				this.refreshLocale();
			}

			if(localeInvalid || editingModeInvalid || spinnerListFactoryInvalid)
			{
				this.refreshLists(editingModeInvalid || spinnerListFactoryInvalid, localeInvalid);
			}

			if(localeInvalid || editingModeInvalid || dataInvalid || spinnerListFactoryInvalid)
			{
				this.useDefaultsIfNeeded();
				this.refreshValidRanges();
				this.refreshSelection();
			}

			if(localeInvalid || editingModeInvalid || stateInvalid || spinnerListFactoryInvalid)
			{
				this.refreshEnabled();
			}

			this.autoSizeIfNeeded();

			this.layoutChildren();

			if(pendingScrollInvalid)
			{
				this.handlePendingScroll();
			}
		}

		/**
		 * @private
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			var needsWidth:Boolean = this._explicitWidth !== this._explicitWidth; //isNaN
			var needsHeight:Boolean = this._explicitHeight !== this._explicitHeight; //isNaN
			var needsMinWidth:Boolean = this._explicitMinWidth !== this._explicitMinWidth; //isNaN
			var needsMinHeight:Boolean = this._explicitMinHeight !== this._explicitMinHeight; //isNaN
			if(!needsWidth && !needsHeight && !needsMinWidth && !needsMinHeight)
			{
				return false;
			}

			var measureBackground:IMeasureDisplayObject = this.currentBackgroundSkin as IMeasureDisplayObject;
			resetFluidChildDimensionsForMeasurement(this.currentBackgroundSkin,
				this._explicitWidth, this._explicitHeight,
				this._explicitMinWidth, this._explicitMinHeight,
				this._explicitMaxWidth, this._explicitMaxHeight,
				this._explicitBackgroundWidth, this._explicitBackgroundHeight,
				this._explicitBackgroundMinWidth, this._explicitBackgroundMinHeight,
				this._explicitBackgroundMaxWidth, this._explicitBackgroundMaxHeight);
			if(this.currentBackgroundSkin is IValidating)
			{
				IValidating(this.currentBackgroundSkin).validate();
			}

			this.listGroup.width = this._explicitWidth;
			this.listGroup.height = this._explicitHeight;
			this.listGroup.minWidth = this._explicitMinWidth;
			this.listGroup.minHeight = this._explicitMinHeight;
			this.listGroup.validate();//minimum dimensions

			var newMinWidth:Number = this._explicitMinWidth;
			if(needsMinWidth)
			{
				if(measureBackground !== null)
				{
					newMinWidth = measureBackground.minWidth;
				}
				else if(this.currentBackgroundSkin !== null)
				{
					newMinWidth = this._explicitBackgroundMinWidth;
				}
				else
				{
					newMinWidth = 0;
				}
				var listsMinWidth:Number = this.listGroup.minWidth;
				listsMinWidth += this._paddingLeft + this._paddingRight;
				if(listsMinWidth > newMinWidth)
				{
					newMinWidth = listsMinWidth;
				}
			}
			var newMinHeight:Number = this._explicitMinHeight;
			if(needsMinHeight)
			{
				if(measureBackground !== null)
				{
					newMinHeight = measureBackground.minHeight;
				}
				else if(this.currentBackgroundSkin !== null)
				{
					newMinHeight = this._explicitBackgroundMinHeight;
				}
				else
				{
					newMinHeight = 0;
				}
				var listsMinHeight:Number = this.listGroup.minHeight;
				listsMinHeight += this._paddingTop + this._paddingBottom;
				if(listsMinHeight > newMinHeight)
				{
					newMinHeight = listsMinHeight;
				}
			}

			//current dimensions
			var newWidth:Number = this._explicitWidth;
			if(needsWidth)
			{
				if(this.currentBackgroundSkin !== null)
				{
					newWidth = this.currentBackgroundSkin.width;
				}
				else
				{
					newWidth = 0;
				}
				var listsWidth:Number = this.listGroup.width + this._paddingLeft + this._paddingRight;
				if(listsWidth > newWidth)
				{
					newWidth = listsWidth;
				}
			}
			var newHeight:Number = this._explicitHeight;
			if(needsHeight)
			{
				if(this.currentBackgroundSkin !== null)
				{
					newHeight = this.currentBackgroundSkin.height;
				}
				else
				{
					newHeight = 0;
				}
				var listsHeight:Number = this.listGroup.height + this._paddingTop + this._paddingBottom;
				if(listsHeight > newHeight)
				{
					newHeight = listsHeight;
				}
			}

			return this.saveMeasurements(newWidth, newHeight, newMinWidth, newMinHeight);
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
				this.removeCurrentBackgroundSkin(oldBackgroundSkin);
				if(this.currentBackgroundSkin !== null)
				{
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
					this.addChildAt(this.currentBackgroundSkin, 0);
				}
			}
		}

		/**
		 * @private
		 */
		protected function removeCurrentBackgroundSkin(skin:DisplayObject):void
		{
			if(skin === null)
			{
				return;
			}
			if(skin.parent === this)
			{
				//we need to restore these values so that they won't be lost the
				//next time that this skin is used for measurement
				skin.width = this._explicitBackgroundWidth;
				skin.height = this._explicitBackgroundHeight;
				if(skin is IMeasureDisplayObject)
				{
					var measureSkin:IMeasureDisplayObject = IMeasureDisplayObject(skin);
					measureSkin.minWidth = this._explicitBackgroundMinWidth;
					measureSkin.minHeight = this._explicitBackgroundMinHeight;
					measureSkin.maxWidth = this._explicitBackgroundMaxWidth;
					measureSkin.maxHeight = this._explicitBackgroundMaxHeight;
				}
				this.setRequiresRedraw();
				skin.removeFromParent(false);
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
		protected function refreshLists(createNewLists:Boolean, localeChanged:Boolean):void
		{
			if(createNewLists)
			{
				this.createYearList();
				this.createMonthList();
				this.createDateList();

				this.createHourList();
				this.createMinuteList();
				this.createMeridiemList();

				this.createDateAndTimeDateList();
			}
			else if((this._showMeridiem && !this.meridiemList) ||
				(!this._showMeridiem && this.meridiemList))
			{
				//if the locale changes, we may need to create or destroy this
				//list, but the other lists can stay
				this.createMeridiemList();
			}
			
			if(this._editingMode == DateTimeMode.DATE)
			{
				//does this locale show the month or the date first?
				if(this._monthFirst)
				{
					this.listGroup.setChildIndex(this.monthsList, 0);
				}
				else
				{
					this.listGroup.setChildIndex(this.datesList, 0);
				}
			}
			
			if(localeChanged)
			{
				if(this.monthsList)
				{
					var monthsCollection:IListCollection = this.monthsList.dataProvider;
					if(monthsCollection)
					{
						monthsCollection.updateAll();
					}
				}
				if(this.dateAndTimeDatesList)
				{
					var dateAndTimeDatesCollection:IListCollection = this.dateAndTimeDatesList.dataProvider;
					if(dateAndTimeDatesCollection)
					{
						dateAndTimeDatesCollection.updateAll();
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function createYearList():void
		{
			if(this.yearsList)
			{
				this.listGroup.removeChild(this.yearsList, true);
				this.yearsList = null;
			}

			if(this._editingMode !== DateTimeMode.DATE)
			{
				return;
			}

			var listFactory:Function = (this._listFactory !== null) ? this._listFactory : defaultListFactory;
			this.yearsList = SpinnerList(listFactory());
			var listStyleName:String = (this._customListStyleName !== null) ? this._customListStyleName : this.listStyleName;
			this.yearsList.styleNameList.add(listStyleName);
			//we'll set the data provider later, when we know what range
			//of years we need

			//for backwards compatibility, allow the listFactory to take
			//precedence if it also sets itemRendererFactory or
			//customItemRendererStyleName
			if(this._itemRendererFactory !== null)
			{
				this.yearsList.itemRendererFactory = this._itemRendererFactory;
			}
			if(this._customItemRendererStyleName !== null)
			{
				this.yearsList.customItemRendererStyleName = this._customItemRendererStyleName;
			}
			this.yearsList.addEventListener(FeathersEventType.RENDERER_ADD, yearsList_rendererAddHandler);
			this.yearsList.addEventListener(Event.CHANGE, yearsList_changeHandler);
			this.listGroup.addChild(this.yearsList);
		}

		/**
		 * @private
		 */
		protected function createMonthList():void
		{
			if(this.monthsList)
			{
				this.listGroup.removeChild(this.monthsList, true);
				this.monthsList = null;
			}

			if(this._editingMode !== DateTimeMode.DATE)
			{
				return;
			}

			var listFactory:Function = (this._listFactory !== null) ? this._listFactory : defaultListFactory;
			this.monthsList = SpinnerList(listFactory());
			var listStyleName:String = (this._customListStyleName !== null) ? this._customListStyleName : this.listStyleName;
			this.monthsList.styleNameList.add(listStyleName);
			this.monthsList.dataProvider = new IntegerRangeCollection(MIN_MONTH_VALUE, MAX_MONTH_VALUE, 1);
			this.monthsList.typicalItem = this._longestMonthNameIndex;
			//for backwards compatibility, allow the listFactory to take
			//precedence if it also sets itemRendererFactory or
			//customItemRendererStyleName
			if(this._itemRendererFactory !== null)
			{
				this.monthsList.itemRendererFactory = this._itemRendererFactory;
			}
			if(this._customItemRendererStyleName !== null)
			{
				this.monthsList.customItemRendererStyleName = this._customItemRendererStyleName;
			}
			this.monthsList.addEventListener(FeathersEventType.RENDERER_ADD, monthsList_rendererAddHandler);
			this.monthsList.addEventListener(Event.CHANGE, monthsList_changeHandler);
			this.listGroup.addChildAt(this.monthsList, 0);
		}

		/**
		 * @private
		 */
		protected function createDateList():void
		{
			if(this.datesList)
			{
				this.listGroup.removeChild(this.datesList, true);
				this.datesList = null;
			}

			if(this._editingMode !== DateTimeMode.DATE)
			{
				return;
			}

			var listFactory:Function = (this._listFactory !== null) ? this._listFactory : defaultListFactory;
			this.datesList = SpinnerList(listFactory());
			var listStyleName:String = (this._customListStyleName !== null) ? this._customListStyleName : this.listStyleName;
			this.datesList.styleNameList.add(listStyleName);
			this.datesList.dataProvider = new IntegerRangeCollection(MIN_DATE_VALUE, MAX_DATE_VALUE, 1);
			//for backwards compatibility, allow the listFactory to take
			//precedence if it also sets itemRendererFactory or
			//customItemRendererStyleName
			if(this._itemRendererFactory !== null)
			{
				this.datesList.itemRendererFactory = this._itemRendererFactory;
			}
			if(this._customItemRendererStyleName !== null)
			{
				this.datesList.customItemRendererStyleName = this._customItemRendererStyleName;
			}
			this.datesList.addEventListener(FeathersEventType.RENDERER_ADD, datesList_rendererAddHandler);
			this.datesList.addEventListener(Event.CHANGE, datesList_changeHandler);
			this.listGroup.addChildAt(this.datesList, 0);
		}

		/**
		 * @private
		 */
		protected function createHourList():void
		{
			if(this.hoursList)
			{
				this.listGroup.removeChild(this.hoursList, true);
				this.hoursList = null;
			}

			if(this._editingMode === DateTimeMode.DATE)
			{
				return;
			}

			var listFactory:Function = (this._listFactory !== null) ? this._listFactory : defaultListFactory;
			this.hoursList = SpinnerList(listFactory());
			var listStyleName:String = (this._customListStyleName !== null) ? this._customListStyleName : this.listStyleName;
			this.hoursList.styleNameList.add(listStyleName);
			//for backwards compatibility, allow the listFactory to take
			//precedence if it also sets itemRendererFactory or
			//customItemRendererStyleName
			if(this._itemRendererFactory !== null)
			{
				this.hoursList.itemRendererFactory = this._itemRendererFactory;
			}
			if(this._customItemRendererStyleName !== null)
			{
				this.hoursList.customItemRendererStyleName = this._customItemRendererStyleName;
			}
			this.hoursList.addEventListener(FeathersEventType.RENDERER_ADD, hoursList_rendererAddHandler);
			this.hoursList.addEventListener(Event.CHANGE, hoursList_changeHandler);
			this.listGroup.addChild(this.hoursList);
		}

		/**
		 * @private
		 */
		protected function createMinuteList():void
		{
			if(this.minutesList)
			{
				this.listGroup.removeChild(this.minutesList, true);
				this.minutesList = null;
			}

			if(this._editingMode === DateTimeMode.DATE)
			{
				return;
			}

			var listFactory:Function = (this._listFactory !== null) ? this._listFactory : defaultListFactory;
			this.minutesList = SpinnerList(listFactory());
			var listStyleName:String = (this._customListStyleName !== null) ? this._customListStyleName : this.listStyleName;
			this.minutesList.styleNameList.add(listStyleName);
			this.minutesList.dataProvider = new IntegerRangeCollection(MIN_MINUTES_VALUE, MAX_MINUTES_VALUE, this._minuteStep);
			//for backwards compatibility, allow the listFactory to take
			//precedence if it also sets itemRendererFactory or
			//customItemRendererStyleName
			if(this._itemRendererFactory !== null)
			{
				this.minutesList.itemRendererFactory = this._itemRendererFactory;
			}
			if(this._customItemRendererStyleName !== null)
			{
				this.minutesList.customItemRendererStyleName = this._customItemRendererStyleName;
			}
			this.minutesList.addEventListener(FeathersEventType.RENDERER_ADD, minutesList_rendererAddHandler);
			this.minutesList.addEventListener(Event.CHANGE, minutesList_changeHandler);
			this.listGroup.addChild(this.minutesList);
		}

		/**
		 * @private
		 */
		protected function createMeridiemList():void
		{
			if(this.meridiemList)
			{
				this.listGroup.removeChild(this.meridiemList, true);
				this.meridiemList = null;
			}

			if(!this._showMeridiem)
			{
				return;
			}

			var listFactory:Function = (this._listFactory !== null) ? this._listFactory : defaultListFactory;
			this.meridiemList = SpinnerList(listFactory());
			var listStyleName:String = (this._customListStyleName !== null) ? this._customListStyleName : this.listStyleName;
			this.meridiemList.styleNameList.add(listStyleName);
			//for backwards compatibility, allow the listFactory to take
			//precedence if it also sets itemRendererFactory or
			//customItemRendererStyleName
			if(this._itemRendererFactory !== null)
			{
				this.meridiemList.itemRendererFactory = this._itemRendererFactory;
			}
			if(this._customItemRendererStyleName !== null)
			{
				this.meridiemList.customItemRendererStyleName = this._customItemRendererStyleName;
			}
			this.meridiemList.addEventListener(Event.CHANGE, meridiemList_changeHandler);
			this.listGroup.addChild(this.meridiemList);
		}

		/**
		 * @private
		 */
		protected function createDateAndTimeDateList():void
		{
			if(this.dateAndTimeDatesList)
			{
				this.listGroup.removeChild(this.dateAndTimeDatesList, true);
				this.dateAndTimeDatesList = null;
			}

			if(this._editingMode !== DateTimeMode.DATE_AND_TIME)
			{
				return;
			}

			var listFactory:Function = (this._listFactory !== null) ? this._listFactory : defaultListFactory;
			this.dateAndTimeDatesList = SpinnerList(listFactory());
			var listStyleName:String = (this._customListStyleName !== null) ? this._customListStyleName : this.listStyleName;
			this.dateAndTimeDatesList.styleNameList.add(listStyleName);
			//for backwards compatibility, allow the listFactory to take
			//precedence if it also sets itemRendererFactory or
			//customItemRendererStyleName
			if(this._itemRendererFactory !== null)
			{
				this.dateAndTimeDatesList.itemRendererFactory = this._itemRendererFactory;
			}
			if(this._customItemRendererStyleName !== null)
			{
				this.dateAndTimeDatesList.customItemRendererStyleName = this._customItemRendererStyleName;
			}
			this.dateAndTimeDatesList.addEventListener(FeathersEventType.RENDERER_ADD, dateAndTimeDatesList_rendererAddHandler);
			this.dateAndTimeDatesList.addEventListener(Event.CHANGE, dateAndTimeDatesList_changeHandler);
			this.dateAndTimeDatesList.typicalItem = {};
			this.listGroup.addChildAt(this.dateAndTimeDatesList, 0);
		}

		/**
		 * @private
		 */
		protected function refreshLocale():void
		{
			if(!this._formatter || this._formatter.requestedLocaleIDName != this._locale)
			{
				this._formatter = new DateTimeFormatter(this._locale, DateTimeStyle.SHORT, DateTimeStyle.SHORT);
				var dateTimePattern:String = this._formatter.getDateTimePattern();
				//figure out if month or date should be displayed first
				var monthIndex:int = dateTimePattern.indexOf("M");
				var dateIndex:int = dateTimePattern.indexOf("d");
				this._monthFirst = monthIndex < dateIndex;
				//figure out if this locale uses am/pm or 24-hour format
				this._showMeridiem = this._editingMode !== DateTimeMode.DATE && dateTimePattern.indexOf("a") >= 0;
				if(this._showMeridiem)
				{
					this._formatter.setDateTimePattern("a");
					HELPER_DATE.setHours(1);
					//different locales have different names for am and pm
					//as an example, see zh_CN
					this._amString = this._formatter.format(HELPER_DATE);
					HELPER_DATE.setHours(13);
					this._pmString = this._formatter.format(HELPER_DATE);
					this._formatter.setDateTimePattern(dateTimePattern);
				}
			}
			if(this._editingMode === DateTimeMode.DATE)
			{
				this._localeMonthNames = this._formatter.getMonthNames(DateTimeNameStyle.FULL);
				this._localeWeekdayNames = null;
			}
			else if(this._editingMode === DateTimeMode.DATE_AND_TIME)
			{
				this._localeMonthNames = this._formatter.getMonthNames(DateTimeNameStyle.SHORT_ABBREVIATION);
				this._localeWeekdayNames = this._formatter.getWeekdayNames(DateTimeNameStyle.LONG_ABBREVIATION);
			}
			else //time only
			{
				this._localeMonthNames = null;
				this._localeWeekdayNames = null;
			}
			if(this._localeMonthNames !== null)
			{
				this._longestMonthNameIndex = 0;
				var longestMonth:String = this._localeMonthNames[0];
				var monthCount:int = this._localeMonthNames.length;
				for(var i:int = 1; i < monthCount; i++)
				{
					var otherMonthName:String = this._localeMonthNames[i];
					if(otherMonthName.length > longestMonth.length)
					{
						longestMonth = otherMonthName;
						this._longestMonthNameIndex = i;
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function refreshSelection():void
		{
			var oldIgnoreListChanges:Boolean = this._ignoreListChanges;
			this._ignoreListChanges = true;

			if(this._editingMode === DateTimeMode.DATE)
			{
				var yearsCollection:IntegerRangeCollection = IntegerRangeCollection(this.yearsList.dataProvider);
				if(yearsCollection !== null)
				{
					yearsCollection.minimum = this._listMinYear;
					yearsCollection.maximum = this._listMaxYear;
				}
				else
				{
					this.yearsList.dataProvider = new IntegerRangeCollection(this._listMinYear, this._listMaxYear, 1);
				}
			}
			else //time only or both date and time
			{
				var totalMS:Number = this._maximum.time - this._minimum.time;
				var totalDays:int = totalMS / MS_PER_DAY;

				if(this._editingMode === DateTimeMode.DATE_AND_TIME)
				{
					var dateAndTimeDatesCollection:IntegerRangeCollection = IntegerRangeCollection(this.dateAndTimeDatesList.dataProvider);
					if(dateAndTimeDatesCollection !== null)
					{
						dateAndTimeDatesCollection.maximum = totalDays;
					}
					else
					{
						this.dateAndTimeDatesList.dataProvider = new IntegerRangeCollection(0, totalDays, 1);
					}
				}

				var hoursMinimum:Number = MIN_HOURS_VALUE;
				var hoursMaximum:Number = this._showMeridiem ? MAX_HOURS_VALUE_12HOURS : MAX_HOURS_VALUE_24HOURS;
				var hoursCollection:IntegerRangeCollection = IntegerRangeCollection(this.hoursList.dataProvider);
				if(hoursCollection !== null)
				{
					hoursCollection.minimum = hoursMinimum;
					hoursCollection.maximum = hoursMaximum;
				}
				else
				{
					this.hoursList.dataProvider = new IntegerRangeCollection(hoursMinimum, hoursMaximum, 1);
				}

				if(this._showMeridiem && !this.meridiemList.dataProvider)
				{
					this.meridiemList.dataProvider = new VectorCollection(new <String>[this._amString, this._pmString]);
				}
			}

			if(this.monthsList && !this.monthsList.isScrolling)
			{
				this.monthsList.selectedItem = this._value.month;
			}
			if(this.datesList && !this.datesList.isScrolling)
			{
				this.datesList.selectedItem = this._value.date;
			}
			if(this.yearsList && !this.yearsList.isScrolling)
			{
				this.yearsList.selectedItem = this._value.fullYear;
			}

			if(this.dateAndTimeDatesList)
			{
				this.dateAndTimeDatesList.selectedIndex = (this._value.time - this._minimum.time) / MS_PER_DAY;
			}
			if(this.hoursList)
			{
				if(this._showMeridiem)
				{
					this.hoursList.selectedIndex = this._value.hours % 12;
				}
				else
				{
					this.hoursList.selectedIndex = this._value.hours;
				}
			}
			if(this.minutesList)
			{
				this.minutesList.selectedItem = this._value.minutes;
			}
			if(this.meridiemList)
			{
				this.meridiemList.selectedIndex = (this._value.hours <= MAX_HOURS_VALUE_12HOURS) ? 0 : 1;
			}
			this._ignoreListChanges = oldIgnoreListChanges;
		}

		/**
		 * @private
		 */
		protected function refreshEnabled():void
		{
			var listCount:int = this.listGroup.numChildren;
			for(var i:int = 0; i < listCount; i++)
			{
				var list:SpinnerList = SpinnerList(this.listGroup.getChildAt(i));
				list.isEnabled = this._isEnabled;
			}
		}

		/**
		 * @private
		 */
		protected function refreshValidRanges():void
		{
			var oldMinYear:int = this._minYear;
			var oldMaxYear:int = this._maxYear;
			var oldMinMonth:int = this._minMonth;
			var oldMaxMonth:int = this._maxMonth;
			var oldMinDate:int = this._minDate;
			var oldMaxDate:int = this._maxDate;
			var oldMinHours:int = this._minHours;
			var oldMaxHours:int = this._maxHours;
			var oldMinMinutes:int = this._minMinute;
			var oldMaxMinutes:int = this._maxMinute;
			var currentYear:int = this._value.fullYear;
			var currentMonth:int = this._value.month;
			var currentDate:int = this._value.date;
			var currentHours:int = this._value.hours;
			this._minYear = this._minimum.fullYear;
			this._maxYear = this._maximum.fullYear;
			if(currentYear === this._minYear)
			{
				this._minMonth = this._minimum.month;
			}
			else
			{
				this._minMonth = MIN_MONTH_VALUE;
			}
			if(currentYear === this._maxYear)
			{
				this._maxMonth = this._maximum.month;
			}
			else
			{
				this._maxMonth = MAX_MONTH_VALUE;
			}
			if(currentYear === this._minYear && currentMonth === this._minimum.month)
			{
				this._minDate = this._minimum.date;
			}
			else
			{
				this._minDate = MIN_DATE_VALUE;
			}
			if(currentYear === this._maxYear && currentMonth === this._maximum.month)
			{
				this._maxDate = this._maximum.date;
			}
			else
			{
				if(currentMonth === 1) //february has a variable number of days
				{
					//subtract one date from march 1st to figure out the last
					//date of february for the specified year
					HELPER_DATE.setFullYear(currentYear, currentMonth + 1, -1);
					this._maxDate = HELPER_DATE.date + 1;
				}
				else //all other months have been pre-calculated
				{
					this._maxDate = DAYS_IN_MONTH[currentMonth];
				}
			}
			if(this._editingMode === DateTimeMode.DATE_AND_TIME)
			{
				if(currentYear === this._minYear && currentMonth === this._minimum.month &&
					currentDate === this._minimum.date)
				{
					this._minHours = this._minimum.hours;
				}
				else
				{
					this._minHours = MIN_HOURS_VALUE;
				}
				if(currentYear === this._maxYear && currentMonth === this._maximum.month &&
					currentDate === this._maximum.date)
				{
					this._maxHours = this._maximum.hours;
				}
				else
				{
					this._maxHours = MAX_HOURS_VALUE_24HOURS;
				}

				if(currentYear === this._minYear && currentMonth === this._minimum.month &&
					currentDate === this._minimum.date && currentHours === this._minimum.hours)
				{
					this._minMinute = this._minimum.minutes;
				}
				else
				{
					this._minMinute = MIN_MINUTES_VALUE;
				}
				if(currentYear === this._maxYear && currentMonth === this._maximum.month &&
					currentDate === this._maximum.date && currentHours === this._maximum.hours)
				{
					this._maxMinute = this._maximum.minutes;
				}
				else
				{
					this._maxMinute = MAX_MINUTES_VALUE;
				}
			}
			else //time
			{
				this._minHours = this._minimum.hours;
				this._maxHours = this._maximum.hours;
				if(currentHours === this._minHours)
				{
					this._minMinute = this._minimum.minutes;
				}
				else
				{
					this._minMinute = MIN_MINUTES_VALUE;
				}
				if(currentHours === this._maxHours)
				{
					this._maxMinute = this._maximum.minutes;
				}
				else
				{
					this._maxMinute = MAX_MINUTES_VALUE;
				}
			}

			//the item renderers in the lists may need to be enabled or disabled
			//after the ranges change, so we need to call updateAll() on the
			//collections
			
			var yearsCollection:IListCollection = this.yearsList ? this.yearsList.dataProvider : null;
			if(yearsCollection && (oldMinYear !== this._minYear || oldMaxYear !== this._maxYear))
			{
				//we need to ensure that the item renderers are enabled
				yearsCollection.updateAll();
			}
			var monthsCollection:IListCollection = this.monthsList ? this.monthsList.dataProvider : null;
			if(monthsCollection && (oldMinMonth !== this._minMonth || oldMaxMonth !== this._maxMonth))
			{
				monthsCollection.updateAll();
			}
			var datesCollection:IListCollection = this.datesList ? this.datesList.dataProvider : null;
			if(datesCollection && (oldMinDate !== this._minDate || oldMaxDate !== this._maxDate))
			{
				datesCollection.updateAll();
			}
			var dateAndTimeDatesCollection:IListCollection = this.dateAndTimeDatesList ? this.dateAndTimeDatesList.dataProvider : null;
			if(dateAndTimeDatesCollection &&
				(oldMinYear !== this._minYear || oldMaxYear !== this._maxYear ||
				oldMinMonth !== this._minMonth || oldMaxMonth !== this._maxMonth ||
				oldMinDate !== this._minDate || oldMaxDate !== this._maxDate))
			{
				dateAndTimeDatesCollection.updateAll();
			}
			var hoursCollection:IListCollection = this.hoursList ? this.hoursList.dataProvider : null;
			if(hoursCollection && (oldMinHours !== this._minHours || oldMaxHours !== this._maxHours ||
				(this._showMeridiem && this._lastMeridiemValue !== this.meridiemList.selectedIndex)))
			{
				hoursCollection.updateAll();
			}
			var minutesCollection:IListCollection = this.minutesList ? this.minutesList.dataProvider : null;
			if(minutesCollection && (oldMinMinutes !== this._minMinute || oldMaxMinutes!== this._maxMinute))
			{
				minutesCollection.updateAll();
			}
			if(this._showMeridiem)
			{
				this._lastMeridiemValue = (this._value.hours <= MAX_HOURS_VALUE_12HOURS) ? 0 : 1;
			}
		}

		/**
		 * @private
		 */
		protected function useDefaultsIfNeeded():void
		{
			if(!this._value)
			{
				//if we don't have a value, try to use today's date
				this._value = new Date();
				//but if there's an existing range, keep the value in there
				if(this._minimum && this._value.time < this._minimum.time)
				{
					this._value.time = this._minimum.time;
				}
				else if(this._maximum && this._value.time > this._maximum.time)
				{
					this._value.time = this._maximum.time;
				}
			}
			if(this._minimum)
			{
				//we want to be able to see years outside the range between
				//minimum and maximum, even if we cannot select them. otherwise,
				//it'll look weird to loop back to the beginning or end.
				if(this._editingMode === DateTimeMode.DATE_AND_TIME)
				{
					//in this editing mode, the date is only controlled by one
					//spinner list, that increments by day. we shouldn't need to
					//go back more than a year.
					this._listMinYear = this._minimum.fullYear - 1;
				}
				else
				{
					//in this editing mode, the year, month, and date are
					//selected separately, so we should have a bigger range
					this._listMinYear = this._minimum.fullYear - 10;
				}
			}
			//if there's no minimum, we need to generate something that is
			//arbitrary, but acceptable for most needs
			else if(this._editingMode === DateTimeMode.DATE_AND_TIME)
			{
				//in this editing mode, the date is only controlled by one
				//spinner list, that increments by day. we shouldn't need to
				//go back more than a year.
				HELPER_DATE.time = this._value.time;
				this._listMinYear = HELPER_DATE.fullYear - 1;
				this._minimum = new Date(this._listMinYear, MIN_MONTH_VALUE, MIN_DATE_VALUE,
					MIN_HOURS_VALUE, MIN_MINUTES_VALUE);
			}
			else
			{
				//in this editing mode, the year, month, and date are
				//selected separately, so we should have a bigger range
				HELPER_DATE.time = this._value.time;
				//goes back 100 years, rounded down to the nearest half century
				//for 2015, this would give us 1900
				//for 2065, this would give us 1950
				this._listMinYear = roundDownToNearest(HELPER_DATE.fullYear - 100, 50);
				this._minimum = new Date(this._listMinYear, MIN_MONTH_VALUE, MIN_DATE_VALUE,
					MIN_HOURS_VALUE, MIN_MINUTES_VALUE);
			}
			if(this._maximum)
			{
				if(this._editingMode === DateTimeMode.DATE_AND_TIME)
				{
					this._listMaxYear = this._maximum.fullYear + 1;
				}
				else
				{
					this._listMaxYear = this._maximum.fullYear + 10;
				}
			}
			else if(this._editingMode === DateTimeMode.DATE_AND_TIME)
			{
				HELPER_DATE.time = this._minimum.time;
				this._listMaxYear = HELPER_DATE.fullYear + 1;
				this._maximum = new Date(this._listMaxYear, MAX_MONTH_VALUE,
					DAYS_IN_MONTH[MAX_MONTH_VALUE], MAX_HOURS_VALUE_24HOURS,
					MAX_MINUTES_VALUE);
			}
			else // date
			{
				//for 2015, this would give us 2150
				//for 2065, this would give us 2200
				HELPER_DATE.time = this._value.time;
				this._listMaxYear = roundUpToNearest(HELPER_DATE.fullYear + 100, 50);
				this._maximum = new Date(this._listMaxYear, MAX_MONTH_VALUE,
					DAYS_IN_MONTH[MAX_MONTH_VALUE], MAX_HOURS_VALUE_24HOURS,
					MAX_MINUTES_VALUE);
			}
		}

		/**
		 * @private
		 */
		protected function layoutChildren():void
		{
			if(this.currentBackgroundSkin !== null &&
				(this.currentBackgroundSkin.width !== this.actualWidth ||
				this.currentBackgroundSkin.height !== this.actualHeight))
			{
				this.currentBackgroundSkin.width = this.actualWidth;
				this.currentBackgroundSkin.height = this.actualHeight;
			}
			this.listGroup.x = this._paddingLeft;
			this.listGroup.y = this._paddingTop;
			this.listGroup.width = this.actualWidth - this._paddingLeft - this._paddingRight;
			this.listGroup.height = this.actualHeight - this._paddingTop - this._paddingBottom;
			this.listGroup.validate();
		}

		/**
		 * @private
		 */
		protected function handlePendingScroll():void
		{
			if(!this.pendingScrollToDate)
			{
				return;
			}
			var pendingDate:Date = this.pendingScrollToDate;
			this.pendingScrollToDate = null;
			var duration:Number = this.pendingScrollDuration;
			if(duration !== duration) //isNaN
			{
				duration = this._scrollDuration;
			}
			if(this.yearsList)
			{
				var year:int = pendingDate.fullYear;
				if(this.yearsList.selectedItem !== year)
				{
					var yearRange:IntegerRangeCollection = IntegerRangeCollection(this.yearsList.dataProvider);
					this.yearsList.scrollToDisplayIndex(year - yearRange.minimum, duration);
				}
			}
			if(this.monthsList)
			{
				var month:int = pendingDate.month;
				if(this.monthsList.selectedItem !== month)
				{
					this.monthsList.scrollToDisplayIndex(month, duration);
				}
			}
			if(this.datesList)
			{
				var date:int = pendingDate.date;
				if(this.datesList.selectedItem !== date)
				{
					this.datesList.scrollToDisplayIndex(date - 1, duration);
				}
			}
			if(this.dateAndTimeDatesList)
			{
				var dateIndex:int = (pendingDate.time - this._minimum.time) / MS_PER_DAY;
				if(this.dateAndTimeDatesList.selectedIndex !== dateIndex)
				{
					this.dateAndTimeDatesList.scrollToDisplayIndex(dateIndex, duration);
				}
			}
			if(this.hoursList)
			{
				var hours:int = pendingDate.hours;
				if(this._showMeridiem)
				{
					hours %= 12;
				}
				if(this.hoursList.selectedItem !== hours)
				{
					this.hoursList.scrollToDisplayIndex(hours, duration);
				}
			}
			if(this.minutesList)
			{
				var minutes:int = pendingDate.minutes;
				if(this.minutesList.selectedItem !== minutes)
				{
					this.minutesList.scrollToDisplayIndex(minutes, duration);
				}
			}
			if(this.meridiemList)
			{
				var index:int = (pendingDate.hours < MAX_HOURS_VALUE_12HOURS) ? 0 : 1;
				if(this.meridiemList.selectedIndex !== index)
				{
					this.meridiemList.scrollToDisplayIndex(index, duration);
				}
			}
		}

		/**
		 * @private
		 */
		protected function isMonthEnabled(month:int):Boolean
		{
			return month >= this._minMonth && month <= this._maxMonth;
		}

		/**
		 * @private
		 */
		protected function isYearEnabled(year:int):Boolean
		{
			return year >= this._minYear && year <= this._maxYear;
		}

		/**
		 * @private
		 */
		protected function isDateEnabled(date:int):Boolean
		{
			return date >= this._minDate && date <= this._maxDate;
		}

		/**
		 * @private
		 */
		protected function isHourEnabled(hour:int):Boolean
		{
			if(this._showMeridiem && this.meridiemList.selectedIndex !== 0)
			{
				hour += 12;
			}
			return hour >= this._minHours && hour <= this._maxHours;
		}

		/**
		 * @private
		 */
		protected function isMinuteEnabled(minute:int):Boolean
		{
			return minute >= this._minMinute && minute <= this._maxMinute;
		}

		/**
		 * @private
		 */
		protected function formatHours(item:int):String
		{
			if(this._showMeridiem)
			{
				if(item === 0)
				{
					item = 12;
				}
				return item.toString();
			}
			var hours:String = item.toString();
			if(hours.length < 2)
			{
				hours = "0" + hours;
			}
			return hours;
		}

		/**
		 * @private
		 */
		protected function formatMinutes(item:int):String
		{
			var minutes:String = item.toString();
			if(minutes.length < 2)
			{
				minutes = "0" + minutes;
			}
			return minutes;
		}

		/**
		 * @private
		 */
		protected function formatDateAndTimeWeekday(item:Object):String
		{
			if(item is int)
			{
				HELPER_DATE.setTime(this._minimum.time);
				HELPER_DATE.setDate(HELPER_DATE.date + item);
				if(this._todayLabel)
				{
					//_lastValidate will be updated once per validation when
					//scrolling, which is better than creating many duplicate Date
					//objects in this function
					if(HELPER_DATE.fullYear === this._lastValidate.fullYear &&
						HELPER_DATE.month === this._lastValidate.month &&
						HELPER_DATE.date === this._lastValidate.date)
					{
						return "";
					}
				}
				return this._localeWeekdayNames[HELPER_DATE.day] as String;
			}
			//this value is used for measurement to try to avoid truncated text.
			//it will not be displayed!
			return "Wom"; 
		}

		/**
		 * @private
		 */
		protected function formatDateAndTimeDate(item:Object):String
		{
			if(item is int)
			{
				HELPER_DATE.setTime(this._minimum.time);
				HELPER_DATE.setDate(HELPER_DATE.date + item);
				if(this._todayLabel)
				{
					//_lastValidate will be updated once per validation when
					//scrolling, which is better than creating many duplicate Date
					//objects in this function
					if(HELPER_DATE.fullYear === this._lastValidate.fullYear &&
						HELPER_DATE.month === this._lastValidate.month &&
						HELPER_DATE.date === this._lastValidate.date)
					{
						return this._todayLabel;
					}
				}
				var monthName:String = this._localeMonthNames[HELPER_DATE.month] as String;
				if(this._monthFirst)
				{
					return monthName + " " + HELPER_DATE.date;
				}
				return HELPER_DATE.date + " " + monthName;
			}
			//this value is used for measurement to try to avoid truncated text.
			//it will not be displayed!
			return "Wom 30";
		}

		/**
		 * @private
		 */
		protected function formatMonthName(item:int):String
		{
			return this._localeMonthNames[item] as String;
		}

		/**
		 * @private
		 */
		protected function validateNewValue():void
		{
			var currentTime:Number = this._value.time;
			var minimumTime:Number = this._minimum.time;
			var maximumTime:Number = this._maximum.time;
			var needsToScroll:Boolean = false;
			if(currentTime < minimumTime)
			{
				needsToScroll = true;
				this._value.setTime(minimumTime);
			}
			else if(currentTime > maximumTime)
			{
				needsToScroll = true;
				this._value.setTime(maximumTime);
			}
			if(needsToScroll)
			{
				this.scrollToDate(this._value);
			}
		}

		/**
		 * @private
		 */
		protected function updateHoursFromLists():void
		{
			var hours:int = this.hoursList.selectedItem as int;
			if(this.meridiemList && this.meridiemList.selectedIndex === 1)
			{
				hours += 12;
			}
			this._value.setHours(hours);
		}

		/**
		 * @private
		 */
		protected function minutesList_rendererAddHandler(event:Event, itemRenderer:DefaultListItemRenderer):void
		{
			itemRenderer.labelFunction = formatMinutes;
			itemRenderer.enabledFunction = isMinuteEnabled;
			itemRenderer.itemHasEnabled = true;
		}

		/**
		 * @private
		 */
		protected function hoursList_rendererAddHandler(event:Event, itemRenderer:DefaultListItemRenderer):void
		{
			itemRenderer.labelFunction = formatHours;
			itemRenderer.enabledFunction = isHourEnabled;
			itemRenderer.itemHasEnabled = true;
		}

		/**
		 * @private
		 */
		protected function dateAndTimeDatesList_rendererAddHandler(event:Event, itemRenderer:DefaultListItemRenderer):void
		{
			itemRenderer.labelFunction = formatDateAndTimeDate;
			itemRenderer.accessoryLabelFunction = formatDateAndTimeWeekday;
		}

		/**
		 * @private
		 */
		protected function monthsList_rendererAddHandler(event:Event, itemRenderer:DefaultListItemRenderer):void
		{
			itemRenderer.labelFunction = formatMonthName;
			itemRenderer.enabledFunction = isMonthEnabled;
			itemRenderer.itemHasEnabled = true;
		}

		/**
		 * @private
		 */
		protected function datesList_rendererAddHandler(event:Event, itemRenderer:DefaultListItemRenderer):void
		{
			itemRenderer.enabledFunction = isDateEnabled;
			itemRenderer.itemHasEnabled = true;
		}

		/**
		 * @private
		 */
		protected function yearsList_rendererAddHandler(event:Event, itemRenderer:DefaultListItemRenderer):void
		{
			itemRenderer.enabledFunction = isYearEnabled;
			itemRenderer.itemHasEnabled = true;
		}

		/**
		 * @private
		 */
		protected function monthsList_changeHandler(event:Event):void
		{
			if(this._ignoreListChanges)
			{
				return;
			}
			var month:int = this.monthsList.selectedItem as int;
			this._value.setMonth(month);
			this.validateNewValue();
			this.refreshValidRanges();
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected function datesList_changeHandler(event:Event):void
		{
			if(this._ignoreListChanges)
			{
				return;
			}
			var date:int = this.datesList.selectedItem as int;
			this._value.setDate(date);
			this.validateNewValue();
			this.refreshValidRanges();
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected function yearsList_changeHandler(event:Event):void
		{
			if(this._ignoreListChanges)
			{
				return;
			}
			var year:int = this.yearsList.selectedItem as int;
			this._value.setFullYear(year);
			this.validateNewValue();
			this.refreshValidRanges();
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected function dateAndTimeDatesList_changeHandler(event:Event):void
		{
			if(this._ignoreListChanges)
			{
				return;
			}
			this._value.setFullYear(this._minimum.fullYear, this._minimum.month, this._minimum.date + this.dateAndTimeDatesList.selectedIndex);
			this.validateNewValue();
			this.refreshValidRanges();
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected function hoursList_changeHandler(event:Event):void
		{
			if(this._ignoreListChanges)
			{
				return;
			}
			this.updateHoursFromLists();
			this.validateNewValue();
			this.refreshValidRanges();
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected function minutesList_changeHandler(event:Event):void
		{
			if(this._ignoreListChanges)
			{
				return;
			}
			var minutes:int = this.minutesList.selectedItem as int;
			this._value.setMinutes(minutes);
			this.validateNewValue();
			this.refreshValidRanges();
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected function meridiemList_changeHandler(event:Event):void
		{
			if(this._ignoreListChanges)
			{
				return;
			}
			this.updateHoursFromLists();
			this.validateNewValue();
			this.refreshValidRanges();
			this.dispatchEventWith(Event.CHANGE);
		}
	}
}

import feathers.data.IListCollection;
import feathers.events.CollectionEventType;

import starling.events.Event;
import starling.events.EventDispatcher;

class IntegerRangeCollection extends EventDispatcher implements IListCollection
{
	public function IntegerRangeCollection(minimum:int = 0, maximum:int = 1, step:int = 1)
	{
		this._minimum = minimum;
		this._maximum = maximum;
		this._step = step;
	}

	protected var _minimum:int;

	public function get minimum():int
	{
		return this._minimum;
	}

	public function set minimum(value:int):void
	{
		if(this._minimum === value)
		{
			return;
		}
		this._minimum = value;
		this.dispatchEventWith(CollectionEventType.RESET);
		this.dispatchEventWith(Event.CHANGE);
	}

	protected var _maximum:int;

	public function get maximum():int
	{
		return this._maximum;
	}

	public function set maximum(value:int):void
	{
		if(this._maximum === value)
		{
			return;
		}
		this._maximum = value;
		this.dispatchEventWith(CollectionEventType.RESET);
		this.dispatchEventWith(Event.CHANGE);
	}

	protected var _step:int;

	public function get step():int
	{
		return this._step;
	}

	public function set step(value:int):void
	{
		if(this._step === value)
		{
			return;
		}
		this._step = value;
		this.dispatchEventWith(CollectionEventType.RESET);
		this.dispatchEventWith(Event.CHANGE);
	}

	public function get filterFunction():Function
	{
		return null;
	}

	public function set filterFunction(value:Function):void
	{
		throw new Error("Not implemented");
	}

	public function get sortCompareFunction():Function
	{
		return null;
	}

	public function set sortCompareFunction(value:Function):void
	{
		throw new Error("Not implemented");
	}

	public function get data():Object
	{
		return null;
	}

	public function set data(value:Object):void
	{
		throw new Error("Not implemented");
	}

	public function get length():int
	{
		return 1 + int((this._maximum - this._minimum) / this._step);
	}

	public function getItemAt(index:int):Object
	{
		var maximum:int = this._maximum;
		var result:int = this._minimum + index * this._step;
		if(result > maximum)
		{
			result = maximum;
		}
		return result;
	}

	public function contains(item:Object):Boolean
	{
		if(!(item is int))
		{
			return false;
		}
		var value:int = item as int;
		return Math.ceil((value - this._minimum) / this._step) !== -1;
	}

	public function getItemIndex(item:Object):int
	{
		if(!(item is int))
		{
			return -1;
		}
		var value:int = item as int;
		return Math.ceil((value - this._minimum) / this._step);
	}

	public function refreshFilter():void
	{
		throw new Error("Not implemented");
	}

	public function refresh():void
	{
		throw new Error("Not implemented");
	}

	public function setItemAt(item:Object, index:int):void
	{
		throw new Error("Not implemented");
	}

	public function addItem(item:Object):void
	{
		throw new Error("Not implemented");
	}

	public function addItemAt(item:Object, index:int):void
	{
		throw new Error("Not implemented");
	}

	public function push(item:Object):void
	{
		throw new Error("Not implemented");
	}

	public function shift():Object
	{
		throw new Error("Not implemented");
	}

	public function removeItem(item:Object):void
	{
		throw new Error("Not implemented");
	}

	public function removeItemAt(index:int):Object
	{
		throw new Error("Not implemented");
	}

	public function unshift(item:Object):void
	{
		throw new Error("Not implemented");
	}

	public function removeAll():void
	{
		throw new Error("Not implemented");
	}

	public function pop():Object
	{
		throw new Error("Not implemented");
	}

	public function addAll(collection:IListCollection):void
	{
		throw new Error("Not implemented");
	}

	public function addAllAt(collection:IListCollection, index:int):void
	{
		throw new Error("Not implemented");
	}

	public function reset(collection:IListCollection):void
	{
		throw new Error("Not implemented");
	}

	public function updateItemAt(index:int):void
	{
		this.dispatchEventWith(CollectionEventType.UPDATE_ITEM, false, index);
	}

	public function updateAll():void
	{
		this.dispatchEventWith(CollectionEventType.UPDATE_ALL);
	}

	public function dispose(callback:Function):void
	{
		throw new Error("Not implemented");
	}
}
