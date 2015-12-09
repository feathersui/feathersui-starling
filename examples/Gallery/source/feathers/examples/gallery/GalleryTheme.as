package feathers.examples.gallery
{
	import feathers.controls.List;
	import feathers.themes.MetalWorksMobileTheme;

	/**
	 * Extends MetalWorksMobileTheme to make some app-specific styling tweaks
	 */
	public class GalleryTheme extends MetalWorksMobileTheme
	{
		public function GalleryTheme()
		{
			super();
		}

		override protected function initializeStyleProviders():void
		{
			super.initializeStyleProviders();
			this.getStyleProviderForClass(List).setFunctionForStyleName(Main.THUMBNAIL_LIST_NAME, this.setThumbnailListStyles);
		}

		protected function setThumbnailListStyles(list:List):void
		{
			//start with the default list styles. we could start from scratch,
			//if we wanted, but we're only making minor changes.
			super.setListStyles(list);

			//we're not displaying scroll bars
			list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
			
			//make a swipe scroll a shorter distance
			list.decelerationRate = List.DECELERATION_RATE_FAST;
		}
	}
}
