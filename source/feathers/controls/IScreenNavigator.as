package feathers.controls
{
	import feathers.controls.supportClasses.IScreenNavigatorItem;
	import feathers.core.IFeathersControl;

	public interface IScreenNavigator extends IFeathersControl
	{
		function addScreen(id:String, item:IScreenNavigatorItem):void;
		function removeScreen(id:String):IScreenNavigatorItem;
		function removeAllScreens():void;
		function getScreen(id:String):IScreenNavigatorItem;
		function hasScreen(id:String):Boolean;
		function getScreenIDs(result:Vector.<String> = null):Vector.<String>
	}
}
