package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.AutoComplete;
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.data.LocalAutoCompleteSource;
	import feathers.skins.IStyleProvider;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class AutoCompleteScreen extends PanelScreen
	{
		public static var globalStyleProvider:IStyleProvider;

		public function AutoCompleteScreen()
		{
		}

		private var _input:AutoComplete;

		override protected function get defaultStyleProvider():IStyleProvider
		{
			return AutoCompleteScreen.globalStyleProvider;
		}

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Auto-complete";

			this._input = new AutoComplete();
			this._input.prompt = "Fruits. Type 'ap' to see suggestions";
			this._input.source = new LocalAutoCompleteSource(new ListCollection(new <String>
			[
				"Apple",
				"Apricot",
				"Banana",
				"Cantaloupe",
				"Cherry",
				"Grape",
				"Lemon",
				"Lime",
				"Mango",
				"Orange",
				"Peach",
				"Pineapple",
				"Plum",
				"Pomegranate",
				"Raspberry",
				"Strawberry",
				"Watermelon"
			]));
			this.addChild(this._input);

			this.headerFactory = this.customHeaderFactory;

			//this screen doesn't use a back button on tablets because the main
			//app's uses a split layout
			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this.backButtonHandler = this.onBackButton;
			}
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

		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}
	}
}
