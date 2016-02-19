package feathers.examples.layoutExplorer.data
{
	import feathers.layout.HorizontalAlign;
	import feathers.layout.TiledRowsLayout;
	import feathers.layout.VerticalAlign;

	public class TiledRowsLayoutSettings
	{
		public function TiledRowsLayoutSettings()
		{
		}

		public var paging:String = TiledRowsLayout.PAGING_NONE;
		public var itemCount:int = 75;
		public var requestedColumnCount:int = 0;
		public var horizontalAlign:String = HorizontalAlign.LEFT;
		public var verticalAlign:String = VerticalAlign.TOP;
		public var tileHorizontalAlign:String = HorizontalAlign.LEFT;
		public var tileVerticalAlign:String = VerticalAlign.TOP;
		public var horizontalGap:Number = 2;
		public var verticalGap:Number = 2;
		public var paddingTop:Number = 0;
		public var paddingRight:Number = 0;
		public var paddingBottom:Number = 0;
		public var paddingLeft:Number = 0;
	}
}
