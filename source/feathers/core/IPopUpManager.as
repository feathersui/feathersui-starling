/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;

	/**
	 * Interface for pop-up management.
	 *
	 * @see feathers.core.PopUpManager
	 */
	public interface IPopUpManager
	{
		/**
		 * @copy PopUpManager#overlayFactory
		 */
		function get overlayFactory():Function;

		/**
		 * @private
		 */
		function set overlayFactory(value:Function):void;

		/**
		 * @copy PopUpManager#root
		 */
		function get root():DisplayObjectContainer;

		/**
		 * @private
		 */
		function set root(value:DisplayObjectContainer):void;

		/**
		 * @copy PopUpManager#addPopUp()
		 */
		function addPopUp(popUp:DisplayObject, isModal:Boolean = true, isCentered:Boolean = true, customOverlayFactory:Function = null):DisplayObject;

		/**
		 * @copy PopUpManager#removePopUp()
		 */
		function removePopUp(popUp:DisplayObject, dispose:Boolean = false):DisplayObject;

		/**
		 * @copy PopUpManager#isPopUp()
		 */
		function isPopUp(popUp:DisplayObject):Boolean;

		/**
		 * @copy PopUpManager#isTopLevelPopUp()
		 */
		function isTopLevelPopUp(popUp:DisplayObject):Boolean;

		/**
		 * @copy PopUpManager#centerPopUp()
		 */
		function centerPopUp(popUp:DisplayObject):void;
	}
}
