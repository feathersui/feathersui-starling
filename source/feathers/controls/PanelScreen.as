/*
 Copyright 2012-2013 Joshua Tynjala

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
	/**
	 * A screen for use with <code>ScreenNavigator</code>, based on <code>Panel</code>
	 * in order to provide a header and layout.
	 *
	 * @see ScreenNavigator
	 * @see Panel
	 */
	public class PanelScreen extends Panel implements IScreen
	{
		/**
		 * The default value added to the <code>nameList</code> of the header.
		 */
		public static const DEFAULT_CHILD_NAME_HEADER:String = "feathers-panel-screen-header";

		/**
		 * Constructor.
		 */
		public function PanelScreen()
		{
			this.headerName = DEFAULT_CHILD_NAME_HEADER;
		}

		/**
		 * @private
		 */
		protected var _screenID:String;

		/**
		 * @inheritDoc
		 */
		public function get screenID():String
		{
			return this._screenID;
		}

		/**
		 * @private
		 */
		public function set screenID(value:String):void
		{
			this._screenID = value;
		}

		/**
		 * @private
		 */
		protected var _owner:ScreenNavigator;

		/**
		 * @inheritDoc
		 */
		public function get owner():ScreenNavigator
		{
			return this._owner;
		}

		/**
		 * @private
		 */
		public function set owner(value:ScreenNavigator):void
		{
			this._owner = value;
		}
	}
}
