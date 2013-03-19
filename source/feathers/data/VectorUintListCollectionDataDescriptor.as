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
	 * An <code>IListCollectionDataDescriptor</code> implementation for Vector.&lt;uint&gt;.
	 * 
	 * @see ListCollection
	 * @see IListCollectionDataDescriptor
	 */
	public class VectorUintListCollectionDataDescriptor implements IListCollectionDataDescriptor
	{
		/**
		 * Constructor.
		 */
		public function VectorUintListCollectionDataDescriptor()
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLength(data:Object):int
		{
			this.checkForCorrectDataType(data);
			return (data as Vector.<uint>).length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getItemAt(data:Object, index:int):Object
		{
			this.checkForCorrectDataType(data);
			return (data as Vector.<uint>)[index];
		}
		
		/**
		 * @inheritDoc
		 */
		public function setItemAt(data:Object, item:Object, index:int):void
		{
			this.checkForCorrectDataType(data);
			(data as Vector.<uint>)[index] = item as uint;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addItemAt(data:Object, item:Object, index:int):void
		{
			this.checkForCorrectDataType(data);
			(data as Vector.<uint>).splice(index, 0, item);
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeItemAt(data:Object, index:int):Object
		{
			this.checkForCorrectDataType(data);
			return (data as Vector.<uint>).splice(index, 1)[0];
		}

		/**
		 * @inheritDoc
		 */
		public function removeAll(data:Object):void
		{
			this.checkForCorrectDataType(data);
			(data as Vector.<uint>).length = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getItemIndex(data:Object, item:Object):int
		{
			this.checkForCorrectDataType(data);
			return (data as Vector.<uint>).indexOf(item as uint);
		}
		
		/**
		 * @private
		 */
		protected function checkForCorrectDataType(data:Object):void
		{
			if(!(data is Vector.<uint>))
			{
				throw new IllegalOperationError("Expected Vector.<uint>. Received " + Object(data).constructor + " instead.");
			}
		}
	}
}