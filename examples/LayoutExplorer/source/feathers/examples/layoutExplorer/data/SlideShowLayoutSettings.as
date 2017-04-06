package feathers.examples.layoutExplorer.data
{
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalAlign;

	public class SlideShowLayoutSettings
	{
		public function SlideShowLayoutSettings()
		{
		}

		public var itemCount:int = 5;
		public var horizontalAlign:String = HorizontalAlign.CENTER;
		public var verticalAlign:String = VerticalAlign.MIDDLE;
		public var paddingTop:Number = 0;
		public var paddingRight:Number = 0;
		public var paddingBottom:Number = 0;
		public var paddingLeft:Number = 0;
	}
}
