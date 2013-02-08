package feathers.examples.componentsExplorer.data
{
	public class GroupedListSettings
	{
		public static const STYLE_NORMAL:String = "normal";
		public static const STYLE_INSET:String = "inset";

		public function GroupedListSettings()
		{
		}

		public var isSelectable:Boolean = true;
		public var hasElasticEdges:Boolean = true;
		public var style:String = STYLE_NORMAL;
	}
}
