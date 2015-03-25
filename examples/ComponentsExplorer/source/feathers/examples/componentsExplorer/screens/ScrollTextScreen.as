package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.PanelScreen;
	import feathers.controls.ScrollText;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class ScrollTextScreen extends PanelScreen
	{
		public function ScrollTextScreen()
		{
			super();
		}

		private var _scrollText:ScrollText;

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Scroll Text";

			this.layout = new AnchorLayout();

			this._scrollText = new ScrollText();
			this._scrollText.text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.\n\nNeque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?\n\nAt vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.\n\nDonec ultricies nibh non metus volutpat, ac gravida tellus accumsan. Sed in urna quis ante ultrices tristique non non felis. Etiam accumsan molestie felis id auctor. Aliquam suscipit finibus mollis. Etiam euismod odio massa, eu tempus neque consequat ullamcorper. Donec non dignissim metus, ut dictum erat. Sed vestibulum ut sapien vitae laoreet. Integer sollicitudin tellus vitae scelerisque aliquam. Praesent gravida, leo imperdiet vestibulum congue, felis arcu eleifend sem, nec cursus enim massa sit amet risus. Sed cursus pulvinar bibendum.\n\nVivamus nec posuere nunc. Quisque consequat nisi sem, a mattis nisi sagittis ac. Donec efficitur, dui in tincidunt mollis, sapien eros pharetra nibh, quis malesuada mauris velit quis mauris. Nunc eget fermentum tellus. Integer a mi neque. Suspendisse ut cursus mi. Nam tempus interdum felis vel rutrum. Sed quis pharetra mauris, id faucibus quam. Nunc vehicula ullamcorper nisl, non interdum massa scelerisque nec. Proin suscipit rhoncus enim sed tristique.\n\nProin id erat nunc. Sed rutrum tortor in tempor vehicula. Integer et imperdiet odio, sed viverra diam. Pellentesque et commodo lectus, vitae tempus tortor. Quisque purus justo, pharetra ac est molestie, finibus aliquam dui. Vestibulum sodales hendrerit nibh, quis venenatis lorem dictum in. Sed volutpat bibendum eros id vulputate. Curabitur lobortis, tellus a aliquet aliquet, nunc risus aliquet arcu, at ullamcorper ligula tortor vel nulla. Duis sit amet odio pharetra, sodales magna ac, eleifend magna. Curabitur fringilla nec urna vel ultricies.\n\nNunc vel consequat dolor. Quisque nec pretium arcu, faucibus efficitur tortor. Etiam sapien dui, vulputate et libero sollicitudin, consectetur iaculis quam. Nulla eget odio vehicula, vehicula libero sed, tristique lectus. Aliquam in mollis ante, ac molestie risus. Nam faucibus urna at dui varius, sed elementum diam convallis. Nullam ut suscipit diam.\n\nCras tempus faucibus dolor id accumsan. Integer lobortis rutrum vulputate. Nullam porttitor nisi dapibus, tincidunt ante eu, gravida mi. Cras efficitur, magna vitae pulvinar dictum, mauris libero laoreet est, quis volutpat nibh libero a felis. Nunc fringilla dignissim mauris, et aliquam elit molestie ac. Nunc sit amet dignissim nunc. Cras accumsan mauris augue, eget laoreet erat tincidunt in. Phasellus rutrum turpis eget ligula tristique consequat. Maecenas volutpat consectetur purus a ultricies. Sed auctor pulvinar sem, eget fringilla purus consequat sit amet. In hac habitasse platea dictumst. Fusce lobortis vehicula aliquam. Phasellus ornare, est at condimentum consequat, elit ipsum hendrerit est, in rhoncus mauris dui nec quam.";
			this._scrollText.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this.addChild(this._scrollText);

			this.headerFactory = this.customHeaderFactory;

			//this screen doesn't use a back button on tablets because the main
			//app's uses a split layout
			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this.backButtonHandler = this.onBackButton;
			}
		}

		private function customHeaderFactory():Header
		{
			var header:Header = new Header();
			//this screen doesn't use a back button on tablets because the main
			//app's uses a split layout
			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				var backButton:Button = new Button();
				backButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON);
				backButton.label = "Back";
				backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);
				header.leftItems = new <DisplayObject>
				[
					backButton
				];
			}
			return header;
		}

		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}
	}
}
