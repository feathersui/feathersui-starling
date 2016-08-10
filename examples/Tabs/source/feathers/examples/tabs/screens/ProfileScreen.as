package feathers.examples.tabs.screens
{
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.Screen;
	import feathers.examples.tabs.themes.StyleNames;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalAlign;
	import feathers.layout.VerticalLayout;

	public class ProfileScreen extends Screen
	{
		public function ProfileScreen()
		{
			super();
		}

		private var _image:ImageLoader;
		private var _nameLabel:Label;
		private var _emailLabel:Label;

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

			this._image = new ImageLoader();
			this._image.styleNameList.add(StyleNames.LARGE_PROFILE_IMAGE);
			this._image.source = "https://randomuser.me/api/portraits/men/67.jpg";
			header.addChild(this._image);

			this._nameLabel = new Label();
			this._nameLabel.styleNameList.add(Label.ALTERNATE_STYLE_NAME_HEADING);
			this._nameLabel.text = "Flynn Reynolds";
			header.addChild(this._nameLabel);

			this._emailLabel = new Label();
			this._emailLabel.text = "flynn.reynolds84@example.com";
			this.addChild(this._emailLabel);
		}
	}
}
