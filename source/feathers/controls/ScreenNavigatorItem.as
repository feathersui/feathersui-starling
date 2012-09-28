/*
Copyright (c) 2012 Josh Tynjala

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package feathers.controls
{
	import flash.errors.IllegalOperationError;

	import starling.display.DisplayObject;

	/**
	 * Data for an individual screen that will be used by a <code>ScreenNavigator</code>
	 * object.
	 * 
	 * @see feathers.controls.ScreenNavigator
	 * 
	 * @author Josh Tynjala (joshblog.net)
	 */
	public class ScreenNavigatorItem
	{
		/**
		 * Creates a new ScreenNavigatorItem instance.
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
		 * the hash are event types, and values are one of two possible types.
		 * If the value is a String, it must refer to a screen ID for the
		 * ScreenNavigator to display. If the value is a Function, it must
		 * be a listener for the screen's event. 
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