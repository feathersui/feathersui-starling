/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.IVirtualLayout;
	import feathers.layout.VerticalSpinnerLayout;

	import flash.ui.Keyboard;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.KeyboardEvent;

	/**
	 * A customized <code>List</code> component where scrolling updates the
	 * the selected item. Layouts may loop infinitely.
	 *
	 * <p>The following example creates a list, gives it a data provider, tells
	 * the item renderer how to interpret the data, and listens for when the
	 * selection changes:</p>
	 *
	 * <listing version="3.0">
	 * var list:SpinnerList = new SpinnerList();
	 *
	 * list.dataProvider = new ListCollection(
	 * [
	 *     { text: "Milk", thumbnail: textureAtlas.getTexture( "milk" ) },
	 *     { text: "Eggs", thumbnail: textureAtlas.getTexture( "eggs" ) },
	 *     { text: "Bread", thumbnail: textureAtlas.getTexture( "bread" ) },
	 *     { text: "Chicken", thumbnail: textureAtlas.getTexture( "chicken" ) },
	 * ]);
	 *
	 * list.itemRendererFactory = function():IListItemRenderer
	 * {
	 *     var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
	 *     renderer.labelField = "text";
	 *     renderer.iconSourceField = "thumbnail";
	 *     return renderer;
	 * };
	 *
	 * list.addEventListener( Event.CHANGE, list_changeHandler );
	 *
	 * this.addChild( list );</listing>
	 *
	 * @see http://wiki.starling-framework.org/feathers/spinner-list
	 */
	public class SpinnerList extends List
	{
		/**
		 * Constructor.
		 */
		public function SpinnerList()
		{
			this._snapToPages = true;
			this.addEventListener(Event.TRIGGERED, spinnerList_triggeredHandler);
			this.addEventListener(FeathersEventType.SCROLL_COMPLETE, spinnerList_scrollCompleteHandler);
		}

		/**
		 * @private
		 */
		override public function set snapToPages(value:Boolean):void
		{
			if(!value)
			{
				throw new ArgumentError("SpinnerList requires snapping to pages.");
			}
			super.snapToPages = value;
		}

		/**
		 * @private
		 */
		override public function set allowMultipleSelection(value:Boolean):void
		{
			if(value)
			{
				throw new ArgumentError("SpinnerList requires single selection.");
			}
			super.snapToPages = value;
		}

		/**
		 * @private
		 */
		override public function set dataProvider(value:ListCollection):void
		{
			super.dataProvider = value;
			if(!this._dataProvider || this._dataProvider.length == 0)
			{
				this.selectedIndex = -1;
			}
			else
			{
				this.selectedIndex = 0;
			}
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(this._layout == null)
			{
				if(this._hasElasticEdges &&
					this._verticalScrollPolicy == SCROLL_POLICY_AUTO &&
					this._scrollBarDisplayMode != SCROLL_BAR_DISPLAY_MODE_FIXED)
				{
					//so that the elastic edges work even when the max scroll
					//position is 0, similar to iOS.
					this.verticalScrollPolicy = SCROLL_POLICY_ON;
				}

				var layout:VerticalSpinnerLayout = new VerticalSpinnerLayout();
				layout.useVirtualLayout = true;
				layout.padding = 0;
				layout.gap = 0;
				layout.horizontalAlign = VerticalSpinnerLayout.HORIZONTAL_ALIGN_JUSTIFY;
				layout.requestedRowCount = 5;
				this.layout = layout;
			}

			super.initialize();
		}

		/**
		 * @private
		 */
		override protected function refreshMinAndMaxScrollPositions():void
		{
			super.refreshMinAndMaxScrollPositions();
			var typicalItem:DisplayObject = IVirtualLayout(this._layout).typicalItem;
			if(this._maxVerticalScrollPosition != this._minVerticalScrollPosition)
			{
				this.actualPageHeight = this.explicitPageHeight = typicalItem.height;
			}
			else if(this._maxHorizontalScrollPosition != this._minHorizontalScrollPosition)
			{
				this.actualPageWidth = this.explicitPageWidth = typicalItem.width;
			}
		}

		/**
		 * @private
		 */
		override protected function handlePendingScroll():void
		{
			if(this.pendingItemIndex >= 0)
			{
				var itemIndex:int = this.pendingItemIndex;
				this.pendingItemIndex = -1;
				if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
				{
					this.pendingVerticalPageIndex = this.calculateNearestPageIndexForItem(itemIndex, this._verticalPageIndex, this._maxVerticalPageIndex);
				}
				else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
				{
					this.pendingHorizontalPageIndex = this.calculateNearestPageIndexForItem(itemIndex, this._horizontalPageIndex, this._maxHorizontalPageIndex);
				}
			}
			super.handlePendingScroll();
		}

		/**
		 * @private
		 */
		protected function calculateNearestPageIndexForItem(itemIndex:int, currentPageIndex:int, maxPageIndex:int):int
		{
			if(maxPageIndex != int.MAX_VALUE)
			{
				return itemIndex;
			}
			var itemCount:int = this._dataProvider.length;
			var fullDataProviderOffsets:int = currentPageIndex / itemCount;
			var currentItemIndex:int = currentPageIndex % itemCount;
			if(itemIndex < currentItemIndex)
			{
				var previousPageIndex:Number = fullDataProviderOffsets * itemCount + itemIndex;
				var nextPageIndex:Number = (fullDataProviderOffsets + 1) * itemCount + itemIndex;
			}
			else
			{
				previousPageIndex = (fullDataProviderOffsets - 1) * itemCount + itemIndex;
				nextPageIndex = fullDataProviderOffsets * itemCount + itemIndex;
			}
			if((nextPageIndex - currentPageIndex) < (currentPageIndex - previousPageIndex))
			{
				return nextPageIndex;
			}
			return previousPageIndex;
		}

		/**
		 * @private
		 */
		protected function spinnerList_scrollCompleteHandler(event:Event):void
		{
			var itemCount:int = this._dataProvider.length;
			if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
			{
				var pageIndex:int = this._verticalPageIndex % itemCount;
			}
			else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
			{
				pageIndex = this._horizontalPageIndex % itemCount;
			}
			if(pageIndex < 0)
			{
				pageIndex = itemCount + pageIndex;
			}
			this.selectedIndex = pageIndex;
		}

		/**
		 * @private
		 */
		protected function spinnerList_triggeredHandler(event:Event, item:Object):void
		{
			var itemIndex:int = this._dataProvider.getItemIndex(item);
			if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
			{
				itemIndex = this.calculateNearestPageIndexForItem(itemIndex, this._verticalPageIndex, this._maxVerticalPageIndex);
				this.throwToPage(this._horizontalPageIndex, itemIndex, this._pageThrowDuration);
			}
			else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
			{
				itemIndex = this.calculateNearestPageIndexForItem(itemIndex, this._horizontalPageIndex, this._maxHorizontalPageIndex);
				this.throwToPage(itemIndex, this._verticalPageIndex);
			}
		}

		/**
		 * @private
		 */
		override protected function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if(!this._dataProvider)
			{
				return;
			}
			var changedSelection:Boolean = false;
			if(event.keyCode == Keyboard.HOME)
			{
				if(this._dataProvider.length > 0)
				{
					this.selectedIndex = 0;
					changedSelection = true;
				}
			}
			else if(event.keyCode == Keyboard.END)
			{
				this.selectedIndex = this._dataProvider.length - 1;
				changedSelection = true;
			}
			else if(event.keyCode == Keyboard.UP)
			{
				var newIndex:int = this._selectedIndex - 1;
				if(newIndex < 0)
				{
					newIndex = this._dataProvider.length + newIndex;
				}
				this.selectedIndex = newIndex;
				changedSelection = true;
			}
			else if(event.keyCode == Keyboard.DOWN)
			{
				newIndex = this._selectedIndex + 1;
				if(newIndex >= this._dataProvider.length)
				{
					newIndex -= this._dataProvider.length;
				}
				this.selectedIndex = newIndex;
				changedSelection = true;
			}
			if(changedSelection)
			{
				if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
				{
					var pageIndex:int = this.calculateNearestPageIndexForItem(this._selectedIndex, this._verticalPageIndex, this._maxVerticalPageIndex);
					this.throwToPage(this._horizontalPageIndex, pageIndex, this._pageThrowDuration);
				}
				else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
				{
					pageIndex = this.calculateNearestPageIndexForItem(this._selectedIndex, this._horizontalPageIndex, this._maxHorizontalPageIndex);
					this.throwToPage(pageIndex, this._verticalPageIndex);
				}
			}
		}
	}
}
