package feathers.examples.gallery
{
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	import starling.textures.Texture;

	public class Main extends Sprite
	{
		//used by the extended theme
		public static const THUMBNAIL_LIST_NAME:String = "thumbnailList";

		private static const LOADER_CONTEXT:LoaderContext = new LoaderContext(true);
		private static const FLICKR_URL:String = "http://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=" + CONFIG::FLICKR_API_KEY + "&format=rest";
		private static const FLICKR_PHOTO_URL:String = "http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_{size}.jpg";

		public function Main()
		{
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		protected var selectedImage:Image;
		protected var list:List;
		protected var message:Label;
		protected var apiLoader:URLLoader;
		protected var loader:Loader;
		protected var fadeTween:Tween;
		protected var originalImageWidth:Number;
		protected var originalImageHeight:Number;

		protected function layout():void
		{
			this.list.width = this.stage.stageWidth;
			this.list.height = 100;
			this.list.y = this.stage.stageHeight - this.list.height;

			if(this.selectedImage)
			{
				var availableHeight:Number = this.stage.stageHeight - this.list.height;
				var widthScale:Number = this.stage.stageWidth / this.originalImageWidth;
				var heightScale:Number = availableHeight / this.originalImageHeight;
				this.selectedImage.scaleX = this.selectedImage.scaleY = Math.min(1, widthScale, heightScale);
				this.selectedImage.x = (this.stage.stageWidth - this.selectedImage.width) / 2;
				this.selectedImage.y = (availableHeight - this.selectedImage.height) / 2;
			}

			this.message.validate();
			availableHeight = this.stage.stageHeight - this.list.height;
			this.message.x = (this.stage.stageWidth - this.message.width) / 2;
			this.message.y = (availableHeight - this.message.height) / 2;
		}

		protected function list_changeHandler(event:starling.events.Event):void
		{
			const item:GalleryItem = GalleryItem(this.list.selectedItem);
			if(!item)
			{
				if(this.selectedImage)
				{
					this.selectedImage.visible = false;
				}
				return;
			}
			if(this.loader)
			{
				this.loader.unloadAndStop(true);
			}
			else
			{
				this.loader = new Loader();
				this.loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, loader_completeHandler);
				this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
				this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_errorHandler);
			}
			this.loader.load(new URLRequest(item.url), LOADER_CONTEXT);
			if(this.selectedImage)
			{
				this.selectedImage.visible = false;
			}
			if(this.fadeTween)
			{
				Starling.juggler.remove(this.fadeTween);
				this.fadeTween = null;
			}
			this.message.text = "Loading...";
			this.layout();
		}

		protected function addedToStageHandler(event:starling.events.Event):void
		{
			//this is an *extended* version of MetalWorksMobileTheme
			new GalleryTheme();

			this.apiLoader = new URLLoader();
			this.apiLoader.addEventListener(flash.events.Event.COMPLETE, apiLoader_completeListener);
			this.apiLoader.addEventListener(IOErrorEvent.IO_ERROR, apiLoader_errorListener);
			this.apiLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, apiLoader_errorListener);
			this.apiLoader.load(new URLRequest(FLICKR_URL));

			this.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);

			const listLayout:HorizontalLayout = new HorizontalLayout();
			listLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_JUSTIFY;
			listLayout.hasVariableItemDimensions = true;
			listLayout.manageVisibility = true;

			this.list = new List();
			this.list.nameList.add(THUMBNAIL_LIST_NAME);
			this.list.layout = listLayout;
			this.list.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
			this.list.snapScrollPositionsToPixels = true;
			this.list.itemRendererType = GalleryItemRenderer;
			this.list.addEventListener(starling.events.Event.CHANGE, list_changeHandler);
			this.addChild(this.list);

			this.message = new Label();
			this.message.text = "Loading...";
			this.addChild(this.message);

			this.layout();
		}

		protected function stage_resizeHandler(event:ResizeEvent):void
		{
			this.layout();
		}

		protected function apiLoader_completeListener(event:flash.events.Event):void
		{
			const result:XML = XML(this.apiLoader.data);
			if(result.attribute("stat") == "fail")
			{
				message.text = "Unable to load the list of images from Flickr at this time.";
				this.layout();
				return;
			}
			const items:Vector.<GalleryItem> = new <GalleryItem>[];
			const photosList:XMLList = result.photos.photo;
			const photoCount:int = photosList.length();
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
			this.layout();
		}

		protected function loader_completeHandler(event:flash.events.Event):void
		{
			const texture:Texture = Texture.fromBitmap(Bitmap(this.loader.content));
			if(this.selectedImage)
			{
				this.selectedImage.texture.dispose();
				this.selectedImage.texture = texture;
				this.selectedImage.scaleX = this.selectedImage.scaleY = 1;
				this.selectedImage.readjustSize();
			}
			else
			{
				this.selectedImage = new Image(texture);
				this.addChildAt(this.selectedImage, 1);
			}
			this.originalImageWidth = this.selectedImage.width;
			this.originalImageHeight = this.selectedImage.height;
			this.selectedImage.alpha = 0;
			this.selectedImage.visible = true;

			this.fadeTween = new Tween(this.selectedImage, 0.5, Transitions.EASE_OUT);
			this.fadeTween.fadeTo(1);
			Starling.juggler.add(this.fadeTween);

			this.message.text = "";

			this.layout();
		}

		protected function loader_errorHandler(event:flash.events.Event):void
		{
			this.message.text = "Error loading image.";
			this.layout();
		}
	}
}
