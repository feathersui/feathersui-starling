package feathers.examples.componentsExplorer.data
{
	import feathers.controls.Button;
	import feathers.controls.renderers.BaseDefaultItemRenderer;

	public class ItemRendererSettings
	{
		public static const ACCESSORY_TYPE_DISPLAY_OBJECT:String = "Display Object";
		public static const ACCESSORY_TYPE_TEXTURE:String = "Texture";
		public static const ACCESSORY_TYPE_LABEL:String = "Label";

		public function ItemRendererSettings()
		{
		}

		public var hasIcon:Boolean = true;
		public var hasAccessory:Boolean = true;
		public var layoutOrder:String = BaseDefaultItemRenderer.LAYOUT_ORDER_LABEL_ICON_ACCESSORY;
		public var iconPosition:String = Button.ICON_POSITION_LEFT;
		public var useInfiniteGap:Boolean = false;
		public var accessoryPosition:String = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
		public var accessoryType:String = ACCESSORY_TYPE_DISPLAY_OBJECT;
		public var useInfiniteAccessoryGap:Boolean = true;
		public var horizontalAlign:String = Button.HORIZONTAL_ALIGN_LEFT;
		public var verticalAlign:String = Button.VERTICAL_ALIGN_MIDDLE;
	}
}
