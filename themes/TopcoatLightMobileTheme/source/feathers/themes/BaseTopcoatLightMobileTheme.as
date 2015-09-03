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
	import feathers.controls.popups.DropDownPopUpContentManager;
	import feathers.controls.popups.VerticalCenteredPopUpContentManager;
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

		/* Colors */
		protected static const COLOR_TEXT_DARK:uint = 0x454545;
		protected static const COLOR_TEXT_DARK_DISABLED:uint = 0x848585;
		protected static const COLOR_TEXT_LIGHT:uint = 0xFFFFFF;
		protected static const COLOR_TEXT_LIGHT_DISABLED:uint = 0xCCCCCC;
		protected static const COLOR_TEXT_BLUE:uint = 0x0083E8;
		protected static const COLOR_TEXT_BLUE_DISABLED:uint = 0xC6DFF3;
		protected static const COLOR_TEXT_DANGER_DISABLED:uint = 0xF7B4AF;
		protected static const COLOR_BACKGROUND_LIGHT:uint = 0xDFE2E2;
		protected static const COLOR_MODAL_OVERLAY:uint = 0xDFE2E2;
		protected static const ALPHA_MODAL_OVERLAY:Number = 0.8;
		protected static const COLOR_DRAWER_OVERLAY:uint = 0x454545;
		protected static const ALPHA_DRAWER_OVERLAY:Number = 0.8;

		/* Scale 9 Grids */
		protected static const BUTTON_SCALE9_GRID:Rectangle = new Rectangle( 10, 10, 12, 80);
		protected static const BUTTON_BACK_SCALE9_GRID:Rectangle = new Rectangle( 52, 10, 20, 80);
		protected static const BUTTON_FORWARD_SCALE9_GRID:Rectangle = new Rectangle( 10, 10, 20, 80);
		protected static const TOGGLE_BUTTON_SCALE9_GRID:Rectangle = new Rectangle( 16, 16, 10, 68);
		protected static const BUTTON_THUMB_HORIZONTAL_SCALE9_GRID:Rectangle = new Rectangle( 31, 31, 4, 38);
		protected static const BUTTON_THUMB_VERTICAL_SCALE9_GRID:Rectangle = new Rectangle( 31, 31, 38, 4);
		protected static const BAR_HORIZONTAL_SCALE9_GRID:Rectangle = new Rectangle( 16, 15, 1, 2);
		protected static const BAR_VERTICAL_SCALE9_GRID:Rectangle = new Rectangle( 15, 16, 2, 1);
		protected static const HEADER_BACKGROUND_SCALE9_GRID:Rectangle = new Rectangle( 5, 5, 20, 112);
		protected static const TAB_SCALE9_GRID:Rectangle = new Rectangle( 5, 5, 10, 110);
		protected static const SEARCH_INPUT_SCALE9_GRID:Rectangle = new Rectangle( 50, 49, 20, 2);
		protected static const BACKGROUND_POPUP_SCALE9_GRID:Rectangle = new Rectangle( 8, 8, 24, 24);
		protected static const LIST_ITEM_SCALE9_GRID:Rectangle = new Rectangle( 4, 4, 2, 92);
		protected static const GROUPED_LIST_HEADER_OR_FOOTER_SCALE9_GRID:Rectangle = new Rectangle( 4, 4, 2, 42);
		protected static const PICKER_LIST_LIST_BACKGROUND_SCALE9_GRID:Rectangle = new Rectangle( 20, 20, 2, 72);
		protected static const SPINNER_LIST_OVERLAY_SCALE9_GRID:Rectangle = new Rectangle( 9, 9, 6, 6);
		protected static const SCROLL_BAR_REGION1:int = 9;
		protected static const SCROLL_BAR_REGION2:int = 34;

		/* Name list */
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
		protected static const THEME_STYLE_NAME_GROUPED_LIST_LAST_ITEM_RENDERER:String = "topcoat-light-mobile-grouped-list-last-item-renderer";
		protected static const THEME_STYLE_NAME_DROP_DOWN_LIST_ITEM_RENDERER:String = "topcoat-light-mobile-picker-list-item-renderer";
		protected static const THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER:String = "topcoat-light-mobile-spinner-list-item-renderer";

		public function BaseTopcoatLightMobileTheme(scaleToDPI:Boolean = true)
		{
			super();
			this._scaleToDPI = scaleToDPI;
		}

		/* Dimensions */
		protected var smallPaddingSize:int;
		protected var regularPaddingSize:int;
		protected var trackSize:int;
		protected var controlSize:int;
		protected var wideControlSize:int;
		protected var headerSize:int;

		/* Fonts */
		protected var smallFontSize:int;
		protected var regularFontSize:int;
		protected var largeFontSize:int;

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

		/* Textures */
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
		protected var toggleButtonSelectedDownTexture:Scale9Textures;
		protected var toggleButtonSelectedDisabledTexture:Scale9Textures;
		protected var toggleSwitchOnTrackTexture:Scale9Textures;
		protected var horizontalThumbUpTexture:Scale9Textures;
		protected var horizontalThumbDownTexture:Scale9Textures;
		protected var horizontalThumbDisabledTexture:Scale9Textures;
		protected var verticalThumbUpTexture:Scale9Textures;
		protected var verticalThumbDownTexture:Scale9Textures;
		protected var verticalThumbDisabledTexture:Scale9Textures;
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
		protected var horizontalSliderMinimumTrackTexture:Scale9Textures;
		protected var horizontalSliderMaximumTrackTexture:Scale9Textures;
		protected var horizontalSliderDisabledTrackTexture:Scale9Textures;
		protected var verticalSliderMinimumTrackTexture:Scale9Textures;
		protected var verticalSliderMaximumTrackTexture:Scale9Textures;
		protected var verticalSliderDisabledTrackTexture:Scale9Textures;
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
		protected var itemRendererDownTexture:Scale9Textures;
		protected var itemRendererSelectedTexture:Scale9Textures;
		protected var lastItemRendererUpTexture:Scale9Textures;
		protected var lastItemRendererDownTexture:Scale9Textures;
		protected var lastItemRendererSelectedTexture:Scale9Textures;
		protected var groupedListHeaderTexture:Scale9Textures;
		protected var groupedListFooterTexture:Scale9Textures;
		protected var pickerListItemRendererUpTexture:Scale9Textures;
		protected var pickerListItemRendererDownTexture:Scale9Textures;
		protected var pickerListItemRendererSelectedTexture:Scale9Textures;
		protected var pickerListButtonIcon:Texture;
		protected var pickerListButtonDisabledIcon:Texture;
		protected var pickerListButtonUpTexture:Scale9Textures;
		protected var pickerListListBackgroundTexture:Scale9Textures;
		protected var spinnerListSelectionOverlayTexture:Scale9Textures;
		protected var pageIndicatorNormalTexture:Texture;
		protected var pageIndicatorSelectedTexture:Texture;

		protected var scale:Number;
		
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
			var scaledDPI:int = DeviceCapabilities.dpi / Starling.contentScaleFactor;
			this._originalDPI = scaledDPI;
			if(this.scaleToDPI)
			{
				if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
				{
					this._originalDPI = ORIGINAL_DPI_IPAD_RETINA;
				}
				else
				{
					this._originalDPI = ORIGINAL_DPI_IPHONE_RETINA;
				}
			}
			this.scale = scaledDPI / this._originalDPI;
		}

		protected function initializeDimensions():void
		{
			this.smallPaddingSize = Math.round(20 * this.scale);
			this.regularPaddingSize = Math.round(40 * this.scale);
			this.trackSize = Math.round(32 * this.scale);
			this.controlSize = Math.round(100 * this.scale);
			this.wideControlSize = Math.round(120 * this.scale);
			this.headerSize = Math.round(122 * this.scale);
		}

		protected function initializeTextures():void
		{
			this.popUpBackgroundTexture = new Scale9Textures(this.atlas.getTexture("background-popup-skin"), BACKGROUND_POPUP_SCALE9_GRID);

			this.buttonUpTexture = new Scale9Textures(this.atlas.getTexture("button-up-skin"), BUTTON_SCALE9_GRID);
			this.buttonDownTexture = new Scale9Textures(this.atlas.getTexture("button-down-skin"), BUTTON_SCALE9_GRID);
			this.buttonDisabledTexture = new Scale9Textures(this.atlas.getTexture("button-disabled-skin"), BUTTON_SCALE9_GRID);
			this.quietButtonDownTexture = new Scale9Textures(this.atlas.getTexture("button-down-skin"), BUTTON_SCALE9_GRID);
			this.dangerButtonUpTexture = new Scale9Textures(this.atlas.getTexture("button-danger-up-skin"), BUTTON_SCALE9_GRID);
			this.dangerButtonDownTexture = new Scale9Textures(this.atlas.getTexture("button-danger-down-skin"), BUTTON_SCALE9_GRID);
			this.dangerButtonDisabledTexture = new Scale9Textures(this.atlas.getTexture("button-danger-disabled-skin"), BUTTON_SCALE9_GRID);
			this.callToActionButtonUpTexture = new Scale9Textures(this.atlas.getTexture("button-call-to-action-up-skin"), BUTTON_SCALE9_GRID);
			this.callToActionButtonDownTexture = new Scale9Textures(this.atlas.getTexture("button-call-to-action-down-skin"), BUTTON_SCALE9_GRID);
			this.callToActionButtonDisabledTexture = new Scale9Textures(this.atlas.getTexture("button-call-to-action-disabled-skin"), BUTTON_SCALE9_GRID);
			this.backButtonUpTexture = new Scale9Textures(this.atlas.getTexture("button-back-up-skin"), BUTTON_BACK_SCALE9_GRID);
			this.backButtonDownTexture = new Scale9Textures(this.atlas.getTexture("button-back-down-skin"), BUTTON_BACK_SCALE9_GRID);
			this.backButtonDisabledTexture = new Scale9Textures(this.atlas.getTexture("button-back-disabled-skin"), BUTTON_BACK_SCALE9_GRID);
			this.forwardButtonUpTexture = new Scale9Textures(this.atlas.getTexture("button-forward-up-skin"), BUTTON_FORWARD_SCALE9_GRID);
			this.forwardButtonDownTexture = new Scale9Textures(this.atlas.getTexture("button-forward-down-skin"), BUTTON_FORWARD_SCALE9_GRID);
			this.forwardButtonDisabledTexture = new Scale9Textures(this.atlas.getTexture("button-forward-disabled-skin"), BUTTON_FORWARD_SCALE9_GRID);
			this.toggleButtonSelectedUpTexture = new Scale9Textures(this.atlas.getTexture("button-selected-up-skin"), TOGGLE_BUTTON_SCALE9_GRID);
			this.toggleButtonSelectedDownTexture = new Scale9Textures(this.atlas.getTexture("button-selected-down-skin"), TOGGLE_BUTTON_SCALE9_GRID);
			this.toggleButtonSelectedDisabledTexture = new Scale9Textures(this.atlas.getTexture("button-selected-disabled-skin"), TOGGLE_BUTTON_SCALE9_GRID);
			this.horizontalThumbUpTexture = new Scale9Textures(this.atlas.getTexture("button-thumb-horizontal-up-skin"), BUTTON_THUMB_HORIZONTAL_SCALE9_GRID);
			this.horizontalThumbDownTexture = new Scale9Textures(this.atlas.getTexture("button-thumb-horizontal-down-skin"), BUTTON_THUMB_HORIZONTAL_SCALE9_GRID);
			this.horizontalThumbDisabledTexture = new Scale9Textures(this.atlas.getTexture("button-thumb-horizontal-disabled-skin"), BUTTON_THUMB_HORIZONTAL_SCALE9_GRID);
			this.verticalThumbUpTexture = new Scale9Textures(this.atlas.getTexture("button-thumb-vertical-up-skin"), BUTTON_THUMB_VERTICAL_SCALE9_GRID);
			this.verticalThumbDownTexture = new Scale9Textures(this.atlas.getTexture("button-thumb-vertical-down-skin"), BUTTON_THUMB_VERTICAL_SCALE9_GRID);
			this.verticalThumbDisabledTexture = new Scale9Textures(this.atlas.getTexture("button-thumb-vertical-disabled-skin"), BUTTON_THUMB_VERTICAL_SCALE9_GRID);

			this.calloutTopArrowTexture = this.atlas.getTexture("callout-arrow-top-skin");
			this.calloutRightArrowTexture = this.atlas.getTexture("callout-arrow-right-skin");
			this.calloutBottomArrowTexture = this.atlas.getTexture("callout-arrow-bottom-skin");
			this.calloutLeftArrowTexture = this.atlas.getTexture("callout-arrow-left-skin");

			this.checkUpIconTexture = this.atlas.getTexture("check-up-icon");
			this.checkDownIconTexture = this.atlas.getTexture("check-down-icon");
			this.checkDisabledIconTexture = this.atlas.getTexture("check-disabled-icon");
			this.checkSelectedUpIconTexture = this.atlas.getTexture("check-selected-up-icon");
			this.checkSelectedDownIconTexture = this.atlas.getTexture("check-selected-down-icon");
			this.checkSelectedDisabledIconTexture = this.atlas.getTexture("check-selected-disabled-icon");

			this.headerBackgroundSkinTexture = new Scale9Textures(this.atlas.getTexture("header-background-skin"), HEADER_BACKGROUND_SCALE9_GRID);

			this.itemRendererUpTexture = new Scale9Textures(this.atlas.getTexture("list-item-up-skin"), LIST_ITEM_SCALE9_GRID);
			this.itemRendererDownTexture = new Scale9Textures(this.atlas.getTexture("list-item-down-skin"), LIST_ITEM_SCALE9_GRID);
			this.itemRendererSelectedTexture = new Scale9Textures(this.atlas.getTexture("list-item-selected-skin"), LIST_ITEM_SCALE9_GRID);
			this.lastItemRendererUpTexture = new Scale9Textures(this.atlas.getTexture("list-last-item-up-skin"), LIST_ITEM_SCALE9_GRID);
			this.lastItemRendererDownTexture = new Scale9Textures(this.atlas.getTexture("list-last-item-down-skin"), LIST_ITEM_SCALE9_GRID);
			this.lastItemRendererSelectedTexture = new Scale9Textures(this.atlas.getTexture("list-last-item-selected-skin"), LIST_ITEM_SCALE9_GRID);
			this.groupedListHeaderTexture = new Scale9Textures(this.atlas.getTexture("grouped-list-header-skin"), GROUPED_LIST_HEADER_OR_FOOTER_SCALE9_GRID);
			this.groupedListFooterTexture = new Scale9Textures(this.atlas.getTexture("grouped-list-footer-skin"), GROUPED_LIST_HEADER_OR_FOOTER_SCALE9_GRID);

			this.pageIndicatorNormalTexture = this.atlas.getTexture("page-indicator-normal-skin");
			this.pageIndicatorSelectedTexture = this.atlas.getTexture("page-indicator-selected-skin");

			this.pickerListButtonUpTexture = new Scale9Textures(this.atlas.getTexture("button-picker-list-up-skin"), BUTTON_SCALE9_GRID);
			this.pickerListListBackgroundTexture = new Scale9Textures(this.atlas.getTexture("picker-list-list-background-skin"), PICKER_LIST_LIST_BACKGROUND_SCALE9_GRID);
			this.pickerListButtonIcon = this.atlas.getTexture("picker-list-button-icon");
			this.pickerListButtonDisabledIcon = this.atlas.getTexture("picker-list-button-disabled-icon");
			this.pickerListItemRendererUpTexture = new Scale9Textures(this.atlas.getTexture("picker-list-list-item-up-skin"), LIST_ITEM_SCALE9_GRID);
			this.pickerListItemRendererDownTexture = new Scale9Textures(this.atlas.getTexture("picker-list-list-item-down-skin"), LIST_ITEM_SCALE9_GRID);
			this.pickerListItemRendererSelectedTexture = new Scale9Textures(this.atlas.getTexture("picker-list-list-item-selected-skin"), LIST_ITEM_SCALE9_GRID);

			this.horizontalProgressBarFillTexture = new Scale9Textures(this.atlas.getTexture("progress-bar-horizontal-fill-skin"), BAR_HORIZONTAL_SCALE9_GRID);
			this.horizontalProgressBarFillDisabledTexture = new Scale9Textures(this.atlas.getTexture("progress-bar-horizontal-fill-disabled-skin"), BAR_HORIZONTAL_SCALE9_GRID);
			this.horizontalProgressBarBackgroundTexture = new Scale9Textures(this.atlas.getTexture("progress-bar-horizontal-background-skin"), BAR_HORIZONTAL_SCALE9_GRID);
			this.horizontalProgressBarBackgroundDisabledTexture = new Scale9Textures(this.atlas.getTexture("progress-bar-horizontal-background-disabled-skin"), BAR_HORIZONTAL_SCALE9_GRID);
			this.verticalProgressBarFillTexture = new Scale9Textures(this.atlas.getTexture("progress-bar-vertical-fill-skin"), BAR_VERTICAL_SCALE9_GRID);
			this.verticalProgressBarFillDisabledTexture = new Scale9Textures(this.atlas.getTexture("progress-bar-vertical-fill-disabled-skin"), BAR_VERTICAL_SCALE9_GRID);
			this.verticalProgressBarBackgroundTexture = new Scale9Textures(this.atlas.getTexture("progress-bar-vertical-background-skin"), BAR_VERTICAL_SCALE9_GRID);
			this.verticalProgressBarBackgroundDisabledTexture = new Scale9Textures(this.atlas.getTexture("progress-bar-vertical-background-disabled-skin"), BAR_VERTICAL_SCALE9_GRID);

			this.radioUpIconTexture = this.atlas.getTexture("radio-up-icon");
			this.radioDownIconTexture = this.atlas.getTexture("radio-down-icon");
			this.radioDisabledIconTexture = this.atlas.getTexture("radio-disabled-icon");
			this.radioSelectedUpIconTexture = this.atlas.getTexture("radio-selected-up-icon");
			this.radioSelectedDownIconTexture = this.atlas.getTexture("radio-selected-down-icon");
			this.radioSelectedDisabledIconTexture = this.atlas.getTexture("radio-selected-disabled-icon");

			this.verticalSimpleScrollBarThumbTexture = new Scale3Textures(this.atlas.getTexture("simple-scroll-bar-vertical-thumb-skin"), SCROLL_BAR_REGION1, SCROLL_BAR_REGION2, Scale3Textures.DIRECTION_VERTICAL);
			this.horizontalSimpleScrollBarThumbTexture = new Scale3Textures(this.atlas.getTexture("simple-scroll-bar-horizontal-thumb-skin"), SCROLL_BAR_REGION1, SCROLL_BAR_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);

			this.horizontalSliderMinimumTrackTexture = new Scale9Textures(this.atlas.getTexture("slider-horizontal-minimum-track-skin"), BAR_HORIZONTAL_SCALE9_GRID);
			this.horizontalSliderMaximumTrackTexture = new Scale9Textures(this.atlas.getTexture("slider-horizontal-maximum-track-skin"), BAR_HORIZONTAL_SCALE9_GRID);
			this.horizontalSliderDisabledTrackTexture = new Scale9Textures(this.atlas.getTexture("slider-horizontal-disabled-track-skin"), BAR_HORIZONTAL_SCALE9_GRID);
			this.verticalSliderMinimumTrackTexture = new Scale9Textures(this.atlas.getTexture("slider-vertical-minimum-track-skin"), BAR_VERTICAL_SCALE9_GRID);
			this.verticalSliderMaximumTrackTexture = new Scale9Textures(this.atlas.getTexture("slider-vertical-maximum-track-skin"), BAR_VERTICAL_SCALE9_GRID);
			this.verticalSliderDisabledTrackTexture = new Scale9Textures(this.atlas.getTexture("slider-vertical-disabled-track-skin"), BAR_VERTICAL_SCALE9_GRID);

			this.spinnerListSelectionOverlayTexture = new Scale9Textures(this.atlas.getTexture("spinner-list-selection-overlay-skin"), SPINNER_LIST_OVERLAY_SCALE9_GRID);

			this.tabUpTexture = new Scale9Textures(this.atlas.getTexture("tab-up-skin"), TAB_SCALE9_GRID);
			this.tabDownTexture = new Scale9Textures(this.atlas.getTexture("tab-down-skin"), TAB_SCALE9_GRID);
			this.tabSelectedUpTexture = new Scale9Textures(this.atlas.getTexture("tab-selected-up-skin"), TAB_SCALE9_GRID);
			this.tabSelectedDownTexture = new Scale9Textures(this.atlas.getTexture("tab-selected-down-skin"), TAB_SCALE9_GRID);
			this.tabSelectedDisabledTexture = new Scale9Textures(this.atlas.getTexture("tab-selected-disabled-skin"), TAB_SCALE9_GRID);

			this.textInputBackgroundEnabledTexture = new Scale9Textures(this.atlas.getTexture("text-input-up-skin"), BUTTON_SCALE9_GRID);
			this.textInputBackgroundFocusedTexture = new Scale9Textures(this.atlas.getTexture("text-input-focused-skin"), BUTTON_SCALE9_GRID);
			this.textInputBackgroundDisabledTexture = new Scale9Textures(this.atlas.getTexture("text-input-disabled-skin"), BUTTON_SCALE9_GRID);
			this.searchTextInputBackgroundEnabledTexture = new Scale9Textures(this.atlas.getTexture("search-input-up-skin"), SEARCH_INPUT_SCALE9_GRID);
			this.searchTextInputBackgroundFocusedTexture = new Scale9Textures(this.atlas.getTexture("search-input-focused-skin"), SEARCH_INPUT_SCALE9_GRID);
			this.searchTextInputBackgroundDisabledTexture = new Scale9Textures(this.atlas.getTexture("search-input-disabled-skin"), SEARCH_INPUT_SCALE9_GRID);
			this.searchIconTexture = this.atlas.getTexture("search-input-icon");

			this.toggleSwitchOnTrackTexture = new Scale9Textures(this.atlas.getTexture("toggle-switch-on-skin"), BUTTON_SCALE9_GRID);
		}

		protected function initializeFonts():void
		{
			this.smallFontSize = Math.round(24 * this.scale);
			this.regularFontSize = Math.round(32 * this.scale);
			this.largeFontSize = Math.round(42 * this.scale);

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
			//custom style for the last item in GroupedList (without shadow at the bottom)
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_GROUPED_LIST_LAST_ITEM_RENDERER, this.setGroupedListLastItemRendererStyles);

			//header
			this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;

			//label
			this.getStyleProviderForClass(Label).defaultStyleFunction = this.setLabelStyles;
			this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_STYLE_NAME_HEADING, this.setHeadingLabelStyles);
			this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_STYLE_NAME_DETAIL, this.setDetailLabelStyles);

			//list
			this.getStyleProviderForClass(List).defaultStyleFunction = this.setListStyles;
			this.getStyleProviderForClass(DefaultListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_DROP_DOWN_LIST_ITEM_RENDERER, this.setPickerListItemRendererStyles);
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
			this.getStyleProviderForClass(PanelScreen).defaultStyleFunction = this.setPanelStyles;
			this.getStyleProviderForClass(Header).setFunctionForStyleName(PanelScreen.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setPanelScreenHeaderStyles);

			//picker list
			this.getStyleProviderForClass(List).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_LIST, this.setPickerListListStyles);
			this.getStyleProviderForClass(PickerList).defaultStyleFunction = this.setPickerListStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setPickerListButtonStyles);

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
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SLIDER_THUMB, this.setHorizontalButtonThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SLIDER_THUMB, this.setVerticalButtonThumbStyles);
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
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setHorizontalButtonThumbStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setHorizontalButtonThumbStyles);
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

		protected static function textureValueTypeHandler( value:Texture, oldDisplayObject:DisplayObject = null):DisplayObject
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

			list.maxHeight = 500 * this.scale;
			list.paddingLeft = 10 * this.scale;
			list.paddingRight = 14 * this.scale;
			list.paddingBottom = this.smallPaddingSize;
			list.backgroundSkin = new Scale9Image(this.pickerListListBackgroundTexture, this.scale);
			list.verticalScrollPolicy = List.SCROLL_POLICY_ON;
			list.customItemRendererStyleName = THEME_STYLE_NAME_DROP_DOWN_LIST_ITEM_RENDERER;
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
			button.paddingBottom = 30 * this.scale;
			button.paddingTop = 30 * this.scale;
			button.paddingRight = this.regularPaddingSize;
			button.paddingLeft = this.regularPaddingSize;
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
				skinSelector.setValueForState(this.toggleButtonSelectedDownTexture, Button.STATE_DOWN, true);
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
			button.paddingLeft = this.regularPaddingSize + this.smallPaddingSize;
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
			button.paddingRight = this.regularPaddingSize + this.smallPaddingSize;
		}

	//-------------------------
	// ButtonGroup
	//-------------------------

		protected function setButtonGroupStyles(group:ButtonGroup):void
		{
			group.minWidth = 720 * this.scale;
			group.gap = this.regularPaddingSize;
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

			check.gap = this.smallPaddingSize;
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

			radio.gap = this.smallPaddingSize;
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
			skinSelector.setValueForState(this.buttonDisabledTexture, Button.STATE_DISABLED);
			this.setBaseToggleSwitchSize( skinSelector);

			track.stateToSkinFunction = skinSelector.updateValue;
			track.hasLabelTextRenderer = false;
		}

		protected function setToggleSwitchOffTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonDownTexture;
			skinSelector.setValueForState(this.buttonDisabledTexture, Button.STATE_DISABLED);
			this.setBaseToggleSwitchSize(skinSelector);

			track.stateToSkinFunction = skinSelector.updateValue;
			track.hasLabelTextRenderer = false;
		}

		protected function setHorizontalButtonThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.horizontalThumbUpTexture;
			skinSelector.setValueForState(this.horizontalThumbDownTexture, Button.STATE_DOWN);
			skinSelector.setValueForState(this.horizontalThumbDisabledTexture, Button.STATE_DISABLED);
			skinSelector.displayObjectProperties =
			{
				width: 68 * this.scale,
				height: this.controlSize,
				textureScale: this.scale
			};
			thumb.stateToSkinFunction = skinSelector.updateValue;
			thumb.hasLabelTextRenderer = false;
		}

		protected function setVerticalButtonThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.verticalThumbUpTexture;
			skinSelector.setValueForState(this.verticalThumbDownTexture, Button.STATE_DOWN);
			skinSelector.setValueForState(this.verticalThumbDisabledTexture, Button.STATE_DISABLED);
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: 68 * this.scale,
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
				backgroundSkin.width = this.trackSize;
				backgroundSkin.height = this.trackSize;
				backgroundDisabledSkin = new Scale9Image(this.horizontalProgressBarBackgroundDisabledTexture, this.scale);
				backgroundDisabledSkin.width = this.trackSize;
				backgroundDisabledSkin.height = this.trackSize;
			}
			else //vertical
			{
				backgroundSkin = new Scale9Image(this.verticalProgressBarBackgroundTexture, this.scale);
				backgroundSkin.width = this.trackSize;
				backgroundSkin.height = this.trackSize;
				backgroundDisabledSkin = new Scale9Image(this.verticalProgressBarBackgroundDisabledTexture, this.scale);
				backgroundDisabledSkin.width = this.trackSize;
				backgroundDisabledSkin.height = this.trackSize;
			}
			progress.backgroundSkin = backgroundSkin;
			progress.backgroundDisabledSkin = backgroundDisabledSkin;

			var fillSkin:Scale9Image;
			var fillDisabledSkin:Scale9Image;
			/* Horizontal fill skin */
			if(progress.direction === ProgressBar.DIRECTION_HORIZONTAL)
			{
				fillSkin = new Scale9Image(this.horizontalProgressBarFillTexture, this.scale);
				fillSkin.width = this.trackSize;
				fillSkin.height = this.trackSize;
				fillDisabledSkin = new Scale9Image(this.horizontalProgressBarFillDisabledTexture, this.scale);
				fillDisabledSkin.width = this.trackSize;
				fillDisabledSkin.height = this.trackSize;
			}
			else //vertical
			{
				fillSkin = new Scale9Image(this.verticalProgressBarFillTexture, this.scale);
				fillSkin.width = this.trackSize;
				fillSkin.height = this.trackSize;
				fillDisabledSkin = new Scale9Image(verticalProgressBarFillDisabledTexture, this.scale);
				fillDisabledSkin.width = this.trackSize;
				fillDisabledSkin.height = this.trackSize;
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
	// List
	//-------------------------

		protected function setListStyles(list:List):void
		{
			this.setScrollerStyles(list);
			list.backgroundSkin = new Quad(10, 10, COLOR_BACKGROUND_LIGHT);
		}

		protected function setBaseItemRendererStyles(renderer:BaseDefaultItemRenderer):void
		{
			renderer.downLabelProperties.elementFormat = this.darkUILargeElementFormat;
			renderer.defaultLabelProperties.elementFormat = this.darkUILargeElementFormat;
			renderer.disabledLabelProperties.elementFormat = this.darkUILargeDisabledElementFormat;
			renderer.defaultSelectedLabelProperties.elementFormat = this.darkUILargeElementFormat;

			renderer.horizontalAlign = BaseDefaultItemRenderer.HORIZONTAL_ALIGN_LEFT;
			renderer.paddingTop = this.regularPaddingSize;
			renderer.paddingBottom = this.regularPaddingSize;
			renderer.paddingLeft = this.regularPaddingSize;
			renderer.paddingRight = this.regularPaddingSize;
			renderer.gap = this.regularPaddingSize;
			renderer.minGap = this.regularPaddingSize;
			renderer.iconPosition = BaseDefaultItemRenderer.ICON_POSITION_LEFT;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.minAccessoryGap = this.regularPaddingSize;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
			renderer.minWidth = this.controlSize;
			renderer.minHeight = this.controlSize;
			renderer.minTouchWidth = this.controlSize;
			renderer.minTouchHeight = this.controlSize;

			renderer.accessoryLoaderFactory = imageLoaderFactory;
			renderer.iconLoaderFactory = imageLoaderFactory;
		}

		protected function setBaseDropDownListItemRendererStyles(renderer:BaseDefaultItemRenderer):SmartDisplayObjectStateValueSelector
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.pickerListItemRendererUpTexture;
			skinSelector.defaultSelectedValue = this.pickerListItemRendererSelectedTexture;
			skinSelector.setValueForState(this.pickerListItemRendererDownTexture, Button.STATE_DOWN);
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			renderer.stateToSkinFunction = skinSelector.updateValue;

			renderer.defaultLabelProperties.elementFormat = this.darkUIElementFormat;
			renderer.downLabelProperties.elementFormat = this.darkUIElementFormat;
			renderer.disabledLabelProperties.elementFormat = this.darkUIElementFormat;

			renderer.gap = this.regularPaddingSize;
			renderer.minWidth = this.controlSize * 2;
			renderer.itemHasIcon = false;
			renderer.iconPosition = BaseDefaultItemRenderer.ICON_POSITION_LEFT;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.minAccessoryGap = this.regularPaddingSize;
			renderer.horizontalAlign = BaseDefaultItemRenderer.HORIZONTAL_ALIGN_CENTER;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
			return skinSelector;
		}

		protected function setItemRendererStyles(renderer:BaseDefaultItemRenderer):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.itemRendererUpTexture;
			skinSelector.defaultSelectedValue = this.itemRendererSelectedTexture;
			skinSelector.setValueForState(this.itemRendererDownTexture, Button.STATE_DOWN);
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

	//-------------------------
	// GroupedList
	//-------------------------

		protected function setGroupedListStyles(list:GroupedList):void
		{
			this.setScrollerStyles(list);
			list.backgroundSkin = new Quad(10, 10, COLOR_BACKGROUND_LIGHT);
			list.customLastItemRendererStyleName = THEME_STYLE_NAME_GROUPED_LIST_LAST_ITEM_RENDERER;
		}

		//see List section for item renderer styles

		protected function setGroupedListLastItemRendererStyles(renderer:BaseDefaultItemRenderer):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.lastItemRendererUpTexture;
			skinSelector.defaultSelectedValue = this.lastItemRendererSelectedTexture;
			skinSelector.setValueForState(this.lastItemRendererDownTexture, Button.STATE_DOWN);
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			renderer.stateToSkinFunction = skinSelector.updateValue;

			this.setBaseItemRendererStyles(renderer);
			renderer.paddingTop = 42 * this.scale;
		}

		protected function setGroupedListHeaderRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			renderer.backgroundSkin = new Scale9Image(this.groupedListHeaderTexture, this.scale);

			renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_LEFT;
			renderer.contentLabelProperties.elementFormat = this.darkUIElementFormat;
			renderer.contentLabelProperties.disabledElementFormat = this.darkUIDisabledElementFormat;
			renderer.paddingTop = this.smallPaddingSize;
			renderer.paddingRight = this.regularPaddingSize;
			renderer.paddingBottom = this.smallPaddingSize;
			renderer.paddingLeft = this.regularPaddingSize;

			renderer.contentLoaderFactory = this.imageLoaderFactory;
		}

		protected function setGroupedListFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			renderer.backgroundSkin = new Scale9Image(this.groupedListFooterTexture, this.scale);

			renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_CENTER;
			renderer.contentLabelProperties.elementFormat = this.lightUIElementFormat;
			renderer.contentLabelProperties.disabledElementFormat = this.lightUIDisabledElementFormat;
			renderer.paddingTop = this.smallPaddingSize;
			renderer.paddingRight = this.regularPaddingSize; 
			renderer.paddingBottom = this.smallPaddingSize;
			renderer.paddingLeft = this.regularPaddingSize;

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
			input.padding = this.smallPaddingSize;
			input.isEditable = false;
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
				list.popUpContentManager = new DropDownPopUpContentManager();
			}
			else
			{
				var manager:VerticalCenteredPopUpContentManager = new VerticalCenteredPopUpContentManager();
				manager.margin = this.regularPaddingSize;
				list.popUpContentManager = manager;
			}
		}

		protected function setPickerListButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.pickerListButtonUpTexture;
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
			button.minGap = this.regularPaddingSize;
			button.iconPosition = Button.ICON_POSITION_RIGHT;
			button.paddingLeft = this.regularPaddingSize;
		}

		protected function setPickerListListStyles(list:List):void
		{
			this.setScrollerStyles(list);

			list.verticalScrollPolicy = List.SCROLL_POLICY_ON;

			if( DeviceCapabilities.isTablet( Starling.current.nativeStage ) )
			{
				list.maxHeight = 500 * this.scale;
				list.paddingLeft = 10 * this.scale;
				list.paddingRight = 14 * this.scale;
				list.paddingBottom = this.smallPaddingSize;
				list.backgroundSkin = new Scale9Image(this.pickerListListBackgroundTexture, this.scale);
			}
			else
			{
				list.paddingTop = 6 * this.scale;
				list.paddingRight = 10 * this.scale;
				list.paddingBottom = 14 * this.scale;
				list.paddingLeft = 6 * this.scale;
				list.backgroundSkin = new Scale9Image(this.popUpBackgroundTexture, this.scale);
			}

			list.customItemRendererStyleName = THEME_STYLE_NAME_DROP_DOWN_LIST_ITEM_RENDERER;
		}

		protected function setPickerListItemRendererStyles(renderer:BaseDefaultItemRenderer):void
		{
			this.setBaseDropDownListItemRendererStyles(renderer);
		}

	//-------------------------
	// SpinnerList
	//-------------------------

		protected function setSpinnerListStyles(list:SpinnerList):void
		{
			list.verticalScrollPolicy = List.SCROLL_POLICY_ON;
			list.paddingTop = 6 * this.scale;
			list.paddingRight = 10 * this.scale;
			list.paddingBottom = 14 * this.scale;
			list.paddingLeft = 6 * this.scale;
			list.backgroundSkin = new Scale9Image(this.popUpBackgroundTexture, this.scale);
			list.selectionOverlaySkin = new Scale9Image(this.spinnerListSelectionOverlayTexture, this.scale);
			list.customItemRendererStyleName = THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER;
		}

		protected function setSpinnerListItemRendererStyles(renderer:BaseDefaultItemRenderer):void
		{
			/* Style is the same as for the PickerList items, except that the
			 * SpinnerList's item does not have a skin for the selected state */
			setBaseDropDownListItemRendererStyles(renderer).defaultSelectedValue = null;
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
				layout.padding = this.regularPaddingSize;
				layout.gap = this.regularPaddingSize;
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
			text.padding = this.regularPaddingSize;
			text.paddingRight = this.regularPaddingSize + this.smallPaddingSize;
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
			var padding:int = this.smallPaddingSize * 0.5;
			scrollBar.paddingTop = padding;
			scrollBar.paddingRight = padding;
			scrollBar.paddingBottom = padding;
		}

		protected function setHorizontalSimpleScrollBarThumbStyles(thumb:Button):void
		{
			var defaultSkin:Scale3Image = new Scale3Image(this.horizontalSimpleScrollBarThumbTexture, this.scale);
			defaultSkin.width = 52 * this.scale;
			thumb.defaultSkin = defaultSkin;
			thumb.hasLabelTextRenderer = false;
		}

		protected function setVerticalSimpleScrollBarThumbStyles(thumb:Button):void
		{
			var defaultSkin:Scale3Image = new Scale3Image(this.verticalSimpleScrollBarThumbTexture, this.scale);
			defaultSkin.height = 52 * this.scale;
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
			pageIndicator.gap = this.regularPaddingSize;
			pageIndicator.padding = this.regularPaddingSize;
			pageIndicator.minTouchWidth = this.regularPaddingSize * 2;
			pageIndicator.minTouchHeight = this.regularPaddingSize * 2;
		}

	//-------------------------
	// Panel
	//-------------------------

		protected function setPanelStyles(panel:Panel):void
		{
			this.setScrollerStyles(panel);

			panel.backgroundSkin = new Quad(1, 1, COLOR_BACKGROUND_LIGHT);

			panel.paddingTop = this.smallPaddingSize;
			panel.paddingRight = this.smallPaddingSize;
			panel.paddingBottom = this.smallPaddingSize;
			panel.paddingLeft = this.smallPaddingSize;
		}

		protected function setHeaderWithoutBackgroundStyles(header:Header):void
		{
			header.gap = this.regularPaddingSize;
			header.padding = this.regularPaddingSize;
			header.titleGap = this.regularPaddingSize;
			header.minHeight = this.headerSize;
			header.titleProperties.elementFormat = this.darkUILargeElementFormat;
		}

	//-------------------------
	// PanelScreen
	//-------------------------

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
			backgroundSkin.width = 80 * this.scale;
			backgroundSkin.height = this.headerSize;
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

			tab.paddingLeft = this.regularPaddingSize;
			tab.paddingRight = this.regularPaddingSize;
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
			skinSelector.setValueForState(this.horizontalSliderDisabledTrackTexture, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			skinSelector.displayObjectProperties.width = this.trackSize;
			skinSelector.displayObjectProperties.height = this.trackSize;
			track.stateToSkinFunction = skinSelector.updateValue;
			track.hasLabelTextRenderer = false;
		}

		protected function setHorizontalSliderMaximumTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.horizontalSliderMaximumTrackTexture;
			skinSelector.setValueForState(this.horizontalSliderDisabledTrackTexture, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			skinSelector.displayObjectProperties.width = this.trackSize;
			skinSelector.displayObjectProperties.height = this.trackSize;
			track.stateToSkinFunction = skinSelector.updateValue;
			track.hasLabelTextRenderer = false;
		}

		protected function setVerticalSliderMinimumTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.verticalSliderMinimumTrackTexture;
			skinSelector.setValueForState(this.verticalSliderDisabledTrackTexture, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			skinSelector.displayObjectProperties.width = this.trackSize;
			skinSelector.displayObjectProperties.height = this.trackSize;
			track.stateToSkinFunction = skinSelector.updateValue;
			track.hasLabelTextRenderer = false;
		}

		protected function setVerticalSliderMaximumTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.verticalSliderMaximumTrackTexture;
			skinSelector.setValueForState(this.verticalSliderDisabledTrackTexture, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: scale
			};
			skinSelector.displayObjectProperties.width = this.trackSize;
			skinSelector.displayObjectProperties.height = this.trackSize;
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
				width: this.controlSize * 2,
				height: this.controlSize * 2,
				textureScale: this.scale
			};
			textArea.stateToSkinFunction = skinSelector.updateValue;

			textArea.padding = this.regularPaddingSize;

			textArea.textEditorProperties.textFormat = this.scrollTextTextFormat;
			textArea.textEditorProperties.disabledTextFormat = this.scrollTextDisabledTextFormat;
		}

	//-------------------------
	// TextInput
	//-------------------------

		protected function setBaseTextInputStyles(input:TextInput):void
		{
			input.textEditorProperties.fontFamily = "Helvetica";
			input.textEditorProperties.fontSize = this.regularFontSize;
			input.textEditorProperties.color = COLOR_TEXT_DARK;
			input.textEditorProperties.disabledColor = COLOR_TEXT_DARK_DISABLED;

			input.promptProperties.elementFormat = this.darkUIElementFormat;
			input.promptProperties.disabledElementFormat = this.darkUIDisabledElementFormat;

			input.minHeight = this.controlSize;
			input.paddingTop = this.smallPaddingSize * 0.5;
		}

		protected function setTextInputStyles(input:TextInput):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.textInputBackgroundEnabledTexture;
			skinSelector.setValueForState(this.textInputBackgroundFocusedTexture, TextInput.STATE_FOCUSED);
			skinSelector.setValueForState(this.textInputBackgroundDisabledTexture, TextInput.STATE_DISABLED);
			skinSelector.displayObjectProperties =
			{
				width: 30 * this.scale,
				height: this.controlSize,
				textureScale: this.scale
			};
			input.stateToSkinFunction = skinSelector.updateValue;

			input.minWidth = 30 * this.scale;
			input.paddingLeft = this.smallPaddingSize;
			input.paddingRight = this.smallPaddingSize;

			setBaseTextInputStyles(input);
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

			input.gap = this.smallPaddingSize;
			input.minWidth = this.wideControlSize;
			input.paddingLeft = this.regularPaddingSize;
			input.paddingRight = this.smallPaddingSize * 2.5;

			/* Icon */
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
			var backgroundSkin:Scale9Image = new Scale9Image(this.popUpBackgroundTexture, scale);
			backgroundSkin.width = this.regularPaddingSize;
			backgroundSkin.height = this.regularPaddingSize;
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

			callout.padding = this.regularPaddingSize;
		}

	//-------------------------
	// Alert
	//-------------------------

		protected function setAlertStyles(alert:Alert):void
		{
			this.setScrollerStyles(alert);

			alert.backgroundSkin = new Scale9Image(this.popUpBackgroundTexture, this.scale);

			alert.paddingTop = 0;
			alert.paddingRight = this.regularPaddingSize;
			alert.paddingBottom = this.regularPaddingSize;
			alert.paddingLeft = this.regularPaddingSize;
			alert.gap = this.regularPaddingSize;
			alert.maxWidth = 720 * this.scale;
			alert.maxHeight = 720 * this.scale;
		}

		//see Panel section for Header styles

		protected function setAlertButtonGroupStyles(group:ButtonGroup):void
		{
			group.direction = ButtonGroup.DIRECTION_HORIZONTAL;
			group.horizontalAlign = ButtonGroup.HORIZONTAL_ALIGN_CENTER;
			group.verticalAlign = ButtonGroup.VERTICAL_ALIGN_JUSTIFY;
			group.distributeButtonSizes = false;
			group.gap = this.regularPaddingSize;
			group.padding = this.regularPaddingSize;
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

		protected function setBaseToggleSwitchSize( skinSelector:SmartDisplayObjectStateValueSelector):void
		{
			skinSelector.displayObjectProperties =
			{
				width: 140 * this.scale,
				height: this.controlSize,
				textureScale: this.scale
			};
		}

	}

}
