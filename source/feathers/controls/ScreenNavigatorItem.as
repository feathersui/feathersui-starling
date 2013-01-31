/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import flash.errors.IllegalOperationError;

	import starling.display.DisplayObject;

	/**
	 * Data for an individual screen that will be used by a <code>ScreenNavigator</code>
	 * object.
	 *
	 * @see http://wiki.starling-framework.org/feathers/screen-navigator
	 * @see feathers.controls.ScreenNavigator
	 */
	public class ScreenNavigatorItem
	{
		/**
		 * Constructor.
		 */
		public function ScreenNavigatorItem(screen:Object = null, events:Object = null, properties:Object = null)
		{
			this.screen = screen;
			this.events = events ? events : {};
			this.properties = properties ? properties : {};
		}
		
		/**
		 * A Starling DisplayObject, a Class that may be instantiated to create
		 * a DisplayObject, or a Function that returns a DisplayObject.
		 */
		public var screen:Object;
		
		/**
		 * A hash of events to which the ScreenNavigator will listen. Keys in
		 * the hash are event types (or the property name of an <code>ISignal</code>),
		 * and values are one of two possible types. If the value is a
		 * <code>String</code>, it must refer to a screen ID for the
		 * <code>ScreenNavigator</code> to display. If the value is a
		 * <code>Function</code>, it must be a listener for the screen's event
		 * or <code>ISignal</code>.
		 */
		public var events:Object;
		
		/**
		 * A hash of properties to set on the screen.
		 */
		public var properties:Object;
		
		/**
		 * Creates and instance of the screen type (or uses the screen directly
		 * if it isn't a class).
		 */
		internal function getScreen():DisplayObject
		{
			var screenInstance:DisplayObject;
			if(this.screen is Class)
			{
				var ScreenType:Class = Class(this.screen);
				screenInstance = new ScreenType();
			}
			else if(this.screen is Function)
			{
				screenInstance = DisplayObject((this.screen as Function)());
			}
			else if(this.screen is DisplayObject)
			{
				screenInstance = DisplayObject(this.screen);
			}
			else
			{
				throw new IllegalOperationError("ScreenNavigatorItem \"screen\" must be a Class, a Function, or a Starling display object.");
			}
			
			if(this.properties)
			{
				for(var property:String in this.properties)
				{
					screenInstance[property] = this.properties[property];
				}
			}
			
			return screenInstance;
		}
	}
}