package feathers.tests.supportClasses
{
	import feathers.controls.LayoutGroup;
	import feathers.core.IFocusDisplayObject;
	import feathers.core.IToggle;

	import starling.display.Quad;
	import starling.events.Event;

	public class CustomToggle extends LayoutGroup implements IToggle, IFocusDisplayObject
	{
		public function CustomToggle()
		{
			this.backgroundSkin = new Quad(200, 200, 0xff00ff);
		}
		
		protected var _isSelected:Boolean = false;
		
		public function get isSelected():Boolean
		{
			return this._isSelected;
		}
		
		public function set isSelected(value:Boolean):void
		{
			if(this._isSelected === value)
			{
				return;
			}
			this._isSelected = value;
			this.dispatchEventWith(Event.CHANGE);
		}
	}
}
