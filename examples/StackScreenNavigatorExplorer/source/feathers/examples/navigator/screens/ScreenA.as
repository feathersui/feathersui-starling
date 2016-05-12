package feathers.examples.navigator.screens
{
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalAlign;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;

	import starling.events.Event;

	/**
	 * Pushes another screen onto the stack. An event is mapped to the push
	 * action by calling setScreenIDForPushEvent() on the
	 * StackScreenNavigatorItem.
	 *
	 * item.setScreenIDForPushEvent(Event.COMPLETE, otherScreenID);
	 */
	[Event(name="complete",type="starling.events.Event")]

	public class ScreenA extends PanelScreen
	{
		public function ScreenA()
		{
			super();
			this.title = "Screen A";
		}

		override protected function initialize():void
		{
			super.initialize();

			var layout:VerticalLayout = new VerticalLayout();
			layout.horizontalAlign = HorizontalAlign.CENTER;
			layout.verticalAlign = VerticalAlign.MIDDLE;
			layout.gap = 10;
			this.layout = layout;

			var pushB1Button:Button = new Button();
			pushB1Button.label = "Push Screen B1";
			pushB1Button.layoutData = new VerticalLayoutData(50);
			pushB1Button.addEventListener(Event.TRIGGERED, pushB1Button_triggeredHandler);
			this.addChild(pushB1Button);
		}

		protected function pushB1Button_triggeredHandler(event:Event):void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}
	}
}
