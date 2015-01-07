package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.PanelScreen;
	import feathers.controls.SpinnerList;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class SpinnerListScreen extends PanelScreen
	{
		public function SpinnerListScreen()
		{
			super();
		}

		private var _list:SpinnerList;

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Spinner List";

			this.layout = new AnchorLayout();

			this._list = new SpinnerList();
			this._list.dataProvider = new ListCollection(
			[
				{ text: "Aardvark" },
				{ text: "Alligator" },
				{ text: "Alpaca" },
				{ text: "Anteater" },
				{ text: "Baboon" },
				{ text: "Bear" },
				{ text: "Beaver" },
				{ text: "Canary" },
				{ text: "Cat" },
				{ text: "Deer" },
				{ text: "Dingo" },
				{ text: "Dog" },
				{ text: "Dolphin" },
				{ text: "Donkey" },
				{ text: "Dragonfly" },
				{ text: "Duck" },
				{ text: "Dung Beetle" },
				{ text: "Eagle" },
				{ text: "Earthworm" },
				{ text: "Eel" },
				{ text: "Elk" },
				{ text: "Fox" },
			]);
			this._list.typicalItem = {text: "Item 1000"};
			this._list.autoHideBackground = true;
			this._list.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();

				//enable the quick hit area to optimize hit tests when an item
				//is only selectable and doesn't have interactive children.
				renderer.isQuickHitAreaEnabled = true;

				renderer.labelField = "text";
				return renderer;
			};
			this._list.addEventListener(Event.CHANGE, list_changeHandler);

			var listLayoutData:AnchorLayoutData = new AnchorLayoutData();
			listLayoutData.left = 0;
			listLayoutData.right = 0;
			listLayoutData.verticalCenter = 0;
			this._list.layoutData = listLayoutData;

			this.addChild(this._list);

			this.headerFactory = this.customHeaderFactory;

			//this screen doesn't use a back button on tablets because the main
			//app's uses a split layout
			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this.backButtonHandler = this.onBackButton;
			}

			this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionInCompleteHandler);
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
			return header;
		}

		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function transitionInCompleteHandler(event:Event):void
		{
			this._list.revealScrollBars();
		}

		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}

		private function list_changeHandler(event:Event):void
		{
			trace("Spinner List selection change:", this._list.selectedIndex);
		}
	}
}