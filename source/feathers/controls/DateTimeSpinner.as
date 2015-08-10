/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.LayoutGroup;
	import feathers.controls.SpinnerList;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;

	import flash.globalization.DateTimeFormatter;
	import flash.globalization.DateTimeNameStyle;
	import flash.globalization.DateTimeStyle;

	import starling.events.Event;

	public class DateTimeSpinner extends FeathersControl
	{
		/**
		 * @see #editingMode
		 */
		public static const EDITING_MODE_DATE_AND_TIME:String = "dateAndTime";

		/**
		 * @see #editingMode
		 */
		public static const EDITING_MODE_TIME:String = "time";

		/**
		 * @see #editingMode
		 */
		public static const EDITING_MODE_DATE:String = "date";

		/**
		 * @private
		 */
		private static const DEFAULT_MINIMUM_YEAR:int = 1601;

		/**
		 * @private
		 */
		private static const DEFAULT_MAXIMUM_YEAR:int = 9999;

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
		 * Constructor.
		 */
		public function DateTimeSpinner()
		{
			super();
			if(DAYS_IN_MONTH.length === 0)
			{
				HELPER_DATE.setFullYear(DEFAULT_MAXIMUM_YEAR);
				for(var i:int = 0; i < 12; i++)
				{
					//subtract one date from the 1st of next month to figure out
					//the last date of the current month
					HELPER_DATE.setMonth(i + 1, -1);
					DAYS_IN_MONTH[i] = HELPER_DATE.date + 1;
				}
				DAYS_IN_MONTH.fixed = true;
			}
		}

		protected var monthsList:SpinnerList;
		protected var datesList:SpinnerList;
		protected var yearsList:SpinnerList;
		protected var hoursList:SpinnerList;
		protected var minutesList:SpinnerList;
		protected var ampmList:SpinnerList;
		protected var listGroup:LayoutGroup;

		/**
		 * @private
		 */
		protected var _locale:String = "en_US";

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
		protected var _value:Date = new Date();

		public function get value():Date
		{
			return this._value;
		}

		/**
		 * @private
		 */
		public function set value(value:Date):void
		{
			if(this._value == value)
			{
				return;
			}
			this._value = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _minimum:Date;

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

		public function get minuteStep():int
		{
			return this._minuteStep;
		}

		/**
		 * @private
		 */
		public function set minuteStep(value:int):void
		{
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
		protected var _editingMode:String = EDITING_MODE_DATE;

		/**
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
		protected var _ampm:Boolean = true;

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
		protected var _minHour:int;

		/**
		 * @private
		 */
		protected var _maxHour:int;

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
		override protected function initialize():void
		{
			if(!this.listGroup)
			{
				var groupLayout:HorizontalLayout = new HorizontalLayout();
				groupLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
				groupLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_JUSTIFY;
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
			
			if(localeInvalid || editingModeInvalid)
			{
				this.refreshLocale();
			}
			
			if(localeInvalid || editingModeInvalid || dataInvalid)
			{
				this.refreshLists();
				this.refreshValidRanges();
				this.refreshSelection();
			}
			
			this.autoSizeIfNeeded();

			this.listGroup.width = this.actualWidth;
			this.listGroup.height = this.actualHeight;
			this.listGroup.validate();
		}

		/**
		 * @private
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			var needsWidth:Boolean = this.explicitWidth !== this.explicitWidth; //isNaN
			var needsHeight:Boolean = this.explicitHeight !== this.explicitHeight; //isNaN
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			
			this.listGroup.width = this.explicitWidth;
			this.listGroup.height = this.explicitHeight;
			this.listGroup.validate();
			return this.setSizeInternal(this.listGroup.width, this.listGroup.height, false);
		}

		/**
		 * @private
		 */
		protected function refreshLists():void
		{
			if(this._editingMode == EDITING_MODE_DATE)
			{
				//first, get rid of lists that we don't need for this mode
				if(this.hoursList)
				{
					this.listGroup.removeChild(this.hoursList, true);
					this.hoursList = null;
				}
				if(this.minutesList)
				{
					this.listGroup.removeChild(this.minutesList, true);
					this.minutesList = null;
				}
				if(this.ampmList)
				{
					this.listGroup.removeChild(this.ampmList, true);
					this.ampmList = null;
				}
				
				//next, create the lists that we need, if they don't exist yet
				if(!this.yearsList)
				{
					this.yearsList = new SpinnerList();
					//we'll set the data provider later, when we know what range
					//of years we need
					this.yearsList.itemRendererFactory = this.yearsListItemRendererFactory;
					this.yearsList.addEventListener(Event.CHANGE, yearsList_changeHandler);
					this.listGroup.addChild(this.yearsList);
				}
				if(!this.datesList)
				{
					this.datesList = new SpinnerList();
					var datesRange:IntegerRange = new IntegerRange(1, 31, 1);
					var datesCollection:ListCollection = new ListCollection(datesRange);
					datesCollection.dataDescriptor = new IntegerRangeDataDescriptor();
					this.datesList.dataProvider = datesCollection;
					this.datesList.itemRendererFactory = this.datesListItemRendererFactory;
					this.datesList.addEventListener(Event.CHANGE, datesList_changeHandler);
					this.listGroup.addChildAt(this.datesList, 0);
				}
				if(!this.monthsList)
				{
					this.monthsList = new SpinnerList();
					var monthsRange:IntegerRange = new IntegerRange(0, 11, 1);
					var monthsCollection:ListCollection = new ListCollection(monthsRange);
					monthsCollection.dataDescriptor = new IntegerRangeDataDescriptor();
					this.monthsList.dataProvider = monthsCollection;
					this.monthsList.itemRendererFactory = this.monthsListItemRendererFactory;
					this.monthsList.addEventListener(Event.CHANGE, monthsList_changeHandler);
					this.listGroup.addChildAt(this.monthsList, 0);
				}
				
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
			else if(this._editingMode === EDITING_MODE_TIME)
			{
				if(this.monthsList)
				{
					this.listGroup.removeChild(this.monthsList, true);
					this.monthsList = null;
				}
				if(this.datesList)
				{
					this.listGroup.removeChild(this.datesList, true);
					this.datesList = null;
				}
				if(this.yearsList)
				{
					this.listGroup.removeChild(this.yearsList, true);
					this.yearsList = null;
				}
				
				if(!this.hoursList)
				{
					this.hoursList = new SpinnerList();
					this.hoursList.itemRendererFactory = this.hoursListItemRendererFactory;
					this.hoursList.addEventListener(Event.CHANGE, hoursList_changeHandler);
					this.listGroup.addChild(this.hoursList);
				}
				if(!this.minutesList)
				{
					this.minutesList = new SpinnerList();
					var minutesRange:IntegerRange = new IntegerRange(0, 59, this._minuteStep);
					var minutesCollection:ListCollection = new ListCollection(minutesRange);
					minutesCollection.dataDescriptor = new IntegerRangeDataDescriptor();
					this.minutesList.dataProvider = minutesCollection;
					this.minutesList.itemRendererFactory = this.minutesListItemRendererFactory;
					this.minutesList.addEventListener(Event.CHANGE, minutesList_changeHandler);
					this.listGroup.addChild(this.minutesList);
				}
				
				//does this locale use a 12 or 24 hour time format?
				if(this._ampm) //12 hour format
				{
					if(!this.ampmList)
					{
						this.ampmList = new SpinnerList();
						this.ampmList.addEventListener(Event.CHANGE, ampmList_changeHandler);
						this.listGroup.addChild(this.ampmList);
					}
				}
				else if(this.ampmList)
				{
					this.listGroup.removeChild(this.ampmList, true);
					this.ampmList = null;
				}
			}
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
				this._ampm = dateTimePattern.indexOf("a") >= 0;
			}
			if(this._editingMode === EDITING_MODE_DATE)
			{
				this._localeMonthNames = this._formatter.getMonthNames(DateTimeNameStyle.FULL);
				this._localeWeekdayNames = null;
			}
			else if(this._editingMode === EDITING_MODE_DATE_AND_TIME)
			{
				this._localeMonthNames = this._formatter.getMonthNames(DateTimeNameStyle.SHORT_ABBREVIATION);
				this._localeWeekdayNames = this._formatter.getWeekdayNames(DateTimeNameStyle.SHORT_ABBREVIATION);
			}
			else //time only
			{
				this._localeMonthNames = null;
				this._localeWeekdayNames = null;
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
				var listMinYear:int = this._minYear;
				var listMaxYear:int = this._maxYear;
				if(listMinYear > DEFAULT_MINIMUM_YEAR)
				{
					listMinYear = DEFAULT_MINIMUM_YEAR;
				}
				if(listMaxYear < DEFAULT_MAXIMUM_YEAR)
				{
					listMaxYear = DEFAULT_MAXIMUM_YEAR;
				}
				var yearsCollection:ListCollection = this.yearsList.dataProvider;
				if(yearsCollection)
				{
					var yearRange:IntegerRange = IntegerRange(yearsCollection.data);
					if(yearRange.minimum !== listMinYear || yearRange.minimum !== listMinYear)
					{
						yearRange.minimum = listMinYear;
						yearRange.maximum = listMinYear;
						yearsCollection.data = null;
						yearsCollection.data = yearRange;
					}
				}
				else
				{
					yearRange = new IntegerRange(listMinYear, listMaxYear, 1);
					yearsCollection = new ListCollection(yearRange);
					yearsCollection.dataDescriptor = new IntegerRangeDataDescriptor();
					this.yearsList.dataProvider = yearsCollection;
				}
			}
			else if(this._editingMode === EDITING_MODE_TIME)
			{
				if(this._ampm)
				{
					var hoursRange:IntegerRange = new IntegerRange(0, 11, 1);
				}
				else
				{
					hoursRange = new IntegerRange(0, 23, 1);
				}
				var hoursCollection:ListCollection = new ListCollection(hoursRange);
				hoursCollection.dataDescriptor = new IntegerRangeDataDescriptor();
				this.hoursList.dataProvider = hoursCollection;
				
				if(this._ampm)
				{
					this.ampmList.dataProvider = new ListCollection(new <String>["am", "pm"]);
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

			if(this.hoursList)
			{
				if(this._ampm)
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
			if(this.ampmList)
			{
				this.ampmList.selectedIndex = (this._value.hours < 12) ? 0 : 1;
			}
			this._ignoreListChanges = oldIgnoreListChanges;
		}

		/**
		 * @private
		 */
		protected function refreshValidRanges():void
		{
			if(!this._minimum)
			{
				this._minimum = new Date(DEFAULT_MINIMUM_YEAR, 0, 1, 0, 0);
			}
			if(!this._maximum)
			{
				var minimumYear:int = this._minimum.fullYear;
				if(minimumYear > DEFAULT_MAXIMUM_YEAR)
				{
					this._maximum = new Date(minimumYear, 11, 31, 11, 59);
				}
				else
				{
					this._maximum = new Date(DEFAULT_MAXIMUM_YEAR, 11, 31, 11, 59);
				}
			}
			
			var oldMinYear:int = this._minYear;
			var oldMaxYear:int = this._maxYear;
			var oldMinMonth:int = this._minMonth;
			var oldMaxMonth:int = this._maxMonth;
			var oldMinDate:int = this._minDate;
			var oldMaxDate:int = this._maxDate;
			var oldMinHour:int = this._minHour;
			var oldMaxHour:int = this._maxHour;
			var oldMinMinute:int = this._minMinute;
			var oldMaxMinute:int = this._maxMinute;
			var currentYear:int = this._value.fullYear;
			var currentMonth:int = this._value.month;
			var currentHour:int = this._value.hours;
			this._minYear = this._minimum.fullYear;
			this._maxYear = this._maximum.fullYear;
			if(currentYear === this._minYear)
			{
				this._minMonth = this._minimum.month;
			}
			else
			{
				this._minMonth = 0;
			}
			if(currentYear === this._maxYear)
			{
				this._maxMonth = this._maximum.month;
			}
			else
			{
				this._maxMonth = 11;
			}
			if(currentYear === this._minYear && currentMonth === this._minimum.month)
			{
				this._minDate = this._minimum.date;
			}
			else
			{
				this._minDate = 1;
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
			this._minHour = this._minimum.hours;
			this._maxHour = this._maximum.hours;
			if(currentHour === this._minHour)
			{
				this._minMinute = this._minimum.minutes;
			}
			else
			{
				this._minMinute = 0;
			}
			if(currentHour === this._maxHour)
			{
				this._maxMinute = this._maximum.minutes;
			}
			else
			{
				this._maxMinute = 59;
			}

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
			var hoursCollection:ListCollection = this.hoursList ? this.hoursList.dataProvider : null;
			if(hoursCollection && (oldMinHour !== this._minHour || oldMaxHour!== this._maxHour))
			{
				hoursCollection.updateAll();
			}
			var minutesCollection:ListCollection = this.minutesList ? this.minutesList.dataProvider : null;
			if(minutesCollection && (oldMinMinute !== this._minMinute || oldMaxMinute!== this._maxMinute))
			{
				minutesCollection.updateAll();
			}
		}

		/**
		 * @private
		 */
		protected function minutesListItemRendererFactory():DefaultListItemRenderer
		{
			var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
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
			var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			itemRenderer.labelFunction = formatHours;
			itemRenderer.enabledFunction = isHourEnabled;
			itemRenderer.itemHasEnabled = true;
			return itemRenderer;
		}

		/**
		 * @private
		 */
		protected function monthsListItemRendererFactory():DefaultListItemRenderer
		{
			var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
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
			var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			itemRenderer.enabledFunction = isDateEnabled;
			itemRenderer.itemHasEnabled = true;
			return itemRenderer;
		}

		/**
		 * @private
		 */
		protected function yearsListItemRendererFactory():DefaultListItemRenderer
		{
			var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
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
			return hour >= this._minHour && hour <= this._maxHour;
		}

		/**
		 * @private
		 */
		protected function isMinuteEnabled(minute:int):Boolean
		{
			var currentHour:int = this._value.hours;
			if(currentHour === this._minHour)
			{
				if(currentHour === this._maxHour)
				{
					return minute >= this._minMinute && minute <= this._maxMinute;
				}
				return minute >= this._minMinute;
			}
			if(currentHour === this._maxHour)
			{
				return minute <= this._maxMinute;
			}
			return true;
		}

		/**
		 * @private
		 */
		protected function formatHours(item:int):String
		{
			if(this._ampm)
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
			if(currentTime < minimumTime)
			{
				this._value.setTime(minimumTime);
			}
			else if(currentTime > maximumTime)
			{
				this._value.setTime(maximumTime);
			}
			if(this.yearsList)
			{
				var year:int = this._value.fullYear;
				if(this.yearsList.selectedItem !== year)
				{
					var yearRange:IntegerRange = IntegerRange(this.yearsList.dataProvider.data);
					this.yearsList.scrollToDisplayIndex(year - yearRange.minimum, this.yearsList.pageThrowDuration);
				}
			}
			if(this.monthsList)
			{
				var month:int = this._value.month;
				if(this.monthsList.selectedItem !== month)
				{
					this.monthsList.scrollToDisplayIndex(month, this.monthsList.pageThrowDuration);
				}
			}
			if(this.datesList)
			{
				var date:int = this._value.date;
				if(this.datesList.selectedItem !== date)
				{
					this.datesList.scrollToDisplayIndex(date - 1, this.datesList.pageThrowDuration);
				}
			}
			if(this.hoursList)
			{
				var hours:int = this._value.hours;
				if(this._ampm)
				{
					hours %= 12;
				}
				if(this.hoursList.selectedItem !== hours)
				{
					this.hoursList.scrollToDisplayIndex(hours, this.hoursList.pageThrowDuration);
				}
			}
			if(this.minutesList)
			{
				var minutes:int = this._value.minutes;
				if(this.minutesList.selectedItem !== minutes)
				{
					this.minutesList.scrollToDisplayIndex(minutes, this.minutesList.pageThrowDuration);
				}
			}
			if(this.ampmList)
			{
				var index:int = (this._value.hours < 12) ? 0 : 1;
				if(this.ampmList.selectedIndex !== index)
				{
					this.ampmList.scrollToDisplayIndex(index, this.minutesList.pageThrowDuration);
				}
			}
		}

		/**
		 * @private
		 */
		protected function updateHoursFromLists():void
		{
			var hours:int = this.hoursList.selectedItem as int;
			if(this.ampmList && this.ampmList.selectedIndex === 1)
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
		protected function ampmList_changeHandler(event:Event):void
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
		return 1 + Math.ceil((range.maximum - range.minimum) / range.step);
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