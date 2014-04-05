/*
 Copyright (c) 2012 Josh Tynjala

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 */
package feathers.themes
{
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Callout;
	import feathers.controls.Check;
	import feathers.controls.Drawers;
	import feathers.controls.GroupedList;
	import feathers.controls.Header;
	import feathers.controls.IScrollBar;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.NumericStepper;
	import feathers.controls.PageIndicator;
	import feathers.controls.Panel;
	import feathers.controls.PanelScreen;
	import feathers.controls.PickerList;
	import feathers.controls.ProgressBar;
	import feathers.controls.Radio;
	import feathers.controls.Screen;
	import feathers.controls.ScrollBar;
	import feathers.controls.ScrollContainer;
	import feathers.controls.ScrollScreen;
	import feathers.controls.ScrollText;
	import feathers.controls.Scroller;
	import feathers.controls.SimpleScrollBar;
	import feathers.controls.Slider;
	import feathers.controls.TabBar;
	import feathers.controls.TextArea;
	import feathers.controls.TextInput;
	import feathers.controls.ToggleSwitch;
	import feathers.controls.popups.CalloutPopUpContentManager;
	import feathers.controls.popups.DropDownPopUpContentManager;
	import feathers.controls.popups.VerticalCenteredPopUpContentManager;
	import feathers.controls.renderers.BaseDefaultItemRenderer;
	import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.core.DisplayListWatcher;
	import feathers.core.FeathersControl;
	import feathers.core.FocusManager;
	import feathers.core.PopUpManager;
	import feathers.display.Scale9Image;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.skins.SmartDisplayObjectStateValueSelector;
	import feathers.skins.StandardIcons;
	import feathers.system.DeviceCapabilities;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	import feathers.utils.math.roundToNearest;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.errors.IllegalOperationError;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getQualifiedClassName;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.SubTexture;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;
	import starling.utils.AssetManager;

	[Event(name="complete",type="starling.events.Event")]

	/**
	 * The "Minimal" theme for desktop Feathers apps.
	 *
	 * <p>This version of the theme requires loading assets at runtime. To use
	 * embedded assets, see <code>MinimalDesktopTheme</code> instead.</p>
	 *
	 * <p>To use this theme, the following files must be included when packaging
	 * your app:</p>
	 * <ul>
	 *     <li>images/minimal.png</li>
	 *     <li>images/minimal.xml</li>
	 *     <li>fonts/pf_ronda_seven.fnt</li>
	 * </ul>
	 *
	 * @see http://wiki.starling-framework.org/feathers/theme-assets
	 */
	public class MinimalDesktopThemeWithAssetManager extends DisplayListWatcher
	{
		public static const FONT_NAME:String = "PF Ronda Seven";

		protected static const THEME_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK:String = "minimal-desktop-horizontal-slider-minimum-track";
		protected static const THEME_NAME_VERTICAL_SLIDER_MINIMUM_TRACK:String = "minimal-desktop-vertical-slider-minimum-track";
		protected static const THEME_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON:String = "minimal-desktop-horizontal-scroll-bar-decrement-button";
		protected static const THEME_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON:String = "minimal-desktop-horizontal-scroll-bar-increment-button";
		protected static const THEME_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON:String = "minimal-desktop-vertical-scroll-bar-decrement-button";
		protected static const THEME_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON:String = "minimal-desktop-vertical-scroll-bar-increment-button";

		protected static const ATLAS_NAME:String = "minimal";
		protected static const FONT_TEXTURE_NAME:String = "pf_ronda_seven_0";

		protected static const SCALE_9_GRID:Rectangle = new Rectangle(2, 2, 1, 1);
		protected static const BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(2, 2, 1, 1);
		protected static const BUTTON_DOWN_SCALE_9_GRID:Rectangle = new Rectangle(3, 3, 1, 1);
		protected static const SCROLLBAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(1, 1, 2, 2);
		protected static const TAB_SCALE_9_GRID:Rectangle = new Rectangle(8, 5, 1, 1);
		protected static const HEADER_SCALE_9_GRID:Rectangle = new Rectangle(0, 5, 3, 1);
		protected static const BACK_BUTTON_SCALE_REGION1:int = 10;
		protected static const BACK_BUTTON_SCALE_REGION2:int = 1;
		protected static const FORWARD_BUTTON_SCALE_REGION1:int = 4;
		protected static const FORWARD_BUTTON_SCALE_REGION2:int = 1;

		protected static const BACKGROUND_COLOR:uint = 0xf3f3f3;
		protected static const LIST_BACKGROUND_COLOR:uint = 0xffffff;
		protected static const LIST_SELECTED_BACKGROUND_COLOR:uint = 0xdddddd;
		protected static const LIST_HOVER_BACKGROUND_COLOR:uint = 0xeeeeee;
		protected static const LIST_HEADER_BACKGROUND_COLOR:uint = 0xf8f8f8;
		protected static const PRIMARY_TEXT_COLOR:uint = 0x666666;
		protected static const DISABLED_TEXT_COLOR:uint = 0x999999;
		protected static const MODAL_OVERLAY_COLOR:uint = 0xcccccc;
		protected static const MODAL_OVERLAY_ALPHA:Number = 0.4;

		protected static function textRendererFactory():BitmapFontTextRenderer
		{
			var renderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
			//since it's a pixel font, we don't want to smooth it.
			renderer.smoothing = TextureSmoothing.NONE;
			return renderer;
		}

		protected static function textEditorFactory():TextFieldTextEditor
		{
			return new TextFieldTextEditor();
		}

		protected static function scrollBarFactory():IScrollBar
		{
			return new ScrollBar();
		}

		protected static function popUpOverlayFactory():DisplayObject
		{
			var quad:Quad = new Quad(100, 100, MODAL_OVERLAY_COLOR);
			quad.alpha = MODAL_OVERLAY_ALPHA;
			return quad;
		}

		protected static function textureValueTypeHandler(value:Texture, oldDisplayObject:DisplayObject = null):DisplayObject
		{
			var displayObject:ImageLoader = oldDisplayObject as ImageLoader;
			if(!displayObject)
			{
				displayObject = new ImageLoader();
			}
			displayObject.source = value;
			return displayObject;
		}

		public function MinimalDesktopThemeWithAssetManager(assets:Object = null, assetManager:AssetManager = null, container:DisplayObjectContainer = null)
		{
			if(!container)
			{
				container = Starling.current.stage;
			}
			super(container);
			this.processSource(assets, assetManager);
		}

		/**
		 * A subclass may embed the theme's assets and override this setter to
		 * return the class that creates the bitmap used for the texture atlas.
		 */
		protected function get atlasImageClass():Class
		{
			return null;
		}

		/**
		 * A subclass may embed the theme's assets and override this setter to
		 * return the class that creates the XML used for the texture atlas.
		 */
		protected function get atlasXMLClass():Class
		{
			return null;
		}

		/**
		 * A subclass may embed the theme's assets and override this setter to
		 * return the class that creates the XML used for the bitmap font.
		 */
		protected function get fontXMLClass():Class
		{
			return null;
		}

		protected var assetManager:AssetManager;
		protected var scale:Number = 1;
		protected var fontSize:int;
		protected var headingFontSize:int;
		protected var detailFontSize:int;
		protected var inputFontSize:int;

		protected var atlas:TextureAtlas;
		protected var atlasTexture:Texture;

		protected var buttonUpSkinTextures:Scale9Textures;
		protected var buttonDownSkinTextures:Scale9Textures;
		protected var buttonDisabledSkinTextures:Scale9Textures;
		protected var buttonSelectedSkinTextures:Scale9Textures;
		protected var buttonSelectedDisabledSkinTextures:Scale9Textures;
		protected var buttonCallToActionUpSkinTextures:Scale9Textures;
		protected var buttonDangerUpSkinTextures:Scale9Textures;
		protected var buttonDangerDownSkinTextures:Scale9Textures;
		protected var buttonBackUpSkinTextures:Scale3Textures;
		protected var buttonBackDownSkinTextures:Scale3Textures;
		protected var buttonBackDisabledSkinTextures:Scale3Textures;
		protected var buttonForwardUpSkinTextures:Scale3Textures;
		protected var buttonForwardDownSkinTextures:Scale3Textures;
		protected var buttonForwardDisabledSkinTextures:Scale3Textures;

		protected var tabSkinTextures:Scale9Textures;
		protected var tabDisabledSkinTextures:Scale9Textures;
		protected var tabSelectedSkinTextures:Scale9Textures;
		protected var tabSelectedDisabledSkinTextures:Scale9Textures;

		protected var thumbSkinTextures:Scale9Textures;
		protected var thumbDisabledSkinTextures:Scale9Textures;

		protected var simpleScrollBarThumbSkinTextures:Scale9Textures;

		protected var insetBackgroundSkinTextures:Scale9Textures;
		protected var insetBackgroundDisabledSkinTextures:Scale9Textures;
		protected var insetBackgroundFocusedSkinTextures:Scale9Textures;

		protected var pickerListButtonIconUpTexture:Texture;
		protected var pickerListButtonIconSelectedTexture:Texture;
		protected var pickerListButtonIconDisabledTexture:Texture;
		protected var searchIconTexture:Texture;
		protected var upArrowIconTexture:Texture;
		protected var rightArrowIconTexture:Texture;
		protected var downArrowIconTexture:Texture;
		protected var leftArrowIconTexture:Texture;
		protected var upArrowDisabledIconTexture:Texture;
		protected var rightArrowDisabledIconTexture:Texture;
		protected var downArrowDisabledIconTexture:Texture;
		protected var leftArrowDisabledIconTexture:Texture;

		protected var headerSkinTextures:Scale9Textures;

		protected var popUpBackgroundSkinTextures:Scale9Textures;
		protected var calloutTopArrowSkinTexture:Texture;
		protected var calloutBottomArrowSkinTexture:Texture;
		protected var calloutLeftArrowSkinTexture:Texture;
		protected var calloutRightArrowSkinTexture:Texture;

		protected var checkIconTexture:Texture;
		protected var checkDisabledIconTexture:Texture;
		protected var checkSelectedIconTexture:Texture;
		protected var checkSelectedDisabledIconTexture:Texture;

		protected var radioIconTexture:Texture;
		protected var radioDisabledIconTexture:Texture;
		protected var radioSelectedIconTexture:Texture;
		protected var radioSelectedDisabledIconTexture:Texture;

		protected var pageIndicatorNormalSkinTexture:Texture;
		protected var pageIndicatorSelectedSkinTexture:Texture;

		protected var primaryTextFormat:BitmapFontTextFormat;
		protected var disabledTextFormat:BitmapFontTextFormat;
		protected var headingTextFormat:BitmapFontTextFormat;
		protected var headingDisabledTextFormat:BitmapFontTextFormat;
		protected var detailTextFormat:BitmapFontTextFormat;
		protected var detailDisabledTextFormat:BitmapFontTextFormat;

		override public function dispose():void
		{
			if(this.root)
			{
				this.root.removeEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);
			}
			if(this.atlas)
			{
				this.atlas.dispose();
				this.atlas = null;
				//no need to dispose the atlas texture because the atlas will do that
				this.atlasTexture = null;
			}
			if(this.assetManager)
			{
				this.assetManager.removeTextureAtlas(ATLAS_NAME);
			}
			super.dispose();
		}

		protected function initializeRoot():void
		{
			if(this.root != this.root.stage)
			{
				return;
			}

			this.root.stage.color = BACKGROUND_COLOR;
			Starling.current.nativeStage.color = BACKGROUND_COLOR;
		}

		protected function atlasTexture_onRestore():void
		{
			var AtlasImageClass:Class = this.atlasImageClass;
			var atlasBitmapData:BitmapData = Bitmap(new AtlasImageClass()).bitmapData;
			this.atlasTexture.root.uploadBitmapData(atlasBitmapData);
			atlasBitmapData.dispose();
		}

		protected function assetManager_onProgress(progress:Number):void
		{
			if(progress < 1)
			{
				return;
			}
			this.initialize();
			this.dispatchEventWith(Event.COMPLETE);
		}

		protected function processSource(assets:Object, assetManager:AssetManager):void
		{
			if(assets)
			{
				this.assetManager = assetManager;
				if(!this.assetManager)
				{
					this.assetManager = new AssetManager(Starling.contentScaleFactor);
				}
				//add a trailing slash, if needed
				if(assets is String)
				{
					var assetsDirectoryName:String = assets as String;
					if(assetsDirectoryName.lastIndexOf("/") != assetsDirectoryName.length - 1)
					{
						assets = assetsDirectoryName + "/";
					}
					this.assetManager.enqueue(assets + "images/minimal.xml");
					this.assetManager.enqueue(assets + "images/minimal.png");
					this.assetManager.enqueue(assets + "fonts/pf_ronda_seven.fnt");
				}
				else if(getQualifiedClassName(assets) == "flash.filesystem::File" && assets["isDirectory"])
				{
					this.assetManager.enqueue(assets["resolvePath"]("images/minimal.xml"));
					this.assetManager.enqueue(assets["resolvePath"]("images/minimal.png"));
					this.assetManager.enqueue(assets["resolvePath"]("fonts/pf_ronda_seven.fnt"));
				}
				else
				{
					this.assetManager.enqueue(assets);
				}
				this.assetManager.loadQueue(assetManager_onProgress);
			}
			else
			{
				var AtlasImageClass:Class = this.atlasImageClass;
				var AtlasXMLClass:Class = this.atlasXMLClass;
				var FontXMLClass:Class = this.fontXMLClass;
				if(AtlasImageClass && AtlasXMLClass && FontXMLClass)
				{
					var atlasBitmapData:BitmapData = Bitmap(new AtlasImageClass()).bitmapData;
					this.atlasTexture = Texture.fromBitmapData(atlasBitmapData, false);
					this.atlasTexture.root.onRestore = this.atlasTexture_onRestore;
					atlasBitmapData.dispose();
					this.atlas = new TextureAtlas(atlasTexture, XML(new AtlasXMLClass()));

					var bitmapFont:BitmapFont = new BitmapFont(this.atlas.getTexture(FONT_TEXTURE_NAME), XML(new FontXMLClass()));
					TextField.registerBitmapFont(bitmapFont, FONT_NAME);

					this.initialize();
					this.dispatchEventWith(Event.COMPLETE);
				}
				else
				{
					throw new Error("Asset path or embedded assets not found. Theme not loaded.")
				}
			}
		}

		protected function initialize():void
		{
			if(!this.atlas)
			{
				if(this.assetManager)
				{
					this.atlas = this.assetManager.getTextureAtlas(ATLAS_NAME);
				}
				else
				{
					throw new IllegalOperationError("Atlas not loaded.");
				}
			}

			this.initializeTextures();
			this.initializeFonts();
			this.initializeGlobals();

			if(this.root.stage)
			{
				this.initializeRoot();
			}
			else
			{
				this.root.addEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);
			}

			this.setInitializers();
		}

		protected function initializeGlobals():void
		{
			FocusManager.isEnabled = true;

			PopUpManager.overlayFactory = popUpOverlayFactory;
			Callout.stagePaddingTop = Callout.stagePaddingRight = Callout.stagePaddingBottom =
				Callout.stagePaddingLeft = 16 * this.scale;

			FeathersControl.defaultTextRendererFactory = textRendererFactory;
			FeathersControl.defaultTextEditorFactory = textEditorFactory;
		}

		protected function initializeTextures():void
		{
			this.buttonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-up-skin"), BUTTON_SCALE_9_GRID);
			this.buttonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("button-down-skin"), BUTTON_DOWN_SCALE_9_GRID);
			this.buttonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("button-disabled-skin"), BUTTON_SCALE_9_GRID);
			this.buttonSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("button-selected-skin"), BUTTON_DOWN_SCALE_9_GRID);
			this.buttonSelectedDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("button-selected-disabled-skin"), BUTTON_DOWN_SCALE_9_GRID);
			this.buttonCallToActionUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-call-to-action-up-skin"), BUTTON_SCALE_9_GRID);
			this.buttonDangerUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-danger-up-skin"), BUTTON_SCALE_9_GRID);
			this.buttonDangerDownSkinTextures = new Scale9Textures(this.atlas.getTexture("button-danger-down-skin"), BUTTON_DOWN_SCALE_9_GRID);
			this.buttonBackUpSkinTextures = new Scale3Textures(this.atlas.getTexture("button-back-up-skin"), BACK_BUTTON_SCALE_REGION1, BACK_BUTTON_SCALE_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
			this.buttonBackDownSkinTextures = new Scale3Textures(this.atlas.getTexture("button-back-down-skin"), BACK_BUTTON_SCALE_REGION1, BACK_BUTTON_SCALE_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
			this.buttonBackDisabledSkinTextures = new Scale3Textures(this.atlas.getTexture("button-back-disabled-skin"), BACK_BUTTON_SCALE_REGION1, BACK_BUTTON_SCALE_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
			this.buttonForwardUpSkinTextures = new Scale3Textures(this.atlas.getTexture("button-forward-up-skin"), FORWARD_BUTTON_SCALE_REGION1, FORWARD_BUTTON_SCALE_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
			this.buttonForwardDownSkinTextures = new Scale3Textures(this.atlas.getTexture("button-forward-down-skin"), FORWARD_BUTTON_SCALE_REGION1, FORWARD_BUTTON_SCALE_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
			this.buttonForwardDisabledSkinTextures = new Scale3Textures(this.atlas.getTexture("button-forward-disabled-skin"), FORWARD_BUTTON_SCALE_REGION1, FORWARD_BUTTON_SCALE_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);

			this.tabSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-skin"), TAB_SCALE_9_GRID);
			this.tabDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-disabled-skin"), TAB_SCALE_9_GRID);
			this.tabSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-skin"), TAB_SCALE_9_GRID);
			this.tabSelectedDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-disabled-skin"), TAB_SCALE_9_GRID);

			this.thumbSkinTextures = new Scale9Textures(this.atlas.getTexture("thumb-skin"), SCALE_9_GRID);
			this.thumbDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("thumb-disabled-skin"), SCALE_9_GRID);

			this.simpleScrollBarThumbSkinTextures = new Scale9Textures(this.atlas.getTexture("scrollbar-thumb-skin"), SCROLLBAR_THUMB_SCALE_9_GRID);

			this.insetBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("inset-background-skin"), SCALE_9_GRID);
			this.insetBackgroundDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("inset-background-disabled-skin"), SCALE_9_GRID);
			this.insetBackgroundFocusedSkinTextures = new Scale9Textures(this.atlas.getTexture("inset-background-focus-skin"), SCALE_9_GRID);

			this.pickerListButtonIconUpTexture = this.atlas.getTexture("picker-list-icon");
			this.pickerListButtonIconSelectedTexture = this.atlas.getTexture("picker-list-selected-icon");
			this.pickerListButtonIconDisabledTexture = this.atlas.getTexture("picker-list-disabled-icon");
			this.searchIconTexture = this.atlas.getTexture("search-icon");
			this.upArrowIconTexture = this.atlas.getTexture("up-arrow-icon");
			this.rightArrowIconTexture = this.atlas.getTexture("right-arrow-icon");
			this.downArrowIconTexture = this.atlas.getTexture("down-arrow-icon");
			this.leftArrowIconTexture = this.atlas.getTexture("left-arrow-icon");
			this.upArrowDisabledIconTexture = this.atlas.getTexture("up-arrow-disabled-icon");
			this.rightArrowDisabledIconTexture = this.atlas.getTexture("right-arrow-disabled-icon");
			this.downArrowDisabledIconTexture = this.atlas.getTexture("down-arrow-disabled-icon");
			this.leftArrowDisabledIconTexture = this.atlas.getTexture("left-arrow-disabled-icon");

			this.headerSkinTextures = new Scale9Textures(this.atlas.getTexture("header-skin"), HEADER_SCALE_9_GRID);

			this.popUpBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("callout-background-skin"), BUTTON_SCALE_9_GRID);
			this.calloutTopArrowSkinTexture = this.atlas.getTexture("callout-arrow-top");
			this.calloutBottomArrowSkinTexture = this.atlas.getTexture("callout-arrow-bottom");
			this.calloutLeftArrowSkinTexture = this.atlas.getTexture("callout-arrow-left");
			this.calloutRightArrowSkinTexture = this.atlas.getTexture("callout-arrow-right");

			this.checkIconTexture = this.atlas.getTexture("check-icon");
			this.checkDisabledIconTexture = this.atlas.getTexture("check-disabled-icon");
			this.checkSelectedIconTexture = this.atlas.getTexture("check-selected-icon");
			this.checkSelectedDisabledIconTexture = this.atlas.getTexture("check-selected-disabled-icon");

			this.radioIconTexture = this.atlas.getTexture("radio-icon");
			this.radioDisabledIconTexture = this.atlas.getTexture("radio-disabled-icon");
			this.radioSelectedIconTexture = this.atlas.getTexture("radio-selected-icon");
			this.radioSelectedDisabledIconTexture = this.atlas.getTexture("radio-selected-disabled-icon");

			this.pageIndicatorNormalSkinTexture = this.atlas.getTexture("page-indicator-normal-skin");
			this.pageIndicatorSelectedSkinTexture = this.atlas.getTexture("page-indicator-selected-skin");

			StandardIcons.listDrillDownAccessoryTexture = this.atlas.getTexture("list-accessory-drill-down-icon");
		}

		protected function initializeFonts():void
		{
			//since it's a pixel font, we want a multiple of the original size,
			//which, in this case, is 8.
			this.fontSize = Math.max(8, roundToNearest(8 * this.scale, 8));
			this.headingFontSize = Math.max(8, roundToNearest(16 * this.scale, 8));
			this.detailFontSize = Math.max(8, roundToNearest(8 * this.scale, 8));
			this.inputFontSize = Math.max(8, roundToNearest(8 * this.scale));

			this.primaryTextFormat = new BitmapFontTextFormat(FONT_NAME, this.fontSize, PRIMARY_TEXT_COLOR);
			this.disabledTextFormat = new BitmapFontTextFormat(FONT_NAME, this.fontSize, DISABLED_TEXT_COLOR);
			this.headingTextFormat = new BitmapFontTextFormat(FONT_NAME, this.headingFontSize, PRIMARY_TEXT_COLOR);
			this.headingDisabledTextFormat = new BitmapFontTextFormat(FONT_NAME, this.headingFontSize, DISABLED_TEXT_COLOR);
			this.detailTextFormat = new BitmapFontTextFormat(FONT_NAME, this.detailFontSize, PRIMARY_TEXT_COLOR);
			this.detailDisabledTextFormat = new BitmapFontTextFormat(FONT_NAME, this.detailFontSize, DISABLED_TEXT_COLOR);
		}

		protected function setInitializers():void
		{
			//screens
			this.setInitializerForClassAndSubclasses(Screen, screenInitializer);
			this.setInitializerForClassAndSubclasses(PanelScreen, panelScreenInitializer);
			this.setInitializerForClassAndSubclasses(ScrollScreen, scrollScreenInitializer);

			//alert
			this.setInitializerForClass(Alert, alertInitializer);
			this.setInitializerForClass(Header, panelHeaderInitializer, Alert.DEFAULT_CHILD_NAME_HEADER);
			this.setInitializerForClass(ButtonGroup, alertButtonGroupInitializer, Alert.DEFAULT_CHILD_NAME_BUTTON_GROUP);
			this.setInitializerForClass(BitmapFontTextRenderer, alertMessageInitializer, Alert.DEFAULT_CHILD_NAME_MESSAGE);

			//button
			this.setInitializerForClass(Button, buttonInitializer);
			this.setInitializerForClass(Button, buttonCallToActionInitializer, Button.ALTERNATE_NAME_CALL_TO_ACTION_BUTTON);
			this.setInitializerForClass(Button, buttonQuietInitializer, Button.ALTERNATE_NAME_QUIET_BUTTON);
			this.setInitializerForClass(Button, buttonDangerInitializer, Button.ALTERNATE_NAME_DANGER_BUTTON);
			this.setInitializerForClass(Button, buttonBackInitializer, Button.ALTERNATE_NAME_BACK_BUTTON);
			this.setInitializerForClass(Button, buttonForwardInitializer, Button.ALTERNATE_NAME_FORWARD_BUTTON);

			//button group
			this.setInitializerForClass(ButtonGroup, buttonGroupInitializer);
			this.setInitializerForClass(Button, buttonGroupButtonInitializer, ButtonGroup.DEFAULT_CHILD_NAME_BUTTON);

			//callout
			this.setInitializerForClass(Callout, calloutInitializer);

			//check
			this.setInitializerForClass(Check, checkInitializer);

			//check
			this.setInitializerForClass(Drawers, drawersInitializer);

			//grouped list (see also: item renderers)
			this.setInitializerForClass(GroupedList, groupedListInitializer);

			//header
			this.setInitializerForClass(Header, headerInitializer);

			//item renderers for lists
			this.setInitializerForClass(DefaultListItemRenderer, itemRendererInitializer);
			this.setInitializerForClass(DefaultGroupedListItemRenderer, itemRendererInitializer);

			//header and footer renderers for grouped list
			this.setInitializerForClass(DefaultGroupedListHeaderOrFooterRenderer, headerOrFooterRendererInitializer);
			this.setInitializerForClass(DefaultGroupedListHeaderOrFooterRenderer, insetHeaderOrFooterRendererInitializer, GroupedList.ALTERNATE_CHILD_NAME_INSET_HEADER_RENDERER);
			this.setInitializerForClass(DefaultGroupedListHeaderOrFooterRenderer, insetHeaderOrFooterRendererInitializer, GroupedList.ALTERNATE_CHILD_NAME_INSET_FOOTER_RENDERER);

			//label
			this.setInitializerForClass(Label, labelInitializer);
			this.setInitializerForClass(Label, headingLabelInitializer, Label.ALTERNATE_NAME_HEADING);
			this.setInitializerForClass(Label, detailLabelInitializer, Label.ALTERNATE_NAME_DETAIL);

			//list (see also: item renderers)
			this.setInitializerForClass(List, listInitializer);

			//numeric stepper
			this.setInitializerForClass(NumericStepper, numericStepperInitializer);
			this.setInitializerForClass(TextInput, numericStepperTextInputInitializer, NumericStepper.DEFAULT_CHILD_NAME_TEXT_INPUT);
			this.setInitializerForClass(Button, numericStepperButtonInitializer, NumericStepper.DEFAULT_CHILD_NAME_DECREMENT_BUTTON);
			this.setInitializerForClass(Button, numericStepperButtonInitializer, NumericStepper.DEFAULT_CHILD_NAME_INCREMENT_BUTTON);

			//page indicator
			this.setInitializerForClass(PageIndicator, pageIndicatorInitializer);

			//panel
			this.setInitializerForClass(Panel, panelInitializer);
			this.setInitializerForClass(Header, panelHeaderInitializer, Panel.DEFAULT_CHILD_NAME_HEADER);

			//panel screen
			this.setInitializerForClass(Header, panelScreenHeaderInitializer, PanelScreen.DEFAULT_CHILD_NAME_HEADER);

			//picker list (see also: item renderers)
			this.setInitializerForClass(PickerList, pickerListInitializer);
			this.setInitializerForClass(Button, pickerListButtonInitializer, PickerList.DEFAULT_CHILD_NAME_BUTTON);
			this.setInitializerForClass(List, pickerListListInitializer, PickerList.DEFAULT_CHILD_NAME_LIST);

			//progress bar
			this.setInitializerForClass(ProgressBar, progressBarInitializer);

			//radio
			this.setInitializerForClass(Radio, radioInitializer);

			//scroll bar
			this.setInitializerForClass(ScrollBar, horizontalScrollBarInitializer, Scroller.DEFAULT_CHILD_NAME_HORIZONTAL_SCROLL_BAR);
			this.setInitializerForClass(ScrollBar, verticalScrollBarInitializer, Scroller.DEFAULT_CHILD_NAME_VERTICAL_SCROLL_BAR);
			this.setInitializerForClass(Button, scrollBarThumbInitializer, ScrollBar.DEFAULT_CHILD_NAME_THUMB);
			this.setInitializerForClass(Button, scrollBarMinimumTrackInitializer, ScrollBar.DEFAULT_CHILD_NAME_MINIMUM_TRACK);
			this.setInitializerForClass(Button, scrollBarThumbInitializer, ScrollBar.DEFAULT_CHILD_NAME_THUMB);
			this.setInitializerForClass(Button, horizontalScrollBarDecrementButtonInitializer, THEME_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON);
			this.setInitializerForClass(Button, horizontalScrollBarIncrementButtonInitializer, THEME_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON);
			this.setInitializerForClass(Button, verticalScrollBarDecrementButtonInitializer, THEME_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON);
			this.setInitializerForClass(Button, verticalScrollBarIncrementButtonInitializer, THEME_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON);

			//scroll container
			this.setInitializerForClass(ScrollContainer, scrollContainerInitializer);
			this.setInitializerForClass(ScrollContainer, scrollContainerToolbarInitializer, ScrollContainer.ALTERNATE_NAME_TOOLBAR);

			//scroll text
			this.setInitializerForClass(ScrollText, scrollTextInitializer);
			this.setInitializerForClass(BitmapFontTextRenderer, itemRendererAccessoryLabelInitializer, BaseDefaultItemRenderer.DEFAULT_CHILD_NAME_ACCESSORY_LABEL);

			//simple scroll bar
			this.setInitializerForClass(Button, simpleScrollBarThumbInitializer, SimpleScrollBar.DEFAULT_CHILD_NAME_THUMB);

			//slider
			this.setInitializerForClass(Slider, sliderInitializer);
			this.setInitializerForClass(Button, sliderThumbInitializer, Slider.DEFAULT_CHILD_NAME_THUMB);
			this.setInitializerForClass(Button, horizontalSliderMinimumTrackInitializer, THEME_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK);
			this.setInitializerForClass(Button, verticalSliderMinimumTrackInitializer, THEME_NAME_VERTICAL_SLIDER_MINIMUM_TRACK);

			//tab bar
			this.setInitializerForClass(Button, tabInitializer, TabBar.DEFAULT_CHILD_NAME_TAB);

			//text input
			this.setInitializerForClass(TextInput, textInputInitializer);
			this.setInitializerForClass(TextInput, searchTextInputInitializer, TextInput.ALTERNATE_NAME_SEARCH_TEXT_INPUT);

			//text area
			this.setInitializerForClass(TextArea, textAreaInitializer);

			//toggle switch
			this.setInitializerForClass(ToggleSwitch, toggleSwitchInitializer);
			this.setInitializerForClass(Button, toggleSwitchThumbInitializer, ToggleSwitch.DEFAULT_CHILD_NAME_THUMB);
			this.setInitializerForClass(Button, toggleSwitchOnTrackInitializer, ToggleSwitch.DEFAULT_CHILD_NAME_ON_TRACK);
		}

		protected function pageIndicatorNormalSymbolFactory():DisplayObject
		{
			var symbol:ImageLoader = new ImageLoader();
			symbol.source = this.pageIndicatorNormalSkinTexture;
			symbol.textureScale = this.scale;
			symbol.snapToPixels = true;
			return symbol;
		}

		protected function pageIndicatorSelectedSymbolFactory():DisplayObject
		{
			var symbol:ImageLoader = new ImageLoader();
			symbol.source = this.pageIndicatorSelectedSkinTexture;
			symbol.textureScale = this.scale;
			symbol.snapToPixels = true;
			return symbol;
		}

		protected function imageLoaderFactory():ImageLoader
		{
			var image:ImageLoader = new ImageLoader();
			image.textureScale = this.scale;
			image.snapToPixels = true;
			return image;
		}

		protected function nothingInitializer(target:DisplayObject):void
		{
			//if this is assigned as an initializer, chances are the target will
			//be a subcomponent of something. the initializer for this
			//component's parent is probably handing the initializing for the
			//target too.
		}

		protected function screenInitializer(screen:Screen):void
		{
			screen.originalDPI = DeviceCapabilities.dpi;
		}

		protected function panelScreenInitializer(screen:PanelScreen):void
		{
			screen.originalDPI = DeviceCapabilities.dpi;
			screen.interactionMode = ScrollContainer.INTERACTION_MODE_MOUSE;
			screen.scrollBarDisplayMode = ScrollContainer.SCROLL_BAR_DISPLAY_MODE_FIXED;
			screen.horizontalScrollBarFactory = scrollBarFactory;
			screen.verticalScrollBarFactory = scrollBarFactory;
		}

		protected function scrollScreenInitializer(screen:ScrollScreen):void
		{
			screen.originalDPI = DeviceCapabilities.dpi;
			screen.interactionMode = ScrollContainer.INTERACTION_MODE_MOUSE;
			screen.scrollBarDisplayMode = ScrollContainer.SCROLL_BAR_DISPLAY_MODE_FIXED;
			screen.horizontalScrollBarFactory = scrollBarFactory;
			screen.verticalScrollBarFactory = scrollBarFactory;
		}

		protected function labelInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.primaryTextFormat;
			label.textRendererProperties.disabledTextFormat = this.disabledTextFormat;
		}

		protected function headingLabelInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.headingTextFormat;
			label.textRendererProperties.disabledTextFormat = this.headingDisabledTextFormat;
		}

		protected function detailLabelInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.detailTextFormat;
			label.textRendererProperties.disabledTextFormat = this.detailDisabledTextFormat;
		}

		protected function itemRendererAccessoryLabelInitializer(renderer:BitmapFontTextRenderer):void
		{
			renderer.textFormat = this.primaryTextFormat;
		}

		protected function alertMessageInitializer(renderer:BitmapFontTextRenderer):void
		{
			renderer.wordWrap = true;
			renderer.textFormat = this.primaryTextFormat;
		}

		protected function scrollTextInitializer(text:ScrollText):void
		{
			text.textFormat = new TextFormat("PF Ronda Seven,Roboto,Helvetica,Arial,_sans", this.fontSize, PRIMARY_TEXT_COLOR);
			text.disabledTextFormat = new TextFormat("PF Ronda Seven,Roboto,Helvetica,Arial,_sans", this.fontSize, DISABLED_TEXT_COLOR);
			text.paddingTop = text.paddingRight = text.paddingBottom = text.paddingLeft = 4 * this.scale;

			text.interactionMode = ScrollContainer.INTERACTION_MODE_MOUSE;
			text.scrollBarDisplayMode = ScrollContainer.SCROLL_BAR_DISPLAY_MODE_FIXED;
			text.horizontalScrollBarFactory = scrollBarFactory;
			text.verticalScrollBarFactory = scrollBarFactory;
		}

		protected function baseButtonInitializer(button:Button):void
		{
			button.defaultLabelProperties.textFormat = this.primaryTextFormat;
			button.defaultLabelProperties.disabledTextFormat = this.disabledTextFormat;

			button.paddingTop = button.paddingBottom = 2 * this.scale;
			button.paddingLeft = button.paddingRight = 4 * this.scale;
			button.gap = 4 * this.scale;
			button.minGap = 4 * this.scale;
			button.minWidth = 20 * this.scale;
			button.minHeight = 20 * this.scale;
		}

		protected function buttonInitializer(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.defaultSelectedValue = this.buttonSelectedSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, true);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			skinSelector.displayObjectProperties =
			{
				width: 20 * this.scale,
				height: 20 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.baseButtonInitializer(button);
			button.minWidth = 100 * this.scale;
		}

		protected function buttonCallToActionInitializer(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonCallToActionUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: 20 * this.scale,
				height: 20 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.baseButtonInitializer(button);
			button.minWidth = 100 * this.scale;
		}

		protected function buttonQuietInitializer(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = null;
			skinSelector.defaultSelectedValue = this.buttonSelectedSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, true);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			skinSelector.displayObjectProperties =
			{
				width: 20 * this.scale,
				height: 20 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.baseButtonInitializer(button);
		}

		protected function buttonDangerInitializer(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonDangerUpSkinTextures;
			skinSelector.setValueForState(this.buttonDangerDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: 20 * this.scale,
				height: 20 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.baseButtonInitializer(button);
			button.minWidth = 100 * this.scale;
		}

		protected function buttonBackInitializer(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonBackUpSkinTextures;
			skinSelector.setValueForState(this.buttonBackDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonBackDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: 20 * this.scale,
				height: 20 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.baseButtonInitializer(button);
			button.paddingLeft = 12 * this.scale;
		}

		protected function buttonForwardInitializer(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonForwardUpSkinTextures;
			skinSelector.setValueForState(this.buttonForwardDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonForwardDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: 20 * this.scale,
				height: 20 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.baseButtonInitializer(button);
			button.paddingRight = 12 * this.scale
		}

		protected function buttonGroupButtonInitializer(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.defaultSelectedValue = this.buttonSelectedSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, true);
			skinSelector.setValueForState(this.buttonSelectedSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			skinSelector.displayObjectProperties =
			{
				width: 20 * this.scale,
				height: 20 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.defaultLabelProperties.textFormat = this.primaryTextFormat;
			button.defaultLabelProperties.disabledTextFormat = this.disabledTextFormat;

			button.paddingTop = button.paddingBottom =
				button.paddingLeft = button.paddingRight = 2 * this.scale;
			button.gap = 4 * this.scale;
			button.minGap = 4 * this.scale;
			button.minWidth = 100 * this.scale;
			button.minHeight = 20 * this.scale;
		}

		protected function numericStepperButtonInitializer(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.defaultSelectedValue = this.buttonSelectedSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, true);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			skinSelector.displayObjectProperties =
			{
				width: 20 * this.scale,
				height: 20 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.baseButtonInitializer(button);
		}

		protected function tabInitializer(tab:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.tabSkinTextures;
			skinSelector.defaultSelectedValue = this.tabSelectedSkinTextures;
			skinSelector.setValueForState(this.tabDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.tabSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			skinSelector.displayObjectProperties =
			{
				width: 20 * this.scale,
				height: 20 * this.scale,
				textureScale: this.scale
			};
			tab.stateToSkinFunction = skinSelector.updateValue;

			tab.defaultLabelProperties.textFormat = this.primaryTextFormat;
			tab.defaultLabelProperties.disabledTextFormat = this.disabledTextFormat;

			tab.iconPosition = Button.ICON_POSITION_LEFT;
			tab.paddingTop = tab.paddingBottom = 2 * this.scale;
			tab.paddingRight = tab.paddingLeft = 4 * this.scale;
			tab.gap = 4 * this.scale;
			tab.minGap = 4 * this.scale;
			tab.minWidth = tab.minHeight = 20 * this.scale;
		}

		protected function simpleScrollBarThumbInitializer(thumb:Button):void
		{
			var defaultSkin:Scale9Image = new Scale9Image(this.simpleScrollBarThumbSkinTextures, this.scale);
			defaultSkin.width = 4 * this.scale;
			defaultSkin.height = 4 * this.scale;
			thumb.defaultSkin = defaultSkin;
		}

		protected function horizontalScrollBarInitializer(scrollBar:ScrollBar):void
		{
			scrollBar.direction = ScrollBar.DIRECTION_HORIZONTAL;
			scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;

			scrollBar.customIncrementButtonName = THEME_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON;
			scrollBar.customDecrementButtonName = THEME_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON;
		}

		protected function verticalScrollBarInitializer(scrollBar:ScrollBar):void
		{
			scrollBar.direction = ScrollBar.DIRECTION_VERTICAL;
			scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;

			scrollBar.customIncrementButtonName = THEME_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON;
			scrollBar.customDecrementButtonName = THEME_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON;
		}

		protected function scrollBarThumbInitializer(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.thumbSkinTextures;
			skinSelector.defaultSelectedValue = this.thumbDisabledSkinTextures;
			skinSelector.displayObjectProperties =
			{
				width: 10 * this.scale,
				height: 10 * this.scale,
				textureScale: this.scale
			};
			thumb.stateToSkinFunction = skinSelector.updateValue;
		}

		protected function scrollBarMinimumTrackInitializer(track:Button):void
		{
			var sliderTrackDefaultSkin:Scale9Image = new Scale9Image(this.insetBackgroundSkinTextures, this.scale);
			sliderTrackDefaultSkin.width = 10 * this.scale;
			sliderTrackDefaultSkin.height = 10 * this.scale;
			track.defaultSkin = sliderTrackDefaultSkin;
		}

		protected function baseScrollBarButtonInitializer(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.defaultSelectedValue = this.buttonSelectedSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, true);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			skinSelector.displayObjectProperties =
			{
				width: 10 * this.scale,
				height: 10 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.horizontalAlign = Button.HORIZONTAL_ALIGN_CENTER;
			button.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
			button.paddingTop = 0;
			button.paddingRight = 0;
			button.paddingBottom = 0;
			button.paddingLeft = 0;
			button.gap = 0;
			button.minGap = 0;
			button.minWidth = 10 * this.scale;
			button.minHeight = 10 * this.scale;
		}

		protected function horizontalScrollBarDecrementButtonInitializer(button:Button):void
		{
			this.baseScrollBarButtonInitializer(button);

			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.defaultValue = this.leftArrowIconTexture;
			iconSelector.defaultSelectedValue = this.leftArrowDisabledIconTexture;
			iconSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			button.stateToIconFunction = iconSelector.updateValue;
		}

		protected function horizontalScrollBarIncrementButtonInitializer(button:Button):void
		{
			this.baseScrollBarButtonInitializer(button);

			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.defaultValue = this.rightArrowIconTexture;
			iconSelector.defaultSelectedValue = this.rightArrowDisabledIconTexture;
			iconSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			button.stateToIconFunction = iconSelector.updateValue;
		}

		protected function verticalScrollBarDecrementButtonInitializer(button:Button):void
		{
			this.baseScrollBarButtonInitializer(button);

			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.defaultValue = this.upArrowIconTexture;
			iconSelector.defaultSelectedValue = this.upArrowDisabledIconTexture;
			iconSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			button.stateToIconFunction = iconSelector.updateValue;
		}

		protected function verticalScrollBarIncrementButtonInitializer(button:Button):void
		{
			this.baseScrollBarButtonInitializer(button);

			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.defaultValue = this.downArrowIconTexture;
			iconSelector.defaultSelectedValue = this.downArrowDisabledIconTexture;
			iconSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			button.stateToIconFunction = iconSelector.updateValue;
		}

		protected function buttonGroupInitializer(group:ButtonGroup):void
		{
			group.minWidth = 100 * this.scale;
			group.gap = 4 * this.scale;
		}

		protected function alertButtonGroupInitializer(group:ButtonGroup):void
		{
			group.direction = ButtonGroup.DIRECTION_VERTICAL;
			group.horizontalAlign = ButtonGroup.HORIZONTAL_ALIGN_JUSTIFY;
			group.verticalAlign = ButtonGroup.VERTICAL_ALIGN_JUSTIFY;
			group.gap = 4 * this.scale;
			group.paddingTop = 8 * this.scale;
			group.paddingRight = 8 * this.scale;
			group.paddingBottom = 8 * this.scale;
			group.paddingLeft = 8 * this.scale;
		}

		protected function sliderInitializer(slider:Slider):void
		{
			slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_SINGLE;

			if(slider.direction == Slider.DIRECTION_VERTICAL)
			{
				slider.customMinimumTrackName = THEME_NAME_VERTICAL_SLIDER_MINIMUM_TRACK;
			}
			else //horizontal
			{
				slider.customMinimumTrackName = THEME_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK;
			}
		}

		protected function horizontalSliderMinimumTrackInitializer(track:Button):void
		{
			var sliderTrackDefaultSkin:Scale9Image = new Scale9Image(insetBackgroundSkinTextures, this.scale);
			sliderTrackDefaultSkin.width = 100 * this.scale;
			sliderTrackDefaultSkin.height = 10 * this.scale;
			track.defaultSkin = sliderTrackDefaultSkin;
		}

		protected function verticalSliderMinimumTrackInitializer(track:Button):void
		{
			var sliderTrackDefaultSkin:Scale9Image = new Scale9Image(insetBackgroundSkinTextures, this.scale);
			sliderTrackDefaultSkin.width = 10 * this.scale;
			sliderTrackDefaultSkin.height = 100 * this.scale;
			track.defaultSkin = sliderTrackDefaultSkin;
		}

		protected function sliderThumbInitializer(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.thumbSkinTextures;
			skinSelector.defaultSelectedValue = this.thumbDisabledSkinTextures;
			skinSelector.displayObjectProperties =
			{
				width: 10 * this.scale,
				height: 10 * this.scale,
				textureScale: this.scale
			};
			thumb.stateToSkinFunction = skinSelector.updateValue;
		}

		protected function numericStepperInitializer(stepper:NumericStepper):void
		{
			stepper.buttonLayoutMode = NumericStepper.BUTTON_LAYOUT_MODE_SPLIT_HORIZONTAL;
			stepper.incrementButtonLabel = "+";
			stepper.decrementButtonLabel = "-";
		}

		protected function toggleSwitchInitializer(toggleSwitch:ToggleSwitch):void
		{
			toggleSwitch.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;

			toggleSwitch.defaultLabelProperties.textFormat = this.primaryTextFormat;
			toggleSwitch.defaultLabelProperties.disabledTextFormat = this.disabledTextFormat;
		}

		protected function toggleSwitchOnTrackInitializer(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.insetBackgroundSkinTextures;
			skinSelector.defaultSelectedValue = this.insetBackgroundDisabledSkinTextures;
			skinSelector.displayObjectProperties =
			{
				width: 40 * this.scale,
				height: 16 * this.scale,
				textureScale: this.scale
			};
			track.stateToSkinFunction = skinSelector.updateValue;
		}

		protected function toggleSwitchThumbInitializer(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.thumbSkinTextures;
			skinSelector.defaultSelectedValue = this.thumbDisabledSkinTextures;
			skinSelector.displayObjectProperties =
			{
				width: 16 * this.scale,
				height: 16 * this.scale,
				textureScale: this.scale
			};
			thumb.stateToSkinFunction = skinSelector.updateValue;
		}

		protected function checkInitializer(check:Check):void
		{
			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
			iconSelector.defaultValue = this.checkIconTexture;
			iconSelector.defaultSelectedValue = this.checkSelectedIconTexture;
			iconSelector.setValueForState(this.checkDisabledIconTexture, Button.STATE_DISABLED, false);
			iconSelector.setValueForState(this.checkSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
			iconSelector.displayObjectProperties =
			{
				textureScale: this.scale,
				snapToPixels: true,
				smoothing: TextureSmoothing.NONE
			};
			check.stateToIconFunction = iconSelector.updateValue;

			check.defaultLabelProperties.textFormat = this.primaryTextFormat;
			check.defaultLabelProperties.disabledTextFormat = this.disabledTextFormat;

			check.gap = 4 * this.scale;
			check.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			check.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
		}

		protected function radioInitializer(radio:Radio):void
		{
			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
			iconSelector.defaultValue = this.radioIconTexture;
			iconSelector.defaultSelectedValue = this.radioSelectedIconTexture;
			iconSelector.setValueForState(this.radioDisabledIconTexture, Button.STATE_DISABLED, false);
			iconSelector.setValueForState(this.radioSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
			iconSelector.displayObjectProperties =
			{
				textureScale: this.scale,
				snapToPixels: true
			};
			radio.stateToIconFunction = iconSelector.updateValue;

			radio.defaultLabelProperties.textFormat = this.primaryTextFormat;
			radio.defaultLabelProperties.disabledTextFormat = this.disabledTextFormat;

			radio.gap = 4 * this.scale;
			radio.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			radio.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
		}

		protected function itemRendererInitializer(renderer:BaseDefaultItemRenderer):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = LIST_BACKGROUND_COLOR;
			skinSelector.defaultSelectedValue = LIST_SELECTED_BACKGROUND_COLOR;
			skinSelector.setValueForState(LIST_HOVER_BACKGROUND_COLOR, Button.STATE_HOVER, false);
			skinSelector.setValueForState(LIST_SELECTED_BACKGROUND_COLOR, Button.STATE_DOWN, false);
			skinSelector.displayObjectProperties =
			{
				width: 20 * this.scale,
				height: 20 * this.scale
			};
			renderer.stateToSkinFunction = skinSelector.updateValue;

			renderer.defaultLabelProperties.textFormat = this.primaryTextFormat;
			renderer.defaultLabelProperties.disabledTextFormat = this.disabledTextFormat;

			renderer.paddingTop = renderer.paddingBottom = 2 * this.scale;
			renderer.paddingLeft = renderer.paddingRight = 8 * this.scale;
			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			renderer.minWidth = renderer.minHeight = 20 * this.scale;

			renderer.gap = 4 * this.scale;
			renderer.minGap = 4 * this.scale;
			renderer.iconPosition = Button.ICON_POSITION_LEFT;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.minAccessoryGap = 4 * this.scale;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;

			renderer.accessoryLoaderFactory = this.imageLoaderFactory;
			renderer.iconLoaderFactory = this.imageLoaderFactory;
		}

		protected function headerOrFooterRendererInitializer(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			var backgroundSkin:Quad = new Quad(20 * this.scale, 20 * this.scale, LIST_HEADER_BACKGROUND_COLOR);
			renderer.backgroundSkin = backgroundSkin;

			renderer.contentLabelProperties.textFormat = this.primaryTextFormat;

			renderer.paddingTop = renderer.paddingBottom = 2 * this.scale;
			renderer.paddingLeft = renderer.paddingRight = 4 * this.scale;
			renderer.minWidth = renderer.minHeight = 20 * this.scale;

			renderer.contentLoaderFactory = this.imageLoaderFactory;
		}

		protected function insetHeaderOrFooterRendererInitializer(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			renderer.contentLabelProperties.textFormat = this.primaryTextFormat;

			renderer.paddingTop = renderer.paddingBottom = 2 * this.scale;
			renderer.paddingLeft = renderer.paddingRight = 6 * this.scale;
			renderer.minWidth = renderer.minHeight = 20 * this.scale;

			renderer.contentLoaderFactory = this.imageLoaderFactory;
		}

		protected function listInitializer(list:List):void
		{
			var backgroundSkin:Quad = new Quad(30 * this.scale, 30 * this.scale, LIST_BACKGROUND_COLOR);
			list.backgroundSkin = backgroundSkin;

			list.interactionMode = ScrollContainer.INTERACTION_MODE_MOUSE;
			list.scrollBarDisplayMode = ScrollContainer.SCROLL_BAR_DISPLAY_MODE_FIXED;
			list.horizontalScrollBarFactory = scrollBarFactory;
			list.verticalScrollBarFactory = scrollBarFactory;
		}

		protected function pickerListListInitializer(list:List):void
		{
			this.listInitializer(list);
			list.maxHeight = 110;
		}

		protected function groupedListInitializer(list:GroupedList):void
		{
			var backgroundSkin:Quad = new Quad(30 * this.scale, 30 * this.scale, LIST_BACKGROUND_COLOR);
			list.backgroundSkin = backgroundSkin;

			list.interactionMode = ScrollContainer.INTERACTION_MODE_MOUSE;
			list.scrollBarDisplayMode = ScrollContainer.SCROLL_BAR_DISPLAY_MODE_FIXED;
			list.horizontalScrollBarFactory = scrollBarFactory;
			list.verticalScrollBarFactory = scrollBarFactory;
		}

		protected function pickerListInitializer(list:PickerList):void
		{
			list.toggleButtonOnOpenAndClose = true;
			list.popUpContentManager = new DropDownPopUpContentManager();
		}

		protected function pickerListButtonInitializer(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, true);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: 20 * this.scale,
				height: 20 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
			iconSelector.defaultValue = this.pickerListButtonIconUpTexture;
			iconSelector.defaultSelectedValue = this.pickerListButtonIconSelectedTexture;
			skinSelector.setValueForState(this.pickerListButtonIconDisabledTexture, Button.STATE_DISABLED, false);
			iconSelector.displayObjectProperties =
			{
				textureScale: this.scale,
				snapToPixels: true
			};
			button.stateToIconFunction = iconSelector.updateValue;

			this.baseButtonInitializer(button);

			button.minWidth = 100 * this.scale;
			button.gap = Number.POSITIVE_INFINITY; //fill as completely as possible
			button.minGap = 12 * this.scale;
			button.paddingRight = 8 * this.scale;
			button.iconPosition = Button.ICON_POSITION_RIGHT;
			button.horizontalAlign =  Button.HORIZONTAL_ALIGN_LEFT;
		}

		protected function headerInitializer(header:Header):void
		{
			header.minWidth = 30 * this.scale;
			header.minHeight = 30 * this.scale;
			header.paddingTop = header.paddingRight = header.paddingBottom =
				header.paddingLeft = 10 * this.scale;
			header.gap = 4 * this.scale;
			header.titleGap = 6 * this.scale;

			var backgroundSkin:Scale9Image = new Scale9Image(headerSkinTextures, this.scale);
			backgroundSkin.width = 30 * this.scale;
			backgroundSkin.height = 30 * this.scale;
			header.backgroundSkin = backgroundSkin;

			header.titleProperties.textFormat = this.primaryTextFormat;
			header.titleProperties.disabledTextFormat = this.disabledTextFormat;
		}

		protected function panelHeaderInitializer(header:Header):void
		{
			header.minWidth = 30 * this.scale;
			header.minHeight = 30 * this.scale;
			header.paddingTop = header.paddingBottom =
				header.paddingLeft = header.paddingRight = 10 * this.scale;
			header.gap = 4 * this.scale;
			header.titleGap = 6 * this.scale;

			var backgroundSkin:Scale9Image = new Scale9Image(popUpBackgroundSkinTextures, this.scale);
			backgroundSkin.width = 30 * this.scale;
			backgroundSkin.height = 30 * this.scale;
			header.backgroundSkin = backgroundSkin;

			header.titleProperties.textFormat = this.primaryTextFormat;
			header.titleProperties.disabledTextFormat = this.disabledTextFormat;
		}

		protected function panelScreenHeaderInitializer(header:Header):void
		{
			this.panelHeaderInitializer(header);
			header.useExtraPaddingForOSStatusBar = true;
		}

		protected function baseTextInputInitializer(input:TextInput):void
		{
			input.minWidth = input.minHeight = 18 * this.scale;
			input.gap = 4 * this.scale;
			input.paddingTop = input.paddingBottom = 0;
			input.paddingLeft = input.paddingRight = 2 * this.scale;
			input.textEditorProperties.textFormat = new TextFormat("PF Ronda Seven,Roboto,Helvetica,Arial,_sans", this.inputFontSize, PRIMARY_TEXT_COLOR);
			input.textEditorProperties.disabledTextFormat = new TextFormat("PF Ronda Seven,Roboto,Helvetica,Arial,_sans", this.inputFontSize, DISABLED_TEXT_COLOR);
			input.promptProperties.textFormat = this.primaryTextFormat;
			input.promptProperties.disabledTextFormat = this.disabledTextFormat;

			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.insetBackgroundSkinTextures;
			skinSelector.setValueForState(this.insetBackgroundDisabledSkinTextures, TextInput.STATE_DISABLED, false);
			skinSelector.setValueForState(this.insetBackgroundFocusedSkinTextures, TextInput.STATE_FOCUSED, false);
			skinSelector.displayObjectProperties =
			{
				width: 100 * this.scale,
				height: 18 * this.scale
			};
			input.stateToSkinFunction = skinSelector.updateValue;
		}

		protected function textInputInitializer(input:TextInput):void
		{
			this.baseTextInputInitializer(input);
		}

		protected function searchTextInputInitializer(input:TextInput):void
		{
			this.baseTextInputInitializer(input);

			var searchIcon:ImageLoader = new ImageLoader();
			searchIcon.source = this.searchIconTexture;
			searchIcon.snapToPixels = true;
			input.defaultIcon = searchIcon;
		}

		protected function textAreaInitializer(textArea:TextArea):void
		{
			textArea.textEditorProperties.textFormat = new TextFormat("PF Ronda Seven,Roboto,Helvetica,Arial,_sans", this.fontSize, PRIMARY_TEXT_COLOR);
			textArea.textEditorProperties.disabledTextFormat = new TextFormat("PF Ronda Seven,Roboto,Helvetica,Arial,_sans", this.fontSize, DISABLED_TEXT_COLOR);

			textArea.paddingTop = 14 * this.scale;
			textArea.paddingBottom = 8 * this.scale;
			textArea.paddingLeft = textArea.paddingRight = 16 * this.scale;

			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.insetBackgroundSkinTextures;
			skinSelector.setValueForState(this.insetBackgroundDisabledSkinTextures, TextInput.STATE_DISABLED, false);
			skinSelector.setValueForState(this.insetBackgroundFocusedSkinTextures, TextInput.STATE_FOCUSED, false);
			skinSelector.displayObjectProperties =
			{
				width: 200 * this.scale,
				height: 100 * this.scale
			};
			textArea.stateToSkinFunction = skinSelector.updateValue;

			textArea.interactionMode = ScrollContainer.INTERACTION_MODE_MOUSE;
			textArea.scrollBarDisplayMode = ScrollContainer.SCROLL_BAR_DISPLAY_MODE_FIXED;
			textArea.horizontalScrollBarFactory = scrollBarFactory;
			textArea.verticalScrollBarFactory = scrollBarFactory;
		}

		protected function numericStepperTextInputInitializer(input:TextInput):void
		{
			input.minWidth = input.minHeight = 18 * this.scale;
			input.gap = 4 * this.scale;
			input.paddingTop = input.paddingBottom = 0;
			input.paddingLeft = input.paddingRight = 2 * this.scale;
			input.textEditorProperties.textFormat = new TextFormat("PF Ronda Seven,Roboto,Helvetica,Arial,_sans", this.inputFontSize, PRIMARY_TEXT_COLOR, null, null, null, null, null, TextFormatAlign.CENTER);
			input.textEditorProperties.disabledTextFormat = new TextFormat("PF Ronda Seven,Roboto,Helvetica,Arial,_sans", this.inputFontSize, DISABLED_TEXT_COLOR, null, null, null, null, null, TextFormatAlign.CENTER);

			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.insetBackgroundSkinTextures;
			skinSelector.setValueForState(this.insetBackgroundDisabledSkinTextures, TextInput.STATE_DISABLED, false);
			skinSelector.setValueForState(this.insetBackgroundFocusedSkinTextures, TextInput.STATE_FOCUSED, false);
			skinSelector.displayObjectProperties =
			{
				width: 18 * this.scale,
				height: 18 * this.scale
			};
			input.stateToSkinFunction = skinSelector.updateValue;
		}

		protected function pageIndicatorInitializer(pageIndicator:PageIndicator):void
		{
			pageIndicator.interactionMode = PageIndicator.INTERACTION_MODE_PRECISE;
			pageIndicator.normalSymbolFactory = this.pageIndicatorNormalSymbolFactory;
			pageIndicator.selectedSymbolFactory = this.pageIndicatorSelectedSymbolFactory;
			pageIndicator.gap = 4 * this.scale;
			pageIndicator.paddingTop = pageIndicator.paddingRight = pageIndicator.paddingBottom =
				pageIndicator.paddingLeft = 4 * this.scale;
		}

		protected function progressBarInitializer(progress:ProgressBar):void
		{
			var backgroundSkin:Scale9Image = new Scale9Image(insetBackgroundSkinTextures, this.scale);
			backgroundSkin.width = (progress.direction == ProgressBar.DIRECTION_HORIZONTAL ? 100 : 16) * this.scale;
			backgroundSkin.height = (progress.direction == ProgressBar.DIRECTION_HORIZONTAL ? 16 : 100) * this.scale;
			progress.backgroundSkin = backgroundSkin;

			var backgroundDisabledSkin:Scale9Image = new Scale9Image(insetBackgroundDisabledSkinTextures, this.scale);
			backgroundDisabledSkin.width = (progress.direction == ProgressBar.DIRECTION_HORIZONTAL ? 100 : 16) * this.scale;
			backgroundDisabledSkin.height = (progress.direction == ProgressBar.DIRECTION_HORIZONTAL ? 16 : 100) * this.scale;
			progress.backgroundDisabledSkin = backgroundDisabledSkin;

			var fillSkin:Scale9Image = new Scale9Image(buttonUpSkinTextures, this.scale);
			fillSkin.width = 16 * this.scale;
			fillSkin.height = 16 * this.scale;
			progress.fillSkin = fillSkin;

			var fillDisabledSkin:Scale9Image = new Scale9Image(buttonDisabledSkinTextures, this.scale);
			fillDisabledSkin.width = 16 * this.scale;
			fillDisabledSkin.height = 16 * this.scale;
			progress.fillDisabledSkin = fillDisabledSkin;
		}

		protected function calloutInitializer(callout:Callout):void
		{
			callout.minWidth = 20 * this.scale;
			callout.minHeight = 20 * this.scale;
			callout.paddingTop = callout.paddingRight = callout.paddingBottom =
				callout.paddingLeft = 4 * this.scale;
			var backgroundSkin:Scale9Image = new Scale9Image(popUpBackgroundSkinTextures, this.scale);
			backgroundSkin.width = 20 * this.scale;
			backgroundSkin.height = 20 * this.scale;
			callout.backgroundSkin = backgroundSkin;

			var topArrowSkin:Image = new Image(calloutTopArrowSkinTexture);
			topArrowSkin.scaleX = topArrowSkin.scaleY = this.scale;
			callout.topArrowSkin = topArrowSkin;
			callout.topArrowGap = -2 * this.scale;

			var bottomArrowSkin:Image = new Image(calloutBottomArrowSkinTexture);
			bottomArrowSkin.scaleX = bottomArrowSkin.scaleY = this.scale;
			callout.bottomArrowSkin = bottomArrowSkin;
			callout.bottomArrowGap = -2 * this.scale;

			var leftArrowSkin:Image = new Image(calloutLeftArrowSkinTexture);
			leftArrowSkin.scaleX = leftArrowSkin.scaleY = this.scale;
			callout.leftArrowSkin = leftArrowSkin;
			callout.leftArrowGap = -2 * this.scale;

			var rightArrowSkin:Image = new Image(calloutRightArrowSkinTexture);
			rightArrowSkin.scaleX = rightArrowSkin.scaleY = this.scale;
			callout.rightArrowSkin = rightArrowSkin;
			callout.rightArrowGap = -2 * this.scale;
		}

		protected function panelInitializer(panel:Panel):void
		{
			var backgroundSkin:Scale9Image = new Scale9Image(popUpBackgroundSkinTextures, this.scale);
			backgroundSkin.width = 20 * this.scale;
			backgroundSkin.height = 20 * this.scale;
			panel.backgroundSkin = backgroundSkin;

			panel.paddingTop = panel.paddingRight = panel.paddingBottom =
				panel.paddingLeft = 14 * this.scale;

			panel.interactionMode = ScrollContainer.INTERACTION_MODE_MOUSE;
			panel.scrollBarDisplayMode = ScrollContainer.SCROLL_BAR_DISPLAY_MODE_FIXED;
			panel.horizontalScrollBarFactory = scrollBarFactory;
			panel.verticalScrollBarFactory = scrollBarFactory;
		}

		protected function alertInitializer(alert:Alert):void
		{
			var backgroundSkin:Scale9Image = new Scale9Image(this.popUpBackgroundSkinTextures, this.scale);
			backgroundSkin.width = 20 * this.scale;
			backgroundSkin.height = 20 * this.scale;
			alert.backgroundSkin = backgroundSkin;

			alert.paddingTop = alert.paddingBottom = 4 * this.scale;
			alert.paddingLeft = alert.paddingRight = 8 * this.scale;
			alert.gap = 4 * this.scale;

			alert.maxWidth = alert.maxHeight = 200 * this.scale;

			alert.interactionMode = ScrollContainer.INTERACTION_MODE_MOUSE;
			alert.scrollBarDisplayMode = ScrollContainer.SCROLL_BAR_DISPLAY_MODE_FIXED;
			alert.horizontalScrollBarFactory = scrollBarFactory;
			alert.verticalScrollBarFactory = scrollBarFactory;
		}

		protected function scrollContainerInitializer(container:ScrollContainer):void
		{
			container.interactionMode = ScrollContainer.INTERACTION_MODE_MOUSE;
			container.scrollBarDisplayMode = ScrollContainer.SCROLL_BAR_DISPLAY_MODE_FIXED;
			container.horizontalScrollBarFactory = scrollBarFactory;
			container.verticalScrollBarFactory = scrollBarFactory;
		}

		protected function scrollContainerToolbarInitializer(container:ScrollContainer):void
		{
			this.scrollContainerInitializer(container);

			if(!container.layout)
			{
				var layout:HorizontalLayout = new HorizontalLayout();
				layout.paddingTop = layout.paddingRight = layout.paddingBottom =
					layout.paddingLeft = 14 * this.scale;
				layout.gap = 8 * this.scale;
				container.layout = layout;
			}

			container.minWidth = 30 * this.scale;
			container.minHeight = 30 * this.scale;

			var backgroundSkin:Scale9Image = new Scale9Image(headerSkinTextures, this.scale);
			backgroundSkin.width = 30 * this.scale;
			backgroundSkin.height = 30 * this.scale;
			container.backgroundSkin = backgroundSkin;
		}

		protected function drawersInitializer(drawers:Drawers):void
		{
			var overlaySkin:Quad = new Quad(10, 10, MODAL_OVERLAY_COLOR);
			overlaySkin.alpha = MODAL_OVERLAY_ALPHA;
			drawers.overlaySkin = overlaySkin;
		}

		protected function root_addedToStageHandler(event:Event):void
		{
			this.initializeRoot();
		}
	}
}
