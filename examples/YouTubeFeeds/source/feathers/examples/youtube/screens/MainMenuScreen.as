package feathers.examples.youtube.screens
{
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;
	import feathers.examples.youtube.models.VideoFeed;
	import feathers.skins.StandardIcons;

	import starling.events.Event;
	import starling.textures.Texture;

	[Event(name="listVideos",type="starling.events.Event")]

	public class MainMenuScreen extends Screen
	{
		public static const LIST_VIDEOS:String = "listVideos";

		public function MainMenuScreen()
		{
		}

		private var _header:Header;
		private var _list:List;

		override protected function initialize():void
		{
			this._list = new List();
			this._list.dataProvider = new ListCollection(
			[
				new VideoFeed("Top Rated", "http://gdata.youtube.com/feeds/api/standardfeeds/top_rated?fields=entry[link/@rel='http://gdata.youtube.com/schemas/2007%23mobile']"),
				new VideoFeed("Top Favorites", "http://gdata.youtube.com/feeds/api/standardfeeds/top_favorites?fields=entry[link/@rel='http://gdata.youtube.com/schemas/2007%23mobile']"),
				new VideoFeed("Most Shared", "http://gdata.youtube.com/feeds/api/standardfeeds/most_shared?fields=entry[link/@rel='http://gdata.youtube.com/schemas/2007%23mobile']"),
				new VideoFeed("Most Popular", "http://gdata.youtube.com/feeds/api/standardfeeds/most_popular?fields=entry[link/@rel='http://gdata.youtube.com/schemas/2007%23mobile']"),
				new VideoFeed("Most Recent", "http://gdata.youtube.com/feeds/api/standardfeeds/most_recent?fields=entry[link/@rel='http://gdata.youtube.com/schemas/2007%23mobile']"),
				new VideoFeed("Most Discussed", "http://gdata.youtube.com/feeds/api/standardfeeds/most_discussed?fields=entry[link/@rel='http://gdata.youtube.com/schemas/2007%23mobile']"),
				new VideoFeed("Most Responded", "http://gdata.youtube.com/feeds/api/standardfeeds/most_responded?fields=entry[link/@rel='http://gdata.youtube.com/schemas/2007%23mobile']"),
				new VideoFeed("Recently Featured", "http://gdata.youtube.com/feeds/api/standardfeeds/recently_featured?fields=entry[link/@rel='http://gdata.youtube.com/schemas/2007%23mobile']"),
				new VideoFeed("Trending Videos", "http://gdata.youtube.com/feeds/api/standardfeeds/on_the_web?fields=entry[link/@rel='http://gdata.youtube.com/schemas/2007%23mobile']"),
			]);
			this._list.itemRendererProperties.labelField = "name";
			this._list.itemRendererProperties.accessorySourceFunction = accessorySourceFunction;
			this._list.addEventListener(Event.CHANGE, list_changeHandler);
			this.addChild(this._list);

			this._header = new Header();
			this._header.title = "YouTube Feeds";
			this.addChild(this._header);
		}

		override protected function draw():void
		{
			this._header.width = this.actualWidth;
			this._header.validate();

			this._list.y = this._header.height;
			this._list.width = this.actualWidth;
			this._list.height = this.actualHeight - this._list.y;
		}

		private function accessorySourceFunction(item:Object):Texture
		{
			return StandardIcons.listDrillDownAccessoryTexture;
		}

		private function list_changeHandler(event:Event):void
		{
			this.dispatchEventWith(LIST_VIDEOS, false, VideoFeed(this._list.selectedItem));
		}
	}
}
