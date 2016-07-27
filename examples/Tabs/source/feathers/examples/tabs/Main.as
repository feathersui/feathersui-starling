package feathers.examples.tabs
{
	import feathers.controls.TabNavigator;
	import feathers.controls.TabNavigatorItem;
	import feathers.examples.tabs.screens.ContactsScreen;
	import feathers.examples.tabs.screens.MessagesScreen;
	import feathers.examples.tabs.screens.ProfileScreen;
	import feathers.examples.tabs.themes.TabsTheme;

	import starling.display.Sprite;
	import starling.events.Event;

	public class Main extends Sprite
	{
		private static const MESSAGES:String = "messages";
		private static const CONTACTS:String = "contacts";
		private static const PROFILE:String = "profile";

		public function Main()
		{
			new TabsTheme();

			super();

			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		protected var navigator:TabNavigator;

		protected function addedToStageHandler(event:Event):void
		{
			this.navigator = new TabNavigator();
			this.addMessagesTab();
			this.addContactsTab();
			this.addProfileTab();
			this.addChild(this.navigator);
		}

		private function addMessagesTab():void
		{
			var screen:MessagesScreen = new MessagesScreen();
			var item:TabNavigatorItem = new TabNavigatorItem(screen, "Messages");
			this.navigator.addScreen(MESSAGES, item);
		}

		private function addContactsTab():void
		{
			var screen:ContactsScreen = new ContactsScreen();
			var item:TabNavigatorItem = new TabNavigatorItem(screen, "Contacts");
			this.navigator.addScreen(CONTACTS, item);
		}

		private function addProfileTab():void
		{
			var screen:ProfileScreen = new ProfileScreen();
			var item:TabNavigatorItem = new TabNavigatorItem(screen, "Profile");
			this.navigator.addScreen(PROFILE, item);
		}
	}
}
