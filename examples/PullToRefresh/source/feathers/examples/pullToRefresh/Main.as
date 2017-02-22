package feathers.examples.pullToRefresh
{
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.data.ArrayCollection;
	import feathers.data.IListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.themes.MetalWorksMobileTheme;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Main extends PanelScreen
	{
		[Embed(source="/../assets/images/spinner.png")]
		private static const SPINNER_ATLAS_IMAGE_EMBEDDED:Class;

		[Embed(source="/../assets/images/spinner.xml",mimeType="application/octet-stream")]
		private static const SPINNER_ATLAS_XML_EMBEDDED:Class;

		public function Main()
		{
			new MetalWorksMobileTheme();
		}

		private var _list:List;
		private var _pullView:MovieClip;
		private var _timer:Timer;
		private var _nextItemIndex:int = 1;

		override protected function initialize():void
		{
			super.initialize(); //don't forget this!

			this.title = "Pull to Refresh";

			this.layout = new AnchorLayout();

			//any Starling display object may be used as a pull view.
			//we'll use an animated MovieClip in this example.
			var texture:Texture = Texture.fromEmbeddedAsset(SPINNER_ATLAS_IMAGE_EMBEDDED, false, false, 2);
			var atlas:TextureAtlas = new TextureAtlas(texture, XML(new SPINNER_ATLAS_XML_EMBEDDED()));
			this._pullView = new MovieClip(atlas.getTextures());

			//FeathersEventType.PULLING will be dispatched on the pull view as
			//it is pulled down so that we can change its appearance. 
			this._pullView.addEventListener(FeathersEventType.PULLING, pullView_pullingHandler);

			this._list = new List();

			//pull views may appear on any of the four sides.
			//we'll put one on the top.
			this._list.topPullView = this._pullView;

			//when the user pulls the topPullView down by its full height then
			//releases, the list will dispatch Event.UPDATE
			this._list.addEventListener(Event.UPDATE, list_updateHandler);

			this._list.dataProvider = new ArrayCollection();
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

			//start the pull view animation
			Starling.juggler.add(this._pullView);

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

			var collection:IListCollection = this._list.dataProvider;
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

			//and stop the pull view animation
			Starling.juggler.remove(this._pullView);
		}

		private function pullView_pullingHandler(event:Event, ratio:Number):void
		{
			var totalFrames:int = this._pullView.numFrames;

			//to provide some extra feedback to the user while they're pulling,
			//change the currentFrame of the MovieClip based on how far they've
			//pulled
			var frameIndex:int = Math.round(ratio * totalFrames);

			//the ratio could be greater than 1, which could result in a frame
			//index greater than the number of frames in the MovieClip
			while(frameIndex >= totalFrames)
			{
				frameIndex -= totalFrames;
			}
			this._pullView.currentFrame = frameIndex;
		}

		private function list_updateHandler(event:Event):void
		{
			//load the new data when the List dispatches Event.UPDATE
			this.loadData();
		}
	}
}
