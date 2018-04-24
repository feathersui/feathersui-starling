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
	import feathers.controls.LayoutGroup;
	import feathers.skins.IStyleProvider;

	import starling.display.DisplayObject;
	import starling.events.Event;

	/**
	 * The background to display behind all content when the item renderer
	 * is selected. The background skin is resized to fill the full width
	 * and height of the layout group.
	 *
	 * <p>In the following example, the group is given a selected background
	 * skin:</p>
	 *
	 * <listing version="3.0">
	 * group.backgroundSelectedSkin = new Image( texture );</listing>
	 *
	 * @default null
	 */
	[Style(name="backgroundSelectedSkin",type="starling.display.DisplayObject")]

	/**
	 * Based on <code>LayoutGroup</code>, this component is meant as a base
	 * class for creating a custom item renderer for a <code>DataGrid</code>
	 * component.
	 *
	 * <p>Sub-components may be created and added inside <code>initialize()</code>.
	 * This is a good place to add event listeners and to set the layout.</p>
	 *
	 * <p>The <code>data</code> property may be parsed inside <code>commitData()</code>.
	 * Use this function to change properties in your sub-components.</p>
	 *
	 * <p>Sub-components may be positioned manually, but a layout may be
	 * provided as well. An <code>AnchorLayout</code> is recommended for fluid
	 * layouts that can automatically adjust positions when the grid resizes.
	 * Create <code>AnchorLayoutData</code> objects to define the constraints.</p>
	 *
	 * @see feathers.controls.DataGrid
	 *
	 * @productversion Feathers 3.4.0
	 */
	public class LayoutGroupDataGridCellRenderer extends LayoutGroup implements IDataGridCellRenderer
	{
		/**
		 * The default <code>IStyleProvider</code> for all <code>LayoutGroupDataGridCellRenderer</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function LayoutGroupDataGridCellRenderer()
		{
			super();
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return LayoutGroupDataGridCellRenderer.globalStyleProvider;
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
			this._rowIndex = value;
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
			this._columnIndex = value;
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
			if(this._owner == value)
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

		[Bindable(event="dataChange")]
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
			if(this._data == value)
			{
				return;
			}
			this._data = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
			//LayoutGroup doesn't know about INVALIDATION_FLAG_DATA, so we need
			//set set another flag that it understands.
			this.invalidate(INVALIDATION_FLAG_SIZE);

			//developers expect to set up bindings with the item's properties,
			//so even though the data property doesn't change with user
			//interaction, it needs to be bindable.
			this.dispatchEventWith("dataChange");
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
		 * @private
		 */
		protected var _isSelected:Boolean;

		[Bindable(event="change")]
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
			if(this._isSelected == value)
			{
				return;
			}
			this._isSelected = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			//the state flag is needed for updating the background
			this.invalidate(INVALIDATION_FLAG_STATE);
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _backgroundSelectedSkin:DisplayObject;

		/**
		 * @private
		 */
		public function get backgroundSelectedSkin():DisplayObject
		{
			return this._backgroundSelectedSkin;
		}

		/**
		 * @private
		 */
		public function set backgroundSelectedSkin(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._backgroundSelectedSkin === value)
			{
				return;
			}
			if(this._backgroundSelectedSkin !== null &&
				this.currentBackgroundSkin === this._backgroundSelectedSkin)
			{
				this.removeCurrentBackgroundSkin(this._backgroundSelectedSkin);
				this.currentBackgroundSkin = null;
			}
			this._backgroundSelectedSkin = value;
			this.invalidate(INVALIDATION_FLAG_SKIN);
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
		override protected function draw():void
		{
			//children are allowed to change during draw() in a subclass up
			//until it calls super.draw().
			this._ignoreChildChangesButSetFlags = false;

			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var scrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);

			if(dataInvalid)
			{
				this.commitData();
			}

			if(scrollInvalid || sizeInvalid || layoutInvalid)
			{
				this._ignoreChildChanges = true;
				this.preLayout();
				this._ignoreChildChanges = false;
			}

			super.draw();

			if(scrollInvalid || sizeInvalid || layoutInvalid)
			{
				this._ignoreChildChanges = true;
				this.postLayout();
				this._ignoreChildChanges = false;
			}
		}

		/**
		 * Makes final changes to the layout before it updates the item
		 * renderer's children. If your layout requires changing the
		 * <code>layoutData</code> property on the item renderer's
		 * sub-components, override the <code>preLayout()</code> function to
		 * make those changes.
		 *
		 * <p>In subclasses, if you create properties that affect the layout,
		 * invalidate using <code>INVALIDATION_FLAG_LAYOUT</code> to trigger a
		 * call to the <code>preLayout()</code> function when the component
		 * validates.</p>
		 *
		 * <p>The final width and height of the item renderer are not yet known
		 * when this function is called. It is meant mainly for adjusting values
		 * used by fluid layouts, such as constraints or percentages. If you
		 * need io access the final width and height of the item renderer,
		 * override the <code>postLayout()</code> function instead.</p>
		 *
		 * @see #postLayout()
		 */
		protected function preLayout():void
		{

		}

		/**
		 * Called after the layout updates the item renderer's children. If any
		 * children are excluded from the layout, you can update them in the
		 * <code>postLayout()</code> function if you need to use the final width
		 * and height in any calculations.
		 *
		 * <p>In subclasses, if you create properties that affect the layout,
		 * invalidate using <code>INVALIDATION_FLAG_LAYOUT</code> to trigger a
		 * call to the <code>postLayout()</code> function when the component
		 * validates.</p>
		 *
		 * <p>To make changes to the layout before it updates the item
		 * renderer's children, override the <code>preLayout()</code> function
		 * instead.</p>
		 *
		 * @see #preLayout()
		 */
		protected function postLayout():void
		{

		}

		/**
		 * Updates the renderer to display the item's data. Override this
		 * function to pass data to sub-components and react to data changes.
		 *
		 * <p>Don't forget to handle the case where the data is <code>null</code>.</p>
		 */
		protected function commitData():void
		{

		}

		/**
		 * @private
		 */
		override protected function getCurrentBackgroundSkin():DisplayObject
		{
			if(!this._isEnabled && this._backgroundDisabledSkin !== null)
			{
				return this._backgroundDisabledSkin;
			}
			if(this._isSelected && this._backgroundSelectedSkin !== null)
			{
				return this._backgroundSelectedSkin;
			}
			return this._backgroundSkin;
		}

	}
}
