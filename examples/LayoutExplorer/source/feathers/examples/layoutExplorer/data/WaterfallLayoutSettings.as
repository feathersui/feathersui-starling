package feathers.examples.layoutExplorer.data
{
	import feathers.layout.HorizontalAlign;

	public class WaterfallLayoutSettings
	{
		public function WaterfallLayoutSettings()
		{
		}

		public var itemCount:int = 75;
		public var requestedColumnCount:int = 0;
		public var horizontalAlign:String = HorizontalAlign.CENTER;
		public var horizontalGap:Number = 2;
		public var verticalGap:Number = 2;
		public var paddingTop:Number = 0;
		public var paddingRight:Number = 0;
		public var paddingBottom:Number = 0;
		public var paddingLeft:Number = 0;
	}
}
