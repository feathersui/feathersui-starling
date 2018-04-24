/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data
{
	import flash.errors.IllegalOperationError;

	/**
	 * An <code>IListCollectionDataDescriptor</code> implementation for
	 * XMLLists. Has some limitations due to certain things that cannot be done
	 * to XMLLists.
	 * 
	 * @see ListCollection
	 * @see IListCollectionDataDescriptor
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class XMLListListCollectionDataDescriptor implements IListCollectionDataDescriptor
	{
		/**
		 * Constructor.
		 */
		public function XMLListListCollectionDataDescriptor()
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLength(data:Object):int
		{
			this.checkForCorrectDataType(data);
			return (data as XMLList).length();
		}
		
		/**
		 * @inheritDoc
		 */
		public function getItemAt(data:Object, index:int):Object
		{
			this.checkForCorrectDataType(data);
			return data[index];
		}
		
		/**
		 * @inheritDoc
		 */
		public function setItemAt(data:Object, item:Object, index:int):void
		{
			this.checkForCorrectDataType(data);
			data[index] = XML(item);
		}
		
		/**
		 * @inheritDoc
		 */
		public function addItemAt(data:Object, item:Object, index:int):void
		{
			this.checkForCorrectDataType(data);
			
			//wow, this is weird. unless I have failed epicly, I can find no 
			//other way to insert an element into an XMLList at a specific index.
			var dataClone:XMLList = (data as XMLList).copy();
			data[index] = item;
			var listLength:int = dataClone.length();
			for(var i:int = index; i < listLength; i++)
			{
				data[i + 1] = dataClone[i];
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeItemAt(data:Object, index:int):Object
		{
			this.checkForCorrectDataType(data);
			var item:XML = data[index];
			delete data[index];
			return item;
		}

		/**
		 * @inheritDoc
		 */
		public function removeAll(data:Object):void
		{
			this.checkForCorrectDataType(data);
			var list:XMLList = data as XMLList;
			var listLength:int = list.length();
			for(var i:int = 0; i < listLength; i++)
			{
				delete data[0];
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function getItemIndex(data:Object, item:Object):int
		{
			this.checkForCorrectDataType(data);
			var list:XMLList = data as XMLList;
			var listLength:int = list.length();
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
		
		/**
		 * @private
		 */
		protected function checkForCorrectDataType(data:Object):void
		{
			if(!(data is XMLList))
			{
				throw new IllegalOperationError("Expected XMLList. Received " + Object(data).constructor + " instead.");
			}
		}
	}
}