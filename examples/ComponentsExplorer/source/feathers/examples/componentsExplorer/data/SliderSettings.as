package feathers.examples.componentsExplorer.data
{
	import feathers.controls.TrackInteractionMode;

	public class SliderSettings
	{
		public function SliderSettings()
		{
		}

		public var step:Number = 1;
		public var page:Number = 10;
		public var liveDragging:Boolean = true;
		public var trackInteractionMode:String = TrackInteractionMode.TO_VALUE;
	}
}
