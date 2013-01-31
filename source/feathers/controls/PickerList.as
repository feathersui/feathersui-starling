/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.popups.CalloutPopUpContentManager;
	import feathers.controls.popups.IPopUpContentManager;
	import feathers.controls.popups.VerticalCenteredPopUpContentManager;
	import feathers.core.FeathersControl;
	import feathers.core.PropertyProxy;
	import feathers.data.ListCollection;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Dispatched when the selected item changes.
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * A combo-box like list control. Displayed as a button. The list appears
	 * on tap as a full-screen overlay.
	 *
	 * @see http://wiki.starling-framework.org/feathers/picker-list
	 */
	public class PickerList extends FeathersControl
	{
		/**
		 * The default value added to the <code>nameList</code> of the button.
		 */
		public static const DEFAULT_CHILD_NAME_BUTTON:String = "feathers-picker-list-button";

		/**
		 * The default value added to the <code>nameList</code> of the pop-up
		 * list.
		 */
		public static const DEFAULT_CHILD_NAME_LIST:String = "feathers-picker-list-list";

		/**
		 * @private
		 */
		private static const HELPER_TOUCHES_VECTOR:Vector.<Touch> = new <Touch>[];

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_BUTTON_FACTORY:String = "buttonFactory";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_LIST_FACTORY:String = "listFactory";

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
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		/**
		 * The default value added to the <code>nameList</code> of the button.
		 */
		protected var buttonName:String = DEFAULT_CHILD_NAME_BUTTON;

		/**
		 * The default value added to the <code>nameList</code> of the pop-up list.
		 */
		protected var listName:String = DEFAULT_CHILD_NAME_LIST;

		/**
		 * The button sub-component.
		 */
		protected var button:Button;

		/**
		 * The list sub-component.
		 */
		protected var list:List;

		/**
		 * @private
		 */
		protected var _buttonTouchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _listTouchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _hasBeenScrolled:Boolean = false;
		
		/**
		 * @private
		 */
		protected var _dataProvider:ListCollection;
		
		/**
		 * @copy List#dataProvider
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
			this._dataProvider = value;
			if(!this._dataProvider || this._dataProvider.length == 0)
			{
				this.selectedIndex = -1;
			}
			else if(this._selectedIndex < 0)
			{
				this.selectedIndex = 0;
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		/**
		 * @private
		 */
		protected var _selectedIndex:int = -1;
		
		/**
		 * @copy List#selectedIndex
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
		 * @copy List#selectedItem
		 */
		public function get selectedItem():Object
		{
			if(!this._dataProvider)
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
			this._popUpContentManager = value;
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
		 * This can be used to change properties on the button when it is first
		 * created. For instance, if you are skinning Feathers components
		 * without a theme, you might use <code>buttonFactory</code> to set
		 * skins and text styles on the button.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():Button</pre>
		 *
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
		protected var _customButtonName:String;

		/**
		 * A name to add to the picker list's button sub-component. Typically
		 * used by a theme to provide different skins to different picker lists.
		 *
		 * @see feathers.core.FeathersControl#nameList
		 * @see #buttonFactory
		 * @see #buttonProperties
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
		protected var _buttonProperties:PropertyProxy;
		
		/**
		 * A set of key/value pairs to be passed down to the picker's button
		 * sub-component. It is a <code>feathers.controls.Button</code>
		 * instance.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 * 
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
		protected var _listFactory:Function;

		/**
		 * A function used to generate the picker list's pop-up list
		 * sub-component. This can be used to change properties on the list when
		 * it is first created. For instance, if you are skinning Feathers
		 * components without a theme, you might use <code>listFactory</code> to
		 * set skins and other styles on the list.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():List</pre>
		 *
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
		protected var _customListName:String;

		/**
		 * A name to add to the picker list's list sub-component. Typically used
		 * by a theme to provide different skins to different picker lists.
		 *
		 * @see feathers.core.FeathersControl#nameList
		 * @see #listFactory
		 * @see #listProperties
		 */
		public function get customListName():String
		{
			return this._customListName;
		}

		/**
		 * @private
		 */
		public function set customListName(value:String):void
		{
			if(this._customListName == value)
			{
				return;
			}
			this._customListName = value;
			this.invalidate(INVALIDATION_FLAG_LIST_FACTORY);
		}
		
		/**
		 * @private
		 */
		protected var _listProperties:PropertyProxy;
		
		/**
		 * A set of key/value pairs to be passed down to the picker's pop-up
		 * list sub-component. The pop-up list is a
		 * <code>feathers.controls.List</code> instance.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 * 
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
				const newValue:PropertyProxy = new PropertyProxy();
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
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			this.closePopUpList();
			this.list.dispose();
			super.dispose();
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
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const buttonFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_BUTTON_FACTORY);
			const listFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LIST_FACTORY);

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
				if(isNaN(this.explicitWidth))
				{
					this.button.width = NaN;
				}
				if(isNaN(this.explicitHeight))
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
				this.list.dataProvider = this._dataProvider;
				this._hasBeenScrolled = false;
			}
			
			if(buttonFactoryInvalid || listFactoryInvalid || stateInvalid)
			{
				this.button.isEnabled = this._isEnabled;
				this.list.isEnabled = this._isEnabled;
			}

			if(buttonFactoryInvalid || selectionInvalid)
			{
				this.refreshButtonLabel();
			}
			if(listFactoryInvalid || selectionInvalid)
			{
				this.list.selectedIndex = this._selectedIndex;
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(buttonFactoryInvalid || sizeInvalid || selectionInvalid)
			{
				this.layout();
			}
		}

		/**
		 * @private
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}

			this.button.width = NaN;
			this.button.height = NaN;
			if(this._typicalItem)
			{
				if(isNaN(this._typicalItemWidth) || isNaN(this._typicalItemHeight))
				{
					this.button.label = this.itemToLabel(this._typicalItem);
					this.button.validate();
					this._typicalItemWidth = this.button.width;
					this._typicalItemHeight = this.button.height;
					this.refreshButtonLabel();
				}
			}
			else
			{
				this.button.validate();
				this._typicalItemWidth = this.button.width;
				this._typicalItemHeight = this.button.height;
			}

			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth)
			{
				newWidth = this._typicalItemWidth;
			}
			if(needsHeight)
			{
				newHeight = this._typicalItemHeight;
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		protected function createButton():void
		{
			if(this.button)
			{
				this.button.removeFromParent(true);
				this.button = null;
			}

			const factory:Function = this._buttonFactory != null ? this._buttonFactory : defaultButtonFactory;
			const buttonName:String = this._customButtonName != null ? this._customButtonName : this.buttonName;
			this.button = Button(factory());
			this.button.nameList.add(buttonName);
			this.button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			this.button.addEventListener(TouchEvent.TOUCH, button_touchHandler);
			this.addChild(this.button);
		}

		/**
		 * @private
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

			const factory:Function = this._listFactory != null ? this._listFactory : defaultListFactory;
			const listName:String = this._customListName != null ? this._customListName : this.listName;
			this.list = List(factory());
			this.list.nameList.add(listName);
			this.list.addEventListener(Event.SCROLL, list_scrollHandler);
			this.list.addEventListener(Event.CHANGE, list_changeHandler);
			this.list.addEventListener(TouchEvent.TOUCH, list_touchHandler);
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
				if(this.button.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._buttonProperties[propertyName];
					this.button[propertyName] = propertyValue;
				}
			}
		}
		
		/**
		 * @private
		 */
		protected function refreshListProperties():void
		{
			for(var propertyName:String in this._listProperties)
			{
				if(this.list.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._listProperties[propertyName];
					this.list[propertyName] = propertyValue;
				}
			}
		}

		/**
		 * @private
		 */
		protected function layout():void
		{
			this.button.width = this.actualWidth;
			this.button.height = this.actualHeight;
		}
		
		/**
		 * @private
		 */
		protected function closePopUpList():void
		{
			this.list.validate();
			this._popUpContentManager.close();
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
		protected function button_triggeredHandler(event:Event):void
		{
			if(this.list.stage)
			{
				this.closePopUpList();
				return;
			}
			this._popUpContentManager.open(this.list, this);
			this.list.scrollToDisplayIndex(this._selectedIndex);
			this.list.validate();

			this._hasBeenScrolled = false;
		}
		
		/**
		 * @private
		 */
		protected function list_changeHandler(event:Event):void
		{
			this.selectedIndex = this.list.selectedIndex;
		}
		
		/**
		 * @private
		 */
		protected function list_scrollHandler(event:Event):void
		{
			if(this._listTouchPointID >= 0)
			{
				this._hasBeenScrolled = true;
			}
		}

		/**
		 * @private
		 */
		protected function removedFromStageHandler(event:Event):void
		{
			this._buttonTouchPointID = -1;
			this._listTouchPointID = -1;
		}

		/**
		 * @private
		 */
		protected function button_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				this._buttonTouchPointID = -1;
				return;
			}
			const touches:Vector.<Touch> = event.getTouches(this.button, null, HELPER_TOUCHES_VECTOR);
			if(touches.length == 0)
			{
				return;
			}
			if(this._buttonTouchPointID >= 0)
			{
				var touch:Touch;
				for each(var currentTouch:Touch in touches)
				{
					if(currentTouch.id == this._buttonTouchPointID)
					{
						touch = currentTouch;
						break;
					}
				}
				if(!touch)
				{
					HELPER_TOUCHES_VECTOR.length = 0;
					return;
				}
				if(touch.phase == TouchPhase.ENDED)
				{
					this._buttonTouchPointID = -1;
				}
			}
			else
			{
				for each(touch in touches)
				{
					if(touch.phase == TouchPhase.BEGAN)
					{
						this._buttonTouchPointID = touch.id;
						break;
					}
				}
			}
			HELPER_TOUCHES_VECTOR.length = 0;
		}
		
		/**
		 * @private
		 */
		protected function list_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				this._listTouchPointID = -1;
				return;
			}
			const touches:Vector.<Touch> = event.getTouches(this.list, null, HELPER_TOUCHES_VECTOR);
			if(touches.length == 0)
			{
				HELPER_TOUCHES_VECTOR.length = 0;
				return;
			}
			if(this._listTouchPointID >= 0)
			{
				var touch:Touch;
				for each(var currentTouch:Touch in touches)
				{
					if(currentTouch.id == this._listTouchPointID)
					{
						touch = currentTouch;
						break;
					}
				}
				if(!touch)
				{
					HELPER_TOUCHES_VECTOR.length = 0;
					return;
				}
				if(touch.phase == TouchPhase.ENDED)
				{
					if(!this._hasBeenScrolled)
					{
						this.closePopUpList();
					}
					this._listTouchPointID = -1;
				}
			}
			else
			{
				for each(touch in touches)
				{
					if(touch.phase == TouchPhase.BEGAN)
					{
						this._listTouchPointID = touch.id;
						this._hasBeenScrolled = false;
						break;
					}
				}
			}
			HELPER_TOUCHES_VECTOR.length = 0;
		}
	}
}