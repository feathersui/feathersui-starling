package org.josht.starling.foxhole.controls
{
	import flash.geom.Rectangle;

	public interface IListItemRenderer
	{
		function get data():Object;
		function set data(value:Object):void;
		
		function get index():int;
		function set index(value:int):void;
		
		function get isSelected():Boolean;
		function set isSelected(value:Boolean):void;
		
		function get owner():List;
		function set owner(value:List):void;
	}
}