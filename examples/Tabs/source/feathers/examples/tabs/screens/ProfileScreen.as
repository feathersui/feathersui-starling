package feathers.examples.tabs.screens
{
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.PanelScreen;
	import feathers.controls.Screen;
	import feathers.examples.tabs.themes.StyleNames;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalAlign;
	import feathers.layout.VerticalLayout;

	import starling.display.Image;

	public class ProfileScreen extends Screen
	{
		public function ProfileScreen()
		{
			super();
		}

		override protected function initialize():void
		{
			super.initialize();

			var mainLayout:VerticalLayout = new VerticalLayout();
			mainLayout.horizontalAlign = HorizontalAlign.CENTER;
			mainLayout.verticalAlign = VerticalAlign.MIDDLE;
			mainLayout.padding = 10;
			this.layout = mainLayout;

			var header:LayoutGroup = new LayoutGroup();
			var headerLayout:VerticalLayout = new VerticalLayout();
			headerLayout.gap = 4;
			headerLayout.horizontalAlign = HorizontalAlign.CENTER;
			header.layout = headerLayout;
			this.addChild(header);

			var image:ImageLoader = new ImageLoader();
			image.styleNameList.add(StyleNames.LARGE_PROFILE_IMAGE);
			image.source = "https://randomuser.me/api/portraits/men/67.jpg";
			header.addChild(image);

			var nameLabel:Label = new Label();
			nameLabel.styleNameList.add(Label.ALTERNATE_STYLE_NAME_HEADING);
			nameLabel.text = "Flynn Reynolds";
			header.addChild(nameLabel);

			var emailLabel:Label = new Label();
			emailLabel.text = "flynn.reynolds84@example.com";
			this.addChild(emailLabel);
		}
	}
}
