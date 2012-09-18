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
package feathers.controls.renderers
{
	import feathers.controls.List;

	/**
	 * The default item renderer for List control. Supports up to three optional
	 * sub-views, including a label to display text, an icon to display an
	 * image, and an "accessory" to display a UI control or another display
	 * object (with shortcuts for including a second image or a second label).
	 * 
	 * @see feathers.controls.List
	 */
	public class DefaultListItemRenderer extends BaseDefaultItemRenderer implements IListItemRenderer
	{
		/**
		 * Constructor.
		 */
		public function DefaultListItemRenderer()
		{
			super();
		}
		
		/**
		 * @private
		 */
		private var _index:int = -1;
		
		/**
		 * @inheritDoc
		 */
		public function get index():int
		{
			return this._index;
		}
		
		/**
		 * @private
		 */
		public function set index(value:int):void
		{
			this._index = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get owner():List
		{
			return List(this._owner);
		}
		
		/**
		 * @private
		 */
		public function set owner(value:List):void
		{
			if(this._owner == value)
			{
				return;
			}
			if(this._owner)
			{
				List(this._owner).onScroll.remove(owner_onScroll);
			}
			this._owner = value;
			if(this._owner)
			{
				const list:List = List(this._owner);
				this.isToggle = list.isSelectable;
				list.onScroll.add(owner_onScroll);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		/**
		 * @private
		 */
		protected function owner_onScroll(list:List):void
		{
			this.handleOwnerScroll();
		}
	}
}