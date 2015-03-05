package feathers.examples.layoutExplorer.data
{
	import feathers.layout.TiledColumnsLayout;

	public class TiledColumnsLayoutSettings
	{
		public function TiledColumnsLayoutSettings()
		{
		}

		public var itemCount:int = 75;
		public var requestedRowCount:int = 0;
		public var paging:String = TiledColumnsLayout.PAGING_NONE;
		public var horizontalAlign:String = TiledColumnsLayout.HORIZONTAL_ALIGN_LEFT;
		public var verticalAlign:String = TiledColumnsLayout.VERTICAL_ALIGN_TOP;
		public var tileHorizontalAlign:String = TiledColumnsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
		public var tileVerticalAlign:String = TiledColumnsLayout.TILE_VERTICAL_ALIGN_TOP;
		public var horizontalGap:Number = 2;
		public var verticalGap:Number = 2;
		public var paddingTop:Number = 0;
		public var paddingRight:Number = 0;
		public var paddingBottom:Number = 0;
		public var paddingLeft:Number = 0;
	}
}
