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

	/**
	 * Replaces this screen with another screen at the same position in the
	 * stack. An event is mapped to the replace action by calling
	 * setScreenIDForReplaceEvent() on the StackScreenNavigatorItem.
	 *
	 * item.setScreenIDForReplaceEvent(Event.CHANGE, otherScreenID);
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Pushes another screen onto the stack. An event is mapped to the push
	 * action by calling setScreenIDForPushEvent() on the
	 * StackScreenNavigatorItem.
	 *
	 * item.setScreenIDForPushEvent(Event.COMPLETE, otherScreenID);
	 */
	[Event(name="complete",type="starling.events.Event")]

	public class ScreenB1 extends PanelScreen
	{
		public function ScreenB1()
		{
			super();
			this.title = "Screen B1";
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

			var pushCButton:Button = new Button();
			pushCButton.label = "Push Screen C";
			pushCButton.layoutData = new VerticalLayoutData(50);
			pushCButton.addEventListener(Event.TRIGGERED, pushCButton_triggeredHandler);
			this.addChild(pushCButton);

			var replaceWithB2Button:Button = new Button();
			replaceWithB2Button.label = "Replace With Screen B2";
			replaceWithB2Button.layoutData = new VerticalLayoutData(50);
			replaceWithB2Button.addEventListener(Event.TRIGGERED, replaceWithB2Button_triggeredHandler);
			this.addChild(replaceWithB2Button);
		}

		protected function popToAButton_triggeredHandler(event:Event):void
		{
			this.dispatchEventWith(Event.CANCEL);
		}

		protected function pushCButton_triggeredHandler(event:Event):void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}

		protected function replaceWithB2Button_triggeredHandler(event:Event):void
		{
			this.dispatchEventWith(Event.CHANGE);
		}
	}
}
