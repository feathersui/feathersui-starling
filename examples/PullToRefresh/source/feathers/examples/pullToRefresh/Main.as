package feathers.examples.pullToRefresh
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.themes.MetalWorksMobileTheme;

	import flash.events.TimerEvent;

	import flash.utils.Timer;

	import starling.display.DisplayObject;

	import starling.display.Quad;

	import starling.events.Event;

	public class Main extends PanelScreen
	{
		public function Main()
		{
			new MetalWorksMobileTheme();
		}

		private var _list:List;
		private var _timer:Timer;
		private var _nextItemIndex:int = 1;

		override protected function initialize():void
		{
			super.initialize(); //don't forget this!

			this.title = "Pull to Refresh";
			this.headerFactory = function():Header
			{
				var button:Button = new Button();
				button.addEventListener(Event.TRIGGERED, function():void
				{
					_list.isTopPullViewActive = !_list.isTopPullViewActive;
				});
				button.label = "Click Me";
				var header:Header = new Header();
				header.rightItems = new <DisplayObject>
				[
					button
				];
				return header;
			};

			this.layout = new AnchorLayout();

			var pullView:Quad = new Quad(100, 60, 0xff00ff);

			this._list = new List();
			//pull views may appear on any of the four sides
			this._list.topPullView = pullView;
			//when the user pulls the topPullView down by its full height then
			//releases, the list will dispatch Event.UPDATE
			this._list.addEventListener(Event.UPDATE, list_updateHandler);
			this._list.dataProvider = new ListCollection();
			this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this.addChild(this._list);

			this.loadData();
		}

		private function loadData():void
		{
			if(this._timer)
			{
				//if we're already loading data, cancel it
				this._timer.stop();
				this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
				this._timer = null;
			}

			//if we aren't showing the pull view (such as the first time we load
			//the data), we can force it to display
			this._list.isTopPullViewActive = true;

			//we're not going to load real data for this example. we'll just
			//wait a couple of seconds and generate some new items dynamically.
			//using an AssetManager or URLLoader would look pretty similar.
			this._timer = new Timer(2000, 1);
			this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			this._timer.start();
		}

		private function timerCompleteHandler(event:TimerEvent):void
		{
			this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			this._timer = null;

			var collection:ListCollection = this._list.dataProvider;
			//we don't need to remove all of the old items. we could simply add
			//the new ones to the beginning instead.
			//if not removing all items, be aware that the new data might
			//contain duplicate items, depending on how it was loaded, so it's
			//a good idea to check if an item already exists in the collection
			//before adding it. 
			collection.removeAll();
			for(var i:int = 0; i < 25; i++)
			{
				var newItem:Object = { label: "Item " + this._nextItemIndex };
				collection.unshift(newItem);
				this._nextItemIndex++;
			}

			//when the data has finished loading, tell the list to deactivate
			//its pull view:
			this._list.isTopPullViewActive = false;
		}

		private function list_updateHandler(event:Event):void
		{
			this.loadData();
		}
	}
}
