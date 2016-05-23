package feathers.examples.helloWorld
{
	import feathers.controls.Button;
	import feathers.controls.TextCallout;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.display.Sprite;
	import starling.events.Event;

	/**
	 * An example to help you get started with Feathers. Creates a "theme" and
	 * displays a Button component that you can trigger.
	 *
	 * <p>Note: This example requires the MetalWorksMobileTheme, which is one of
	 * the themes included with Feathers.</p>
	 *
	 * @see http://feathersui.com/help/getting-started.html
	 */
	public class Main extends Sprite
	{
		/**
		 * Constructor.
		 */
		public function Main()
		{
			//we'll initialize things after we've been added to the stage
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		/**
		 * The Feathers Button control that we'll be creating.
		 */
		protected var button:Button;

		/**
		 * Where the magic happens. Start after the main class has been added
		 * to the stage so that we can access the stage property.
		 */
		protected function addedToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

			//create the theme. this class will automatically pass skins to any
			//Feathers component that is added to the stage. components do not
			//have default skins, so you must always use a theme or skin the
			//components manually. you should always create a theme immediately
			//when your app starts up to ensure that all components are
			//properly skinned.
			//see http://feathersui.com/help/themes.html
			new MetalWorksMobileTheme();

			//create a button and give it some text to display.
			this.button = new Button();
			this.button.label = "Click Me";

			//an event that tells us when the user has tapped the button.
			this.button.addEventListener(Event.TRIGGERED, button_triggeredHandler);

			//add the button to the display list, just like you would with any
			//other Starling display object. this is where the theme give some
			//skins to the button.
			this.addChild(this.button);

			//the button won't have a width and height until it "validates". it
			//will validate on its own before the next frame is rendered by
			//Starling, but we want to access the dimension immediately, so tell
			//it to validate right now.
			this.button.validate();

			//center the button
			this.button.x = Math.round((this.stage.stageWidth - this.button.width) / 2);
			this.button.y = Math.round((this.stage.stageHeight - this.button.height) / 2);
		}

		/**
		 * Listener for the Button's Event.TRIGGERED event.
		 */
		protected function button_triggeredHandler(event:Event):void
		{
			TextCallout.show("Hi, I'm Feathers!\nHave a nice day.", this.button);
		}
	}
}
