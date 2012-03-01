package org.josht.starling.foxhole.data
{
	import flash.errors.IllegalOperationError;
	
	public class XMLListListCollectionDataDescriptor implements IListCollectionDataDescriptor
	{
		public function XMLListListCollectionDataDescriptor()
		{
		}
		
		public function getLength(data:Object):int
		{
			this.checkForCorrectDataType(data);
			return (data as XMLList).length();
		}
		
		public function getItemAt(data:Object, index:int):Object
		{
			this.checkForCorrectDataType(data);
			return data[index];
		}
		
		public function setItemAt(data:Object, item:Object, index:int):void
		{
			this.checkForCorrectDataType(data);
			data[index] = XML(item);
		}
		
		public function addItemAt(data:Object, item:Object, index:int):void
		{
			this.checkForCorrectDataType(data);
			data += item;
			trace("Warning: addItemAt() for XMLList always adds items to the end.");
		}
		
		public function removeItemAt(data:Object, index:int):Object
		{
			this.checkForCorrectDataType(data);
			const item:XML = data[index];
			delete data[index];
			return item;
		}
		
		public function getItemIndex(data:Object, item:Object):int
		{
			this.checkForCorrectDataType(data);
			const list:XMLList = data as XMLList;
			const listLength:int = list.length();
			for(var i:int = 0; i < listLength; i++)
			{
				var currentItem:XML = list[i];
				if(currentItem == item)
				{
					return i;
				}
			}
			return -1;
		}
		
		protected function checkForCorrectDataType(data:Object):void
		{
			if(!(data is XMLList))
			{
				throw new IllegalOperationError("Expected XMLList. Received " + Object(data).constructor + " instead.");
			}
		}
	}
}