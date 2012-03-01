package org.josht.starling.foxhole.data
{
	public interface IListCollectionDataDescriptor
	{
		function getLength(data:Object):int;
		function getItemAt(data:Object, index:int):Object;
		function setItemAt(data:Object, item:Object, index:int):void;
		function addItemAt(data:Object, item:Object, index:int):void;
		function removeItemAt(data:Object, index:int):Object;
		function getItemIndex(data:Object, item:Object):int;
	}
}