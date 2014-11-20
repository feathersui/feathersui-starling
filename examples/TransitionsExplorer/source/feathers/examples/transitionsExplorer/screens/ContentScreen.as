package feathers.examples.transitionsExplorer.screens
{
	import feathers.controls.Screen;

	import starling.display.Quad;

	public class ContentScreen extends Screen
	{
		public function ContentScreen()
		{
		}

		public var color:uint;

		override protected function initialize():void
		{
			this.backgroundSkin = new Quad(1, 1, this.color);
		}

	}
}
