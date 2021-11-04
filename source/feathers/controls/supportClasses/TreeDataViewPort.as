/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses
{
	import feathers.controls.Scroller;
	import feathers.controls.Tree;
	import feathers.controls.renderers.ITreeItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.IValidating;
	import feathers.data.IHierarchicalCollection;
	import feathers.data.IListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.ILayout;
	import feathers.layout.IVariableVirtualLayout;
	import feathers.layout.IVirtualLayout;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.ViewPortBounds;

	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.utils.Pool;

	/**
	 * @private
	 * Used internally by Tree. Not meant to be used on its own.
	 *
	 * @productversion Feathers 3.3.0
	 */
	public class TreeDataViewPort extends FeathersControl implements IViewPort
	{
		private static const INVALIDATION_FLAG_ITEM_RENDERER_FACTORY:String = "itemRendererFactory";
		private static const HELPER_VECTOR:Vector.<int> = new <int>[];
		private static const LOCATION_HELPER_VECTOR:Vector.<int> = new <int>[];

		public function TreeDataViewPort()
		{
			super();
		}

		private var _viewPortBounds:ViewPortBounds = new ViewPortBounds();

		private var _layoutResult:LayoutBoundsResult = new LayoutBoundsResult();

		private var _actualMinVisibleWidth:Number = 0;

		private var _explicitMinVisibleWidth:Number;

		public function get minVisibleWidth():Number
		{
			if(this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth) //isNaN
			{
				return this._actualMinVisibleWidth;
			}
			return this._explicitMinVisibleWidth;
		}

		public function set minVisibleWidth(value:Number):void
		{
			if(this._explicitMinVisibleWidth == value)
			{
				return;
			}
			var valueIsNaN:Boolean = value !== value; //isNaN
			if(valueIsNaN &&
				this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth) //isNaN
			{
				return;
			}
			var oldValue:Number = this._explicitMinVisibleWidth;
			this._explicitMinVisibleWidth = value;
			if(valueIsNaN)
			{
				this._actualMinVisibleWidth = 0;
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
			else
			{
				this._actualMinVisibleWidth = value;
				if(this._explicitVisibleWidth !== this._explicitVisibleWidth && //isNaN
					(this._actualVisibleWidth < value || this._actualVisibleWidth == oldValue))
				{
					//only invalidate if this change might affect the visibleWidth
					this.invalidate(INVALIDATION_FLAG_SIZE);
				}
			}
		}

		private var _maxVisibleWidth:Number = Number.POSITIVE_INFINITY;

		public function get maxVisibleWidth():Number
		{
			return this._maxVisibleWidth;
		}

		public function set maxVisibleWidth(value:Number):void
		{
			if(this._maxVisibleWidth == value)
			{
				return;
			}
			if(value !== value) //isNaN
			{
				throw new ArgumentError("maxVisibleWidth cannot be NaN");
			}
			var oldValue:Number = this._maxVisibleWidth;
			this._maxVisibleWidth = value;
			if(this._explicitVisibleWidth !== this._explicitVisibleWidth && //isNaN
				(this._actualVisibleWidth > value || this._actualVisibleWidth == oldValue))
			{
				//only invalidate if this change might affect the visibleWidth
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		private var _actualVisibleWidth:Number = NaN;

		private var _explicitVisibleWidth:Number = NaN;

		public function get visibleWidth():Number
		{
			return this._actualVisibleWidth;
		}

		public function set visibleWidth(value:Number):void
		{
			if(this._explicitVisibleWidth == value ||
				(value !== value && this._explicitVisibleWidth !== this._explicitVisibleWidth)) //isNaN
			{
				return;
			}
			this._explicitVisibleWidth = value;
			if(this._actualVisibleWidth != value)
			{
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		private var _actualMinVisibleHeight:Number = 0;

		private var _explicitMinVisibleHeight:Number;

		public function get minVisibleHeight():Number
		{
			if(this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight) //isNaN
			{
				return this._actualMinVisibleHeight;
			}
			return this._explicitMinVisibleHeight;
		}

		public function set minVisibleHeight(value:Number):void
		{
			if(this._explicitMinVisibleHeight == value)
			{
				return;
			}
			var valueIsNaN:Boolean = value !== value; //isNaN
			if(valueIsNaN &&
				this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight) //isNaN
			{
				return;
			}
			var oldValue:Number = this._explicitMinVisibleHeight;
			this._explicitMinVisibleHeight = value;
			if(valueIsNaN)
			{
				this._actualMinVisibleHeight = 0;
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
			else
			{
				this._actualMinVisibleHeight = value;
				if(this._explicitVisibleHeight !== this._explicitVisibleHeight && //isNaN
					(this._actualVisibleHeight < value || this._actualVisibleHeight == oldValue))
				{
					//only invalidate if this change might affect the visibleHeight
					this.invalidate(INVALIDATION_FLAG_SIZE);
				}
			}
		}

		private var _maxVisibleHeight:Number = Number.POSITIVE_INFINITY;

		public function get maxVisibleHeight():Number
		{
			return this._maxVisibleHeight;
		}

		public function set maxVisibleHeight(value:Number):void
		{
			if(this._maxVisibleHeight == value)
			{
				return;
			}
			if(value !== value) //isNaN
			{
				throw new ArgumentError("maxVisibleHeight cannot be NaN");
			}
			var oldValue:Number = this._maxVisibleHeight;
			this._maxVisibleHeight = value;
			if(this._explicitVisibleHeight !== this._explicitVisibleHeight && //isNaN
				(this._actualVisibleHeight > value || this._actualVisibleHeight == oldValue))
			{
				//only invalidate if this change might affect the visibleHeight
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		private var _actualVisibleHeight:Number;

		private var _explicitVisibleHeight:Number = NaN;

		public function get visibleHeight():Number
		{
			return this._actualVisibleHeight;
		}

		public function set visibleHeight(value:Number):void
		{
			if(this._explicitVisibleHeight == value ||
				(value !== value && this._explicitVisibleHeight !== this._explicitVisibleHeight)) //isNaN
			{
				return;
			}
			this._explicitVisibleHeight = value;
			if(this._actualVisibleHeight != value)
			{
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		protected var _contentX:Number = 0;

		public function get contentX():Number
		{
			return this._contentX;
		}

		protected var _contentY:Number = 0;

		public function get contentY():Number
		{
			return this._contentY;
		}

		public function get horizontalScrollStep():Number
		{
			var itemRenderer:DisplayObject = null;
			var virtualLayout:IVirtualLayout = this._layout as IVirtualLayout;
			if(virtualLayout === null || !virtualLayout.useVirtualLayout)
			{
				if(this._layoutItems.length > 0)
				{
					itemRenderer = this._layoutItems[0] as DisplayObject;
				}
			}
			if(itemRenderer === null)
			{
				itemRenderer = this._typicalItemRenderer as DisplayObject;
			}
			if(itemRenderer === null)
			{
				return 0;
			}
			var itemRendererWidth:Number = itemRenderer.width;
			var itemRendererHeight:Number = itemRenderer.height;
			if(itemRendererWidth < itemRendererHeight)
			{
				return itemRendererWidth;
			}
			return itemRendererHeight;
		}

		public function get verticalScrollStep():Number
		{
			var itemRenderer:DisplayObject = null;
			var virtualLayout:IVirtualLayout = this._layout as IVirtualLayout;
			if(virtualLayout === null || !virtualLayout.useVirtualLayout)
			{
				if(this._layoutItems.length > 0)
				{
					itemRenderer = this._layoutItems[0] as DisplayObject;
				}
			}
			if(itemRenderer === null)
			{
				itemRenderer = this._typicalItemRenderer as DisplayObject;
			}
			if(itemRenderer === null)
			{
				return 0;
			}
			var itemRendererWidth:Number = itemRenderer.width;
			var itemRendererHeight:Number = itemRenderer.height;
			if(itemRendererWidth < itemRendererHeight)
			{
				return itemRendererWidth;
			}
			return itemRendererHeight;
		}

		private var _owner:Tree = null;

		public function get owner():Tree
		{
			return this._owner;
		}

		public function set owner(value:Tree):void
		{
			this._owner = value;
		}

		private var _updateForDataReset:Boolean = false;

		private var _dataProvider:IHierarchicalCollection = null;

		public function get dataProvider():IHierarchicalCollection
		{
			return this._dataProvider;
		}

		public function set dataProvider(value:IHierarchicalCollection):void
		{
			if(this._dataProvider == value)
			{
				return;
			}
			if(this._dataProvider)
			{
				this._dataProvider.removeEventListener(Event.CHANGE, dataProvider_changeHandler);
				/*this._dataProvider.removeEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
				this._dataProvider.removeEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ITEM, dataProvider_updateItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ALL, dataProvider_updateAllHandler);*/
			}
			this._dataProvider = value;
			if(this._dataProvider)
			{
				this._dataProvider.addEventListener(Event.CHANGE, dataProvider_changeHandler);
				/*this._dataProvider.addEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
				this._dataProvider.addEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.UPDATE_ITEM, dataProvider_updateItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.UPDATE_ALL, dataProvider_updateAllHandler);*/
			}
			if(this._layout is IVariableVirtualLayout)
			{
				IVariableVirtualLayout(this._layout).resetVariableVirtualCache();
			}
			this._updateForDataReset = true;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		private var _ignoreLayoutChanges:Boolean = false;
		private var _ignoreRendererResizing:Boolean = false;

		private var _layout:ILayout = null;

		public function get layout():ILayout
		{
			return this._layout;
		}

		public function set layout(value:ILayout):void
		{
			if(this._layout == value)
			{
				return;
			}
			if(this._layout)
			{
				this._layout.removeEventListener(Event.CHANGE, layout_changeHandler);
			}
			this._layout = value;
			if(this._layout)
			{
				if(this._layout is IVariableVirtualLayout)
				{
					var variableVirtualLayout:IVariableVirtualLayout = IVariableVirtualLayout(this._layout);
					variableVirtualLayout.resetVariableVirtualCache();
				}
				this._layout.addEventListener(Event.CHANGE, layout_changeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		private var _horizontalScrollPosition:Number = 0;

		public function get horizontalScrollPosition():Number
		{
			return this._horizontalScrollPosition;
		}

		public function set horizontalScrollPosition(value:Number):void
		{
			if(this._horizontalScrollPosition == value)
			{
				return;
			}
			this._horizontalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		private var _verticalScrollPosition:Number = 0;

		public function get verticalScrollPosition():Number
		{
			return this._verticalScrollPosition;
		}

		public function set verticalScrollPosition(value:Number):void
		{
			if(this._verticalScrollPosition == value)
			{
				return;
			}
			this._verticalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		public function get requiresMeasurementOnScroll():Boolean
		{
			return this._layout.requiresLayoutOnScroll &&
				(this._explicitVisibleWidth !== this._explicitVisibleWidth || //isNaN
				this._explicitVisibleHeight !== this._explicitVisibleHeight); //isNaN
		}

		private var _ignoreSelectionChanges:Boolean = false;

		private var _isSelectable:Boolean = true;

		public function get isSelectable():Boolean
		{
			return this._isSelectable;
		}

		public function set isSelectable(value:Boolean):void
		{
			if(this._isSelectable == value)
			{
				return;
			}
			this._isSelectable = value;
			if(!this._isSelectable)
			{
				this.selectedItem = null;
			}
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		private var _selectedItem:Object = null;

		public function get selectedItem():Object
		{
			return this._selectedItem;
		}

		public function set selectedItem(value:Object):void
		{
			if(this._selectedItem == value)
			{
				return;
			}
			this._selectedItem = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.dispatchEventWith(Event.CHANGE);
		}

		private var _typicalItem:Object = null;

		public function get typicalItem():Object
		{
			return this._typicalItem;
		}

		public function set typicalItem(value:Object):void
		{
			if(this._typicalItem == value)
			{
				return;
			}
			this._typicalItem = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		private var _itemRendererType:Class;

		public function get itemRendererType():Class
		{
			return this._itemRendererType;
		}

		public function set itemRendererType(value:Class):void
		{
			if(this._itemRendererType == value)
			{
				return;
			}

			this._itemRendererType = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _itemRendererFactory:Function;

		public function get itemRendererFactory():Function
		{
			return this._itemRendererFactory;
		}

		public function set itemRendererFactory(value:Function):void
		{
			if(this._itemRendererFactory === value)
			{
				return;
			}

			this._itemRendererFactory = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _itemRendererFactories:Object;

		public function get itemRendererFactories():Object
		{
			return this._itemRendererFactories;
		}

		public function set itemRendererFactories(value:Object):void
		{
			if(this._itemRendererFactories === value)
			{
				return;
			}

			this._itemRendererFactories = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _factoryIDFunction:Function;

		public function get factoryIDFunction():Function
		{
			return this._factoryIDFunction;
		}

		public function set factoryIDFunction(value:Function):void
		{
			if(this._factoryIDFunction === value)
			{
				return;
			}

			this._factoryIDFunction = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _customItemRendererStyleName:String;

		public function get customItemRendererStyleName():String
		{
			return this._customItemRendererStyleName;
		}

		public function set customItemRendererStyleName(value:String):void
		{
			if(this._customItemRendererStyleName == value)
			{
				return;
			}
			this._customItemRendererStyleName = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _openBranches:IListCollection;

		public function get openBranches():IListCollection
		{
			return this._openBranches;
		}

		public function set openBranches(value:IListCollection):void
		{
			if(this._openBranches == value)
			{
				return;
			}
			if(this._openBranches !== null)
			{
				this._openBranches.removeEventListener(Event.CHANGE, openBranches_changeHandler);
			}
			this._openBranches = value;
			if(this._openBranches !== null)
			{
				this._openBranches.addEventListener(Event.CHANGE, openBranches_changeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		private var _typicalItemIsInDataProvider:Boolean = false;
		private var _typicalItemRenderer:ITreeItemRenderer;

		private var _layoutItems:Vector.<DisplayObject> = new <DisplayObject>[];

		private var _unrenderedItems:Array = [];
		private var _defaultItemRendererStorage:ItemRendererFactoryStorage = new ItemRendererFactoryStorage();
		private var _itemStorageMap:Object = {};
		private var _itemRendererMap:Dictionary = new Dictionary(true);
		private var _minimumItemCount:int;

		public function calculateNavigationDestination(location:Vector.<int>, keyCode:uint, result:Vector.<int>):void
		{
			var displayIndex:int = this.locationToDisplayIndex(location, false);
			if(displayIndex == -1)
			{
				throw new ArgumentError("Cannot calculate navigation destination for location: " + location);
			}
			var newDisplayIndex:int = this._layout.calculateNavigationDestination(this._layoutItems, displayIndex, keyCode, this._layoutResult);
			this.displayIndexToLocation(newDisplayIndex, result);
		}

		public function getScrollPositionForLocation(location:Vector.<int>, result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}

			var displayIndex:int = this.locationToDisplayIndex(location, true);
			if(displayIndex == -1)
			{
				throw new ArgumentError("Cannot calculate scroll position for location: " + location);
			}
			return this._layout.getScrollPositionForIndex(displayIndex, this._layoutItems,
				0, 0, this._actualVisibleWidth, this._actualVisibleHeight, result);
		}

		public function getNearestScrollPositionForIndex(location:Vector.<int>, result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}

			var displayIndex:int = this.locationToDisplayIndex(location, true);
			if(displayIndex == -1)
			{
				throw new ArgumentError("Cannot calculate nearest scroll position for location: " + location);
			}
			return this._layout.getNearestScrollPositionForIndex(displayIndex, this._horizontalScrollPosition,
				this._verticalScrollPosition, this._layoutItems, 0, 0, this._actualVisibleWidth, this._actualVisibleHeight, result);
		}

		public function itemToItemRenderer(item:Object):ITreeItemRenderer
		{
			if(item is XML || item is XMLList)
			{
				return ITreeItemRenderer(this._itemRendererMap[item.toXMLString()]);
			}
			return ITreeItemRenderer(this._itemRendererMap[item]);
		}

		override public function dispose():void
		{
			this.refreshInactiveItemRenderers(null, true);
			if(this._itemStorageMap)
			{
				for(var factoryID:String in this._itemStorageMap)
				{
					this.refreshInactiveItemRenderers(factoryID, true);
				}
			}
			this.owner = null;
			this.dataProvider = null;
			this.layout = null;
			super.dispose();
		}

		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var scrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			var itemRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);

			//scrolling only affects the layout is requiresLayoutOnScroll is true
			if(!layoutInvalid && scrollInvalid && this._layout && this._layout.requiresLayoutOnScroll)
			{
				layoutInvalid = true;
			}

			var basicsInvalid:Boolean = sizeInvalid || dataInvalid || layoutInvalid || itemRendererInvalid;

			var oldIgnoreRendererResizing:Boolean = this._ignoreRendererResizing;
			this._ignoreRendererResizing = true;
			var oldIgnoreLayoutChanges:Boolean = this._ignoreLayoutChanges;
			this._ignoreLayoutChanges = true;

			if(scrollInvalid || sizeInvalid)
			{
				this.refreshViewPortBounds();
			}
			if(basicsInvalid)
			{
				this.refreshInactiveItemRenderers(null, itemRendererInvalid);
				if(this._itemStorageMap)
				{
					for(var factoryID:String in this._itemStorageMap)
					{
						this.refreshInactiveItemRenderers(factoryID, itemRendererInvalid);
					}
				}
			}
			if(dataInvalid || layoutInvalid || itemRendererInvalid)
			{
				this.refreshLayoutTypicalItem();
			}
			if(basicsInvalid)
			{
				this.refreshItemRenderers();
			}
			if(selectionInvalid || basicsInvalid)
			{
				//unlike resizing renderers and layout changes, we only want to
				//stop listening for selection changes when we're forcibly
				//updating selection. other property changes on item renderers
				//can validly change selection, and we need to detect that.
				var oldIgnoreSelectionChanges:Boolean = this._ignoreSelectionChanges;
				this._ignoreSelectionChanges = true;
				this.refreshSelection();
				this._ignoreSelectionChanges = oldIgnoreSelectionChanges;
			}
			if(stateInvalid || basicsInvalid)
			{
				this.refreshEnabled();
			}
			this._ignoreLayoutChanges = oldIgnoreLayoutChanges;

			if(stateInvalid || selectionInvalid || stylesInvalid || basicsInvalid)
			{
				this._layout.layout(this._layoutItems, this._viewPortBounds, this._layoutResult);
			}

			this._ignoreRendererResizing = oldIgnoreRendererResizing;

			this._contentX = this._layoutResult.contentX;
			this._contentY = this._layoutResult.contentY;
			this.saveMeasurements(this._layoutResult.contentWidth, this._layoutResult.contentHeight,
				this._layoutResult.contentWidth, this._layoutResult.contentHeight);
			this._actualVisibleWidth = this._layoutResult.viewPortWidth;
			this._actualVisibleHeight = this._layoutResult.viewPortHeight;
			this._actualMinVisibleWidth = this._layoutResult.viewPortWidth;
			this._actualMinVisibleHeight = this._layoutResult.viewPortHeight;

			//final validation to avoid juggler next frame issues
			this.validateRenderers();
		}

		private function displayIndexToLocation(displayIndex:int, result:Vector.<int>):void
		{
		}

		private var _displayIndex:int;

		private function locationToDisplayIndex(location:Vector.<int>, returnNearestIfBranchNotOpen:Boolean):int
		{
			this._displayIndex = -1;
			var result:Object = this.locationToDisplayIndexAtBranch(new <int>[], location, returnNearestIfBranchNotOpen);
			if(result !== null)
			{
				return this._displayIndex;
			}
			return -1;
		}

		private function locationToDisplayIndexAtBranch(locationOfBranch:Vector.<int>, locationToFind:Vector.<int>, returnNearestIfBranchNotOpen:Boolean):Object
		{
			var childCount:int = this._dataProvider.getLengthAtLocation(locationOfBranch);
			for(var i:int = 0; i < childCount; i++)
			{
				this._displayIndex++;
				locationOfBranch[locationOfBranch.length] = i;
				var child:Object = this._dataProvider.getItemAtLocation(locationOfBranch);
				if(locationOfBranch.length == locationToFind.length)
				{
					var every:Boolean = locationOfBranch.every(function(item:int, index:int, source:Vector.<int>):Boolean
					{
						return item === locationToFind[index];
					});
					if(every)
					{
						return child;
					}
				}
				if(this._dataProvider.isBranch(child))
				{
					if(this.owner.isBranchOpen(child))
					{
						var result:Object = this.locationToDisplayIndexAtBranch(locationOfBranch, locationToFind, returnNearestIfBranchNotOpen);
						if(result)
						{
							return result;
						}
					}
					else if(returnNearestIfBranchNotOpen)
					{
						//if the location is inside a closed branch
						//return that branch
						every = locationOfBranch.every(function(item:int, index:int, source:Vector.<int>):Boolean
						{
							return item === locationToFind[index];
						});
						if(every)
						{
							return child;
						}
					}
				}
				locationOfBranch.length--;
			}
			//location was not found!
			return null;
		}

		private function refreshViewPortBounds():void
		{
			var needsMinWidth:Boolean = this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth; //isNaN
			var needsMinHeight:Boolean = this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight; //isNaN
			this._viewPortBounds.x = 0;
			this._viewPortBounds.y = 0;
			this._viewPortBounds.scrollX = this._horizontalScrollPosition;
			this._viewPortBounds.scrollY = this._verticalScrollPosition;
			this._viewPortBounds.explicitWidth = this._explicitVisibleWidth;
			this._viewPortBounds.explicitHeight = this._explicitVisibleHeight;
			if(needsMinWidth)
			{
				this._viewPortBounds.minWidth = 0;
			}
			else
			{
				this._viewPortBounds.minWidth = this._explicitMinVisibleWidth;
			}
			if(needsMinHeight)
			{
				this._viewPortBounds.minHeight = 0;
			}
			else
			{
				this._viewPortBounds.minHeight = this._explicitMinVisibleHeight;
			}
			this._viewPortBounds.maxWidth = this._maxVisibleWidth;
			this._viewPortBounds.maxHeight = this._maxVisibleHeight;
		}

		private function refreshLayoutTypicalItem():void
		{
			var virtualLayout:IVirtualLayout = this._layout as IVirtualLayout;
			if(virtualLayout === null || !virtualLayout.useVirtualLayout)
			{
				//the old layout was virtual, but this one isn't
				if(!this._typicalItemIsInDataProvider && this._typicalItemRenderer !== null)
				{
					//it's safe to destroy this renderer
					this.destroyItemRenderer(this._typicalItemRenderer);
					this._typicalItemRenderer = null;
				}
				return;
			}
			var typicalItemLocation:Vector.<int> = null;
			var newTypicalItemIsInDataProvider:Boolean = false;
			var typicalItem:Object = this._typicalItem;
			if(typicalItem !== null)
			{
				if(this._dataProvider !== null)
				{
					typicalItemLocation = this._dataProvider.getItemLocation(typicalItem);
					newTypicalItemIsInDataProvider = typicalItemLocation !== null && typicalItemLocation.length > 0;
				}
			}
			else
			{
				if(this._dataProvider !== null && this._dataProvider.getLengthAtLocation() > 0)
				{
					newTypicalItemIsInDataProvider = true;
					typicalItem = this._dataProvider.getItemAt(0);
					typicalItemLocation = new <int>[0];
				}
			}

			//#1645 The typicalItem can be null if the data provider contains
			//a null value at index 0. this is the only time we allow null.
			if(typicalItem !== null || newTypicalItemIsInDataProvider)
			{
				var typicalItemRenderer:ITreeItemRenderer = this.itemToItemRenderer(typicalItem);
				if(typicalItemRenderer !== null)
				{
					//at this point, the item already has an item renderer.
					//(this doesn't necessarily mean that the current typical
					//item was the typical item last time this function was
					//called)

					//the location may have changed if items were added,
					//removed or reordered in the data provider
					typicalItemRenderer.location = typicalItemLocation;
				}
				if(typicalItemRenderer === null && this._typicalItemRenderer !== null)
				{
					//the typical item has changed, and doesn't have an item
					//renderer yet. the previous typical item had an item
					//renderer, so we will try to reuse it.

					//we can reuse the existing typical item renderer if the old
					//typical item wasn't in the data provider. otherwise, it
					//may still be needed for the same item.
					var canReuse:Boolean = !this._typicalItemIsInDataProvider;
					var oldTypicalItemRemoved:Boolean = this._typicalItemIsInDataProvider &&
						this._dataProvider !== null && this._dataProvider.getItemLocation(this._typicalItemRenderer.data) === null;
					if(!canReuse && oldTypicalItemRemoved)
					{
						//special case: if the old typical item was in the data
						//provider, but it has been removed, it's safe to reuse.
						canReuse = true;
					}
					if(canReuse)
					{
						//we can't reuse if the factoryID has changed, though!
						var factoryID:String = null;
						if(this._factoryIDFunction !== null)
						{
							factoryID = this.getFactoryID(typicalItem, typicalItemLocation);
						}
						if(this._typicalItemRenderer.factoryID !== factoryID)
						{
							canReuse = false;
						}
					}
					if(canReuse)
					{
						//we can reuse the item renderer used for the old
						//typical item!

						//if the old typical item was in the data provider,
						//remove it from the renderer map.
						if(this._typicalItemIsInDataProvider)
						{
							var oldData:Object = this._typicalItemRenderer.data;
							if(oldData is XML || oldData is XMLList)
							{
								delete this._itemRendererMap[oldData.toXMLString()];
							}
							else
							{
								delete this._itemRendererMap[oldData];
							}
						}
						typicalItemRenderer = this._typicalItemRenderer;
						typicalItemRenderer.data = typicalItem;
						typicalItemRenderer.location = typicalItemLocation;
						//if the new typical item is in the data provider, add it
						//to the renderer map.
						if(newTypicalItemIsInDataProvider)
						{
							if(typicalItem is XML || typicalItem is XMLList)
							{
								this._itemRendererMap[typicalItem.toXMLString()] = typicalItemRenderer;
							}
							else
							{
								this._itemRendererMap[typicalItem] = typicalItemRenderer;
							}
						}
					}
				}
				if(typicalItemRenderer === null)
				{
					//if we still don't have a typical item renderer, we need to
					//create a new one.
					typicalItemRenderer = this.createItemRenderer(typicalItem, typicalItemLocation, 0, false, !newTypicalItemIsInDataProvider);
					if(!this._typicalItemIsInDataProvider && this._typicalItemRenderer !== null)
					{
						//get rid of the old typical item renderer if it isn't
						//needed anymore.  since it was not in the data
						//provider, we don't need to mess with the renderer map
						//dictionary or dispatch any events.
						this.destroyItemRenderer(this._typicalItemRenderer);
						this._typicalItemRenderer = null;
					}
				}
			}

			virtualLayout.typicalItem = DisplayObject(typicalItemRenderer);
			this._typicalItemRenderer = typicalItemRenderer;
			this._typicalItemIsInDataProvider = newTypicalItemIsInDataProvider;
			if(this._typicalItemRenderer !== null && !this._typicalItemIsInDataProvider)
			{
				//we need to know if this item renderer resizes to adjust the
				//layout because the layout may use this item renderer to resize
				//the other item renderers
				this._typicalItemRenderer.addEventListener(FeathersEventType.RESIZE, itemRenderer_resizeHandler);
			}
		}

		private function refreshItemRenderers():void
		{
			if(this._typicalItemRenderer !== null && this._typicalItemIsInDataProvider)
			{
				var storage:ItemRendererFactoryStorage = this.factoryIDToStorage(this._typicalItemRenderer.factoryID);
				var inactiveItemRenderers:Vector.<ITreeItemRenderer> = storage.inactiveItemRenderers;
				var activeItemRenderers:Vector.<ITreeItemRenderer> = storage.activeItemRenderers;
				//this renderer is already is use by the typical item, so we
				//don't want to allow it to be used by other items.
				var inactiveIndex:int = inactiveItemRenderers.indexOf(this._typicalItemRenderer);
				if(inactiveIndex >= 0)
				{
					inactiveItemRenderers[inactiveIndex] = null;
				}
				//if refreshLayoutTypicalItem() was called, it will have already
				//added the typical item renderer to the active renderers. if
				//not, we need to do it here.
				var activeRendererCount:int = activeItemRenderers.length;
				if(activeRendererCount == 0)
				{
					activeItemRenderers[activeRendererCount] = this._typicalItemRenderer;
				}
			}

			this.findUnrenderedData();
			this.recoverInactiveItemRenderers(this._defaultItemRendererStorage);
			if(this._itemStorageMap)
			{
				for(var factoryID:String in this._itemStorageMap)
				{
					storage = ItemRendererFactoryStorage(this._itemStorageMap[factoryID]);
					this.recoverInactiveItemRenderers(storage);
				}
			}
			this.renderUnrenderedData();
			this.freeInactiveItemRenderers(this._defaultItemRendererStorage, this._minimumItemCount);
			if(this._itemStorageMap)
			{
				for(factoryID in this._itemStorageMap)
				{
					storage = ItemRendererFactoryStorage(this._itemStorageMap[factoryID]);
					this.freeInactiveItemRenderers(storage, 1);
				}
			}
			this._updateForDataReset = false;
		}

		private function findTotalLayoutCount(location:Vector.<int>):int
		{
			var itemCount:int = 0;
			if(this._dataProvider !== null)
			{
				itemCount = this._dataProvider.getLengthAtLocation(location);
			}
			var result:int = itemCount;
			for(var i:int = 0; i < itemCount; i++)
			{
				location[location.length] = i;
				var item:Object = this._dataProvider.getItemAtLocation(location);
				if(this._dataProvider.isBranch(item) &&
					this._openBranches.contains(item))
				{
					result += this.findTotalLayoutCount(location);
				}
				location.length--;
			}
			return result;
		}

		private function findUnrenderedDataForLocation(location:Vector.<int>, currentIndex:int):int
		{
			var virtualLayout:IVirtualLayout = this._layout as IVirtualLayout;
			var useVirtualLayout:Boolean = virtualLayout !== null && virtualLayout.useVirtualLayout;
			var itemCount:int = 0;
			if(this._dataProvider !== null)
			{
				itemCount = this._dataProvider.getLengthAtLocation(location);
			}
			for(var i:int = 0; i < itemCount; i++)
			{
				location[location.length] = i;
				var item:Object = this._dataProvider.getItemAtLocation(location);

				if(useVirtualLayout && HELPER_VECTOR.indexOf(currentIndex) == -1)
				{
					if(this._typicalItemRenderer !== null &&
						this._typicalItemIsInDataProvider &&
						this._typicalItemRenderer.data === item)
					{
						//the index may have changed if items were added, removed,
						//or reordered in the data provider
						this._typicalItemRenderer.layoutIndex = currentIndex;
					}
					this._layoutItems[currentIndex] = null;
				}
				else
				{
					this.findRendererForItem(item, location.slice(), currentIndex);
				}
				currentIndex++;

				if(this._dataProvider.isBranch(item) &&
					this._openBranches.contains(item))
				{
					currentIndex = this.findUnrenderedDataForLocation(location, currentIndex);
				}
				location.length--;
			}
			return currentIndex;
		}

		private function findUnrenderedData():void
		{
			LOCATION_HELPER_VECTOR.length = 0;
			var totalLayoutCount:int = this.findTotalLayoutCount(LOCATION_HELPER_VECTOR);
			LOCATION_HELPER_VECTOR.length = 0;
			this._layoutItems.length = totalLayoutCount;
			var virtualLayout:IVirtualLayout = this._layout as IVirtualLayout;
			var useVirtualLayout:Boolean = virtualLayout !== null && virtualLayout.useVirtualLayout;
			if(useVirtualLayout)
			{
				var point:Point = Pool.getPoint();
				virtualLayout.measureViewPort(totalLayoutCount, this._viewPortBounds, point);
				var viewPortWidth:Number = point.x;
				var viewPortHeight:Number = point.y;
				Pool.putPoint(point);
				virtualLayout.getVisibleIndicesAtScrollPosition(this._horizontalScrollPosition, this._verticalScrollPosition, viewPortWidth, viewPortHeight, totalLayoutCount, HELPER_VECTOR);

				if(this._typicalItemRenderer !== null)
				{
					var minimumTypicalItemEdge:Number = this._typicalItemRenderer.height;
					if(this._typicalItemRenderer.width < minimumTypicalItemEdge)
					{
						minimumTypicalItemEdge = this._typicalItemRenderer.width;
					}

					var maximumViewPortEdge:Number = viewPortWidth;
					if(viewPortHeight > viewPortWidth)
					{
						maximumViewPortEdge = viewPortHeight;
					}

					this._minimumItemCount = Math.ceil(maximumViewPortEdge / minimumTypicalItemEdge) + 1;
				}
				else
				{
					this._minimumItemCount = 1;
				}
			}
			LOCATION_HELPER_VECTOR.length = 0;
			this.findUnrenderedDataForLocation(LOCATION_HELPER_VECTOR, 0);
			LOCATION_HELPER_VECTOR.length = 0;
			//update the typical item renderer's visibility
			if(this._typicalItemRenderer !== null)
			{
				if(useVirtualLayout && this._typicalItemIsInDataProvider)
				{
					var index:int = HELPER_VECTOR.indexOf(this._typicalItemRenderer.layoutIndex);
					if(index >= 0)
					{
						this._typicalItemRenderer.visible = true;
					}
					else
					{
						this._typicalItemRenderer.visible = false;

						//uncomment these lines to see a hidden typical item for
						//debugging purposes...
						/*this._typicalItemRenderer.visible = true;
						this._typicalItemRenderer.x = this._horizontalScrollPosition;
						this._typicalItemRenderer.y = this._verticalScrollPosition;*/
					}
				}
				else
				{
					this._typicalItemRenderer.visible = this._typicalItemIsInDataProvider;
				}
			}
			HELPER_VECTOR.length = 0;
		}

		private function findRendererForItem(item:Object, location:Vector.<int>, layoutIndex:int):void
		{
			var itemRenderer:ITreeItemRenderer = this.itemToItemRenderer(item);
			if(this._factoryIDFunction !== null && itemRenderer !== null)
			{
				var newFactoryID:String = this.getFactoryID(itemRenderer.data, location);
				if(newFactoryID !== itemRenderer.factoryID)
				{
					itemRenderer = null;
					if(item is XML || item is XMLList)
					{
						delete this._itemRendererMap[item.toXMLString()];
					}
					else
					{
						delete this._itemRendererMap[item];
					}
				}
			}
			if(itemRenderer !== null)
			{
				//the indices may have changed if items were added, removed,
				//or reordered in the data provider
				itemRenderer.location = location;
				itemRenderer.layoutIndex = layoutIndex;
				itemRenderer.isOpen = this._dataProvider.isBranch(item) && this._openBranches.contains(item);
				if(this._updateForDataReset)
				{
					//similar to calling updateItemAt(), replacing the data
					//provider or resetting its source means that we should
					//trick the item renderer into thinking it has new data.
					//many developers seem to expect this behavior, so while
					//it's not the most optimal for performance, it saves on
					//support time in the forums. thankfully, it's still
					//somewhat optimized since the same item renderer will
					//receive the same data, and the children generally
					//won't have changed much, if at all.
					itemRenderer.data = null;
					itemRenderer.data = item;
				}

				//the typical item renderer is a special case, and we will
				//have already put it into the active renderers, so we don't
				//want to do it again!
				if(this._typicalItemRenderer !== itemRenderer)
				{
					var storage:ItemRendererFactoryStorage = this.factoryIDToStorage(itemRenderer.factoryID);
					var activeItemRenderers:Vector.<ITreeItemRenderer> = storage.activeItemRenderers;
					var inactiveItemRenderers:Vector.<ITreeItemRenderer> = storage.inactiveItemRenderers;
					activeItemRenderers[activeItemRenderers.length] = itemRenderer;
					var inactiveIndex:int = inactiveItemRenderers.indexOf(itemRenderer);
					if(inactiveIndex >= 0)
					{
						inactiveItemRenderers.removeAt(inactiveIndex);
					}
					else
					{
						throw new IllegalOperationError("TreeDataViewPort: item renderer map contains bad data. This may be caused by duplicate items in the data provider, which is not allowed.");
					}
				}
				itemRenderer.visible = true;
				this._layoutItems[layoutIndex] = DisplayObject(itemRenderer);
			}
			else
			{
				var pushIndex:int = this._unrenderedItems.length;
				this._unrenderedItems[pushIndex] = location;
				pushIndex++;
				this._unrenderedItems[pushIndex] = layoutIndex;
			}
		}

		private function renderUnrenderedData():void
		{
			LOCATION_HELPER_VECTOR.length = 2;
			var rendererCount:int = this._unrenderedItems.length;
			for(var i:int = 0; i < rendererCount; i += 2)
			{
				var location:Vector.<int> = this._unrenderedItems.shift();
				var layoutIndex:int = this._unrenderedItems.shift();
				var item:Object = this._dataProvider.getItemAtLocation(location);
				var itemRenderer:ITreeItemRenderer = this.createItemRenderer(
					item, location, layoutIndex, true, false);
				itemRenderer.visible = true;
				this._layoutItems[layoutIndex] = DisplayObject(itemRenderer);
			}
			LOCATION_HELPER_VECTOR.length = 0;
		}

		private function refreshInactiveItemRenderers(factoryID:String, itemRendererTypeIsInvalid:Boolean):void
		{
			if(factoryID !== null)
			{
				var storage:ItemRendererFactoryStorage = ItemRendererFactoryStorage(this._itemStorageMap[factoryID]);
			}
			else
			{
				storage = this._defaultItemRendererStorage;
			}
			var temp:Vector.<ITreeItemRenderer> = storage.inactiveItemRenderers;
			storage.inactiveItemRenderers = storage.activeItemRenderers;
			storage.activeItemRenderers = temp;
			if(storage.activeItemRenderers.length > 0)
			{
				throw new IllegalOperationError("TreeDataViewPort: active renderers should be empty.");
			}
			if(itemRendererTypeIsInvalid)
			{
				this.recoverInactiveItemRenderers(storage);
				this.freeInactiveItemRenderers(storage, 0);
				if(this._typicalItemRenderer && this._typicalItemRenderer.factoryID === factoryID)
				{
					if(this._typicalItemIsInDataProvider)
					{
						var item:Object = this._typicalItemRenderer.data;
						if(item is XML || item is XMLList)
						{
							delete this._itemRendererMap[item.toXMLString()];
						}
						else
						{
							delete this._itemRendererMap[item];
						}
					}
					this.destroyItemRenderer(this._typicalItemRenderer);
					this._typicalItemRenderer = null;
					this._typicalItemIsInDataProvider = false;
				}
			}

			this._layoutItems.length = 0;
		}

		private function recoverInactiveItemRenderers(storage:ItemRendererFactoryStorage):void
		{
			var inactiveItemRenderers:Vector.<ITreeItemRenderer> = storage.inactiveItemRenderers;

			var itemCount:int = inactiveItemRenderers.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var itemRenderer:ITreeItemRenderer = inactiveItemRenderers[i];
				if(itemRenderer === null || itemRenderer.data === null)
				{
					continue;
				}
				this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE, false, itemRenderer);
				var item:Object = itemRenderer.data;
				if(item is XML || item is XMLList)
				{
					delete this._itemRendererMap[item.toXMLString()];
				}
				else
				{
					delete this._itemRendererMap[item];
				}
			}
		}

		private function freeInactiveItemRenderers(storage:ItemRendererFactoryStorage, minimumItemCount:int):void
		{
			var inactiveItemRenderers:Vector.<ITreeItemRenderer> = storage.inactiveItemRenderers;
			var activeItemRenderers:Vector.<ITreeItemRenderer> = storage.activeItemRenderers;
			var activeItemRenderersCount:int = activeItemRenderers.length;

			//we may keep around some extra renderers to avoid too much
			//allocation and garbage collection. they'll be hidden.
			var itemCount:int = inactiveItemRenderers.length;
			var keepCount:int = minimumItemCount - activeItemRenderersCount;
			if(keepCount > itemCount)
			{
				keepCount = itemCount;
			}
			for(var i:int = 0; i < keepCount; i++)
			{
				var itemRenderer:ITreeItemRenderer = inactiveItemRenderers.shift();
				if(!itemRenderer)
				{
					keepCount++;
					if(itemCount < keepCount)
					{
						keepCount = itemCount;
					}
					continue;
				}
				itemRenderer.data = null;
				itemRenderer.location = null;
				itemRenderer.visible = false;
				activeItemRenderers[activeItemRenderersCount] = itemRenderer;
				activeItemRenderersCount++;
			}
			itemCount -= keepCount;
			for(i = 0; i < itemCount; i++)
			{
				itemRenderer = inactiveItemRenderers.shift();
				if(!itemRenderer)
				{
					continue;
				}
				this.destroyItemRenderer(itemRenderer);
			}
		}

		private function createItemRenderer(item:Object, location:Vector.<int>, layoutIndex:int, useCache:Boolean, isTemporary:Boolean):ITreeItemRenderer
		{
			var factoryID:String = null;
			if(this._factoryIDFunction !== null)
			{
				factoryID = this.getFactoryID(item, location);
			}
			var itemRendererFactory:Function = this.factoryIDToFactory(factoryID);
			var storage:ItemRendererFactoryStorage = this.factoryIDToStorage(factoryID);
			var inactiveItemRenderers:Vector.<ITreeItemRenderer> = storage.inactiveItemRenderers;
			var activeItemRenderers:Vector.<ITreeItemRenderer> = storage.activeItemRenderers;
			var itemRenderer:ITreeItemRenderer;
			do
			{
				if(!useCache || isTemporary || inactiveItemRenderers.length == 0)
				{
					if(itemRendererFactory !== null)
					{
						itemRenderer = ITreeItemRenderer(itemRendererFactory());
					}
					else
					{
						itemRenderer = ITreeItemRenderer(new this._itemRendererType());
					}
					if(this._customItemRendererStyleName && this._customItemRendererStyleName.length > 0)
					{
						itemRenderer.styleNameList.add(this._customItemRendererStyleName);
					}
					this.addChild(DisplayObject(itemRenderer));
				}
				else
				{
					itemRenderer = inactiveItemRenderers.shift();
				}
				//wondering why this all is in a loop?
				//_inactiveRenderers.shift() may return null because we're
				//storing null values instead of calling splice() to improve
				//performance.
			}
			while(!itemRenderer);
			itemRenderer.data = item;
			itemRenderer.owner = this._owner;
			itemRenderer.factoryID = factoryID;
			itemRenderer.location = location;
			itemRenderer.layoutIndex = layoutIndex;
			var isBranch:Boolean = this._dataProvider !== null && this._dataProvider.isBranch(item);
			itemRenderer.isBranch = isBranch;
			itemRenderer.isOpen = isBranch && this._openBranches.contains(item);

			if(!isTemporary)
			{
				if(item is XML || item is XMLList)
				{
					this._itemRendererMap[item.toXMLString()] = itemRenderer;
				}
				else
				{
					this._itemRendererMap[item] = itemRenderer;
				}
				activeItemRenderers[activeItemRenderers.length] = itemRenderer;
				itemRenderer.addEventListener(Event.TRIGGERED, itemRenderer_triggeredHandler);
				itemRenderer.addEventListener(Event.CHANGE, itemRenderer_changeHandler);
				itemRenderer.addEventListener(FeathersEventType.RESIZE, itemRenderer_resizeHandler);
				this._owner.dispatchEventWith(FeathersEventType.RENDERER_ADD, false, itemRenderer);
			}

			return itemRenderer;
		}

		private function destroyItemRenderer(itemRenderer:ITreeItemRenderer):void
		{
			itemRenderer.removeEventListener(Event.TRIGGERED, itemRenderer_triggeredHandler);
			itemRenderer.removeEventListener(Event.CHANGE, itemRenderer_changeHandler);
			itemRenderer.removeEventListener(FeathersEventType.RESIZE, itemRenderer_resizeHandler);
			itemRenderer.owner = null;
			itemRenderer.data = null;
			itemRenderer.location = null;
			itemRenderer.layoutIndex = -1;
			itemRenderer.factoryID = null;
			this.removeChild(DisplayObject(itemRenderer), true);
		}

		private function getFactoryID(item:Object, location:Vector.<int>):String
		{
			if(this._factoryIDFunction === null)
			{
				return null;
			}
			if(this._factoryIDFunction.length == 2)
			{
				return this._factoryIDFunction(item, location);
			}
			return this._factoryIDFunction(item);
		}

		private function factoryIDToFactory(id:String):Function
		{
			if(id !== null)
			{
				if(id in this._itemRendererFactories)
				{
					return this._itemRendererFactories[id] as Function;
				}
				else
				{
					throw new ReferenceError("Cannot find item renderer factory for ID \"" + id + "\".");
				}
			}
			return this._itemRendererFactory;
		}

		private function factoryIDToStorage(id:String):ItemRendererFactoryStorage
		{
			if(id !== null)
			{
				if(id in this._itemStorageMap)
				{
					return ItemRendererFactoryStorage(this._itemStorageMap[id]);
				}
				var storage:ItemRendererFactoryStorage = new ItemRendererFactoryStorage();
				this._itemStorageMap[id] = storage;
				return storage;
			}
			return this._defaultItemRendererStorage;
		}

		private function invalidateParent(flag:String = INVALIDATION_FLAG_ALL):void
		{
			Scroller(this.parent).invalidate(flag);
		}

		private function refreshSelection():void
		{
			for each(var item:DisplayObject in this._layoutItems)
			{
				var itemRenderer:ITreeItemRenderer = item as ITreeItemRenderer;
				if(itemRenderer !== null)
				{
					itemRenderer.isSelected = itemRenderer.data === this._selectedItem;
				}
			}
		}

		private function refreshEnabled():void
		{
			for each(var item:DisplayObject in this._layoutItems)
			{
				var control:IFeathersControl = item as IFeathersControl;
				if(control !== null)
				{
					control.isEnabled = this._isEnabled;
				}
			}
		}

		private function validateRenderers():void
		{
			var itemCount:int = this._layoutItems.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:IValidating = this._layoutItems[i] as IValidating;
				if(item !== null)
				{
					item.validate();
				}
			}
		}

		private function layout_changeHandler(event:Event):void
		{
			if(this._ignoreLayoutChanges)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
			this.invalidateParent(INVALIDATION_FLAG_LAYOUT);
		}

		private function dataProvider_changeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		private function itemRenderer_triggeredHandler(event:Event):void
		{
			var itemRenderer:ITreeItemRenderer = ITreeItemRenderer(event.currentTarget);
			this.parent.dispatchEventWith(Event.TRIGGERED, false, itemRenderer.data);
		}

		private function itemRenderer_changeHandler(event:Event):void
		{
			if(this._ignoreSelectionChanges)
			{
				return;
			}
			var itemRenderer:ITreeItemRenderer = ITreeItemRenderer(event.currentTarget);
			if(!this._isSelectable || this._owner.isScrolling)
			{
				itemRenderer.isSelected = false;
				return;
			}
			var isSelected:Boolean = itemRenderer.isSelected;
			if(isSelected)
			{
				this.selectedItem = itemRenderer.data;
			}
			else
			{
				this.selectedItem = null;
			}
		}

		private function itemRenderer_resizeHandler(event:Event):void
		{
			if(this._ignoreRendererResizing)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
			this.invalidateParent(INVALIDATION_FLAG_LAYOUT);
			if(event.currentTarget === this._typicalItemRenderer && !this._typicalItemIsInDataProvider)
			{
				return;
			}
			var layout:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
			if(!layout || !layout.hasVariableItemDimensions)
			{
				return;
			}
			var itemRenderer:ITreeItemRenderer = ITreeItemRenderer(event.currentTarget);
			layout.resetVariableVirtualCacheAtIndex(itemRenderer.layoutIndex, DisplayObject(itemRenderer));
		}

		private function openBranches_changeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
	}
}

import feathers.controls.renderers.ITreeItemRenderer;

class ItemRendererFactoryStorage
{
	public function ItemRendererFactoryStorage()
	{

	}

	public var activeItemRenderers:Vector.<ITreeItemRenderer> = new <ITreeItemRenderer>[];
	public var inactiveItemRenderers:Vector.<ITreeItemRenderer> = new <ITreeItemRenderer>[];
}