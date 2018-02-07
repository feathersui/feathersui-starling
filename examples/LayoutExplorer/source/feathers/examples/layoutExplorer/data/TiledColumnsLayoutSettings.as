package feathers.examples.layoutExplorer.data
{
	import feathers.layout.Direction;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.TiledColumnsLayout;
	import feathers.layout.VerticalAlign;

	public class TiledColumnsLayoutSettings
	{
		public function TiledColumnsLayoutSettings()
		{
		}

		public var itemCount:int = 75;
		public var requestedRowCount:int = 0;
		public var paging:String = Direction.NONE;
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
