package feathers.examples.gallery
{
	import feathers.controls.List;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.display.DisplayObjectContainer;

	/**
	 * Extends MetalWorksMobileTheme to make some app-specific styling tweaks
	 */
	public class GalleryTheme extends MetalWorksMobileTheme
	{
		public function GalleryTheme(container:DisplayObjectContainer = null, scaleToDPI:Boolean = true)
		{
			super(container, scaleToDPI)
		}

		override protected function initialize():void
		{
			this.setInitializerForClass(List, thumbnailListInitializer, Main.THUMBNAIL_LIST_NAME)
			super.initialize();
		}

		protected function thumbnailListInitializer(list:List):void
		{
			//start with the default list styles. we could start from scratch,
			//if we wanted, but we're only making minor changes.
			super.listInitializer(list);

			//we're not displaying scroll bars
			list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
		}
	}
}
