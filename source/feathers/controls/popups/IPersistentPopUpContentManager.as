/*
Feathers
Copyright 2012-2020 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.popups
{
	/**
	 * An <code>IPopUpContentManager</code> that wraps its content in a custom
	 * UI that should keep the content open until closed by the user.
	 * 
	 * <p>For example, a <code>PickerList</code> using this type of manager
	 * would keep its pop-up open after a list item is selected or triggered.
	 * The manager will provide its own custom UI to close itself, such as a
	 * close button.</p>
	 *
	 * @productversion Feathers 2.3.0
	 */
	public interface IPersistentPopUpContentManager extends IPopUpContentManager
	{
	}
}
