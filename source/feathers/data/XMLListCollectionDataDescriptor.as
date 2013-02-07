/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data
{
	import flash.errors.IllegalOperationError;

	/**
	 * An <code>IListCollectionDataDescriptor</code> implementation for
	 * XML.
	 * 
	 * @see ListCollection
	 * @see IListCollectionDataDescriptor
	 */
	public class XMLListCollectionDataDescriptor implements IListCollectionDataDescriptor
	{
		/**
		 * Constructor.
		 */
		public function XMLListCollectionDataDescriptor()
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLength(data:Object):int
		{
			this.checkForCorrectDataType(data);
			return (data as XML).children().length();
		}
		
		/**
		 * @inheritDoc
		 */
		public function getItemAt(data:Object, index:int):Object
		{
			this.checkForCorrectDataType(data);
			return (data as XML).children()[index];
		}
		
		/**
		 * @inheritDoc
		 */
		public function setItemAt(data:Object, item:Object, index:int):void
		{
			this.checkForCorrectDataType(data);
			(data as XML).replace(index,item as XML);
		}
		
		/**
		 * @inheritDoc
		 */
		public function addItemAt(data:Object, item:Object, index:int):void
		{
			this.checkForCorrectDataType(data);
			if(index==0) {
				(data as XML).prependChild(item as XML);
			} else {
				var xml:XML=data as XML;
				if(index>=xml.children().length()) {
					xml.appendChild(item as XML);
				} else {
					xml.insertChildBefore(xml.children()[index],item as XML);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeItemAt(data:Object, index:int):Object
		{
			this.checkForCorrectDataType(data);
			
			const item:XML = (data as XML).children()[index];
			delete (data as XML).children()[index];
			return item;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getItemIndex(data:Object, item:Object):int
		{
			this.checkForCorrectDataType(data);
			
			const list:XMLList = (data as XML).children();
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
		
		/**
		 * @private
		 */
		protected function checkForCorrectDataType(data:Object):void
		{
			if(!(data is XML))
			{
				throw new IllegalOperationError("Expected XML. Received " + Object(data).constructor + " instead.");
			}
		}
	}
}