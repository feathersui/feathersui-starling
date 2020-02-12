/*
Feathers
Copyright 2012-2020 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	/**
	 * Layout options for stepper controls.
	 *
	 * @see feathers.controls.NumericStepper
	 *
	 * @productversion Feathers 3.0.0
	 */
	public class StepperButtonLayoutMode
	{
		/**
		 * The decrement button will be placed on the left side of the text
		 * input and the increment button will be placed on the right side of
		 * the text input.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const SPLIT_HORIZONTAL:String = "splitHorizontal";

		/**
		 * The decrement button will be placed below the text input and the
		 * increment button will be placed above the text input.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const SPLIT_VERTICAL:String = "splitVertical";

		/**
		 * Both the decrement and increment button will be placed on the right
		 * side of the text input. The increment button will be above the
		 * decrement button.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const RIGHT_SIDE_VERTICAL:String = "rightSideVertical";
	}
}
