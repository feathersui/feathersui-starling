package feathers.examples.youtube.screens
{
	import feathers.controls.Label;
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

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import starling.events.Event;
	import starling.textures.Texture;

	[Event(name="listVideos",type="starling.events.Event")]

	public class MainMenuScreen extends PanelScreen
	{
		public static const LIST_VIDEOS:String = "listVideos";

		private static const CATEGORIES_URL:String = "http://gdata.youtube.com/schemas/2007/categories.cat";
		private static const FEED_URL_BEFORE:String = "http://gdata.youtube.com/feeds/api/standardfeeds/US/most_popular_";
		private static const FEED_URL_AFTER:String = "?v=2";

		public function MainMenuScreen()
		{
			this.addEventListener(starling.events.Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		private var _list:List;

		private var _loader:URLLoader;
		private var _message:Label;

		public var savedVerticalScrollPosition:Number = 0;
		public var savedSelectedIndex:int = -1;
		public var savedDataProvider:ListCollection;

		public function get selectedCategory():VideoFeed
		{
			if(!this._list)
			{
				return null;
			}
			return this._list.selectedItem as VideoFeed;
		}

		override protected function initialize():void
		{
			super.initialize();

			this.title = "YouTube Feeds";

			this.layout = new AnchorLayout();

			this._list = new List();
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
			//when navigating to video results, we save this information to
			//restore the list when later navigating back to this screen.
			if(this.savedDataProvider)
			{
				this._list.dataProvider = this.savedDataProvider;
				this._list.selectedIndex = this.savedSelectedIndex;
				this._list.verticalScrollPosition = this.savedVerticalScrollPosition;
			}
			this.addChild(this._list);

			this._message = new Label();
			this._message.text = "Loading...";
			this._message.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
			//hide the loading message if we're using restored results
			this._message.visible = this.savedDataProvider === null;
			this.addChild(this._message);

			this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionInCompleteHandler);
		}

		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);

			//only load the list of videos if don't have restored results
			if(!this.savedDataProvider && dataInvalid)
			{
				this._list.dataProvider = null;
				this._message.visible = true;
				if(this._loader)
				{
					this.cleanUpLoader();
				}
				this._loader = new URLLoader();
				this._loader.addEventListener(flash.events.Event.COMPLETE, loader_completeHandler);
				this._loader.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
				this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_errorHandler);
				this._loader.load(new URLRequest(CATEGORIES_URL));
			}

			//never forget to call super.draw()!
			super.draw();
		}

		private function cleanUpLoader():void
		{
			if(!this._loader)
			{
				return;
			}
			this._loader.removeEventListener(flash.events.Event.COMPLETE, loader_completeHandler);
			this._loader.removeEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_errorHandler);
			this._loader = null;
		}

		private function parseFeed(feed:XML):void
		{
			this._message.visible = false;

			var atom:Namespace = feed.namespace("atom");
			var yt:Namespace = feed.namespace("yt");
			var deprecatedElement:QName = new QName(yt, "deprecated");
			var browsableElement:QName = new QName(yt, "browsable");

			var items:Vector.<VideoFeed> = new <VideoFeed>[];
			var categories:XMLList = feed.atom::category;
			var categoryCount:int = categories.length();
			for(var i:int = 0; i < categoryCount; i++)
			{
				var category:XML = categories[i];
				var item:VideoFeed = new VideoFeed();
				if(category.elements(deprecatedElement).length() > 0)
				{
					continue;
				}
				var browsable:XMLList = category.elements(browsableElement);
				if(browsable.length() < 0)
				{
					continue;
				}
				var regions:String = browsable[0].@regions.toString();
				if(regions.toString().indexOf("US") < 0)
				{
					continue;
				}
				item.name = category.@label[0].toString();
				var term:String = category.@term[0].toString();
				item.url = FEED_URL_BEFORE + encodeURI(term) + FEED_URL_AFTER;
				items.push(item);
			}
			var collection:ListCollection = new ListCollection(items);
			this._list.dataProvider = collection;

			//show the scroll bars so that the user knows they can scroll
			this._list.revealScrollBars();
		}

		private function accessorySourceFunction(item:Object):Texture
		{
			return StandardIcons.listDrillDownAccessoryTexture;
		}

		private function removedFromStageHandler(event:starling.events.Event):void
		{
			this.cleanUpLoader();
		}

		private function transitionInCompleteHandler(event:starling.events.Event):void
		{
			this._list.selectedIndex = -1;
			this._list.addEventListener(starling.events.Event.CHANGE, list_changeHandler);

			this._list.revealScrollBars();
		}

		private function list_changeHandler(event:starling.events.Event):void
		{
			this.dispatchEventWith(LIST_VIDEOS, false,
			{
				//we're going to save the position of the list so that when the user
				//navigates back to this screen, they won't need to scroll back to
				//the same position manually
				savedVerticalScrollPosition: this._list.verticalScrollPosition,
				//we'll also save the selected index to temporarily highlight
				//the previously selected item when transitioning back
				savedSelectedIndex: this._list.selectedIndex,
				//and we'll save the data provider so that we don't need to reload
				//data when we return to this screen. we can restore it.
				savedDataProvider: this._list.dataProvider
			});
		}

		private function loader_completeHandler(event:flash.events.Event):void
		{
			try
			{
				var loaderData:* = this._loader.data;
				this.parseFeed(new XML(loaderData));
			}
			catch(error:Error)
			{
				this._message.text = "Unable to load data. Please try again later.";
				this._message.visible = true;
				this.invalidate(INVALIDATION_FLAG_STYLES);
				trace(error.toString());
			}
			this.cleanUpLoader();
		}

		private function loader_errorHandler(event:ErrorEvent):void
		{
			this.cleanUpLoader();
			this._message.text = "Unable to load data. Please try again later.";
			this._message.visible = true;
			this.invalidate(INVALIDATION_FLAG_STYLES);
			trace(event.toString());
		}
	}
}
