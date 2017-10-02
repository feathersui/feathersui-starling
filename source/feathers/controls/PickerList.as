/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.popups.CalloutPopUpContentManager;
	import feathers.controls.popups.DropDownPopUpContentManager;
	import feathers.controls.popups.IPersistentPopUpContentManager;
	import feathers.controls.popups.IPopUpContentManager;
	import feathers.controls.popups.IPopUpContentManagerWithPrompt;
	import feathers.controls.popups.VerticalCenteredPopUpContentManager;
	import feathers.core.FeathersControl;
	import feathers.core.IFocusDisplayObject;
	import feathers.core.ITextBaselineControl;
	import feathers.core.IToggle;
	import feathers.core.PropertyProxy;
	import feathers.data.IListCollection;
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
	import starling.utils.SystemUtil;

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
	 */
	[Style(name="customButtonStyleName",type="String")]

	/**
	 * A style name to add to all item renderers in the pop-up list. Typically
	 * used by a theme to provide different skins to different lists.
	 *
	 * <p>The following example sets the item renderer name:</p>
	 *
	 * <listing version="3.0">
	 * list.customItemRendererStyleName = "my-custom-item-renderer";</listing>
	 *
	 * <p>In your theme, you can target this sub-component name to provide
	 * different skins than the default style:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( DefaultListItemRenderer ).setFunctionForStyleName( "my-custom-item-renderer", setCustomItemRendererStyles );</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	[Style(name="customItemRendererStyleName",type="String")]

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
	 */
	[Style(name="customListStyleName",type="String")]

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
	[Style(name="popUpContentManager",type="feathers.controls.popups.IPopUpContentManager")]

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
	[Style(name="toggleButtonOnOpenAndClose",type="Boolean")]

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
	 * @see #selectedItem
	 * @see #selectedIndex
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Displays a button that may be triggered to display a pop-up list.
	 * The list may be customized to display in different ways, such as a
	 * drop-down, in a <code>Callout</code>, or as a modal overlay.
	 *
	 * <p>The following example creates a picker list, gives it a data provider,
	 * tells the item renderer how to interpret the data, and listens for when
	 * the selection changes:</p>
	 *
	 * <listing version="3.0">
	 * var list:PickerList = new PickerList();
	 * 
	 * list.dataProvider = new ArrayCollection(
	 * [
	 *     { text: "Milk", thumbnail: textureAtlas.getTexture( "milk" ) },
	 *     { text: "Eggs", thumbnail: textureAtlas.getTexture( "eggs" ) },
	 *     { text: "Bread", thumbnail: textureAtlas.getTexture( "bread" ) },
	 *     { text: "Chicken", thumbnail: textureAtlas.getTexture( "chicken" ) },
	 * ]);
	 * 
	 * list.itemRendererFactory = function():IListItemRenderer
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
	 * @see ../../../help/picker-list.html How to use the Feathers PickerList component
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class PickerList extends FeathersControl implements IFocusDisplayObject, ITextBaselineControl
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
		 * The default value added to the <code>styleNameList</code> of the pop-up
		 * list.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_LIST:String = "feathers-picker-list-list";

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
		 * @see #style:customButtonStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var buttonStyleName:String = DEFAULT_CHILD_STYLE_NAME_BUTTON;

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
		protected var buttonExplicitWidth:Number;

		/**
		 * @private
		 */
		protected var buttonExplicitHeight:Number;

		/**
		 * @private
		 */
		protected var buttonExplicitMinWidth:Number;

		/**
		 * @private
		 */
		protected var buttonExplicitMinHeight:Number;
		
		/**
		 * @private
		 */
		protected var _dataProvider:IListCollection;
		
		/**
		 * The collection of data displayed by the list.
		 *
		 * <p>The following example passes in a data provider and tells the item
		 * renderer how to interpret the data:</p>
		 *
		 * <listing version="3.0">
		 * list.dataProvider = new ArrayCollection(
		 * [
		 *     { text: "Milk", thumbnail: textureAtlas.getTexture( "milk" ) },
		 *     { text: "Eggs", thumbnail: textureAtlas.getTexture( "eggs" ) },
		 *     { text: "Bread", thumbnail: textureAtlas.getTexture( "bread" ) },
		 *     { text: "Chicken", thumbnail: textureAtlas.getTexture( "chicken" ) },
		 * ]);
		 *
		 * list.itemRendererFactory = function():IListItemRenderer
		 * {
		 *     var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
		 *     renderer.labelField = "text";
		 *     renderer.iconSourceField = "thumbnail";
		 *     return renderer;
		 * };</listing>
		 *
		 * @default null
		 * 
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
			var oldSelectedIndex:int = this.selectedIndex;
			var oldSelectedItem:Object = this.selectedItem;
			if(this._dataProvider)
			{
				this._dataProvider.removeEventListener(CollectionEventType.RESET, dataProvider_multipleEventHandler);
				this._dataProvider.removeEventListener(CollectionEventType.ADD_ITEM, dataProvider_multipleEventHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_multipleEventHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ALL, dataProvider_multipleEventHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_multipleEventHandler);
				this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ITEM, dataProvider_updateItemHandler);
			}
			this._dataProvider = value;
			if(this._dataProvider)
			{
				this._dataProvider.addEventListener(CollectionEventType.RESET, dataProvider_multipleEventHandler);
				this._dataProvider.addEventListener(CollectionEventType.ADD_ITEM, dataProvider_multipleEventHandler);
				this._dataProvider.addEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_multipleEventHandler);
				this._dataProvider.addEventListener(CollectionEventType.REMOVE_ALL, dataProvider_multipleEventHandler);
				this._dataProvider.addEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_multipleEventHandler);
				this._dataProvider.addEventListener(CollectionEventType.UPDATE_ITEM, dataProvider_updateItemHandler);
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
		protected var _typicalItem:Object = null;
		
		/**
		 * Used to auto-size the list. If the list's width or height is NaN, the
		 * list will try to automatically pick an ideal size. This item is
		 * used in that process to create a sample item renderer.
		 *
		 * <p>The following example provides a typical item:</p>
		 *
		 * <listing version="3.0">
		 * list.typicalItem = { text: "A typical item", thumbnail: texture };</listing>
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
		protected var _buttonProperties:PropertyProxy;
		
		/**
		 * An object that stores properties for the picker's button
		 * sub-component, and the properties will be passed down to the button
		 * when the picker validates. For a list of available
		 * properties, refer to
		 * <a href="Button.html"><code>feathers.controls.Button</code></a>.
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
		 * An object that stores properties for the picker's pop-up list
		 * sub-component, and the properties will be passed down to the pop-up
		 * list when the picker validates. For a list of available
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._toggleButtonOnOpenAndClose === value)
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
		protected var _itemRendererFactory:Function = null;

		/**
		 * A function called that is expected to return a new item renderer.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 *
		 * <pre>function():IListItemRenderer</pre>
		 *
		 * <p>The following example provides a factory for the item renderer:</p>
		 *
		 * <listing version="3.0">
		 * list.itemRendererFactory = function():IListItemRenderer
		 * {
		 *     var renderer:CustomItemRendererClass = new CustomItemRendererClass();
		 *     renderer.backgroundSkin = new Quad( 10, 10, 0xff0000 );
		 *     return renderer;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.renderers.IListItemRenderer
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
			this.invalidate(INVALIDATION_FLAG_LIST_FACTORY);
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
			this.invalidate(INVALIDATION_FLAG_LIST_FACTORY);
		}

		/**
		 * @inheritDoc
		 */
		public function get baseline():Number
		{
			if(!this.button)
			{
				return this.scaledActualHeight;
			}
			return this.scaleY * (this.button.y + this.button.baseline);
		}

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
			if(this._labelFunction !== null)
			{
				var labelResult:Object = this._labelFunction(item);
				if(labelResult is String)
				{
					return labelResult as String;
				}
				else if(labelResult !== null)
				{
					return labelResult.toString();
				}
			}
			else if(this._labelField !== null && item !== null && item.hasOwnProperty(this._labelField))
			{
				labelResult = item[this._labelField];
				if(labelResult is String)
				{
					return labelResult as String;
				}
				else if(labelResult !== null)
				{
					return labelResult.toString();
				}
			}
			else if(item is String)
			{
				return item as String;
			}
			else if(item !== null)
			{
				//we need to use strict equality here because the data can be
				//non-strictly equal to null
				return item.toString();
			}
			return null;
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
			if(this._popUpContentManager is IPopUpContentManagerWithPrompt)
			{
				IPopUpContentManagerWithPrompt(this._popUpContentManager).prompt = this._prompt;
			}
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
			//clearing selection now so that the data provider setter won't
			//cause a selection change that triggers events.
			this._selectedIndex = -1;
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
			if(this._popUpContentManager === null)
			{
				var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
				if(SystemUtil.isDesktop)
				{
					var popUpContentManager:IPopUpContentManager = new DropDownPopUpContentManager();
				}
				else if(DeviceCapabilities.isTablet(starling.nativeStage))
				{
					popUpContentManager = new CalloutPopUpContentManager();
				}
				else
				{
					popUpContentManager = new VerticalCenteredPopUpContentManager();
				}
				this.ignoreNextStyleRestriction();
				this.popUpContentManager = popUpContentManager;
			}
			super.initialize();
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
				if(this._explicitWidth !== this._explicitWidth) //isNaN
				{
					this.button.width = NaN;
				}
				if(this._explicitHeight !== this._explicitHeight) //isNaN
				{
					this.button.height = NaN;
				}
			}

			if(buttonFactoryInvalid || stylesInvalid)
			{
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

			this.autoSizeIfNeeded();
			this.layout();

			if(this.list.stage)
			{
				//final validation to avoid juggler next frame issues
				//only validate if it's on the display list, though, because the
				//popUpContentManager may need to place restrictions on
				//dimensions or make other important changes.
				//otherwise, the List may create an item renderer for every item
				//in the data provider, which is not good for performance!
				this.list.validate();
			}

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
		 * <p>Calls <code>saveMeasurements()</code> to set up the
		 * <code>actualWidth</code> and <code>actualHeight</code> member
		 * variables used for layout.</p>
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
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

			var buttonWidth:Number = this._explicitWidth;
			if(buttonWidth !== buttonWidth)
			{
				//we save the button's explicitWidth (and other explicit
				//dimensions) after the buttonFactory() returns so that
				//measurement always accounts for it, even after the button's
				//width is set by the PickerList
				buttonWidth = this.buttonExplicitWidth;
			}
			var buttonHeight:Number = this._explicitHeight;
			if(buttonHeight !== buttonHeight)
			{
				buttonHeight = this.buttonExplicitHeight;
			}
			var buttonMinWidth:Number = this._explicitMinWidth;
			if(buttonMinWidth !== buttonMinWidth)
			{
				buttonMinWidth = this.buttonExplicitMinWidth;
			}
			var buttonMinHeight:Number = this._explicitMinHeight;
			if(buttonMinHeight !== buttonMinHeight)
			{
				buttonMinHeight = this.buttonExplicitMinHeight;
			}
			if(this._typicalItem !== null)
			{
				this.button.label = this.itemToLabel(this._typicalItem);
			}
			this.button.width = buttonWidth;
			this.button.height = buttonHeight;
			this.button.minWidth = buttonMinWidth;
			this.button.minHeight = buttonMinHeight;
			this.button.validate();
			
			if(this._typicalItem !== null)
			{
				this.refreshButtonLabel();
			}

			var newWidth:Number = this._explicitWidth;
			var newHeight:Number = this._explicitHeight;
			var newMinWidth:Number = this._explicitMinWidth;
			var newMinHeight:Number = this._explicitMinHeight;
			
			if(needsWidth)
			{
				newWidth = this.button.width;
			}
			if(needsHeight)
			{
				newHeight = this.button.height;
			}
			if(needsMinWidth)
			{
				newMinWidth = this.button.minWidth;
			}
			if(needsMinHeight)
			{
				newMinHeight = this.button.minHeight;
			}

			return this.saveMeasurements(newWidth, newHeight, newMinWidth, newMinHeight);
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
		 * @see #style:customButtonStyleName
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
			
			//we will use these values for measurement, if possible
			this.button.initializeNow();
			this.buttonExplicitWidth = this.button.explicitWidth;
			this.buttonExplicitHeight = this.button.explicitHeight;
			this.buttonExplicitMinWidth = this.button.explicitMinWidth;
			this.buttonExplicitMinHeight = this.button.explicitMinHeight;
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
			this.list.styleNameList.add(listStyleName);
			//for backwards compatibility, allow the listFactory to take
			//precedence if it also sets customItemRendererStyleName and our
			//value is null. if our value is not null, we'll use it.
			if(this._customItemRendererStyleName !== null)
			{
				this.list.customItemRendererStyleName = this._customItemRendererStyleName;
			}
			if(this._itemRendererFactory !== null)
			{
				this.list.itemRendererFactory = this._itemRendererFactory;
			}
			this.list.addEventListener(Event.CHANGE, list_changeHandler);
			this.list.addEventListener(Event.TRIGGERED, list_triggeredHandler);
			this.list.addEventListener(TouchEvent.TOUCH, list_touchHandler);
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
			if(this._ignoreSelectionChanges ||
				this._popUpContentManager is IPersistentPopUpContentManager)
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
			this.list.revealScrollBars();
			this.dispatchEventWith(Event.OPEN);
		}

		/**
		 * @private
		 */
		protected function popUpContentManager_closeHandler(event:Event):void
		{
			if(this._popUpContentManager is IPersistentPopUpContentManager)
			{
				this.selectedIndex = this.list.selectedIndex;
			}
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
			if(!this._isEnabled ||
				this._popUpContentManager is IPersistentPopUpContentManager)
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
			}
		}

		/**
		 * @private
		 */
		protected function dataProvider_multipleEventHandler(event:Event):void
		{
			//we need to ensure that the pop-up list has received the new
			//selected index, or it might update the selected index to an
			//incorrect value after an item is added, removed, or replaced.
			this.validate();
		}

		/**
		 * @private
		 */
		protected function dataProvider_updateItemHandler(event:Event, index:int):void
		{
			if(index === this._selectedIndex)
			{
				this.invalidate(INVALIDATION_FLAG_SELECTED);
			}
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