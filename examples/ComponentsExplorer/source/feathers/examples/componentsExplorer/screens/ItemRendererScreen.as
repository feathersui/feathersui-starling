package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.ToggleSwitch;
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
			this._list.itemRendererProperties.labelField = "text";
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

		override protected function draw():void
		{
			if(this.settings.hasIcon)
			{
				switch(this.settings.iconType)
				{
					case ItemRendererSettings.ICON_ACCESSORY_TYPE_LABEL:
					{
						this._listItem.iconText = "Icon Text";
						this._list.itemRendererProperties.iconLabelField = "iconText";

						//clear these in case this setting has changed
						delete this._listItem.iconTexture;
						delete this._listItem.icon;
						break;
					}
					case ItemRendererSettings.ICON_ACCESSORY_TYPE_TEXTURE:
					{
						this._listItem.iconTexture = EmbeddedAssets.SKULL_ICON_LIGHT;
						this._list.itemRendererProperties.iconSourceField = "iconTexture";

						//clear these in case this setting has changed
						delete this._listItem.iconText;
						delete this._listItem.icon;
						break;
					}
					default:
					{
						this._listItem.icon = new ToggleSwitch();
						this._list.itemRendererProperties.iconField = "icon";

						//clear these in case this setting has changed
						delete this._listItem.iconText;
						delete this._listItem.iconTexture;

					}
				}
				this._list.itemRendererProperties.iconPosition = this.settings.iconPosition;
			}
			if(this.settings.hasAccessory)
			{
				switch(this.settings.accessoryType)
				{
					case ItemRendererSettings.ICON_ACCESSORY_TYPE_LABEL:
					{
						this._listItem.accessoryText = "Accessory Text";
						this._list.itemRendererProperties.accessoryLabelField = "accessoryText";

						//clear these in case this setting has changed
						delete this._listItem.accessoryTexture;
						delete this._listItem.accessory;
						break;
					}
					case ItemRendererSettings.ICON_ACCESSORY_TYPE_TEXTURE:
					{
						this._listItem.accessoryTexture = EmbeddedAssets.SKULL_ICON_LIGHT;
						this._list.itemRendererProperties.accessorySourceField = "accessoryTexture";
						break;
					}
					default:
					{
						this._listItem.accessory = new ToggleSwitch();
						this._list.itemRendererProperties.accessoryField = "accessory";

						//clear these in case this setting has changed
						delete this._listItem.accessoryText;
						delete this._listItem.accessoryTexture;
					}
				}
				this._list.itemRendererProperties.accessoryPosition = this.settings.accessoryPosition;
			}
			if(this.settings.useInfiniteGap)
			{
				this._list.itemRendererProperties.gap = Number.POSITIVE_INFINITY;
			}
			else
			{
				this._list.itemRendererProperties.gap = this._itemRendererGap;
			}
			if(this.settings.useInfiniteAccessoryGap)
			{
				this._list.itemRendererProperties.accessoryGap = Number.POSITIVE_INFINITY;
			}
			else
			{
				this._list.itemRendererProperties.accessoryGap = this._itemRendererGap;
			}
			this._list.itemRendererProperties.horizontalAlign = this.settings.horizontalAlign;
			this._list.itemRendererProperties.verticalAlign = this.settings.verticalAlign;
			this._list.itemRendererProperties.layoutOrder = this.settings.layoutOrder;

			//ideally, styles like gap, accessoryGap, horizontalAlign,
			//verticalAlign, layoutOrder, iconPosition, and accessoryPosition
			//will be handled in the theme.
			//this is a special case because this screen is designed to
			//configure those styles at runtime

			//never forget to call super.draw()!
			super.draw();
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
