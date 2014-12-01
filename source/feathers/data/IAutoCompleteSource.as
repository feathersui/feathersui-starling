package feathers.data
{
	import feathers.core.IFeathersEventDispatcher;
	import feathers.data.ListCollection;

	public interface IAutoCompleteSource extends IFeathersEventDispatcher
	{
		function load(text:String, result:ListCollection = null):void;
	}
}
