package feathers.controls.autoComplete
{
	import feathers.data.ListCollection;

	import starling.events.Event;
	import starling.events.EventDispatcher;

	[Event(name="complete",type="starling.events.Event")]

	public class LocalAutoCompleteSource extends EventDispatcher implements IAutoCompleteSource
	{
		public function LocalAutoCompleteSource(source:Object = null)
		{
			if(source is ListCollection)
			{
				this._source = ListCollection(source);
			}
			else
			{
				this._source = new ListCollection(source);
			}
		}

		private var _source:ListCollection;

		public function load(text:String, result:ListCollection = null):void
		{
			if(result)
			{
				result.removeAll();
			}
			else
			{
				result = new ListCollection();
			}
			if(!this._source)
			{
				this.dispatchEventWith(Event.COMPLETE, false, result);
				return;
			}

			for(var i:int = 0; i < this._source.length; i++)
			{
				var item:Object = this._source.getItemAt(i);
				if(item.toString().toLowerCase().indexOf(text.toLowerCase()) >= 0)
				{
					result.push(item);
				}
			}
			this.dispatchEventWith(Event.COMPLETE, false, result);
		}
	}
}
