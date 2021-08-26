/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data
{
	/**
	 * Constants for sorting of items in a collection.
	 *
	 * <p>Note: Some constants may not be valid for certain properties. Please
	 * see the description of the property in the API reference for full
	 * details.</p>
	 *
	 * @productversion Feathers 3.4.0
	 */
	public class SortOrder
	{
		/**
		 * Indicates that items are sorted in ascending order.
		 *
		 * @productversion Feathers 3.4.0
		 */
		public static const ASCENDING:String = "ascending";

		/**
		 * Indicates that items are sorted in descending order.
		 *
		 * @productversion Feathers 3.4.0
		 */
		public static const DESCENDING:String = "descending";

		/**
		 * Indicates that items are not sorted.
		 *
		 * @productversion Feathers 3.4.0
		 */
		public static const NONE:String = "none";
	}
}