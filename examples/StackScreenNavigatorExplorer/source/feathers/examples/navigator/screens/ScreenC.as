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
	 * Pops all screens from the stack to return to the root screen. An event
	 * is mapped to the pop to root action by calling addPopToRootEvent() on the
	 * StackScreenNavigatorItem.
	 *
	 * item.addPopToRootEvent(Event.CLOSE);
	 */
	[Event(name="close",type="starling.events.Event")]

	/**
	 * Pops this screen from the stack to return to the previous screen. An
	 * event is mapped to the pop action by calling addPopEvent() on the
	 * StackScreenNavigatorItem.
	 *
	 * item.addPopEvent(Event.CANCEL);
	 */
	[Event(name="cancel",type="starling.events.Event")]

	public class ScreenC extends PanelScreen
	{
		public function ScreenC()
		{
			super();
			this.title = "Screen C";
		}

		override protected function initialize():void
		{
			super.initialize();

			var layout:VerticalLayout = new VerticalLayout();
			layout.horizontalAlign = HorizontalAlign.CENTER;
			layout.verticalAlign = VerticalAlign.MIDDLE;
			layout.gap = 10;
			this.layout = layout;

			var popToB1Button:Button = new Button();
			popToB1Button.label = "Pop to Screen B";
			popToB1Button.layoutData = new VerticalLayoutData(50);
			popToB1Button.addEventListener(Event.TRIGGERED, popToB1Button_triggeredHandler);
			this.addChild(popToB1Button);

			var popToRootButton:Button = new Button();
			popToRootButton.label = "Pop to Root";
			popToRootButton.layoutData = new VerticalLayoutData(50);
			popToRootButton.addEventListener(Event.TRIGGERED, popToRootButton_triggeredHandler);
			this.addChild(popToRootButton);
		}

		protected function popToB1Button_triggeredHandler(event:Event):void
		{
			this.dispatchEventWith(Event.CANCEL);
		}

		protected function popToRootButton_triggeredHandler(event:Event):void
		{
			this.dispatchEventWith(Event.CLOSE);
		}
	}
}
