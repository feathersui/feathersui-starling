package feathers.examples.tabs.themes
{
	import feathers.controls.ImageLoader;
	import feathers.controls.ItemRendererLayoutOrder;
	import feathers.controls.renderers.BaseDefaultItemRenderer;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.layout.RelativePosition;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.display.Canvas;

	public class TabsTheme extends MetalWorksMobileTheme
	{
		public function TabsTheme()
		{
			super();
		}

		override protected function initializeStyleProviders():void
		{
			super.initializeStyleProviders();

			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(
					StyleNames.MESSAGE_LIST_ITEM_RENDERER, this.setMessageListItemRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(
				StyleNames.MESSAGE_LIST_ITEM_RENDERER, this.setMessageListItemRendererStyles);
			this.getStyleProviderForClass(ImageLoader).setFunctionForStyleName(
				StyleNames.SMALL_PROFILE_IMAGE, this.setSmallProfileImageStyles);
			this.getStyleProviderForClass(ImageLoader).setFunctionForStyleName(
				StyleNames.LARGE_PROFILE_IMAGE, this.setLargeProfileImageStyles);
		}

		private function setMessageListItemRendererStyles(itemRenderer:BaseDefaultItemRenderer):void
		{
			this.setItemRendererStyles(itemRenderer);
			itemRenderer.accessoryPosition = RelativePosition.BOTTOM;
			itemRenderer.accessoryGap = 4;
			itemRenderer.layoutOrder = ItemRendererLayoutOrder.LABEL_ACCESSORY_ICON;
			itemRenderer.customIconLoaderStyleName = StyleNames.SMALL_PROFILE_IMAGE;
		}

		private function setProfileImageStyles(image:ImageLoader, size:Number):void
		{
			var halfSize:Number = size / 2;
			image.setSize(size, size);
			var mask:Canvas = new Canvas();
			mask.beginFill(0xff00ff, 1);
			mask.drawCircle(halfSize, halfSize, halfSize);
			mask.endFill();
			image.mask = mask;
			image.addChild(mask);
		}

		private function setSmallProfileImageStyles(image:ImageLoader):void
		{
			this.setProfileImageStyles(image, 48);
		}

		private function setLargeProfileImageStyles(image:ImageLoader):void
		{
			this.setProfileImageStyles(image, 100);
		}
	}
}
