package feathers.examples.trainTimes
{

	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.examples.trainTimes.screens.StationScreen;
	import feathers.examples.trainTimes.screens.TimesScreen;
	import feathers.examples.trainTimes.themes.TrainTimesTheme;
	import feathers.motion.transitions.OldFadeNewSlideTransitionManager;

	import starling.display.Sprite;
	import starling.events.Event;

	public class Main extends Sprite
	{
		private static const STATION_SCREEN:String = "stationScreen";
		private static const TIMES_SCREEN:String = "timesScreen";

		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		private var _navigator:ScreenNavigator;
		private var _transitionManager:OldFadeNewSlideTransitionManager;

		private function addedToStageHandler(event:Event):void
		{
			new TrainTimesTheme();

			this._navigator = new ScreenNavigator();
			this.addChild(this._navigator);

			this._navigator.addScreen(STATION_SCREEN, new ScreenNavigatorItem(StationScreen,
			{
				complete: TIMES_SCREEN
			}));

			this._navigator.addScreen(TIMES_SCREEN, new ScreenNavigatorItem(TimesScreen,
			{
				complete: STATION_SCREEN
			}));

			this._transitionManager = new OldFadeNewSlideTransitionManager(this._navigator);
			this._transitionManager.duration = 0.4;
			this._navigator.showScreen(STATION_SCREEN);
		}
	}
}
