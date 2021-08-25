/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	/**
	 * Constants to control how the toast queue will behave when the maximum
	 * number of allowed toasts are visible.
	 * 
	 * @productversion Feathers 4.0.0
	 * 
	 * @see feathers.controls.Toast
	 */
	public class ToastQueueMode
	{
		/**
		 * If a new toast is queued up, and any of the active toasts have a
		 * timeout, the timeout is cancelled immediately, and the new toast is
		 * displayed after the active toast has finished closing.
		 * 
		 * @productversion Feathers 4.0.0
		 */
		public static const CANCEL_TIMEOUT:String = "cancelTimeout";

		/**
		 * If a new toast is queued up, waits indefinitely until the next active
		 * toast closes.
		 * 
		 * @productversion Feathers 4.0.0
		 */
		public static const WAIT_FOR_TIMEOUT:String = "waitForTimeout";
	}
}