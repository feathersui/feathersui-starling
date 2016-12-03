package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.ToggleSwitch;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.examples.componentsExplorer.data.EmbeddedAssets;
	import feathers.examples.componentsExplorer.data.ItemRendererSettings;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.skins.IStyleProvider;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]
	[Event(name="showSettings",type="starling.events.Event")]

	public class ItemRendererScreen extends PanelScreen
	{
		public static const SHOW_SETTINGS:String = "showSettings";

		public static var globalStyleProvider:IStyleProvider;

		public function ItemRendererScreen()
		{
			super();
		}

		private var _list:List;
		private var _listItem:Object;

		private var _itemRendererGap:Number = 0;

		public function get itemRendererGap():Number
		{
			return this._itemRendererGap;
		}

		public function set itemRendererGap(value:Number):void
		{
			if(this._itemRendererGap == value)
			{
				return;
			}
			this._itemRendererGap = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		private var _settings:ItemRendererSettings;

		public function get settings():ItemRendererSettings
		{
			return this._settings;
		}

		public function set settings(value:ItemRendererSettings):void
		{
			if(this._settings == value)
			{
				return;
			}
			this._settings = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		override protected function get defaultStyleProvider():IStyleProvider
		{
			return ItemRendererScreen.globalStyleProvider;
		}

		override public function dispose():void
		{
			//icon and accessory display objects in the list's data provider
			//won't be automatically disposed because feathers cannot know if
			//they need to be used again elsewhere or not. we need to dispose
			//them manually.
			this._list.dataProvider.dispose(disposeItemIconOrAccessory);

			//never forget to call super.dispose() because you don't want to
			//create a memory leak!
			super.dispose();
		}

		override protected function initialize():void
		{
			//never forget to call super.initialize()!
			super.initialize();

			this.title = "Item Renderer";

			this.layout = new AnchorLayout();

			this._list = new List();

			this._listItem = { text: "Primary Text" };
			this._list.itemRendererFactory = this.customItemRendererFactory;
			this._list.dataProvider = new ListCollection([this._listItem]);
			this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this._list.isSelectable = false;
			this._list.clipContent = false;
			this._list.autoHideBackground = true;
			this.addChild(this._list);

			this.headerFactory = this.customHeaderFactory;

			//this screen doesn't use a back button on tablets because the main
			//app's uses a split layout
			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this.backButtonHandler = this.onBackButton;
			}
		}

		private function customItemRendererFactory():IListItemRenderer
		{
			var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			itemRenderer.labelField = "text";
			if(this.settings.hasIcon)
			{
				switch(this.settings.iconType)
				{
					case ItemRendererSettings.ICON_ACCESSORY_TYPE_LABEL:
					{
						this._listItem.iconText = "Icon Text";
						itemRenderer.iconLabelField = "iconText";

						//clear these in case this setting has changed
						delete this._listItem.iconTexture;
						delete this._listItem.icon;
						break;
					}
					case ItemRendererSettings.ICON_ACCESSORY_TYPE_TEXTURE:
					{
						this._listItem.iconTexture = EmbeddedAssets.SKULL_ICON_LIGHT;
						itemRenderer.iconSourceField = "iconTexture";

						//clear these in case this setting has changed
						delete this._listItem.iconText;
						delete this._listItem.icon;
						break;
					}
					default:
					{
						this._listItem.icon = new ToggleSwitch();
						itemRenderer.iconField = "icon";

						//clear these in case this setting has changed
						delete this._listItem.iconText;
						delete this._listItem.iconTexture;

					}
				}
				itemRenderer.iconPosition = this.settings.iconPosition;
			}
			if(this.settings.hasAccessory)
			{
				switch(this.settings.accessoryType)
				{
					case ItemRendererSettings.ICON_ACCESSORY_TYPE_LABEL:
					{
						this._listItem.accessoryText = "Accessory Text";
						itemRenderer.accessoryLabelField = "accessoryText";

						//clear these in case this setting has changed
						delete this._listItem.accessoryTexture;
						delete this._listItem.accessory;
						break;
					}
					case ItemRendererSettings.ICON_ACCESSORY_TYPE_TEXTURE:
					{
						this._listItem.accessoryTexture = EmbeddedAssets.SKULL_ICON_LIGHT;
						itemRenderer.accessorySourceField = "accessoryTexture";
						break;
					}
					default:
					{
						this._listItem.accessory = new ToggleSwitch();
						itemRenderer.accessoryField = "accessory";

						//clear these in case this setting has changed
						delete this._listItem.accessoryText;
						delete this._listItem.accessoryTexture;
					}
				}
				itemRenderer.accessoryPosition = this.settings.accessoryPosition;
			}
			if(this.settings.useInfiniteGap)
			{
				itemRenderer.gap = Number.POSITIVE_INFINITY;
			}
			else
			{
				itemRenderer.gap = this._itemRendererGap;
			}
			if(this.settings.useInfiniteAccessoryGap)
			{
				itemRenderer.accessoryGap = Number.POSITIVE_INFINITY;
			}
			else
			{
				itemRenderer.accessoryGap = this._itemRendererGap;
			}
			itemRenderer.horizontalAlign = this.settings.horizontalAlign;
			itemRenderer.verticalAlign = this.settings.verticalAlign;
			itemRenderer.layoutOrder = this.settings.layoutOrder;
			return itemRenderer;
		}

		private function customHeaderFactory():Header
		{
			var header:Header = new Header();
			//this screen doesn't use a back button on tablets because the main
			//app's uses a split layout
			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				var backButton:Button = new Button();
				backButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON);
				backButton.label = "Back";
				backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);
				header.leftItems = new <DisplayObject>
				[
					backButton
				];
			}
			var settingsButton:Button = new Button();
			settingsButton.label = "Settings";
			settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);
			header.rightItems = new <DisplayObject>
			[
				settingsButton
			];
			return header;
		}

		private function disposeItemIconOrAccessory(item:Object):void
		{
			if(item.hasOwnProperty("icon"))
			{
				DisplayObject(item.icon).dispose();
			}
			if(item.hasOwnProperty("accessory"))
			{
				DisplayObject(item.accessory).dispose();
			}
		}

		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}

		private function settingsButton_triggeredHandler(event:Event):void
		{
			this.dispatchEventWith(SHOW_SETTINGS);
		}
	}
}
