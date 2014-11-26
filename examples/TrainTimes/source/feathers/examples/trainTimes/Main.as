package feathers.examples.trainTimes
{

	import feathers.controls.StackScreenNavigator;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.examples.trainTimes.screens.StationScreen;
	import feathers.examples.trainTimes.screens.TimesScreen;
	import feathers.examples.trainTimes.themes.TrainTimesTheme;
	import feathers.motion.transitions.Slide;

	import starling.events.Event;

	public class Main extends StackScreenNavigator
	{
		private static const STATION_SCREEN:String = "stationScreen";
		private static const TIMES_SCREEN:String = "timesScreen";

		public function Main()
		{
			super();
		}

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			new TrainTimesTheme();

			var stationScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(StationScreen);
			stationScreenItem.setScreenIDForPushEvent(Event.COMPLETE, TIMES_SCREEN);
			this.addScreen(STATION_SCREEN, stationScreenItem);

			var timesScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(TimesScreen);
			timesScreenItem.addPopEvent(Event.COMPLETE);
			this.addScreen(TIMES_SCREEN, timesScreenItem);

			this.rootScreen = STATION_SCREEN;

			this.pushTransition = Slide.createSlideLeftTransition();
			this.popTransition = Slide.createSlideRightTransition();
		}
	}
}
