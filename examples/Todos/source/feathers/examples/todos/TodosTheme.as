package feathers.examples.todos
{
	import feathers.controls.Check;
	import feathers.controls.LayoutGroup;
	import feathers.examples.todos.controls.TodoItemRenderer;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalAlign;
	import feathers.skins.ImageSkin;
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
			check.horizontalAlign = HorizontalAlign.CENTER;
		}
		
		override protected function setToolbarLayoutGroupStyles(group:LayoutGroup):void
		{
			super.setToolbarLayoutGroupStyles(group);
			
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = this.smallGutterSize;
			layout.padding = this.gutterSize;
			layout.horizontalAlign = HorizontalAlign.CENTER;
			layout.verticalAlign = VerticalAlign.MIDDLE;
			group.layout = layout;
		}
		
		protected function setTodoItemRendererStyles(itemRenderer:TodoItemRenderer):void
		{
			var backgroundSkin:ImageSkin = new ImageSkin(this.itemRendererUpSkinTexture);
			backgroundSkin.scale9Grid = ITEM_RENDERER_SCALE9_GRID;
			itemRenderer.backgroundSkin = backgroundSkin;

			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = this.smallGutterSize;
			layout.padding = this.smallGutterSize;
			layout.verticalAlign = VerticalAlign.MIDDLE;
			itemRenderer.layout = layout;

			var dragIcon:ImageSkin = new ImageSkin(this.dragHandleIcon);
			itemRenderer.dragIcon = dragIcon;
		}
	}
}
