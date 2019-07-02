/*
Feathers
Copyright 2012-2019 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.IFeathersControl;

	import starling.display.DisplayObject;

	/**
	 * Defines functions for a <code>Scroller</code> subclass that delegates
	 * display list manipulations to its <code>IViewPort</code>.
	 *
	 * <p>Mainly intended for <code>ScrollContainer</code>, but other subclasses
	 * of <code>Scroller</code> could possibly implement it too.</p>
	 *
	 * @see feathers.controls.Scroller
	 * @see feathers.controls.ScrollContainer
	 *
	 * @productversion Feathers 1.3.0
	 */
	public interface IScrollContainer extends IFeathersControl
	{
		/**
		 * Returns the number of raw children that are added directly to the
		 * <code>Scroller</code> rather than delegating the call to the view
		 * port.
		 */
		function get numRawChildren():int;

		/**
		 * Gets the name of a direct child of the <code>Scroller</code> rather
		 * than delegating the call to the view port.
		 */
		function getRawChildByName(name:String):DisplayObject;

		/**
		 * Gets the index of a direct child of the <code>Scroller</code> rather
		 * than delegating the call to the view port.
		 */
		function getRawChildIndex(child:DisplayObject):int;

		/**
		 * Gets the direct child of the <code>Scroller</code> at a specific
		 * index rather than delegating the call to the view port.
		 */
		function getRawChildAt(index:int):DisplayObject;

		/**
		 * Sets the index of a direct child of the <code>Scroller</code> rather
		 * than delegating the call to the view port.
		 */
		function setRawChildIndex(child:DisplayObject, index:int):void;

		/**
		 * Adds a child to the <code>Scroller</code> rather than delegating the
		 * call to the view port.
		 */
		function addRawChild(child:DisplayObject):DisplayObject;

		/**
		 * Adds a child to the <code>Scroller</code> at a specific index rather
		 * than delegating the call to the view port.
		 */
		function addRawChildAt(child:DisplayObject, index:int):DisplayObject;

		/**
		 * Removes a child from the <code>Scroller</code> rather than delegating
		 * the call to the view port.
		 */
		function removeRawChild(child:DisplayObject, dispose:Boolean = false):DisplayObject;

		/**
		 * Removes a child from the <code>Scroller</code> at a specific index
		 * rather than delegating the call to the view port.
		 */
		function removeRawChildAt(index:int, dispose:Boolean = false):DisplayObject;

		/**
		 * Swaps the children of the <code>Scroller</code> rather than
		 * delegating the call to the view port.
		 */
		function swapRawChildren(child1:DisplayObject, child2:DisplayObject):void;

		/**
		 * Swaps the children of the <code>Scroller</code> rather than
		 * delegating the call to the view port.
		 */
		function swapRawChildrenAt(index1:int, index2:int):void;

		/**
		 * Sorts the children of the <code>Scroller</code> rather than
		 * delegating the call to the view port.
		 */
		function sortRawChildren(compareFunction:Function):void;
	}
}
