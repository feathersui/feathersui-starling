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
	import feathers.examples.trainTimes.controls.StationListItemRenderer;
	import feathers.examples.trainTimes.screens.StationScreen;
	import feathers.examples.trainTimes.screens.TimesScreen;
	import feathers.layout.HorizontalLayout;
	import feathers.themes.StyleNameFunctionTheme;

	import flash.geom.Rectangle;
	import flash.text.TextFormat;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
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

		protected static const HEADER_SCALE9_GRID:Rectangle = new Rectangle(0, 0, 2, 2);
		protected static const HORIZONTAL_SCROLL_BAR_THUMB_SCALE9_GRID:Rectangle = new Rectangle(3, 0, 7, 4);
		protected static const VERTICAL_SCROLL_BAR_THUMB_SCALE9_GRID:Rectangle = new Rectangle(0, 3, 4, 7);

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

		protected var primaryBackground:Image;

		protected var defaultTextFormat:TextFormat;
		protected var selectedTextFormat:TextFormat;
		protected var headerTitleTextFormat:TextFormat;
		protected var stationListNameTextFormat:TextFormat;
		protected var stationListDetailTextFormat:TextFormat;

		protected var atlas:TextureAtlas;
		protected var mainBackgroundTexture:Texture;
		protected var headerBackgroundTexture:Texture;
		protected var stationListNormalIconTexture:Texture;
		protected var stationListFirstNormalIconTexture:Texture;
		protected var stationListLastNormalIconTexture:Texture;
		protected var stationListSelectedIconTexture:Texture;
		protected var stationListFirstSelectedIconTexture:Texture;
		protected var stationListLastSelectedIconTexture:Texture;
		protected var confirmIconTexture:Texture;
		protected var cancelIconTexture:Texture;
		protected var backIconTexture:Texture;
		protected var horizontalScrollBarThumbSkinTexture:Texture;
		protected var verticalScrollBarThumbSkinTexture:Texture;

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
			super.dispose();
		}

		protected function initialize():void
		{
			this.initializeGlobals();
			this.initializeTextures();
			this.initializeStage();
			this.initializeStyleProviders();
		}

		protected function initializeStage():void
		{
			this.primaryBackground = new Image(this.mainBackgroundTexture);
			this.primaryBackground.tileGrid = new Rectangle();
			this.primaryBackground.width = Starling.current.stage.stageWidth;
			this.primaryBackground.height = Starling.current.stage.stageHeight;
			Starling.current.stage.addChildAt(this.primaryBackground, 0);
			Starling.current.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
		}

		protected function initializeGlobals():void
		{
			FeathersControl.defaultTextRendererFactory = textRendererFactory;
			FeathersControl.defaultTextEditorFactory = textEditorFactory;

			PopUpManager.overlayFactory = popUpOverlayFactory;
			Callout.stagePaddingTop = Callout.stagePaddingRight = Callout.stagePaddingBottom =
				Callout.stagePaddingLeft = 8;
		}

		protected function initializeTextures():void
		{
			var atlasTexture:Texture = Texture.fromEmbeddedAsset(ATLAS_IMAGE, false, false, 2);
			this.atlas = new TextureAtlas(atlasTexture, XML(new ATLAS_XML()));

			this.mainBackgroundTexture = this.atlas.getTexture("main-background");
			this.headerBackgroundTexture = this.atlas.getTexture("header-background");
			this.stationListNormalIconTexture = this.atlas.getTexture("station-list-normal-icon");
			this.stationListFirstNormalIconTexture = this.atlas.getTexture("station-list-first-normal-icon");
			this.stationListLastNormalIconTexture = this.atlas.getTexture("station-list-last-normal-icon");
			this.stationListSelectedIconTexture = this.atlas.getTexture("station-list-selected-icon");
			this.stationListFirstSelectedIconTexture = this.atlas.getTexture("station-list-first-selected-icon");
			this.stationListLastSelectedIconTexture = this.atlas.getTexture("station-list-last-selected-icon");
			this.confirmIconTexture = this.atlas.getTexture("confirm-icon");
			this.cancelIconTexture = this.atlas.getTexture("cancel-icon");
			this.backIconTexture = this.atlas.getTexture("back-icon");
			this.horizontalScrollBarThumbSkinTexture = this.atlas.getTexture("horizontal-scroll-bar-thumb-skin");
			this.verticalScrollBarThumbSkinTexture = this.atlas.getTexture("vertical-scroll-bar-thumb-skin");

			//we need to use different font names because Flash runtimes seem to
			//have a bug where setting defaultTextFormat on a TextField with a
			//different TextFormat that has the same font name as the existing
			//defaultTextFormat value causes the new TextFormat to be ignored,
			//even if the new TextFormat has different bold or italic values.
			//wtf, right?
			var regularFontName:String = "SourceSansPro";
			var boldFontName:String = "SourceSansProBold";
			var boldItalicFontName:String = "SourceSansProBoldItalic";
			this.defaultTextFormat = new TextFormat(regularFontName, 18, PRIMARY_TEXT_COLOR);
			this.selectedTextFormat = new TextFormat(boldFontName, 18, PRIMARY_TEXT_COLOR, true);
			this.headerTitleTextFormat = new TextFormat(regularFontName, 18, PRIMARY_TEXT_COLOR);
			this.stationListNameTextFormat = new TextFormat(boldItalicFontName, 24, PRIMARY_TEXT_COLOR, true, true);
			this.stationListDetailTextFormat = new TextFormat(boldFontName, 12, DETAIL_TEXT_COLOR, true);
			this.stationListDetailTextFormat.letterSpacing = 3;
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
			this.getStyleProviderForClass(StationListItemRenderer).setFunctionForStyleName(StationScreen.CHILD_STYLE_NAME_STATION_LIST_ITEM_RENDERER, setStationListItemRendererStyles);
			this.getStyleProviderForClass(StationListItemRenderer).setFunctionForStyleName(StationScreen.CHILD_STYLE_NAME_STATION_LIST_FIRST_ITEM_RENDERER, setStationListFirstItemRendererStyles);
			this.getStyleProviderForClass(StationListItemRenderer).setFunctionForStyleName(StationScreen.CHILD_STYLE_NAME_STATION_LIST_LAST_ITEM_RENDERER, setStationListLastItemRendererStyles);
			this.getStyleProviderForClass(ScrollContainer).setFunctionForStyleName(StationListItemRenderer.CHILD_STYLE_NAME_STATION_LIST_ACTION_CONTAINER, setActionContainerStyles);
		}

		protected function horizontalScrollBarFactory():SimpleScrollBar
		{
			var scrollBar:SimpleScrollBar = new SimpleScrollBar();
			scrollBar.direction = SimpleScrollBar.DIRECTION_HORIZONTAL;
			var defaultSkin:Image = new Image(this.horizontalScrollBarThumbSkinTexture);
			defaultSkin.scale9Grid = HORIZONTAL_SCROLL_BAR_THUMB_SCALE9_GRID;
			defaultSkin.width = 5;
			scrollBar.thumbProperties.defaultSkin = defaultSkin;
			scrollBar.paddingRight = scrollBar.paddingBottom = scrollBar.paddingLeft = 2;
			return scrollBar;
		}

		protected function verticalScrollBarFactory():SimpleScrollBar
		{
			var scrollBar:SimpleScrollBar = new SimpleScrollBar();
			scrollBar.direction = SimpleScrollBar.DIRECTION_VERTICAL;
			var defaultSkin:Image = new Image(this.verticalScrollBarThumbSkinTexture);
			defaultSkin.scale9Grid = VERTICAL_SCROLL_BAR_THUMB_SCALE9_GRID;
			defaultSkin.height = 5;
			scrollBar.thumbProperties.defaultSkin = defaultSkin;
			scrollBar.paddingTop = scrollBar.paddingRight = scrollBar.paddingBottom = 2;
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
			var defaultIcon:Image = new Image(this.backIconTexture);
			button.defaultIcon = defaultIcon;
			button.minWidth = button.minHeight = 22;
			button.minTouchWidth = button.minTouchHeight = 44;
		}

		protected function setConfirmButtonStyles(button:Button):void
		{
			var defaultIcon:Image = new Image(this.confirmIconTexture);
			button.defaultIcon = defaultIcon;
			button.minWidth = button.minHeight = 22;
			button.minTouchWidth = button.minTouchHeight = 44;
		}

		protected function setCancelButtonStyles(button:Button):void
		{
			var defaultIcon:Image = new Image(this.cancelIconTexture);
			button.defaultIcon = defaultIcon;
			button.minWidth = button.minHeight = 22;
			button.minTouchWidth = button.minTouchHeight = 44;
		}

		protected function setHeaderStyles(header:Header):void
		{
			header.useExtraPaddingForOSStatusBar = true;
			
			header.minWidth = 44;
			header.minHeight = 44;
			header.padding = 7;
			header.titleAlign = Header.TITLE_ALIGN_PREFER_RIGHT;

			var backgroundSkin:Image = new Image(this.headerBackgroundTexture);
			backgroundSkin.scale9Grid = HEADER_SCALE9_GRID;
			header.backgroundSkin = backgroundSkin;
			
			header.titleProperties.textFormat = this.headerTitleTextFormat;
		}

		protected function setStationListStyles(list:List):void
		{
			list.horizontalScrollBarFactory = this.horizontalScrollBarFactory;
			list.verticalScrollBarFactory = this.verticalScrollBarFactory;
		}

		protected function setTimesListStyles(list:List):void
		{
			list.horizontalScrollBarFactory = this.horizontalScrollBarFactory;
			list.verticalScrollBarFactory = this.verticalScrollBarFactory;
			list.customItemRendererStyleName = TIMES_LIST_ITEM_RENDERER_NAME;
		}

		protected function setTimesListItemRendererStyles(renderer:DefaultListItemRenderer):void
		{
			var defaultSkin:Quad = new Quad(44, 44, 0xff00ff);
			defaultSkin.alpha = 0;
			renderer.defaultSkin = defaultSkin;
			var defaultSelectedSkin:Quad = new Quad(44, 44, 0xcc2a41);
			renderer.defaultSelectedSkin = defaultSelectedSkin;
			renderer.defaultLabelProperties.textFormat = this.defaultTextFormat;
			renderer.defaultSelectedLabelProperties.textFormat = this.selectedTextFormat;
			renderer.paddingLeft = 4;
			renderer.paddingRight = 8;
		}

		protected function setStationListItemRendererStyles(renderer:StationListItemRenderer):void
		{
			renderer.paddingLeft = 22;
			renderer.paddingRight = 16;
			renderer.normalIconTexture = this.stationListNormalIconTexture;
			renderer.selectedIconTexture = this.stationListSelectedIconTexture;
		}

		protected function setStationListFirstItemRendererStyles(renderer:StationListItemRenderer):void
		{
			renderer.paddingLeft = 22;
			renderer.paddingRight = 16;
			renderer.normalIconTexture = this.stationListFirstNormalIconTexture;
			renderer.selectedIconTexture = this.stationListFirstSelectedIconTexture;
		}

		protected function setStationListLastItemRendererStyles(renderer:StationListItemRenderer):void
		{
			renderer.paddingLeft = 22;
			renderer.paddingRight = 16;
			renderer.normalIconTexture = this.stationListLastNormalIconTexture;
			renderer.selectedIconTexture = this.stationListLastSelectedIconTexture;
		}

		protected function setActionContainerStyles(container:ScrollContainer):void
		{
			var backgroundSkin:Quad = new Quad(24, 24, 0xcc2a41);
			container.backgroundSkin = backgroundSkin;

			var layout:HorizontalLayout = new HorizontalLayout();
			layout.paddingRight = 16;
			layout.gap = 24;
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
