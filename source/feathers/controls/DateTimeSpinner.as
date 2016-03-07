/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalAlign;
	import feathers.skins.IStyleProvider;
	import feathers.utils.math.roundDownToNearest;
	import feathers.utils.math.roundUpToNearest;

	import flash.globalization.DateTimeFormatter;
	import flash.globalization.DateTimeNameStyle;
	import flash.globalization.DateTimeStyle;
	import flash.globalization.LocaleID;

	import starling.events.Event;

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
	 * spinner.editingMode = DateTimeSpinner.EDITING_MODE_DATE;
	 * spinner.minimum = new Date(1970, 0, 1);
	 * spinner.maximum = new Date(2050, 11, 31);
	 * spinner.value = new Date();
	 * spinner.addEventListener( Event.CHANGE, spinner_changeHandler );
	 * this.addChild( spinner );</listing>
	 *
	 * @see ../../../help/date-time-spinner.html How to use the Feathers DateTimeSpinner component
	 */
	public class DateTimeSpinner extends FeathersControl
	{
		/**
		 * The default name to use with lists.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_LIST:String = "feathers-date-time-spinner-list";
		
		/**
		 * The <code>DateTimeSpinner</code> will allow both the date and the
		 * time to be edited.
		 * 
		 * @see #editingMode
		 */
		public static const EDITING_MODE_DATE_AND_TIME:String = "dateAndTime";

		/**
		 * The <code>DateTimeSpinner</code> will allow only the time to be
		 * edited.
		 * 
		 * @see #editingMode
		 */
		public static const EDITING_MODE_TIME:String = "time";

		/**
		 * The <code>DateTimeSpinner</code> will allow only the date to be
		 * edited.
		 * 
		 * @see #editingMode
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
		 * @see #customListStyleName
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
		protected var _editingMode:String = EDITING_MODE_DATE_AND_TIME;

		/**
		 * Determines which parts of the <code>Date</code> value may be edited.
		 * 
		 * @default DateTimeSpinner.EDITING_MODE_DATE_AND_TIME
		 * 
		 * @see #EDITING_MODE_DATE_AND_TIME
		 * @see #EDITING_MODE_DATE
		 * @see #EDITING_MODE_TIME
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
		public function get scrollDuration():Number
		{
			return this._scrollDuration;
		}

		/**
		 * @private
		 */
		public function set scrollDuration(value:Number):void
		{
			this._scrollDuration = value;
		}

		/**
		 * @private
		 */
		protected var _itemRendererFactory:Function;

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
		 * property of the <code>SpinnerList</code> should not be set in the
		 * <code>listFactory</code>. Instead, set the
		 * <code>itemRendererFactory</code> property of the
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
		 * A style name to add to the date time spinner's list sub-components.
		 * Typically used by a theme to provide different styles to different
		 * date time spinners.
		 *
		 * <p>In the following example, a custom list style name is passed to
		 * the date time spijnner:</p>
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
		public function get customListStyleName():String
		{
			return this._customListStyleName;
		}

		/**
		 * @private
		 */
		public function set customListStyleName(value:String):void
		{
			if(this._customListStyleName == value)
			{
				return;
			}
			this._customListStyleName = value;
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
		 * is set to <code>DateTimeSpinner.EDITING_MODE_DATE_AND_TIME</code> the
		 * date matching today's current date will display this label instead
		 * of the date.
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
		 * <p>In the following example, we scroll to a specific date with
		 * animation of 1.5 seconds:</p>
		 *
		 * <listing version="3.0">
		 * spinner.scrollToDate( new Date(2016, 0, 1), 1.5 );</listing>
		 * 
		 * @see #scrollDuration
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
		override protected function initialize():void
		{
			if(!this.listGroup)
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
			var editingModeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_EDITING_MODE);
			var localeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LOCALE);
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var pendingScrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_PENDING_SCROLL);
			var spinnerListFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SPINNER_LIST_FACTORY);
			
			if(this._todayLabel)
			{
				this._lastValidate = new Date();
			}
			
			if(localeInvalid || editingModeInvalid)
			{
				this.refreshLocale();
			}
			
			if(localeInvalid || editingModeInvalid || spinnerListFactoryInvalid)
			{
				this.refreshLists(editingModeInvalid || spinnerListFactoryInvalid);
			}

			if(localeInvalid || editingModeInvalid || dataInvalid || spinnerListFactoryInvalid)
			{
				this.useDefaultsIfNeeded();
				this.refreshValidRanges();
				this.refreshSelection();
			}
			
			this.autoSizeIfNeeded();

			this.listGroup.width = this.actualWidth;
			this.listGroup.height = this.actualHeight;
			this.listGroup.validate();

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
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			
			this.listGroup.width = this._explicitWidth;
			this.listGroup.height = this._explicitHeight;
			this.listGroup.validate();
			return this.setSizeInternal(this.listGroup.width, this.listGroup.height, false);
		}

		/**
		 * @private
		 */
		protected function refreshLists(createNewLists:Boolean):void
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
			
			if(this._editingMode == EDITING_MODE_DATE)
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
			
			if(this._editingMode !== EDITING_MODE_DATE)
			{
				return;
			}

			var listFactory:Function = (this._listFactory !== null) ? this._listFactory : defaultListFactory;
			this.yearsList = SpinnerList(listFactory());
			var listStyleName:String = (this._customListStyleName !== null) ? this._customListStyleName : this.listStyleName;
			this.yearsList.styleNameList.add(listStyleName);
			//we'll set the data provider later, when we know what range
			//of years we need
			this.yearsList.itemRendererFactory = this.yearsListItemRendererFactory;
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

			if(this._editingMode !== EDITING_MODE_DATE)
			{
				return;
			}

			var listFactory:Function = (this._listFactory !== null) ? this._listFactory : defaultListFactory;
			this.monthsList = SpinnerList(listFactory());
			var listStyleName:String = (this._customListStyleName !== null) ? this._customListStyleName : this.listStyleName;
			this.monthsList.styleNameList.add(listStyleName);
			var monthsRange:IntegerRange = new IntegerRange(MIN_MONTH_VALUE, MAX_MONTH_VALUE, 1);
			var monthsCollection:ListCollection = new ListCollection(monthsRange);
			monthsCollection.dataDescriptor = new IntegerRangeDataDescriptor();
			this.monthsList.dataProvider = monthsCollection;
			this.monthsList.typicalItem = this._longestMonthNameIndex;
			this.monthsList.itemRendererFactory = this.monthsListItemRendererFactory;
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

			if(this._editingMode !== EDITING_MODE_DATE)
			{
				return;
			}

			var listFactory:Function = (this._listFactory !== null) ? this._listFactory : defaultListFactory;
			this.datesList = SpinnerList(listFactory());
			var listStyleName:String = (this._customListStyleName !== null) ? this._customListStyleName : this.listStyleName;
			this.datesList.styleNameList.add(listStyleName);
			var datesRange:IntegerRange = new IntegerRange(MIN_DATE_VALUE, MAX_DATE_VALUE, 1);
			var datesCollection:ListCollection = new ListCollection(datesRange);
			datesCollection.dataDescriptor = new IntegerRangeDataDescriptor();
			this.datesList.dataProvider = datesCollection;
			this.datesList.itemRendererFactory = this.datesListItemRendererFactory;
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

			if(this._editingMode === EDITING_MODE_DATE)
			{
				return;
			}

			var listFactory:Function = (this._listFactory !== null) ? this._listFactory : defaultListFactory;
			this.hoursList = SpinnerList(listFactory());
			var listStyleName:String = (this._customListStyleName !== null) ? this._customListStyleName : this.listStyleName;
			this.hoursList.styleNameList.add(listStyleName);
			this.hoursList.itemRendererFactory = this.hoursListItemRendererFactory;
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

			if(this._editingMode === EDITING_MODE_DATE)
			{
				return;
			}

			var listFactory:Function = (this._listFactory !== null) ? this._listFactory : defaultListFactory;
			this.minutesList = SpinnerList(listFactory());
			var listStyleName:String = (this._customListStyleName !== null) ? this._customListStyleName : this.listStyleName;
			this.minutesList.styleNameList.add(listStyleName);
			var minutesRange:IntegerRange = new IntegerRange(MIN_MINUTES_VALUE, MAX_MINUTES_VALUE, this._minuteStep);
			var minutesCollection:ListCollection = new ListCollection(minutesRange);
			minutesCollection.dataDescriptor = new IntegerRangeDataDescriptor();
			this.minutesList.dataProvider = minutesCollection;
			this.minutesList.itemRendererFactory = this.minutesListItemRendererFactory;
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

			if(this._editingMode === EDITING_MODE_DATE || !this._showMeridiem)
			{
				return;
			}

			var listFactory:Function = (this._listFactory !== null) ? this._listFactory : defaultListFactory;
			this.meridiemList = SpinnerList(listFactory());
			var listStyleName:String = (this._customListStyleName !== null) ? this._customListStyleName : this.listStyleName;
			this.meridiemList.styleNameList.add(listStyleName);
			this.meridiemList.itemRendererFactory = this.meridiemListItemRendererFactory;
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

			if(this._editingMode !== EDITING_MODE_DATE_AND_TIME)
			{
				return;
			}

			var listFactory:Function = (this._listFactory !== null) ? this._listFactory : defaultListFactory;
			this.dateAndTimeDatesList = SpinnerList(listFactory());
			var listStyleName:String = (this._customListStyleName !== null) ? this._customListStyleName : this.listStyleName;
			this.dateAndTimeDatesList.styleNameList.add(listStyleName);
			this.dateAndTimeDatesList.itemRendererFactory = this.dateAndTimeDatesListItemRendererFactory;
			this.dateAndTimeDatesList.addEventListener(Event.CHANGE, dateAndTimeDatesList_changeHandler);
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
				this._showMeridiem = dateTimePattern.indexOf("a") >= 0;
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
			if(this._editingMode === EDITING_MODE_DATE)
			{
				this._localeMonthNames = this._formatter.getMonthNames(DateTimeNameStyle.FULL);
				this._localeWeekdayNames = null;
			}
			else if(this._editingMode === EDITING_MODE_DATE_AND_TIME)
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
			
			if(this._editingMode === EDITING_MODE_DATE)
			{
				var yearsCollection:ListCollection = this.yearsList.dataProvider;
				if(yearsCollection)
				{
					var yearRange:IntegerRange = IntegerRange(yearsCollection.data);
					if(yearRange.minimum !== this._listMinYear || yearRange.minimum !== this._listMinYear)
					{
						yearRange.minimum = this._listMinYear;
						yearRange.maximum = this._listMinYear;
						yearsCollection.data = null;
						yearsCollection.data = yearRange;
					}
				}
				else
				{
					yearRange = new IntegerRange(this._listMinYear, this._listMaxYear, 1);
					yearsCollection = new ListCollection(yearRange);
					yearsCollection.dataDescriptor = new IntegerRangeDataDescriptor();
					this.yearsList.dataProvider = yearsCollection;
				}
			}
			else //time only or both date and time
			{
				var totalMS:Number = this._maximum.time - this._minimum.time;
				var totalDays:int = totalMS / MS_PER_DAY;

				if(this._editingMode === EDITING_MODE_DATE_AND_TIME)
				{
					var dateAndTimeDatesCollection:ListCollection = this.dateAndTimeDatesList.dataProvider;
					if(dateAndTimeDatesCollection)
					{
						var datesRange:IntegerRange = IntegerRange(dateAndTimeDatesCollection.data);
						if(datesRange.maximum !== totalDays)
						{
							datesRange.maximum = totalDays;
							dateAndTimeDatesCollection.data = null;
							dateAndTimeDatesCollection.data = datesRange;
						}
					}
					else
					{
						datesRange = new IntegerRange(0, totalDays, 1);
						dateAndTimeDatesCollection = new ListCollection(datesRange);
						dateAndTimeDatesCollection.dataDescriptor = new IntegerRangeDataDescriptor();
						this.dateAndTimeDatesList.dataProvider = dateAndTimeDatesCollection;
					}
				}

				var hoursMinimum:Number = MIN_HOURS_VALUE;
				var hoursMaximum:Number = this._showMeridiem ? MAX_HOURS_VALUE_12HOURS : MAX_HOURS_VALUE_24HOURS;
				var hoursCollection:ListCollection = this.hoursList.dataProvider;
				if(hoursCollection)
				{
					var hoursRange:IntegerRange = IntegerRange(hoursCollection.data);
					if(hoursRange.minimum !== hoursMinimum || hoursRange.maximum !== hoursMaximum)
					{
						hoursRange.minimum = hoursMinimum;
						hoursRange.maximum = hoursMaximum;
						hoursCollection.data = null;
						hoursCollection.data = datesRange;
					}
				}
				else
				{
					hoursRange = new IntegerRange(hoursMinimum, hoursMaximum, 1);
					hoursCollection = new ListCollection(hoursRange);
					hoursCollection.dataDescriptor = new IntegerRangeDataDescriptor();
					this.hoursList.dataProvider = hoursCollection;
				}
				
				if(this._showMeridiem && !this.meridiemList.dataProvider)
				{
					this.meridiemList.dataProvider = new ListCollection(new <String>[this._amString, this._pmString]);
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
			if(this._editingMode === EDITING_MODE_DATE_AND_TIME)
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
			
			var yearsCollection:ListCollection = this.yearsList ? this.yearsList.dataProvider : null;
			if(yearsCollection && (oldMinYear !== this._minYear || oldMaxYear !== this._maxYear))
			{
				//we need to ensure that the item renderers are enabled
				yearsCollection.updateAll();
			}
			var monthsCollection:ListCollection = this.monthsList ? this.monthsList.dataProvider : null;
			if(monthsCollection && (oldMinMonth !== this._minMonth || oldMaxMonth !== this._maxMonth))
			{
				monthsCollection.updateAll();
			}
			var datesCollection:ListCollection = this.datesList ? this.datesList.dataProvider : null;
			if(datesCollection && (oldMinDate !== this._minDate || oldMaxDate !== this._maxDate))
			{
				datesCollection.updateAll();
			}
			var dateAndTimeDatesCollection:ListCollection = this.dateAndTimeDatesList ? this.dateAndTimeDatesList.dataProvider : null;
			if(dateAndTimeDatesCollection &&
				(oldMinYear !== this._minYear || oldMaxYear !== this._maxYear ||
				oldMinMonth !== this._minMonth || oldMaxMonth !== this._maxMonth ||
				oldMinDate !== this._minDate || oldMaxDate !== this._maxDate))
			{
				dateAndTimeDatesCollection.updateAll();
			}
			var hoursCollection:ListCollection = this.hoursList ? this.hoursList.dataProvider : null;
			if(hoursCollection && (oldMinHours !== this._minHours || oldMaxHours !== this._maxHours ||
				(this._showMeridiem && this._lastMeridiemValue !== this.meridiemList.selectedIndex)))
			{
				hoursCollection.updateAll();
			}
			var minutesCollection:ListCollection = this.minutesList ? this.minutesList.dataProvider : null;
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
				if(this._editingMode === EDITING_MODE_DATE_AND_TIME)
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
			else if(this._editingMode === EDITING_MODE_DATE_AND_TIME)
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
				if(this._editingMode === EDITING_MODE_DATE_AND_TIME)
				{
					this._listMaxYear = this._maximum.fullYear + 1;
				}
				else
				{
					this._listMaxYear = this._maximum.fullYear + 10;
				}
			}
			else if(this._editingMode === EDITING_MODE_DATE_AND_TIME)
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
		protected function handlePendingScroll():void
		{
			if(!this.pendingScrollToDate)
			{
				return;
			}
			var duration:Number = this.pendingScrollDuration;
			if(duration !== duration) //isNaN
			{
				duration = this._scrollDuration;
			}
			if(this.yearsList)
			{
				var year:int = this.pendingScrollToDate.fullYear;
				if(this.yearsList.selectedItem !== year)
				{
					var yearRange:IntegerRange = IntegerRange(this.yearsList.dataProvider.data);
					this.yearsList.scrollToDisplayIndex(year - yearRange.minimum, duration);
				}
			}
			if(this.monthsList)
			{
				var month:int = this.pendingScrollToDate.month;
				if(this.monthsList.selectedItem !== month)
				{
					this.monthsList.scrollToDisplayIndex(month, duration);
				}
			}
			if(this.datesList)
			{
				var date:int = this.pendingScrollToDate.date;
				if(this.datesList.selectedItem !== date)
				{
					this.datesList.scrollToDisplayIndex(date - 1, duration);
				}
			}
			if(this.dateAndTimeDatesList)
			{
				var dateIndex:int = (this.pendingScrollToDate.time - this._minimum.time) / MS_PER_DAY;
				if(this.dateAndTimeDatesList.selectedIndex !== dateIndex)
				{
					this.dateAndTimeDatesList.scrollToDisplayIndex(dateIndex, duration);
				}
			}
			if(this.hoursList)
			{
				var hours:int = this.pendingScrollToDate.hours;
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
				var minutes:int = this.pendingScrollToDate.minutes;
				if(this.minutesList.selectedItem !== minutes)
				{
					this.minutesList.scrollToDisplayIndex(minutes, duration);
				}
			}
			if(this.meridiemList)
			{
				var index:int = (this.pendingScrollToDate.hours < MAX_HOURS_VALUE_12HOURS) ? 0 : 1;
				if(this.meridiemList.selectedIndex !== index)
				{
					this.meridiemList.scrollToDisplayIndex(index, duration);
				}
			}
		}

		/**
		 * @private
		 */
		protected function meridiemListItemRendererFactory():DefaultListItemRenderer
		{
			if(this._itemRendererFactory !== null)
			{
				var itemRenderer:DefaultListItemRenderer = DefaultListItemRenderer(this._itemRendererFactory());
			}
			else
			{
				itemRenderer = new DefaultListItemRenderer();
			}
			return itemRenderer;
		}

		/**
		 * @private
		 */
		protected function minutesListItemRendererFactory():DefaultListItemRenderer
		{
			if(this._itemRendererFactory !== null)
			{
				var itemRenderer:DefaultListItemRenderer = DefaultListItemRenderer(this._itemRendererFactory());
			}
			else
			{
				itemRenderer = new DefaultListItemRenderer();
			}
			itemRenderer.labelFunction = formatMinutes;
			itemRenderer.enabledFunction = isMinuteEnabled;
			itemRenderer.itemHasEnabled = true;
			return itemRenderer;
		}

		/**
		 * @private
		 */
		protected function hoursListItemRendererFactory():DefaultListItemRenderer
		{
			if(this._itemRendererFactory !== null)
			{
				var itemRenderer:DefaultListItemRenderer = DefaultListItemRenderer(this._itemRendererFactory());
			}
			else
			{
				itemRenderer = new DefaultListItemRenderer();
			}
			itemRenderer.labelFunction = formatHours;
			itemRenderer.enabledFunction = isHourEnabled;
			itemRenderer.itemHasEnabled = true;
			return itemRenderer;
		}

		/**
		 * @private
		 */
		protected function dateAndTimeDatesListItemRendererFactory():DefaultListItemRenderer
		{
			if(this._itemRendererFactory !== null)
			{
				var itemRenderer:DefaultListItemRenderer = DefaultListItemRenderer(this._itemRendererFactory());
			}
			else
			{
				itemRenderer = new DefaultListItemRenderer();
			}
			itemRenderer.labelFunction = formatDateAndTimeDate;
			itemRenderer.accessoryLabelFunction = formatDateAndTimeWeekday;
			return itemRenderer;
		}

		/**
		 * @private
		 */
		protected function monthsListItemRendererFactory():DefaultListItemRenderer
		{
			if(this._itemRendererFactory !== null)
			{
				var itemRenderer:DefaultListItemRenderer = DefaultListItemRenderer(this._itemRendererFactory());
			}
			else
			{
				itemRenderer = new DefaultListItemRenderer();
			}
			itemRenderer.labelFunction = formatMonthName;
			itemRenderer.enabledFunction = isMonthEnabled;
			itemRenderer.itemHasEnabled = true;
			return itemRenderer;
		}

		/**
		 * @private
		 */
		protected function datesListItemRendererFactory():DefaultListItemRenderer
		{
			if(this._itemRendererFactory !== null)
			{
				var itemRenderer:DefaultListItemRenderer = DefaultListItemRenderer(this._itemRendererFactory());
			}
			else
			{
				itemRenderer = new DefaultListItemRenderer();
			}
			itemRenderer.enabledFunction = isDateEnabled;
			itemRenderer.itemHasEnabled = true;
			return itemRenderer;
		}

		/**
		 * @private
		 */
		protected function yearsListItemRendererFactory():DefaultListItemRenderer
		{
			if(this._itemRendererFactory !== null)
			{
				var itemRenderer:DefaultListItemRenderer = DefaultListItemRenderer(this._itemRendererFactory());
			}
			else
			{
				itemRenderer = new DefaultListItemRenderer();
			}
			itemRenderer.enabledFunction = isYearEnabled;
			itemRenderer.itemHasEnabled = true;
			return itemRenderer;
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
		protected function formatDateAndTimeWeekday(item:int):String
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

		/**
		 * @private
		 */
		protected function formatDateAndTimeDate(item:int):String
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

import feathers.data.IListCollectionDataDescriptor;

class IntegerRange
{
	public function IntegerRange(minimum:int, maximum:int, step:int = 1)
	{
		this.minimum = minimum;
		this.maximum = maximum;
		this.step = step;
	}
	
	public var minimum:int;
	public var maximum:int;
	public var step:int;
}


class IntegerRangeDataDescriptor implements IListCollectionDataDescriptor
{
	public function getLength(data:Object):int
	{
		var range:IntegerRange = IntegerRange(data);
		return 1 + int((range.maximum - range.minimum) / range.step);
	}

	public function getItemAt(data:Object, index:int):Object
	{
		var range:IntegerRange = IntegerRange(data);
		var maximum:int = range.maximum;
		var result:int = range.minimum + index * range.step;
		if(result > maximum)
		{
			result = maximum;
		}
		return result;
	}

	public function setItemAt(data:Object, item:Object, index:int):void
	{
		throw "Not implemented";
	}

	public function addItemAt(data:Object, item:Object, index:int):void
	{
		throw "Not implemented";
	}

	public function removeItemAt(data:Object, index:int):Object
	{
		throw "Not implemented";
	}

	public function getItemIndex(data:Object, item:Object):int
	{
		var value:int = item as int;
		var range:IntegerRange = IntegerRange(data);
		return Math.ceil((value - range.minimum) / range.step);
	}

	public function removeAll(data:Object):void
	{
		throw "Not implemented";
	}
}