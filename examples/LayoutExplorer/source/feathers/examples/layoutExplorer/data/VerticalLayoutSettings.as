package feathers.examples.layoutExplorer.data
{
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalAlign;
	import feathers.layout.VerticalLayout;

	public class VerticalLayoutSettings
	{
		public function VerticalLayoutSettings()
		{
		}

		public var itemCount:int = 75;
		public var horizontalAlign:String = HorizontalAlign.LEFT;
		public var verticalAlign:String = VerticalAlign.TOP;
		public var gap:Number = 2;
		public var paddingTop:Number = 0;
		public var paddingRight:Number = 0;
		public var paddingBottom:Number = 0;
		public var paddingLeft:Number = 0;
	}
}
