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
	import feathers.core.FeathersControl;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.ILayout;
	import feathers.layout.IVirtualLayout;
	import feathers.layout.LayoutBoundsResult;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.display.DisplayObject;

	/**
	 * Displays a selected index, usually corresponding to a page index in
	 * another UI control, using a highlighted symbol.
	 */
	public class PageIndicator extends FeathersControl
	{
		private static const LAYOUT_RESULT:LayoutBoundsResult = new LayoutBoundsResult();

		/**
		 * Constructor.
		 */
		public function PageIndicator()
		{
			this.isQuickHitAreaEnabled = true;
		}

		/**
		 * @private
		 */
		protected var selectedSymbol:DisplayObject;

		/**
		 * @private
		 */
		protected var cache:Vector.<DisplayObject> = new <DisplayObject>[];

		/**
		 * @private
		 */
		protected var unselectedSymbols:Vector.<DisplayObject> = new <DisplayObject>[];

		/**
		 * @private
		 */
		protected var symbols:Vector.<DisplayObject> = new <DisplayObject>[];

		/**
		 * @private
		 */
		protected var _maximum:int = 2;

		/**
		 * The maximum selectable page index.
		 */
		public function get maximum():int
		{
			return this._maximum;
		}

		/**
		 * @private
		 */
		public function set maximum(value:int):void
		{
			if(this._maximum == value)
			{
				return;
			}
			this._maximum = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _selectedIndex:int = 0;

		/**
		 * The currently selected index.
		 */
		public function get selectedIndex():int
		{
			return this._selectedIndex;
		}

		/**
		 * @private
		 */
		public function set selectedIndex(value:int):void
		{
			if(this._selectedIndex == value)
			{
				return;
			}
			this._selectedIndex = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this._onChange.dispatch(this);
		}

		/**
		 * @private
		 */
		protected var _layout:ILayout;

		/**
		 * The layout algorithm used to position and, optionally, size the
		 * symbols.
		 */
		public function get layout():ILayout
		{
			return this._layout;
		}

		/**
		 * @private
		 */
		public function set layout(value:ILayout):void
		{
			if(this._layout == value)
			{
				return;
			}
			this._layout = value;
			if(this._layout is IVirtualLayout)
			{
				IVirtualLayout(this._layout).useVirtualLayout = false;
			}
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		/**
		 * @private
		 */
		protected var _normalSymbolFactory:Function;

		/**
		 * A function used to create a normal symbol.
		 *
		 * <p>This function should have the following signature:</p>
		 * <pre>function():DisplayObject</pre>
		 */
		public function get normalSymbolFactory():Function
		{
			return this._normalSymbolFactory;
		}

		/**
		 * @private
		 */
		public function set normalSymbolFactory(value:Function):void
		{
			if(this._normalSymbolFactory == value)
			{
				return;
			}
			this._normalSymbolFactory = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _selectedSymbolFactory:Function;

		/**
		 * A function used to create a selected symbol.
		 *
		 * <p>This function should have the following signature:</p>
		 * <pre>function():DisplayObject</pre>
		 */
		public function get selectedSymbolFactory():Function
		{
			return this._selectedSymbolFactory;
		}

		/**
		 * @private
		 */
		public function set selectedSymbolFactory(value:Function):void
		{
			if(this._selectedSymbolFactory == value)
			{
				return;
			}
			this._selectedSymbolFactory = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _onChange:Signal = new Signal(PageIndicator);

		/**
		 * Dispatched when the selected item changes.
		 */
		public function get onChange():ISignal
		{
			return this._onChange;
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this._onChange.removeAll();
			super.dispose();
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(!this._layout)
			{
				this.layout = new HorizontalLayout();
			}
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);

			if(dataInvalid || selectionInvalid || stylesInvalid)
			{
				this.refreshSymbols(stylesInvalid);
				this.layoutSymbols();
			}
		}

		/**
		 * @private
		 */
		protected function refreshSymbols(symbolsInvalid:Boolean):void
		{
			this.symbols.length = 0;
			const temp:Vector.<DisplayObject> = this.cache;
			if(symbolsInvalid)
			{
				var symbolCount:int = this.unselectedSymbols.length;
				for(var i:int = 0; i < symbolCount; i++)
				{
					var symbol:DisplayObject = this.unselectedSymbols.shift();
					this.removeChild(symbol, true);
				}
				if(this.selectedSymbol)
				{
					this.removeChild(this.selectedSymbol, true);
					this.selectedSymbol = null;
				}
			}
			this.cache = this.unselectedSymbols;
			this.unselectedSymbols = temp;
			for(i = 0; i < this._maximum; i++)
			{
				if(i == this._selectedIndex)
				{
					if(!this.selectedSymbol)
					{
						this.selectedSymbol = this._selectedSymbolFactory();
						this.addChild(this.selectedSymbol);
					}
					this.symbols.push(this.selectedSymbol);
				}
				else
				{
					if(this.cache.length > 0)
					{
						symbol = this.cache.shift();
					}
					else
					{
						symbol = this._normalSymbolFactory();
						this.addChild(symbol);
					}
					this.unselectedSymbols.push(symbol);
					this.symbols.push(symbol);
				}
			}

			symbolCount = this.cache.length;
			for(i = 0; i < symbolCount; i++)
			{
				symbol = this.cache.shift();
				this.removeChild(symbol, true);
			}

		}

		/**
		 * @private
		 */
		protected function layoutSymbols():void
		{
			this._layout.layout(this.symbols, null, LAYOUT_RESULT);
			this.setSizeInternal(LAYOUT_RESULT.contentWidth, LAYOUT_RESULT.contentHeight, false);
		}

	}
}
