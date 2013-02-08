package feathers.examples.componentsExplorer.data
{
	import feathers.controls.Button;

	public class ButtonSettings
	{
		public function ButtonSettings()
		{
		}

		public var isToggle:Boolean = false;
		public var horizontalAlign:String = Button.HORIZONTAL_ALIGN_CENTER;
		public var verticalAlign:String = Button.VERTICAL_ALIGN_MIDDLE;
		public var hasIcon:Boolean = true;
		public var iconPosition:String = Button.ICON_POSITION_LEFT;
		public var iconOffsetX:Number = 0;
		public var iconOffsetY:Number = 0;
	}
}
