package feathers.examples.todos
{
	import feathers.examples.todos.controls.TodoItemRenderer;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.display.DisplayObjectContainer;

	public class TodosTheme extends MetalWorksMobileTheme
	{
		public function TodosTheme(container:DisplayObjectContainer = null, scaleToDPI:Boolean = true)
		{
			super(container, scaleToDPI);
		}

		override protected function initialize():void
		{
			super.initialize();
			this.setInitializerForClass(TodoItemRenderer, this.itemRendererInitializer);
		}
	}
}
