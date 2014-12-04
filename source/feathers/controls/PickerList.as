/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.popups.CalloutPopUpContentManager;
	import feathers.controls.popups.IPopUpContentManager;
	import feathers.controls.popups.VerticalCenteredPopUpContentManager;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.IFocusDisplayObject;
	import feathers.core.IToggle;
	import feathers.core.PropertyProxy;
	import feathers.data.ListCollection;
	import feathers.events.CollectionEventType;
	import feathers.events.FeathersEventType;
	import feathers.skins.IStyleProvider;
	import feathers.system.DeviceCapabilities;

	import flash.ui.Keyboard;

	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

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
	 * Dispatched when the selected item changes.
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
	 * A combo-box like list control. Displayed as a button. The list appears
	 * on tap as a full-screen overlay.
	 *
	 * <p>The following example creates a picker list, gives it a data provider,
	 * tells the item renderer how to interpret the data, and listens for when
	 * the selection changes:</p>
	 *
	 * <listing version="3.0">
	 * var list:PickerList = new PickerList();
	 *
	 * list.dataProvider = new ListCollection(
	 * [
	 *     { text: "Milk", thumbnail: textureAtlas.getTexture( "milk" ) },
	 *     { text: "Eggs", thumbnail: textureAtlas.getTexture( "eggs" ) },
	 *     { text: "Bread", thumbnail: textureAtlas.getTexture( "bread" ) },
	 *     { text: "Chicken", thumbnail: textureAtlas.getTexture( "chicken" ) },
	 * ]);
	 *
	 * list.listProperties.itemRendererFactory = function():IListItemRenderer
	 * {
	 *     var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
	 *     renderer.labelField = "text";
	 *     renderer.iconSourceField = "thumbnail";
	 *     return renderer;
	 * };
	 *
	 * list.addEventListener( Event.CHANGE, list_changeHandler );
	 *
	 * this.addChild( list );</listing>
	 *
	 * @see http://wiki.starling-framework.org/feathers/picker-list
	 */
	public class PickerList extends FeathersControl implements IFocusDisplayObject
	{
		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_BUTTON_FACTORY:String = "buttonFactory";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_LIST_FACTORY:String = "listFactory";

		/**
		 * The default value added to the <code>styleNameList</code> of the button.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_BUTTON:String = "feathers-picker-list-button";

		/**
		 * DEPRECATED: Replaced by <code>PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a href="http://wiki.starling-framework.org/feathers/deprecation-policy">Feathers deprecation policy</a>.</p>
		 *
		 * @see PickerList#DEFAULT_CHILD_STYLE_NAME_BUTTON
		 */
		public static const DEFAULT_CHILD_NAME_BUTTON:String = DEFAULT_CHILD_STYLE_NAME_BUTTON;

		/**
		 * The default value added to the <code>styleNameList</code> of the pop-up
		 * list.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_LIST:String = "feathers-picker-list-list";

		/**
		 * DEPRECATED: Replaced by <code>PickerList.DEFAULT_CHILD_STYLE_NAME_LIST</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a href="http://wiki.starling-framework.org/feathers/deprecation-policy">Feathers deprecation policy</a>.</p>
		 *
		 * @see PickerList#DEFAULT_CHILD_STYLE_NAME_LIST
		 */
		public static const DEFAULT_CHILD_NAME_LIST:String = DEFAULT_CHILD_STYLE_NAME_LIST;

		/**
		 * The default <code>IStyleProvider</code> for all <code>PickerList</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * @private
		 */
		protected static function defaultButtonFactory():Button
		{
			return new Button();
		}

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
		public function PickerList()
		{
			super();
		}

		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * button. This variable is <code>protected</code> so that sub-classes
		 * can customize the button style name in their constructors instead of
		 * using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_BUTTON</code>.
		 *
		 * <p>To customize the button style name without subclassing, see
		 * <code>customButtonStyleName</code>.</p>
		 *
		 * @see #customButtonStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var buttonStyleName:String = DEFAULT_CHILD_STYLE_NAME_BUTTON;

		/**
		 * DEPRECATED: Replaced by <code>buttonStyleName</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a href="http://wiki.starling-framework.org/feathers/deprecation-policy">Feathers deprecation policy</a>.</p>
		 *
		 * @see #buttonStyleName
		 */
		protected function get buttonName():String
		{
			return this.buttonStyleName;
		}

		/**
		 * @private
		 */
		protected function set buttonName(value:String):void
		{
			this.buttonStyleName = value;
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
		 * @see #customListStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var listStyleName:String = DEFAULT_CHILD_STYLE_NAME_LIST;

		/**
		 * DEPRECATED: Replaced by <code>listStyleName</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a href="http://wiki.starling-framework.org/feathers/deprecation-policy">Feathers deprecation policy</a>.</p>
		 *
		 * @see #listStyleName
		 */
		protected function get listName():String
		{
			return this.listStyleName;
		}

		/**
		 * @private
		 */
		protected function set listName(value:String):void
		{
			this.listStyleName = value;
		}

		/**
		 * The button sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #buttonFactory
		 * @see #createButton()
		 */
		protected var button:Button;

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
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return PickerList.globalStyleProvider;
		}
		
		/**
		 * @private
		 */
		protected var _dataProvider:ListCollection;
		
		/**
		 * The collection of data displayed by the list.
		 *
		 * <p>The following example passes in a data provider and tells the item
		 * renderer how to interpret the data:</p>
		 *
		 * <listing version="3.0">
		 * list.dataProvider = new ListCollection(
		 * [
		 *     { text: "Milk", thumbnail: textureAtlas.getTexture( "milk" ) },
		 *     { text: "Eggs", thumbnail: textureAtlas.getTexture( "eggs" ) },
		 *     { text: "Bread", thumbnail: textureAtlas.getTexture( "bread" ) },
		 *     { text: "Chicken", thumbnail: textureAtlas.getTexture( "chicken" ) },
		 * ]);
		 *
		 * list.listProperties.itemRendererFactory = function():IListItemRenderer
		 * {
		 *     var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
		 *     renderer.labelField = "text";
		 *     renderer.iconSourceField = "thumbnail";
		 *     return renderer;
		 * };</listing>
		 *
		 * @default null
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
			var oldSelectedIndex:int = this.selectedIndex;
			var oldSelectedItem:Object = this.selectedItem;
			if(this._dataProvider)
			{
				this._dataProvider.removeEventListener(CollectionEventType.RESET, dataProvider_multipleEventHandler);
				this._dataProvider.removeEventListener(CollectionEventType.ADD_ITEM, dataProvider_multipleEventHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_multipleEventHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_multipleEventHandler);
			}
			this._dataProvider = value;
			if(this._dataProvider)
			{
				this._dataProvider.addEventListener(CollectionEventType.RESET, dataProvider_multipleEventHandler);
				this._dataProvider.addEventListener(CollectionEventType.ADD_ITEM, dataProvider_multipleEventHandler);
				this._dataProvider.addEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_multipleEventHandler);
				this._dataProvider.addEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_multipleEventHandler);
			}
			if(!this._dataProvider || this._dataProvider.length == 0)
			{
				this.selectedIndex = -1;
			}
			else
			{
				this.selectedIndex = 0;
			}
			//this ensures that Event.CHANGE will dispatch for selectedItem
			//changing, even if selectedIndex has not changed.
			if(this.selectedIndex == oldSelectedIndex && this.selectedItem != oldSelectedItem)
			{
				this.dispatchEventWith(Event.CHANGE);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _ignoreSelectionChanges:Boolean = false;
		
		/**
		 * @private
		 */
		protected var _selectedIndex:int = -1;
		
		/**
		 * The index of the currently selected item. Returns <code>-1</code> if
		 * no item is selected.
		 *
		 * <p>The following example selects an item by its index:</p>
		 *
		 * <listing version="3.0">
		 * list.selectedIndex = 2;</listing>
		 *
		 * <p>The following example clears the selected index:</p>
		 *
		 * <listing version="3.0">
		 * list.selectedIndex = -1;</listing>
		 *
		 * <p>The following example listens for when selection changes and
		 * requests the selected index:</p>
		 *
		 * <listing version="3.0">
		 * function list_changeHandler( event:Event ):void
		 * {
		 *     var list:PickerList = PickerList( event.currentTarget );
		 *     var index:int = list.selectedIndex;
		 *
		 * }
		 * list.addEventListener( Event.CHANGE, list_changeHandler );</listing>
		 *
		 * @default -1
		 *
		 * @see #selectedItem
		 */
		public function get selectedIndex():int
		{
			return this._selectedIndex;
		}
		
		/**
		 * @private
		 */
		public function set selectedIndex(value:int):void
		{
			if(this._selectedIndex == value)
			{
				return;
			}
			this._selectedIndex = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.dispatchEventWith(Event.CHANGE);
		}
		
		/**
		 * The currently selected item. Returns <code>null</code> if no item is
		 * selected.
		 *
		 * <p>The following example changes the selected item:</p>
		 *
		 * <listing version="3.0">
		 * list.selectedItem = list.dataProvider.getItemAt(0);</listing>
		 *
		 * <p>The following example clears the selected item:</p>
		 *
		 * <listing version="3.0">
		 * list.selectedItem = null;</listing>
		 *
		 * <p>The following example listens for when selection changes and
		 * requests the selected item:</p>
		 *
		 * <listing version="3.0">
		 * function list_changeHandler( event:Event ):void
		 * {
		 *     var list:PickerList = PickerList( event.currentTarget );
		 *     var item:Object = list.selectedItem;
		 *
		 * }
		 * list.addEventListener( Event.CHANGE, list_changeHandler );</listing>
		 *
		 * @default null
		 *
		 * @see #selectedIndex
		 */
		public function get selectedItem():Object
		{
			if(!this._dataProvider || this._selectedIndex < 0 || this._selectedIndex >= this._dataProvider.length)
			{
				return null;
			}
			return this._dataProvider.getItemAt(this._selectedIndex);
		}
		
		/**
		 * @private
		 */
		public function set selectedItem(value:Object):void
		{
			if(!this._dataProvider)
			{
				this.selectedIndex = -1;
				return;
			}
			this.selectedIndex = this._dataProvider.getItemIndex(value);
		}

		/**
		 * @private
		 */
		protected var _prompt:String;

		/**
		 * Text displayed by the button sub-component when no items are
		 * currently selected.
		 *
		 * <p>In the following example, a prompt is given to the picker list
		 * and the selected item is cleared to display the prompt:</p>
		 *
		 * <listing version="3.0">
		 * list.prompt = "Select an Item";
		 * list.selectedIndex = -1;</listing>
		 *
		 * @default null
		 */
		public function get prompt():String
		{
			return this._prompt;
		}

		/**
		 * @private
		 */
		public function set prompt(value:String):void
		{
			if(this._prompt == value)
			{
				return;
			}
			this._prompt = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}
		
		/**
		 * @private
		 */
		protected var _labelField:String = "label";
		
		/**
		 * The field in the selected item that contains the label text to be
		 * displayed by the picker list's button control. If the selected item
		 * does not have this field, and a <code>labelFunction</code> is not
		 * defined, then the picker list will default to calling
		 * <code>toString()</code> on the selected item. To omit the
		 * label completely, define a <code>labelFunction</code> that returns an
		 * empty string.
		 *
		 * <p><strong>Important:</strong> This value only affects the selected
		 * item displayed by the picker list's button control. It will <em>not</em>
		 * affect the label text of the pop-up list's item renderers.</p>
		 *
		 * <p>In the following example, the label field is changed:</p>
		 *
		 * <listing version="3.0">
		 * list.labelField = "text";</listing>
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
		 * A function used to generate label text for the selected item
		 * displayed by the picker list's button control. If this
		 * function is not null, then the <code>labelField</code> will be
		 * ignored.
		 *
		 * <p><strong>Important:</strong> This value only affects the selected
		 * item displayed by the picker list's button control. It will <em>not</em>
		 * affect the label text of the pop-up list's item renderers.</p>
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
		 * <p>In the following example, the label field is changed:</p>
		 *
		 * <listing version="3.0">
		 * list.labelFunction = function( item:Object ):String
		 * {
		 *     return item.firstName + " " + item.lastName;
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
			this._labelFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		/**
		 * @private
		 */
		protected var _popUpContentManager:IPopUpContentManager;
		
		/**
		 * A manager that handles the details of how to display the pop-up list.
		 *
		 * <p>In the following example, a pop-up content manager is provided:</p>
		 *
		 * <listing version="3.0">
		 * list.popUpContentManager = new CalloutPopUpContentManager();</listing>
		 *
		 * @default null
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
			if(this._popUpContentManager == value)
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
		protected var _typicalItemWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var _typicalItemHeight:Number = NaN;
		
		/**
		 * @private
		 */
		protected var _typicalItem:Object = null;
		
		/**
		 * Used to auto-size the list. If the list's width or height is NaN, the
		 * list will try to automatically pick an ideal size. This item is
		 * used in that process to create a sample item renderer.
		 *
		 * <p>The following example provides a typical item:</p>
		 *
		 * <listing version="3.0">
		 * list.typicalItem = { text: "A typical item", thumbnail: texture };
		 * list.itemRendererProperties.labelField = "text";
		 * list.itemRendererProperties.iconSourceField = "thumbnail";</listing>
		 *
		 * @default null
		 */
		public function get typicalItem():Object
		{
			return this._typicalItem;
		}
		
		/**
		 * @private
		 */
		public function set typicalItem(value:Object):void
		{
			if(this._typicalItem == value)
			{
				return;
			}
			this._typicalItem = value;
			this._typicalItemWidth = NaN;
			this._typicalItemHeight = NaN;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _buttonFactory:Function;

		/**
		 * A function used to generate the picker list's button sub-component.
		 * The button must be an instance of <code>Button</code>. This factory
		 * can be used to change properties on the button when it is first
		 * created. For instance, if you are skinning Feathers components
		 * without a theme, you might use this factory to set skins and other
		 * styles on the button.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():Button</pre>
		 *
		 * <p>In the following example, a custom button factory is passed to the
		 * picker list:</p>
		 *
		 * <listing version="3.0">
		 * list.buttonFactory = function():Button
		 * {
		 *     var button:Button = new Button();
		 *     button.defaultSkin = new Image( upTexture );
		 *     button.downSkin = new Image( downTexture );
		 *     return button;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.Button
		 * @see #buttonProperties
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
		protected var _customButtonStyleName:String;

		/**
		 * A style name to add to the picker list's button sub-component.
		 * Typically used by a theme to provide different styles to different
		 * picker lists.
		 *
		 * <p>In the following example, a custom button style name is passed to
		 * the picker list:</p>
		 *
		 * <listing version="3.0">
		 * list.customButtonStyleName = "my-custom-button";</listing>
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
		 * @see #buttonFactory
		 * @see #buttonProperties
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
			if(this._customButtonStyleName == value)
			{
				return;
			}
			this._customButtonStyleName = value;
			this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
		}

		/**
		 * DEPRECATED: Replaced by <code>customButtonStyleName</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a href="http://wiki.starling-framework.org/feathers/deprecation-policy">Feathers deprecation policy</a>.</p>
		 *
		 * @see #customButtonStyleName
		 */
		public function get customButtonName():String
		{
			return this.customButtonStyleName;
		}

		/**
		 * @private
		 */
		public function set customButtonName(value:String):void
		{
			this.customButtonStyleName = value;
		}
		
		/**
		 * @private
		 */
		protected var _buttonProperties:PropertyProxy;
		
		/**
		 * A set of key/value pairs to be passed down to the picker's button
		 * sub-component. It is a <code>feathers.controls.Button</code>
		 * instance that is created by <code>buttonFactory</code>.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>buttonFactory</code> function
		 * instead of using <code>buttonProperties</code> will result in better
		 * performance.</p>
		 *
		 * <p>In the following example, the button properties are passed to the
		 * picker list:</p>
		 *
		 * <listing version="3.0">
		 * list.buttonProperties.defaultSkin = new Image( upTexture );
		 * list.buttonProperties.downSkin = new Image( downTexture );</listing>
		 *
		 * @default null
		 *
		 * @see #buttonFactory
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
		 * @private
		 */
		protected var _listFactory:Function;

		/**
		 * A function used to generate the picker list's pop-up list
		 * sub-component. The list must be an instance of <code>List</code>.
		 * This factory can be used to change properties on the list when it is
		 * first created. For instance, if you are skinning Feathers components
		 * without a theme, you might use this factory to set skins and other
		 * styles on the list.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():List</pre>
		 *
		 * <p>In the following example, a custom list factory is passed to the
		 * picker list:</p>
		 *
		 * <listing version="3.0">
		 * list.listFactory = function():List
		 * {
		 *     var popUpList:List = new List();
		 *     popUpList.backgroundSkin = new Image( texture );
		 *     return popUpList;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.List
		 * @see #listProperties
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
		 * A style name to add to the picker list's list sub-component.
		 * Typically used by a theme to provide different styles to different
		 * picker lists.
		 *
		 * <p>In the following example, a custom list style name is passed to the
		 * picker list:</p>
		 *
		 * <listing version="3.0">
		 * list.customListStyleName = "my-custom-list";</listing>
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
		 * @see #listProperties
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
			this.invalidate(INVALIDATION_FLAG_LIST_FACTORY);
		}

		/**
		 * DEPRECATED: Replaced by <code>customListStyleName</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a href="http://wiki.starling-framework.org/feathers/deprecation-policy">Feathers deprecation policy</a>.</p>
		 *
		 * @see #customListStyleName
		 */
		public function get customListName():String
		{
			return this.customListStyleName;
		}

		/**
		 * @private
		 */
		public function set customListName(value:String):void
		{
			this.customListStyleName = value;
		}
		
		/**
		 * @private
		 */
		protected var _listProperties:PropertyProxy;
		
		/**
		 * A set of key/value pairs to be passed down to the picker's pop-up
		 * list sub-component. The pop-up list is a
		 * <code>feathers.controls.List</code> instance that is created by
		 * <code>listFactory</code>.
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
		 * picker list:</p>
		 *
		 * <listing version="3.0">
		 * list.listProperties.backgroundSkin = new Image( texture );</listing>
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
		protected var _toggleButtonOnOpenAndClose:Boolean = false;

		/**
		 * Determines if the <code>isSelected</code> property of the picker
		 * list's button sub-component is toggled when the list is opened and
		 * closed, if the class used to create the thumb implements the
		 * <code>IToggle</code> interface. Useful for skinning to provide a
		 * different appearance for the button based on whether the list is open
		 * or not.
		 *
		 * <p>In the following example, the button is toggled on open and close:</p>
		 *
		 * <listing version="3.0">
		 * list.toggleButtonOnOpenAndClose = true;</listing>
		 *
		 * @default false
		 *
		 * @see feathers.core.IToggle
		 * @see feathers.controls.ToggleButton
		 */
		public function get toggleButtonOnOpenAndClose():Boolean
		{
			return this._toggleButtonOnOpenAndClose;
		}

		/**
		 * @private
		 */
		public function set toggleButtonOnOpenAndClose(value:Boolean):void
		{
			if(this._toggleButtonOnOpenAndClose == value)
			{
				return;
			}
			this._toggleButtonOnOpenAndClose = value;
			if(this.button is IToggle)
			{
				if(this._toggleButtonOnOpenAndClose && this._popUpContentManager.isOpen)
				{
					IToggle(this.button).isSelected = true;
				}
				else
				{
					IToggle(this.button).isSelected = false;
				}
			}
		}

		/**
		 * @private
		 */
		protected var _isOpenListPending:Boolean = false;

		/**
		 * @private
		 */
		protected var _isCloseListPending:Boolean = false;
		
		/**
		 * Using <code>labelField</code> and <code>labelFunction</code>,
		 * generates a label from the selected item to be displayed by the
		 * picker list's button control.
		 *
		 * <p><strong>Important:</strong> This value only affects the selected
		 * item displayed by the picker list's button control. It will <em>not</em>
		 * affect the label text of the pop-up list's item renderers.</p>
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
		 * @private
		 */
		protected var _buttonHasFocus:Boolean = false;

		/**
		 * @private
		 */
		protected var _buttonTouchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _listIsOpenOnTouchBegan:Boolean = false;

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
			this.list.scrollToDisplayIndex(this._selectedIndex);
			this.list.validate();
			if(this._focusManager)
			{
				this._focusManager.focus = this.list;
				this.stage.addEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
				this.list.addEventListener(FeathersEventType.FOCUS_OUT, list_focusOutHandler);
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
			this.dataProvider = null;
			super.dispose();
		}

		/**
		 * @private
		 */
		override public function showFocus():void
		{
			if(!this.button)
			{
				return;
			}
			this.button.showFocus();
		}

		/**
		 * @private
		 */
		override public function hideFocus():void
		{
			if(!this.button)
			{
				return;
			}
			this.button.hideFocus();
		}
		
		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(!this._popUpContentManager)
			{
				if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
				{
					this.popUpContentManager = new CalloutPopUpContentManager();
				}
				else
				{
					this.popUpContentManager = new VerticalCenteredPopUpContentManager();
				}
			}

		}
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var buttonFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_BUTTON_FACTORY);
			var listFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LIST_FACTORY);

			if(buttonFactoryInvalid)
			{
				this.createButton();
			}

			if(listFactoryInvalid)
			{
				this.createList();
			}
			
			if(buttonFactoryInvalid || stylesInvalid || selectionInvalid)
			{
				//this section asks the button to auto-size again, if our
				//explicit dimensions aren't set.
				//set this before buttonProperties is used because it might
				//contain width or height changes.
				if(this.explicitWidth !== this.explicitWidth) //isNaN
				{
					this.button.width = NaN;
				}
				if(this.explicitHeight !== this.explicitHeight) //isNaN
				{
					this.button.height = NaN;
				}
			}

			if(buttonFactoryInvalid || stylesInvalid)
			{
				this._typicalItemWidth = NaN;
				this._typicalItemHeight = NaN;
				this.refreshButtonProperties();
			}

			if(listFactoryInvalid || stylesInvalid)
			{
				this.refreshListProperties();
			}
			
			if(listFactoryInvalid || dataInvalid)
			{
				var oldIgnoreSelectionChanges:Boolean = this._ignoreSelectionChanges;
				this._ignoreSelectionChanges = true;
				this.list.dataProvider = this._dataProvider;
				this._ignoreSelectionChanges = oldIgnoreSelectionChanges;
			}
			
			if(buttonFactoryInvalid || listFactoryInvalid || stateInvalid)
			{
				this.button.isEnabled = this._isEnabled;
				this.list.isEnabled = this._isEnabled;
			}

			if(buttonFactoryInvalid || dataInvalid || selectionInvalid)
			{
				this.refreshButtonLabel();
			}
			if(listFactoryInvalid || dataInvalid || selectionInvalid)
			{
				oldIgnoreSelectionChanges = this._ignoreSelectionChanges;
				this._ignoreSelectionChanges = true;
				this.list.selectedIndex = this._selectedIndex;
				this._ignoreSelectionChanges = oldIgnoreSelectionChanges;
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(buttonFactoryInvalid || stylesInvalid || sizeInvalid || selectionInvalid)
			{
				this.layout();
			}

			//final validation to avoid juggler next frame issues
			//also, to ensure that property changes on the pop-up list are fully
			//committed
			this.list.validate();

			this.handlePendingActions();
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
			var needsWidth:Boolean = this.explicitWidth !== this.explicitWidth; //isNaN
			var needsHeight:Boolean = this.explicitHeight !== this.explicitHeight; //isNaN
			if(!needsWidth && !needsHeight)
			{
				return false;
			}

			var buttonWidth:Number;
			var buttonHeight:Number;
			if(this._typicalItem)
			{
				if(this._typicalItemWidth !== this._typicalItemWidth || //isNaN
					this._typicalItemHeight !== this._typicalItemHeight) //isNaN
				{
					var oldWidth:Number = this.button.width;
					var oldHeight:Number = this.button.height;
					this.button.width = NaN;
					this.button.height = NaN;
					if(this._typicalItem)
					{
						this.button.label = this.itemToLabel(this._typicalItem);
					}
					this.button.validate();
					this._typicalItemWidth = this.button.width;
					this._typicalItemHeight = this.button.height;
					this.refreshButtonLabel();
					this.button.width = oldWidth;
					this.button.height = oldHeight;
				}
				buttonWidth = this._typicalItemWidth;
				buttonHeight = this._typicalItemHeight;
			}
			else
			{
				this.button.validate();
				buttonWidth = this.button.width;
				buttonHeight = this.button.height;
			}

			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth)
			{
				if(buttonWidth === buttonWidth) //!isNaN
				{
					newWidth = buttonWidth;
				}
				else
				{
					newWidth = 0;
				}
			}
			if(needsHeight)
			{
				if(buttonHeight === buttonHeight) //!isNaN
				{
					newHeight = buttonHeight;
				}
				else
				{
					newHeight = 0;
				}
			}

			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * Creates and adds the <code>button</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #button
		 * @see #buttonFactory
		 * @see #customButtonStyleName
		 */
		protected function createButton():void
		{
			if(this.button)
			{
				this.button.removeFromParent(true);
				this.button = null;
			}

			var factory:Function = this._buttonFactory != null ? this._buttonFactory : defaultButtonFactory;
			var buttonStyleName:String = this._customButtonStyleName != null ? this._customButtonStyleName : this.buttonStyleName;
			this.button = Button(factory());
			if(this.button is ToggleButton)
			{
				//we'll control the value of isSelected manually
				ToggleButton(this.button).isToggle = false;
			}
			this.button.styleNameList.add(buttonStyleName);
			this.button.addEventListener(TouchEvent.TOUCH, button_touchHandler);
			this.button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			this.addChild(this.button);
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
		 * @see #customListStyleName
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
			this.list.styleNameList.add(listStyleName);
			this.list.addEventListener(Event.CHANGE, list_changeHandler);
			this.list.addEventListener(Event.TRIGGERED, list_triggeredHandler);
			this.list.addEventListener(Event.REMOVED_FROM_STAGE, list_removedFromStageHandler);
		}
		
		/**
		 * @private
		 */
		protected function refreshButtonLabel():void
		{
			if(this._selectedIndex >= 0)
			{
				this.button.label = this.itemToLabel(this.selectedItem);
			}
			else
			{
				this.button.label = this._prompt;
			}
		}
		
		/**
		 * @private
		 */
		protected function refreshButtonProperties():void
		{
			for(var propertyName:String in this._buttonProperties)
			{
				var propertyValue:Object = this._buttonProperties[propertyName];
				this.button[propertyName] = propertyValue;
			}
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
		protected function layout():void
		{
			this.button.width = this.actualWidth;
			this.button.height = this.actualHeight;

			//final validation to avoid juggler next frame issues
			this.button.validate();
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
			super.focusInHandler(event);
			this._buttonHasFocus = true;
			this.button.dispatchEventWith(FeathersEventType.FOCUS_IN);
		}

		/**
		 * @private
		 */
		override protected function focusOutHandler(event:Event):void
		{
			if(this._buttonHasFocus)
			{
				this.button.dispatchEventWith(FeathersEventType.FOCUS_OUT);
				this._buttonHasFocus = false;
			}
			super.focusOutHandler(event);
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
		protected function button_touchHandler(event:TouchEvent):void
		{
			if(this._buttonTouchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this.button, TouchPhase.ENDED, this._buttonTouchPointID);
				if(!touch)
				{
					return;
				}
				this._buttonTouchPointID = -1;
				//the button will dispatch Event.TRIGGERED before this touch
				//listener is called, so it is safe to clear this flag.
				//we're clearing it because Event.TRIGGERED may also be
				//dispatched after keyboard input.
				this._listIsOpenOnTouchBegan = false;
			}
			else
			{
				touch = event.getTouch(this.button, TouchPhase.BEGAN);
				if(!touch)
				{
					return;
				}
				this._buttonTouchPointID = touch.id;
				this._listIsOpenOnTouchBegan = this._popUpContentManager.isOpen;
			}
		}
		
		/**
		 * @private
		 */
		protected function button_triggeredHandler(event:Event):void
		{
			if(this._focusManager && this._listIsOpenOnTouchBegan)
			{
				return;
			}
			if(this._popUpContentManager.isOpen)
			{
				this.closeList();
				return;
			}
			this.openList();
		}
		
		/**
		 * @private
		 */
		protected function list_changeHandler(event:Event):void
		{
			if(this._ignoreSelectionChanges)
			{
				return;
			}
			this.selectedIndex = this.list.selectedIndex;
		}

		/**
		 * @private
		 */
		protected function popUpContentManager_openHandler(event:Event):void
		{
			if(this._toggleButtonOnOpenAndClose && this.button is IToggle)
			{
				IToggle(this.button).isSelected = true;
			}
			this.dispatchEventWith(Event.OPEN);
		}

		/**
		 * @private
		 */
		protected function popUpContentManager_closeHandler(event:Event):void
		{
			if(this._toggleButtonOnOpenAndClose && this.button is IToggle)
			{
				IToggle(this.button).isSelected = false;
			}
			this.dispatchEventWith(Event.CLOSE);
		}

		/**
		 * @private
		 */
		protected function list_removedFromStageHandler(event:Event):void
		{
			if(this._focusManager)
			{
				this.list.stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
				this.list.removeEventListener(FeathersEventType.FOCUS_OUT, list_focusOutHandler);
			}
		}

		/**
		 * @private
		 */
		protected function list_focusOutHandler(event:Event):void
		{
			if(!this._popUpContentManager.isOpen)
			{
				return;
			}
			this.closeList();
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
			this.closeList();
		}

		/**
		 * @private
		 */
		protected function dataProvider_multipleEventHandler():void
		{
			//we need to ensure that the pop-up list has received the new
			//selected index, or it might update the selected index to an
			//incorrect value after an item is added, removed, or replaced.
			this.validate();
		}

		/**
		 * @private
		 */
		protected function stage_keyUpHandler(event:KeyboardEvent):void
		{
			if(!this._popUpContentManager.isOpen)
			{
				return;
			}
			if(event.keyCode == Keyboard.ENTER)
			{
				this.closeList();
			}
		}
	}
}