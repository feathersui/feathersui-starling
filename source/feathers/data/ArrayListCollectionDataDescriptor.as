/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data
{
	import flash.errors.IllegalOperationError;

	/**
	 * An <code>IListCollectionDataDescriptor</code> implementation for Arrays.
	 *
	 * @see ListCollection
	 * @see IListCollectionDataDescriptor
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class ArrayListCollectionDataDescriptor implements IListCollectionDataDescriptor
	{
		/**
		 * Constructor.
		 */
		public function ArrayListCollectionDataDescriptor()
		{
		}

		/**
		 * @inheritDoc
		 */
		public function getLength(data:Object):int
		{
			this.checkForCorrectDataType(data);
			return (data as Array).length;
		}

		/**
		 * @inheritDoc
		 */
		public function getItemAt(data:Object, index:int):Object
		{
			this.checkForCorrectDataType(data);
			return (data as Array)[index];
		}

		/**
		 * @inheritDoc
		 */
		public function setItemAt(data:Object, item:Object, index:int):void
		{
			this.checkForCorrectDataType(data);
			(data as Array)[index] = item;
		}

		/**
		 * @inheritDoc
		 */
		public function addItemAt(data:Object, item:Object, index:int):void
		{
			this.checkForCorrectDataType(data);
			(data as Array).insertAt(index, item);
		}

		/**
		 * @inheritDoc
		 */
		public function removeItemAt(data:Object, index:int):Object
		{
			this.checkForCorrectDataType(data);
			return (data as Array).removeAt(index);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAll(data:Object):void
		{
			this.checkForCorrectDataType(data);
			(data as Array).length = 0;
		}

		/**
		 * @inheritDoc
		 */
		public function getItemIndex(data:Object, item:Object):int
		{
			this.checkForCorrectDataType(data);
			return (data as Array).indexOf(item);
		}

		/**
		 * @private
		 */
		protected function checkForCorrectDataType(data:Object):void
		{
			if(!(data is Array))
			{
				throw new IllegalOperationError("Expected Array. Received " + Object(data).constructor + " instead.");
			}
		}
	}
}