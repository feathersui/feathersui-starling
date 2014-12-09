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
	import feathers.layout.HorizontalLayout;
	import feathers.layout.ILayout;
	import feathers.layout.VerticalLayout;

	import starling.events.Event;

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
		override public function set layout(value:ILayout):void
		{
			if(value is VerticalLayout)
			{
				var verticalLayout:VerticalLayout = VerticalLayout(value);
				//these properties are required for this component.
				verticalLayout.repeatItems = true;
				verticalLayout.hasVariableItemDimensions = false;
			}
			else if(value is HorizontalLayout)
			{
				var horizontalLayout:HorizontalLayout = HorizontalLayout(value);
				horizontalLayout.repeatItems = true;
				horizontalLayout.hasVariableItemDimensions = false;
			}
			else
			{
				throw new ArgumentError("SpinnerList requires VerticalLayout or HorizontalLayout.");
			}
			super.layout = value;
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

				var layout:VerticalLayout = new VerticalLayout();
				layout.useVirtualLayout = true;
				layout.padding = 0;
				layout.gap = 0;
				layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
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
			if(this._layout is VerticalLayout)
			{
				this.actualPageHeight = this.explicitPageHeight = VerticalLayout(this._layout).typicalItem.height;
			}
			else //horizontal
			{
				this.actualPageWidth = this.explicitPageWidth = HorizontalLayout(this._layout).typicalItem.width;
			}
		}

		/**
		 * @private
		 */
		protected function spinnerList_scrollCompleteHandler(event:Event):void
		{
			var itemCount:int = this._dataProvider.length;
			if(this._layout is VerticalLayout)
			{
				var pageIndex:int = this._verticalPageIndex % itemCount;
			}
			else //horizontal
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
			if(this._layout is VerticalLayout)
			{
				if(this._maxVerticalPageIndex != int.MAX_VALUE)
				{
					this.scrollToPageIndex(0, itemIndex);
					return;
				}
				var pageIndex:int = this._verticalPageIndex;
			}
			else //horizontal
			{
				if(this._maxHorizontalPageIndex != int.MAX_VALUE)
				{
					this.scrollToPageIndex(itemIndex, 0);
					return;
				}
				pageIndex = this._horizontalPageIndex;
			}
			var itemCount:int = this._dataProvider.length;
			var fullDataProviderOffsets:int = pageIndex / itemCount;
			if(itemIndex < pageIndex)
			{
				var previousIndex:Number = fullDataProviderOffsets * itemCount + itemIndex;
				var nextIndex:Number = (fullDataProviderOffsets + 1) * itemCount + itemIndex;
			}
			else
			{
				nextIndex = fullDataProviderOffsets * itemCount + itemIndex;
				previousIndex = (fullDataProviderOffsets - 1) * itemCount + itemIndex;
			}

			if((nextIndex - pageIndex) < (pageIndex - previousIndex))
			{
				if(this._layout is VerticalLayout)
				{
					this.scrollToPageIndex(0, nextIndex);
				}
				else //horizontal
				{
					this.scrollToPageIndex(nextIndex, 0);
				}
			}
			else
			{
				if(this._layout is VerticalLayout)
				{
					this.scrollToPageIndex(0, previousIndex);
				}
				else //horizontal
				{
					this.scrollToPageIndex(previousIndex, 0);
				}
			}
		}
	}
}
