package feathers.tests.supportClasses
{
	import feathers.core.IFeathersControl;
	import feathers.skins.IStyleProvider;

	public class CustomStyleProvider implements IStyleProvider
	{
		public function CustomStyleProvider()
		{
		}

		private var _appliedStyles:Boolean = false;

		public function get appliedStyles():Boolean
		{
			return this._appliedStyles;
		}

		public function applyStyles(target:IFeathersControl):void
		{
			this._appliedStyles = true;
		}
	}
}
