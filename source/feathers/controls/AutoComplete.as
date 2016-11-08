/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.popups.DropDownPopUpContentManager;
	import feathers.controls.popups.IPopUpContentManager;
	import feathers.core.PropertyProxy;
	import feathers.data.IAutoCompleteSource;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.skins.IStyleProvider;
	import feathers.utils.display.stageToStarling;

	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;

	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * A style name to add to the list sub-component of the
	 * <code>AutoComplete</code>. Typically used by a theme to provide
	 * different styles to different <code>AutoComplete</code> instances.
	 *
	 * <p>In the following example, a custom list style name is passed to the
	 * <code>AutoComplete</code>:</p>
	 *
	 * <listing version="3.0">
	 * input.customListStyleName = "my-custom-list";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to provide
	 * different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( List ).setFunctionForStyleName( "my-custom-list", setCustomListStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_LIST
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #listFactory
	 */
	[Style(name="customListStyleName",type="String")]

	/**
	 * A manager that handles the details of how to display the pop-up list.
	 *
	 * <p>In the following example, a pop-up content manager is provided:</p>
	 *
	 * <listing version="3.0">
	 * input.popUpContentManager = new CalloutPopUpContentManager();</listing>
	 *
	 * @default null
	 */
	[Style(name="popUpContentManager",type="feathers.controls.popups.IPopUpContentManager")]

	/**
	 * Dispatched when the pop-up list is opened.
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
	 * @eventType starling.events.Event.OPEN
	 */
	[Event(name="open",type="starling.events.Event")]

	/**
	 * Dispatched when the pop-up list is closed.
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
	 * @eventType starling.events.Event.CLOSE
	 */
	[Event(name="close",type="starling.events.Event")]

	/**
	 * A text input that provides a pop-up list with suggestions as you type.
	 *
	 * <p>The following example creates an <code>AutoComplete</code> with a
	 * local collection of suggestions:</p>
	 *
	 * <listing version="3.0">
	 * var input:AutoComplete = new AutoComplete();
	 * input.source = new LocalAutoCompleteSource( new ListCollection(new &lt;String&gt;
	 * [
	 *     "Apple",
	 *     "Banana",
	 *     "Cherry",
	 *     "Grape",
	 *     "Lemon",
	 *     "Orange",
	 *     "Watermelon"
	 * ]));
	 * this.addChild( input );</listing>
	 *
	 * @see ../../../help/auto-complete.html How to use the Feathers AutoComplete component
	 * @see feathers.controls.TextInput
	 */
	public class AutoComplete extends TextInput
	{
		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_LIST_FACTORY:String = "listFactory";

		/**
		 * The default value added to the <code>styleNameList</code> of the pop-up
		 * list.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_LIST:String = "feathers-auto-complete-list";

		/**
		 * The default <code>IStyleProvider</code> for all
		 * <code>AutoComplete</code> components. If <code>null</code>, falls
		 * back to using <code>TextInput.globalStyleProvider</code> instead.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * @private
		 */
		protected static function defaultListFactory():List
		{
			return new List();
		}

		/**
		 * Constructor.
		 */
		public function AutoComplete()
		{
			this.addEventListener(Event.CHANGE, autoComplete_changeHandler);
		}

		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * pop-up list. This variable is <code>protected</code> so that
		 * sub-classes can customize the list style name in their constructors
		 * instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_LIST</code>.
		 *
		 * <p>To customize the pop-up list name without subclassing, see
		 * <code>customListStyleName</code>.</p>
		 *
		 * @see #style:customListStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var listStyleName:String = DEFAULT_CHILD_STYLE_NAME_LIST;

		/**
		 * The list sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #listFactory
		 * @see #createList()
		 */
		protected var list:List;

		/**
		 * @private
		 */
		protected var _listCollection:ListCollection;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			if(AutoComplete.globalStyleProvider)
			{
				return AutoComplete.globalStyleProvider;
			}
			return TextInput.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _originalText:String;

		/**
		 * @private
		 */
		protected var _source:IAutoCompleteSource;

		/**
		 * The source of the suggestions that appear in the pop-up list.
		 *
		 * <p>In the following example, a source of suggestions is provided:</p>
		 *
		 * <listing version="3.0">
		 * input.source = new LocalAutoCompleteSource( new ListCollection(new &lt;String&gt;
		 * [
		 *     "Apple",
		 *     "Banana",
		 *     "Cherry",
		 *     "Grape",
		 *     "Lemon",
		 *     "Orange",
		 *     "Watermelon"
		 * ]));</listing>
		 * 
		 * @default null
		 */
		public function get source():IAutoCompleteSource
		{
			return this._source;
		}

		/**
		 * @private
		 */
		public function set source(value:IAutoCompleteSource):void
		{
			if(this._source == value)
			{
				return;
			}
			if(this._source)
			{
				this._source.removeEventListener(Event.COMPLETE, dataProvider_completeHandler);
			}
			this._source = value;
			if(this._source)
			{
				this._source.addEventListener(Event.COMPLETE, dataProvider_completeHandler);
			}
		}

		/**
		 * @private
		 */
		protected var _autoCompleteDelay:Number = 0.5;

		/**
		 * The time, in seconds, after the text has changed before requesting
		 * suggestions from the <code>IAutoCompleteSource</code>.
		 *
		 * <p>In the following example, the delay is changed to 1.5 seconds:</p>
		 *
		 * <listing version="3.0">
		 * input.autoCompleteDelay = 1.5;</listing>
		 *
		 * @default 0.5
		 *
		 * @see #source
		 */
		public function get autoCompleteDelay():Number
		{
			return this._autoCompleteDelay;
		}

		/**
		 * @private
		 */
		public function set autoCompleteDelay(value:Number):void
		{
			this._autoCompleteDelay = value;
		}

		/**
		 * @private
		 */
		protected var _minimumAutoCompleteLength:int = 2;

		/**
		 * The minimum number of entered characters required to request
		 * suggestions from the <code>IAutoCompleteSource</code>.
		 *
		 * <p>In the following example, the minimum number of characters is
		 * changed to <code>3</code>:</p>
		 *
		 * <listing version="3.0">
		 * input.minimumAutoCompleteLength = 3;</listing>
		 *
		 * @default 2
		 *
		 * @see #source
		 */
		public function get minimumAutoCompleteLength():Number
		{
			return this._minimumAutoCompleteLength;
		}

		/**
		 * @private
		 */
		public function set minimumAutoCompleteLength(value:Number):void
		{
			this._minimumAutoCompleteLength = value;
		}

		/**
		 * @private
		 */
		protected var _popUpContentManager:IPopUpContentManager;

		/**
		 * @private
		 */
		public function get popUpContentManager():IPopUpContentManager
		{
			return this._popUpContentManager;
		}

		/**
		 * @private
		 */
		public function set popUpContentManager(value:IPopUpContentManager):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._popUpContentManager === value)
			{
				return;
			}
			if(this._popUpContentManager is EventDispatcher)
			{
				var dispatcher:EventDispatcher = EventDispatcher(this._popUpContentManager);
				dispatcher.removeEventListener(Event.OPEN, popUpContentManager_openHandler);
				dispatcher.removeEventListener(Event.CLOSE, popUpContentManager_closeHandler);
			}
			this._popUpContentManager = value;
			if(this._popUpContentManager is EventDispatcher)
			{
				dispatcher = EventDispatcher(this._popUpContentManager);
				dispatcher.addEventListener(Event.OPEN, popUpContentManager_openHandler);
				dispatcher.addEventListener(Event.CLOSE, popUpContentManager_closeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _listFactory:Function;

		/**
		 * A function used to generate the pop-up list sub-component. The list
		 * must be an instance of <code>List</code>. This factory can be used to
		 * change properties on the list when it is first created. For instance,
		 * if you are skinning Feathers components without a theme, you might
		 * use this factory to set skins and other styles on the list.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():List</pre>
		 *
		 * <p>In the following example, a custom list factory is passed to the
		 * <code>AutoComplete</code>:</p>
		 *
		 * <listing version="3.0">
		 * input.listFactory = function():List
		 * {
		 *     var popUpList:List = new List();
		 *     popUpList.backgroundSkin = new Image( texture );
		 *     return popUpList;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.List
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
			this.invalidate(INVALIDATION_FLAG_LIST_FACTORY);
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
			this.invalidate(INVALIDATION_FLAG_LIST_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _listProperties:PropertyProxy;

		/**
		 * An object that stores properties for the auto-complete's pop-up list
		 * sub-component, and the properties will be passed down to the pop-up
		 * list when the auto-complete validates. For a list of available
		 * properties, refer to
		 * <a href="List.html"><code>feathers.controls.List</code></a>.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>listFactory</code> function
		 * instead of using <code>listProperties</code> will result in better
		 * performance.</p>
		 *
		 * <p>In the following example, the list properties are passed to the
		 * auto complete:</p>
		 *
		 * <listing version="3.0">
		 * input.listProperties.backgroundSkin = new Image( texture );</listing>
		 *
		 * @default null
		 *
		 * @see #listFactory
		 * @see feathers.controls.List
		 */
		public function get listProperties():Object
		{
			if(!this._listProperties)
			{
				this._listProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._listProperties;
		}

		/**
		 * @private
		 */
		public function set listProperties(value:Object):void
		{
			if(this._listProperties == value)
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
			if(this._listProperties)
			{
				this._listProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._listProperties = PropertyProxy(value);
			if(this._listProperties)
			{
				this._listProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _ignoreAutoCompleteChanges:Boolean = false;

		/**
		 * @private
		 */
		protected var _lastChangeTime:int = 0;

		/**
		 * @private
		 */
		protected var _listHasFocus:Boolean = false;

		/**
		 * @private
		 */
		protected var _triggered:Boolean = false;

		/**
		 * @private
		 */
		protected var _isOpenListPending:Boolean = false;

		/**
		 * @private
		 */
		protected var _isCloseListPending:Boolean = false;

		/**
		 * Opens the pop-up list, if it isn't already open.
		 */
		public function openList():void
		{
			this._isCloseListPending = false;
			if(this._popUpContentManager.isOpen)
			{
				return;
			}
			if(!this._isValidating && this.isInvalid())
			{
				this._isOpenListPending = true;
				return;
			}
			this._isOpenListPending = false;
			this._popUpContentManager.open(this.list, this);
			this.list.validate();
			if(this._focusManager)
			{
				this.stage.addEventListener(starling.events.KeyboardEvent.KEY_UP, stage_keyUpHandler);
			}
		}

		/**
		 * Closes the pop-up list, if it is open.
		 */
		public function closeList():void
		{
			this._isOpenListPending = false;
			if(!this._popUpContentManager.isOpen)
			{
				return;
			}
			if(!this._isValidating && this.isInvalid())
			{
				this._isCloseListPending = true;
				return;
			}
			if(this._listHasFocus)
			{
				this.list.dispatchEventWith(FeathersEventType.FOCUS_OUT);
			}
			this._isCloseListPending = false;
			this.list.validate();
			//don't clean up anything from openList() in closeList(). The list
			//may be closed by removing it from the PopUpManager, which would
			//result in closeList() never being called.
			//instead, clean up in the Event.REMOVED_FROM_STAGE listener.
			this._popUpContentManager.close();
		}

		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			this.source = null;
			if(this.list)
			{
				this.closeList();
				this.list.dispose();
				this.list = null;
			}
			if(this._popUpContentManager)
			{
				this._popUpContentManager.dispose();
				this._popUpContentManager = null;
			}
			super.dispose();
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			super.initialize();

			this._listCollection = new ListCollection();
			if(this._popUpContentManager === null)
			{
				//must pass to setter so that listeners are added
				this._popUpContentManager = new DropDownPopUpContentManager();
				this._popUpContentManager.addEventListener(Event.OPEN, popUpContentManager_openHandler);
				this._popUpContentManager.addEventListener(Event.CLOSE, popUpContentManager_closeHandler);
			}
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var listFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LIST_FACTORY);

			super.draw();

			if(listFactoryInvalid)
			{
				this.createList();
			}

			if(listFactoryInvalid || stylesInvalid)
			{
				this.refreshListProperties();
			}

			this.handlePendingActions();
		}

		/**
		 * Creates and adds the <code>list</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #list
		 * @see #listFactory
		 * @see #style:customListStyleName
		 */
		protected function createList():void
		{
			if(this.list)
			{
				this.list.removeFromParent(false);
				//disposing separately because the list may not have a parent
				this.list.dispose();
				this.list = null;
			}

			var factory:Function = this._listFactory != null ? this._listFactory : defaultListFactory;
			var listStyleName:String = this._customListStyleName != null ? this._customListStyleName : this.listStyleName;
			this.list = List(factory());
			this.list.focusOwner = this;
			this.list.isFocusEnabled = false;
			this.list.isChildFocusEnabled = false;
			this.list.styleNameList.add(listStyleName);
			this.list.addEventListener(Event.CHANGE, list_changeHandler);
			this.list.addEventListener(Event.TRIGGERED, list_triggeredHandler);
			this.list.addEventListener(TouchEvent.TOUCH, list_touchHandler);
			this.list.addEventListener(Event.REMOVED_FROM_STAGE, list_removedFromStageHandler);
		}

		/**
		 * @private
		 */
		protected function refreshListProperties():void
		{
			for(var propertyName:String in this._listProperties)
			{
				var propertyValue:Object = this._listProperties[propertyName];
				this.list[propertyName] = propertyValue;
			}
		}

		/**
		 * @private
		 */
		protected function handlePendingActions():void
		{
			if(this._isOpenListPending)
			{
				this.openList();
			}
			if(this._isCloseListPending)
			{
				this.closeList();
			}
		}

		/**
		 * @private
		 */
		override protected function focusInHandler(event:Event):void
		{
			//the priority here is 1 so that this listener is called before
			//starling's listener. we want to know the list's selected index
			//before the list changes it.
			var starling:Starling = stageToStarling(this.stage);
			starling.nativeStage.addEventListener(flash.events.KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler, false, 1, true);
			super.focusInHandler(event);
		}

		/**
		 * @private
		 */
		override protected function focusOutHandler(event:Event):void
		{
			var starling:Starling = stageToStarling(this.stage);
			starling.nativeStage.removeEventListener(flash.events.KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler);
			super.focusOutHandler(event);
		}

		/**
		 * @private
		 */
		protected function nativeStage_keyDownHandler(event:flash.events.KeyboardEvent):void
		{
			if(!this._popUpContentManager.isOpen)
			{
				return;
			}
			var isDown:Boolean = event.keyCode == Keyboard.DOWN;
			var isUp:Boolean = event.keyCode == Keyboard.UP;
			if(!isDown && !isUp)
			{
				return;
			}
			var oldSelectedIndex:int = this.list.selectedIndex;
			var lastIndex:int = this.list.dataProvider.length - 1;
			if(oldSelectedIndex < 0)
			{
				event.stopImmediatePropagation();
				this._originalText = this._text;
				if(isDown)
				{
					this.list.selectedIndex = 0;
				}
				else
				{
					this.list.selectedIndex = lastIndex;
				}
				this.list.scrollToDisplayIndex(this.list.selectedIndex, this.list.keyScrollDuration);
				this._listHasFocus = true;
				this.list.dispatchEventWith(FeathersEventType.FOCUS_IN);
			}
			else if((isDown && oldSelectedIndex == lastIndex) ||
				(isUp && oldSelectedIndex == 0))
			{
				event.stopImmediatePropagation();
				var oldIgnoreAutoCompleteChanges:Boolean = this._ignoreAutoCompleteChanges;
				this._ignoreAutoCompleteChanges = true;
				this.text = this._originalText;
				this._ignoreAutoCompleteChanges = oldIgnoreAutoCompleteChanges;
				this.list.selectedIndex = -1;
				this.selectRange(this.text.length, this.text.length);
				this._listHasFocus = false;
				this.list.dispatchEventWith(FeathersEventType.FOCUS_OUT);
			}
		}

		/**
		 * @private
		 */
		protected function autoComplete_changeHandler(event:Event):void
		{
			if(this._ignoreAutoCompleteChanges || !this._source || !this.hasFocus)
			{
				return;
			}
			if(this.text.length < this._minimumAutoCompleteLength)
			{
				this.removeEventListener(Event.ENTER_FRAME, autoComplete_enterFrameHandler);
				this.closeList();
				return;
			}

			if(this._autoCompleteDelay == 0)
			{
				//just in case the enter frame listener was added before
				//sourceUpdateDelay was set to 0.
				this.removeEventListener(Event.ENTER_FRAME, autoComplete_enterFrameHandler);

				this._source.load(this.text, this._listCollection);
			}
			else
			{
				this._lastChangeTime = getTimer();
				this.addEventListener(Event.ENTER_FRAME, autoComplete_enterFrameHandler);
			}
		}

		/**
		 * @private
		 */
		protected function autoComplete_enterFrameHandler():void
		{
			var currentTime:int = getTimer();
			var secondsSinceLastUpdate:Number = (currentTime - this._lastChangeTime) / 1000;
			if(secondsSinceLastUpdate < this._autoCompleteDelay)
			{
				return;
			}
			this.removeEventListener(Event.ENTER_FRAME, autoComplete_enterFrameHandler);
			this._source.load(this.text, this._listCollection);
		}

		/**
		 * @private
		 */
		protected function dataProvider_completeHandler(event:Event, data:ListCollection):void
		{
			this.list.dataProvider = data;
			if(data.length == 0)
			{
				if(this._popUpContentManager.isOpen)
				{
					this.closeList();
				}
				return;
			}
			this.openList();
		}

		/**
		 * @private
		 */
		protected function list_changeHandler(event:Event):void
		{
			if(!this.list.selectedItem)
			{
				return;
			}
			var oldIgnoreAutoCompleteChanges:Boolean = this._ignoreAutoCompleteChanges;
			this._ignoreAutoCompleteChanges = true;
			this.text = this.list.selectedItem.toString();
			this.selectRange(this.text.length, this.text.length);
			this._ignoreAutoCompleteChanges = oldIgnoreAutoCompleteChanges;
		}

		/**
		 * @private
		 */
		protected function popUpContentManager_openHandler(event:Event):void
		{
			this.dispatchEventWith(Event.OPEN);
		}

		/**
		 * @private
		 */
		protected function popUpContentManager_closeHandler(event:Event):void
		{
			this.dispatchEventWith(Event.CLOSE);
		}

		/**
		 * @private
		 */
		protected function list_removedFromStageHandler(event:Event):void
		{
			if(this._focusManager)
			{
				this.list.stage.removeEventListener(starling.events.KeyboardEvent.KEY_UP, stage_keyUpHandler);
			}
		}

		/**
		 * @private
		 */
		protected function list_triggeredHandler(event:Event):void
		{
			if(!this._isEnabled)
			{
				return;
			}
			this._triggered = true;
		}

		/**
		 * @private
		 */
		protected function list_touchHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this.list);
			if(touch === null)
			{
				return;
			}
			if(touch.phase === TouchPhase.BEGAN)
			{
				this._triggered = false;
			}
			if(touch.phase === TouchPhase.ENDED && this._triggered)
			{
				this.closeList();
				this.selectRange(this.text.length, this.text.length);
			}
		}

		/**
		 * @private
		 */
		protected function stage_keyUpHandler(event:starling.events.KeyboardEvent):void
		{
			if(!this._popUpContentManager.isOpen)
			{
				return;
			}
			if(event.keyCode == Keyboard.ENTER)
			{
				this.closeList();
				this.selectRange(this.text.length, this.text.length);
			}
		}
	}
}
