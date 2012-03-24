package org.josht.starling.foxhole.controls
{
	public class SimpleItemRenderer extends Button implements IListItemRenderer
	{
		public function SimpleItemRenderer()
		{
			super();
		}
		
		private var _data:Object;
		
		public function get data():Object
		{
			return this._data;
		}
		
		public function set data(value:Object):void
		{
			if(this._data == value)
			{
				return;
			}
			this._data = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		private var _index:int;
		
		public function get index():int
		{
			return this._index;
		}
		
		public function set index(value:int):void
		{
			this._index = value;
		}
		
		private var _owner:List;
		
		public function get owner():List
		{
			return this._owner;
		}
		
		public function set owner(value:List):void
		{
			if(this._owner == value)
			{
				return;
			}
			this._owner = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(dataInvalid)
			{
				if(this._owner)
				{
					this._label = this._owner.itemToLabel(this._data);
				}
				else
				{
					this._label = "";
				}
			}
			super.draw();
		}
	}
}