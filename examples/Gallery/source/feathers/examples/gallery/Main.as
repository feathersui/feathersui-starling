package feathers.examples.gallery
{
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.ScrollBarDisplayMode;
	import feathers.controls.ScrollPolicy;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.VectorCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.SlideShowLayout;
	import feathers.layout.VerticalAlign;
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
		//used by the extended theme
		public static const THUMBNAIL_LIST_NAME:String = "thumbnailList";

		private static const FLICKR_URL:String = "https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=" + CONFIG::FLICKR_API_KEY + "&format=rest";
		private static const FLICKR_PHOTO_URL:String = "https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_{size}.jpg";

		public function Main()
		{
			//set up the theme right away!
			//this is an *extended* version of MetalWorksMobileTheme
			new GalleryTheme();
			super();
		}

		protected var fullSizeList:List;
		protected var thumbnailList:List;
		protected var message:Label;
		protected var apiLoader:URLLoader;
		protected var fadeTween:Tween;
		protected var textureCache:TextureCache;

		override public function dispose():void
		{
			if(this.textureCache)
			{
				this.textureCache.dispose();
				this.textureCache = null;
			}
			super.dispose();
		}

		override protected function initialize():void
		{
			super.initialize();

			//this is an *extended* version of MetalWorksMobileTheme
			new GalleryTheme();

			this.layout = new AnchorLayout();

			this.textureCache = new TextureCache(30);

			this.apiLoader = new URLLoader();
			this.apiLoader.addEventListener(flash.events.Event.COMPLETE, apiLoader_completeListener);
			this.apiLoader.addEventListener(IOErrorEvent.IO_ERROR, apiLoader_errorListener);
			this.apiLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, apiLoader_errorListener);
			this.apiLoader.load(new URLRequest(FLICKR_URL));

			var thumbnailListLayout:HorizontalLayout = new HorizontalLayout();
			thumbnailListLayout.verticalAlign = VerticalAlign.JUSTIFY;
			thumbnailListLayout.hasVariableItemDimensions = true;

			var thumbnailListLayoutData:AnchorLayoutData = new AnchorLayoutData();
			thumbnailListLayoutData.left = 0;
			thumbnailListLayoutData.right = 0;
			thumbnailListLayoutData.bottom = 0;

			this.thumbnailList = new List();
			this.thumbnailList.styleNameList.add(THUMBNAIL_LIST_NAME);
			this.thumbnailList.layout = thumbnailListLayout;
			this.thumbnailList.horizontalScrollPolicy = ScrollPolicy.ON;
			this.thumbnailList.itemRendererFactory = thumbnailItemRendererFactory;
			this.thumbnailList.addEventListener(starling.events.Event.CHANGE, thumbnailList_changeHandler);
			this.thumbnailList.height = 100;
			this.thumbnailList.layoutData = thumbnailListLayoutData;
			this.addChild(this.thumbnailList);

			var fullSizeListLayoutData:AnchorLayoutData = new AnchorLayoutData(0, 0, 0, 0);
			fullSizeListLayoutData.bottomAnchorDisplayObject = this.thumbnailList;

			var fullSizeListLayout:SlideShowLayout = new SlideShowLayout();
			fullSizeListLayout.horizontalAlign = HorizontalAlign.JUSTIFY;
			fullSizeListLayout.verticalAlign = VerticalAlign.JUSTIFY;

			this.fullSizeList = new List();
			this.fullSizeList.snapToPages = true;
			this.fullSizeList.isSelectable = false;
			this.fullSizeList.scrollBarDisplayMode = ScrollBarDisplayMode.NONE;
			this.fullSizeList.layout = fullSizeListLayout;
			this.fullSizeList.horizontalScrollPolicy = ScrollPolicy.ON;
			this.fullSizeList.layoutData = fullSizeListLayoutData;
			this.fullSizeList.itemRendererFactory = fullSizeItemRendererFactory;
			this.addChild(this.fullSizeList);

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
			var itemRenderer:GalleryItemRenderer = new GalleryItemRenderer();
			itemRenderer.isThumb = false;
			return itemRenderer;
		}

		protected function thumbnailItemRendererFactory():IListItemRenderer
		{
			var itemRenderer:GalleryItemRenderer = new GalleryItemRenderer();
			itemRenderer.textureCache = this.textureCache;
			return itemRenderer;
		}

		protected function thumbnailList_changeHandler(event:starling.events.Event):void
		{
			if(this.fadeTween)
			{
				Starling.juggler.remove(this.fadeTween);
				this.fadeTween = null;
			}
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
