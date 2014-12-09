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
			else if(this._layout is HorizontalLayout)
			{
				this.actualPageWidth = this.explicitPageWidth = HorizontalLayout(this._layout).typicalItem.width;
			}
		}

		/**
		 * @private
		 */
		protected function spinnerList_scrollCompleteHandler(event:Event):void
		{
			if(this._layout is VerticalLayout)
			{
				trace(this.verticalPageIndex, this.maxVerticalPageIndex);
				this.selectedIndex = this.verticalPageIndex;
			}
			else if(this._layout is HorizontalLayout)
			{
				this.selectedIndex = this.horizontalPageIndex;
			}
		}

		/**
		 * @private
		 */
		protected function spinnerList_triggeredHandler(event:Event, item:Object):void
		{
			var pageIndex:int = this._dataProvider.getItemIndex(item);
			if(this._layout is VerticalLayout)
			{
				this.scrollToPageIndex(0, pageIndex);
			}
			else if(this._layout is HorizontalLayout)
			{
				this.scrollToPageIndex(pageIndex, 0);
			}
		}
	}
}
