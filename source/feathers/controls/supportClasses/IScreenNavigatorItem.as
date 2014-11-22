package feathers.controls.supportClasses
{
	import starling.display.DisplayObject;

	public interface IScreenNavigatorItem
	{
		function get canDispose():Boolean;
		function getScreen():DisplayObject;
	}
}
