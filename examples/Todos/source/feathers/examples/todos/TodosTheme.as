package feathers.examples.todos
{
	import feathers.controls.Check;
	import feathers.controls.LayoutGroup;
	import feathers.display.Scale9Image;
	import feathers.examples.todos.controls.TodoItemRenderer;
	import feathers.layout.HorizontalLayout;
	import feathers.themes.MetalWorksMobileTheme;

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
			itemRenderer.backgroundSkin = new Scale9Image(this.itemRendererUpSkinTextures, this.scale);

			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = 10;
			layout.padding = 10;
			layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			itemRenderer.layout = layout;
		}
	}
}
