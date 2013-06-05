package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.ToggleSwitch;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.examples.componentsExplorer.data.EmbeddedAssets;
	import feathers.examples.componentsExplorer.data.ItemRendererSettings;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]
	[Event(name="showSettings",type="starling.events.Event")]

	public class ItemRendererScreen extends PanelScreen
	{
		public static const SHOW_SETTINGS:String = "showSettings";

		public function ItemRendererScreen()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		public var settings:ItemRendererSettings;

		private var _list:List;
		private var _backButton:Button;
		private var _settingsButton:Button;

		protected function initializeHandler(event:Event):void
		{
			this.layout = new AnchorLayout();

			this._list = new List();

			var item:Object = { text: "Primary Text" };
			this._list.itemRendererProperties.labelField = "text";

			if(this.settings.hasIcon)
			{
				item.texture = EmbeddedAssets.SKULL_ICON_LIGHT;

				this._list.itemRendererProperties.iconSourceField = "texture";
				this._list.itemRendererProperties.iconPosition = this.settings.iconPosition;
			}
			if(this.settings.hasAccessory)
			{
				switch(this.settings.accessoryType)
				{
					case ItemRendererSettings.ACCESSORY_TYPE_LABEL:
					{
						item.secondaryText = "Secondary Text";
						this._list.itemRendererProperties.accessoryLabelField = "secondaryText";
						break;
					}
					case ItemRendererSettings.ACCESSORY_TYPE_TEXTURE:
					{
						item.accessoryTexture = EmbeddedAssets.SKULL_ICON_LIGHT;
						this._list.itemRendererProperties.accessorySourceField = "accessoryTexture";
						break;
					}
					default:
					{
						item.accessory = new ToggleSwitch();
						this._list.itemRendererProperties.accessoryField = "accessory";
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
				this._list.itemRendererProperties.gap = 20 * this.dpiScale;
			}
			if(this.settings.useInfiniteAccessoryGap)
			{
				this._list.itemRendererProperties.accessoryGap = Number.POSITIVE_INFINITY;
			}
			else
			{
				this._list.itemRendererProperties.accessoryGap = 20 * this.dpiScale;
			}
			this._list.itemRendererProperties.horizontalAlign = this.settings.horizontalAlign;
			this._list.itemRendererProperties.verticalAlign = this.settings.verticalAlign;
			this._list.itemRendererProperties.layoutOrder = this.settings.layoutOrder;

			//ideally, styles like gap, accessoryGap, horizontalAlign,
			//verticalAlign, layoutOrder, iconPosition, and accessoryPosition
			//will be handled in the theme.
			//this is a special case because this screen is designed to
			//configure those styles at runtime

			this._list.dataProvider = new ListCollection([item]);
			this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this._list.isSelectable = false;
			this._list.clipContent = false;
			this._list.autoHideBackground = true;
			this.addChild(this._list);

			this.headerProperties.title = "Item Renderer";

			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this._backButton = new Button();
				this._backButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
				this._backButton.label = "Back";
				this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

				this.headerProperties.leftItems = new <DisplayObject>
				[
					this._backButton
				];

				this.backButtonHandler = this.onBackButton;
			}

			this._settingsButton = new Button();
			this._settingsButton.label = "Settings";
			this._settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);

			this.headerProperties.rightItems = new <DisplayObject>
			[
				this._settingsButton
			];
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
