package feathers.examples.todos
{
	import feathers.controls.Check;
	import feathers.controls.LayoutGroup;
	import feathers.examples.todos.controls.TodoItemRenderer;
	import feathers.layout.HorizontalLayout;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.display.Image;

	public class TodosTheme extends MetalWorksMobileTheme
	{
		public function TodosTheme()
		{
			super();
		}
		
		override protected function initializeStyleProviders():void
		{
			super.initializeStyleProviders();
			
			this.getStyleProviderForClass(TodoItemRenderer).defaultStyleFunction = this.setTodoItemRendererStyles;
		}

		override protected function setCheckStyles(check:Check):void
		{
			super.setCheckStyles(check);
			check.hasLabelTextRenderer = false;
			check.horizontalAlign = Check.HORIZONTAL_ALIGN_CENTER;
		}
		
		override protected function setToolbarLayoutGroupStyles(group:LayoutGroup):void
		{
			super.setToolbarLayoutGroupStyles(group);
			
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = this.smallGutterSize;
			layout.padding = this.gutterSize;
			layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			group.layout = layout;
		}
		
		protected function setTodoItemRendererStyles(itemRenderer:TodoItemRenderer):void
		{
			var backgroundSkin:Image = new Image(this.itemRendererUpSkinTexture);
			backgroundSkin.scale9Grid = ITEM_RENDERER_SCALE9_GRID;
			itemRenderer.backgroundSkin = backgroundSkin;

			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = this.smallGutterSize;
			layout.padding = this.smallGutterSize;
			layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			itemRenderer.layout = layout;
		}
	}
}
