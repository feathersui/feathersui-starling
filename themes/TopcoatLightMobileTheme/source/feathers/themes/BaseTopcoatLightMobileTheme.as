/*
Copyright 2012-2015 Bowler Hat LLC, Marcel Piestansky

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
	import feathers.controls.AutoComplete;
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
	import feathers.controls.popups.BottomDrawerPopUpContentManager;
	import feathers.controls.popups.CalloutPopUpContentManager;
	import feathers.controls.renderers.BaseDefaultItemRenderer;
	import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.text.TextBlockTextEditor;
	import feathers.controls.text.TextBlockTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.core.PopUpManager;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.skins.SmartDisplayObjectStateValueSelector;
	import feathers.system.DeviceCapabilities;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;

	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.engine.CFFHinting;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.RenderingMode;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.SubTexture;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class BaseTopcoatLightMobileTheme extends StyleNameFunctionTheme
	{
		[Embed(source="/../assets/fonts/SourceSansPro-Regular.ttf", fontFamily="SourceSansPro", fontWeight="normal", mimeType="application/x-font", embedAsCFF="true")]
		protected static const SOURCE_SANS_PRO_REGULAR:Class;

		/**
		 * The name of the embedded font used by controls in this theme.
		 */
		public static const FONT_NAME:String = "SourceSansPro";

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

		protected static const COLOR_TEXT_DARK:uint = 0x454545;
		protected static const COLOR_TEXT_DARK_DISABLED:uint = 0x848585;
		protected static const COLOR_TEXT_LIGHT:uint = 0xFFFFFF;
		protected static const COLOR_TEXT_LIGHT_DISABLED:uint = 0xCCCCCC;
		protected static const COLOR_TEXT_BLUE:uint = 0x0083E8;
		protected static const COLOR_TEXT_BLUE_DISABLED:uint = 0xC6DFF3;
		protected static const COLOR_TEXT_DANGER_DISABLED:uint = 0xF7B4AF;
		protected static const COLOR_BACKGROUND_LIGHT:uint = 0xDFE2E2;
		protected static const COLOR_SPINNER_LIST_BACKGROUND:uint = 0xE5E9E8;
		protected static const COLOR_MODAL_OVERLAY:uint = 0xDFE2E2;
		protected static const ALPHA_MODAL_OVERLAY:Number = 0.8;
		protected static const COLOR_DRAWER_OVERLAY:uint = 0x454545;
		protected static const ALPHA_DRAWER_OVERLAY:Number = 0.8;

		protected static const BUTTON_SCALE9_GRID:Rectangle = new Rectangle(14, 14, 2, 2);
		protected static const BUTTON_BACK_SCALE9_GRID:Rectangle = new Rectangle(52, 10, 20, 80);
		protected static const BUTTON_FORWARD_SCALE9_GRID:Rectangle = new Rectangle(10, 10, 20, 80);
		protected static const TEXT_INPUT_SCALE9_GRID:Rectangle = new Rectangle(14, 14, 2, 2);
		protected static const HORIZONTAL_TRACK_SCALE3_FIRST_REGION:Number = 10;
		protected static const HORIZONTAL_TRACK_SCALE3_SECOND_REGION:Number = 2;
		protected static const HORIZONTAL_TRACK_SCALE3_THIRD_REGION:Number = 0;
		protected static const VERTICAL_TRACK_SCALE3_FIRST_REGION:Number = 10;
		protected static const VERTICAL_TRACK_SCALE3_SECOND_REGION:Number = 2;
		protected static const VERTICAL_TRACK_SCALE3_THIRD_REGION:Number = 0;
		protected static const BAR_HORIZONTAL_SCALE9_GRID:Rectangle = new Rectangle(16, 15, 1, 2);
		protected static const BAR_VERTICAL_SCALE9_GRID:Rectangle = new Rectangle(15, 16, 2, 1);
		protected static const HEADER_BACKGROUND_SCALE9_GRID:Rectangle = new Rectangle(5, 5, 20, 112);
		protected static const TAB_SCALE9_GRID:Rectangle = new Rectangle(5, 5, 10, 110);
		protected static const SEARCH_INPUT_SCALE9_GRID:Rectangle = new Rectangle(50, 49, 20, 2);
		protected static const BACKGROUND_POPUP_SCALE9_GRID:Rectangle = new Rectangle(10, 10, 20, 20);
		protected static const POP_UP_DRAWER_BACKGROUND_SCALE9_GRID:Rectangle = new Rectangle(2, 6, 6, 8);
		protected static const LIST_ITEM_SCALE9_GRID:Rectangle = new Rectangle(4, 4, 2, 12);
		protected static const GROUPED_LIST_HEADER_OR_FOOTER_SCALE9_GRID:Rectangle = new Rectangle(4, 4, 2, 12);
		protected static const SPINNER_LIST_OVERLAY_SCALE9_GRID:Rectangle = new Rectangle(4, 10, 2, 2);
		protected static const SCROLL_BAR_REGION1:int = 9;
		protected static const SCROLL_BAR_REGION2:int = 6;

		protected static const THEME_STYLE_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB:String = "topcoat-light-mobile-vertical-simple-scroll-bar-thumb";
		protected static const THEME_STYLE_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB:String = "topcoat-light-mobile-horizontal-simple-scroll-bar-thumb";
		protected static const THEME_STYLE_NAME_HORIZONTAL_SLIDER_THUMB:String = "topcoat-light-mobile-horizontal-slider-thumb";
		protected static const THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK:String = "topcoat-light-mobile-horizontal-slider-minimum-track";
		protected static const THEME_STYLE_NAME_HORIZONTAL_SLIDER_MAXIMUM_TRACK:String = "topcoat-light-mobile-horizontal-slider-maximum-track";
		protected static const THEME_STYLE_NAME_VERTICAL_SLIDER_THUMB:String = "topcoat-light-mobile-vertical-slider-thumb";
		protected static const THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK:String = "topcoat-light-mobile-vertical-slider-minimum-track";
		protected static const THEME_STYLE_NAME_VERTICAL_SLIDER_MAXIMUM_TRACK:String = "topcoat-light-mobile-vertical-slider-maximum-track";
		protected static const THEME_STYLE_NAME_ALERT_BUTTON_GROUP_BUTTON:String = "topcoat-light-mobile-alert-button-group-button";
		protected static const THEME_STYLE_NAME_ALERT_BUTTON_GROUP_LAST_BUTTON:String = "topcoat-light-mobile-alert-button-group-last-button";
		protected static const THEME_STYLE_NAME_GROUPED_LIST_FIRST_ITEM_RENDERER:String = "topcoat-light-mobile-grouped-list-first-item-renderer";
		protected static const THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER:String = "topcoat-light-mobile-spinner-list-item-renderer";
		protected static const THEME_STYLE_NAME_POP_UP_DRAWER:String = "topcoat-light-mobile-pop-up-drawer";
		protected static const THEME_STYLE_NAME_POP_UP_DRAWER_HEADER:String = "topcoat-light-mobile-pop-up-drawer-header";

		public function BaseTopcoatLightMobileTheme(scaleToDPI:Boolean = true)
		{
			super();
			this._scaleToDPI = scaleToDPI;
		}

		protected var gridSize:int;
		protected var gutterSize:int;
		protected var smallGutterSize:int;
		protected var extraSmallGutterSize:int;
		protected var borderSize:int;
		protected var controlSize:int;
		protected var smallControlSize:int;
		protected var wideControlSize:int;
		protected var popUpFillSize:int;
		protected var thumbSize:int;
		protected var calloutBackgroundMinSize:int;

		protected var smallFontSize:int;
		protected var regularFontSize:int;
		protected var largeFontSize:int;
		protected var inputFontSize:int;

		protected var regularFontDescription:FontDescription;

		protected var scrollTextTextFormat:TextFormat;
		protected var scrollTextDisabledTextFormat:TextFormat;

		protected var lightUIElementFormat:ElementFormat;
		protected var lightUIDisabledElementFormat:ElementFormat;
		protected var darkUIElementFormat:ElementFormat;
		protected var darkUIDisabledElementFormat:ElementFormat;
		protected var darkUISmallElementFormat:ElementFormat;
		protected var darkUISmallDisabledElementFormat:ElementFormat;
		protected var darkUILargeElementFormat:ElementFormat;
		protected var darkUILargeDisabledElementFormat:ElementFormat;
		protected var blueUIElementFormat:ElementFormat;
		protected var blueUIDisabledElementFormat:ElementFormat;
		protected var dangerButtonDisabledElementFormat:ElementFormat;

		/**
		 * The texture atlas that contains skins for this theme. This base class
		 * does not initialize this member variable. Subclasses are expected to
		 * load the assets somehow and set the <code>atlas</code> member
		 * variable before calling <code>initialize()</code>.
		 */
		protected var atlas:TextureAtlas;

		protected var buttonUpTexture:Scale9Textures;
		protected var buttonDownTexture:Scale9Textures;
		protected var buttonDisabledTexture:Scale9Textures;
		protected var quietButtonDownTexture:Scale9Textures;
		protected var backButtonUpTexture:Scale9Textures;
		protected var backButtonDownTexture:Scale9Textures;
		protected var backButtonDisabledTexture:Scale9Textures;
		protected var forwardButtonUpTexture:Scale9Textures;
		protected var forwardButtonDownTexture:Scale9Textures;
		protected var forwardButtonDisabledTexture:Scale9Textures;
		protected var dangerButtonUpTexture:Scale9Textures;
		protected var dangerButtonDownTexture:Scale9Textures;
		protected var dangerButtonDisabledTexture:Scale9Textures;
		protected var callToActionButtonUpTexture:Scale9Textures;
		protected var callToActionButtonDownTexture:Scale9Textures;
		protected var callToActionButtonDisabledTexture:Scale9Textures;
		protected var toggleButtonSelectedUpTexture:Scale9Textures;
		protected var toggleButtonSelectedDisabledTexture:Scale9Textures;
		protected var toggleSwitchOnTrackTexture:Scale9Textures;
		protected var toggleSwitchOnTrackDisabledTexture:Scale9Textures;
		protected var toggleSwitchOffTrackTexture:Scale9Textures;
		protected var toggleSwitchOffTrackDisabledTexture:Scale9Textures;
		protected var checkUpIconTexture:Texture;
		protected var checkSelectedUpIconTexture:Texture;
		protected var checkDownIconTexture:Texture;
		protected var checkDisabledIconTexture:Texture;
		protected var checkSelectedDownIconTexture:Texture;
		protected var checkSelectedDisabledIconTexture:Texture;
		protected var radioUpIconTexture:Texture;
		protected var radioSelectedUpIconTexture:Texture;
		protected var radioDownIconTexture:Texture;
		protected var radioDisabledIconTexture:Texture;
		protected var radioSelectedDownIconTexture:Texture;
		protected var radioSelectedDisabledIconTexture:Texture;
		protected var horizontalProgressBarFillTexture:Scale9Textures;
		protected var horizontalProgressBarFillDisabledTexture:Scale9Textures;
		protected var horizontalProgressBarBackgroundTexture:Scale9Textures;
		protected var horizontalProgressBarBackgroundDisabledTexture:Scale9Textures;
		protected var verticalProgressBarFillTexture:Scale9Textures;
		protected var verticalProgressBarFillDisabledTexture:Scale9Textures;
		protected var verticalProgressBarBackgroundTexture:Scale9Textures;
		protected var verticalProgressBarBackgroundDisabledTexture:Scale9Textures;
		protected var headerBackgroundSkinTexture:Scale9Textures;
		protected var verticalSimpleScrollBarThumbTexture:Scale3Textures;
		protected var horizontalSimpleScrollBarThumbTexture:Scale3Textures;
		protected var tabUpTexture:Scale9Textures;
		protected var tabDownTexture:Scale9Textures;
		protected var tabSelectedUpTexture:Scale9Textures;
		protected var tabSelectedDownTexture:Scale9Textures;
		protected var tabSelectedDisabledTexture:Scale9Textures;
		protected var horizontalSliderMinimumTrackTexture:Scale3Textures;
		protected var horizontalSliderMinimumTrackDisabledTexture:Scale3Textures;
		protected var horizontalSliderMaximumTrackTexture:Scale3Textures;
		protected var horizontalSliderMaximumTrackDisabledTexture:Scale3Textures;
		protected var verticalSliderMinimumTrackTexture:Scale3Textures;
		protected var verticalSliderMinimumTrackDisabledTexture:Scale3Textures;
		protected var verticalSliderMaximumTrackTexture:Scale3Textures;
		protected var verticalSliderMaximumTrackDisabledTexture:Scale3Textures;
		protected var textInputBackgroundEnabledTexture:Scale9Textures;
		protected var textInputBackgroundFocusedTexture:Scale9Textures;
		protected var textInputBackgroundDisabledTexture:Scale9Textures;
		protected var searchTextInputBackgroundEnabledTexture:Scale9Textures;
		protected var searchTextInputBackgroundFocusedTexture:Scale9Textures;
		protected var searchTextInputBackgroundDisabledTexture:Scale9Textures;
		protected var searchIconTexture:Texture;
		protected var popUpBackgroundTexture:Scale9Textures;
		protected var calloutTopArrowTexture:Texture;
		protected var calloutRightArrowTexture:Texture;
		protected var calloutBottomArrowTexture:Texture;
		protected var calloutLeftArrowTexture:Texture;
		protected var itemRendererUpTexture:Scale9Textures;
		protected var itemRendererSelectedTexture:Scale9Textures;
		protected var firstItemRendererUpTexture:Scale9Textures;
		protected var groupedListHeaderTexture:Scale9Textures;
		protected var groupedListFooterTexture:Scale9Textures;
		protected var pickerListButtonIcon:Texture;
		protected var pickerListButtonDisabledIcon:Texture;
		protected var popUpDrawerBackgroundTexture:Scale9Textures;
		protected var spinnerListSelectionOverlayTexture:Scale9Textures;
		protected var pageIndicatorNormalTexture:Texture;
		protected var pageIndicatorSelectedTexture:Texture;

		protected var scale:Number;
		protected var stageTextScale:Number;
		
		protected var _originalDPI:int;

		/**
		 * The original screen density used for scaling.
		 */
		public function get originalDPI():int
		{
			return this._originalDPI;
		}
		
		protected var _scaleToDPI:Boolean;

		/**
		 * Indicates if the theme scales skins to match the screen density of the device.
		 */
		public function get scaleToDPI():Boolean
		{
			return this._scaleToDPI;
		}

		/**
		 * Disposes the atlas before calling super.dispose()
		 */
		override public function dispose():void
		{
			if(this.atlas)
			{
				this.atlas.dispose();
				this.atlas = null;
			}
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
			this.initializeFonts();
			this.initializeTextures();
			this.initializeGlobals();
			this.initializeStage();
			this.initializeStyleProviders();
		}

		protected function initializeStage():void
		{
			Starling.current.stage.color = COLOR_BACKGROUND_LIGHT;
			Starling.current.nativeStage.color = COLOR_BACKGROUND_LIGHT;
		}

		protected function initializeScale():void
		{
			var starling:Starling = Starling.current;
			var nativeScaleFactor:Number = 1;
			if(starling.supportHighResolutions)
			{
				nativeScaleFactor = starling.nativeStage.contentsScaleFactor;
			}
			var scaledDPI:int = DeviceCapabilities.dpi / (starling.contentScaleFactor / nativeScaleFactor);
			this._originalDPI = scaledDPI;
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
			this.scale = scaledDPI / this._originalDPI;
			this.stageTextScale = this.scale / nativeScaleFactor;
		}

		protected function initializeDimensions():void
		{
			this.gridSize = Math.round(140 * this.scale);
			this.gutterSize = Math.round(40 * this.scale);
			this.smallGutterSize = Math.round(20 * this.scale);
			this.extraSmallGutterSize = Math.round(10 * this.scale);
			this.borderSize = Math.round(4 * this.scale);
			this.controlSize = Math.round(100 * this.scale);
			this.smallControlSize = Math.round(32 * this.scale);
			this.wideControlSize = Math.round(460 * this.scale);
			this.popUpFillSize = Math.round(600 * this.scale);
			this.thumbSize = Math.round(68 * this.scale);
			this.calloutBackgroundMinSize = Math.round(106 * this.scale);
		}

		protected function initializeTextures():void
		{
			this.popUpBackgroundTexture = new Scale9Textures(this.atlas.getTexture("background-popup-skin0000"), BACKGROUND_POPUP_SCALE9_GRID);
			this.popUpDrawerBackgroundTexture = new Scale9Textures(this.atlas.getTexture("pop-up-drawer-background-skin0000"), POP_UP_DRAWER_BACKGROUND_SCALE9_GRID);

			this.buttonUpTexture = new Scale9Textures(this.atlas.getTexture("button-up-skin0000"), BUTTON_SCALE9_GRID);
			this.buttonDownTexture = new Scale9Textures(this.atlas.getTexture("button-down-skin0000"), BUTTON_SCALE9_GRID);
			this.buttonDisabledTexture = new Scale9Textures(this.atlas.getTexture("button-disabled-skin0000"), BUTTON_SCALE9_GRID);
			this.quietButtonDownTexture = new Scale9Textures(this.atlas.getTexture("button-down-skin0000"), BUTTON_SCALE9_GRID);
			this.dangerButtonUpTexture = new Scale9Textures(this.atlas.getTexture("button-danger-up-skin0000"), BUTTON_SCALE9_GRID);
			this.dangerButtonDownTexture = new Scale9Textures(this.atlas.getTexture("button-danger-down-skin0000"), BUTTON_SCALE9_GRID);
			this.dangerButtonDisabledTexture = new Scale9Textures(this.atlas.getTexture("button-danger-disabled-skin0000"), BUTTON_SCALE9_GRID);
			this.callToActionButtonUpTexture = new Scale9Textures(this.atlas.getTexture("button-call-to-action-up-skin0000"), BUTTON_SCALE9_GRID);
			this.callToActionButtonDownTexture = new Scale9Textures(this.atlas.getTexture("button-call-to-action-down-skin0000"), BUTTON_SCALE9_GRID);
			this.callToActionButtonDisabledTexture = new Scale9Textures(this.atlas.getTexture("button-call-to-action-disabled-skin0000"), BUTTON_SCALE9_GRID);
			this.backButtonUpTexture = new Scale9Textures(this.atlas.getTexture("button-back-up-skin0000"), BUTTON_BACK_SCALE9_GRID);
			this.backButtonDownTexture = new Scale9Textures(this.atlas.getTexture("button-back-down-skin0000"), BUTTON_BACK_SCALE9_GRID);
			this.backButtonDisabledTexture = new Scale9Textures(this.atlas.getTexture("button-back-disabled-skin0000"), BUTTON_BACK_SCALE9_GRID);
			this.forwardButtonUpTexture = new Scale9Textures(this.atlas.getTexture("button-forward-up-skin0000"), BUTTON_FORWARD_SCALE9_GRID);
			this.forwardButtonDownTexture = new Scale9Textures(this.atlas.getTexture("button-forward-down-skin0000"), BUTTON_FORWARD_SCALE9_GRID);
			this.forwardButtonDisabledTexture = new Scale9Textures(this.atlas.getTexture("button-forward-disabled-skin0000"), BUTTON_FORWARD_SCALE9_GRID);
			this.toggleButtonSelectedUpTexture = new Scale9Textures(this.atlas.getTexture("toggle-button-selected-up-skin0000"), BUTTON_SCALE9_GRID);
			this.toggleButtonSelectedDisabledTexture = new Scale9Textures(this.atlas.getTexture("toggle-button-selected-disabled-skin0000"), BUTTON_SCALE9_GRID);
			
			this.calloutTopArrowTexture = this.atlas.getTexture("callout-arrow-top-skin0000");
			this.calloutRightArrowTexture = this.atlas.getTexture("callout-arrow-right-skin0000");
			this.calloutBottomArrowTexture = this.atlas.getTexture("callout-arrow-bottom-skin0000");
			this.calloutLeftArrowTexture = this.atlas.getTexture("callout-arrow-left-skin0000");

			this.checkUpIconTexture = this.atlas.getTexture("check-up-icon0000");
			this.checkDownIconTexture = this.atlas.getTexture("check-down-icon0000");
			this.checkDisabledIconTexture = this.atlas.getTexture("check-disabled-icon0000");
			this.checkSelectedUpIconTexture = this.atlas.getTexture("check-selected-up-icon0000");
			this.checkSelectedDownIconTexture = this.atlas.getTexture("check-selected-down-icon0000");
			this.checkSelectedDisabledIconTexture = this.atlas.getTexture("check-selected-disabled-icon0000");

			this.headerBackgroundSkinTexture = new Scale9Textures(this.atlas.getTexture("header-background-skin0000"), HEADER_BACKGROUND_SCALE9_GRID);

			this.itemRendererUpTexture = new Scale9Textures(this.atlas.getTexture("list-item-up-skin0000"), LIST_ITEM_SCALE9_GRID);
			this.itemRendererSelectedTexture = new Scale9Textures(this.atlas.getTexture("list-item-selected-skin0000"), LIST_ITEM_SCALE9_GRID);
			this.firstItemRendererUpTexture = new Scale9Textures(this.atlas.getTexture("list-first-item-up-skin0000"), LIST_ITEM_SCALE9_GRID);
			this.groupedListHeaderTexture = new Scale9Textures(this.atlas.getTexture("grouped-list-header-skin0000"), GROUPED_LIST_HEADER_OR_FOOTER_SCALE9_GRID);
			this.groupedListFooterTexture = new Scale9Textures(this.atlas.getTexture("grouped-list-footer-skin0000"), GROUPED_LIST_HEADER_OR_FOOTER_SCALE9_GRID);

			this.pageIndicatorNormalTexture = this.atlas.getTexture("page-indicator-normal-skin0000");
			this.pageIndicatorSelectedTexture = this.atlas.getTexture("page-indicator-selected-skin0000");

			this.pickerListButtonIcon = this.atlas.getTexture("picker-list-button-icon0000");
			this.pickerListButtonDisabledIcon = this.atlas.getTexture("picker-list-button-disabled-icon0000");
			
			this.horizontalProgressBarFillTexture = new Scale9Textures(this.atlas.getTexture("progress-bar-horizontal-fill-skin0000"), BAR_HORIZONTAL_SCALE9_GRID);
			this.horizontalProgressBarFillDisabledTexture = new Scale9Textures(this.atlas.getTexture("progress-bar-horizontal-fill-disabled-skin0000"), BAR_HORIZONTAL_SCALE9_GRID);
			this.horizontalProgressBarBackgroundTexture = new Scale9Textures(this.atlas.getTexture("progress-bar-horizontal-background-skin0000"), BAR_HORIZONTAL_SCALE9_GRID);
			this.horizontalProgressBarBackgroundDisabledTexture = new Scale9Textures(this.atlas.getTexture("progress-bar-horizontal-background-disabled-skin0000"), BAR_HORIZONTAL_SCALE9_GRID);
			this.verticalProgressBarFillTexture = new Scale9Textures(this.atlas.getTexture("progress-bar-vertical-fill-skin0000"), BAR_VERTICAL_SCALE9_GRID);
			this.verticalProgressBarFillDisabledTexture = new Scale9Textures(this.atlas.getTexture("progress-bar-vertical-fill-disabled-skin0000"), BAR_VERTICAL_SCALE9_GRID);
			this.verticalProgressBarBackgroundTexture = new Scale9Textures(this.atlas.getTexture("progress-bar-vertical-background-skin0000"), BAR_VERTICAL_SCALE9_GRID);
			this.verticalProgressBarBackgroundDisabledTexture = new Scale9Textures(this.atlas.getTexture("progress-bar-vertical-background-disabled-skin0000"), BAR_VERTICAL_SCALE9_GRID);

			this.radioUpIconTexture = this.atlas.getTexture("radio-up-icon0000");
			this.radioDownIconTexture = this.atlas.getTexture("radio-down-icon0000");
			this.radioDisabledIconTexture = this.atlas.getTexture("radio-disabled-icon0000");
			this.radioSelectedUpIconTexture = this.atlas.getTexture("radio-selected-up-icon0000");
			this.radioSelectedDownIconTexture = this.atlas.getTexture("radio-selected-down-icon0000");
			this.radioSelectedDisabledIconTexture = this.atlas.getTexture("radio-selected-disabled-icon0000");

			this.verticalSimpleScrollBarThumbTexture = new Scale3Textures(this.atlas.getTexture("simple-scroll-bar-vertical-thumb-skin0000"), SCROLL_BAR_REGION1, SCROLL_BAR_REGION2, Scale3Textures.DIRECTION_VERTICAL);
			this.horizontalSimpleScrollBarThumbTexture = new Scale3Textures(this.atlas.getTexture("simple-scroll-bar-horizontal-thumb-skin0000"), SCROLL_BAR_REGION1, SCROLL_BAR_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);

			this.horizontalSliderMinimumTrackTexture = new Scale3Textures(this.atlas.getTexture("slider-horizontal-minimum-track-skin0000"), HORIZONTAL_TRACK_SCALE3_FIRST_REGION, HORIZONTAL_TRACK_SCALE3_SECOND_REGION, Scale3Textures.DIRECTION_HORIZONTAL);
			this.horizontalSliderMinimumTrackDisabledTexture = new Scale3Textures(this.atlas.getTexture("slider-horizontal-minimum-track-disabled-skin0000"), HORIZONTAL_TRACK_SCALE3_FIRST_REGION, HORIZONTAL_TRACK_SCALE3_SECOND_REGION, Scale3Textures.DIRECTION_HORIZONTAL);
			this.horizontalSliderMaximumTrackTexture = new Scale3Textures(this.atlas.getTexture("slider-horizontal-maximum-track-skin0000"), HORIZONTAL_TRACK_SCALE3_THIRD_REGION, HORIZONTAL_TRACK_SCALE3_SECOND_REGION, Scale3Textures.DIRECTION_HORIZONTAL);
			this.horizontalSliderMaximumTrackDisabledTexture = new Scale3Textures(this.atlas.getTexture("slider-horizontal-maximum-track-disabled-skin0000"), HORIZONTAL_TRACK_SCALE3_THIRD_REGION, HORIZONTAL_TRACK_SCALE3_SECOND_REGION, Scale3Textures.DIRECTION_HORIZONTAL);
			this.verticalSliderMinimumTrackTexture = new Scale3Textures(this.atlas.getTexture("slider-vertical-minimum-track-skin0000"), VERTICAL_TRACK_SCALE3_THIRD_REGION, VERTICAL_TRACK_SCALE3_SECOND_REGION, Scale3Textures.DIRECTION_VERTICAL);
			this.verticalSliderMinimumTrackDisabledTexture = new Scale3Textures(this.atlas.getTexture("slider-vertical-minimum-track-disabled-skin0000"), VERTICAL_TRACK_SCALE3_THIRD_REGION, VERTICAL_TRACK_SCALE3_SECOND_REGION, Scale3Textures.DIRECTION_VERTICAL);
			this.verticalSliderMaximumTrackTexture = new Scale3Textures(this.atlas.getTexture("slider-vertical-maximum-track-skin0000"), VERTICAL_TRACK_SCALE3_FIRST_REGION, VERTICAL_TRACK_SCALE3_SECOND_REGION, Scale3Textures.DIRECTION_VERTICAL);
			this.verticalSliderMaximumTrackDisabledTexture = new Scale3Textures(this.atlas.getTexture("slider-vertical-maximum-track-disabled-skin0000"), VERTICAL_TRACK_SCALE3_FIRST_REGION, VERTICAL_TRACK_SCALE3_SECOND_REGION, Scale3Textures.DIRECTION_VERTICAL);

			this.spinnerListSelectionOverlayTexture = new Scale9Textures(this.atlas.getTexture("spinner-list-selection-overlay-skin0000"), SPINNER_LIST_OVERLAY_SCALE9_GRID);

			this.tabUpTexture = new Scale9Textures(this.atlas.getTexture("tab-up-skin0000"), TAB_SCALE9_GRID);
			this.tabDownTexture = new Scale9Textures(this.atlas.getTexture("tab-down-skin0000"), TAB_SCALE9_GRID);
			this.tabSelectedUpTexture = new Scale9Textures(this.atlas.getTexture("tab-selected-up-skin0000"), TAB_SCALE9_GRID);
			this.tabSelectedDownTexture = new Scale9Textures(this.atlas.getTexture("tab-selected-down-skin0000"), TAB_SCALE9_GRID);
			this.tabSelectedDisabledTexture = new Scale9Textures(this.atlas.getTexture("tab-selected-disabled-skin0000"), TAB_SCALE9_GRID);

			this.textInputBackgroundEnabledTexture = new Scale9Textures(this.atlas.getTexture("text-input-up-skin0000"), TEXT_INPUT_SCALE9_GRID);
			this.textInputBackgroundFocusedTexture = new Scale9Textures(this.atlas.getTexture("text-input-focused-skin0000"), TEXT_INPUT_SCALE9_GRID);
			this.textInputBackgroundDisabledTexture = new Scale9Textures(this.atlas.getTexture("text-input-disabled-skin0000"), TEXT_INPUT_SCALE9_GRID);
			this.searchTextInputBackgroundEnabledTexture = new Scale9Textures(this.atlas.getTexture("search-input-up-skin0000"), SEARCH_INPUT_SCALE9_GRID);
			this.searchTextInputBackgroundFocusedTexture = new Scale9Textures(this.atlas.getTexture("search-input-focused-skin0000"), SEARCH_INPUT_SCALE9_GRID);
			this.searchTextInputBackgroundDisabledTexture = new Scale9Textures(this.atlas.getTexture("search-input-disabled-skin0000"), SEARCH_INPUT_SCALE9_GRID);
			this.searchIconTexture = this.atlas.getTexture("search-input-icon0000");

			this.toggleSwitchOnTrackTexture = new Scale9Textures(this.atlas.getTexture("toggle-switch-on-track-skin0000"), BUTTON_SCALE9_GRID);
			this.toggleSwitchOnTrackDisabledTexture = new Scale9Textures(this.atlas.getTexture("toggle-switch-on-track-disabled-skin0000"), BUTTON_SCALE9_GRID);
			this.toggleSwitchOffTrackTexture = new Scale9Textures(this.atlas.getTexture("toggle-switch-off-track-skin0000"), BUTTON_SCALE9_GRID);
			this.toggleSwitchOffTrackDisabledTexture = new Scale9Textures(this.atlas.getTexture("toggle-switch-off-track-disabled-skin0000"), BUTTON_SCALE9_GRID);
		}

		protected function initializeFonts():void
		{
			this.smallFontSize = Math.round(28 * this.scale);
			this.regularFontSize = Math.round(32 * this.scale);
			this.largeFontSize = Math.round(40 * this.scale);
			this.inputFontSize = Math.round(32 * this.stageTextScale);

			//these are for components that do not use FTE
			this.scrollTextTextFormat = new TextFormat("_sans", this.regularFontSize, COLOR_TEXT_DARK);
			this.scrollTextDisabledTextFormat = new TextFormat("_sans", this.regularFontSize, COLOR_TEXT_DARK_DISABLED);

			this.regularFontDescription = new FontDescription(FONT_NAME, FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE);

			this.lightUIElementFormat = new ElementFormat(this.regularFontDescription, this.regularFontSize, COLOR_TEXT_LIGHT);
			this.lightUIDisabledElementFormat = new ElementFormat(this.regularFontDescription, this.regularFontSize, COLOR_TEXT_LIGHT_DISABLED);
			this.darkUIElementFormat = new ElementFormat(this.regularFontDescription, this.regularFontSize, COLOR_TEXT_DARK);
			this.darkUIDisabledElementFormat = new ElementFormat(this.regularFontDescription, this.regularFontSize, COLOR_TEXT_DARK_DISABLED);
			this.darkUISmallElementFormat = new ElementFormat(this.regularFontDescription, this.smallFontSize, COLOR_TEXT_DARK);
			this.darkUISmallDisabledElementFormat = new ElementFormat(this.regularFontDescription, this.smallFontSize, COLOR_TEXT_DARK_DISABLED);
			this.dangerButtonDisabledElementFormat = new ElementFormat(this.regularFontDescription, this.regularFontSize, COLOR_TEXT_DANGER_DISABLED);
			this.blueUIElementFormat = new ElementFormat(this.regularFontDescription, this.regularFontSize, COLOR_TEXT_BLUE);
			this.blueUIDisabledElementFormat = new ElementFormat(this.regularFontDescription, this.regularFontSize, COLOR_TEXT_BLUE_DISABLED);
			this.darkUILargeElementFormat = new ElementFormat(this.regularFontDescription, this.largeFontSize, COLOR_TEXT_DARK);
			this.darkUILargeDisabledElementFormat = new ElementFormat(this.regularFontDescription, this.largeFontSize, COLOR_TEXT_DARK_DISABLED);
		}

		protected function initializeGlobals():void
		{
			FeathersControl.defaultTextRendererFactory = textRendererFactory;

			PopUpManager.overlayFactory = popUpOverlayFactory;
		}

		protected function initializeStyleProviders():void
		{
			//alert
			this.getStyleProviderForClass(Alert).defaultStyleFunction = this.setAlertStyles;
			this.getStyleProviderForClass(ButtonGroup).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_BUTTON_GROUP, this.setAlertButtonGroupStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_ALERT_BUTTON_GROUP_BUTTON, this.setAlertButtonGroupButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_ALERT_BUTTON_GROUP_LAST_BUTTON, this.setAlertButtonGroupLastButtonStyles);
			this.getStyleProviderForClass(Header).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setHeaderWithoutBackgroundStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_MESSAGE, this.setAlertMessageTextRendererStyles);

			//auto complete
			this.getStyleProviderForClass(AutoComplete).defaultStyleFunction = this.setTextInputStyles;
			this.getStyleProviderForClass(List).setFunctionForStyleName(AutoComplete.DEFAULT_CHILD_STYLE_NAME_LIST, this.setAutoCompleteListStyles);

			//button
			this.getStyleProviderForClass(Button).defaultStyleFunction = this.setButtonStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_DANGER_BUTTON, this.setDangerButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_CALL_TO_ACTION_BUTTON, this.setCallToActionButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON, this.setBackButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_FORWARD_BUTTON, this.setForwardButtonStyles);
			this.getStyleProviderForClass(ToggleButton).defaultStyleFunction = this.setButtonStyles;
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);

			//button group
			this.getStyleProviderForClass(ButtonGroup).defaultStyleFunction = this.setButtonGroupStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ButtonGroup.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setButtonStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ButtonGroup.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setButtonStyles);

			//callout
			this.getStyleProviderForClass(Callout).defaultStyleFunction = this.setCalloutStyles;

			//check
			this.getStyleProviderForClass(Check).defaultStyleFunction = this.setCheckStyles;

			//drawers
			this.getStyleProviderForClass(Drawers).defaultStyleFunction = this.setDrawersStyles;

			//grouped list
			this.getStyleProviderForClass(GroupedList).defaultStyleFunction = this.setGroupedListStyles;
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).defaultStyleFunction = this.setGroupedListHeaderRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.DEFAULT_CHILD_STYLE_NAME_FOOTER_RENDERER, this.setGroupedListFooterRendererStyles);
			//custom style for the first item in GroupedList (without highlight at the top)
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_GROUPED_LIST_FIRST_ITEM_RENDERER, this.setGroupedListFirstItemRendererStyles);

			//header
			this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;

			//label
			this.getStyleProviderForClass(Label).defaultStyleFunction = this.setLabelStyles;
			this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_STYLE_NAME_HEADING, this.setHeadingLabelStyles);
			this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_STYLE_NAME_DETAIL, this.setDetailLabelStyles);

			//layout group
			this.getStyleProviderForClass(LayoutGroup).setFunctionForStyleName(LayoutGroup.ALTERNATE_STYLE_NAME_TOOLBAR, this.setToolbarLayoutGroupStyles);

			//list
			this.getStyleProviderForClass(List).defaultStyleFunction = this.setListStyles;
			this.getStyleProviderForClass(DefaultListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_ICON_LABEL, this.setItemRendererIconLabelStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL, this.setItemRendererAccessoryLabelRendererStyles);
			
			//numeric stepper
			this.getStyleProviderForClass(NumericStepper).defaultStyleFunction = this.setNumericStepperStyles;
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_TEXT_INPUT, this.setNumericStepperTextInputStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON, this.setNumericStepperButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON, this.setNumericStepperButtonStyles);

			//page indicator
			this.getStyleProviderForClass(PageIndicator).defaultStyleFunction = this.setPageIndicatorStyles;

			//panel
			this.getStyleProviderForClass(Panel).defaultStyleFunction = this.setPanelStyles;
			this.getStyleProviderForClass(Header).setFunctionForStyleName(Panel.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setHeaderWithoutBackgroundStyles);

			//panel screen
			this.getStyleProviderForClass(PanelScreen).defaultStyleFunction = this.setPanelScreenStyles;
			this.getStyleProviderForClass(Header).setFunctionForStyleName(PanelScreen.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setPanelScreenHeaderStyles);

			//picker list
			this.getStyleProviderForClass(PickerList).defaultStyleFunction = this.setPickerListStyles;
			this.getStyleProviderForClass(List).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_LIST, this.setPickerListListStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setPickerListButtonStyles);
			this.getStyleProviderForClass(Panel).setFunctionForStyleName(THEME_STYLE_NAME_POP_UP_DRAWER, this.setPickerListPopUpDrawerStyles);
			this.getStyleProviderForClass(Header).setFunctionForStyleName(THEME_STYLE_NAME_POP_UP_DRAWER_HEADER, this.setHeaderStyles);

			//progress bar
			this.getStyleProviderForClass(ProgressBar).defaultStyleFunction = this.setProgressBarStyles;

			//radio
			this.getStyleProviderForClass(Radio).defaultStyleFunction = this.setRadioStyles;

			//scroll container
			this.getStyleProviderForClass(ScrollContainer).defaultStyleFunction = this.setScrollContainerStyles;
			this.getStyleProviderForClass(ScrollContainer).setFunctionForStyleName(ScrollContainer.ALTERNATE_STYLE_NAME_TOOLBAR, this.setToolbarScrollContainerStyles);

			//scroll text
			this.getStyleProviderForClass(ScrollText).defaultStyleFunction = this.setScrollTextStyles;

			//simple scroll bar
			this.getStyleProviderForClass(SimpleScrollBar).defaultStyleFunction = this.setSimpleScrollBarStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB, this.setVerticalSimpleScrollBarThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB, this.setHorizontalSimpleScrollBarThumbStyles);

			//slider
			this.getStyleProviderForClass(Slider).defaultStyleFunction = this.setSliderStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SLIDER_THUMB, this.setHorizontalThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SLIDER_THUMB, this.setVerticalThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK, this.setHorizontalSliderMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SLIDER_MAXIMUM_TRACK, this.setHorizontalSliderMaximumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK, this.setVerticalSliderMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SLIDER_MAXIMUM_TRACK, this.setVerticalSliderMaximumTrackStyles);

			//spinner list
			this.getStyleProviderForClass(SpinnerList).defaultStyleFunction = this.setSpinnerListStyles;
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER, this.setSpinnerListItemRendererStyles);

			//tab bar
			this.getStyleProviderForClass(TabBar).defaultStyleFunction = this.setTabBarStyles;
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(TabBar.DEFAULT_CHILD_STYLE_NAME_TAB, this.setTabStyles);

			//text input
			this.getStyleProviderForClass(TextInput).defaultStyleFunction = this.setTextInputStyles;
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName(TextInput.ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT, this.setSearchTextInputStyles);

			//text area
			this.getStyleProviderForClass(TextArea).defaultStyleFunction = this.setTextAreaStyles;

			//toggle switch
			this.getStyleProviderForClass(ToggleSwitch).defaultStyleFunction = this.setToggleSwitchStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_ON_TRACK, this.setToggleSwitchOnTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_OFF_TRACK, this.setToggleSwitchOffTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setHorizontalThumbStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setHorizontalThumbStyles);
		}

		protected function textRendererFactory():ITextRenderer
		{
			return new TextBlockTextRenderer();
		}

		protected static function popUpOverlayFactory():DisplayObject
		{
			var quad:Quad = new Quad(10, 10, COLOR_MODAL_OVERLAY);
			quad.alpha = ALPHA_MODAL_OVERLAY;
			return quad;
		}

		protected function imageLoaderFactory():ImageLoader
		{
			var image:ImageLoader = new ImageLoader();
			image.textureScale = this.scale;
			return image;
		}

		protected static function scrollBarFactory():SimpleScrollBar
		{
			return new SimpleScrollBar();
		}

		protected static function stepperTextEditorFactory():TextBlockTextEditor
		{
			/* We are only using this text editor in the NumericStepper because
			 * isEditable is false on the TextInput. this text editor is not
			 * suitable for mobile use if the TextInput needs to be editable
			 * because it can't use the soft keyboard or other mobile-friendly UI */
			return new TextBlockTextEditor();
		}
		
		protected static function pickerListSpinnerListFactory():SpinnerList
		{
			return new SpinnerList();
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

		protected function pageIndicatorNormalSymbolFactory():DisplayObject
		{
			var symbol:ImageLoader = new ImageLoader();
			symbol.source = this.pageIndicatorNormalTexture;
			symbol.textureScale = this.scale;
			return symbol;
		}

		protected function pageIndicatorSelectedSymbolFactory():DisplayObject
		{
			var symbol:ImageLoader = new ImageLoader();
			symbol.source = this.pageIndicatorSelectedTexture;
			symbol.textureScale = this.scale;
			return symbol;
		}

	//-------------------------
	// Shared
	//-------------------------

		protected function setScrollerStyles(scroller:Scroller):void
		{
			scroller.verticalScrollBarFactory = scrollBarFactory;
			scroller.horizontalScrollBarFactory = scrollBarFactory;
		}

	//-------------------------
	// AutoComplete
	//-------------------------

		protected function setAutoCompleteListStyles(list:List):void
		{
			this.setScrollerStyles(list);

			list.maxHeight = this.wideControlSize;
			list.verticalScrollPolicy = List.SCROLL_POLICY_ON;
		}

	//-------------------------
	// Button
	//-------------------------

		protected function setBaseButtonSize(skinSelector:SmartDisplayObjectStateValueSelector):void
		{
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
		}

		protected function setBaseButtonStyles(button:Button):void
		{
			button.defaultLabelProperties.elementFormat = this.darkUIElementFormat;
			button.disabledLabelProperties.elementFormat = this.darkUIDisabledElementFormat;
			button.minHeight = this.controlSize;
			button.paddingBottom = this.smallGutterSize;
			button.paddingTop = this.smallGutterSize;
			button.paddingRight = this.gutterSize;
			button.paddingLeft = this.gutterSize;
			button.gap = this.smallGutterSize;
		}

		protected function setButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpTexture;
			skinSelector.setValueForState(this.buttonDownTexture, Button.STATE_DOWN);
			skinSelector.setValueForState(this.buttonDisabledTexture, Button.STATE_DISABLED);
			this.setBaseButtonSize(skinSelector);
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				skinSelector.defaultSelectedValue = this.toggleButtonSelectedUpTexture;
				//skinSelector.setValueForState(this.toggleButtonSelectedUpTexture, Button.STATE_DOWN, false);
				skinSelector.setValueForState(this.toggleButtonSelectedDisabledTexture, Button.STATE_DISABLED, true);
			}

			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
		}

		protected function setQuietButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = null;
			skinSelector.setValueForState(this.quietButtonDownTexture, Button.STATE_DOWN);
			this.setBaseButtonSize(skinSelector);

			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
		}

		protected function setDangerButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.dangerButtonUpTexture;
			skinSelector.setValueForState(this.dangerButtonDownTexture, Button.STATE_DOWN);
			skinSelector.setValueForState(this.dangerButtonDisabledTexture, Button.STATE_DISABLED);
			this.setBaseButtonSize(skinSelector);

			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
			/* Override label color */
			button.defaultLabelProperties.elementFormat = this.lightUIElementFormat;
			button.disabledLabelProperties.elementFormat = this.dangerButtonDisabledElementFormat;
		}

		protected function setCallToActionButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.callToActionButtonUpTexture;
			skinSelector.setValueForState(this.callToActionButtonDownTexture, Button.STATE_DOWN);
			skinSelector.setValueForState(this.callToActionButtonDisabledTexture, Button.STATE_DISABLED);
			this.setBaseButtonSize(skinSelector);

			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
			/* Override label color */
			button.defaultLabelProperties.elementFormat = this.lightUIElementFormat;
			button.disabledLabelProperties.elementFormat = this.blueUIDisabledElementFormat;
		}

		protected function setBackButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.backButtonUpTexture;
			skinSelector.setValueForState(this.backButtonDownTexture, Button.STATE_DOWN);
			skinSelector.setValueForState(this.backButtonDisabledTexture, Button.STATE_DISABLED);
			this.setBaseButtonSize(skinSelector);

			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
			/* Override left padding */
			button.paddingLeft = this.gutterSize + this.smallGutterSize;
		}

		protected function setForwardButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.forwardButtonUpTexture;
			skinSelector.setValueForState(this.forwardButtonDownTexture, Button.STATE_DOWN);
			skinSelector.setValueForState(this.forwardButtonDisabledTexture, Button.STATE_DISABLED);
			this.setBaseButtonSize(skinSelector);

			button.stateToSkinFunction = skinSelector.updateValue;
			setBaseButtonStyles(button);
			/* Override right padding */
			button.paddingRight = this.gutterSize + this.smallGutterSize;
		}

	//-------------------------
	// ButtonGroup
	//-------------------------

		protected function setButtonGroupStyles(group:ButtonGroup):void
		{
			group.minWidth = this.wideControlSize;
			group.gap = this.gutterSize;
		}

	//-------------------------
	// Check
	//-------------------------

		protected function setCheckStyles(check:Check):void
		{
			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.defaultValue = this.checkUpIconTexture;
			iconSelector.defaultSelectedValue = this.checkSelectedUpIconTexture;
			iconSelector.setValueForState(this.checkDownIconTexture, Button.STATE_DOWN);
			iconSelector.setValueForState(this.checkDisabledIconTexture, Button.STATE_DISABLED);
			iconSelector.setValueForState(this.checkSelectedDownIconTexture, Button.STATE_DOWN, true);
			iconSelector.setValueForState(this.checkSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
			iconSelector.displayObjectProperties =
			{
				scaleX: this.scale,
				scaleY: this.scale
			};
			check.stateToIconFunction = iconSelector.updateValue;

			check.defaultLabelProperties.elementFormat = this.darkUIElementFormat;
			check.disabledLabelProperties.elementFormat = this.darkUIDisabledElementFormat;
			check.selectedDisabledLabelProperties.elementFormat = this.darkUIDisabledElementFormat;

			check.gap = this.smallGutterSize;
		}

	//-------------------------
	// Radio
	//-------------------------

		protected function setRadioStyles(radio:Radio):void
		{
			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.defaultValue = this.radioUpIconTexture;
			iconSelector.defaultSelectedValue = this.radioSelectedUpIconTexture;
			iconSelector.setValueForState(this.radioDownIconTexture, Button.STATE_DOWN);
			iconSelector.setValueForState(this.radioDisabledIconTexture, Button.STATE_DISABLED);
			iconSelector.setValueForState(this.radioSelectedDownIconTexture, Button.STATE_DOWN, true);
			iconSelector.setValueForState(this.radioSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
			iconSelector.displayObjectProperties =
			{
				scaleX: this.scale,
				scaleY: this.scale
			};
			radio.stateToIconFunction = iconSelector.updateValue;

			radio.defaultLabelProperties.elementFormat = this.darkUIElementFormat;
			radio.disabledLabelProperties.elementFormat = this.darkUIDisabledElementFormat;
			radio.selectedDisabledLabelProperties.elementFormat = this.darkUIDisabledElementFormat;

			radio.gap = this.smallGutterSize;
		}

	//-------------------------
	// ToggleSwitch
	//-------------------------

		protected function setToggleSwitchStyles(toggle:ToggleSwitch):void
		{
			toggle.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_ON_OFF;

			toggle.defaultLabelProperties.elementFormat = this.darkUIElementFormat;
			toggle.onLabelProperties.elementFormat = this.blueUIElementFormat;
			toggle.disabledLabelProperties.elementFormat = this.darkUIDisabledElementFormat;
		}

		protected function setToggleSwitchOnTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.toggleSwitchOnTrackTexture;
			skinSelector.setValueForState(this.toggleSwitchOnTrackDisabledTexture, Button.STATE_DISABLED);
			this.setBaseToggleSwitchSize(skinSelector);

			track.stateToSkinFunction = skinSelector.updateValue;
			track.hasLabelTextRenderer = false;
		}

		protected function setToggleSwitchOffTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.toggleSwitchOffTrackTexture;
			skinSelector.setValueForState(this.toggleSwitchOffTrackDisabledTexture, Button.STATE_DISABLED);
			this.setBaseToggleSwitchSize(skinSelector);

			track.stateToSkinFunction = skinSelector.updateValue;
			track.hasLabelTextRenderer = false;
		}

		protected function setHorizontalThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpTexture;
			skinSelector.setValueForState(this.buttonDisabledTexture, Button.STATE_DISABLED);
			skinSelector.displayObjectProperties =
			{
				width: this.thumbSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			thumb.stateToSkinFunction = skinSelector.updateValue;
			thumb.hasLabelTextRenderer = false;
		}

		protected function setVerticalThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpTexture;
			skinSelector.setValueForState(this.buttonDisabledTexture, Button.STATE_DISABLED);
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.thumbSize,
				textureScale: this.scale
			};
			thumb.stateToSkinFunction = skinSelector.updateValue;
			thumb.hasLabelTextRenderer = false;
		}

	//-------------------------
	// ProgressBar
	//-------------------------

		protected function setProgressBarStyles(progress:ProgressBar):void
		{
			var backgroundSkin:Scale9Image;
			var backgroundDisabledSkin:Scale9Image;
			/* Horizontal background skin */
			if(progress.direction === ProgressBar.DIRECTION_HORIZONTAL)
			{
				backgroundSkin = new Scale9Image(this.horizontalProgressBarBackgroundTexture, this.scale);
				backgroundSkin.width = this.wideControlSize;
				backgroundSkin.height = this.smallControlSize;
				backgroundDisabledSkin = new Scale9Image(this.horizontalProgressBarBackgroundDisabledTexture, this.scale);
				backgroundDisabledSkin.width = this.wideControlSize;
				backgroundDisabledSkin.height = this.smallControlSize;
			}
			else //vertical
			{
				backgroundSkin = new Scale9Image(this.verticalProgressBarBackgroundTexture, this.scale);
				backgroundSkin.width = this.smallControlSize;
				backgroundSkin.height = this.wideControlSize;
				backgroundDisabledSkin = new Scale9Image(this.verticalProgressBarBackgroundDisabledTexture, this.scale);
				backgroundDisabledSkin.width = this.smallControlSize;
				backgroundDisabledSkin.height = this.wideControlSize;
			}
			progress.backgroundSkin = backgroundSkin;
			progress.backgroundDisabledSkin = backgroundDisabledSkin;

			var fillSkin:Scale9Image;
			var fillDisabledSkin:Scale9Image;
			/* Horizontal fill skin */
			if(progress.direction === ProgressBar.DIRECTION_HORIZONTAL)
			{
				fillSkin = new Scale9Image(this.horizontalProgressBarFillTexture, this.scale);
				fillSkin.width = this.smallControlSize;
				fillSkin.height = this.smallControlSize;
				fillDisabledSkin = new Scale9Image(this.horizontalProgressBarFillDisabledTexture, this.scale);
				fillDisabledSkin.width = this.smallControlSize;
				fillDisabledSkin.height = this.smallControlSize;
			}
			else //vertical
			{
				fillSkin = new Scale9Image(this.verticalProgressBarFillTexture, this.scale);
				fillSkin.width = this.smallControlSize;
				fillSkin.height = this.smallControlSize;
				fillDisabledSkin = new Scale9Image(verticalProgressBarFillDisabledTexture, this.scale);
				fillDisabledSkin.width = this.smallControlSize;
				fillDisabledSkin.height = this.smallControlSize;
			}
			progress.fillSkin = fillSkin;
			progress.fillDisabledSkin = fillDisabledSkin;
		}

	//-------------------------
	// Label
	//-------------------------

		protected function setLabelStyles(label:Label):void
		{
			label.textRendererProperties.elementFormat = this.darkUIElementFormat;
			label.textRendererProperties.disabledElementFormat = this.darkUIDisabledElementFormat;
		}

		protected function setHeadingLabelStyles(label:Label):void
		{
			label.textRendererProperties.elementFormat = this.darkUILargeElementFormat;
			label.textRendererProperties.disabledElementFormat = this.darkUILargeDisabledElementFormat;
		}

		protected function setDetailLabelStyles(label:Label):void
		{
			label.textRendererProperties.elementFormat = this.darkUISmallElementFormat;
			label.textRendererProperties.disabledElementFormat = this.darkUISmallDisabledElementFormat;
		}

	//-------------------------
	// LayoutGroup
	//-------------------------
		
		protected function setToolbarLayoutGroupStyles(group:LayoutGroup):void
		{
			if(!group.layout)
			{
				var layout:HorizontalLayout = new HorizontalLayout();
				layout.paddingTop = this.smallGutterSize;
				layout.paddingRight = this.smallGutterSize;
				layout.paddingBottom = this.smallGutterSize;
				layout.paddingLeft = this.smallGutterSize;
				layout.gap = this.smallGutterSize;
				group.layout = layout;
			}
			group.minWidth = this.controlSize;
			group.minHeight = this.controlSize;

			group.backgroundSkin = new Quad(10, 10, COLOR_BACKGROUND_LIGHT);
		}

	//-------------------------
	// List
	//-------------------------

		protected function setListStyles(list:List):void
		{
			this.setScrollerStyles(list);
			list.backgroundSkin = new Quad(10, 10, COLOR_BACKGROUND_LIGHT);
		}

		protected function setBaseItemRendererStyles(renderer:BaseDefaultItemRenderer):void
		{
			renderer.downLabelProperties.elementFormat = this.darkUIElementFormat;
			renderer.defaultLabelProperties.elementFormat = this.darkUIElementFormat;
			renderer.disabledLabelProperties.elementFormat = this.darkUIDisabledElementFormat;
			renderer.defaultSelectedLabelProperties.elementFormat = this.darkUIElementFormat;

			renderer.horizontalAlign = BaseDefaultItemRenderer.HORIZONTAL_ALIGN_LEFT;
			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingRight = this.gutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;
			renderer.gap = this.gutterSize;
			renderer.minGap = this.gutterSize;
			renderer.iconPosition = BaseDefaultItemRenderer.ICON_POSITION_LEFT;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.minAccessoryGap = this.gutterSize;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
			renderer.minWidth = this.controlSize;
			renderer.minHeight = this.controlSize;
			renderer.minTouchWidth = this.controlSize;
			renderer.minTouchHeight = this.controlSize;

			renderer.accessoryLoaderFactory = imageLoaderFactory;
			renderer.iconLoaderFactory = imageLoaderFactory;
		}

		protected function setItemRendererStyles(renderer:BaseDefaultItemRenderer):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.itemRendererUpTexture;
			skinSelector.defaultSelectedValue = this.itemRendererSelectedTexture;
			skinSelector.setValueForState(this.itemRendererSelectedTexture, Button.STATE_DOWN);
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			renderer.stateToSkinFunction = skinSelector.updateValue;

			this.setBaseItemRendererStyles(renderer);
		}

		protected function setItemRendererAccessoryLabelRendererStyles(renderer:TextBlockTextRenderer):void
		{
			renderer.elementFormat = this.darkUIElementFormat;
		}

		protected function setItemRendererIconLabelStyles(renderer:TextBlockTextRenderer):void
		{
			renderer.elementFormat = this.darkUIElementFormat;
		}

		protected function setSpinnerListItemRendererStyles(renderer:DefaultListItemRenderer):void
		{
			var defaultSkin:Quad = new Quad(1, 1, 0xff00ff);
			defaultSkin.alpha = 0;
			renderer.defaultSkin = defaultSkin;

			renderer.defaultLabelProperties.elementFormat = this.darkUIElementFormat;
			renderer.downLabelProperties.elementFormat = this.darkUIElementFormat;
			renderer.disabledLabelProperties.elementFormat = this.darkUIElementFormat;

			renderer.horizontalAlign = DefaultListItemRenderer.HORIZONTAL_ALIGN_LEFT;
			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;
			renderer.paddingRight = this.gutterSize;
			renderer.gap = this.smallGutterSize;
			renderer.minGap = this.smallGutterSize;
			renderer.iconPosition = Button.ICON_POSITION_LEFT;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.minAccessoryGap = this.smallGutterSize;
			renderer.accessoryPosition = DefaultListItemRenderer.ACCESSORY_POSITION_RIGHT;
			renderer.minWidth = this.gridSize;
			renderer.minHeight = this.gridSize;
			renderer.minTouchWidth = this.gridSize;
			renderer.minTouchHeight = this.gridSize;

			renderer.accessoryLoaderFactory = this.imageLoaderFactory;
			renderer.iconLoaderFactory = this.imageLoaderFactory;
		}

	//-------------------------
	// GroupedList
	//-------------------------

		protected function setGroupedListStyles(list:GroupedList):void
		{
			this.setScrollerStyles(list);
			list.backgroundSkin = new Quad(10, 10, COLOR_BACKGROUND_LIGHT);
			list.customFirstItemRendererStyleName = THEME_STYLE_NAME_GROUPED_LIST_FIRST_ITEM_RENDERER;
		}

		//see List section for item renderer styles

		protected function setGroupedListFirstItemRendererStyles(renderer:BaseDefaultItemRenderer):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.firstItemRendererUpTexture;
			skinSelector.defaultSelectedValue = this.itemRendererSelectedTexture;
			skinSelector.setValueForState(this.itemRendererSelectedTexture, Button.STATE_DOWN);
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			renderer.stateToSkinFunction = skinSelector.updateValue;

			this.setBaseItemRendererStyles(renderer);
		}

		protected function setGroupedListHeaderRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			renderer.backgroundSkin = new Scale9Image(this.groupedListHeaderTexture, this.scale);

			renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_LEFT;
			renderer.contentLabelProperties.elementFormat = this.darkUISmallElementFormat;
			renderer.contentLabelProperties.disabledElementFormat = this.darkUISmallDisabledElementFormat;
			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingRight = this.gutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;

			renderer.contentLoaderFactory = this.imageLoaderFactory;
		}

		protected function setGroupedListFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			renderer.backgroundSkin = new Scale9Image(this.groupedListFooterTexture, this.scale);

			renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_CENTER;
			renderer.contentLabelProperties.elementFormat = this.lightUIElementFormat;
			renderer.contentLabelProperties.disabledElementFormat = this.lightUIDisabledElementFormat;
			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingRight = this.gutterSize; 
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;

			renderer.contentLoaderFactory = this.imageLoaderFactory;
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
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.textInputBackgroundEnabledTexture;
			skinSelector.setValueForState(this.textInputBackgroundDisabledTexture, TextInput.STATE_DISABLED);
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			input.stateToSkinFunction = skinSelector.updateValue;

			input.minWidth = this.controlSize;
			input.minHeight = this.controlSize;
			input.padding = this.smallGutterSize;
			input.isEditable = false;
			input.isSelectable = false;
			input.textEditorFactory = stepperTextEditorFactory;
			input.textEditorProperties.elementFormat = this.darkUIElementFormat;
			input.textEditorProperties.disabledElementFormat = this.darkUIDisabledElementFormat;
			input.textEditorProperties.textAlign = TextBlockTextEditor.TEXT_ALIGN_CENTER;
		}

		protected function setNumericStepperButtonStyles(button:Button):void
		{
			setQuietButtonStyles(button);
			button.keepDownStateOnRollOut = true;
			button.defaultLabelProperties.elementFormat = this.darkUILargeElementFormat;
			button.disabledLabelProperties.elementFormat = this.darkUILargeDisabledElementFormat;
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
				list.listFactory = pickerListSpinnerListFactory;
				
				var popUpContentManager:BottomDrawerPopUpContentManager = new BottomDrawerPopUpContentManager();
				popUpContentManager.customPanelStyleName = THEME_STYLE_NAME_POP_UP_DRAWER;
				list.popUpContentManager = popUpContentManager;
			}
		}

		protected function setPickerListButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpTexture;
			skinSelector.setValueForState(this.buttonDownTexture, Button.STATE_DOWN);
			skinSelector.setValueForState(this.buttonDisabledTexture, Button.STATE_DISABLED);
			this.setBaseButtonSize(skinSelector);

			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);

			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
			iconSelector.defaultValue = this.pickerListButtonIcon;
			iconSelector.setValueForState(this.pickerListButtonDisabledIcon, Button.STATE_DISABLED);
			iconSelector.displayObjectProperties =
			{
				textureScale: this.scale,
				snapToPixels: true
			};
			button.stateToIconFunction = iconSelector.updateValue;

			button.gap = Number.POSITIVE_INFINITY;
			button.minGap = this.gutterSize;
			button.iconPosition = Button.ICON_POSITION_RIGHT;
			button.paddingLeft = this.gutterSize;
		}

		protected function setPickerListListStyles(list:List):void
		{
			if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				list.minWidth = this.wideControlSize;
				list.maxHeight = this.wideControlSize;
			}
			else //phone
			{
				//the pop-up list should be a SpinnerList in this case, but we
				//should provide a reasonable fallback skin if the listFactory
				//on the PickerList returns a List instead. we don't want the
				//List to be too big for the BottomDrawerPopUpContentManager
				
				list.padding = this.smallGutterSize;

				var layout:VerticalLayout = new VerticalLayout();
				layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
				layout.requestedRowCount = 4;
				list.layout = layout;
			}

			list.customItemRendererStyleName = DefaultListItemRenderer.ALTERNATE_STYLE_NAME_CHECK;
		}

		protected function setPickerListPopUpDrawerStyles(panel:Panel):void
		{
			this.setScrollerStyles(panel);
			
			panel.customHeaderStyleName = THEME_STYLE_NAME_POP_UP_DRAWER_HEADER;
			
			panel.backgroundSkin = new Scale9Image(this.popUpDrawerBackgroundTexture, this.scale);

			panel.outerPaddingTop = this.borderSize;
		}

	//-------------------------
	// SpinnerList
	//-------------------------

		protected function setSpinnerListStyles(list:SpinnerList):void
		{
			list.verticalScrollPolicy = List.SCROLL_POLICY_ON;
			list.backgroundSkin = new Quad(this.controlSize, this.controlSize, COLOR_SPINNER_LIST_BACKGROUND);
			list.selectionOverlaySkin = new Scale9Image(this.spinnerListSelectionOverlayTexture, this.scale);
			list.customItemRendererStyleName = THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER;
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
				layout.paddingTop = this.smallGutterSize;
				layout.paddingRight = this.smallGutterSize;
				layout.paddingBottom = this.smallGutterSize;
				layout.paddingLeft = this.smallGutterSize;
				layout.gap = this.smallGutterSize;
				container.layout = layout;
			}
			container.minWidth = this.controlSize;
			container.minHeight = this.controlSize;

			container.backgroundSkin = new Quad(10, 10, COLOR_BACKGROUND_LIGHT);
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

		protected function setSimpleScrollBarStyles(scrollBar:SimpleScrollBar):void
		{
			if(scrollBar.direction === SimpleScrollBar.DIRECTION_HORIZONTAL)
			{
				scrollBar.customThumbStyleName = THEME_STYLE_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB;
			}
			else //vertical
			{
				scrollBar.customThumbStyleName = THEME_STYLE_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB;
			}
			scrollBar.paddingTop = this.extraSmallGutterSize;
			scrollBar.paddingRight = this.extraSmallGutterSize;
			scrollBar.paddingBottom = this.extraSmallGutterSize;
		}

		protected function setHorizontalSimpleScrollBarThumbStyles(thumb:Button):void
		{
			var defaultSkin:Scale3Image = new Scale3Image(this.horizontalSimpleScrollBarThumbTexture, this.scale);
			thumb.defaultSkin = defaultSkin;
			thumb.hasLabelTextRenderer = false;
		}

		protected function setVerticalSimpleScrollBarThumbStyles(thumb:Button):void
		{
			var defaultSkin:Scale3Image = new Scale3Image(this.verticalSimpleScrollBarThumbTexture, this.scale);
			thumb.defaultSkin = defaultSkin;
			thumb.hasLabelTextRenderer = false;
		}

	//-------------------------
	// PageIndicator
	//-------------------------

		protected function setPageIndicatorStyles(pageIndicator:PageIndicator):void
		{
			pageIndicator.normalSymbolFactory = pageIndicatorNormalSymbolFactory;
			pageIndicator.selectedSymbolFactory = pageIndicatorSelectedSymbolFactory;
			pageIndicator.gap = this.gutterSize;
			pageIndicator.padding = this.gutterSize;
			pageIndicator.minTouchWidth = this.controlSize;
			pageIndicator.minTouchHeight = this.controlSize;
		}

	//-------------------------
	// Panel
	//-------------------------

		protected function setPanelStyles(panel:Panel):void
		{
			this.setScrollerStyles(panel);

			panel.backgroundSkin = new Scale9Image(this.popUpBackgroundTexture, this.scale);

			panel.paddingTop = this.smallGutterSize;
			panel.paddingRight = this.smallGutterSize;
			panel.paddingBottom = this.smallGutterSize;
			panel.paddingLeft = this.smallGutterSize;
		}

		protected function setHeaderWithoutBackgroundStyles(header:Header):void
		{
			header.gap = this.gutterSize;
			header.paddingTop = this.smallGutterSize;
			header.paddingRight = this.smallGutterSize;
			header.paddingBottom = this.smallGutterSize;
			header.paddingLeft = this.smallGutterSize;
			header.titleGap = this.smallGutterSize;
			header.minHeight = this.gridSize;
			header.titleProperties.elementFormat = this.darkUILargeElementFormat;
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
			this.setHeaderStyles(header);
			header.useExtraPaddingForOSStatusBar = true;
		}

	//-------------------------
	// Header
	//-------------------------

		protected function setHeaderStyles(header:Header):void
		{
			this.setHeaderWithoutBackgroundStyles(header);

			var backgroundSkin:Scale9Image = new Scale9Image(this.headerBackgroundSkinTexture, this.scale);
			backgroundSkin.width = this.gridSize;
			backgroundSkin.height = this.gridSize;
			header.backgroundSkin = backgroundSkin;
			header.titleProperties.elementFormat = this.darkUILargeElementFormat;
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
			tab.defaultSkin = new Scale9Image(this.tabUpTexture, this.scale);
			tab.downSkin = new Scale9Image(this.tabDownTexture, this.scale);
			//no skin for disabled state (just different label)
			tab.defaultSelectedSkin = new Scale9Image(this.tabSelectedUpTexture, this.scale);
			tab.selectedDisabledSkin = new Scale9Image(this.tabSelectedDisabledTexture, this.scale);
			tab.selectedDownSkin = new Scale9Image(this.tabSelectedDownTexture, this.scale);

			tab.defaultLabelProperties.elementFormat = this.darkUIElementFormat;
			tab.defaultSelectedLabelProperties.elementFormat = this.blueUIElementFormat;
			tab.disabledLabelProperties.elementFormat = this.darkUIDisabledElementFormat;
			tab.selectedDisabledLabelProperties.elementFormat = this.blueUIDisabledElementFormat;

			tab.paddingLeft = this.gutterSize;
			tab.paddingRight = this.gutterSize;
			tab.minWidth = this.wideControlSize;
			tab.minHeight = this.wideControlSize;
		}

	//-------------------------
	// Slider
	//-------------------------

		protected function setSliderStyles(slider:Slider):void
		{
			slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_MIN_MAX;
			if(slider.direction === Slider.DIRECTION_VERTICAL)
			{
				slider.customThumbStyleName = THEME_STYLE_NAME_VERTICAL_SLIDER_THUMB;
				slider.customMinimumTrackStyleName = THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK;
				slider.customMaximumTrackStyleName = THEME_STYLE_NAME_VERTICAL_SLIDER_MAXIMUM_TRACK;
			}
			else //horizontal
			{
				slider.customThumbStyleName = THEME_STYLE_NAME_HORIZONTAL_SLIDER_THUMB;
				slider.customMinimumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK;
				slider.customMaximumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_SLIDER_MAXIMUM_TRACK;
			}
		}

		protected function setHorizontalSliderMinimumTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.horizontalSliderMinimumTrackTexture;
			skinSelector.setValueForState(this.horizontalSliderMinimumTrackDisabledTexture, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			skinSelector.displayObjectProperties.width = this.wideControlSize - this.thumbSize / 2;
			skinSelector.displayObjectProperties.height = this.smallControlSize;
			track.stateToSkinFunction = skinSelector.updateValue;
			track.hasLabelTextRenderer = false;
		}

		protected function setHorizontalSliderMaximumTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.horizontalSliderMaximumTrackTexture;
			skinSelector.setValueForState(this.horizontalSliderMaximumTrackDisabledTexture, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			skinSelector.displayObjectProperties.width = this.wideControlSize - this.thumbSize / 2;
			skinSelector.displayObjectProperties.height = this.smallControlSize;
			track.stateToSkinFunction = skinSelector.updateValue;
			track.hasLabelTextRenderer = false;
		}

		protected function setVerticalSliderMinimumTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.verticalSliderMinimumTrackTexture;
			skinSelector.setValueForState(this.verticalSliderMinimumTrackDisabledTexture, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			skinSelector.displayObjectProperties.width = this.smallControlSize;
			skinSelector.displayObjectProperties.height = this.wideControlSize - this.thumbSize / 2
			track.stateToSkinFunction = skinSelector.updateValue;
			track.hasLabelTextRenderer = false;
		}

		protected function setVerticalSliderMaximumTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.verticalSliderMaximumTrackTexture;
			skinSelector.setValueForState(this.verticalSliderMaximumTrackDisabledTexture, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: scale
			};
			skinSelector.displayObjectProperties.width = this.smallControlSize;
			skinSelector.displayObjectProperties.height = this.wideControlSize - this.thumbSize / 2
			track.stateToSkinFunction = skinSelector.updateValue;
			track.hasLabelTextRenderer = false;
		}

	//-------------------------
	// TextArea
	//-------------------------

		protected function setTextAreaStyles(textArea:TextArea):void
		{
			this.setScrollerStyles(textArea);

			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.textInputBackgroundEnabledTexture;
			skinSelector.setValueForState(this.textInputBackgroundFocusedTexture, TextInput.STATE_FOCUSED);
			skinSelector.setValueForState(this.textInputBackgroundDisabledTexture, TextInput.STATE_DISABLED);
			skinSelector.displayObjectProperties =
			{
				width: this.wideControlSize,
				height: this.wideControlSize,
				textureScale: this.scale
			};
			textArea.stateToSkinFunction = skinSelector.updateValue;

			textArea.padding = this.smallGutterSize;

			textArea.textEditorProperties.textFormat = this.scrollTextTextFormat;
			textArea.textEditorProperties.disabledTextFormat = this.scrollTextDisabledTextFormat;
		}

	//-------------------------
	// TextInput
	//-------------------------

		protected function setBaseTextInputStyles(input:TextInput):void
		{
			input.textEditorProperties.fontFamily = "Helvetica";
			input.textEditorProperties.fontSize = this.inputFontSize;
			input.textEditorProperties.color = COLOR_TEXT_DARK;
			input.textEditorProperties.disabledColor = COLOR_TEXT_DARK_DISABLED;

			input.promptProperties.elementFormat = this.darkUIElementFormat;
			input.promptProperties.disabledElementFormat = this.darkUIDisabledElementFormat;

			input.minWidth = this.wideControlSize;
			input.minHeight = this.controlSize;
			input.paddingTop = this.smallGutterSize;
			input.paddingRight = this.gutterSize;
			input.paddingBottom = this.smallGutterSize;
			input.paddingLeft = this.gutterSize;
			input.gap = this.smallGutterSize;
		}

		protected function setTextInputStyles(input:TextInput):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.textInputBackgroundEnabledTexture;
			skinSelector.setValueForState(this.textInputBackgroundFocusedTexture, TextInput.STATE_FOCUSED);
			skinSelector.setValueForState(this.textInputBackgroundDisabledTexture, TextInput.STATE_DISABLED);
			skinSelector.displayObjectProperties =
			{
				width: this.wideControlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			input.stateToSkinFunction = skinSelector.updateValue;

			this.setBaseTextInputStyles(input);
		}

		protected function setSearchTextInputStyles(input:TextInput):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.searchTextInputBackgroundEnabledTexture;
			skinSelector.setValueForState(this.searchTextInputBackgroundFocusedTexture, TextInput.STATE_FOCUSED);
			skinSelector.setValueForState(this.searchTextInputBackgroundDisabledTexture, TextInput.STATE_DISABLED);
			skinSelector.displayObjectProperties =
			{
				width: this.wideControlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			input.stateToSkinFunction = skinSelector.updateValue;

			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
			iconSelector.defaultValue = this.searchIconTexture;
			iconSelector.displayObjectProperties =
			{
				textureScale: this.scale,
				snapToPixels: true
			};
			input.stateToIconFunction = iconSelector.updateValue;

			this.setBaseTextInputStyles(input);
		}

	//-------------------------
	// Callout
	//-------------------------

		protected function setCalloutStyles(callout:Callout):void
		{
			var backgroundSkin:Scale9Image = new Scale9Image(this.popUpBackgroundTexture, this.scale);
			backgroundSkin.width = this.calloutBackgroundMinSize;
			backgroundSkin.height = this.calloutBackgroundMinSize;
			callout.backgroundSkin = backgroundSkin;

			var topArrowSkin:Image = new Image(this.calloutTopArrowTexture);
			topArrowSkin.scaleX = this.scale;
			topArrowSkin.scaleY = this.scale;
			callout.topArrowSkin = topArrowSkin;
			callout.topArrowGap = -16 * this.scale;

			var rightArrowSkin:Image = new Image(this.calloutRightArrowTexture);
			rightArrowSkin.scaleX = this.scale;
			rightArrowSkin.scaleY = scale;
			callout.rightArrowSkin = rightArrowSkin;
			callout.rightArrowGap = -14 * this.scale;

			var bottomArrowSkin:Image = new Image(this.calloutBottomArrowTexture);
			bottomArrowSkin.scaleX = this.scale;
			bottomArrowSkin.scaleY = this.scale;
			callout.bottomArrowSkin = bottomArrowSkin;
			callout.bottomArrowGap = -16 * this.scale;

			var leftArrowSkin:Image = new Image(this.calloutLeftArrowTexture);
			leftArrowSkin.scaleX = this.scale;
			leftArrowSkin.scaleY = this.scale;
			callout.leftArrowSkin = leftArrowSkin;
			callout.leftArrowGap = -14 * this.scale;

			callout.padding = this.gutterSize;
		}

	//-------------------------
	// Alert
	//-------------------------

		protected function setAlertStyles(alert:Alert):void
		{
			this.setScrollerStyles(alert);

			alert.backgroundSkin = new Scale9Image(this.popUpBackgroundTexture, this.scale);

			alert.paddingTop = 0;
			alert.paddingRight = this.gutterSize;
			alert.paddingBottom = this.gutterSize;
			alert.paddingLeft = this.gutterSize;
			alert.gap = this.gutterSize;
			alert.maxWidth = this.popUpFillSize;
			alert.maxHeight = this.popUpFillSize;
		}

		//see Panel section for Header styles

		protected function setAlertButtonGroupStyles(group:ButtonGroup):void
		{
			group.direction = ButtonGroup.DIRECTION_HORIZONTAL;
			group.horizontalAlign = ButtonGroup.HORIZONTAL_ALIGN_CENTER;
			group.verticalAlign = ButtonGroup.VERTICAL_ALIGN_JUSTIFY;
			group.distributeButtonSizes = false;
			group.gap = this.gutterSize;
			group.padding = this.gutterSize;
			group.paddingTop = 0;
			group.customLastButtonStyleName = THEME_STYLE_NAME_ALERT_BUTTON_GROUP_LAST_BUTTON;
			group.customButtonStyleName = THEME_STYLE_NAME_ALERT_BUTTON_GROUP_BUTTON;
		}

		protected function setAlertButtonGroupButtonStyles(button:Button):void
		{
			this.setButtonStyles(button);
			button.minWidth = this.controlSize * 2;
		}

		protected function setAlertButtonGroupLastButtonStyles(button:Button):void
		{
			this.setCallToActionButtonStyles(button);
			button.minWidth = this.controlSize * 2;
		}

		protected function setAlertMessageTextRendererStyles(renderer:TextBlockTextRenderer):void
		{
			renderer.wordWrap = true;
			renderer.elementFormat = this.darkUIElementFormat;
		}

	//-------------------------
	// Drawers
	//-------------------------

		protected function setDrawersStyles(drawers:Drawers):void
		{
			var overlaySkin:Quad = new Quad(10, 10, COLOR_DRAWER_OVERLAY);
			overlaySkin.alpha = ALPHA_DRAWER_OVERLAY;
			drawers.overlaySkin = overlaySkin;
		}

		protected function setBaseToggleSwitchSize(skinSelector:SmartDisplayObjectStateValueSelector):void
		{
			skinSelector.displayObjectProperties =
			{
				width: this.gridSize,
				height: this.controlSize,
				textureScale: this.scale
			};
		}

	}

}
