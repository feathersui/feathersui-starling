package feathers.examples.gallery
{
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalAlign;

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

		protected var selectedImage:ImageLoader;
		protected var list:List;
		protected var message:Label;
		protected var apiLoader:URLLoader;
		protected var fadeTween:Tween;

		override protected function initialize():void
		{
			super.initialize();

			//this is an *extended* version of MetalWorksMobileTheme
			new GalleryTheme();

			this.autoSizeMode = LayoutGroup.AUTO_SIZE_MODE_STAGE;
			this.layout = new AnchorLayout();

			this.apiLoader = new URLLoader();
			this.apiLoader.addEventListener(flash.events.Event.COMPLETE, apiLoader_completeListener);
			this.apiLoader.addEventListener(IOErrorEvent.IO_ERROR, apiLoader_errorListener);
			this.apiLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, apiLoader_errorListener);
			this.apiLoader.load(new URLRequest(FLICKR_URL));

			var listLayout:HorizontalLayout = new HorizontalLayout();
			listLayout.verticalAlign = VerticalAlign.JUSTIFY;
			listLayout.hasVariableItemDimensions = true;
			
			var listLayoutData:AnchorLayoutData = new AnchorLayoutData();
			listLayoutData.left = 0;
			listLayoutData.right = 0;
			listLayoutData.bottom = 0;
			
			this.list = new List();
			this.list.styleNameList.add(THUMBNAIL_LIST_NAME);
			this.list.layout = listLayout;
			this.list.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
			this.list.snapScrollPositionsToPixels = true;
			this.list.itemRendererType = GalleryItemRenderer;
			this.list.addEventListener(starling.events.Event.CHANGE, list_changeHandler);
			this.list.height = 100;
			this.list.layoutData = listLayoutData;
			this.addChild(this.list);
			
			var imageLayoutData:AnchorLayoutData = new AnchorLayoutData(0, 0, 0, 0);
			imageLayoutData.bottomAnchorDisplayObject = this.list;
			
			this.selectedImage = new ImageLoader();
			this.selectedImage.layoutData = imageLayoutData;
			this.selectedImage.addEventListener(starling.events.Event.COMPLETE, loader_completeHandler);
			this.selectedImage.addEventListener(FeathersEventType.ERROR, loader_errorHandler);
			this.addChild(this.selectedImage);
			
			var messageLayoutData:AnchorLayoutData = new AnchorLayoutData();
			messageLayoutData.horizontalCenter = 0;
			messageLayoutData.verticalCenter = 0;
			messageLayoutData.verticalCenterAnchorDisplayObject = this.selectedImage;
			
			this.message = new Label();
			this.message.text = "Loading...";
			this.message.layoutData = messageLayoutData;
			this.addChild(this.message);
		}

		protected function list_changeHandler(event:starling.events.Event):void
		{
			this.selectedImage.visible = false;
			if(this.fadeTween)
			{
				Starling.juggler.remove(this.fadeTween);
				this.fadeTween = null;
			}
			var item:GalleryItem = GalleryItem(this.list.selectedItem);
			if(!item)
			{
				return;
			}
			this.selectedImage.source = item.url;
			this.message.text = "Loading...";
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

			this.list.dataProvider = new ListCollection(items);
			this.list.selectedIndex = 0;
		}

		protected function apiLoader_errorListener(event:flash.events.Event):void
		{
			this.message.text = "Error loading images.";
		}

		protected function loader_completeHandler(event:starling.events.Event):void
		{
			this.selectedImage.alpha = 0;
			this.selectedImage.visible = true;

			this.fadeTween = new Tween(this.selectedImage, 0.5, Transitions.EASE_OUT);
			this.fadeTween.fadeTo(1);
			Starling.juggler.add(this.fadeTween);

			this.message.text = "";
		}

		protected function loader_errorHandler(event:flash.events.Event):void
		{
			this.message.text = "Error loading image.";
		}
	}
}
