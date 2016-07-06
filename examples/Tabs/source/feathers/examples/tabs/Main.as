package feathers.examples.tabs
{
	import feathers.controls.Button;
	import feathers.controls.TabNavigator;
	import feathers.controls.TabNavigatorItem;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.display.Sprite;
	import starling.events.Event;

	public class Main extends Sprite
	{
		private static const ONE:String = "one";
		private static const TWO:String = "two";
		private static const THREE:String = "three";
		
		public function Main()
		{
			new MetalWorksMobileTheme();

			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		protected var navigator:TabNavigator;

		protected function addedToStageHandler(event:Event):void
		{
			this.navigator = new TabNavigator();
			this.addFirstTab();
			this.addSecondTab();
			this.addThirdTab();
			this.addChild(navigator);
		}

		private function addFirstTab():void
		{
			var screen:Button = new Button();
			screen.label = "One";
			var item:TabNavigatorItem = new TabNavigatorItem(screen, "One");
			this.navigator.addScreen(ONE, item);
		}

		private function addSecondTab():void
		{
			var screen:Button = new Button();
			screen.label = "Two";
			var item:TabNavigatorItem = new TabNavigatorItem(screen, "Two");
			this.navigator.addScreen(TWO, item);
		}

		private function addThirdTab():void
		{
			var screen:Button = new Button();
			screen.label = "Three";
			var item:TabNavigatorItem = new TabNavigatorItem(screen, "Three");
			this.navigator.addScreen(THREE, item);
		}
	}
}
