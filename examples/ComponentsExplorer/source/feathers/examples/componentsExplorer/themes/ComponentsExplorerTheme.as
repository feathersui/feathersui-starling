package feathers.examples.componentsExplorer.themes
{
	import feathers.controls.PanelScreen;
	import feathers.examples.componentsExplorer.screens.ButtonScreen;
	import feathers.examples.componentsExplorer.screens.CalloutScreen;
	import feathers.examples.componentsExplorer.screens.ItemRendererScreen;
	import feathers.examples.componentsExplorer.screens.LabelScreen;
	import feathers.examples.componentsExplorer.screens.ProgressBarScreen;
	import feathers.examples.componentsExplorer.screens.SliderScreen;
	import feathers.examples.componentsExplorer.screens.TextInputScreen;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.themes.MetalWorksMobileTheme;

	public class ComponentsExplorerTheme extends MetalWorksMobileTheme
	{
		public function ComponentsExplorerTheme()
		{
			super();
		}

		override protected function initializeStyleProviders():void
		{
			super.initializeStyleProviders();

			this.getStyleProviderForClass(ButtonScreen).defaultStyleFunction = this.setButtonScreenStyles;
			this.getStyleProviderForClass(CalloutScreen).defaultStyleFunction = this.setCalloutScreenStyles;
			this.getStyleProviderForClass(LabelScreen).defaultStyleFunction = this.setLabelScreenStyles;
			this.getStyleProviderForClass(ItemRendererScreen).defaultStyleFunction = this.setItemRendererScreenStyles;
			this.getStyleProviderForClass(ProgressBarScreen).defaultStyleFunction = this.setProgressBarScreenStyles;
			this.getStyleProviderForClass(SliderScreen).defaultStyleFunction = this.setSliderScreenStyles;
			this.getStyleProviderForClass(TextInputScreen).defaultStyleFunction = this.setTextInputScreenStyles;
		}

		protected function setButtonScreenStyles(screen:ButtonScreen):void
		{
			//don't forget to set styles from the super class, if required
			this.setPanelScreenStyles(screen);

			var verticalLayout:VerticalLayout = new VerticalLayout();
			verticalLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			verticalLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			verticalLayout.padding = this.gutterSize;
			verticalLayout.gap = this.smallGutterSize;
			verticalLayout.manageVisibility = true;
			screen.layout = verticalLayout;

			screen.verticalScrollPolicy = PanelScreen.SCROLL_POLICY_ON;
		}

		protected function setCalloutScreenStyles(screen:CalloutScreen):void
		{
			//don't forget to set styles from the super class, if required
			this.setPanelScreenStyles(screen);

			screen.layoutPadding = this.gutterSize;
		}

		protected function setItemRendererScreenStyles(screen:ItemRendererScreen):void
		{
			//don't forget to set styles from the super class, if required
			this.setPanelScreenStyles(screen);

			screen.itemRendererGap = this.gutterSize;
		}

		protected function setLabelScreenStyles(screen:LabelScreen):void
		{
			//don't forget to set styles from the super class, if required
			this.setPanelScreenStyles(screen);

			var verticalLayout:VerticalLayout = new VerticalLayout();
			verticalLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			verticalLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			verticalLayout.padding = this.gutterSize;
			verticalLayout.gap = this.smallGutterSize;
			verticalLayout.manageVisibility = true;
			screen.layout = verticalLayout;

			screen.verticalScrollPolicy = PanelScreen.SCROLL_POLICY_ON;
		}

		protected function setProgressBarScreenStyles(screen:ProgressBarScreen):void
		{
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			layout.gap = this.gutterSize;
			screen.layout = layout;
		}

		protected function setSliderScreenStyles(screen:SliderScreen):void
		{
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			layout.gap = this.gutterSize;
			screen.layout = layout;
		}

		protected function setTextInputScreenStyles(screen:TextInputScreen):void
		{
			//don't forget to set styles from the super class, if required
			this.setPanelScreenStyles(screen);

			var verticalLayout:VerticalLayout = new VerticalLayout();
			verticalLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			verticalLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			verticalLayout.padding = this.gutterSize;
			verticalLayout.gap = this.smallGutterSize;
			verticalLayout.manageVisibility = true;
			screen.layout = verticalLayout;

			screen.verticalScrollPolicy = PanelScreen.SCROLL_POLICY_ON;
		}
	}
}
