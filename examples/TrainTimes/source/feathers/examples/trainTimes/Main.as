package feathers.examples.trainTimes
{

	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.events.FeathersEventType;
	import feathers.examples.trainTimes.screens.StationScreen;
	import feathers.examples.trainTimes.screens.TimesScreen;
	import feathers.examples.trainTimes.themes.TrainTimesTheme;
	import feathers.motion.transitions.OldFadeNewSlideTransitionManager;

	import starling.events.Event;

	public class Main extends ScreenNavigator
	{
		private static const STATION_SCREEN:String = "stationScreen";
		private static const TIMES_SCREEN:String = "timesScreen";

		public function Main()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		private var _transitionManager:OldFadeNewSlideTransitionManager;

		private function initializeHandler(event:Event):void
		{
			new TrainTimesTheme();

			this.addScreen(STATION_SCREEN, new ScreenNavigatorItem(StationScreen,
			{
				complete: TIMES_SCREEN
			}));

			this.addScreen(TIMES_SCREEN, new ScreenNavigatorItem(TimesScreen,
			{
				complete: STATION_SCREEN
			}));

			this._transitionManager = new OldFadeNewSlideTransitionManager(this);
			this._transitionManager.duration = 0.4;
			this.showScreen(STATION_SCREEN);
		}
	}
}
