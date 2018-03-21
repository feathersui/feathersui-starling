/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.dragDrop
{
	/**
	 * Stores data associated with a drag and drop operation.
	 *
	 * @see feathers.dragDrop.DragDropManager
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class DragData
	{
		/**
		 * Constructor.
		 */
		public function DragData()
		{
		}

		/**
		 * @private
		 */
		protected var _data:Object = {};

		/**
		 * Determines if the specified data format is available.
		 */
		public function hasDataForFormat(format:String):Boolean
		{
			return this._data.hasOwnProperty(format);
		}

		/**
		 * Returns data for the specified format.
		 */
		public function getDataForFormat(format:String):*
		{
			if(this._data.hasOwnProperty(format))
			{
				return this._data[format];
			}
			return undefined;
		}

		/**
		 * Saves data for the specified format.
		 */
		public function setDataForFormat(format:String, data:*):void
		{
			this._data[format] = data;
		}

		/**
		 * Removes all data for the specified format.
		 */
		public function clearDataForFormat(format:String):*
		{
			var data:* = undefined;
			if(this._data.hasOwnProperty(format))
			{
				data = this._data[format];
			}
			delete this._data[format];
			return data;

		}
	}
}
