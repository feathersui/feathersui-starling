/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.IValidating;
	import feathers.data.IListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.ILayout;
	import feathers.layout.ISpinnerLayout;
	import feathers.layout.VerticalSpinnerLayout;
	import feathers.skins.IStyleProvider;

	import flash.events.KeyboardEvent;
	import flash.events.TransformGestureEvent;
	import flash.ui.Keyboard;

	import starling.display.DisplayObject;
	import starling.events.Event;

	/**
	 * Determines if the <code>selectionOverlaySkin</code> is hidden when
	 * the list is not focused.
	 *
	 * <listing version="3.0">
	 * list.hideSelectionOverlayUnlessFocused = true;</listing>
	 *
	 * <p>Note: If the <code>showSelectionOverlay</code> property is
	 * <code>false</code>, the <code>selectionOverlaySkin</code> will always
	 * be hidden.</p>
	 *
	 * @default false
	 *
	 * @see #style:selectionOverlaySkin
	 * @see #style:showSelectionOverlay
	 */
	[Style(name="hideSelectionOverlayUnlessFocused",type="Boolean")]

	/**
	 * An optional skin to display in the horizontal or vertical center of
	 * the list to highlight the currently selected item. If the list
	 * scrolls vertically, the <code>selectionOverlaySkin</code> will fill
	 * the entire width of the list, and it will be positioned in the
	 * vertical center. If the list scrolls horizontally, the
	 * <code>selectionOverlaySkin</code> will fill the entire height of the
	 * list, and it will be positioned in the horizontal center.
	 *
	 * <p>The following example gives the spinner list a selection overlay
	 * skin:</p>
	 *
	 * <listing version="3.0">
	 * list.selectionOverlaySkin = new Image( texture );</listing>
	 *
	 * @default null
	 */
	[Style(name="selectionOverlaySkin",type="starling.display.DisplayObject")]

	/**
	 * Determines if the <code>selectionOverlaySkin</code> is visible or hidden.
	 *
	 * <p>The following example hides the selection overlay skin:</p>
	 *
	 * <listing version="3.0">
	 * list.showSelectionOverlay = false;</listing>
	 *
	 * @default true
	 *
	 * @see #style:selectionOverlaySkin
	 * @see #style:hideSelectionOverlayUnlessFocused
	 */
	[Style(name="showSelectionOverlay",type="Boolean")]

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
	 * list.dataProvider = new ArrayCollection(
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
	 * @see ../../../help/spinner-list.html How to use the Feathers SpinnerList component
	 *
	 * @productversion Feathers 2.1.0
	 */
	public class SpinnerList extends List
	{
		/**
		 * The default <code>IStyleProvider</code> for all <code>SpinnerList</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function SpinnerList()
		{
			super();
			this._scrollBarDisplayMode = ScrollBarDisplayMode.NONE;
			this._snapToPages = true;
			this._snapOnComplete = true;
			this.decelerationRate = DecelerationRate.FAST;
			this.addEventListener(Event.TRIGGERED, spinnerList_triggeredHandler);
			this.addEventListener(FeathersEventType.SCROLL_COMPLETE, spinnerList_scrollCompleteHandler);
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			if(SpinnerList.globalStyleProvider)
			{
				return SpinnerList.globalStyleProvider;
			}
			return List.globalStyleProvider;
		}

		/**
		 * <code>SpinnerList</code> requires that the <code>snapToPages</code>
		 * property is set to <code>true</code>. Attempts to set it to
		 * <code>false</code> will result in a runtime error.
		 *
		 * @throws ArgumentError SpinnerList requires snapToPages to be true.
		 */
		override public function set snapToPages(value:Boolean):void
		{
			if(!value)
			{
				throw new ArgumentError("SpinnerList requires snapToPages to be true.");
			}
			super.snapToPages = value;
		}

		/**
		 * <code>SpinnerList</code> requires that the <code>allowMultipleSelection</code>
		 * property is set to <code>false</code>. Attempts to set it to
		 * <code>true</code> will result in a runtime error.
		 *
		 * @throws ArgumentError SpinnerList requires allowMultipleSelection to be false.
		 */
		override public function set allowMultipleSelection(value:Boolean):void
		{
			if(value)
			{
				throw new ArgumentError("SpinnerList requires allowMultipleSelection to be false.");
			}
			super.allowMultipleSelection = value;
		}

		/**
		 * <code>SpinnerList</code> requires that the <code>isSelectable</code>
		 * property is set to <code>true</code>. Attempts to set it to
		 * <code>false</code> will result in a runtime error.
		 *
		 * @throws ArgumentError SpinnerList requires isSelectable to be true.
		 */
		override public function set isSelectable(value:Boolean):void
		{
			if(!value)
			{
				throw new ArgumentError("SpinnerList requires isSelectable to be true.");
			}
			super.snapToPages = value;
		}

		/**
		 * @private
		 */
		override public function set layout(value:ILayout):void
		{
			if(value && !(value is ISpinnerLayout))
			{
				throw new ArgumentError("SpinnerList requires layouts to implement the ISpinnerLayout interface.");
			}
			super.layout = value;
		}

		/**
		 * @private
		 */
		override public function set selectedIndex(value:int):void
		{
			if(value < 0 && this._dataProvider !== null && this._dataProvider.length > 0)
			{
				//a SpinnerList must always select an item, unless the data
				//provider is empty
				return;
			}
			if(this._selectedIndex !== value)
			{
				this.scrollToDisplayIndex(value, 0);
			}
			super.selectedIndex = value;
		}

		/**
		 * @private
		 */
		override public function set selectedItem(value:Object):void
		{
			if(this._dataProvider === null)
			{
				this.selectedIndex = -1;
				return;
			}
			var index:int = this._dataProvider.getItemIndex(value);
			if(index < 0)
			{
				return;
			}
			this.selectedIndex = index; 
		}

		/**
		 * @private
		 */
		override public function set dataProvider(value:IListCollection):void
		{
			if(this._dataProvider == value)
			{
				return;
			}
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
		protected var _selectionOverlaySkin:DisplayObject;

		/**
		 * @private
		 */
		public function get selectionOverlaySkin():DisplayObject
		{
			return this._selectionOverlaySkin;
		}

		/**
		 * @private
		 */
		public function set selectionOverlaySkin(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._selectionOverlaySkin === value)
			{
				return;
			}
			if(this._selectionOverlaySkin && this._selectionOverlaySkin.parent == this)
			{
				this.removeRawChildInternal(this._selectionOverlaySkin);
			}
			this._selectionOverlaySkin = value;
			if(this._selectionOverlaySkin)
			{
				this.addRawChildInternal(this._selectionOverlaySkin);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _showSelectionOverlay:Boolean = true;

		/**
		 * @private
		 */
		public function get showSelectionOverlay():Boolean
		{
			return this._showSelectionOverlay;
		}

		/**
		 * @private
		 */
		public function set showSelectionOverlay(value:Boolean):void
		{
			if(this._showSelectionOverlay === value)
			{
				return;
			}
			this._showSelectionOverlay = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _hideSelectionOverlayUnlessFocused:Boolean = false;

		/**
		 * @private
		 */
		public function get hideSelectionOverlayUnlessFocused():Boolean
		{
			return this._hideSelectionOverlayUnlessFocused;
		}

		/**
		 * @private
		 */
		public function set hideSelectionOverlayUnlessFocused(value:Boolean):void
		{
			if(this._hideSelectionOverlayUnlessFocused === value)
			{
				return;
			}
			this._hideSelectionOverlayUnlessFocused = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			//SpinnerList has a different default layout than its superclass,
			//List, so set it before calling super.initialize()
			if(this._layout === null)
			{
				if(this._hasElasticEdges &&
					this._verticalScrollPolicy === ScrollPolicy.AUTO &&
					this._scrollBarDisplayMode !== ScrollBarDisplayMode.FIXED)
				{
					//so that the elastic edges work even when the max scroll
					//position is 0, similar to iOS.
					this._verticalScrollPolicy = ScrollPolicy.ON;
				}

				var layout:VerticalSpinnerLayout = new VerticalSpinnerLayout();
				layout.useVirtualLayout = true;
				layout.padding = 0;
				layout.gap = 0;
				layout.horizontalAlign = HorizontalAlign.JUSTIFY;
				layout.requestedRowCount = 4;
				this.ignoreNextStyleRestriction();
				this.layout = layout;
			}

			super.initialize();
		}

		/**
		 * @private
		 */
		override protected function refreshMinAndMaxScrollPositions():void
		{
			var oldActualPageWidth:Number = this.actualPageWidth;
			var oldActualPageHeight:Number = this.actualPageHeight;
			super.refreshMinAndMaxScrollPositions();
			if(this._maxVerticalScrollPosition !== this._minVerticalScrollPosition)
			{
				this.actualPageHeight = ISpinnerLayout(this._layout).snapInterval;
				if(!this.isScrolling && this.pendingItemIndex === -1 &&
					this.actualPageHeight !== oldActualPageHeight)
				{
					//if the height of items have changed, we need to tweak the
					//scroll position to re-center the selected item.
					//we don't do this if the user is currently scrolling or if
					//the selected index has changed (which will set
					//pendingItemIndex).
					var verticalPageIndex:int = this.calculateNearestPageIndexForItem(this._selectedIndex, this._verticalPageIndex, this._maxVerticalPageIndex);
					this._verticalScrollPosition = this.actualPageHeight * verticalPageIndex;
				}
			}
			else if(this._maxHorizontalScrollPosition !== this._minHorizontalScrollPosition)
			{
				this.actualPageWidth = ISpinnerLayout(this._layout).snapInterval;
				if(!this.isScrolling && this.pendingItemIndex === -1 &&
					this.actualPageWidth !== oldActualPageWidth)
				{
					var horizontalPageIndex:int = this.calculateNearestPageIndexForItem(this._selectedIndex, this._horizontalPageIndex, this._maxHorizontalPageIndex);
					this._horizontalScrollPosition = this.actualPageWidth * horizontalPageIndex;
				}
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
					this.hasPendingVerticalPageIndex = this.pendingVerticalPageIndex !== this._verticalPageIndex;
				}
				else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
				{
					this.pendingHorizontalPageIndex = this.calculateNearestPageIndexForItem(itemIndex, this._horizontalPageIndex, this._maxHorizontalPageIndex);
					this.hasPendingHorizontalPageIndex = this.pendingHorizontalPageIndex !== this._horizontalPageIndex;
				}
			}
			super.handlePendingScroll();
		}

		/**
		 * @private
		 */
		override protected function layoutChildren():void
		{
			super.layoutChildren();

			if(this._selectionOverlaySkin)
			{
				if(this._showSelectionOverlay && this._hideSelectionOverlayUnlessFocused &&
					this._focusManager !== null && this._isFocusEnabled)
				{
					this._selectionOverlaySkin.visible = this._hasFocus;
				}
				else
				{
					this._selectionOverlaySkin.visible = this._showSelectionOverlay;
				}
				if(this._selectionOverlaySkin is IValidating)
				{
					IValidating(this._selectionOverlaySkin).validate();
				}
				if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
				{
					this._selectionOverlaySkin.width = this.actualWidth - this._leftViewPortOffset - this._rightViewPortOffset;
					var overlayHeight:Number = this.actualPageHeight;
					if(overlayHeight > this.actualHeight)
					{
						overlayHeight = this.actualHeight;
					}
					this._selectionOverlaySkin.height = overlayHeight;
					this._selectionOverlaySkin.x = this._leftViewPortOffset;
					this._selectionOverlaySkin.y = Math.round(this._topViewPortOffset + (this.actualHeight - this._topViewPortOffset - this._bottomViewPortOffset - overlayHeight) / 2);
				}
				else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
				{
					var overlayWidth:Number = this.actualPageWidth;
					if(overlayWidth > this.actualWidth)
					{
						overlayWidth = this.actualWidth;
					}
					this._selectionOverlaySkin.width = overlayWidth;
					this._selectionOverlaySkin.height = this.actualHeight - this._topViewPortOffset - this._bottomViewPortOffset;
					this._selectionOverlaySkin.x = Math.round(this._leftViewPortOffset + (this.actualWidth - this._leftViewPortOffset - this._rightViewPortOffset - overlayWidth) / 2);
					this._selectionOverlaySkin.y = this._topViewPortOffset;
				}
			}
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
			if(this._maxVerticalPageIndex !== this._minVerticalPageIndex)
			{
				var pageIndex:int = this._verticalPageIndex % itemCount;
			}
			else if(this._maxHorizontalPageIndex !== this._minHorizontalPageIndex)
			{
				pageIndex = this._horizontalPageIndex % itemCount;
			}
			if(pageIndex < 0)
			{
				pageIndex = itemCount + pageIndex;
			}
			var item:Object = this._dataProvider.getItemAt(pageIndex);
			var itemRenderer:IListItemRenderer = this.itemToItemRenderer(item);
			if(itemRenderer !== null && !itemRenderer.isEnabled)
			{
				//if the item renderer isn't enabled, we cannot select it
				//go back to the previously selected index
				if(this._maxVerticalPageIndex !== this._minVerticalPageIndex)
				{
					this.scrollToPageIndex(this._horizontalPageIndex, this._selectedIndex, this._pageThrowDuration);
				}
				else if(this._maxHorizontalPageIndex !== this._minHorizontalPageIndex)
				{
					this.scrollToPageIndex(this._selectedIndex, this._verticalPageIndex, this._pageThrowDuration);
				}
				return;
			}
			this.selectedIndex = pageIndex;
		}

		/**
		 * @private
		 */
		protected function spinnerList_triggeredHandler(event:Event, item:Object):void
		{
			var itemIndex:int = this._dataProvider.getItemIndex(item);
			//property must change immediately, but the animation can take longer
			this.selectedIndex = itemIndex;
			if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
			{
				itemIndex = this.calculateNearestPageIndexForItem(itemIndex, this._verticalPageIndex, this._maxVerticalPageIndex);
				this.throwToPage(this._horizontalPageIndex, itemIndex, this._pageThrowDuration);
			}
			else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
			{
				itemIndex = this.calculateNearestPageIndexForItem(itemIndex, this._horizontalPageIndex, this._maxHorizontalPageIndex);
				this.throwToPage(itemIndex, this._verticalPageIndex, this._pageThrowDuration);
			}
		}

		/**
		 * @private
		 */
		override protected function dataProvider_removeItemHandler(event:Event, index:int):void
		{
			super.dataProvider_removeItemHandler(event, index);
			if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
			{
				var itemIndex:int = this.calculateNearestPageIndexForItem(this._selectedIndex, this._verticalPageIndex, this._maxVerticalPageIndex);
				if(itemIndex > this._dataProvider.length)
				{
					itemIndex -= this._dataProvider.length;
				}
				this.scrollToDisplayIndex(itemIndex, 0);
			}
			else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
			{
				itemIndex = this.calculateNearestPageIndexForItem(this._selectedIndex, this._horizontalPageIndex, this._maxHorizontalPageIndex);
				if(itemIndex > this._dataProvider.length)
				{
					itemIndex -= this._dataProvider.length;
				}
				this.scrollToDisplayIndex(itemIndex, 0);
			}
		}

		/**
		 * @private
		 */
		override protected function dataProvider_addItemHandler(event:Event, index:int):void
		{
			super.dataProvider_addItemHandler(event, index);
			if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
			{
				var itemIndex:int = this.calculateNearestPageIndexForItem(this._selectedIndex, this._verticalPageIndex, this._maxVerticalPageIndex);
				if(itemIndex > this._dataProvider.length)
				{
					itemIndex -= this._dataProvider.length;
				}
				this.scrollToDisplayIndex(itemIndex, 0);
			}
			else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
			{
				itemIndex = this.calculateNearestPageIndexForItem(this._selectedIndex, this._horizontalPageIndex, this._maxHorizontalPageIndex);
				if(itemIndex > this._dataProvider.length)
				{
					itemIndex -= this._dataProvider.length;
				}
				this.scrollToDisplayIndex(itemIndex, 0);
			}
		}

		/**
		 * @private
		 */
		override protected function nativeStage_keyDownHandler(event:KeyboardEvent):void
		{
			if(event.isDefaultPrevented())
			{
				return;
			}
			if(!this._dataProvider)
			{
				return;
			}
			if(event.keyCode === Keyboard.HOME || event.keyCode === Keyboard.END ||
				event.keyCode === Keyboard.PAGE_UP ||event.keyCode === Keyboard.PAGE_DOWN ||
				event.keyCode === Keyboard.UP ||event.keyCode === Keyboard.DOWN ||
				event.keyCode === Keyboard.LEFT ||event.keyCode === Keyboard.RIGHT)
			{
				var newIndex:int = this.dataViewPort.calculateNavigationDestination(this.selectedIndex, event.keyCode);
				if(this.selectedIndex !== newIndex)
				{
					//property must change immediately, but the animation can take longer
					this.selectedIndex = newIndex;
					if(this._maxVerticalPageIndex !== this._minVerticalPageIndex)
					{
						event.preventDefault();
						var pageIndex:int = this.calculateNearestPageIndexForItem(newIndex, this._verticalPageIndex, this._maxVerticalPageIndex);
						this.throwToPage(this._horizontalPageIndex, pageIndex, this._pageThrowDuration);
					}
					else if(this._maxHorizontalPageIndex !== this._minHorizontalPageIndex)
					{
						event.preventDefault();
						pageIndex = this.calculateNearestPageIndexForItem(newIndex, this._horizontalPageIndex, this._maxHorizontalPageIndex);
						this.throwToPage(pageIndex, this._verticalPageIndex, this._pageThrowDuration);
					}
				}
			}
		}

		/**
		 * @private
		 */
		override protected function stage_gestureDirectionalTapHandler(event:TransformGestureEvent):void
		{
			if(event.isDefaultPrevented())
			{
				//something else has already handled this event
				return;
			}
			var keyCode:uint = int.MAX_VALUE;
			if(event.offsetY < 0)
			{
				keyCode = Keyboard.UP;
			}
			else if(event.offsetY > 0)
			{
				keyCode = Keyboard.DOWN;
			}
			else if(event.offsetX > 0)
			{
				keyCode = Keyboard.RIGHT;
			}
			else if(event.offsetX < 0)
			{
				keyCode = Keyboard.LEFT;
			}
			if(keyCode === int.MAX_VALUE)
			{
				return;
			}
			var newIndex:int = this.dataViewPort.calculateNavigationDestination(this.selectedIndex, keyCode);
			if(this.selectedIndex !== newIndex)
			{
				//property must change immediately, but the animation can take longer
				this.selectedIndex = newIndex;
				if(this._maxVerticalPageIndex !== this._minVerticalPageIndex)
				{
					event.stopImmediatePropagation();
					//event.preventDefault();
					var pageIndex:int = this.calculateNearestPageIndexForItem(newIndex, this._verticalPageIndex, this._maxVerticalPageIndex);
					this.throwToPage(this._horizontalPageIndex, pageIndex, this._pageThrowDuration);
				}
				else if(this._maxHorizontalPageIndex !== this._minHorizontalPageIndex)
				{
					event.stopImmediatePropagation();
					//event.preventDefault();
					pageIndex = this.calculateNearestPageIndexForItem(newIndex, this._horizontalPageIndex, this._maxHorizontalPageIndex);
					this.throwToPage(pageIndex, this._verticalPageIndex, this._pageThrowDuration);
				}
			}
		}
	}
}
