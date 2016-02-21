package feathers.examples.tileList
{
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.PageIndicator;
	import feathers.controls.ScrollBarDisplayMode;
	import feathers.controls.ScrollPolicy;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.Direction;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.RelativePosition;
	import feathers.layout.TiledRowsLayout;
	import feathers.layout.VerticalAlign;
	import feathers.skins.AddOnFunctionStyleProvider;
	import feathers.themes.MinimalMobileTheme;

	import starling.events.Event;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;

	public class Main extends LayoutGroup
	{
		public function Main()
		{
			new MinimalMobileTheme();
			super();
		}

		private var _assetManager:AssetManager;
		private var _list:List;
		private var _pageIndicator:PageIndicator;

		override public function dispose():void
		{
			//don't forget to clean up textures and things!
			if(this._assetManager)
			{
				this._assetManager.dispose();
				this._assetManager = null;
			}
			super.dispose();
		}

		override protected function initialize():void
		{
			//don't forget to call super.initialize()
			super.initialize();
			
			//a nice, fluid layout
			this.layout = new AnchorLayout();

			//the page indicator can be used to scroll the list
			this._pageIndicator = new PageIndicator();
			this._pageIndicator.direction = Direction.HORIZONTAL;
			this._pageIndicator.pageCount = 1;

			//we listen to the change event to update the list's scroll position
			this._pageIndicator.addEventListener(Event.CHANGE, pageIndicator_changeHandler);

			//we'll position the page indicator on the bottom and stretch its
			//width to fill the container's width
			var pageIndicatorLayoutData:AnchorLayoutData = new AnchorLayoutData();
			pageIndicatorLayoutData.bottom = 0;
			pageIndicatorLayoutData.left = 0;
			pageIndicatorLayoutData.right = 0;
			this._pageIndicator.layoutData = pageIndicatorLayoutData;

			this.addChild(this._pageIndicator);

			this._list = new List();
			this._list.itemRendererFactory = tileListItemRendererFactory;
			this._list.styleProvider = new AddOnFunctionStyleProvider(
				this._list.styleProvider, setListStyles);

			//we listen to the scroll event to update the page indicator
			this._list.addEventListener(Event.SCROLL, list_scrollHandler);

			//the list fills the container's width and the remaining height
			//above the page indicator
			var listLayoutData:AnchorLayoutData = new AnchorLayoutData();
			listLayoutData.top = 0;
			listLayoutData.right = 0;
			listLayoutData.bottom = 0;
			listLayoutData.bottomAnchorDisplayObject = this._pageIndicator;
			listLayoutData.left = 0;
			this._list.layoutData = listLayoutData;

			this.addChild(this._list);
			
			this.loadIcons();
		}
		
		protected function loadIcons():void
		{
			this._assetManager = new AssetManager(2);
			this._assetManager.enqueue("images/atlas@2x.png");
			this._assetManager.enqueue("images/atlas@2x.xml");
			this._assetManager.loadQueue(assetManager_onProgress);
		}
		
		protected function tileListItemRendererFactory():IListItemRenderer
		{
			var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			renderer.labelField = "label";
			renderer.iconSourceField = "texture";
			renderer.styleProvider = new AddOnFunctionStyleProvider(
				renderer.styleProvider, setItemRendererStyles);
			return renderer;
		}
		
		protected function setListStyles(list:List):void
		{
			//we could put this into a theme subclass, but we're using an
			//AddOnFunctionStyleProvider for convenience
			list.snapToPages = true;
			list.scrollBarDisplayMode = ScrollBarDisplayMode.NONE;
			list.horizontalScrollPolicy = ScrollPolicy.ON;
			list.verticalScrollPolicy = ScrollPolicy.OFF;

			var listLayout:TiledRowsLayout = new TiledRowsLayout();
			listLayout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			listLayout.useSquareTiles = false;
			listLayout.tileHorizontalAlign = HorizontalAlign.JUSTIFY;
			listLayout.tileVerticalAlign = HorizontalAlign.JUSTIFY;
			listLayout.horizontalAlign = HorizontalAlign.CENTER;
			listLayout.verticalAlign = VerticalAlign.TOP;
			list.layout = listLayout;
		}

		protected function setItemRendererStyles(itemRenderer:DefaultListItemRenderer):void
		{
			//similar to above, we're setting styles with an
			//AddOnFunctionStyleProvider for convenience
			
			itemRenderer.iconPosition = RelativePosition.TOP;
			
			itemRenderer.horizontalAlign = HorizontalAlign.CENTER;
			itemRenderer.verticalAlign = VerticalAlign.BOTTOM;
			
			itemRenderer.maxWidth = 80;
		}

		protected function list_scrollHandler(event:Event):void
		{
			this._pageIndicator.pageCount = this._list.horizontalPageCount;
			this._pageIndicator.selectedIndex = this._list.horizontalPageIndex;
		}

		protected function pageIndicator_changeHandler(event:Event):void
		{
			this._list.scrollToPageIndex(this._pageIndicator.selectedIndex, 0, this._list.pageThrowDuration);
		}
		
		protected function assetManager_onProgress(ratio:Number):void
		{
			if(ratio < 1)
			{
				return;
			}

			//get the texture atlas from the asset manager
			var atlas:TextureAtlas = this._assetManager.getTextureAtlas("atlas@2x");
			
			//populate the list using the textures
			this._list.dataProvider = new ListCollection(
			[
				{ label: "Behance", texture: atlas.getTexture("behance") },
				{ label: "Blogger", texture: atlas.getTexture("blogger") },
				{ label: "Delicious", texture: atlas.getTexture("delicious") },
				{ label: "DeviantArt", texture: atlas.getTexture("deviantart") },
				{ label: "Digg", texture: atlas.getTexture("digg") },
				{ label: "Dribbble", texture: atlas.getTexture("dribbble") },
				{ label: "Facebook", texture: atlas.getTexture("facebook") },
				{ label: "Flickr", texture: atlas.getTexture("flickr") },
				{ label: "Github", texture: atlas.getTexture("github") },
				{ label: "Google", texture: atlas.getTexture("google") },
				{ label: "Instagram", texture: atlas.getTexture("instagram") },
				{ label: "LinkedIn", texture: atlas.getTexture("linkedin") },
				{ label: "Pinterest", texture: atlas.getTexture("pinterest") },
				{ label: "Snapchat", texture: atlas.getTexture("snapchat") },
				{ label: "SoundCloud", texture: atlas.getTexture("soundcloud") },
				{ label: "StackOverflow", texture: atlas.getTexture("stackoverflow") },
				{ label: "StumbleUpon", texture: atlas.getTexture("stumbleupon") },
				{ label: "Tumblr", texture: atlas.getTexture("tumblr") },
				{ label: "Twitter", texture: atlas.getTexture("twitter") },
				{ label: "Vimeo", texture: atlas.getTexture("vimeo") },
				{ label: "Vine", texture: atlas.getTexture("vine") },
				{ label: "WordPress", texture: atlas.getTexture("wordpress") },
				{ label: "Yahoo!", texture: atlas.getTexture("yahoo") },
				{ label: "Yelp", texture: atlas.getTexture("yelp") },
				{ label: "YouTube", texture: atlas.getTexture("youtube") },
			]);
		}
	}
}
