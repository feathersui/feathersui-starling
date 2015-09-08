package feathers.tests.supportClasses
{
	import starling.display.Quad;

	public class DisposeFlagQuad extends Quad
	{
		public function DisposeFlagQuad()
		{
			super(1, 1, 0xff00ff);
		}

		public var isDisposed:Boolean = false;

		override public function dispose():void
		{
			super.dispose();
			this.isDisposed = true;
		}
	}
}