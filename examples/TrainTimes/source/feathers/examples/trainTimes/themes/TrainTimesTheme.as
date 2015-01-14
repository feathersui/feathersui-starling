package feathers.examples.trainTimes.themes
{
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.Header;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.ScrollContainer;
	import feathers.controls.SimpleScrollBar;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.ITextEditor;
	import feathers.core.ITextRenderer;
	import feathers.core.PopUpManager;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.examples.trainTimes.controls.StationListItemRenderer;
	import feathers.examples.trainTimes.screens.StationScreen;
	import feathers.examples.trainTimes.screens.TimesScreen;
	import feathers.layout.HorizontalLayout;
	import feathers.system.DeviceCapabilities;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	import feathers.themes.StyleNameFunctionTheme;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.ResizeEvent;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class TrainTimesTheme extends StyleNameFunctionTheme
	{
		[Embed(source="/../assets/images/traintimes.png")]
		protected static const ATLAS_IMAGE:Class;

		[Embed(source="/../assets/images/traintimes.xml",mimeType="application/octet-stream")]
		protected static const ATLAS_XML:Class;

		[Embed(source="/../assets/fonts/SourceSansPro-Regular.ttf",fontName="SourceSansPro",mimeType="application/x-font",embedAsCFF="false")]
		protected static const SOURCE_SANS_PRO_REGULAR:Class;

		[Embed(source="/../assets/fonts/SourceSansPro-Bold.ttf",fontName="SourceSansProBold",fontWeight="bold",mimeType="application/x-font",embedAsCFF="false")]
		protected static const SOURCE_SANS_PRO_BOLD:Class;

		[Embed(source="/../assets/fonts/SourceSansPro-BoldIt.ttf",fontName="SourceSansProBoldItalic",fontWeight="bold",fontStyle="italic",mimeType="application/x-font",embedAsCFF="false")]
		protected static const SOURCE_SANS_PRO_BOLD_ITALIC:Class;

		protected static const TIMES_LIST_ITEM_RENDERER_NAME:String = "traintimes-times-list-item-renderer";

		protected static const ORIGINAL_DPI_IPHONE_RETINA:int = 326;
		protected static const ORIGINAL_DPI_IPAD_RETINA:int = 264;

		protected static const HEADER_SCALE9_GRID:Rectangle = new Rectangle(0, 0, 4, 5);
		protected static const SCROLL_BAR_THUMB_REGION1:int = 5;
		protected static const SCROLL_BAR_THUMB_REGION2:int = 14;

		protected static const PRIMARY_TEXT_COLOR:uint = 0xe8caa4;
		protected static const DETAIL_TEXT_COLOR:uint = 0x64908a;

		protected static function textRendererFactory():ITextRenderer
		{
			var renderer:TextFieldTextRenderer = new TextFieldTextRenderer();
			renderer.embedFonts = true;
			return renderer;
		}

		protected static function textEditorFactory():ITextEditor
		{
			return new StageTextTextEditor();
		}

		protected static function popUpOverlayFactory():DisplayObject
		{
			var quad:Quad = new Quad(100, 100, 0x1a1a1a);
			quad.alpha = 0.85;
			return quad;
		}

		public function TrainTimesTheme()
		{
			super();
			this.initialize();
		}

		protected var scale:Number = 1;

		protected var primaryBackground:TiledImage;

		protected var defaultTextFormat:TextFormat;
		protected var selectedTextFormat:TextFormat;
		protected var headerTitleTextFormat:TextFormat;
		protected var stationListNameTextFormat:TextFormat;
		protected var stationListDetailTextFormat:TextFormat;

		protected var atlas:TextureAtlas;
		protected var atlasBitmapData:BitmapData;
		protected var mainBackgroundTexture:Texture;
		protected var headerBackgroundTextures:Scale9Textures;
		protected var stationListNormalIconTexture:Texture;
		protected var stationListFirstNormalIconTexture:Texture;
		protected var stationListLastNormalIconTexture:Texture;
		protected var stationListSelectedIconTexture:Texture;
		protected var stationListFirstSelectedIconTexture:Texture;
		protected var stationListLastSelectedIconTexture:Texture;
		protected var confirmIconTexture:Texture;
		protected var cancelIconTexture:Texture;
		protected var backIconTexture:Texture;
		protected var horizontalScrollBarThumbSkinTextures:Scale3Textures;
		protected var verticalScrollBarThumbSkinTextures:Scale3Textures;

		override public function dispose():void
		{
			if(this.primaryBackground)
			{
				Starling.current.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
				Starling.current.stage.removeChild(this.primaryBackground, true);
				this.primaryBackground = null;
			}
			if(this.atlas)
			{
				this.atlas.dispose();
				this.atlas = null;
			}
			if(this.atlasBitmapData)
			{
				this.atlasBitmapData.dispose();
				this.atlasBitmapData = null;
			}
			super.dispose();
		}

		protected function initialize():void
		{
			this.initializeScale();
			this.initializeGlobals();
			this.initializeTextures();
			this.initializeStage();
			this.initializeStyleProviders();
		}

		protected function initializeStage():void
		{
			this.primaryBackground = new TiledImage(this.mainBackgroundTexture);
			this.primaryBackground.width = Starling.current.stage.stageWidth;
			this.primaryBackground.height = Starling.current.stage.stageHeight;
			Starling.current.stage.addChildAt(this.primaryBackground, 0);
			Starling.current.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
		}

		protected function initializeScale():void
		{
			var scaledDPI:int = DeviceCapabilities.dpi / Starling.contentScaleFactor;
			if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				var originalDPI:int = ORIGINAL_DPI_IPAD_RETINA;
			}
			else
			{
				originalDPI = ORIGINAL_DPI_IPHONE_RETINA;
			}

			this.scale = scaledDPI / originalDPI;
		}

		protected function initializeGlobals():void
		{
			FeathersControl.defaultTextRendererFactory = textRendererFactory;
			FeathersControl.defaultTextEditorFactory = textEditorFactory;

			PopUpManager.overlayFactory = popUpOverlayFactory;
			Callout.stagePaddingTop = Callout.stagePaddingRight = Callout.stagePaddingBottom =
				Callout.stagePaddingLeft = 16 * this.scale;
		}

		protected function initializeTextures():void
		{
			var atlasBitmapData:BitmapData = (new ATLAS_IMAGE()).bitmapData;
			this.atlas = new TextureAtlas(Texture.fromBitmapData(atlasBitmapData, false), XML(new ATLAS_XML()));
			if(Starling.handleLostContext)
			{
				this.atlasBitmapData = atlasBitmapData;
			}
			else
			{
				atlasBitmapData.dispose();
			}

			this.mainBackgroundTexture = this.atlas.getTexture("main-background");
			this.headerBackgroundTextures = new Scale9Textures(this.atlas.getTexture("header-background"), HEADER_SCALE9_GRID);
			this.stationListNormalIconTexture = this.atlas.getTexture("station-list-normal-icon");
			this.stationListFirstNormalIconTexture = this.atlas.getTexture("station-list-first-normal-icon");
			this.stationListLastNormalIconTexture = this.atlas.getTexture("station-list-last-normal-icon");
			this.stationListSelectedIconTexture = this.atlas.getTexture("station-list-selected-icon");
			this.stationListFirstSelectedIconTexture = this.atlas.getTexture("station-list-first-selected-icon");
			this.stationListLastSelectedIconTexture = this.atlas.getTexture("station-list-last-selected-icon");
			this.confirmIconTexture = this.atlas.getTexture("confirm-icon");
			this.cancelIconTexture = this.atlas.getTexture("cancel-icon");
			this.backIconTexture = this.atlas.getTexture("back-icon");
			this.horizontalScrollBarThumbSkinTextures = new Scale3Textures(this.atlas.getTexture("horizontal-scroll-bar-thumb-skin"), SCROLL_BAR_THUMB_REGION1, SCROLL_BAR_THUMB_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
			this.verticalScrollBarThumbSkinTextures = new Scale3Textures(this.atlas.getTexture("vertical-scroll-bar-thumb-skin"), SCROLL_BAR_THUMB_REGION1, SCROLL_BAR_THUMB_REGION2, Scale3Textures.DIRECTION_VERTICAL);

			//we need to use different font names because Flash runtimes seem to
			//have a bug where setting defaultTextFormat on a TextField with a
			//different TextFormat that has the same font name as the existing
			//defaultTextFormat value causes the new TextFormat to be ignored,
			//even if the new TextFormat has different bold or italic values.
			//wtf, right?
			var regularFontName:String = "SourceSansPro";
			var boldFontName:String = "SourceSansProBold";
			var boldItalicFontName:String = "SourceSansProBoldItalic";
			this.defaultTextFormat = new TextFormat(regularFontName, Math.round(36 * this.scale), PRIMARY_TEXT_COLOR);
			this.selectedTextFormat = new TextFormat(boldFontName, Math.round(36 * this.scale), PRIMARY_TEXT_COLOR, true);
			this.headerTitleTextFormat = new TextFormat(regularFontName, Math.round(36 * this.scale), PRIMARY_TEXT_COLOR);
			this.stationListNameTextFormat = new TextFormat(boldItalicFontName, Math.round(48 * this.scale), PRIMARY_TEXT_COLOR, true, true);
			this.stationListDetailTextFormat = new TextFormat(boldFontName, Math.round(24 * this.scale), DETAIL_TEXT_COLOR, true);
			this.stationListDetailTextFormat.letterSpacing = 6 * this.scale;
		}

		protected function initializeStyleProviders():void
		{
			this.getStyleProviderForClass(Button).defaultStyleFunction = setButtonStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(StationListItemRenderer.CHILD_STYLE_NAME_STATION_LIST_CONFIRM_BUTTON, setConfirmButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(StationListItemRenderer.CHILD_STYLE_NAME_STATION_LIST_CANCEL_BUTTON, setCancelButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(SimpleScrollBar.DEFAULT_CHILD_STYLE_NAME_THUMB, setNoStyles);
			this.getStyleProviderForClass(Label).defaultStyleFunction = setLabelStyles;
			this.getStyleProviderForClass(Label).setFunctionForStyleName(StationListItemRenderer.CHILD_STYLE_NAME_STATION_LIST_NAME_LABEL, setStationListNameLabelStyles);
			this.getStyleProviderForClass(Label).setFunctionForStyleName(StationListItemRenderer.CHILD_STYLE_NAME_STATION_LIST_DETAILS_LABEL, setStationListDetailLabelStyles);
			this.getStyleProviderForClass(Header).defaultStyleFunction = setHeaderStyles;
			this.getStyleProviderForClass(List).setFunctionForStyleName(StationScreen.CHILD_STYLE_NAME_STATION_LIST, setStationListStyles);
			this.getStyleProviderForClass(List).setFunctionForStyleName(TimesScreen.CHILD_STYLE_NAME_TIMES_LIST, setTimesListStyles);
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(TIMES_LIST_ITEM_RENDERER_NAME, setTimesListItemRendererStyles);
			this.getStyleProviderForClass(StationListItemRenderer).defaultStyleFunction = setStationListItemRendererStyles;
			this.getStyleProviderForClass(ScrollContainer).setFunctionForStyleName(StationListItemRenderer.CHILD_STYLE_NAME_STATION_LIST_ACTION_CONTAINER, setActionContainerStyles);
		}

		protected function imageLoaderFactory():ImageLoader
		{
			var image:ImageLoader = new ImageLoader();
			image.textureScale = this.scale;
			return image;
		}

		protected function horizontalScrollBarFactory():SimpleScrollBar
		{
			var scrollBar:SimpleScrollBar = new SimpleScrollBar();
			scrollBar.direction = SimpleScrollBar.DIRECTION_HORIZONTAL;
			var defaultSkin:Scale3Image = new Scale3Image(this.horizontalScrollBarThumbSkinTextures, this.scale);
			defaultSkin.width = 10 * this.scale;
			scrollBar.thumbProperties.defaultSkin = defaultSkin;
			scrollBar.paddingRight = scrollBar.paddingBottom = scrollBar.paddingLeft = 4 * this.scale;
			return scrollBar;
		}

		protected function verticalScrollBarFactory():SimpleScrollBar
		{
			var scrollBar:SimpleScrollBar = new SimpleScrollBar();
			scrollBar.direction = SimpleScrollBar.DIRECTION_VERTICAL;
			var defaultSkin:Scale3Image = new Scale3Image(this.verticalScrollBarThumbSkinTextures, this.scale);
			defaultSkin.height = 10 * this.scale;
			scrollBar.thumbProperties.defaultSkin = defaultSkin;
			scrollBar.paddingTop = scrollBar.paddingRight = scrollBar.paddingBottom = 4 * this.scale;
			return scrollBar;
		}

		protected function setNoStyles(target:DisplayObject):void {}

		protected function setLabelStyles(label:Label):void
		{
			label.textRendererProperties.textFormat = this.defaultTextFormat;
		}

		protected function setStationListNameLabelStyles(label:Label):void
		{
			label.textRendererProperties.textFormat = this.stationListNameTextFormat;
		}

		protected function setStationListDetailLabelStyles(label:Label):void
		{
			label.textRendererProperties.textFormat = this.stationListDetailTextFormat;
		}

		protected function setButtonStyles(button:Button):void
		{
			var defaultIcon:ImageLoader = new ImageLoader();
			defaultIcon.source = this.backIconTexture;
			defaultIcon.textureScale = this.scale;
			defaultIcon.snapToPixels = true;
			button.defaultIcon = defaultIcon;
			button.minWidth = button.minHeight = 44 * this.scale;
			button.minTouchWidth = button.minTouchHeight = 88 * this.scale;
		}

		protected function setConfirmButtonStyles(button:Button):void
		{
			var defaultIcon:ImageLoader = new ImageLoader();
			defaultIcon.source = this.confirmIconTexture;
			defaultIcon.textureScale = this.scale;
			defaultIcon.snapToPixels = true;
			button.defaultIcon = defaultIcon;
			button.minWidth = button.minHeight = 44 * this.scale;
			button.minTouchWidth = button.minTouchHeight = 88 * this.scale;
		}

		protected function setCancelButtonStyles(button:Button):void
		{
			var defaultIcon:ImageLoader = new ImageLoader();
			defaultIcon.source = this.cancelIconTexture;
			defaultIcon.textureScale = this.scale;
			defaultIcon.snapToPixels = true;
			button.defaultIcon = defaultIcon;
			button.minWidth = button.minHeight = 44 * this.scale;
			button.minTouchWidth = button.minTouchHeight = 88 * this.scale;
		}

		protected function setHeaderStyles(header:Header):void
		{
			header.minWidth = 88 * this.scale;
			header.minHeight = 88 * this.scale;
			header.paddingTop = header.paddingRight = header.paddingBottom =
				header.paddingLeft = 14 * this.scale;
			header.titleAlign = Header.TITLE_ALIGN_PREFER_RIGHT;

			var backgroundSkin:Scale9Image = new Scale9Image(this.headerBackgroundTextures, this.scale);
			header.backgroundSkin = backgroundSkin;
			header.titleProperties.textFormat = this.headerTitleTextFormat;
		}

		protected function setStationListStyles(list:List):void
		{
			list.horizontalScrollBarFactory = this.horizontalScrollBarFactory;
			list.verticalScrollBarFactory = this.verticalScrollBarFactory;

			list.itemRendererType = StationListItemRenderer;
		}

		protected function setTimesListStyles(list:List):void
		{
			list.horizontalScrollBarFactory = this.horizontalScrollBarFactory;
			list.verticalScrollBarFactory = this.verticalScrollBarFactory;
			list.customItemRendererStyleName = TIMES_LIST_ITEM_RENDERER_NAME;
		}

		protected function setTimesListItemRendererStyles(renderer:DefaultListItemRenderer):void
		{
			var defaultSkin:Quad = new Quad(88 * this.scale, 88 * this.scale, 0xff00ff);
			defaultSkin.alpha = 0;
			renderer.defaultSkin = defaultSkin;
			var defaultSelectedSkin:Quad = new Quad(88 * this.scale, 88 * this.scale, 0xcc2a41);
			renderer.defaultSelectedSkin = defaultSelectedSkin;
			renderer.defaultLabelProperties.textFormat = this.defaultTextFormat;
			renderer.defaultSelectedLabelProperties.textFormat = this.selectedTextFormat;
			renderer.paddingLeft = 8 * this.scale;
			renderer.paddingRight = 16 * this.scale;
		}

		protected function setStationListItemRendererStyles(renderer:StationListItemRenderer):void
		{
			renderer.paddingLeft = 44 * this.scale;
			renderer.paddingRight = 32 * this.scale
			renderer.iconLoaderFactory = imageLoaderFactory;
			renderer.normalIconTexture = this.stationListNormalIconTexture;
			renderer.firstNormalIconTexture = this.stationListFirstNormalIconTexture;
			renderer.lastNormalIconTexture = this.stationListLastNormalIconTexture;
			renderer.selectedIconTexture = this.stationListSelectedIconTexture;
			renderer.firstSelectedIconTexture = this.stationListFirstSelectedIconTexture;
			renderer.lastSelectedIconTexture = this.stationListLastSelectedIconTexture;
		}

		protected function setActionContainerStyles(container:ScrollContainer):void
		{
			var backgroundSkin:Quad = new Quad(48 * this.scale, 48 * this.scale, 0xcc2a41);
			container.backgroundSkin = backgroundSkin;

			var layout:HorizontalLayout = new HorizontalLayout();
			layout.paddingRight = 32 * this.scale;
			layout.gap = 48 * this.scale;
			layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			container.layout = layout;
		}

		protected function stage_resizeHandler(event:ResizeEvent):void
		{
			this.primaryBackground.width = event.width;
			this.primaryBackground.height = event.height;
		}
	}
}
