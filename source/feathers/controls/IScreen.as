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
	import feathers.core.IFeathersControl;

	/**
	 * A screen for use with <code>ScreenNavigator</code>.
	 *
	 * @see ScreenNavigator
	 * @see ScreenNavigatorItem
	 */
	public interface IScreen extends IFeathersControl
	{
		/**
		 * The identifier for the screen. This value is passed in by the
		 * <code>ScreenNavigator</code> when the screen is instantiated.
		 */
		function get screenID():String;

		/**
		 * @private
		 */
		function set screenID(value:String):void;

		/**
		 * The ScreenNavigator that is displaying this screen.
		 */
		function get owner():ScreenNavigator;

		/**
		 * @private
		 */
		function set owner(value:ScreenNavigator):void;
	}
}
