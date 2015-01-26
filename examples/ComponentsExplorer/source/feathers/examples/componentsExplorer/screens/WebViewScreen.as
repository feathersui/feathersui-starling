package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.TextInput;
	import feathers.controls.WebView;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.examples.componentsExplorer.data.ListSettings;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayoutData;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class WebViewScreen extends PanelScreen
	{
		public function WebViewScreen()
		{
			super();
		}

		private var _browser:WebView;
		private var _locationInput:TextInput;

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Web View";

			this.layout = new AnchorLayout();

			var items:Array = [];
			for(var i:int = 0; i < 150; i++)
			{
				var item:Object = {text: "Item " + (i + 1).toString()};
				items[i] = item;
			}
			items.fixed = true;

			this._browser = new WebView();
			this._browser.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this._browser.addEventListener("locationChange", webView_locationChangeHandler);
			this.addChild(this._browser);

			this.headerFactory = this.customHeaderFactory;
			this.footerFactory = this.customFooterFactory;

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

		private function customFooterFactory():LayoutGroup
		{
			var footer:LayoutGroup = new LayoutGroup();
			footer.styleNameList.add(LayoutGroup.ALTERNATE_STYLE_NAME_TOOLBAR);
			
			this._locationInput = new TextInput();
			this._locationInput.prompt = "Enter a website address";
			this._locationInput.layoutData = new HorizontalLayoutData(100);
			this._locationInput.addEventListener(FeathersEventType.ENTER, locationInput_enterHandler);
			footer.addChild(this._locationInput);
			
			var goButton:Button = new Button();
			goButton.label = "Go";
			goButton.addEventListener(Event.TRIGGERED, goButton_triggeredHandler);
			footer.addChild(goButton);
			
			return footer;
		}
		
		private function loadLocation():void
		{
			if(this._locationInput.text.length == 0)
			{
				return;
			}
			this._locationInput.clearFocus();
			var url:String = this._locationInput.text;
			//make sure that there's a protocol. otherwise, AIR will add app:/,
			//which probably isn't what you want.
			if(!url.match(/^\w+:\//))
			{
				url = "http://" + url;
			}
			url = encodeURI(url);
			this._browser.loadURL(url);
		}

		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}
		
		private function webView_locationChangeHandler(event:Event):void
		{
			this._locationInput.text = this._browser.location;
		}
		
		private function locationInput_enterHandler(event:Event):void
		{
			this.loadLocation();
		}
		
		private function goButton_triggeredHandler(event:Event):void
		{
			this.loadLocation();
		}
		
		
	}
}