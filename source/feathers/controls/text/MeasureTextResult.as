/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.text
{
	/**
	 * The result of text measurement.
	 *
	 * @productversion Feathers 3.0.0
	 */
	public class MeasureTextResult
	{
		/**
		 * Constructor.
		 */
		public function MeasureTextResult(width:Number = 0, height:Number = 0,
			isTruncated:Boolean = false)
		{
			this.width = width;
			this.height = height;
			this.isTruncated = isTruncated;
		}

		/**
		 * The measured width of the text.
		 */
		public var width:Number;

		/**
		 * The measured height of the text.
		 */
		public var height:Number;

		/**
		 * Indicates if the text needed to be truncated.
		 */
		public var isTruncated:Boolean;
	}
}
