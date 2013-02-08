package feathers.examples.componentsExplorer.data
{
	import feathers.controls.Slider;

	public class SliderSettings
	{
		public function SliderSettings()
		{
		}

		public var direction:String = Slider.DIRECTION_HORIZONTAL;
		public var step:Number = 1;
		public var page:Number = 10;
		public var liveDragging:Boolean = true;
	}
}
