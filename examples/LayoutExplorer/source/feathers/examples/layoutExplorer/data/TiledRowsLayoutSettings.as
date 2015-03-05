package feathers.examples.layoutExplorer.data
{
	import feathers.layout.TiledRowsLayout;

	public class TiledRowsLayoutSettings
	{
		public function TiledRowsLayoutSettings()
		{
		}

		public var paging:String = TiledRowsLayout.PAGING_NONE;
		public var itemCount:int = 75;
		public var requestedColumnCount:int = 0;
		public var horizontalAlign:String = TiledRowsLayout.HORIZONTAL_ALIGN_LEFT;
		public var verticalAlign:String = TiledRowsLayout.VERTICAL_ALIGN_TOP;
		public var tileHorizontalAlign:String = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
		public var tileVerticalAlign:String = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
		public var horizontalGap:Number = 2;
		public var verticalGap:Number = 2;
		public var paddingTop:Number = 0;
		public var paddingRight:Number = 0;
		public var paddingBottom:Number = 0;
		public var paddingLeft:Number = 0;
	}
}
