/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.supportClasses.IScreenNavigatorItem;

	import starling.display.DisplayObject;

	/**
	 * Data for an individual tab that will be displayed by a
	 * <code>TabNavigator</code> component.
	 *
	 * @see ../../../help/tab-navigator.html How to use the Feathers TabNavigator component
	 * @see feathers.controls.TabNavigator
	 */
	public class TabNavigatorItem implements IScreenNavigatorItem
	{
		/**
		 * Constructor.
		 */
		public function TabNavigatorItem()
		{
		}

		/**
		 * @inheritDoc
		 */
		public function get canDispose():Boolean
		{
			return false;
		}

		/**
		 * @inheritDoc
		 */
		public function getScreen():DisplayObject
		{
			return null;
		}
	}
}
