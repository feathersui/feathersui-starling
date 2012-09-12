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
	import feathers.core.FeathersControl;
	import feathers.core.PropertyProxy;
	import feathers.core.ToggleGroup;
	import feathers.data.ListCollection;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	/**
	 * A line of tabs, where one may be selected at a time.
	 */
	public class TabBar extends FeathersControl
	{
		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_TAB_FACTORY:String = "tabFactory";

		/**
		 * @private
		 */
		private static const DEFAULT_TAB_FIELDS:Vector.<String> = new <String>
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
			"selectedDisabledIcon"
		];

		/**
		 * The tabs are displayed in order from left to right.
		 */
		public static const DIRECTION_HORIZONTAL:String = "horizontal";

		/**
		 * The tabs are displayed in order from top to bottom.
		 */
		public static const DIRECTION_VERTICAL:String = "vertical";

		/**
		 * The default value added to the <code>nameList</code> of the tabs.
		 */
		public static const DEFAULT_CHILD_NAME_TAB:String = "feathers-tab-bar-tab";

		/**
		 * @private
		 */
		protected static function defaultTabFactory():Button
		{
			return new Button();
		}

		/**
		 * Constructor.
		 */
		public function TabBar()
		{
		}

		/**
		 * The value added to the <code>nameList</code> of the tabs.
		 */
		protected var tabName:String = DEFAULT_CHILD_NAME_TAB;

		/**
		 * The value added to the <code>nameList</code> of the first tab.
		 */
		protected var firstTabName:String = DEFAULT_CHILD_NAME_TAB;

		/**
		 * The value added to the <code>nameList</code> of the last tab.
		 */
		protected var lastTabName:String = DEFAULT_CHILD_NAME_TAB;

		/**
		 * @private
		 */
		protected var toggleGroup:ToggleGroup;

		/**
		 * @private
		 */
		protected var activeFirstTab:Button;

		/**
		 * @private
		 */
		protected var inactiveFirstTab:Button;

		/**
		 * @private
		 */
		protected var activeLastTab:Button;

		/**
		 * @private
		 */
		protected var inactiveLastTab:Button;

		/**
		 * @private
		 */
		protected var activeTabs:Vector.<Button> = new <Button>[];

		/**
		 * @private
		 */
		protected var inactiveTabs:Vector.<Button> = new <Button>[];

		/**
		 * @private
		 */
		private var _dataProvider:ListCollection;

		/**
		 * The collection of data to be displayed with tabs.
		 *
		 * @see #tabInitializer
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
				this._dataProvider.onChange.remove(dataProvider_onChange);
			}
			this._dataProvider = value;
			if(this._dataProvider)
			{
				this._dataProvider.onChange.add(dataProvider_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _direction:String = DIRECTION_HORIZONTAL;

		/**
		 * The tab bar layout is either vertical or horizontal.
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
		protected var _gap:Number = 0;

		/**
		 * Space, in pixels, between tabs.
		 */
		public function get gap():Number
		{
			return _gap;
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
		private var _tabFactory:Function = defaultTabFactory;

		/**
		 * Creates a new tab.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 *
		 * <pre>function():Button</pre>
		 *
		 * @see #firstTabFactory
		 * @see #lastTabFactory
		 */
		public function get tabFactory():Function
		{
			return this._tabFactory;
		}

		/**
		 * @private
		 */
		public function set tabFactory(value:Function):void
		{
			if(this._tabFactory == value)
			{
				return;
			}
			this._tabFactory = value;
			this.invalidate(INVALIDATION_FLAG_TAB_FACTORY);
		}

		/**
		 * @private
		 */
		private var _firstTabFactory:Function;

		/**
		 * Creates a new first tab.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 *
		 * <pre>function():Button</pre>
		 *
		 * @see #tabFactory
		 * @see #lastTabFactory
		 */
		public function get firstTabFactory():Function
		{
			return this._firstTabFactory;
		}

		/**
		 * @private
		 */
		public function set firstTabFactory(value:Function):void
		{
			if(this._firstTabFactory == value)
			{
				return;
			}
			this._firstTabFactory = value;
			this.invalidate(INVALIDATION_FLAG_TAB_FACTORY);
		}

		/**
		 * @private
		 */
		private var _lastTabFactory:Function;

		/**
		 * Creates a new last tab. If the lastTabFactory is null, then the
		 * TabBar will use the tabFactory.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 *
		 * <pre>function():Button</pre>
		 *
		 * @see #tabFactory
		 * @see #firstTabFactory
		 */
		public function get lastTabFactory():Function
		{
			return this._lastTabFactory;
		}

		/**
		 * @private
		 */
		public function set lastTabFactory(value:Function):void
		{
			if(this._lastTabFactory == value)
			{
				return;
			}
			this._lastTabFactory = value;
			this.invalidate(INVALIDATION_FLAG_TAB_FACTORY);
		}

		/**
		 * @private
		 */
		private var _tabInitializer:Function = defaultTabInitializer;

		/**
		 * Modifies a tab, perhaps by changing its label and icons, based on the
		 * item from the data provider that the tab is meant to represent. The
		 * default tabInitializer function can set the tab's label and icons if
		 * <code>label</code> and/or any of the <code>Button</code> icon fields
		 * (<code>defaultIcon</code>, <code>upIcon</code>, etc.) are present in
		 * the item.
		 */
		public function get tabInitializer():Function
		{
			return this._tabInitializer;
		}

		/**
		 * @private
		 */
		public function set tabInitializer(value:Function):void
		{
			if(this._tabInitializer == value)
			{
				return;
			}
			this._tabInitializer = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		private var _pendingSelectedIndex:int = -1;

		/**
		 * The index of the currently selected tab. Returns -1 if no tab is
		 * selected.
		 */
		public function get selectedIndex():int
		{
			if(this._pendingSelectedIndex >= 0 || !this.toggleGroup)
			{
				return this._pendingSelectedIndex;
			}
			return this.toggleGroup.selectedIndex;
		}

		/**
		 * @private
		 */
		public function set selectedIndex(value:int):void
		{
			this._pendingSelectedIndex = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * The currently selected item from the data provider. Returns
		 * <code>null</code> if no item is selected.
		 */
		public function get selectedItem():Object
		{
			const index:int = this.selectedIndex;
			if(!this._dataProvider || index < 0 || index >= this._dataProvider.length)
			{
				return null;
			}

			return this._dataProvider.getItemAt(index);
		}

		/**
		 * @private
		 */
		public function set selectedItem(value:Object):void
		{
			this.selectedIndex = this._dataProvider.getItemIndex(value);
		}

		/**
		 * @private
		 */
		protected var _customTabName:String;

		/**
		 * A name to add to all tabs in this tab bar. Typically used by a theme
		 * to provide different skins to different tab bars.
		 *
		 * @see feathers.core.FeathersControl#nameList
		 */
		public function get customTabName():String
		{
			return this._customTabName;
		}

		/**
		 * @private
		 */
		public function set customTabName(value:String):void
		{
			if(this._customTabName == value)
			{
				return;
			}
			if(this._customTabName)
			{
				for each(var tab:Button in this.activeTabs)
				{
					tab.nameList.remove(this._customTabName);
				}
			}
			this._customTabName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _customFirstTabName:String;

		/**
		 * A name to add to the first tab in this tab bar. Typically used by a
		 * theme to provide different skins to the first tab.
		 *
		 * @see feathers.core.FeathersControl#nameList
		 */
		public function get customFirstTabName():String
		{
			return this._customFirstTabName;
		}

		/**
		 * @private
		 */
		public function set customFirstTabName(value:String):void
		{
			if(this._customFirstTabName == value)
			{
				return;
			}
			if(this._customFirstTabName && this.activeFirstTab)
			{
				this.activeFirstTab.nameList.remove(this._customTabName);
				this.activeFirstTab.nameList.remove(this._customFirstTabName);
			}
			this._customFirstTabName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _customLastTabName:String;

		/**
		 * A name to add to the last tab in this tab bar. Typically used by a
		 * theme to provide different skins to the last tab.
		 *
		 * @see feathers.core.FeathersControl#nameList
		 */
		public function get customLastTabName():String
		{
			return this._customLastTabName;
		}

		/**
		 * @private
		 */
		public function set customLastTabName(value:String):void
		{
			if(this._customLastTabName == value)
			{
				return;
			}
			if(this._customLastTabName && this.activeLastTab)
			{
				this.activeLastTab.nameList.remove(this._customTabName);
				this.activeLastTab.nameList.remove(this._customLastTabName);
			}
			this._customLastTabName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _onChange:Signal = new Signal(TabBar);

		/**
		 * Dispatched when the selected tab changes.
		 */
		public function get onChange():ISignal
		{
			return this._onChange;
		}

		/**
		 * @private
		 */
		private var _tabProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to all of the tab bar's
		 * tabs. These values are shared by each tabs, so values that cannot be
		 * shared (such as display objects that need to be added to the display
		 * list) should be passed to tabs in another way (such as with an
		 * <code>AddedWatcher</code>).
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * @see AddedWatcher
		 */
		public function get tabProperties():Object
		{
			if(!this._tabProperties)
			{
				this._tabProperties = new PropertyProxy(tabProperties_onChange);
			}
			return this._tabProperties;
		}

		/**
		 * @private
		 */
		public function set tabProperties(value:Object):void
		{
			if(this._tabProperties == value)
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
			if(this._tabProperties)
			{
				this._tabProperties.onChange.remove(tabProperties_onChange);
			}
			this._tabProperties = PropertyProxy(value);
			if(this._tabProperties)
			{
				this._tabProperties.onChange.add(tabProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this._onChange.removeAll();
			super.dispose();
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			this.toggleGroup = new ToggleGroup();
			this.toggleGroup.isSelectionRequired = true;
			this.toggleGroup.onChange.add(toggleGroup_onChange);
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
			const tabFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TAB_FACTORY);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);

			if(dataInvalid || tabFactoryInvalid)
			{
				this.refreshTabs(tabFactoryInvalid);
			}

			if(dataInvalid || tabFactoryInvalid || stylesInvalid)
			{
				this.refreshTabStyles();
			}

			if(dataInvalid || tabFactoryInvalid || selectionInvalid)
			{
				this.commitSelection();
			}

			if(dataInvalid || tabFactoryInvalid || stateInvalid)
			{
				this.commitEnabled();
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(sizeInvalid || dataInvalid || tabFactoryInvalid || stylesInvalid)
			{
				this.layoutTabs();
			}
		}

		/**
		 * @private
		 */
		protected function commitSelection():void
		{
			if(this._pendingSelectedIndex < 0 || !this.toggleGroup)
			{
				return;
			}
			if(this.toggleGroup.selectedIndex == this._pendingSelectedIndex)
			{
				this._pendingSelectedIndex = -1;
				return;
			}
			this.toggleGroup.selectedIndex = this._pendingSelectedIndex;
			this._pendingSelectedIndex = -1;
			this._onChange.dispatch(this);
		}

		/**
		 * @private
		 */
		protected function commitEnabled():void
		{
			for each(var tab:Button in this.activeTabs)
			{
				tab.isEnabled = this._isEnabled;
			}
		}

		/**
		 * @private
		 */
		protected function refreshTabStyles():void
		{
			for each(var tab:Button in this.activeTabs)
			{
				for(var propertyName:String in this._tabProperties)
				{
					var propertyValue:Object = this._tabProperties[propertyName];
					if(tab.hasOwnProperty(propertyName))
					{
						tab[propertyName] = propertyValue;
					}
				}

				if(tab == this.activeFirstTab && this._customFirstTabName)
				{
					if(!tab.nameList.contains(this._customFirstTabName))
					{
						tab.nameList.add(this._customFirstTabName);
					}
				}
				else if(tab == this.activeLastTab && this._customLastTabName)
				{
					if(!tab.nameList.contains(this._customLastTabName))
					{
						tab.nameList.add(this._customLastTabName);
					}
				}
				else if(this._customTabName && !tab.nameList.contains(this._customTabName))
				{
					tab.nameList.add(this._customTabName);
				}
			}
		}

		/**
		 * @private
		 */
		protected function defaultTabInitializer(tab:Button, item:Object):void
		{
			if(item is Object)
			{
				if(item.hasOwnProperty("label"))
				{
					tab.label = item.label;
				}
				else
				{
					tab.label = item.toString();
				}
				for each(var field:String in DEFAULT_TAB_FIELDS)
				{
					if(item.hasOwnProperty(field))
					{
						tab[field] = item[field];
					}
				}
			}
			else
			{
				tab.label = "";
			}

		}

		/**
		 * @private
		 */
		protected function refreshTabs(isFactoryInvalid:Boolean):void
		{
			var temp:Vector.<Button> = this.inactiveTabs;
			this.inactiveTabs = this.activeTabs;
			this.activeTabs = temp;
			this.activeTabs.length = 0;
			temp = null;
			if(isFactoryInvalid)
			{
				this.clearInactiveTabs();
			}
			else
			{
				if(this.activeFirstTab)
				{
					this.inactiveTabs.shift();
				}
				this.inactiveFirstTab = this.activeFirstTab;

				if(this.activeLastTab)
				{
					this.inactiveTabs.pop();
				}
				this.inactiveLastTab = this.activeLastTab;
			}
			this.activeFirstTab = null;
			this.activeLastTab = null;

			const itemCount:int = this._dataProvider ? this._dataProvider.length : 0;
			const lastItemIndex:int = itemCount - 1;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = this._dataProvider.getItemAt(i);
				if(i == 0)
				{
					var tab:Button = this.activeFirstTab = this.createFirstTab(item);
				}
				else if(i == lastItemIndex)
				{
					tab = this.activeLastTab = this.createLastTab(item);
				}
				else
				{
					tab = this.createTab(item);
				}
				this.activeTabs.push(tab);
			}
			this.clearInactiveTabs();
		}

		/**
		 * @private
		 */
		protected function clearInactiveTabs():void
		{
			const itemCount:int = this.inactiveTabs.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var tab:Button = this.inactiveTabs.shift();
				this.destroyTab(tab);
			}

			if(this.inactiveFirstTab)
			{
				this.destroyTab(this.inactiveFirstTab);
				this.inactiveFirstTab = null;
			}

			if(this.inactiveLastTab)
			{
				this.destroyTab(this.inactiveLastTab);
				this.inactiveLastTab = null;
			}
		}

		/**
		 * @private
		 */
		protected function createFirstTab(item:Object):Button
		{
			if(this.inactiveFirstTab)
			{
				var tab:Button = this.inactiveFirstTab;
				this.inactiveFirstTab = null;
			}
			else
			{
				const factory:Function = this._firstTabFactory != null ? this._firstTabFactory : this._tabFactory;
				tab = factory();
				if(this._customFirstTabName)
				{
					tab.nameList.add(this._customFirstTabName);
				}
				else
				{
					tab.nameList.add(this.firstTabName);
				}
				tab.isToggle = true;
				this.toggleGroup.addItem(tab);
				this.addChild(tab);
			}
			this._tabInitializer(tab, item);
			return tab;
		}

		/**
		 * @private
		 */
		protected function createLastTab(item:Object):Button
		{
			if(this.inactiveLastTab)
			{
				var tab:Button = this.inactiveLastTab;
				this.inactiveLastTab = null;
			}
			else
			{
				const factory:Function = this._lastTabFactory != null ? this._lastTabFactory : this._tabFactory;
				tab = factory();
				if(this._customLastTabName)
				{
					tab.nameList.add(this._customLastTabName);
				}
				else
				{
					tab.nameList.add(this.lastTabName);
				}
				tab.isToggle = true;
				this.toggleGroup.addItem(tab);
				this.addChild(tab);
			}
			this._tabInitializer(tab, item);
			return tab;
		}

		/**
		 * @private
		 */
		protected function createTab(item:Object):Button
		{
			if(this.inactiveTabs.length == 0)
			{
				var tab:Button = this._tabFactory();
				if(this._customTabName)
				{
					tab.nameList.add(this._customTabName);
				}
				else
				{
					tab.nameList.add(this.tabName);
				}
				tab.isToggle = true;
				this.toggleGroup.addItem(tab);
				this.addChild(tab);
			}
			else
			{
				tab = this.inactiveTabs.shift();
			}
			this._tabInitializer(tab, item);
			return tab;
		}

		/**
		 * @private
		 */
		protected function destroyTab(tab:Button):void
		{
			this.toggleGroup.removeItem(tab);
			this.removeChild(tab);
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

			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth)
			{
				newWidth = 0;
				for each(var tab:Button in this.activeTabs)
				{
					tab.validate();
					newWidth = Math.max(tab.width, newWidth);
				}
				newWidth = this.activeTabs.length * (newWidth + this._gap) - this._gap;
			}

			if(needsHeight)
			{
				newHeight = 0;
				for each(tab in this.activeTabs)
				{
					tab.validate();
					newHeight = Math.max(tab.height, newHeight);
				}
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		protected function layoutTabs():void
		{
			const tabCount:int = this.activeTabs.length;
			const tabSize:Number = (this._direction == DIRECTION_VERTICAL ? this.actualHeight : this.actualWidth) / tabCount;
			var position:Number = 0;
			for(var i:int = 0; i < tabCount; i++)
			{
				var tab:Button = this.activeTabs[i];
				if(this._direction == DIRECTION_VERTICAL)
				{
					tab.width = this.actualWidth;
					tab.height = tabSize;
					tab.x = 0;
					tab.y = position;
					position += tab.height + this._gap;
				}
				else //horizontal
				{
					tab.width = tabSize;
					tab.height = this.actualHeight;
					tab.x = position;
					tab.y = 0;
					position += tab.width + this._gap;
				}
			}
		}

		/**
		 * @private
		 */
		protected function tabProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function toggleGroup_onChange(toggleGroup:ToggleGroup):void
		{
			if(this._pendingSelectedIndex >= 0)
			{
				return;
			}
			this._onChange.dispatch(this);
		}

		/**
		 * @private
		 */
		protected function dataProvider_onChange(data:ListCollection):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
	}
}
