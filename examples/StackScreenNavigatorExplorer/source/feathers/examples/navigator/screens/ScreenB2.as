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
	 * Pops this screen from the stack to return to the previous screen. An
	 * event is mapped to the pop action by calling addPopEvent() on the
	 * StackScreenNavigatorItem.
	 *
	 * item.addPopEvent(Event.CANCEL);
	 */
	[Event(name="cancel",type="starling.events.Event")]

	public class ScreenB2 extends PanelScreen
	{
		public function ScreenB2()
		{
			super();
			this.title = "Screen B2";
		}

		override protected function initialize():void
		{
			super.initialize();

			var layout:VerticalLayout = new VerticalLayout();
			layout.horizontalAlign = HorizontalAlign.CENTER;
			layout.verticalAlign = VerticalAlign.MIDDLE;
			layout.gap = 10;
			this.layout = layout;

			var popToAButton:Button = new Button();
			popToAButton.label = "Pop to Screen A";
			popToAButton.layoutData = new VerticalLayoutData(50);
			popToAButton.addEventListener(Event.TRIGGERED, popToAButton_triggeredHandler);
			this.addChild(popToAButton);
		}

		protected function popToAButton_triggeredHandler(event:Event):void
		{
			this.dispatchEventWith(Event.CANCEL);
		}
	}
}
