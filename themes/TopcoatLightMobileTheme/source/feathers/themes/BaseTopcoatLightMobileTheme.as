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
			this.mScaleToDPI = scaleToDPI;
		}

		/* Dimensions */
		protected var mSmallPaddingSize:int;
		protected var mRegularPaddingSize:int;
		protected var mTrackSize:int;
		protected var mControlSize:int;
		protected var mWideControlSize:int;
		protected var mHeaderSize:int;

		/* Fonts */
		protected var mSmallFontSize:int;
		protected var mRegularFontSize:int;
		protected var mLargeFontSize:int;

		protected var mRegularFontDescription:FontDescription;

		protected var mScrollTextTextFormat:TextFormat;
		protected var mScrollTextDisabledTextFormat:TextFormat;

		protected var mLightUIElementFormat:ElementFormat;
		protected var mLightUIDisabledElementFormat:ElementFormat;
		protected var mDarkUIElementFormat:ElementFormat;
		protected var mDarkUIDisabledElementFormat:ElementFormat;
		protected var mDarkUISmallElementFormat:ElementFormat;
		protected var mDarkUISmallDisabledElementFormat:ElementFormat;
		protected var mDarkUILargeElementFormat:ElementFormat;
		protected var mDarkUILargeDisabledElementFormat:ElementFormat;
		protected var mBlueUIElementFormat:ElementFormat;
		protected var mBlueUIDisabledElementFormat:ElementFormat;
		protected var mDangerButtonDisabledElementFormat:ElementFormat;

		/**
		 * The texture atlas that contains skins for this theme. This base class
		 * does not initialize this member variable. Subclasses are expected to
		 * load the assets somehow and set the <code>atlas</code> member
		 * variable before calling <code>initialize()</code>.
		 */
		protected var mAtlas:TextureAtlas;

		/* Textures */
		protected var mButtonUpTexture:Scale9Textures;
		protected var mButtonDownTexture:Scale9Textures;
		protected var mButtonDisabledTexture:Scale9Textures;
		protected var mButtonQuietDownTexture:Scale9Textures;
		protected var mButtonBackUpTexture:Scale9Textures;
		protected var mButtonBackDownTexture:Scale9Textures;
		protected var mButtonBackDisabledTexture:Scale9Textures;
		protected var mButtonForwardUpTexture:Scale9Textures;
		protected var mButtonForwardDownTexture:Scale9Textures;
		protected var mButtonForwardDisabledTexture:Scale9Textures;
		protected var mButtonDangerUpTexture:Scale9Textures;
		protected var mButtonDangerDownTexture:Scale9Textures;
		protected var mButtonDangerDisabledTexture:Scale9Textures;
		protected var mButtonCallToActionUpTexture:Scale9Textures;
		protected var mButtonCallToActionDownTexture:Scale9Textures;
		protected var mButtonCallToActionDisabledTexture:Scale9Textures;
		protected var mButtonSelectedUpTexture:Scale9Textures;
		protected var mButtonSelectedDownTexture:Scale9Textures;
		protected var mButtonSelectedDisabledTexture:Scale9Textures;
		protected var mToggleSwitchOnTexture:Scale9Textures;
		protected var mButtonThumbHorizontalUpTexture:Scale9Textures;
		protected var mButtonThumbHorizontalDownTexture:Scale9Textures;
		protected var mButtonThumbHorizontalDisabledTexture:Scale9Textures;
		protected var mButtonThumbVerticalUpTexture:Scale9Textures;
		protected var mButtonThumbVerticalDownTexture:Scale9Textures;
		protected var mButtonThumbVerticalDisabledTexture:Scale9Textures;
		protected var mCheckUpIconTexture:Texture;
		protected var mCheckSelectedUpIconTexture:Texture;
		protected var mCheckDownIconTexture:Texture;
		protected var mCheckDisabledIconTexture:Texture;
		protected var mCheckSelectedDownIconTexture:Texture;
		protected var mCheckSelectedDisabledIconTexture:Texture;
		protected var mRadioUpIconTexture:Texture;
		protected var mRadioSelectedUpIconTexture:Texture;
		protected var mRadioDownIconTexture:Texture;
		protected var mRadioDisabledIconTexture:Texture;
		protected var mRadioSelectedDownIconTexture:Texture;
		protected var mRadioSelectedDisabledIconTexture:Texture;
		protected var mProgressBarHorizontalFillTexture:Scale9Textures;
		protected var mProgressBarHorizontalFillDisabledTexture:Scale9Textures;
		protected var mProgressBarHorizontalBackgroundTexture:Scale9Textures;
		protected var mProgressBarHorizontalBackgroundDisabledTexture:Scale9Textures;
		protected var mProgressBarVerticalFillTexture:Scale9Textures;
		protected var mProgressBarVerticalFillDisabledTexture:Scale9Textures;
		protected var mProgressBarVerticalBackgroundTexture:Scale9Textures;
		protected var mProgressBarVerticalBackgroundDisabledTexture:Scale9Textures;
		protected var mHeaderBackgroundTexture:Scale9Textures;
		protected var mVerticalScrollBarTexture:Scale3Textures;
		protected var mHorizontalScrollBarTexture:Scale3Textures;
		protected var mTabUpTexture:Scale9Textures;
		protected var mTabDownTexture:Scale9Textures;
		protected var mTabSelectedTexture:Scale9Textures;
		protected var mTabSelectedDownTexture:Scale9Textures;
		protected var mTabSelectedDisabledTexture:Scale9Textures;
		protected var mSliderHorizontalMinimalTrackTexture:Scale9Textures;
		protected var mSliderHorizontalMaximumTrackTexture:Scale9Textures;
		protected var mSliderHorizontalDisabledTrackTexture:Scale9Textures;
		protected var mSliderVerticalMinimumTrackTexture:Scale9Textures;
		protected var mSliderVerticalMaximumTrackTexture:Scale9Textures;
		protected var mSliderVerticalDisabledTrackTexture:Scale9Textures;
		protected var mTextInputUpTexture:Scale9Textures;
		protected var mTextInputFocusedTexture:Scale9Textures;
		protected var mTextInputDisabledTexture:Scale9Textures;
		protected var mSearchInputUpTexture:Scale9Textures;
		protected var mSearchInputFocusedTexture:Scale9Textures;
		protected var mSearchInputDisabledTexture:Scale9Textures;
		protected var mSearchIconTexture:Texture;
		protected var mBackgroundPopUpTexture:Scale9Textures;
		protected var mCalloutTopArrowTexture:Texture;
		protected var mCalloutRightArrowTexture:Texture;
		protected var mCalloutBottomArrowTexture:Texture;
		protected var mCalloutLeftArrowTexture:Texture;
		protected var mItemRendererUpTexture:Scale9Textures;
		protected var mItemRendererDownTexture:Scale9Textures;
		protected var mItemRendererSelectedTexture:Scale9Textures;
		protected var mLastItemRendererUpTexture:Scale9Textures;
		protected var mLastItemRendererDownTexture:Scale9Textures;
		protected var mLastItemRendererSelectedTexture:Scale9Textures;
		protected var mGroupedListHeaderTexture:Scale9Textures;
		protected var mGroupedListFooterTexture:Scale9Textures;
		protected var mPickerListItemRendererUpTexture:Scale9Textures;
		protected var mPickerListItemRendererDownTexture:Scale9Textures;
		protected var mPickerListItemRendererSelectedTexture:Scale9Textures;
		protected var mPickerListButtonIcon:Texture;
		protected var mPickerListButtonDisabledIcon:Texture;
		protected var mButtonPickerListUpTexture:Scale9Textures;
		protected var mPickerListListBackgroundTexture:Scale9Textures;
		protected var mSpinnerListSelectionOverlayTexture:Scale9Textures;
		protected var mPageIndicatorNormalTexture:Texture;
		protected var mPageIndicatorSelectedTexture:Texture;

		protected var mScale:Number;
		protected var mOriginalDPI:int;

		/**
		 * The original screen density used for scaling.
		 */
		public function get originalDPI():int
		{
			return this.mOriginalDPI;
		}
		
		protected var mScaleToDPI:Boolean;

		/**
		 * Indicates if the theme scales skins to match the screen density of the device.
		 */
		public function get scaleToDPI():Boolean
		{
			return this.mScaleToDPI;
		}

		/**
		 * Disposes the atlas before calling super.dispose()
		 */
		override public function dispose():void
		{
			if(this.mAtlas)
			{
				this.mAtlas.dispose();
				this.mAtlas = null;
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
			this.mOriginalDPI = scaledDPI;
			if(this.mScaleToDPI)
			{
				if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
				{
					this.mOriginalDPI = ORIGINAL_DPI_IPAD_RETINA;
				}
				else
				{
					this.mOriginalDPI = ORIGINAL_DPI_IPHONE_RETINA;
				}
			}
			this.mScale = scaledDPI / this.mOriginalDPI;
		}

		protected function initializeDimensions():void
		{
			this.mSmallPaddingSize = Math.round(20 * this.mScale);
			this.mRegularPaddingSize = Math.round(40 * this.mScale);
			this.mTrackSize = Math.round(32 * this.mScale);
			this.mControlSize = Math.round(100 * this.mScale);
			this.mWideControlSize = Math.round(120 * this.mScale);
			this.mHeaderSize = Math.round(122 * this.mScale);
		}

		protected function initializeTextures():void
		{
			this.mBackgroundPopUpTexture = new Scale9Textures(this.mAtlas.getTexture("background-popup-skin"), BACKGROUND_POPUP_SCALE9_GRID);

			this.mButtonUpTexture = new Scale9Textures(this.mAtlas.getTexture("button-up-skin"), BUTTON_SCALE9_GRID);
			this.mButtonDownTexture = new Scale9Textures(this.mAtlas.getTexture("button-down-skin"), BUTTON_SCALE9_GRID);
			this.mButtonDisabledTexture = new Scale9Textures(this.mAtlas.getTexture("button-disabled-skin"), BUTTON_SCALE9_GRID);
			this.mButtonQuietDownTexture = new Scale9Textures(this.mAtlas.getTexture("button-down-skin"), BUTTON_SCALE9_GRID);
			this.mButtonDangerUpTexture = new Scale9Textures(this.mAtlas.getTexture("button-danger-up-skin"), BUTTON_SCALE9_GRID);
			this.mButtonDangerDownTexture = new Scale9Textures(this.mAtlas.getTexture("button-danger-down-skin"), BUTTON_SCALE9_GRID);
			this.mButtonDangerDisabledTexture = new Scale9Textures(this.mAtlas.getTexture("button-danger-disabled-skin"), BUTTON_SCALE9_GRID);
			this.mButtonCallToActionUpTexture = new Scale9Textures(this.mAtlas.getTexture("button-call-to-action-up-skin"), BUTTON_SCALE9_GRID);
			this.mButtonCallToActionDownTexture = new Scale9Textures(this.mAtlas.getTexture("button-call-to-action-down-skin"), BUTTON_SCALE9_GRID);
			this.mButtonCallToActionDisabledTexture = new Scale9Textures(this.mAtlas.getTexture("button-call-to-action-disabled-skin"), BUTTON_SCALE9_GRID);
			this.mButtonBackUpTexture = new Scale9Textures(this.mAtlas.getTexture("button-back-up-skin"), BUTTON_BACK_SCALE9_GRID);
			this.mButtonBackDownTexture = new Scale9Textures(this.mAtlas.getTexture("button-back-down-skin"), BUTTON_BACK_SCALE9_GRID);
			this.mButtonBackDisabledTexture = new Scale9Textures(this.mAtlas.getTexture("button-back-disabled-skin"), BUTTON_BACK_SCALE9_GRID);
			this.mButtonForwardUpTexture = new Scale9Textures(this.mAtlas.getTexture("button-forward-up-skin"), BUTTON_FORWARD_SCALE9_GRID);
			this.mButtonForwardDownTexture = new Scale9Textures(this.mAtlas.getTexture("button-forward-down-skin"), BUTTON_FORWARD_SCALE9_GRID);
			this.mButtonForwardDisabledTexture = new Scale9Textures(this.mAtlas.getTexture("button-forward-disabled-skin"), BUTTON_FORWARD_SCALE9_GRID);
			this.mButtonSelectedUpTexture = new Scale9Textures(this.mAtlas.getTexture("button-selected-up-skin"), TOGGLE_BUTTON_SCALE9_GRID);
			this.mButtonSelectedDownTexture = new Scale9Textures(this.mAtlas.getTexture("button-selected-down-skin"), TOGGLE_BUTTON_SCALE9_GRID);
			this.mButtonSelectedDisabledTexture = new Scale9Textures(this.mAtlas.getTexture("button-selected-disabled-skin"), TOGGLE_BUTTON_SCALE9_GRID);
			this.mButtonThumbHorizontalUpTexture = new Scale9Textures(this.mAtlas.getTexture("button-thumb-horizontal-up-skin"), BUTTON_THUMB_HORIZONTAL_SCALE9_GRID);
			this.mButtonThumbHorizontalDownTexture = new Scale9Textures(this.mAtlas.getTexture("button-thumb-horizontal-down-skin"), BUTTON_THUMB_HORIZONTAL_SCALE9_GRID);
			this.mButtonThumbHorizontalDisabledTexture = new Scale9Textures(this.mAtlas.getTexture("button-thumb-horizontal-disabled-skin"), BUTTON_THUMB_HORIZONTAL_SCALE9_GRID);
			this.mButtonThumbVerticalUpTexture = new Scale9Textures(this.mAtlas.getTexture("button-thumb-vertical-up-skin"), BUTTON_THUMB_VERTICAL_SCALE9_GRID);
			this.mButtonThumbVerticalDownTexture = new Scale9Textures(this.mAtlas.getTexture("button-thumb-vertical-down-skin"), BUTTON_THUMB_VERTICAL_SCALE9_GRID);
			this.mButtonThumbVerticalDisabledTexture = new Scale9Textures(this.mAtlas.getTexture("button-thumb-vertical-disabled-skin"), BUTTON_THUMB_VERTICAL_SCALE9_GRID);

			/* Callout */
			this.mCalloutTopArrowTexture = this.mAtlas.getTexture("callout-arrow-top-skin");
			this.mCalloutRightArrowTexture = this.mAtlas.getTexture("callout-arrow-right-skin");
			this.mCalloutBottomArrowTexture = this.mAtlas.getTexture("callout-arrow-bottom-skin");
			this.mCalloutLeftArrowTexture = this.mAtlas.getTexture("callout-arrow-left-skin");

			/* Check */
			this.mCheckUpIconTexture = this.mAtlas.getTexture("check-up-icon");
			this.mCheckDownIconTexture = this.mAtlas.getTexture("check-down-icon");
			this.mCheckDisabledIconTexture = this.mAtlas.getTexture("check-disabled-icon");
			this.mCheckSelectedUpIconTexture = this.mAtlas.getTexture("check-selected-up-icon");
			this.mCheckSelectedDownIconTexture = this.mAtlas.getTexture("check-selected-down-icon");
			this.mCheckSelectedDisabledIconTexture = this.mAtlas.getTexture("check-selected-disabled-icon");

			/* Header */
			this.mHeaderBackgroundTexture = new Scale9Textures(this.mAtlas.getTexture("header-background-skin"), HEADER_BACKGROUND_SCALE9_GRID);

			/* List / GroupedList / Item renderers */
			this.mItemRendererUpTexture = new Scale9Textures(this.mAtlas.getTexture("list-item-up-skin"), LIST_ITEM_SCALE9_GRID);
			this.mItemRendererDownTexture = new Scale9Textures(this.mAtlas.getTexture("list-item-down-skin"), LIST_ITEM_SCALE9_GRID);
			this.mItemRendererSelectedTexture = new Scale9Textures(this.mAtlas.getTexture("list-item-selected-skin"), LIST_ITEM_SCALE9_GRID);
			this.mLastItemRendererUpTexture = new Scale9Textures(this.mAtlas.getTexture("list-last-item-up-skin"), LIST_ITEM_SCALE9_GRID);
			this.mLastItemRendererDownTexture = new Scale9Textures(this.mAtlas.getTexture("list-last-item-down-skin"), LIST_ITEM_SCALE9_GRID);
			this.mLastItemRendererSelectedTexture = new Scale9Textures(this.mAtlas.getTexture("list-last-item-selected-skin"), LIST_ITEM_SCALE9_GRID);
			this.mGroupedListHeaderTexture = new Scale9Textures(this.mAtlas.getTexture("grouped-list-header-skin"), GROUPED_LIST_HEADER_OR_FOOTER_SCALE9_GRID);
			this.mGroupedListFooterTexture = new Scale9Textures(this.mAtlas.getTexture("grouped-list-footer-skin"), GROUPED_LIST_HEADER_OR_FOOTER_SCALE9_GRID);

			/* Page indicator */
			this.mPageIndicatorNormalTexture = this.mAtlas.getTexture("page-indicator-normal-skin");
			this.mPageIndicatorSelectedTexture = this.mAtlas.getTexture("page-indicator-selected-skin");

			/* Picker list */
			this.mButtonPickerListUpTexture = new Scale9Textures(this.mAtlas.getTexture("button-picker-list-up-skin"), BUTTON_SCALE9_GRID);
			this.mPickerListListBackgroundTexture = new Scale9Textures(this.mAtlas.getTexture("picker-list-list-background-skin"), PICKER_LIST_LIST_BACKGROUND_SCALE9_GRID);
			this.mPickerListButtonIcon = this.mAtlas.getTexture("picker-list-button-icon");
			this.mPickerListButtonDisabledIcon = this.mAtlas.getTexture("picker-list-button-disabled-icon");
			this.mPickerListItemRendererUpTexture = new Scale9Textures(this.mAtlas.getTexture("picker-list-list-item-up-skin"), LIST_ITEM_SCALE9_GRID);
			this.mPickerListItemRendererDownTexture = new Scale9Textures(this.mAtlas.getTexture("picker-list-list-item-down-skin"), LIST_ITEM_SCALE9_GRID);
			this.mPickerListItemRendererSelectedTexture = new Scale9Textures(this.mAtlas.getTexture("picker-list-list-item-selected-skin"), LIST_ITEM_SCALE9_GRID);

			/* ProgressBar */
			this.mProgressBarHorizontalFillTexture = new Scale9Textures(this.mAtlas.getTexture("progress-bar-horizontal-fill-skin"), BAR_HORIZONTAL_SCALE9_GRID);
			this.mProgressBarHorizontalFillDisabledTexture = new Scale9Textures(this.mAtlas.getTexture("progress-bar-horizontal-fill-disabled-skin"), BAR_HORIZONTAL_SCALE9_GRID);
			this.mProgressBarHorizontalBackgroundTexture = new Scale9Textures(this.mAtlas.getTexture("progress-bar-horizontal-background-skin"), BAR_HORIZONTAL_SCALE9_GRID);
			this.mProgressBarHorizontalBackgroundDisabledTexture = new Scale9Textures(this.mAtlas.getTexture("progress-bar-horizontal-background-disabled-skin"), BAR_HORIZONTAL_SCALE9_GRID);
			this.mProgressBarVerticalFillTexture = new Scale9Textures(this.mAtlas.getTexture("progress-bar-vertical-fill-skin"), BAR_VERTICAL_SCALE9_GRID);
			this.mProgressBarVerticalFillDisabledTexture = new Scale9Textures(this.mAtlas.getTexture("progress-bar-vertical-fill-disabled-skin"), BAR_VERTICAL_SCALE9_GRID);
			this.mProgressBarVerticalBackgroundTexture = new Scale9Textures(this.mAtlas.getTexture("progress-bar-vertical-background-skin"), BAR_VERTICAL_SCALE9_GRID);
			this.mProgressBarVerticalBackgroundDisabledTexture = new Scale9Textures(this.mAtlas.getTexture("progress-bar-vertical-background-disabled-skin"), BAR_VERTICAL_SCALE9_GRID);

			/* Radio */
			this.mRadioUpIconTexture = this.mAtlas.getTexture("radio-up-icon");
			this.mRadioDownIconTexture = this.mAtlas.getTexture("radio-down-icon");
			this.mRadioDisabledIconTexture = this.mAtlas.getTexture("radio-disabled-icon");
			this.mRadioSelectedUpIconTexture = this.mAtlas.getTexture("radio-selected-up-icon");
			this.mRadioSelectedDownIconTexture = this.mAtlas.getTexture("radio-selected-down-icon");
			this.mRadioSelectedDisabledIconTexture = this.mAtlas.getTexture("radio-selected-disabled-icon");

			/* Scroll bar */
			this.mVerticalScrollBarTexture = new Scale3Textures(this.mAtlas.getTexture("simple-scroll-bar-vertical-thumb-skin"), SCROLL_BAR_REGION1, SCROLL_BAR_REGION2, Scale3Textures.DIRECTION_VERTICAL);
			this.mHorizontalScrollBarTexture = new Scale3Textures(this.mAtlas.getTexture("simple-scroll-bar-horizontal-thumb-skin"), SCROLL_BAR_REGION1, SCROLL_BAR_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);

			/* Slider */
			this.mSliderHorizontalMinimalTrackTexture = new Scale9Textures(this.mAtlas.getTexture("slider-horizontal-minimum-track-skin"), BAR_HORIZONTAL_SCALE9_GRID);
			this.mSliderHorizontalMaximumTrackTexture = new Scale9Textures(this.mAtlas.getTexture("slider-horizontal-maximum-track-skin"), BAR_HORIZONTAL_SCALE9_GRID);
			this.mSliderHorizontalDisabledTrackTexture = new Scale9Textures(this.mAtlas.getTexture("slider-horizontal-disabled-track-skin"), BAR_HORIZONTAL_SCALE9_GRID);
			this.mSliderVerticalMinimumTrackTexture = new Scale9Textures(this.mAtlas.getTexture("slider-vertical-minimum-track-skin"), BAR_VERTICAL_SCALE9_GRID);
			this.mSliderVerticalMaximumTrackTexture = new Scale9Textures(this.mAtlas.getTexture("slider-vertical-maximum-track-skin"), BAR_VERTICAL_SCALE9_GRID);
			this.mSliderVerticalDisabledTrackTexture = new Scale9Textures(this.mAtlas.getTexture("slider-vertical-disabled-track-skin"), BAR_VERTICAL_SCALE9_GRID);

			/* Spinner list */
			this.mSpinnerListSelectionOverlayTexture = new Scale9Textures(this.mAtlas.getTexture("spinner-list-selection-overlay-skin"), SPINNER_LIST_OVERLAY_SCALE9_GRID);

			/* TabBar */
			this.mTabUpTexture = new Scale9Textures(this.mAtlas.getTexture("tab-up-skin"), TAB_SCALE9_GRID);
			this.mTabDownTexture = new Scale9Textures(this.mAtlas.getTexture("tab-down-skin"), TAB_SCALE9_GRID);
			this.mTabSelectedTexture = new Scale9Textures(this.mAtlas.getTexture("tab-selected-up-skin"), TAB_SCALE9_GRID);
			this.mTabSelectedDownTexture = new Scale9Textures(this.mAtlas.getTexture("tab-selected-down-skin"), TAB_SCALE9_GRID);
			this.mTabSelectedDisabledTexture = new Scale9Textures(this.mAtlas.getTexture("tab-selected-disabled-skin"), TAB_SCALE9_GRID);

			/* Text & search inputs */
			this.mTextInputUpTexture = new Scale9Textures(this.mAtlas.getTexture("text-input-up-skin"), BUTTON_SCALE9_GRID);
			this.mTextInputFocusedTexture = new Scale9Textures(this.mAtlas.getTexture("text-input-focused-skin"), BUTTON_SCALE9_GRID);
			this.mTextInputDisabledTexture = new Scale9Textures(this.mAtlas.getTexture("text-input-disabled-skin"), BUTTON_SCALE9_GRID);
			this.mSearchInputUpTexture = new Scale9Textures(this.mAtlas.getTexture("search-input-up-skin"), SEARCH_INPUT_SCALE9_GRID);
			this.mSearchInputFocusedTexture = new Scale9Textures(this.mAtlas.getTexture("search-input-focused-skin"), SEARCH_INPUT_SCALE9_GRID);
			this.mSearchInputDisabledTexture = new Scale9Textures(this.mAtlas.getTexture("search-input-disabled-skin"), SEARCH_INPUT_SCALE9_GRID);
			this.mSearchIconTexture = this.mAtlas.getTexture("search-input-icon");

			/* ToggleSwitch */
			this.mToggleSwitchOnTexture = new Scale9Textures(this.mAtlas.getTexture("toggle-switch-on-skin"), BUTTON_SCALE9_GRID);
		}

		protected function initializeFonts():void
		{
			this.mSmallFontSize = Math.round(24 * this.mScale);
			this.mRegularFontSize = Math.round(32 * this.mScale);
			this.mLargeFontSize = Math.round(42 * this.mScale);

			/* These are for components that do not use FTE */
			this.mScrollTextTextFormat = new TextFormat("_sans", this.mRegularFontSize, COLOR_TEXT_DARK);
			this.mScrollTextDisabledTextFormat = new TextFormat("_sans", this.mRegularFontSize, COLOR_TEXT_DARK_DISABLED);

			this.mRegularFontDescription = new FontDescription(FONT_NAME, FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE);

			/* UI */
			this.mLightUIElementFormat = new ElementFormat(this.mRegularFontDescription, this.mRegularFontSize, COLOR_TEXT_LIGHT);
			this.mLightUIDisabledElementFormat = new ElementFormat(this.mRegularFontDescription, this.mRegularFontSize, COLOR_TEXT_LIGHT_DISABLED);
			this.mDarkUIElementFormat = new ElementFormat(this.mRegularFontDescription, this.mRegularFontSize, COLOR_TEXT_DARK);
			this.mDarkUIDisabledElementFormat = new ElementFormat(this.mRegularFontDescription, this.mRegularFontSize, COLOR_TEXT_DARK_DISABLED);
			this.mDarkUISmallElementFormat = new ElementFormat(this.mRegularFontDescription, this.mSmallFontSize, COLOR_TEXT_DARK);
			this.mDarkUISmallDisabledElementFormat = new ElementFormat(this.mRegularFontDescription, this.mSmallFontSize, COLOR_TEXT_DARK_DISABLED);
			this.mDangerButtonDisabledElementFormat = new ElementFormat(this.mRegularFontDescription, this.mRegularFontSize, COLOR_TEXT_DANGER_DISABLED);
			this.mBlueUIElementFormat = new ElementFormat(this.mRegularFontDescription, this.mRegularFontSize, COLOR_TEXT_BLUE);
			this.mBlueUIDisabledElementFormat = new ElementFormat(this.mRegularFontDescription, this.mRegularFontSize, COLOR_TEXT_BLUE_DISABLED);
			this.mDarkUILargeElementFormat = new ElementFormat(this.mRegularFontDescription, this.mLargeFontSize, COLOR_TEXT_DARK);
			this.mDarkUILargeDisabledElementFormat = new ElementFormat(this.mRegularFontDescription, this.mLargeFontSize, COLOR_TEXT_DARK_DISABLED);
		}

		protected function initializeGlobals():void
		{
			FeathersControl.defaultTextRendererFactory = textRendererFactory;

			PopUpManager.overlayFactory = popUpOverlayFactory;
		}

		protected function initializeStyleProviders():void
		{
			/* Alert */
			this.getStyleProviderForClass(Alert).defaultStyleFunction = this.setAlertStyles;
			this.getStyleProviderForClass(ButtonGroup).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_BUTTON_GROUP, this.setAlertButtonGroupStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_ALERT_BUTTON_GROUP_BUTTON, this.setAlertButtonGroupButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_ALERT_BUTTON_GROUP_LAST_BUTTON, this.setAlertButtonGroupLastButtonStyles);
			this.getStyleProviderForClass(Header).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setHeaderWithoutBackgroundStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_MESSAGE, this.setAlertMessageTextRendererStyles);

			/* AutoComplete */
			this.getStyleProviderForClass(AutoComplete).defaultStyleFunction = this.setTextInputStyles;
			this.getStyleProviderForClass(List).setFunctionForStyleName(AutoComplete.DEFAULT_CHILD_STYLE_NAME_LIST, this.setAutoCompleteListStyles);

			/* Buttons */
			this.getStyleProviderForClass(Button).defaultStyleFunction = this.setButtonStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_DANGER_BUTTON, this.setDangerButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_CALL_TO_ACTION_BUTTON, this.setCallToActionButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON, this.setBackButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_FORWARD_BUTTON, this.setForwardButtonStyles);
			this.getStyleProviderForClass(ToggleButton).defaultStyleFunction = this.setButtonStyles;
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);

			/* ButtonGroup */
			this.getStyleProviderForClass(ButtonGroup).defaultStyleFunction = this.setButtonGroupStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ButtonGroup.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setButtonStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ButtonGroup.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setButtonStyles);

			/* Callout */
			this.getStyleProviderForClass(Callout).defaultStyleFunction = this.setCalloutStyles;

			/* Check */
			this.getStyleProviderForClass(Check).defaultStyleFunction = this.setCheckStyles;

			/* Drawers */
			this.getStyleProviderForClass(Drawers).defaultStyleFunction = this.setDrawersStyles;

			/* GroupedList*/
			this.getStyleProviderForClass(GroupedList).defaultStyleFunction = this.setGroupedListStyles;

			/* Header */
			this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;

			/* Label */
			this.getStyleProviderForClass(Label).defaultStyleFunction = this.setLabelStyles;
			this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_STYLE_NAME_HEADING, this.setHeadingLabelStyles);
			this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_STYLE_NAME_DETAIL, this.setDetailLabelStyles);

			/* List / Item renderers */
			this.getStyleProviderForClass(List).defaultStyleFunction = this.setListStyles;
			this.getStyleProviderForClass(DefaultListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_DROP_DOWN_LIST_ITEM_RENDERER, this.setPickerListItemRendererStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_ICON_LABEL, this.setItemRendererIconLabelStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL, this.setItemRendererAccessoryLabelRendererStyles);
			/* Custom style for the last item in GroupedList (without shadow at the bottom) */
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_GROUPED_LIST_LAST_ITEM_RENDERER, this.setGroupedListLastItemRendererStyles);
			/* GroupedList header / footer */
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).defaultStyleFunction = this.setGroupedListHeaderRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.DEFAULT_CHILD_STYLE_NAME_FOOTER_RENDERER, this.setGroupedListFooterRendererStyles);

			/* Numeric stepper */
			this.getStyleProviderForClass(NumericStepper).defaultStyleFunction = this.setNumericStepperStyles;
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_TEXT_INPUT, this.setNumericStepperTextInputStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON, this.setNumericStepperButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON, this.setNumericStepperButtonStyles);

			/* Page indicator */
			this.getStyleProviderForClass(PageIndicator).defaultStyleFunction = this.setPageIndicatorStyles;

			/* Panel */
			this.getStyleProviderForClass(Panel).defaultStyleFunction = this.setPanelStyles;
			this.getStyleProviderForClass(Header).setFunctionForStyleName(Panel.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setHeaderWithoutBackgroundStyles);

			/* Panel screen */
			this.getStyleProviderForClass(PanelScreen).defaultStyleFunction = this.setPanelStyles;
			this.getStyleProviderForClass(Header).setFunctionForStyleName(PanelScreen.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setPanelScreenHeaderStyles);

			/* Picker list */
			this.getStyleProviderForClass(List).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_LIST, this.setPickerListListStyles);
			this.getStyleProviderForClass(PickerList).defaultStyleFunction = this.setPickerListStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setPickerListButtonStyles);

			/* Progress bar */
			this.getStyleProviderForClass(ProgressBar).defaultStyleFunction = this.setProgressBarStyles;

			/* Radio */
			this.getStyleProviderForClass(Radio).defaultStyleFunction = this.setRadioStyles;

			/* Scroll container */
			this.getStyleProviderForClass(ScrollContainer).defaultStyleFunction = this.setScrollContainerStyles;
			this.getStyleProviderForClass(ScrollContainer).setFunctionForStyleName(ScrollContainer.ALTERNATE_STYLE_NAME_TOOLBAR, this.setToolbarScrollContainerStyles);

			/* Scroll text */
			this.getStyleProviderForClass(ScrollText).defaultStyleFunction = this.setScrollTextStyles;

			/* Simple scroll bar */
			this.getStyleProviderForClass(SimpleScrollBar).defaultStyleFunction = this.setSimpleScrollBarStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB, this.setVerticalSimpleScrollBarThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB, this.setHorizontalSimpleScrollBarThumbStyles);

			/* Slider */
			this.getStyleProviderForClass(Slider).defaultStyleFunction = this.setSliderStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SLIDER_THUMB, this.setHorizontalButtonThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SLIDER_THUMB, this.setVerticalButtonThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK, this.setHorizontalSliderMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SLIDER_MAXIMUM_TRACK, this.setHorizontalSliderMaximumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK, this.setVerticalSliderMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SLIDER_MAXIMUM_TRACK, this.setVerticalSliderMaximumTrackStyles);

			/* Spinner list */
			this.getStyleProviderForClass(SpinnerList).defaultStyleFunction = this.setSpinnerListStyles;
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER, this.setSpinnerListItemRendererStyles);

			/* Tab bar */
			this.getStyleProviderForClass(TabBar).defaultStyleFunction = this.setTabBarStyles;
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(TabBar.DEFAULT_CHILD_STYLE_NAME_TAB, this.setTabStyles);

			/* Text input */
			this.getStyleProviderForClass(TextInput).defaultStyleFunction = this.setTextInputStyles;
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName(TextInput.ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT, this.setSearchTextInputStyles);

			/* Text area */
			this.getStyleProviderForClass(TextArea).defaultStyleFunction = this.setTextAreaStyles;

			/* Toggle switch */
			this.getStyleProviderForClass(ToggleSwitch).defaultStyleFunction = this.setToggleSwitchStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_ON_TRACK, this.setToggleSwitchOnTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_OFF_TRACK, this.setToggleSwitchOffTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setHorizontalButtonThumbStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setHorizontalButtonThumbStyles);
		}

		/**
		 * Auto complete
		 */

		protected function setAutoCompleteListStyles(list:List):void
		{
			this.setScrollerStyles(list);

			list.maxHeight = 500 * this.mScale;
			list.paddingLeft = 10 * this.mScale;
			list.paddingRight = 14 * this.mScale;
			list.paddingBottom = this.mSmallPaddingSize;
			list.backgroundSkin = new Scale9Image(this.mPickerListListBackgroundTexture, this.mScale);
			list.verticalScrollPolicy = List.SCROLL_POLICY_ON;
			list.customItemRendererStyleName = THEME_STYLE_NAME_DROP_DOWN_LIST_ITEM_RENDERER;
		}

		/**
		 * Buttons
		 */

		protected function setButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.mButtonUpTexture;
			skinSelector.setValueForState(this.mButtonDownTexture, Button.STATE_DOWN);
			skinSelector.setValueForState(this.mButtonDisabledTexture, Button.STATE_DISABLED);
			this.setBaseButtonSize(skinSelector);
			/* Set ToggleButton styles as well */
			if( button is ToggleButton )
			{
				skinSelector.defaultSelectedValue = this.mButtonSelectedUpTexture;
				skinSelector.setValueForState(this.mButtonSelectedDownTexture, Button.STATE_DOWN, true);
				skinSelector.setValueForState(this.mButtonSelectedDisabledTexture, Button.STATE_DISABLED, true);
			}

			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
		}

		protected function setQuietButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = null;
			skinSelector.setValueForState(this.mButtonQuietDownTexture, Button.STATE_DOWN);
			this.setBaseButtonSize(skinSelector);

			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
		}

		protected function setDangerButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.mButtonDangerUpTexture;
			skinSelector.setValueForState(this.mButtonDangerDownTexture, Button.STATE_DOWN);
			skinSelector.setValueForState(this.mButtonDangerDisabledTexture, Button.STATE_DISABLED);
			this.setBaseButtonSize(skinSelector);

			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
			/* Override label color */
			button.defaultLabelProperties.elementFormat = this.mLightUIElementFormat;
			button.disabledLabelProperties.elementFormat = this.mDangerButtonDisabledElementFormat;
		}

		protected function setCallToActionButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.mButtonCallToActionUpTexture;
			skinSelector.setValueForState(this.mButtonCallToActionDownTexture, Button.STATE_DOWN);
			skinSelector.setValueForState(this.mButtonCallToActionDisabledTexture, Button.STATE_DISABLED);
			this.setBaseButtonSize(skinSelector);

			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
			/* Override label color */
			button.defaultLabelProperties.elementFormat = this.mLightUIElementFormat;
			button.disabledLabelProperties.elementFormat = this.mBlueUIDisabledElementFormat;
		}

		protected function setBackButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.mButtonBackUpTexture;
			skinSelector.setValueForState(this.mButtonBackDownTexture, Button.STATE_DOWN);
			skinSelector.setValueForState(this.mButtonBackDisabledTexture, Button.STATE_DISABLED);
			this.setBaseButtonSize(skinSelector);

			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
			/* Override left padding */
			button.paddingLeft = this.mRegularPaddingSize + this.mSmallPaddingSize;
		}

		protected function setForwardButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.mButtonForwardUpTexture;
			skinSelector.setValueForState(this.mButtonForwardDownTexture, Button.STATE_DOWN);
			skinSelector.setValueForState(this.mButtonForwardDisabledTexture, Button.STATE_DISABLED);
			this.setBaseButtonSize(skinSelector);

			button.stateToSkinFunction = skinSelector.updateValue;
			setBaseButtonStyles(button);
			/* Override right padding */
			button.paddingRight = this.mRegularPaddingSize + this.mSmallPaddingSize;
		}

		/**
		 * ButtonGroup
		 */

		protected function setButtonGroupStyles(group:ButtonGroup):void
		{
			group.minWidth = 720 * this.mScale;
			group.gap = this.mRegularPaddingSize;
		}

		/**
		 * Check
		 */

		protected function setCheckStyles(check:Check):void
		{
			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.defaultValue = this.mCheckUpIconTexture;
			iconSelector.defaultSelectedValue = this.mCheckSelectedUpIconTexture;
			iconSelector.setValueForState(this.mCheckDownIconTexture, Button.STATE_DOWN);
			iconSelector.setValueForState(this.mCheckDisabledIconTexture, Button.STATE_DISABLED);
			iconSelector.setValueForState(this.mCheckSelectedDownIconTexture, Button.STATE_DOWN, true);
			iconSelector.setValueForState(this.mCheckSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
			iconSelector.displayObjectProperties =
			{
				scaleX: this.mScale,
				scaleY: this.mScale
			};
			check.stateToIconFunction = iconSelector.updateValue;

			check.defaultLabelProperties.elementFormat = this.mDarkUIElementFormat;
			check.disabledLabelProperties.elementFormat = this.mDarkUIDisabledElementFormat;
			check.selectedDisabledLabelProperties.elementFormat = this.mDarkUIDisabledElementFormat;

			check.gap = this.mSmallPaddingSize;
		}

		/**
		 * Radio
		 */

		protected function setRadioStyles(radio:Radio):void
		{
			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.defaultValue = this.mRadioUpIconTexture;
			iconSelector.defaultSelectedValue = this.mRadioSelectedUpIconTexture;
			iconSelector.setValueForState(this.mRadioDownIconTexture, Button.STATE_DOWN);
			iconSelector.setValueForState(this.mRadioDisabledIconTexture, Button.STATE_DISABLED);
			iconSelector.setValueForState(this.mRadioSelectedDownIconTexture, Button.STATE_DOWN, true);
			iconSelector.setValueForState(this.mRadioSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
			iconSelector.displayObjectProperties =
			{
				scaleX: this.mScale,
				scaleY: this.mScale
			};
			radio.stateToIconFunction = iconSelector.updateValue;

			radio.defaultLabelProperties.elementFormat = this.mDarkUIElementFormat;
			radio.disabledLabelProperties.elementFormat = this.mDarkUIDisabledElementFormat;
			radio.selectedDisabledLabelProperties.elementFormat = this.mDarkUIDisabledElementFormat;

			radio.gap = this.mSmallPaddingSize;
		}

		/**
		 * ToggleSwitch
		 */

		protected function setToggleSwitchStyles(toggle:ToggleSwitch):void
		{
			toggle.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_ON_OFF;

			toggle.defaultLabelProperties.elementFormat = this.mDarkUIElementFormat;
			toggle.onLabelProperties.elementFormat = this.mBlueUIElementFormat;
			toggle.disabledLabelProperties.elementFormat = this.mDarkUIDisabledElementFormat;
		}

		protected function setToggleSwitchOnTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.mToggleSwitchOnTexture;
			skinSelector.setValueForState(this.mButtonDisabledTexture, Button.STATE_DISABLED);
			this.setBaseToggleSwitchSize( skinSelector);

			track.stateToSkinFunction = skinSelector.updateValue;
			track.hasLabelTextRenderer = false;
		}

		protected function setToggleSwitchOffTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.mButtonDownTexture;
			skinSelector.setValueForState(this.mButtonDisabledTexture, Button.STATE_DISABLED);
			this.setBaseToggleSwitchSize(skinSelector);

			track.stateToSkinFunction = skinSelector.updateValue;
			track.hasLabelTextRenderer = false;
		}

		protected function setHorizontalButtonThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.mButtonThumbHorizontalUpTexture;
			skinSelector.setValueForState(this.mButtonThumbHorizontalDownTexture, Button.STATE_DOWN);
			skinSelector.setValueForState(this.mButtonThumbHorizontalDisabledTexture, Button.STATE_DISABLED);
			skinSelector.displayObjectProperties =
			{
				width: 68 * this.mScale,
				height: this.mControlSize,
				textureScale: this.mScale
			};
			thumb.stateToSkinFunction = skinSelector.updateValue;
			thumb.hasLabelTextRenderer = false;
		}

		protected function setVerticalButtonThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.mButtonThumbVerticalUpTexture;
			skinSelector.setValueForState(this.mButtonThumbVerticalDownTexture, Button.STATE_DOWN);
			skinSelector.setValueForState(this.mButtonThumbVerticalDisabledTexture, Button.STATE_DISABLED);
			skinSelector.displayObjectProperties =
			{
				width: this.mControlSize,
				height: 68 * this.mScale,
				textureScale: this.mScale
			};
			thumb.stateToSkinFunction = skinSelector.updateValue;
			thumb.hasLabelTextRenderer = false;
		}

		/**
		 * Progress bar
		 */

		protected function setProgressBarStyles(progress:ProgressBar):void
		{
			var backgroundSkin:Scale9Image;
			var backgroundDisabledSkin:Scale9Image;
			/* Horizontal background skin */
			if(progress.direction === ProgressBar.DIRECTION_HORIZONTAL)
			{
				backgroundSkin = new Scale9Image(this.mProgressBarHorizontalBackgroundTexture, this.mScale);
				backgroundSkin.width = this.mTrackSize;
				backgroundSkin.height = this.mTrackSize;
				backgroundDisabledSkin = new Scale9Image(this.mProgressBarHorizontalBackgroundDisabledTexture, this.mScale);
				backgroundDisabledSkin.width = this.mTrackSize;
				backgroundDisabledSkin.height = this.mTrackSize;
			}
			else //vertical
			{
				backgroundSkin = new Scale9Image(this.mProgressBarVerticalBackgroundTexture, this.mScale);
				backgroundSkin.width = this.mTrackSize;
				backgroundSkin.height = this.mTrackSize;
				backgroundDisabledSkin = new Scale9Image(this.mProgressBarVerticalBackgroundDisabledTexture, this.mScale);
				backgroundDisabledSkin.width = this.mTrackSize;
				backgroundDisabledSkin.height = this.mTrackSize;
			}
			progress.backgroundSkin = backgroundSkin;
			progress.backgroundDisabledSkin = backgroundDisabledSkin;

			var fillSkin:Scale9Image;
			var fillDisabledSkin:Scale9Image;
			/* Horizontal fill skin */
			if(progress.direction === ProgressBar.DIRECTION_HORIZONTAL)
			{
				fillSkin = new Scale9Image(this.mProgressBarHorizontalFillTexture, this.mScale);
				fillSkin.width = this.mTrackSize;
				fillSkin.height = this.mTrackSize;
				fillDisabledSkin = new Scale9Image(this.mProgressBarHorizontalFillDisabledTexture, this.mScale);
				fillDisabledSkin.width = this.mTrackSize;
				fillDisabledSkin.height = this.mTrackSize;
			}
			else //vertical
			{
				fillSkin = new Scale9Image(this.mProgressBarVerticalFillTexture, this.mScale);
				fillSkin.width = this.mTrackSize;
				fillSkin.height = this.mTrackSize;
				fillDisabledSkin = new Scale9Image(mProgressBarVerticalFillDisabledTexture, this.mScale);
				fillDisabledSkin.width = this.mTrackSize;
				fillDisabledSkin.height = this.mTrackSize;
			}
			progress.fillSkin = fillSkin;
			progress.fillDisabledSkin = fillDisabledSkin;
		}

		/**
		 * Label
		 */

		protected function setLabelStyles(label:Label):void
		{
			label.textRendererProperties.elementFormat = this.mDarkUIElementFormat;
			label.textRendererProperties.disabledElementFormat = this.mDarkUIDisabledElementFormat;
		}

		protected function setHeadingLabelStyles(label:Label):void
		{
			label.textRendererProperties.elementFormat = this.mDarkUILargeElementFormat;
			label.textRendererProperties.disabledElementFormat = this.mDarkUILargeDisabledElementFormat;
		}

		protected function setDetailLabelStyles(label:Label):void
		{
			label.textRendererProperties.elementFormat = this.mDarkUISmallElementFormat;
			label.textRendererProperties.disabledElementFormat = this.mDarkUISmallDisabledElementFormat;
		}

		/**
		 * List
		 */

		protected function setListStyles(list:List):void
		{
			this.setScrollerStyles(list);
			list.backgroundSkin = new Quad(10, 10, COLOR_BACKGROUND_LIGHT);
		}

		protected function setItemRendererStyles(renderer:BaseDefaultItemRenderer):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.mItemRendererUpTexture;
			skinSelector.defaultSelectedValue = this.mItemRendererSelectedTexture;
			skinSelector.setValueForState(this.mItemRendererDownTexture, Button.STATE_DOWN);
			skinSelector.displayObjectProperties =
			{
				width: this.mControlSize,
				height: this.mControlSize,
				textureScale: this.mScale
			};
			renderer.stateToSkinFunction = skinSelector.updateValue;

			this.setBaseItemRendererStyles(renderer);
		}

		protected function setGroupedListLastItemRendererStyles(renderer:BaseDefaultItemRenderer):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.mLastItemRendererUpTexture;
			skinSelector.defaultSelectedValue = this.mLastItemRendererSelectedTexture;
			skinSelector.setValueForState(this.mLastItemRendererDownTexture, Button.STATE_DOWN);
			skinSelector.displayObjectProperties =
			{
				width: this.mControlSize,
				height: this.mControlSize,
				textureScale: this.mScale
			};
			renderer.stateToSkinFunction = skinSelector.updateValue;

			this.setBaseItemRendererStyles(renderer);
			renderer.paddingTop = 42 * this.mScale;
		}

		protected function setItemRendererAccessoryLabelRendererStyles(renderer:TextBlockTextRenderer):void
		{
			renderer.elementFormat = this.mDarkUIElementFormat;
		}

		protected function setItemRendererIconLabelStyles(renderer:TextBlockTextRenderer):void
		{
			renderer.elementFormat = this.mDarkUIElementFormat;
		}

		/**
		 * Grouped list
		 */

		protected function setGroupedListStyles(list:GroupedList):void
		{
			this.setScrollerStyles(list);
			list.backgroundSkin = new Quad(10, 10, COLOR_BACKGROUND_LIGHT);
			list.customLastItemRendererStyleName = THEME_STYLE_NAME_GROUPED_LIST_LAST_ITEM_RENDERER;
		}

		//see List section for item renderer styles

		protected function setGroupedListHeaderRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			renderer.backgroundSkin = new Scale9Image(this.mGroupedListHeaderTexture, this.mScale);

			renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_LEFT;
			renderer.contentLabelProperties.elementFormat = this.mDarkUIElementFormat;
			renderer.contentLabelProperties.disabledElementFormat = this.mDarkUIDisabledElementFormat;
			renderer.paddingTop = this.mSmallPaddingSize;
			renderer.paddingRight = this.mRegularPaddingSize;
			renderer.paddingBottom = this.mSmallPaddingSize;
			renderer.paddingLeft = this.mRegularPaddingSize;

			renderer.contentLoaderFactory = this.imageLoaderFactory;
		}

		protected function setGroupedListFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			renderer.backgroundSkin = new Scale9Image(this.mGroupedListFooterTexture, this.mScale);

			renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_CENTER;
			renderer.contentLabelProperties.elementFormat = this.mLightUIElementFormat;
			renderer.contentLabelProperties.disabledElementFormat = this.mLightUIDisabledElementFormat;
			renderer.paddingTop = this.mSmallPaddingSize;
			renderer.paddingRight = this.mRegularPaddingSize; 
			renderer.paddingBottom = this.mSmallPaddingSize;
			renderer.paddingLeft = this.mRegularPaddingSize;

			renderer.contentLoaderFactory = this.imageLoaderFactory;
		}

		/**
		 * Numeric stepper
		 */

		protected function setNumericStepperStyles(stepper:NumericStepper):void
		{
			stepper.buttonLayoutMode = NumericStepper.BUTTON_LAYOUT_MODE_SPLIT_HORIZONTAL;
			stepper.incrementButtonLabel = "+";
			stepper.decrementButtonLabel = "-";
		}

		protected function setNumericStepperTextInputStyles(input:TextInput):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.mTextInputUpTexture;
			skinSelector.setValueForState(this.mTextInputDisabledTexture, TextInput.STATE_DISABLED);
			skinSelector.displayObjectProperties =
			{
				width: this.mControlSize,
				height: this.mControlSize,
				textureScale: this.mScale
			};
			input.stateToSkinFunction = skinSelector.updateValue;

			input.minWidth = this.mControlSize;
			input.minHeight = this.mControlSize;
			input.padding = this.mSmallPaddingSize;
			input.isEditable = false;
			input.textEditorFactory = stepperTextEditorFactory;
			input.textEditorProperties.elementFormat = this.mDarkUIElementFormat;
			input.textEditorProperties.disabledElementFormat = this.mDarkUIDisabledElementFormat;
			input.textEditorProperties.textAlign = TextBlockTextEditor.TEXT_ALIGN_CENTER;
		}

		protected function setNumericStepperButtonStyles(button:Button):void
		{
			setQuietButtonStyles(button);
			button.keepDownStateOnRollOut = true;
			button.defaultLabelProperties.elementFormat = this.mDarkUILargeElementFormat;
			button.disabledLabelProperties.elementFormat = this.mDarkUILargeDisabledElementFormat;
		}

		/**
		 * Picker list
		 */

		protected function setPickerListStyles(list:PickerList):void
		{
			if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				list.popUpContentManager = new DropDownPopUpContentManager();
			}
			else
			{
				var manager:VerticalCenteredPopUpContentManager = new VerticalCenteredPopUpContentManager();
				manager.margin = this.mRegularPaddingSize;
				list.popUpContentManager = manager;
			}
		}

		protected function setPickerListButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.mButtonPickerListUpTexture;
			skinSelector.setValueForState(this.mButtonDownTexture, Button.STATE_DOWN);
			skinSelector.setValueForState(this.mButtonDisabledTexture, Button.STATE_DISABLED);
			this.setBaseButtonSize(skinSelector);

			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);

			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
			iconSelector.defaultValue = this.mPickerListButtonIcon;
			iconSelector.setValueForState(this.mPickerListButtonDisabledIcon, Button.STATE_DISABLED);
			iconSelector.displayObjectProperties =
			{
				textureScale: this.mScale,
				snapToPixels: true
			};
			button.stateToIconFunction = iconSelector.updateValue;

			button.gap = Number.POSITIVE_INFINITY;
			button.minGap = this.mRegularPaddingSize;
			button.iconPosition = Button.ICON_POSITION_RIGHT;
			button.paddingLeft = this.mRegularPaddingSize;
		}

		protected function setPickerListListStyles(list:List):void
		{
			this.setScrollerStyles(list);

			list.verticalScrollPolicy = List.SCROLL_POLICY_ON;

			if( DeviceCapabilities.isTablet( Starling.current.nativeStage ) )
			{
				list.maxHeight = 500 * this.mScale;
				list.paddingLeft = 10 * this.mScale;
				list.paddingRight = 14 * this.mScale;
				list.paddingBottom = this.mSmallPaddingSize;
				list.backgroundSkin = new Scale9Image(this.mPickerListListBackgroundTexture, this.mScale);
			}
			else
			{
				list.paddingTop = 6 * this.mScale;
				list.paddingRight = 10 * this.mScale;
				list.paddingBottom = 14 * this.mScale;
				list.paddingLeft = 6 * this.mScale;
				list.backgroundSkin = new Scale9Image(this.mBackgroundPopUpTexture, this.mScale);
			}

			list.customItemRendererStyleName = THEME_STYLE_NAME_DROP_DOWN_LIST_ITEM_RENDERER;
		}

		protected function setPickerListItemRendererStyles(renderer:BaseDefaultItemRenderer):void
		{
			this.setBaseDropDownListItemRendererStyles(renderer);
		}

		/**
		 * Spinner list
		 */

		protected function setSpinnerListStyles(list:SpinnerList):void
		{
			list.verticalScrollPolicy = List.SCROLL_POLICY_ON;
			list.paddingTop = 6 * this.mScale;
			list.paddingRight = 10 * this.mScale;
			list.paddingBottom = 14 * this.mScale;
			list.paddingLeft = 6 * this.mScale;
			list.backgroundSkin = new Scale9Image(this.mBackgroundPopUpTexture, this.mScale);
			list.selectionOverlaySkin = new Scale9Image(this.mSpinnerListSelectionOverlayTexture, this.mScale);
			list.customItemRendererStyleName = THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER;
		}

		protected function setSpinnerListItemRendererStyles(renderer:BaseDefaultItemRenderer):void
		{
			/* Style is the same as for the PickerList items, except that the
			 * SpinnerList's item does not have a skin for the selected state */
			setBaseDropDownListItemRendererStyles(renderer).defaultSelectedValue = null;
		}

		/**
		 * Scroll container
		 */

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
				layout.padding = this.mRegularPaddingSize;
				layout.gap = this.mRegularPaddingSize;
				container.layout = layout;
			}
			container.minWidth = this.mControlSize;
			container.minHeight = this.mControlSize;

			container.backgroundSkin = new Quad(10, 10, COLOR_BACKGROUND_LIGHT);
		}

		/**
		 * Scroll text
		 */

		protected function setScrollTextStyles(text:ScrollText):void
		{
			this.setScrollerStyles(text);

			text.textFormat = this.mScrollTextTextFormat;
			text.disabledTextFormat = this.mScrollTextDisabledTextFormat;
			text.padding = this.mRegularPaddingSize;
			text.paddingRight = this.mRegularPaddingSize + this.mSmallPaddingSize;
		}

		/**
		 * Scroll bar
		 */

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
			var padding:int = this.mSmallPaddingSize * 0.5;
			scrollBar.paddingTop = padding;
			scrollBar.paddingRight = padding;
			scrollBar.paddingBottom = padding;
		}

		protected function setHorizontalSimpleScrollBarThumbStyles(thumb:Button):void
		{
			var defaultSkin:Scale3Image = new Scale3Image(this.mHorizontalScrollBarTexture, this.mScale);
			defaultSkin.width = 52 * this.mScale;
			thumb.defaultSkin = defaultSkin;
			thumb.hasLabelTextRenderer = false;
		}

		protected function setVerticalSimpleScrollBarThumbStyles(thumb:Button):void
		{
			var defaultSkin:Scale3Image = new Scale3Image(this.mVerticalScrollBarTexture, this.mScale);
			defaultSkin.height = 52 * this.mScale;
			thumb.defaultSkin = defaultSkin;
			thumb.hasLabelTextRenderer = false;
		}

		/**
		 * Page indicator
		 */

		protected function setPageIndicatorStyles(pageIndicator:PageIndicator):void
		{
			pageIndicator.normalSymbolFactory = pageIndicatorNormalSymbolFactory;
			pageIndicator.selectedSymbolFactory = pageIndicatorSelectedSymbolFactory;
			pageIndicator.gap = this.mRegularPaddingSize;
			pageIndicator.padding = this.mRegularPaddingSize;
			pageIndicator.minTouchWidth = this.mRegularPaddingSize * 2;
			pageIndicator.minTouchHeight = this.mRegularPaddingSize * 2;
		}

		/**
		 * Panel
		 */

		protected function setPanelStyles(panel:Panel):void
		{
			this.setScrollerStyles(panel);

			panel.backgroundSkin = new Quad(1, 1, COLOR_BACKGROUND_LIGHT);

			panel.paddingTop = this.mSmallPaddingSize;
			panel.paddingRight = this.mSmallPaddingSize;
			panel.paddingBottom = this.mSmallPaddingSize;
			panel.paddingLeft = this.mSmallPaddingSize;
		}

		protected function setHeaderWithoutBackgroundStyles(header:Header):void
		{
			header.gap = this.mRegularPaddingSize;
			header.padding = this.mRegularPaddingSize;
			header.titleGap = this.mRegularPaddingSize;
			header.minHeight = this.mHeaderSize;
			header.titleProperties.elementFormat = this.mDarkUILargeElementFormat;
		}

		/**
		 * Panel Screen
		 */

		protected function setPanelScreenHeaderStyles(header:Header):void
		{
			this.setHeaderStyles(header);
			header.useExtraPaddingForOSStatusBar = true;
		}

		/**
		 * Header
		 */

		protected function setHeaderStyles(header:Header):void
		{
			this.setHeaderWithoutBackgroundStyles(header);

			var backgroundSkin:Scale9Image = new Scale9Image(this.mHeaderBackgroundTexture, this.mScale);
			backgroundSkin.width = 80 * this.mScale;
			backgroundSkin.height = this.mHeaderSize;
			header.backgroundSkin = backgroundSkin;
			header.titleProperties.elementFormat = this.mDarkUILargeElementFormat;
		}

		/**
		 * Tab Bar
		 */

		protected function setTabBarStyles(tabBar:TabBar):void
		{
			tabBar.distributeTabSizes = true;
		}

		protected function setTabStyles(tab:ToggleButton):void
		{
			/* No skin for disabled state (just different label) */

			tab.defaultSkin = new Scale9Image(this.mTabUpTexture, this.mScale);
			tab.downSkin = new Scale9Image(this.mTabDownTexture, this.mScale);
			tab.defaultSelectedSkin = new Scale9Image(this.mTabSelectedTexture, this.mScale);
			tab.selectedDisabledSkin = new Scale9Image(this.mTabSelectedDisabledTexture, this.mScale);
			tab.selectedDownSkin = new Scale9Image(this.mTabSelectedDownTexture, this.mScale);

			tab.defaultLabelProperties.elementFormat = this.mDarkUIElementFormat;
			tab.defaultSelectedLabelProperties.elementFormat = this.mBlueUIElementFormat;
			tab.disabledLabelProperties.elementFormat = this.mDarkUIDisabledElementFormat;
			tab.selectedDisabledLabelProperties.elementFormat = this.mBlueUIDisabledElementFormat;

			tab.paddingLeft = this.mRegularPaddingSize;
			tab.paddingRight = this.mRegularPaddingSize;
			tab.minWidth = this.mWideControlSize;
			tab.minHeight = this.mWideControlSize;
		}

		/**
		 * Slider
		 */

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
			skinSelector.defaultValue = this.mSliderHorizontalMinimalTrackTexture;
			skinSelector.setValueForState(this.mSliderHorizontalDisabledTrackTexture, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.mScale
			};
			skinSelector.displayObjectProperties.width = this.mTrackSize;
			skinSelector.displayObjectProperties.height = this.mTrackSize;
			track.stateToSkinFunction = skinSelector.updateValue;
			track.hasLabelTextRenderer = false;
		}

		protected function setHorizontalSliderMaximumTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.mSliderHorizontalMaximumTrackTexture;
			skinSelector.setValueForState(this.mSliderHorizontalDisabledTrackTexture, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.mScale
			};
			skinSelector.displayObjectProperties.width = this.mTrackSize;
			skinSelector.displayObjectProperties.height = this.mTrackSize;
			track.stateToSkinFunction = skinSelector.updateValue;
			track.hasLabelTextRenderer = false;
		}

		protected function setVerticalSliderMinimumTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.mSliderVerticalMinimumTrackTexture;
			skinSelector.setValueForState(this.mSliderVerticalDisabledTrackTexture, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.mScale
			};
			skinSelector.displayObjectProperties.width = this.mTrackSize;
			skinSelector.displayObjectProperties.height = this.mTrackSize;
			track.stateToSkinFunction = skinSelector.updateValue;
			track.hasLabelTextRenderer = false;
		}

		protected function setVerticalSliderMaximumTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.mSliderVerticalMaximumTrackTexture;
			skinSelector.setValueForState(this.mSliderVerticalDisabledTrackTexture, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: mScale
			};
			skinSelector.displayObjectProperties.width = this.mTrackSize;
			skinSelector.displayObjectProperties.height = this.mTrackSize;
			track.stateToSkinFunction = skinSelector.updateValue;
			track.hasLabelTextRenderer = false;
		}

		/**
		 * Text area
		 */

		protected function setTextAreaStyles(textArea:TextArea):void
		{
			setScrollerStyles(textArea);

			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.mTextInputUpTexture;
			skinSelector.setValueForState(this.mTextInputFocusedTexture, TextInput.STATE_FOCUSED);
			skinSelector.setValueForState(this.mTextInputDisabledTexture, TextInput.STATE_DISABLED);
			skinSelector.displayObjectProperties =
			{
				width: this.mControlSize * 2,
				height: this.mControlSize * 2,
				textureScale: this.mScale
			};
			textArea.stateToSkinFunction = skinSelector.updateValue;

			textArea.padding = this.mRegularPaddingSize;

			textArea.textEditorProperties.textFormat = this.mScrollTextTextFormat;
			textArea.textEditorProperties.disabledTextFormat = this.mScrollTextDisabledTextFormat;
		}

		/**
		 * Text input
		 */

		protected function setTextInputStyles(input:TextInput):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.mTextInputUpTexture;
			skinSelector.setValueForState(this.mTextInputFocusedTexture, TextInput.STATE_FOCUSED);
			skinSelector.setValueForState(this.mTextInputDisabledTexture, TextInput.STATE_DISABLED);
			skinSelector.displayObjectProperties =
			{
				width: 30 * this.mScale,
				height: this.mControlSize,
				textureScale: this.mScale
			};
			input.stateToSkinFunction = skinSelector.updateValue;

			input.minWidth = 30 * this.mScale;
			input.paddingLeft = this.mSmallPaddingSize;
			input.paddingRight = this.mSmallPaddingSize;

			setBaseTextInputStyles(input);
		}

		protected function setSearchTextInputStyles(input:TextInput):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.mSearchInputUpTexture;
			skinSelector.setValueForState(this.mSearchInputFocusedTexture, TextInput.STATE_FOCUSED);
			skinSelector.setValueForState(this.mSearchInputDisabledTexture, TextInput.STATE_DISABLED);
			skinSelector.displayObjectProperties =
			{
				width: this.mWideControlSize,
				height: this.mControlSize,
				textureScale: this.mScale
			};
			input.stateToSkinFunction = skinSelector.updateValue;

			input.gap = this.mSmallPaddingSize;
			input.minWidth = this.mWideControlSize;
			input.paddingLeft = this.mRegularPaddingSize;
			input.paddingRight = this.mSmallPaddingSize * 2.5;

			/* Icon */
			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
			iconSelector.defaultValue = this.mSearchIconTexture;
			iconSelector.displayObjectProperties =
			{
				textureScale: this.mScale,
				snapToPixels: true
			};
			input.stateToIconFunction = iconSelector.updateValue;

			this.setBaseTextInputStyles(input);
		}

		/**
		 * Callout
		 */

		protected function setCalloutStyles(callout:Callout):void
		{
			var backgroundSkin:Scale9Image = new Scale9Image(this.mBackgroundPopUpTexture, mScale);
			backgroundSkin.width = this.mRegularPaddingSize;
			backgroundSkin.height = this.mRegularPaddingSize;
			callout.backgroundSkin = backgroundSkin;

			var topArrowSkin:Image = new Image(this.mCalloutTopArrowTexture);
			topArrowSkin.scaleX = this.mScale;
			topArrowSkin.scaleY = this.mScale;
			callout.topArrowSkin = topArrowSkin;
			callout.topArrowGap = -16 * this.mScale;

			var rightArrowSkin:Image = new Image(this.mCalloutRightArrowTexture);
			rightArrowSkin.scaleX = this.mScale;
			rightArrowSkin.scaleY = mScale;
			callout.rightArrowSkin = rightArrowSkin;
			callout.rightArrowGap = -14 * this.mScale;

			var bottomArrowSkin:Image = new Image(this.mCalloutBottomArrowTexture);
			bottomArrowSkin.scaleX = this.mScale;
			bottomArrowSkin.scaleY = this.mScale;
			callout.bottomArrowSkin = bottomArrowSkin;
			callout.bottomArrowGap = -16 * this.mScale;

			var leftArrowSkin:Image = new Image(this.mCalloutLeftArrowTexture);
			leftArrowSkin.scaleX = this.mScale;
			leftArrowSkin.scaleY = this.mScale;
			callout.leftArrowSkin = leftArrowSkin;
			callout.leftArrowGap = -14 * this.mScale;

			callout.padding = this.mRegularPaddingSize;
		}

		/**
		 * Alert
		 */

		protected function setAlertStyles(alert:Alert):void
		{
			this.setScrollerStyles(alert);

			alert.backgroundSkin = new Scale9Image(this.mBackgroundPopUpTexture, this.mScale);

			alert.paddingTop = 0;
			alert.paddingRight = this.mRegularPaddingSize;
			alert.paddingBottom = this.mRegularPaddingSize;
			alert.paddingLeft = this.mRegularPaddingSize;
			alert.gap = this.mRegularPaddingSize;
			alert.maxWidth = 720 * this.mScale;
			alert.maxHeight = 720 * this.mScale;
		}

		//see Panel section for Header styles

		protected function setAlertButtonGroupStyles(group:ButtonGroup):void
		{
			group.direction = ButtonGroup.DIRECTION_HORIZONTAL;
			group.horizontalAlign = ButtonGroup.HORIZONTAL_ALIGN_CENTER;
			group.verticalAlign = ButtonGroup.VERTICAL_ALIGN_JUSTIFY;
			group.distributeButtonSizes = false;
			group.gap = this.mRegularPaddingSize;
			group.padding = this.mRegularPaddingSize;
			group.paddingTop = 0;
			group.customLastButtonStyleName = THEME_STYLE_NAME_ALERT_BUTTON_GROUP_LAST_BUTTON;
			group.customButtonStyleName = THEME_STYLE_NAME_ALERT_BUTTON_GROUP_BUTTON;
		}

		protected function setAlertButtonGroupButtonStyles(button:Button):void
		{
			this.setButtonStyles(button);
			button.minWidth = this.mControlSize * 2;
		}

		protected function setAlertButtonGroupLastButtonStyles(button:Button):void
		{
			this.setCallToActionButtonStyles(button);
			button.minWidth = this.mControlSize * 2;
		}

		protected function setAlertMessageTextRendererStyles(renderer:TextBlockTextRenderer):void
		{
			renderer.wordWrap = true;
			renderer.elementFormat = this.mDarkUIElementFormat;
		}

		/**
		 * Drawers
		 */

		protected function setDrawersStyles(drawers:Drawers):void
		{
			var overlaySkin:Quad = new Quad(10, 10, COLOR_DRAWER_OVERLAY);
			overlaySkin.alpha = ALPHA_DRAWER_OVERLAY;
			drawers.overlaySkin = overlaySkin;
		}

		/**
		 *
		 *
		 * Shared
		 *
		 *
		 */

		protected function setScrollerStyles(scroller:Scroller):void
		{
			scroller.verticalScrollBarFactory = scrollBarFactory;
			scroller.horizontalScrollBarFactory = scrollBarFactory;
		}

		protected function setBaseTextInputStyles(input:TextInput):void
		{
			input.textEditorProperties.fontFamily = "Helvetica";
			input.textEditorProperties.fontSize = this.mRegularFontSize;
			input.textEditorProperties.color = COLOR_TEXT_DARK;
			input.textEditorProperties.disabledColor = COLOR_TEXT_DARK_DISABLED;

			input.promptProperties.elementFormat = this.mDarkUIElementFormat;
			input.promptProperties.disabledElementFormat = this.mDarkUIDisabledElementFormat;

			input.minHeight = this.mControlSize;
			input.paddingTop = this.mSmallPaddingSize * 0.5;
		}

		protected function setBaseButtonSize( skinSelector:SmartDisplayObjectStateValueSelector):void
		{
			skinSelector.displayObjectProperties =
			{
				width: this.mControlSize,
				height: this.mControlSize,
				textureScale: this.mScale
			};
		}

		protected function setBaseButtonStyles(button:Button):void
		{
			button.defaultLabelProperties.elementFormat = this.mDarkUIElementFormat;
			button.disabledLabelProperties.elementFormat = this.mDarkUIDisabledElementFormat;
			button.minHeight = this.mControlSize;
			button.paddingBottom = 30 * this.mScale;
			button.paddingTop = 30 * this.mScale;
			button.paddingRight = this.mRegularPaddingSize;
			button.paddingLeft = this.mRegularPaddingSize;
		}

		protected function setBaseItemRendererStyles(renderer:BaseDefaultItemRenderer):void
		{
			renderer.downLabelProperties.elementFormat = this.mDarkUILargeElementFormat;
			renderer.defaultLabelProperties.elementFormat = this.mDarkUILargeElementFormat;
			renderer.disabledLabelProperties.elementFormat = this.mDarkUILargeDisabledElementFormat;
			renderer.defaultSelectedLabelProperties.elementFormat = this.mDarkUILargeElementFormat;

			renderer.horizontalAlign = BaseDefaultItemRenderer.HORIZONTAL_ALIGN_LEFT;
			renderer.paddingTop = this.mRegularPaddingSize;
			renderer.paddingBottom = this.mRegularPaddingSize;
			renderer.paddingLeft = this.mRegularPaddingSize;
			renderer.paddingRight = this.mRegularPaddingSize;
			renderer.gap = this.mRegularPaddingSize;
			renderer.minGap = this.mRegularPaddingSize;
			renderer.iconPosition = BaseDefaultItemRenderer.ICON_POSITION_LEFT;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.minAccessoryGap = this.mRegularPaddingSize;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
			renderer.minWidth = this.mControlSize;
			renderer.minHeight = this.mControlSize;
			renderer.minTouchWidth = this.mControlSize;
			renderer.minTouchHeight = this.mControlSize;

			renderer.accessoryLoaderFactory = imageLoaderFactory;
			renderer.iconLoaderFactory = imageLoaderFactory;
		}

		protected function setBaseDropDownListItemRendererStyles(renderer:BaseDefaultItemRenderer):SmartDisplayObjectStateValueSelector
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.mPickerListItemRendererUpTexture;
			skinSelector.defaultSelectedValue = this.mPickerListItemRendererSelectedTexture;
			skinSelector.setValueForState(this.mPickerListItemRendererDownTexture, Button.STATE_DOWN);
			skinSelector.displayObjectProperties =
			{
				width: this.mControlSize,
				height: this.mControlSize,
				textureScale: this.mScale
			};
			renderer.stateToSkinFunction = skinSelector.updateValue;

			renderer.defaultLabelProperties.elementFormat = this.mDarkUIElementFormat;
			renderer.downLabelProperties.elementFormat = this.mDarkUIElementFormat;
			renderer.disabledLabelProperties.elementFormat = this.mDarkUIElementFormat;

			renderer.gap = this.mRegularPaddingSize;
			renderer.minWidth = this.mControlSize * 2;
			renderer.itemHasIcon = false;
			renderer.iconPosition = BaseDefaultItemRenderer.ICON_POSITION_LEFT;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.minAccessoryGap = this.mRegularPaddingSize;
			renderer.horizontalAlign = BaseDefaultItemRenderer.HORIZONTAL_ALIGN_CENTER;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
			return skinSelector;
		}

		protected function setBaseToggleSwitchSize( skinSelector:SmartDisplayObjectStateValueSelector):void
		{
			skinSelector.displayObjectProperties =
			{
				width: 140 * this.mScale,
				height: this.mControlSize,
				textureScale: this.mScale
			};
		}

		/**
		 *
		 *
		 * Font renderers / factories
		 *
		 *
		 */

		protected function textRendererFactory():TextBlockTextRenderer
		{
			var renderer:TextBlockTextRenderer = new TextBlockTextRenderer();
			renderer.elementFormat = this.mLightUIElementFormat;
			return renderer;
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
			image.textureScale = this.mScale;
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

		protected function pageIndicatorNormalSymbolFactory():DisplayObject
		{
			var symbol:ImageLoader = new ImageLoader();
			symbol.source = this.mPageIndicatorNormalTexture;
			symbol.textureScale = this.mScale;
			return symbol;
		}

		protected function pageIndicatorSelectedSymbolFactory():DisplayObject
		{
			var symbol:ImageLoader = new ImageLoader();
			symbol.source = this.mPageIndicatorSelectedTexture;
			symbol.textureScale = this.mScale;
			return symbol;
		}

		/**
		 *
		 *
		 * Helpers
		 *
		 *
		 */

		protected function textureValueTypeHandler( value:Texture, oldDisplayObject:DisplayObject = null):DisplayObject
		{
			var displayObject:ImageLoader = oldDisplayObject as ImageLoader;
			if(!displayObject)
			{
				displayObject = new ImageLoader();
			}
			displayObject.source = value;
			return displayObject;
		}

	}

}
