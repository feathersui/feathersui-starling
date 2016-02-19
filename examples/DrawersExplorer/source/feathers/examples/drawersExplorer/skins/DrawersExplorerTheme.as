package feathers.examples.drawersExplorer.skins
{
	import feathers.examples.drawersExplorer.views.ContentView;
	import feathers.examples.drawersExplorer.views.DrawerView;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalAlign;
	import feathers.layout.VerticalLayout;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.display.Quad;

	public class DrawersExplorerTheme extends MetalWorksMobileTheme
	{
		public static const THEME_NAME_TOP_AND_BOTTOM_DRAWER:String = "drawers-explorer-top-and-bottom-drawer";
		public static const THEME_NAME_LEFT_AND_RIGHT_DRAWER:String = "drawers-explorer-left-and-right-drawer";

		public function DrawersExplorerTheme()
		{
			super();
		}

		override protected function initializeStyleProviders():void
		{
			super.initializeStyleProviders();
			this.getStyleProviderForClass(ContentView).defaultStyleFunction = setContentViewStyles;
			this.getStyleProviderForClass(DrawerView).setFunctionForStyleName(THEME_NAME_TOP_AND_BOTTOM_DRAWER, setTopAndBottomDrawerViewStyles);
			this.getStyleProviderForClass(DrawerView).setFunctionForStyleName(THEME_NAME_LEFT_AND_RIGHT_DRAWER, setLeftAndRightDrawerViewStyles);
		}

		protected function setContentViewStyles(view:ContentView):void
		{
			//don't forget to set styles from the super class, if required
			this.setScrollerStyles(view);
			
			var layout:VerticalLayout = new VerticalLayout();
			layout.horizontalAlign = HorizontalAlign.CENTER;
			layout.padding = this.gutterSize;
			layout.gap = this.gutterSize;
			view.layout = layout;
		}

		protected function setLeftAndRightDrawerViewStyles(view:DrawerView):void
		{
			//don't forget to set styles from the super class, if required
			this.setScrollerStyles(view);
			
			view.backgroundSkin = new Quad(10, 10, LIST_BACKGROUND_COLOR);

			var layout:VerticalLayout = new VerticalLayout();
			layout.horizontalAlign = HorizontalAlign.CENTER;
			layout.verticalAlign = VerticalAlign.MIDDLE;
			layout.padding = this.smallGutterSize;
			layout.gap = this.smallGutterSize;
			view.layout = layout;
		}

		protected function setTopAndBottomDrawerViewStyles(view:DrawerView):void
		{
			//don't forget to set styles from the super class, if required
			this.setScrollerStyles(view);
			
			view.backgroundSkin = new Quad(10, 10, GROUPED_LIST_HEADER_BACKGROUND_COLOR);

			var layout:HorizontalLayout = new HorizontalLayout();
			layout.horizontalAlign = HorizontalAlign.CENTER;
			layout.verticalAlign = VerticalAlign.MIDDLE;
			layout.padding = this.smallGutterSize;
			layout.gap = this.smallGutterSize;
			view.layout = layout;
		}
	}
}
