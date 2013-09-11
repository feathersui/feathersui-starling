package feathers.examples.youtube.screens
{
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.examples.youtube.models.VideoFeed;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.skins.StandardIcons;

	import starling.events.Event;
	import starling.textures.Texture;

	[Event(name="listVideos",type="starling.events.Event")]

	public class MainMenuScreen extends PanelScreen
	{
		public static const LIST_VIDEOS:String = "listVideos";

		public function MainMenuScreen()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		private var _list:List;

		protected function initializeHandler(event:Event):void
		{
			this.layout = new AnchorLayout();

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
			this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this._list.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();

				//enable the quick hit area to optimize hit tests when an item
				//is only selectable and doesn't have interactive children.
				renderer.isQuickHitAreaEnabled = true;

				renderer.labelField = "name";
				renderer.accessorySourceFunction = accessorySourceFunction;
				return renderer;
			}
			this._list.addEventListener(Event.CHANGE, list_changeHandler);
			this.addChild(this._list);

			this.headerProperties.title = "YouTube Feeds";
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
