/*
Copyright (c) 2012 Josh Tynjala

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
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
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * A combo-box like list control. Displayed as a button. The list appears
	 * on tap as a full-screen overlay.
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
		 * Constructor.
		 */
		public function PickerList()
		{
			super();
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		/**
		 * The value added to the <code>nameList</code> of the button.
		 */
		protected var buttonName:String = DEFAULT_CHILD_NAME_BUTTON;

		/**
		 * The value added to the <code>nameList</code> of the pop-up list.
		 */
		protected var listName:String = DEFAULT_CHILD_NAME_LIST;
		
		private var _button:Button;
		private var _list:List;

		private var _buttonTouchPointID:int = -1;
		private var _listTouchPointID:int = -1;
		private var _hasBeenScrolled:Boolean = false;
		
		/**
		 * @private
		 */
		private var _dataProvider:ListCollection;
		
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
				this.selectedIndex = 0
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		/**
		 * @private
		 */
		private var _selectedIndex:int = -1;
		
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
			this._onChange.dispatch(this);
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
		private var _labelField:String = "label";
		
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
		private var _labelFunction:Function;

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
		private var _popUpContentManager:IPopUpContentManager;
		
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
		private var _typicalItem:Object = null;
		
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
		protected var _onChange:Signal = new Signal(PickerList);
		
		/**
		 * @copy List#onChange
		 */
		public function get onChange():ISignal
		{
			return this._onChange;
		}
		
		/**
		 * @private
		 */
		private var _buttonProperties:PropertyProxy;
		
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
				this._buttonProperties = new PropertyProxy(buttonProperties_onChange);
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
				this._buttonProperties.onChange.remove(buttonProperties_onChange);
			}
			this._buttonProperties = PropertyProxy(value);
			if(this._buttonProperties)
			{
				this._buttonProperties.onChange.add(buttonProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		private var _listProperties:PropertyProxy;
		
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
				this._listProperties = new PropertyProxy(listProperties_onChange);
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
				this._listProperties.onChange.remove(listProperties_onChange);
			}
			this._listProperties = PropertyProxy(value);
			if(this._listProperties)
			{
				this._listProperties.onChange.add(listProperties_onChange);
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
			this._onChange.removeAll();
			this._list.dispose();
			super.dispose();
		}
		
		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(!this._button)
			{
				this._button = new Button();
				this._button.nameList.add(this.buttonName);
				this._button.onRelease.add(button_onRelease);
				this._button.addEventListener(TouchEvent.TOUCH, button_touchHandler);
				this.addChild(this._button);
			}
			
			if(!this._list)
			{
				this._list = new List();
				this._list.nameList.add(this.listName);
				this._list.onScroll.add(list_onScroll);
				this._list.onChange.add(list_onChange);
				this._list.addEventListener(TouchEvent.TOUCH, list_touchHandler);
			}

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
			
			if(stylesInvalid || selectionInvalid)
			{
				//this section asks the button to auto-size again, if our
				//explicit dimensions aren't set.
				//set this before buttonProperties is used because it might
				//contain width or height changes.
				if(isNaN(this.explicitWidth))
				{
					this._button.width = NaN;
				}
				if(isNaN(this.explicitHeight))
				{
					this._button.height = NaN;
				}
			}

			if(stylesInvalid)
			{
				this._typicalItemWidth = NaN;
				this._typicalItemHeight = NaN;
				this.refreshButtonProperties();
				this.refreshListProperties();
			}
			
			if(dataInvalid)
			{
				this._list.dataProvider = this._dataProvider;
				this._hasBeenScrolled = false;
			}
			
			if(stateInvalid)
			{
				this._button.isEnabled = this.isEnabled;
			}

			if(selectionInvalid)
			{
				this.refreshButtonLabel();
				this._list.selectedIndex = this._selectedIndex;
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			this._button.width = this.actualWidth;
			this._button.height = this.actualHeight;
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

			this._button.width = NaN;
			this._button.height = NaN;
			if(this._typicalItem)
			{
				if(isNaN(this._typicalItemWidth) || isNaN(this._typicalItemHeight))
				{
					this._button.label = this.itemToLabel(this._typicalItem);
					this._button.validate();
					this._typicalItemWidth = this._button.width;
					this._typicalItemHeight = this._button.height;
					this.refreshButtonLabel();
				}
			}
			else
			{
				this._button.validate();
				this._typicalItemWidth = this._button.width;
				this._typicalItemHeight = this._button.height;
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
		protected function refreshButtonLabel():void
		{
			if(this._selectedIndex >= 0)
			{
				this._button.label = this.itemToLabel(this.selectedItem);
			}
			else
			{
				this._button.label = "";
			}
		}
		
		/**
		 * @private
		 */
		protected function refreshButtonProperties():void
		{
			for(var propertyName:String in this._buttonProperties)
			{
				if(this._button.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._buttonProperties[propertyName];
					this._button[propertyName] = propertyValue;
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
				if(this._list.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._listProperties[propertyName];
					this._list[propertyName] = propertyValue;
				}
			}
		}
		
		/**
		 * @private
		 */
		protected function closePopUpList():void
		{
			this._list.validate();
			this._popUpContentManager.close();
		}

		/**
		 * @private
		 */
		protected function buttonProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function listProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		protected function button_onRelease(button:Button):void
		{
			this._popUpContentManager.open(this._list, this);
			this._list.scrollToDisplayIndex(this._selectedIndex);
			this._list.validate();

			this._hasBeenScrolled = false;
		}
		
		/**
		 * @private
		 */
		protected function list_onChange(list:List):void
		{
			this.selectedIndex = this._list.selectedIndex;
		}
		
		/**
		 * @private
		 */
		protected function list_onScroll(list:List):void
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
			const touches:Vector.<Touch> = event.getTouches(this._button);
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
					return;
				}
				if(touch.phase == TouchPhase.ENDED)
				{
					this._buttonTouchPointID = -1;
					return;
				}
			}
			else
			{
				for each(touch in touches)
				{
					if(touch.phase == TouchPhase.BEGAN)
					{
						this._buttonTouchPointID = touch.id;
						return;
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		protected function list_touchHandler(event:TouchEvent):void
		{
			const touches:Vector.<Touch> = event.getTouches(this._list);
			if(touches.length == 0)
			{
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
					}
				}
			}
		}
	}
}