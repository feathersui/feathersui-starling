/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.color
{
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.skins.IStyleProvider;

	/**
	 * The default item renderer used by <code>ColorSwatchList</code>.
	 * 
	 * @see feathers.controls.color.ColorSwatchList
	 */
	public class ColorSwatchItemRenderer extends ColorSwatchButton implements IListItemRenderer
	{
		/**
		 * The default <code>IStyleProvider</code> for all <code>ColorSwatchItemRenderer</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function ColorSwatchItemRenderer()
		{
			super();
			this.isFocusEnabled = false;
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return ColorSwatchItemRenderer.globalStyleProvider;
		}

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
			this._index = value;
		}

		/**
		 * @private
		 */
		protected var _owner:List;

		/**
		 * @inheritDoc
		 */
		public function get owner():List
		{
			return this._owner;
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
			this._owner = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _data:ColorSwatchData;

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
			this._data = ColorSwatchData(value);
			if(this._data !== null)
			{
				this.color = this._data.color;
			}
			else
			{
				this.color = 0;
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _factoryID:String;

		/**
		 * @inheritDoc
		 */
		public function get factoryID():String
		{
			return this._factoryID;
		}

		/**
		 * @private
		 */
		public function set factoryID(value:String):void
		{
			this._factoryID = value;
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
		override protected function refreshSelectionEvents():void
		{
			this.tapToSelect.isEnabled = this._isEnabled;
			this.tapToSelect.tapToDeselect = this._isToggle;
			this.keyToSelect.isEnabled = false;
		}
	}
}
