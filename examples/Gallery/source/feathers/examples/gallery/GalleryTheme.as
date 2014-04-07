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
		public function GalleryTheme()
		{
			super(true)
		}

		override protected function initializeStyleProviders():void
		{
			super.initializeStyleProviders();
			this._listStyleProvider.setFunctionForStyleName(Main.THUMBNAIL_LIST_NAME, this.setThumbnailListStyles);
		}

		protected function setThumbnailListStyles(list:List):void
		{
			//start with the default list styles. we could start from scratch,
			//if we wanted, but we're only making minor changes.
			super.setListStyles(list);

			//we're not displaying scroll bars
			list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
		}
	}
}
