/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.renderers
{
	import feathers.controls.DataGrid;
	import feathers.controls.DataGridColumn;
	import feathers.events.FeathersEventType;
	import feathers.skins.IStyleProvider;

	/**
	 * The default cell renderer for the <code>DataGrid</code> component.
	 * Supports up to three optional sub-views, including a label to display
	 * text, an icon to display an image, and an "accessory" to display a UI
	 * component or another display object (with shortcuts for including a
	 * second image or a second label).
	 * 
	 * @see feathers.controls.DataGrid
	 *
	 * @productversion Feathers 3.4.0
	 */
	public class DefaultDataGridCellRenderer extends BaseDefaultItemRenderer implements IDataGridCellRenderer
	{
		/**
		 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#ALTERNATE_STYLE_NAME_CHECK
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const ALTERNATE_STYLE_NAME_CHECK:String = "feathers-check-item-renderer";

		/**
		 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#DEFAULT_CHILD_STYLE_NAME_LABEL
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_LABEL:String = "feathers-item-renderer-label";

		/**
		 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#DEFAULT_CHILD_STYLE_NAME_ICON_LABEL
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_ICON_LABEL:String = "feathers-item-renderer-icon-label";

		/**
		 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL:String = "feathers-item-renderer-accessory-label";
		/**
		 * The default <code>IStyleProvider</code> for all <code>DefaultListItemRenderer</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function DefaultDataGridCellRenderer()
		{
			super();
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return DefaultDataGridCellRenderer.globalStyleProvider;
		}
		
		/**
		 * @private
		 */
		protected var _rowIndex:int = -1;
		
		/**
		 * @inheritDoc
		 */
		public function get rowIndex():int
		{
			return this._rowIndex;
		}
		
		/**
		 * @private
		 */
		public function set rowIndex(value:int):void
		{
			if(this._rowIndex == value)
			{
				return;
			}
			this._rowIndex = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _columnIndex:int = -1;

		/**
		 * @inheritDoc
		 */
		public function get columnIndex():int
		{
			return this._columnIndex;
		}

		/**
		 * @private
		 */
		public function set columnIndex(value:int):void
		{
			if(this._columnIndex == value)
			{
				return;
			}
			this._columnIndex = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		/**
		 * @private
		 */
		protected var _dataField:String = null;
		
		/**
		 * @inheritDoc
		 */
		public function get dataField():String
		{
			return this._dataField;
		}
		
		/**
		 * @private
		 */
		public function set dataField(value:String):void
		{
			if(this._dataField === value)
			{
				return;
			}
			this._dataField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _column:DataGridColumn = null;
		
		/**
		 * @inheritDoc
		 */
		public function get column():DataGridColumn
		{
			return this._column;
		}
		
		/**
		 * @private
		 */
		public function set column(value:DataGridColumn):void
		{
			if(this._column === value)
			{
				return;
			}
			this._column = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get owner():DataGrid
		{
			return DataGrid(this._owner);
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
			if(this._owner)
			{
				this._owner.removeEventListener(FeathersEventType.SCROLL_START, owner_scrollStartHandler);
				this._owner.removeEventListener(FeathersEventType.SCROLL_COMPLETE, owner_scrollCompleteHandler);
			}
			this._owner = value;
			if(this._owner)
			{
				var grid:DataGrid = DataGrid(this._owner);
				this.isSelectableWithoutToggle = grid.isSelectable;
				if(grid.allowMultipleSelection)
				{
					//toggling is forced in this case
					this.isToggle = true;
				}
				this._owner.addEventListener(FeathersEventType.SCROLL_START, owner_scrollStartHandler);
				this._owner.addEventListener(FeathersEventType.SCROLL_COMPLETE, owner_scrollCompleteHandler);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
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
			//every cell in a row should be affected by touches anywhere
			//in the row, so use the parent as the target
			this.touchToState.target = this.parent;
		}

		/**
		 * @private
		 */
		override protected function getDataToRender():Object
		{
			if(this._data === null || this._dataField === null)
			{
				return this._data;
			}
			return this._data[this._dataField];
		}
	}
}