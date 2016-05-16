package feathers.examples.componentsExplorer.data
{
	import feathers.controls.ItemRendererLayoutOrder;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.RelativePosition;
	import feathers.layout.VerticalAlign;

	public class ItemRendererSettings
	{
		public static const ICON_ACCESSORY_TYPE_DISPLAY_OBJECT:String = "Display Object";
		public static const ICON_ACCESSORY_TYPE_TEXTURE:String = "Texture";
		public static const ICON_ACCESSORY_TYPE_LABEL:String = "Label";

		public function ItemRendererSettings()
		{
		}

		public var hasIcon:Boolean = true;
		public var hasAccessory:Boolean = true;
		public var layoutOrder:String = ItemRendererLayoutOrder.LABEL_ICON_ACCESSORY;
		public var iconType:String = ICON_ACCESSORY_TYPE_TEXTURE;
		public var iconPosition:String = RelativePosition.LEFT;
		public var useInfiniteGap:Boolean = false;
		public var accessoryPosition:String = RelativePosition.RIGHT;
		public var accessoryType:String = ICON_ACCESSORY_TYPE_DISPLAY_OBJECT;
		public var useInfiniteAccessoryGap:Boolean = true;
		public var horizontalAlign:String = HorizontalAlign.LEFT;
		public var verticalAlign:String = VerticalAlign.MIDDLE;
	}
}
