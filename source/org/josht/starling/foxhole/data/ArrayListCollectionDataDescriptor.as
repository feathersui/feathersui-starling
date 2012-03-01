package org.josht.starling.foxhole.data
{
	import flash.errors.IllegalOperationError;

	public class ArrayListCollectionDataDescriptor implements IListCollectionDataDescriptor
	{
		public function ArrayListCollectionDataDescriptor()
		{
		}
		
		public function getLength(data:Object):int
		{
			this.checkForCorrectDataType(data);
			return (data as Array).length;
		}
		
		public function getItemAt(data:Object, index:int):Object
		{
			this.checkForCorrectDataType(data);
			return (data as Array)[index];
		}
		
		public function setItemAt(data:Object, item:Object, index:int):void
		{
			this.checkForCorrectDataType(data);
			(data as Array)[index] = item;
		}
		
		public function addItemAt(data:Object, item:Object, index:int):void
		{
			this.checkForCorrectDataType(data);
			(data as Array).splice(index, 0, item);
		}
		
		public function removeItemAt(data:Object, index:int):Object
		{
			this.checkForCorrectDataType(data);
			return (data as Array).splice(index, 1)[0];
		}
		
		public function getItemIndex(data:Object, item:Object):int
		{
			this.checkForCorrectDataType(data);
			return (data as Array).indexOf(item);
		}
		
		protected function checkForCorrectDataType(data:Object):void
		{
			if(!(data is Array))
			{
				throw new IllegalOperationError("Expected Array. Received " + Object(data).constructor + " instead.");
			}
		}
	}
}