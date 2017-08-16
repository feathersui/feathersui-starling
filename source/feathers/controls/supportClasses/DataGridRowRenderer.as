/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses
{
	import feathers.controls.BasicButton;
	import feathers.controls.DataGrid;
	import feathers.controls.DataGridColumn;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.renderers.IDataGridCellRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.IToggle;
	import feathers.data.IListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.VerticalAlign;
	import feathers.layout.ViewPortBounds;
	import feathers.skins.IStyleProvider;
	import feathers.utils.touch.DelayedDownTouchToState;
	import feathers.utils.touch.TapToSelect;
	import feathers.utils.touch.TapToTrigger;

	import starling.display.DisplayObject;
	import starling.events.Event;

	/**
	 * @private
	 * Used internally by DataGrid. Not meant to be used on its own.
	 * 
	 * @see feathers.controls.DataGrid
	 *
	 * @productversion Feathers 3.4.0
	 */
	public class DataGridRowRenderer extends LayoutGroup implements IToggle
	{
		/**
		 * Constructor.
		 */
		public function DataGridRowRenderer()
		{
			super();
		}

		/**
		 * @private
		 */
		protected var _tapToTrigger:TapToTrigger = null;

		/**
		 * @private
		 */
		protected var _tapToSelect:TapToSelect = null;

		/**
		 * @private
		 */
		protected var _cellRenderers:Vector.<DisplayObject> = new <DisplayObject>[];

		/**
		 * @private
		 */
		protected var _factories:Vector.<Function> = new <Function>[];

		/**
		 * @private
		 */
		protected var _styleNames:Vector.<String> = new <String>[];

		/**
		 * @private
		 */
		protected var _index:int = -1;

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
			if(this._index === value)
			{
				return;
			}
			this._index = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _owner:DataGrid = null;

		/**
		 * @inheritDoc
		 */
		public function get owner():DataGrid
		{
			return this._owner;
		}

		/**
		 * @private
		 */
		public function set owner(value:DataGrid):void
		{
			if(this._owner === value)
			{
				return;
			}
			this._owner = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _data:Object = null;

		/**
		 * @inheritDoc
		 */
		public function get data():Object
		{
			return this._data;
		}

		/**
		 * @private
		 */
		public function set data(value:Object):void
		{
			if(this._data === value)
			{
				return;
			}
			this._data = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _isSelected:Boolean;

		/**
		 * @inheritDoc
		 */
		public function get isSelected():Boolean
		{
			return this._isSelected;
		}

		/**
		 * @private
		 */
		public function set isSelected(value:Boolean):void
		{
			if(this._isSelected === value)
			{
				return;
			}
			this._isSelected = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @inheritDoc
		 */
		public function getCellRendererForColumn(columnIndex:int):IDataGridCellRenderer
		{
			return null;
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this.owner = null;
			super.dispose();
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			super.initialize();

			if(this._layout === null)
			{
				var layout:HorizontalLayout = new HorizontalLayout();
				layout.verticalAlign = VerticalAlign.MIDDLE;
				layout.useVirtualLayout = false;
				this._layout = layout;
			}

			if(this._tapToTrigger === null)
			{
				this._tapToTrigger = new TapToTrigger(this);
			}

			if(this._tapToSelect === null)
			{
				this._tapToSelect = new TapToSelect(this);
			}
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var oldIgnoreChildChanges:Boolean = this._ignoreChildChanges;
			this._ignoreChildChanges = true;
			this.preLayout();
			this._ignoreChildChanges = oldIgnoreChildChanges;

			super.draw();
		}

		/**
		 * @private
		 */
		protected function preLayout():void
		{
			var columnCount:int = 0;
			if(this._owner !== null)
			{
				var columns:IListCollection = this._owner.columns;
				columnCount = columns.length;
			}
			var cellRendererCount:int = this._cellRenderers.length;
			if(cellRendererCount > columnCount)
			{
				for(var i:int = columnCount; i < cellRendererCount; i++)
				{
					var cellRenderer:IDataGridCellRenderer = IDataGridCellRenderer(this._cellRenderers[i]);
					this.removeChild(DisplayObject(cellRenderer), true);
				}
			}
			if(this._data === null || this._owner === null)
			{
				return;
			}
			this._cellRenderers.length = columnCount;
			this._factories.length = columnCount;
			this._styleNames.length = columnCount;
			for(i = 0; i < columnCount; i++)
			{
				var column:DataGridColumn = DataGridColumn(columns.getItemAt(i));
				cellRenderer = null;
				var oldFactory:Function = null;
				var oldStyleName:String = null;
				if(this._cellRenderers.length > i)
				{
					cellRenderer = IDataGridCellRenderer(this._cellRenderers[i]);
					oldFactory = this._factories[i];
					oldStyleName = this._styleNames[i];
				}
				if(cellRenderer !== null &&
					(column.cellRendererFactory !== oldFactory || column.customCellRendererStyleName !== oldStyleName))
				{
					this.removeChild(DisplayObject(cellRenderer), true);
					cellRenderer = null;
				}
				this._factories[i] = column.cellRendererFactory;
				this._styleNames[i] = column.customCellRendererStyleName;
				if(cellRenderer === null)
				{
					cellRenderer = IDataGridCellRenderer(column.cellRendererFactory());
					if(column.customCellRendererStyleName !== null)
					{
						cellRenderer.styleNameList.add(column.customCellRendererStyleName);
					}
					cellRenderer.owner = this._owner;
					this.addChild(DisplayObject(cellRenderer));
				}
				cellRenderer.data = this._data;
				cellRenderer.rowIndex = this._index;
				cellRenderer.columnIndex = i;
				cellRenderer.isSelected = this._isSelected;
				cellRenderer.dataField = column.dataField;
				cellRenderer.minWidth = column.minWidth;
				if(column.width === column.width) //!isNaN
				{
					cellRenderer.width = column.width;
					cellRenderer.layoutData = null;
				}
				else
				{
					var layoutData:HorizontalLayoutData = cellRenderer.layoutData as HorizontalLayoutData;
					if(layoutData === null)
					{
						cellRenderer.layoutData = new HorizontalLayoutData(100, NaN);
					}
					else
					{
						layoutData.percentWidth = 100;
						layoutData.percentHeight = NaN;
					}
				}
				this._cellRenderers[i] = cellRenderer;
			}
		}
	}
}
