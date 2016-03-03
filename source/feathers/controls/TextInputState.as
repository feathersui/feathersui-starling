/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	/**
	 * States for text input components.
	 *
	 * @see feathers.controls.TextInput
	 * @see feathers.controls.TextArea
	 * @see feathers.controls.AutoComplete
	 */
	public class TextInputState
	{
		/**
		 * The default state, when the input is enabled.
		 */
		public static const ENABLED:String = "enabled";
		
		/**
		 * The disabled state, when the input is not enabled.
		 */
		public static const DISABLED:String = "disabled";
		
		/**
		 * The focused state, when the input is currently in focus and the user
		 * can interact with it.
		 */
		public static const FOCUSED:String = "focused";

		/**
		 * The state when the input has an error string.
		 */
		public static const ERROR:String = "error";
	}
}
