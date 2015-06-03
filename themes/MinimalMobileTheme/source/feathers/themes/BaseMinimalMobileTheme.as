/*
 Copyright 2012-2015 Joshua Tynjala

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
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.NumericStepper;
	import feathers.controls.PageIndicator;
	import feathers.controls.Panel;
	import feathers.controls.PanelScreen;
	import feathers.controls.PickerList;
	import feathers.controls.ProgressBar;
	import feathers.controls.Radio;
	import feathers.controls.ScrollContainer;
	import feathers.controls.ScrollScreen;
	import feathers.controls.ScrollText;
	import feathers.controls.Scroller;
	import feathers.controls.SimpleScrollBar;
	import feathers.controls.Slider;
	import feathers.controls.SpinnerList;
	import feathers.controls.TabBar;
	import feathers.controls.TextArea;
	import feathers.controls.TextInput;
	import feathers.controls.ToggleButton;
	import feathers.controls.ToggleSwitch;
	import feathers.controls.popups.CalloutPopUpContentManager;
	import feathers.controls.popups.VerticalCenteredPopUpContentManager;
	import feathers.controls.renderers.BaseDefaultItemRenderer;
	import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.text.BitmapFontTextEditor;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.FeathersControl;
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

	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.textures.SubTexture;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;

	/**
	 * The base class for the "Minimal" theme for mobile Feathers apps. Handles
	 * everything except asset loading, which is left to subclasses.
	 *
	 * @see MinimalMobileTheme
	 * @see MinimalMobileThemeWithAssetManager
	 */
	public class BaseMinimalMobileTheme extends StyleNameFunctionTheme
	{
		/**
		 * The name of the embedded bitmap font used by controls in this theme.
		 */
		public static const FONT_NAME:String = "PF Ronda Seven";

		/**
		 * @private
		 * The theme's custom style name for item renderers in a PickerList.
		 */
		protected static const THEME_STYLE_NAME_PICKER_LIST_ITEM_RENDERER:String = "minimal-mobile-picker-list-item-renderer";

		/**
		 * @private
		 * The theme's custom style name for item renderers in a SpinnerList.
		 */
		protected static const THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER:String = "minimal-mobile-spinner-list-item-renderer";

		/**
		 * @private
		 * The theme's custom style name for the minimum track of a horizontal slider.
		 */
		protected static const THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK:String = "minimal-mobile-horizontal-slider-minimum-track";

		/**
		 * @private
		 * The theme's custom style name for the minimum track of a vertical slider.
		 */
		protected static const THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK:String = "minimal-mobile-vertical-slider-minimum-track";

		protected static const FONT_TEXTURE_NAME:String = "pf_ronda_seven_0";

		protected static const SCALE_9_GRID:Rectangle = new Rectangle(9, 9, 2, 2);
		protected static const BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(5, 5, 1, 1);
		protected static const BUTTON_DOWN_SCALE_9_GRID:Rectangle = new Rectangle(9, 9, 1, 1);
		protected static const SCROLLBAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(1, 1, 2, 2);
		protected static const TAB_SCALE_9_GRID:Rectangle = new Rectangle(25, 21, 1, 1);
		protected static const HEADER_SCALE_9_GRID:Rectangle = new Rectangle(0, 5, 3, 1);
		protected static const LIST_ITEM_SCALE_9_GRID:Rectangle = new Rectangle(5, 5, 1, 1);
		protected static const SPINNER_LIST_SELECTION_OVERLAY_SCALE9_GRID:Rectangle = new Rectangle(0, 5, 1, 1);
		protected static const BACK_BUTTON_SCALE_REGION1:int = 30;
		protected static const BACK_BUTTON_SCALE_REGION2:int = 1;
		protected static const FORWARD_BUTTON_SCALE_REGION1:int = 9;
		protected static const FORWARD_BUTTON_SCALE_REGION2:int = 1;

		protected static const BACKGROUND_COLOR:uint = 0xf3f3f3;
		protected static const LIST_BACKGROUND_COLOR:uint = 0xf8f8f8;
		protected static const LIST_HEADER_BACKGROUND_COLOR:uint = 0xeeeeee;
		protected static const PRIMARY_TEXT_COLOR:uint = 0x666666;
		protected static const DISABLED_TEXT_COLOR:uint = 0x999999;
		protected static const MODAL_OVERLAY_COLOR:uint = 0xcccccc;
		protected static const MODAL_OVERLAY_ALPHA:Number = 0.4;

		/**
		 * The screen density of an iPhone with Retina display. The textures
		 * used by this theme are designed for this density and scale for other
		 * densities.
		 */
		protected static const ORIGINAL_DPI_IPHONE_RETINA:int = 326;

		/**
		 * The screen density of an iPad with Retina display. The textures used
		 * by this theme are designed for this density and scale for other
		 * densities.
		 */
		protected static const ORIGINAL_DPI_IPAD_RETINA:int = 264;

		/**
		 * The default global text renderer factory for this theme creates a
		 * BitmapFontTextRenderer.
		 */
		protected static function textRendererFactory():BitmapFontTextRenderer
		{
			var renderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
			//since it's a pixel font, we don't want to smooth it.
			renderer.smoothing = TextureSmoothing.NONE;
			return renderer;
		}

		/**
		 * The default global text editor factory for this theme creates a
		 * StageTextTextEditor.
		 */
		protected static function textEditorFactory():StageTextTextEditor
		{
			return new StageTextTextEditor();
		}

		/**
		 * The text editor factory for a NumericStepper creates a
		 * BitmapFontTextEditor.
		 */
		protected static function numericStepperTextEditorFactory():BitmapFontTextEditor
		{
			//we're only using this text editor in the NumericStepper because
			//isEditable is false on the TextInput. this text editor is not
			//suitable for mobile use if the TextInput needs to be editable
			//because it can't use the soft keyboard or other mobile-friendly UI
			var editor:BitmapFontTextEditor = new BitmapFontTextEditor();
			//since it's a pixel font, we don't want to smooth it.
			editor.smoothing = TextureSmoothing.NONE;
			return editor;
		}

		protected static function popUpOverlayFactory():DisplayObject
		{
			var quad:Quad = new Quad(100, 100, MODAL_OVERLAY_COLOR);
			quad.alpha = MODAL_OVERLAY_ALPHA;
			return quad;
		}

		/**
		 * This theme's scroll bar type is SimpleScrollBar.
		 */
		protected static function scrollBarFactory():SimpleScrollBar
		{
			return new SimpleScrollBar();
		}

		/**
		 * SmartDisplayObjectValueSelectors will use ImageLoader instead of
		 * Image so that we can use extra features like pixel snapping.
		 */
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

		/**
		 * Constructor.
		 *
		 * @param scaleToDPI Determines if the theme's skins will be scaled based on the screen density and content scale factor.
		 */
		public function BaseMinimalMobileTheme(scaleToDPI:Boolean = true)
		{
			super();
			this._scaleToDPI = scaleToDPI;
		}

		/**
		 * @private
		 */
		protected var _originalDPI:int;

		/**
		 * The original screen density used for scaling.
		 */
		public function get originalDPI():int
		{
			return this._originalDPI;
		}

		/**
		 * @private
		 */
		protected var _scaleToDPI:Boolean;

		/**
		 * Indicates if the theme scales skins to match the screen density of
		 * the device.
		 */
		public function get scaleToDPI():Boolean
		{
			return this._scaleToDPI;
		}

		/**
		 * Skins are scaled by a value based on the screen density on the
		 * content scale factor.
		 */
		protected var scale:Number = 1;

		/**
		 * StageText scales strangely when contentsScaleFactor > 1, so we need
		 * to account for that.
		 */
		protected var stageTextScale:Number = 1;

		/**
		 * A normal font size.
		 */
		protected var fontSize:int;

		/**
		 * A larger font size for headers.
		 */
		protected var largeFontSize:int;

		/**
		 * A smaller font size for details.
		 */
		protected var smallFontSize:int;

		/**
		 * A special font size for text editing.
		 */
		protected var inputFontSize:int;

		/**
		 * The texture atlas that contains skins for this theme. This base class
		 * does not initialize this member variable. Subclasses are expected to
		 * load the assets somehow and set the <code>atlas</code> member
		 * variable before calling <code>initialize()</code>.
		 */
		protected var atlas:TextureAtlas;

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

		protected var tabDownSkinTextures:Scale9Textures;
		protected var tabSelectedSkinTextures:Scale9Textures;
		protected var tabSelectedDisabledSkinTextures:Scale9Textures;

		protected var thumbSkinTextures:Scale9Textures;
		protected var thumbDisabledSkinTextures:Scale9Textures;

		protected var scrollBarThumbSkinTextures:Scale9Textures;

		protected var insetBackgroundSkinTextures:Scale9Textures;
		protected var insetBackgroundDisabledSkinTextures:Scale9Textures;

		protected var dropDownArrowTexture:Texture;
		protected var dropDownDisabledArrowTexture:Texture;
		protected var searchIconTexture:Texture;
		protected var searchIconDisabledTexture:Texture;

		protected var listItemUpTextures:Scale9Textures;
		protected var listItemDownTextures:Scale9Textures;
		protected var listItemSelectedTextures:Scale9Textures;
		protected var pickerListItemSelectedIconTexture:Texture;
		protected var spinnerListSelectionOverlaySkinTextures:Scale9Textures;

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

		/**
		 * The size, in pixels, of major regions in the grid. Used for sizing
		 * containers and larger UI controls.
		 */
		protected var gridSize:int;

		/**
		 * The size, in pixels, of minor regions in the grid. Used for larger
		 * padding and gaps.
		 */
		protected var gutterSize:int;

		/**
		 * The size, in pixels, of smaller padding and gaps within the major
		 * regions in the grid.
		 */
		protected var smallGutterSize:int;

		/**
		 * The width, in pixels, of UI controls that span across multiple grid regions.
		 */
		protected var wideControlSize:int;

		/**
		 * The size, in pixels, of a typical UI control.
		 */
		protected var controlSize:int;

		/**
		 * The size, in pixels, of smaller UI controls.
		 */
		protected var smallControlSize:int;

		/**
		 * The size, in pixels, of a UI control's border.
		 */
		protected var borderSize:int;

		protected var simpleScrollBarThumbSize:int;
		protected var calloutBorderPaddingSize:int;
		protected var calloutBackgroundMinSize:int;
		protected var popUpFillSize:int;

		protected var primaryTextFormat:BitmapFontTextFormat;
		protected var disabledTextFormat:BitmapFontTextFormat;
		protected var centeredTextFormat:BitmapFontTextFormat;
		protected var centeredDisabledTextFormat:BitmapFontTextFormat;
		protected var headingTextFormat:BitmapFontTextFormat;
		protected var headingDisabledTextFormat:BitmapFontTextFormat;
		protected var detailTextFormat:BitmapFontTextFormat;
		protected var detailDisabledTextFormat:BitmapFontTextFormat;

		protected var scrollTextTextFormat:TextFormat;
		protected var scrollTextDisabledTextFormat:TextFormat;

		/**
		 * Disposes the texture atlas and bitmap font before calling
		 * super.dispose().
		 */
		override public function dispose():void
		{
			if(this.atlas)
			{
				//these are saved globally, so we want to clear them out
				if(StandardIcons.listDrillDownAccessoryTexture.root == this.atlas.texture.root)
				{
					StandardIcons.listDrillDownAccessoryTexture = null;
				}
				
				//if anything is keeping a reference to the texture, we don't
				//want it to keep a reference to the theme too.
				this.atlas.texture.root.onRestore = null;
				
				this.atlas.dispose();
				this.atlas = null;
			}
			TextField.unregisterBitmapFont(FONT_NAME);

			//don't forget to call super.dispose()!
			super.dispose();
		}

		/**
		 * Initializes the theme. Expected to be called by subclasses after the
		 * assets have been loaded and the skin texture atlas has been created.
		 */
		protected function initialize():void
		{
			this.initializeScale();
			this.initializeDimensions();
			this.initializeTextures();
			this.initializeFonts();
			this.initializeGlobals();
			this.initializeStage();
			this.initializeStyleProviders();
		}

		/**
		 * Sets the stage background color.
		 */
		protected function initializeStage():void
		{
			Starling.current.stage.color = BACKGROUND_COLOR;
			Starling.current.nativeStage.color = BACKGROUND_COLOR;
		}

		/**
		 * Initializes global variables (not including global style providers).
		 */
		protected function initializeGlobals():void
		{
			PopUpManager.overlayFactory = popUpOverlayFactory;
			Callout.stagePadding = this.smallGutterSize;

			FeathersControl.defaultTextRendererFactory = textRendererFactory;
			FeathersControl.defaultTextEditorFactory = textEditorFactory;
		}

		/**
		 * Initializes the scale value based on the screen density and content
		 * scale factor.
		 */
		protected function initializeScale():void
		{
			var starling:Starling = Starling.current;
			var nativeScaleFactor:Number = 1;
			if(starling.supportHighResolutions)
			{
				nativeScaleFactor = starling.nativeStage.contentsScaleFactor;
			}
			var scaledDPI:int = DeviceCapabilities.dpi / (starling.contentScaleFactor / nativeScaleFactor);
			if(this._scaleToDPI)
			{
				if(DeviceCapabilities.isTablet(starling.nativeStage))
				{
					this._originalDPI = ORIGINAL_DPI_IPAD_RETINA;
				}
				else
				{
					this._originalDPI = ORIGINAL_DPI_IPHONE_RETINA;
				}
			}
			else
			{
				this._originalDPI = scaledDPI;
			}
			//our min scale is 0.25 because lines in the graphics are four
			//pixels wide and this will keep them crisp.
			this.scale = Math.max(0.25, scaledDPI / this._originalDPI);
			this.stageTextScale = this.scale / nativeScaleFactor;
		}

		/**
		 * Initializes common values used for setting the dimensions of components.
		 */
		protected function initializeDimensions():void
		{
			this.gridSize = Math.round(88 * this.scale);
			this.smallGutterSize = Math.round(11 * this.scale);
			this.gutterSize = Math.round(22 * this.scale);
			this.controlSize = Math.round(58 * this.scale);
			this.smallControlSize = Math.round(22 * this.scale);
			this.popUpFillSize = Math.round(552 * this.scale);
			this.wideControlSize = this.gridSize * 3 + this.gutterSize * 2;
			this.borderSize = Math.round(4 * this.scale);
			this.simpleScrollBarThumbSize = Math.round(8 * this.scale);
			this.calloutBackgroundMinSize = Math.round(11 * this.scale);
			this.calloutBorderPaddingSize = -Math.round(8 * this.scale);
		}

		/**
		 * Initializes the textures by extracting them from the atlas and
		 * setting up any scaling grids that are needed.
		 */
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

			this.tabDownSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-down-skin"), TAB_SCALE_9_GRID);
			this.tabSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-skin"), TAB_SCALE_9_GRID);
			this.tabSelectedDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-disabled-skin"), TAB_SCALE_9_GRID);

			this.thumbSkinTextures = new Scale9Textures(this.atlas.getTexture("thumb-skin"), SCALE_9_GRID);
			this.thumbDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("thumb-disabled-skin"), SCALE_9_GRID);

			this.scrollBarThumbSkinTextures = new Scale9Textures(this.atlas.getTexture("scrollbar-thumb-skin"), SCROLLBAR_THUMB_SCALE_9_GRID);

			this.insetBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("inset-background-skin"), SCALE_9_GRID);
			this.insetBackgroundDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("inset-background-disabled-skin"), SCALE_9_GRID);

			this.dropDownArrowTexture = this.atlas.getTexture("drop-down-arrow-icon");
			this.dropDownDisabledArrowTexture = this.atlas.getTexture("drop-down-arrow-icon-disabled");
			this.searchIconTexture = this.atlas.getTexture("search-icon");
			this.searchIconDisabledTexture = this.atlas.getTexture("search-icon-disabled");

			this.listItemUpTextures = new Scale9Textures(this.atlas.getTexture("list-item-up"), LIST_ITEM_SCALE_9_GRID);
			this.listItemDownTextures = new Scale9Textures(this.atlas.getTexture("list-item-down"), LIST_ITEM_SCALE_9_GRID);
			this.listItemSelectedTextures = new Scale9Textures(this.atlas.getTexture("list-item-selected"), LIST_ITEM_SCALE_9_GRID);
			this.pickerListItemSelectedIconTexture = this.atlas.getTexture("picker-list-item-selected-icon");
			this.spinnerListSelectionOverlaySkinTextures = new Scale9Textures(this.atlas.getTexture("spinner-list-selection-overlay-skin"), SPINNER_LIST_SELECTION_OVERLAY_SCALE9_GRID);

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

		/**
		 * Initializes font sizes and formats.
		 */
		protected function initializeFonts():void
		{
			//since it's a pixel font, we want a multiple of the original size,
			//which, in this case, is 8.
			this.fontSize = Math.max(4, roundToNearest(24 * this.scale, 8));
			this.largeFontSize = Math.max(4, roundToNearest(32 * this.scale, 8));
			this.smallFontSize = Math.max(4, roundToNearest(16 * this.scale, 8));
			this.inputFontSize = 26 * this.stageTextScale;

			this.primaryTextFormat = new BitmapFontTextFormat(FONT_NAME, this.fontSize, PRIMARY_TEXT_COLOR);
			this.disabledTextFormat = new BitmapFontTextFormat(FONT_NAME, this.fontSize, DISABLED_TEXT_COLOR);
			this.centeredTextFormat = new BitmapFontTextFormat(FONT_NAME, this.fontSize, PRIMARY_TEXT_COLOR, TextFormatAlign.CENTER);
			this.centeredDisabledTextFormat = new BitmapFontTextFormat(FONT_NAME, this.fontSize, DISABLED_TEXT_COLOR, TextFormatAlign.CENTER);
			this.headingTextFormat = new BitmapFontTextFormat(FONT_NAME, this.largeFontSize, PRIMARY_TEXT_COLOR);
			this.headingDisabledTextFormat = new BitmapFontTextFormat(FONT_NAME, this.largeFontSize, DISABLED_TEXT_COLOR);
			this.detailTextFormat = new BitmapFontTextFormat(FONT_NAME, this.smallFontSize, PRIMARY_TEXT_COLOR);
			this.detailDisabledTextFormat = new BitmapFontTextFormat(FONT_NAME, this.smallFontSize, DISABLED_TEXT_COLOR);

			var scrollTextFontList:String = "PF Ronda Seven,Roboto,Helvetica,Arial,_sans";
			this.scrollTextTextFormat = new TextFormat(scrollTextFontList, this.fontSize, PRIMARY_TEXT_COLOR);
			this.scrollTextDisabledTextFormat = new TextFormat(scrollTextFontList, this.fontSize, DISABLED_TEXT_COLOR);
		}

		/**
		 * Sets global style providers for all components.
		 */
		protected function initializeStyleProviders():void
		{
			//alert
			this.getStyleProviderForClass(Alert).defaultStyleFunction = this.setAlertStyles;
			this.getStyleProviderForClass(Header).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setPanelHeaderStyles);
			this.getStyleProviderForClass(ButtonGroup).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_BUTTON_GROUP, this.setAlertButtonGroupStyles);
			this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_MESSAGE, this.setAlertMessageTextRendererStyles);

			//button
			this.getStyleProviderForClass(Button).defaultStyleFunction = this.setButtonStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_CALL_TO_ACTION_BUTTON, this.setCallToActionButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_DANGER_BUTTON, this.setDangerButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON, this.setBackButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_FORWARD_BUTTON, this.setForwardButtonStyles);

			//button group
			this.getStyleProviderForClass(ButtonGroup).defaultStyleFunction = this.setButtonGroupStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ButtonGroup.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setButtonGroupButtonStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ButtonGroup.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setButtonGroupButtonStyles);

			//callout
			this.getStyleProviderForClass(Callout).defaultStyleFunction = this.setCalloutStyles;

			//check
			this.getStyleProviderForClass(Check).defaultStyleFunction = this.setCheckStyles;

			//check
			this.getStyleProviderForClass(Drawers).defaultStyleFunction = this.setDrawersStyles;

			//grouped list (see also: item renderers)
			this.getStyleProviderForClass(GroupedList).defaultStyleFunction = this.setGroupedListStyles;
			this.getStyleProviderForClass(GroupedList).setFunctionForStyleName(GroupedList.ALTERNATE_STYLE_NAME_INSET_GROUPED_LIST, this.setInsetGroupedListStyles);

			//header
			this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;

			//item renderers for lists
			this.getStyleProviderForClass(DefaultListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_PICKER_LIST_ITEM_RENDERER, this.setPickerListItemRendererStyles);
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER, this.setSpinnerListItemRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL, this.setItemRendererAccessoryLabelStyles);
			this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_ICON_LABEL, this.setItemRendererIconLabelStyles);

			//header and footer renderers for grouped list
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).defaultStyleFunction = this.setGroupedListHeaderOrFooterRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_HEADER_RENDERER, this.setInsetGroupedListHeaderOrFooterRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FOOTER_RENDERER, this.setInsetGroupedListHeaderOrFooterRendererStyles);

			//label
			this.getStyleProviderForClass(Label).defaultStyleFunction = this.setLabelStyles;
			this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_STYLE_NAME_HEADING, this.setHeadingLabelStyles);
			this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_STYLE_NAME_DETAIL, this.setDetailLabelStyles);

			//layout group
			this.getStyleProviderForClass(LayoutGroup).setFunctionForStyleName(LayoutGroup.ALTERNATE_STYLE_NAME_TOOLBAR, this.setToolbarLayoutGroupStyles);

			//list (see also: item renderers)
			this.getStyleProviderForClass(List).defaultStyleFunction = this.setListStyles;

			//numeric stepper
			this.getStyleProviderForClass(NumericStepper).defaultStyleFunction = this.setNumericStepperStyles;
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_TEXT_INPUT, this.setNumericStepperTextInputStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON, this.setNumericStepperButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON, this.setNumericStepperButtonStyles);

			//page indicator
			this.getStyleProviderForClass(PageIndicator).defaultStyleFunction = this.setPageIndicatorStyles;

			//panel
			this.getStyleProviderForClass(Panel).defaultStyleFunction = this.setPanelStyles;
			this.getStyleProviderForClass(Header).setFunctionForStyleName(Panel.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setPanelHeaderStyles);

			//panel screen
			this.getStyleProviderForClass(PanelScreen).defaultStyleFunction = this.setPanelScreenStyles;
			this.getStyleProviderForClass(Header).setFunctionForStyleName(PanelScreen.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setPanelScreenHeaderStyles);

			//picker list (see also: item renderers)
			this.getStyleProviderForClass(PickerList).defaultStyleFunction = this.setPickerListStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setPickerListButtonStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setPickerListButtonStyles);
			this.getStyleProviderForClass(List).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_LIST, this.setNoStyles);

			//progress bar
			this.getStyleProviderForClass(ProgressBar).defaultStyleFunction = this.setProgressBarStyles;

			//radio
			this.getStyleProviderForClass(Radio).defaultStyleFunction = this.setRadioStyles;

			//scroll container
			this.getStyleProviderForClass(ScrollContainer).defaultStyleFunction = this.setScrollContainerStyles;
			this.getStyleProviderForClass(ScrollContainer).setFunctionForStyleName(ScrollContainer.ALTERNATE_STYLE_NAME_TOOLBAR, this.setToolbarScrollContainerStyles);

			//scroll screen
			this.getStyleProviderForClass(ScrollScreen).defaultStyleFunction = this.setScrollScreenStyles;

			//scroll text
			this.getStyleProviderForClass(ScrollText).defaultStyleFunction = this.setScrollTextStyles;

			//simple scroll bar
			this.getStyleProviderForClass(Button).setFunctionForStyleName(SimpleScrollBar.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setSimpleScrollBarThumbStyles);

			//slider
			this.getStyleProviderForClass(Slider).defaultStyleFunction = this.setSliderStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Slider.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setSliderThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK, this.setHorizontalSliderMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK, this.setVerticalSliderMinimumTrackStyles);

			//spinner list
			this.getStyleProviderForClass(SpinnerList).defaultStyleFunction = this.setSpinnerListStyles;

			//tab bar
			this.getStyleProviderForClass(TabBar).defaultStyleFunction = this.setTabBarStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(TabBar.DEFAULT_CHILD_STYLE_NAME_TAB, this.setTabStyles);

			//text input
			this.getStyleProviderForClass(TextInput).defaultStyleFunction = this.setTextInputStyles;
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName(TextInput.ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT, this.setSearchTextInputStyles);

			//text area
			this.getStyleProviderForClass(TextArea).defaultStyleFunction = this.setTextAreaStyles;

			//toggle button
			this.getStyleProviderForClass(ToggleButton).defaultStyleFunction = this.setButtonStyles;
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(Button.ALTERNATE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);

			//toggle switch
			this.getStyleProviderForClass(ToggleSwitch).defaultStyleFunction = this.setToggleSwitchStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setToggleSwitchThumbStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setToggleSwitchThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_ON_TRACK, this.setToggleSwitchOnTrackStyles);
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
			image.smoothing = TextureSmoothing.NONE;
			image.textureScale = this.scale;
			return image;
		}

	//-------------------------
	// Shared
	//-------------------------

		protected function setNoStyles(target:DisplayObject):void
		{
			//if this is assigned as a style function, chances are the target
			//will be a subcomponent of something. the style function for this
			//component's parent is probably handing the styling for the target
		}

		protected function setScrollerStyles(scroller:Scroller):void
		{
			scroller.horizontalScrollBarFactory = scrollBarFactory;
			scroller.verticalScrollBarFactory = scrollBarFactory;
		}

	//-------------------------
	// Alert
	//-------------------------

		protected function setAlertStyles(alert:Alert):void
		{
			this.setScrollerStyles(alert);

			var backgroundSkin:Scale9Image = new Scale9Image(this.popUpBackgroundSkinTextures, this.scale);
			backgroundSkin.width = this.smallGutterSize;
			backgroundSkin.height = this.smallGutterSize;
			alert.backgroundSkin = backgroundSkin;

			alert.paddingTop = this.smallGutterSize;
			alert.paddingBottom = this.smallGutterSize;
			alert.paddingLeft = this.gutterSize;
			alert.paddingRight = this.gutterSize;
			alert.gap = this.gutterSize;

			alert.maxWidth = this.popUpFillSize;
			alert.maxHeight = this.popUpFillSize;
		}

		protected function setAlertButtonGroupStyles(group:ButtonGroup):void
		{
			group.direction = ButtonGroup.DIRECTION_VERTICAL;
			group.horizontalAlign = ButtonGroup.HORIZONTAL_ALIGN_JUSTIFY;
			group.verticalAlign = ButtonGroup.VERTICAL_ALIGN_JUSTIFY;
			group.gap = this.smallGutterSize;
			group.padding = this.smallGutterSize;
		}

		protected function setAlertMessageTextRendererStyles(renderer:BitmapFontTextRenderer):void
		{
			renderer.wordWrap = true;
			renderer.textFormat = this.primaryTextFormat;
		}

	//-------------------------
	// Button
	//-------------------------

		protected function setBaseButtonStyles(button:Button):void
		{
			button.defaultLabelProperties.textFormat = this.primaryTextFormat;
			button.disabledLabelProperties.textFormat = this.disabledTextFormat;
			if(button is ToggleButton)
			{
				ToggleButton(button).selectedDisabledLabelProperties.textFormat = this.disabledTextFormat;
			}

			button.paddingTop = this.smallGutterSize;
			button.paddingBottom = this.smallGutterSize;
			button.paddingLeft = this.gutterSize;
			button.paddingRight = this.gutterSize;
			button.gap = this.smallGutterSize;
			button.minGap = this.smallGutterSize;
			button.minWidth = this.controlSize;
			button.minHeight = this.controlSize;
			button.minTouchWidth = this.gridSize;
			button.minTouchHeight = this.gridSize;
		}

		protected function setButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				skinSelector.defaultSelectedValue = this.buttonSelectedSkinTextures;
				skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, true);
				skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			}
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
		}

		protected function setCallToActionButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonCallToActionUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
		}

		protected function setQuietButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = null;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(null, Button.STATE_DISABLED, false);
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				skinSelector.defaultSelectedValue = this.buttonSelectedSkinTextures;
				skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, true);
				skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			}
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
		}

		protected function setDangerButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonDangerUpSkinTextures;
			skinSelector.setValueForState(this.buttonDangerDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
		}

		protected function setBackButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonBackUpSkinTextures;
			skinSelector.setValueForState(this.buttonBackDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonBackDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
			button.paddingLeft = this.gutterSize + this.smallGutterSize;
		}

		protected function setForwardButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonForwardUpSkinTextures;
			skinSelector.setValueForState(this.buttonForwardDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonForwardDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
			button.paddingRight = this.gutterSize + this.smallGutterSize;
		}

	//-------------------------
	// ButtonGroup
	//-------------------------

		protected function setButtonGroupStyles(group:ButtonGroup):void
		{
			group.minWidth = this.popUpFillSize;
			group.gap = this.smallGutterSize;
		}

		protected function setButtonGroupButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				skinSelector.defaultSelectedValue = this.buttonSelectedSkinTextures;
				skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, true);
				skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			}
			skinSelector.displayObjectProperties =
			{
				width: this.gridSize,
				height: this.gridSize,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.defaultLabelProperties.textFormat = this.primaryTextFormat;
			button.disabledLabelProperties.textFormat = this.disabledTextFormat;
			if(button is ToggleButton)
			{
				ToggleButton(button).selectedDisabledLabelProperties.textFormat = this.disabledTextFormat;
			}

			button.paddingTop = this.smallGutterSize;
			button.paddingBottom = this.smallGutterSize;
			button.paddingLeft = this.gutterSize;
			button.paddingRight = this.gutterSize;
			button.gap = this.smallGutterSize;
			button.minGap = this.smallGutterSize;
			button.minWidth = this.gridSize;
			button.minHeight = this.gridSize;
			button.minTouchWidth = this.gridSize;
			button.minTouchHeight = this.gridSize;
		}

	//-------------------------
	// Callout
	//-------------------------

		protected function setCalloutStyles(callout:Callout):void
		{
			callout.minWidth = this.calloutBackgroundMinSize;
			callout.minHeight = this.calloutBackgroundMinSize;
			callout.padding = this.smallGutterSize;
			var backgroundSkin:Scale9Image = new Scale9Image(popUpBackgroundSkinTextures, this.scale);
			backgroundSkin.width = this.calloutBackgroundMinSize;
			backgroundSkin.height = this.calloutBackgroundMinSize;
			callout.backgroundSkin = backgroundSkin;

			var topArrowSkin:Image = new Image(calloutTopArrowSkinTexture);
			topArrowSkin.scaleX = topArrowSkin.scaleY = this.scale;
			callout.topArrowSkin = topArrowSkin;
			callout.topArrowGap = this.calloutBorderPaddingSize;

			var bottomArrowSkin:Image = new Image(calloutBottomArrowSkinTexture);
			bottomArrowSkin.scaleX = bottomArrowSkin.scaleY = this.scale;
			callout.bottomArrowSkin = bottomArrowSkin;
			callout.bottomArrowGap = this.calloutBorderPaddingSize;

			var leftArrowSkin:Image = new Image(calloutLeftArrowSkinTexture);
			leftArrowSkin.scaleX = leftArrowSkin.scaleY = this.scale;
			callout.leftArrowSkin = leftArrowSkin;
			callout.leftArrowGap = this.calloutBorderPaddingSize;

			var rightArrowSkin:Image = new Image(calloutRightArrowSkinTexture);
			rightArrowSkin.scaleX = rightArrowSkin.scaleY = this.scale;
			callout.rightArrowSkin = rightArrowSkin;
			callout.rightArrowGap = this.calloutBorderPaddingSize;
		}

	//-------------------------
	// Check
	//-------------------------

		protected function setCheckStyles(check:Check):void
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
				snapToPixels: true
			};
			check.stateToIconFunction = iconSelector.updateValue;

			check.defaultLabelProperties.textFormat = this.primaryTextFormat;
			check.disabledLabelProperties.textFormat = this.disabledTextFormat;
			check.selectedDisabledLabelProperties.textFormat = this.disabledTextFormat;

			check.gap = this.smallGutterSize;
			check.minWidth = this.controlSize;
			check.minHeight = this.controlSize;
			check.minTouchWidth = this.gridSize;
			check.minTouchHeight = this.gridSize;
			check.horizontalAlign = Check.HORIZONTAL_ALIGN_LEFT;
			check.verticalAlign = Check.VERTICAL_ALIGN_MIDDLE;
		}

	//-------------------------
	// Drawers
	//-------------------------

		protected function setDrawersStyles(drawers:Drawers):void
		{
			var overlaySkin:Quad = new Quad(10, 10, MODAL_OVERLAY_COLOR);
			overlaySkin.alpha = MODAL_OVERLAY_ALPHA;
			drawers.overlaySkin = overlaySkin;
		}

	//-------------------------
	// GroupedList
	//-------------------------

		protected function setGroupedListStyles(list:GroupedList):void
		{
			this.setScrollerStyles(list);

			var backgroundSkin:Quad = new Quad(this.gridSize, this.gridSize, LIST_BACKGROUND_COLOR);
			list.backgroundSkin = backgroundSkin;
		}

		//see List section for item renderer styles

		protected function setGroupedListHeaderOrFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			renderer.backgroundSkin = new Quad(1, 1, LIST_HEADER_BACKGROUND_COLOR);

			renderer.contentLabelProperties.textFormat = this.primaryTextFormat;
			renderer.contentLabelProperties.disabledTextFormat = this.disabledTextFormat;

			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;
			renderer.paddingRight = this.gutterSize;

			renderer.contentLoaderFactory = this.imageLoaderFactory;
		}

		protected function setInsetGroupedListStyles(list:GroupedList):void
		{
			this.setScrollerStyles(list);

			list.customHeaderRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_HEADER_RENDERER;
			list.customFooterRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FOOTER_RENDERER;

			var layout:VerticalLayout = new VerticalLayout();
			layout.useVirtualLayout = true;
			layout.padding = this.gutterSize;
			layout.paddingTop = 0;
			layout.gap = 0;
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			list.layout = layout;
		}

		protected function setInsetGroupedListHeaderOrFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			renderer.contentLabelProperties.textFormat = this.primaryTextFormat;
			renderer.contentLabelProperties.disabledTextFormat = this.disabledTextFormat;

			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;
			renderer.paddingRight = this.gutterSize;
			renderer.minWidth = this.controlSize;
			renderer.minHeight = this.controlSize;

			renderer.contentLoaderFactory = this.imageLoaderFactory;
		}

	//-------------------------
	// Header
	//-------------------------

		protected function setHeaderStyles(header:Header):void
		{
			header.minWidth = this.gridSize;
			header.minHeight = this.gridSize;
			header.padding = this.smallGutterSize;
			header.gap = this.smallGutterSize;
			header.titleGap = this.smallGutterSize;

			var backgroundSkin:Scale9Image = new Scale9Image(headerSkinTextures, this.scale);
			backgroundSkin.width = this.gridSize;
			backgroundSkin.height = this.gridSize;
			header.backgroundSkin = backgroundSkin;

			header.titleProperties.textFormat = this.primaryTextFormat;
			header.titleProperties.disabledTextFormat = this.disabledTextFormat;
		}

	//-------------------------
	// Label
	//-------------------------

		protected function setLabelStyles(label:Label):void
		{
			label.textRendererProperties.textFormat = this.primaryTextFormat;
			label.textRendererProperties.disabledTextFormat = this.disabledTextFormat;
		}

		protected function setHeadingLabelStyles(label:Label):void
		{
			label.textRendererProperties.textFormat = this.headingTextFormat;
			label.textRendererProperties.disabledTextFormat = this.headingDisabledTextFormat;
		}

		protected function setDetailLabelStyles(label:Label):void
		{
			label.textRendererProperties.textFormat = this.detailTextFormat;
			label.textRendererProperties.disabledTextFormat = this.detailDisabledTextFormat;
		}

	//-------------------------
	// LayoutGroup
	//-------------------------

		protected function setToolbarLayoutGroupStyles(group:LayoutGroup):void
		{
			if(!group.layout)
			{
				var layout:HorizontalLayout = new HorizontalLayout();
				layout.padding = this.smallGutterSize;
				layout.gap = this.smallGutterSize;
				group.layout = layout;
			}

			group.minWidth = this.gridSize;
			group.minHeight = this.gridSize;

			var backgroundSkin:Scale9Image = new Scale9Image(this.headerSkinTextures, this.scale);
			backgroundSkin.width = this.gridSize;
			backgroundSkin.height = this.gridSize;
			group.backgroundSkin = backgroundSkin;
		}

	//-------------------------
	// List
	//-------------------------

		protected function setListStyles(list:List):void
		{
			this.setScrollerStyles(list);

			list.backgroundSkin = new Quad(this.gridSize, this.gridSize, LIST_BACKGROUND_COLOR);
		}

		protected function setItemRendererStyles(renderer:BaseDefaultItemRenderer):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.listItemUpTextures;
			skinSelector.defaultSelectedValue = this.listItemSelectedTextures;
			skinSelector.setValueForState(this.listItemDownTextures, Button.STATE_DOWN, false);
			skinSelector.displayObjectProperties =
			{
				width: this.gridSize,
				height: this.gridSize,
				textureScale: this.scale
			};
			renderer.stateToSkinFunction = skinSelector.updateValue;

			renderer.defaultLabelProperties.textFormat = this.primaryTextFormat;
			renderer.disabledLabelProperties.textFormat = this.disabledTextFormat;
			renderer.selectedDisabledLabelProperties.textFormat = this.disabledTextFormat;

			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;
			renderer.paddingRight = this.gutterSize;
			renderer.gap = this.gutterSize;
			renderer.minGap = this.gutterSize;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.minAccessoryGap = this.gutterSize;
			renderer.minWidth = this.gridSize;
			renderer.minHeight = this.gridSize;
			renderer.minTouchWidth = this.gridSize;
			renderer.minTouchHeight = this.gridSize;
			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			renderer.iconPosition = Button.ICON_POSITION_LEFT;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;

			renderer.accessoryLoaderFactory = this.imageLoaderFactory;
			renderer.iconLoaderFactory = this.imageLoaderFactory;
		}

		protected function setItemRendererAccessoryLabelStyles(renderer:BitmapFontTextRenderer):void
		{
			renderer.textFormat = this.primaryTextFormat;
		}

		protected function setItemRendererIconLabelStyles(renderer:BitmapFontTextRenderer):void
		{
			renderer.textFormat = this.primaryTextFormat;
		}

	//-------------------------
	// NumericStepper
	//-------------------------

		protected function setNumericStepperStyles(stepper:NumericStepper):void
		{
			stepper.buttonLayoutMode = NumericStepper.BUTTON_LAYOUT_MODE_SPLIT_HORIZONTAL;
			stepper.incrementButtonLabel = "+";
			stepper.decrementButtonLabel = "-";
		}

		protected function setNumericStepperTextInputStyles(input:TextInput):void
		{
			input.minWidth = this.controlSize;
			input.minHeight = this.controlSize;
			input.minTouchWidth = this.gridSize;
			input.minTouchHeight = this.gridSize;
			input.gap = this.smallGutterSize;
			input.padding = this.smallGutterSize;
			input.isEditable = false;
			input.textEditorFactory = numericStepperTextEditorFactory;
			input.textEditorProperties.textFormat = this.centeredTextFormat;
			input.textEditorProperties.disabledTextFormat = this.centeredDisabledTextFormat;

			var backgroundSkin:Scale9Image = new Scale9Image(insetBackgroundSkinTextures, this.scale);
			backgroundSkin.width = this.controlSize;
			backgroundSkin.height = this.controlSize;
			input.backgroundSkin = backgroundSkin;

			var backgroundDisabledSkin:Scale9Image = new Scale9Image(insetBackgroundDisabledSkinTextures, this.scale);
			backgroundDisabledSkin.width = this.controlSize;
			backgroundDisabledSkin.height = this.controlSize;
			input.backgroundDisabledSkin = backgroundDisabledSkin;
		}

		protected function setNumericStepperButtonStyles(button:Button):void
		{
			this.setButtonStyles(button);
			button.keepDownStateOnRollOut = true;
		}

	//-------------------------
	// PageIndicator
	//-------------------------

		protected function setPageIndicatorStyles(pageIndicator:PageIndicator):void
		{
			pageIndicator.normalSymbolFactory = this.pageIndicatorNormalSymbolFactory;
			pageIndicator.selectedSymbolFactory = this.pageIndicatorSelectedSymbolFactory;
			pageIndicator.gap = this.smallGutterSize;
			pageIndicator.padding = this.smallGutterSize;
			pageIndicator.minTouchWidth = this.smallControlSize * 2;
			pageIndicator.minTouchHeight = this.smallControlSize * 2;
		}

	//-------------------------
	// Panel
	//-------------------------

		protected function setPanelStyles(panel:Panel):void
		{
			this.setScrollerStyles(panel);

			var backgroundSkin:Scale9Image = new Scale9Image(popUpBackgroundSkinTextures, this.scale);
			backgroundSkin.width = this.smallControlSize;
			backgroundSkin.height = this.smallControlSize;
			panel.backgroundSkin = backgroundSkin;

			panel.padding = this.smallGutterSize;
		}

		protected function setPanelHeaderStyles(header:Header):void
		{
			header.minWidth = this.gridSize;
			header.minHeight = this.gridSize;
			header.padding = this.smallGutterSize;
			header.gap = this.smallGutterSize;
			header.titleGap = this.smallGutterSize;

			var backgroundSkin:Scale9Image = new Scale9Image(popUpBackgroundSkinTextures, this.scale);
			backgroundSkin.width = this.gridSize;
			backgroundSkin.height = this.gridSize;
			header.backgroundSkin = backgroundSkin;

			header.titleProperties.textFormat = this.primaryTextFormat;
			header.titleProperties.disabledTextFormat = this.disabledTextFormat;
		}

	//-------------------------
	// PanelScreen
	//-------------------------

		protected function setPanelScreenStyles(screen:PanelScreen):void
		{
			this.setScrollerStyles(screen);
		}

		protected function setPanelScreenHeaderStyles(header:Header):void
		{
			this.setPanelHeaderStyles(header);
			header.useExtraPaddingForOSStatusBar = true;
		}

	//-------------------------
	// PickerList
	//-------------------------

		protected function setPickerListStyles(list:PickerList):void
		{
			if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				list.popUpContentManager = new CalloutPopUpContentManager();
			}
			else
			{
				var centerStage:VerticalCenteredPopUpContentManager = new VerticalCenteredPopUpContentManager();
				centerStage.marginTop = centerStage.marginRight = centerStage.marginBottom =
					centerStage.marginLeft = this.gutterSize;
				list.popUpContentManager = centerStage;
			}

			var layout:VerticalLayout = new VerticalLayout();
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_BOTTOM;
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			layout.useVirtualLayout = true;
			layout.gap = 0;
			layout.padding = 0;
			list.listProperties.layout = layout;
			list.listProperties.verticalScrollPolicy = List.SCROLL_POLICY_ON;

			if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				list.listProperties.minWidth = this.popUpFillSize;
				list.listProperties.maxHeight = this.popUpFillSize;
			}
			else
			{
				var backgroundSkin:Scale9Image = new Scale9Image(popUpBackgroundSkinTextures, this.scale);
				backgroundSkin.width = this.gridSize;
				backgroundSkin.height = this.gridSize;
				list.listProperties.backgroundSkin = backgroundSkin;
				list.listProperties.padding = this.borderSize;
			}

			list.listProperties.customItemRendererStyleName = THEME_STYLE_NAME_PICKER_LIST_ITEM_RENDERER;
		}

		protected function setPickerListItemRendererStyles(renderer:BaseDefaultItemRenderer):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.listItemUpTextures;
			skinSelector.setValueForState(this.listItemDownTextures, Button.STATE_DOWN, false);
			skinSelector.displayObjectProperties =
			{
				width: this.gridSize,
				height: this.gridSize,
				textureScale: this.scale
			};
			renderer.stateToSkinFunction = skinSelector.updateValue;

			var defaultSelectedIcon:ImageLoader = new ImageLoader();
			defaultSelectedIcon.source = this.pickerListItemSelectedIconTexture;
			defaultSelectedIcon.textureScale = this.scale;
			defaultSelectedIcon.snapToPixels = true;
			renderer.defaultSelectedIcon = defaultSelectedIcon;

			var frame:Rectangle = this.pickerListItemSelectedIconTexture.frame;
			if(frame)
			{
				var iconWidth:Number = frame.width;
				var iconHeight:Number = frame.height;
			}
			else
			{
				iconWidth = this.pickerListItemSelectedIconTexture.width;
				iconHeight = this.pickerListItemSelectedIconTexture.height;
			}
			var defaultIcon:Quad = new Quad(iconWidth, iconHeight, 0xff00ff);
			defaultIcon.alpha = 0;
			renderer.defaultIcon = defaultIcon;

			renderer.defaultLabelProperties.textFormat = this.primaryTextFormat;
			renderer.disabledLabelProperties.textFormat = this.disabledTextFormat;
			renderer.selectedDisabledLabelProperties.textFormat = this.disabledTextFormat;

			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;
			renderer.paddingRight = this.gutterSize;
			renderer.gap = Number.POSITIVE_INFINITY;
			renderer.minGap = this.gutterSize;
			renderer.iconPosition = Button.ICON_POSITION_RIGHT;
			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.minAccessoryGap = this.gutterSize;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
			renderer.minWidth = this.gridSize;
			renderer.minHeight = this.gridSize;
			renderer.minTouchWidth = this.gridSize;
			renderer.minTouchHeight = this.gridSize;

			renderer.accessoryLoaderFactory = this.imageLoaderFactory;
			renderer.iconLoaderFactory = this.imageLoaderFactory;
		}

		protected function setPickerListButtonStyles(button:Button):void
		{
			//we're going to expand on the standard button styles
			this.setButtonStyles(button);

			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
			iconSelector.defaultValue = this.dropDownArrowTexture;
			iconSelector.setValueForState(this.dropDownDisabledArrowTexture, Button.STATE_DISABLED, false);
			iconSelector.setValueForState(this.dropDownDisabledArrowTexture, Button.STATE_DISABLED, true);
			iconSelector.displayObjectProperties =
			{
				textureScale: this.scale,
				snapToPixels: true
			};
			button.stateToIconFunction = iconSelector.updateValue;

			button.gap = Number.POSITIVE_INFINITY; //fill as completely as possible
			button.minGap = this.gutterSize;
			button.iconPosition = Button.ICON_POSITION_RIGHT;
			button.horizontalAlign =  Button.HORIZONTAL_ALIGN_LEFT;
		}

	//-------------------------
	// ProgressBar
	//-------------------------

		protected function setProgressBarStyles(progress:ProgressBar):void
		{
			var backgroundSkin:Scale9Image = new Scale9Image(insetBackgroundSkinTextures, this.scale);
			if(progress.direction == ProgressBar.DIRECTION_VERTICAL)
			{
				backgroundSkin.width = this.smallControlSize;
				backgroundSkin.height = this.wideControlSize;
			}
			else
			{
				backgroundSkin.width = this.wideControlSize;
				backgroundSkin.height = this.smallControlSize;
			}
			progress.backgroundSkin = backgroundSkin;

			var backgroundDisabledSkin:Scale9Image = new Scale9Image(insetBackgroundDisabledSkinTextures, this.scale);
			if(progress.direction == ProgressBar.DIRECTION_VERTICAL)
			{
				backgroundDisabledSkin.width = this.smallControlSize;
				backgroundDisabledSkin.height = this.wideControlSize;
			}
			else
			{
				backgroundDisabledSkin.width = this.wideControlSize;
				backgroundDisabledSkin.height = this.smallControlSize;
			}
			progress.backgroundDisabledSkin = backgroundDisabledSkin;

			var fillSkin:Scale9Image = new Scale9Image(buttonUpSkinTextures, this.scale);
			if(progress.direction == ProgressBar.DIRECTION_VERTICAL)
			{
				fillSkin.width = this.smallGutterSize;
				fillSkin.height = this.borderSize;
			}
			else
			{
				fillSkin.width = this.borderSize;
				fillSkin.height = this.smallGutterSize;
			}
			progress.fillSkin = fillSkin;

			var fillDisabledSkin:Scale9Image = new Scale9Image(buttonDisabledSkinTextures, this.scale);
			if(progress.direction == ProgressBar.DIRECTION_VERTICAL)
			{
				fillDisabledSkin.width = this.smallGutterSize;
				fillDisabledSkin.height = this.borderSize;
			}
			else
			{
				fillDisabledSkin.width = this.borderSize;
				fillDisabledSkin.height = this.smallGutterSize;
			}
			progress.fillDisabledSkin = fillDisabledSkin;
		}

	//-------------------------
	// Radio
	//-------------------------

		protected function setRadioStyles(radio:Radio):void
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
			radio.disabledLabelProperties.textFormat = this.disabledTextFormat;
			radio.selectedDisabledLabelProperties.textFormat = this.disabledTextFormat;

			radio.gap = this.smallGutterSize;
			radio.minWidth = this.controlSize;
			radio.minHeight = this.controlSize;
			radio.minTouchWidth = this.gridSize;
			radio.minTouchHeight = this.gridSize;
			radio.horizontalAlign = Radio.HORIZONTAL_ALIGN_LEFT;
			radio.verticalAlign = Radio.VERTICAL_ALIGN_MIDDLE;
		}

	//-------------------------
	// ScrollContainer
	//-------------------------

		protected function setScrollContainerStyles(container:ScrollContainer):void
		{
			this.setScrollerStyles(container);
		}

		protected function setToolbarScrollContainerStyles(container:ScrollContainer):void
		{
			this.setScrollerStyles(container);

			if(!container.layout)
			{
				var layout:HorizontalLayout = new HorizontalLayout();
				layout.padding = this.smallGutterSize;
				layout.gap = this.smallGutterSize;
				container.layout = layout;
			}

			container.minWidth = this.gridSize;
			container.minHeight = this.gridSize;

			var backgroundSkin:Scale9Image = new Scale9Image(headerSkinTextures, this.scale);
			backgroundSkin.width = this.gridSize;
			backgroundSkin.height = this.gridSize;
			container.backgroundSkin = backgroundSkin;
		}

	//-------------------------
	// ScrollScreen
	//-------------------------

		protected function setScrollScreenStyles(screen:ScrollScreen):void
		{
			this.setScrollerStyles(screen);
		}

	//-------------------------
	// ScrollText
	//-------------------------

		protected function setScrollTextStyles(text:ScrollText):void
		{
			this.setScrollerStyles(text);
			text.textFormat = this.scrollTextTextFormat;
			text.disabledTextFormat = this.scrollTextDisabledTextFormat;
			text.padding = this.gutterSize;
			text.paddingRight = this.gutterSize + this.smallGutterSize;
		}

	//-------------------------
	// SimpleScrollBar
	//-------------------------

		protected function setSimpleScrollBarThumbStyles(thumb:Button):void
		{
			var defaultSkin:Scale9Image = new Scale9Image(scrollBarThumbSkinTextures, this.scale);
			defaultSkin.width = this.simpleScrollBarThumbSize;
			defaultSkin.height = this.simpleScrollBarThumbSize;
			thumb.defaultSkin = defaultSkin;

			thumb.minTouchWidth = this.smallControlSize;
			thumb.minTouchHeight = this.smallControlSize;

			thumb.hasLabelTextRenderer = false;
		}

	//-------------------------
	// Slider
	//-------------------------

		protected function setSliderStyles(slider:Slider):void
		{
			slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_SINGLE;

			if(slider.direction == Slider.DIRECTION_VERTICAL)
			{
				slider.customMinimumTrackStyleName = THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK;
			}
			else //horizontal
			{
				slider.customMinimumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK;
			}
		}

		protected function setHorizontalSliderMinimumTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.insetBackgroundSkinTextures;
			skinSelector.setValueForState(this.insetBackgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: this.wideControlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			track.stateToSkinFunction = skinSelector.updateValue;

			track.hasLabelTextRenderer = false;
		}

		protected function setVerticalSliderMinimumTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.insetBackgroundSkinTextures;
			skinSelector.setValueForState(this.insetBackgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.wideControlSize,
				textureScale: this.scale
			};
			track.stateToSkinFunction = skinSelector.updateValue;

			track.hasLabelTextRenderer = false;
		}

		protected function setSliderThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.thumbSkinTextures;
			skinSelector.setValueForState(this.thumbDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			thumb.stateToSkinFunction = skinSelector.updateValue;
			thumb.minTouchWidth = this.gridSize;
			thumb.minTouchHeight = this.gridSize;

			thumb.hasLabelTextRenderer = false;
		}

	//-------------------------
	// SpinnerList
	//-------------------------

		protected function setSpinnerListStyles(list:SpinnerList):void
		{
			this.setListStyles(list);
			list.customItemRendererStyleName = THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER;
			list.selectionOverlaySkin = new Scale9Image(this.spinnerListSelectionOverlaySkinTextures, this.scale);
		}

		protected function setSpinnerListItemRendererStyles(renderer:BaseDefaultItemRenderer):void
		{
			renderer.defaultLabelProperties.textFormat = this.disabledTextFormat;
			renderer.defaultSelectedLabelProperties.textFormat = this.primaryTextFormat;
			renderer.disabledLabelProperties.textFormat = this.disabledTextFormat;
			renderer.selectedDisabledLabelProperties.textFormat = this.disabledTextFormat;

			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;
			renderer.paddingRight = this.gutterSize;
			renderer.gap = Number.POSITIVE_INFINITY;
			renderer.minGap = this.gutterSize;
			renderer.iconPosition = Button.ICON_POSITION_RIGHT;
			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.minAccessoryGap = this.gutterSize;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
			renderer.minWidth = this.gridSize;
			renderer.minHeight = this.gridSize;
			renderer.minTouchWidth = this.gridSize;
			renderer.minTouchHeight = this.gridSize;
			renderer.isQuickHitAreaEnabled = true;

			renderer.accessoryLoaderFactory = this.imageLoaderFactory;
			renderer.iconLoaderFactory = this.imageLoaderFactory;
		}

	//-------------------------
	// TabBar
	//-------------------------

		protected function setTabBarStyles(tabBar:TabBar):void
		{
			tabBar.distributeTabSizes = true;
		}

		protected function setTabStyles(tab:ToggleButton):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.headerSkinTextures;
			skinSelector.defaultSelectedValue = this.tabSelectedSkinTextures;
			skinSelector.setValueForState(this.tabDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.tabSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			skinSelector.displayObjectProperties =
			{
				width: this.gridSize,
				height: this.gridSize,
				textureScale: this.scale
			};
			tab.stateToSkinFunction = skinSelector.updateValue;

			tab.defaultLabelProperties.textFormat = this.primaryTextFormat;
			tab.disabledLabelProperties.textFormat = this.disabledTextFormat;
			tab.selectedDisabledLabelProperties.textFormat = this.disabledTextFormat;

			tab.iconPosition = Button.ICON_POSITION_TOP;
			tab.padding = this.gutterSize;
			tab.gap = this.smallGutterSize;
			tab.minGap = this.smallGutterSize;
			tab.minWidth = this.gridSize;
			tab.minHeight = this.gridSize;
			tab.minTouchWidth = this.gridSize;
			tab.minTouchHeight = this.gridSize;
		}

	//-------------------------
	// TextArea
	//-------------------------

		protected function setTextAreaStyles(textArea:TextArea):void
		{
			this.setScrollerStyles(textArea);

			textArea.textEditorProperties.textFormat = this.scrollTextTextFormat;
			textArea.textEditorProperties.disabledTextFormat = this.scrollTextDisabledTextFormat;
			textArea.textEditorProperties.padding = this.smallGutterSize;

			textArea.padding = this.smallGutterSize;

			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.insetBackgroundSkinTextures;
			skinSelector.setValueForState(this.insetBackgroundDisabledSkinTextures, TextArea.STATE_DISABLED);
			skinSelector.displayObjectProperties =
			{
				width: this.wideControlSize,
				height: this.wideControlSize,
				textureScale: this.scale
			};
			textArea.stateToSkinFunction = skinSelector.updateValue;
		}

	//-------------------------
	// TextInput
	//-------------------------

		protected function setBaseTextInputStyles(input:TextInput):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.insetBackgroundSkinTextures;
			skinSelector.setValueForState(this.insetBackgroundDisabledSkinTextures, TextArea.STATE_DISABLED);
			skinSelector.displayObjectProperties =
			{
				width: this.wideControlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			input.stateToSkinFunction = skinSelector.updateValue;

			input.minWidth = this.controlSize;
			input.minHeight = this.controlSize;
			input.minTouchWidth = this.gridSize;
			input.minTouchHeight = this.gridSize;
			input.gap = this.smallGutterSize;
			input.padding = this.smallGutterSize;

			input.textEditorProperties.fontFamily = "_sans";
			input.textEditorProperties.fontSize = this.inputFontSize;
			input.textEditorProperties.color = PRIMARY_TEXT_COLOR;
			input.textEditorProperties.disabledColor = DISABLED_TEXT_COLOR;

			input.promptProperties.textFormat = this.primaryTextFormat;
			input.promptProperties.disabledTextFormat = this.disabledTextFormat;
		}

		protected function setTextInputStyles(input:TextInput):void
		{
			this.setBaseTextInputStyles(input);
		}

		protected function setSearchTextInputStyles(input:TextInput):void
		{
			this.setBaseTextInputStyles(input);

			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
			iconSelector.defaultValue = this.searchIconTexture;
			iconSelector.setValueForState(this.searchIconDisabledTexture, TextInput.STATE_DISABLED, false);
			iconSelector.displayObjectProperties =
			{
				textureScale: this.scale,
				snapToPixels: true
			};
			input.stateToIconFunction = iconSelector.updateValue;
		}

	//-------------------------
	// ToggleSwitch
	//-------------------------

		protected function setToggleSwitchStyles(toggleSwitch:ToggleSwitch):void
		{
			toggleSwitch.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;

			toggleSwitch.defaultLabelProperties.textFormat = this.primaryTextFormat;
			toggleSwitch.disabledLabelProperties.textFormat = this.disabledTextFormat;
		}

		protected function setToggleSwitchOnTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.insetBackgroundSkinTextures;
			skinSelector.setValueForState(this.insetBackgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: Math.round(this.controlSize * 2.5),
				height: this.controlSize,
				textureScale: this.scale
			};
			track.stateToSkinFunction = skinSelector.updateValue;
			track.minTouchWidth = this.gridSize;
			track.minTouchHeight = this.gridSize;

			track.hasLabelTextRenderer = false;
		}

		protected function setToggleSwitchThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.thumbSkinTextures;
			skinSelector.setValueForState(this.thumbDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			thumb.stateToSkinFunction = skinSelector.updateValue;
			thumb.minTouchWidth = this.gridSize;
			thumb.minTouchHeight = this.gridSize;

			thumb.hasLabelTextRenderer = false;
		}
	}
}
