package feathers.examples.tileList
{
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PageIndicator;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	import feathers.text.BitmapFontTextFormat;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Main extends Sprite
	{
		[Embed(source="/../assets/images/atlas.png")]
		private static const ICONS_IMAGE:Class;

		[Embed(source="/../assets/images/atlas.xml",mimeType="application/octet-stream")]
		private static const ICONS_XML:Class;

		[Embed(source="/../assets/images/arial20.fnt",mimeType="application/octet-stream")]
		private static const FONT_XML:Class;

		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		private var _iconAtlas:TextureAtlas;
		private var _font:BitmapFont;
		private var _list:List;
		private var _pageIndicator:PageIndicator;

		protected function layout():void
		{
			this._pageIndicator.width = this.stage.stageWidth;
			this._pageIndicator.validate();
			this._pageIndicator.y = this.stage.stageHeight - this._pageIndicator.height;

			const shorterSide:Number = Math.min(this.stage.stageWidth, this.stage.stageHeight);
			const layout:TiledRowsLayout = TiledRowsLayout(this._list.layout);
			layout.paddingTop = layout.paddingRight = layout.paddingBottom =
				layout.paddingLeft = shorterSide * 0.06;
			layout.gap = shorterSide * 0.04;

			this._list.itemRendererProperties.gap = shorterSide * 0.01;

			this._list.width = this.stage.stageWidth;
			this._list.height = this._pageIndicator.y;
			this._list.validate();

			this._pageIndicator.pageCount = this._list.horizontalPageCount;
		}

		protected function addedToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);

			this._iconAtlas = new TextureAtlas(Texture.fromBitmap(new ICONS_IMAGE(), false), XML(new ICONS_XML()));
			this._font = new BitmapFont(this._iconAtlas.getTexture("arial20_0"), XML(new FONT_XML()));

			const collection:ListCollection = new ListCollection(
			[
				{ label: "Facebook", texture: this._iconAtlas.getTexture("facebook") },
				{ label: "Twitter", texture: this._iconAtlas.getTexture("twitter") },
				{ label: "Google", texture: this._iconAtlas.getTexture("google") },
				{ label: "YouTube", texture: this._iconAtlas.getTexture("youtube") },
				{ label: "StumbleUpon", texture: this._iconAtlas.getTexture("stumbleupon") },
				{ label: "Yahoo", texture: this._iconAtlas.getTexture("yahoo") },
				{ label: "Tumblr", texture: this._iconAtlas.getTexture("tumblr") },
				{ label: "Blogger", texture: this._iconAtlas.getTexture("blogger") },
				{ label: "Reddit", texture: this._iconAtlas.getTexture("reddit") },
				{ label: "Flickr", texture: this._iconAtlas.getTexture("flickr") },
				{ label: "Yelp", texture: this._iconAtlas.getTexture("yelp") },
				{ label: "Vimeo", texture: this._iconAtlas.getTexture("vimeo") },
				{ label: "LinkedIn", texture: this._iconAtlas.getTexture("linkedin") },
				{ label: "Delicious", texture: this._iconAtlas.getTexture("delicious") },
				{ label: "FriendFeed", texture: this._iconAtlas.getTexture("friendfeed") },
				{ label: "MySpace", texture: this._iconAtlas.getTexture("myspace") },
				{ label: "Digg", texture: this._iconAtlas.getTexture("digg") },
				{ label: "DeviantArt", texture: this._iconAtlas.getTexture("deviantart") },
				{ label: "Picasa", texture: this._iconAtlas.getTexture("picasa") },
				{ label: "LiveJournal", texture: this._iconAtlas.getTexture("livejournal") },
				{ label: "Slashdot", texture: this._iconAtlas.getTexture("slashdot") },
				{ label: "Bebo", texture: this._iconAtlas.getTexture("bebo") },
				{ label: "Viddler", texture: this._iconAtlas.getTexture("viddler") },
				{ label: "Newsvine", texture: this._iconAtlas.getTexture("newsvine") },
				{ label: "Posterous", texture: this._iconAtlas.getTexture("posterous") },
				{ label: "Orkut", texture: this._iconAtlas.getTexture("orkut") },
			]);

			const listLayout:TiledRowsLayout = new TiledRowsLayout();
			listLayout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			listLayout.useSquareTiles = false;
			listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
			listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.manageVisibility = true;

			this._list = new List();
			this._list.dataProvider = collection;
			this._list.layout = listLayout;
			this._list.snapToPages = true;
			this._list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
			this._list.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
			this._list.itemRendererFactory = tileListItemRendererFactory;
			this._list.addEventListener(Event.SCROLL, list_scrollHandler);
			this.addChild(this._list);

			const normalSymbolTexture:Texture = this._iconAtlas.getTexture("normal-page-symbol");
			const selectedSymbolTexture:Texture = this._iconAtlas.getTexture("selected-page-symbol");
			this._pageIndicator = new PageIndicator();
			this._pageIndicator.normalSymbolFactory = function():Image
			{
				return new Image(normalSymbolTexture);
			}
			this._pageIndicator.selectedSymbolFactory = function():Image
			{
				return new Image(selectedSymbolTexture);
			}
			this._pageIndicator.direction = PageIndicator.DIRECTION_HORIZONTAL;
			this._pageIndicator.pageCount = 1;
			this._pageIndicator.gap = 3;
			this._pageIndicator.paddingTop = this._pageIndicator.paddingRight = this._pageIndicator.paddingBottom =
				this._pageIndicator.paddingLeft = 6;
			this._pageIndicator.addEventListener(Event.CHANGE, pageIndicator_changeHandler);
			this.addChild(this._pageIndicator);

			this.layout();
		}
		
		protected function tileListItemRendererFactory():IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			renderer.labelField = "label";
			renderer.iconSourceField = "texture";
			renderer.iconPosition = Button.ICON_POSITION_TOP;
			renderer.defaultLabelProperties.textFormat = new BitmapFontTextFormat(this._font, NaN, 0x000000);
			return renderer;
		}

		protected function list_scrollHandler(event:Event):void
		{
			this._pageIndicator.selectedIndex = this._list.horizontalPageIndex;
		}

		protected function pageIndicator_changeHandler(event:Event):void
		{
			this._list.scrollToPageIndex(this._pageIndicator.selectedIndex, 0, this._list.pageThrowDuration);
		}

		protected function stage_resizeHandler(event:ResizeEvent):void
		{
			this.layout();
		}
	}
}
