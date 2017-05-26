package feathers.examples.gallery
{
	import feathers.controls.DecelerationRate;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.ScrollBarDisplayMode;
	import feathers.controls.ScrollPolicy;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.VectorCollection;
	import feathers.events.FeathersEventType;
	import feathers.examples.gallery.controls.GalleryItemRenderer;
	import feathers.examples.gallery.controls.ThumbItemRenderer;
	import feathers.examples.gallery.data.GalleryItem;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.SlideShowLayout;
	import feathers.layout.VerticalAlign;
	import feathers.themes.MetalWorksMobileTheme;
	import feathers.utils.textures.TextureCache;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;

	public class Main extends LayoutGroup
	{
		private static const FLICKR_URL:String = "https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=" + CONFIG::FLICKR_API_KEY + "&format=rest";
		private static const FLICKR_PHOTO_URL:String = "https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_{size}.jpg";

		public function Main()
		{
			//set up the theme right away!
			//this is an *extended* version of MetalWorksMobileTheme
			new MetalWorksMobileTheme();
			super();
		}

		protected var fullSizeList:List;
		protected var thumbnailList:List;
		protected var message:Label;
		protected var apiLoader:URLLoader;
		protected var thumbnailTextureCache:TextureCache;

		override public function dispose():void
		{
			if(this.thumbnailTextureCache)
			{
				this.thumbnailTextureCache.dispose();
				this.thumbnailTextureCache = null;
			}
			super.dispose();
		}

		override protected function initialize():void
		{
			//don't forget to call super.initialize() when you override it!
			super.initialize();

			this.layout = new AnchorLayout();

			//keep some thumbnails in memory so that they don't need to be
			//reloaded from the web
			this.thumbnailTextureCache = new TextureCache(30);

			this.apiLoader = new URLLoader();
			this.apiLoader.addEventListener(flash.events.Event.COMPLETE, apiLoader_completeListener);
			this.apiLoader.addEventListener(IOErrorEvent.IO_ERROR, apiLoader_errorListener);
			this.apiLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, apiLoader_errorListener);
			this.apiLoader.load(new URLRequest(FLICKR_URL));

			//the thumbnail list is positioned on the bottom edge of the app
			//and fills the entire width
			var thumbnailListLayoutData:AnchorLayoutData = new AnchorLayoutData();
			thumbnailListLayoutData.left = 0;
			thumbnailListLayoutData.right = 0;
			thumbnailListLayoutData.bottom = 0;

			var thumbnailListLayout:HorizontalLayout = new HorizontalLayout();
			thumbnailListLayout.verticalAlign = VerticalAlign.JUSTIFY;
			thumbnailListLayout.hasVariableItemDimensions = true;

			this.thumbnailList = new List();
			this.thumbnailList.layout = thumbnailListLayout;
			//make sure that we have elastic edges horizontally
			this.thumbnailList.horizontalScrollPolicy = ScrollPolicy.ON;
			//we're not displaying scroll bars
			this.thumbnailList.scrollBarDisplayMode = ScrollBarDisplayMode.NONE;
			//make a swipe scroll a shorter distance
			this.thumbnailList.decelerationRate = DecelerationRate.FAST;
			this.thumbnailList.itemRendererFactory = thumbnailItemRendererFactory;
			this.thumbnailList.addEventListener(starling.events.Event.CHANGE, thumbnailList_changeHandler);
			this.thumbnailList.height = 100;
			this.thumbnailList.layoutData = thumbnailListLayoutData;
			this.addChild(this.thumbnailList);

			//the full size list fills the remaining space above the thumbnails
			var fullSizeListLayoutData:AnchorLayoutData = new AnchorLayoutData(0, 0, 0, 0);
			fullSizeListLayoutData.bottomAnchorDisplayObject = this.thumbnailList;

			//show a single item per page
			var fullSizeListLayout:SlideShowLayout = new SlideShowLayout();
			fullSizeListLayout.horizontalAlign = HorizontalAlign.JUSTIFY;
			fullSizeListLayout.verticalAlign = VerticalAlign.JUSTIFY;
			//load the previous and next items so that they are already visible
			//if images use a lot of memory, this might not be possible for
			//some galleries!
			fullSizeListLayout.minimumItemCount = 3;

			this.fullSizeList = new List();
			//snap to the nearest page when scrolling
			this.fullSizeList.snapToPages = true;
			//there is nothing to select in this list
			this.fullSizeList.isSelectable = false;
			//no need to display scroll bars in this list
			this.fullSizeList.scrollBarDisplayMode = ScrollBarDisplayMode.NONE;
			//make sure that we have elastic edges horizontally
			this.fullSizeList.horizontalScrollPolicy = ScrollPolicy.ON;
			this.fullSizeList.layout = fullSizeListLayout;
			this.fullSizeList.layoutData = fullSizeListLayoutData;
			this.fullSizeList.itemRendererFactory = fullSizeItemRendererFactory;
			this.addChild(this.fullSizeList);

			//display at the center of the list of full size images
			var messageLayoutData:AnchorLayoutData = new AnchorLayoutData();
			messageLayoutData.horizontalCenter = 0;
			messageLayoutData.verticalCenter = 0;
			messageLayoutData.verticalCenterAnchorDisplayObject = this.fullSizeList;

			this.message = new Label();
			this.message.text = "Loading...";
			this.message.layoutData = messageLayoutData;
			this.addChild(this.message);
		}

		protected function fullSizeItemRendererFactory():IListItemRenderer
		{
			return new GalleryItemRenderer();
		}

		protected function thumbnailItemRendererFactory():IListItemRenderer
		{
			var itemRenderer:ThumbItemRenderer = new ThumbItemRenderer();
			//cache the textures so that they don't need to be reloaded from URLs
			itemRenderer.textureCache = this.thumbnailTextureCache;
			return itemRenderer;
		}

		protected function thumbnailList_changeHandler(event:starling.events.Event):void
		{
			var item:GalleryItem = GalleryItem(this.thumbnailList.selectedItem);
			if(!item)
			{
				return;
			}
			this.fullSizeList.scrollToDisplayIndex(this.thumbnailList.selectedIndex, 0.5);
		}

		protected function apiLoader_completeListener(event:flash.events.Event):void
		{
			var result:XML = XML(this.apiLoader.data);
			if(result.attribute("stat") == "fail")
			{
				message.text = "Unable to load the list of images from Flickr at this time.";
				return;
			}
			var items:Vector.<GalleryItem> = new <GalleryItem>[];
			var photosList:XMLList = result.photos.photo;
			var photoCount:int = photosList.length();
			for(var i:int = 0; i < photoCount; i++)
			{
				var photoXML:XML = photosList[i];
				var url:String = FLICKR_PHOTO_URL.replace("{farm-id}", photoXML.@farm.toString());
				url = url.replace("{server-id}", photoXML.@server.toString());
				url = url.replace("{id}", photoXML.@id.toString());
				url = url.replace("{secret}", photoXML.@secret.toString());
				var thumbURL:String = url.replace("{size}", "t");
				url = url.replace("{size}", "b");
				var title:String = photoXML.@title.toString();
				items.push(new GalleryItem(title, url, thumbURL));
			}

			this.message.text = "";

			var collection:VectorCollection = new VectorCollection(items);
			this.thumbnailList.dataProvider = collection;
			this.fullSizeList.dataProvider = collection;
		}

		protected function apiLoader_errorListener(event:flash.events.Event):void
		{
			this.message.text = "Error loading images.";
		}
	}
}
