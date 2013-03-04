package feathers.examples.mxml
{
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.examples.mxml.screens.SampleScreen;
	import feathers.examples.mxml.screens.SettingsScreen;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;

	public class Main extends Sprite
	{
		private static const SAMPLE_SCREEN:String = "sample";
		private static const SETTINGS_SCREEN:String = "settings";

		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		private var _navigator:ScreenNavigator;

		private function addedToStageHandler(event:Event):void
		{
			new MetalWorksMobileTheme();

			this.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);

			this._navigator = new ScreenNavigator();
			this.addChild(this._navigator);

			this._navigator.addScreen(SAMPLE_SCREEN, new ScreenNavigatorItem(SampleScreen,
			{
				settings: SETTINGS_SCREEN
			}));

			this._navigator.addScreen(SETTINGS_SCREEN, new ScreenNavigatorItem(SettingsScreen,
			{
				complete: SAMPLE_SCREEN
			}));

			new ScreenSlidingStackTransitionManager(this._navigator);

			this._navigator.showScreen(SAMPLE_SCREEN);
		}

		private function removedFromStageHandler(event:Event):void
		{
			this.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
		}

		private function stage_resizeHandler(event:Event):void
		{
			this._navigator.width = this.stage.stageWidth;
			this._navigator.height = this.stage.stageHeight;
		}

	}
}
