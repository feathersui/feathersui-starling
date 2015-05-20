/*
 Copyright 2012-2015 Joshua Tynjala, Marcel Piestansky

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
package feathers.themes {

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

    public class BaseTopcoatLightMobileTheme extends StyleNameFunctionTheme {

        [Embed(source="/../assets/fonts/SourceSansPro-Regular.ttf", fontFamily="SourceSansPro", fontWeight="normal", mimeType="application/x-font", embedAsCFF="true")]
        private static const SOURCE_SANS_PRO_REGULAR:Class;

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
        protected static const BUTTON_SCALE9_GRID:Rectangle = new Rectangle( 10, 10, 12, 80 );
        protected static const BUTTON_BACK_SCALE9_GRID:Rectangle = new Rectangle( 52, 10, 20, 80 );
        protected static const BUTTON_FORWARD_SCALE9_GRID:Rectangle = new Rectangle( 10, 10, 20, 80 );
        protected static const TOGGLE_BUTTON_SCALE9_GRID:Rectangle = new Rectangle( 16, 16, 10, 68 );
        protected static const BUTTON_THUMB_HORIZONTAL_SCALE9_GRID:Rectangle = new Rectangle( 31, 31, 4, 38 );
        protected static const BUTTON_THUMB_VERTICAL_SCALE9_GRID:Rectangle = new Rectangle( 31, 31, 38, 4 );
        protected static const BAR_HORIZONTAL_SCALE9_GRID:Rectangle = new Rectangle( 16, 15, 1, 2 );
        protected static const BAR_VERTICAL_SCALE9_GRID:Rectangle = new Rectangle( 15, 16, 2, 1 );
        protected static const HEADER_BACKGROUND_SCALE9_GRID:Rectangle = new Rectangle( 5, 5, 20, 112 );
        protected static const TAB_SCALE9_GRID:Rectangle = new Rectangle( 5, 5, 10, 110 );
        protected static const SEARCH_INPUT_SCALE9_GRID:Rectangle = new Rectangle( 50, 49, 20, 2 );
        protected static const BACKGROUND_POPUP_SCALE9_GRID:Rectangle = new Rectangle( 8, 8, 24, 24 );
        protected static const LIST_ITEM_SCALE9_GRID:Rectangle = new Rectangle( 4, 4, 2, 92 );
        protected static const GROUPED_LIST_HEADER_OR_FOOTER_SCALE9_GRID:Rectangle = new Rectangle( 4, 4, 2, 42 );
        protected static const PICKER_LIST_LIST_BACKGROUND_SCALE9_GRID:Rectangle = new Rectangle( 20, 20, 2, 72 );
        protected static const SPINNER_LIST_OVERLAY_SCALE9_GRID:Rectangle = new Rectangle( 9, 9, 6, 6 );
        protected static const SCROLL_BAR_REGION1:int = 9;
        protected static const SCROLL_BAR_REGION2:int = 34;

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

        private static var mScale:Number;
        private var mOriginalDPI:int;
        private var mScaleToDPI:Boolean;

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

        public function BaseTopcoatLightMobileTheme( scaleToDPI:Boolean = true ) {
            super();
            mScaleToDPI = scaleToDPI;
        }

        /**
         *
         *
         * Initializers
         *
         *
         */

        /**
         * Initializes the theme. Expected to be called by subclasses after the
         * assets have been loaded and the skin texture atlas has been created.
         */
        protected function initialize():void {
            initializeScale();
            initializeDimensions();
            initializeFonts();
            initializeTextures();
            initializeGlobals();
            initializeStage();
            initializeStyleProviders();
        }

        protected function initializeStage():void {
            Starling.current.stage.color = COLOR_BACKGROUND_LIGHT;
            Starling.current.nativeStage.color = COLOR_BACKGROUND_LIGHT;
        }

        protected function initializeScale():void {
            var scaledDPI:int = DeviceCapabilities.dpi / Starling.contentScaleFactor;
            mOriginalDPI = scaledDPI;
            if( mScaleToDPI ) {
                if( DeviceCapabilities.isTablet( Starling.current.nativeStage ) ) {
                    mOriginalDPI = ORIGINAL_DPI_IPAD_RETINA;
                }
                else {
                    mOriginalDPI = ORIGINAL_DPI_IPHONE_RETINA;
                }
            }
            mScale = scaledDPI / mOriginalDPI;
        }

        protected function initializeDimensions():void {
            mSmallPaddingSize = Math.round( 20 * mScale );
            mRegularPaddingSize = Math.round( 40 * mScale );
            mTrackSize = Math.round( 32 * mScale );
            mControlSize = Math.round( 100 * mScale );
            mWideControlSize = Math.round( 120 * mScale );
            mHeaderSize = Math.round( 122 * mScale );
        }

        protected function initializeTextures():void {
            /* Background */
            mBackgroundPopUpTexture = new Scale9Textures( mAtlas.getTexture( "background-popup-skin" ), BACKGROUND_POPUP_SCALE9_GRID );

            /* Button */
            mButtonUpTexture = new Scale9Textures( mAtlas.getTexture( "button-up-skin" ), BUTTON_SCALE9_GRID );
            mButtonDownTexture = new Scale9Textures( mAtlas.getTexture( "button-down-skin" ), BUTTON_SCALE9_GRID );
            mButtonDisabledTexture = new Scale9Textures( mAtlas.getTexture( "button-disabled-skin" ), BUTTON_SCALE9_GRID );
            mButtonQuietDownTexture = new Scale9Textures( mAtlas.getTexture( "button-down-skin" ), BUTTON_SCALE9_GRID );
            mButtonDangerUpTexture = new Scale9Textures( mAtlas.getTexture( "button-danger-up-skin" ), BUTTON_SCALE9_GRID );
            mButtonDangerDownTexture = new Scale9Textures( mAtlas.getTexture( "button-danger-down-skin" ), BUTTON_SCALE9_GRID );
            mButtonDangerDisabledTexture = new Scale9Textures( mAtlas.getTexture( "button-danger-disabled-skin" ), BUTTON_SCALE9_GRID );
            mButtonCallToActionUpTexture = new Scale9Textures( mAtlas.getTexture( "button-call-to-action-up-skin" ), BUTTON_SCALE9_GRID );
            mButtonCallToActionDownTexture = new Scale9Textures( mAtlas.getTexture( "button-call-to-action-down-skin" ), BUTTON_SCALE9_GRID );
            mButtonCallToActionDisabledTexture = new Scale9Textures( mAtlas.getTexture( "button-call-to-action-disabled-skin" ), BUTTON_SCALE9_GRID );
            mButtonBackUpTexture = new Scale9Textures( mAtlas.getTexture( "button-back-up-skin" ), BUTTON_BACK_SCALE9_GRID );
            mButtonBackDownTexture = new Scale9Textures( mAtlas.getTexture( "button-back-down-skin" ), BUTTON_BACK_SCALE9_GRID );
            mButtonBackDisabledTexture = new Scale9Textures( mAtlas.getTexture( "button-back-disabled-skin" ), BUTTON_BACK_SCALE9_GRID );
            mButtonForwardUpTexture = new Scale9Textures( mAtlas.getTexture( "button-forward-up-skin" ), BUTTON_FORWARD_SCALE9_GRID );
            mButtonForwardDownTexture = new Scale9Textures( mAtlas.getTexture( "button-forward-down-skin" ), BUTTON_FORWARD_SCALE9_GRID );
            mButtonForwardDisabledTexture = new Scale9Textures( mAtlas.getTexture( "button-forward-disabled-skin" ), BUTTON_FORWARD_SCALE9_GRID );
            mButtonSelectedUpTexture = new Scale9Textures( mAtlas.getTexture( "button-selected-up-skin" ), TOGGLE_BUTTON_SCALE9_GRID );
            mButtonSelectedDownTexture = new Scale9Textures( mAtlas.getTexture( "button-selected-down-skin" ), TOGGLE_BUTTON_SCALE9_GRID );
            mButtonSelectedDisabledTexture = new Scale9Textures( mAtlas.getTexture( "button-selected-disabled-skin" ), TOGGLE_BUTTON_SCALE9_GRID );
            mButtonThumbHorizontalUpTexture = new Scale9Textures( mAtlas.getTexture( "button-thumb-horizontal-up-skin" ), BUTTON_THUMB_HORIZONTAL_SCALE9_GRID );
            mButtonThumbHorizontalDownTexture = new Scale9Textures( mAtlas.getTexture( "button-thumb-horizontal-down-skin" ), BUTTON_THUMB_HORIZONTAL_SCALE9_GRID );
            mButtonThumbHorizontalDisabledTexture = new Scale9Textures( mAtlas.getTexture( "button-thumb-horizontal-disabled-skin" ), BUTTON_THUMB_HORIZONTAL_SCALE9_GRID );
            mButtonThumbVerticalUpTexture = new Scale9Textures( mAtlas.getTexture( "button-thumb-vertical-up-skin" ), BUTTON_THUMB_VERTICAL_SCALE9_GRID );
            mButtonThumbVerticalDownTexture = new Scale9Textures( mAtlas.getTexture( "button-thumb-vertical-down-skin" ), BUTTON_THUMB_VERTICAL_SCALE9_GRID );
            mButtonThumbVerticalDisabledTexture = new Scale9Textures( mAtlas.getTexture( "button-thumb-vertical-disabled-skin" ), BUTTON_THUMB_VERTICAL_SCALE9_GRID );

            /* Callout */
            mCalloutTopArrowTexture = mAtlas.getTexture( "callout-arrow-top-skin" );
            mCalloutRightArrowTexture = mAtlas.getTexture( "callout-arrow-right-skin" );
            mCalloutBottomArrowTexture = mAtlas.getTexture( "callout-arrow-bottom-skin" );
            mCalloutLeftArrowTexture = mAtlas.getTexture( "callout-arrow-left-skin" );

            /* Check */
            mCheckUpIconTexture = mAtlas.getTexture( "check-up-icon" );
            mCheckDownIconTexture = mAtlas.getTexture( "check-down-icon" );
            mCheckDisabledIconTexture = mAtlas.getTexture( "check-disabled-icon" );
            mCheckSelectedUpIconTexture = mAtlas.getTexture( "check-selected-up-icon" );
            mCheckSelectedDownIconTexture = mAtlas.getTexture( "check-selected-down-icon" );
            mCheckSelectedDisabledIconTexture = mAtlas.getTexture( "check-selected-disabled-icon" );

            /* Header */
            mHeaderBackgroundTexture = new Scale9Textures( mAtlas.getTexture( "header-background-skin" ), HEADER_BACKGROUND_SCALE9_GRID );

            /* List / GroupedList / Item renderers */
            mItemRendererUpTexture = new Scale9Textures( mAtlas.getTexture( "list-item-up-skin" ), LIST_ITEM_SCALE9_GRID );
            mItemRendererDownTexture = new Scale9Textures( mAtlas.getTexture( "list-item-down-skin" ), LIST_ITEM_SCALE9_GRID );
            mItemRendererSelectedTexture = new Scale9Textures( mAtlas.getTexture( "list-item-selected-skin" ), LIST_ITEM_SCALE9_GRID );
            mLastItemRendererUpTexture = new Scale9Textures( mAtlas.getTexture( "list-last-item-up-skin" ), LIST_ITEM_SCALE9_GRID );
            mLastItemRendererDownTexture = new Scale9Textures( mAtlas.getTexture( "list-last-item-down-skin" ), LIST_ITEM_SCALE9_GRID );
            mLastItemRendererSelectedTexture = new Scale9Textures( mAtlas.getTexture( "list-last-item-selected-skin" ), LIST_ITEM_SCALE9_GRID );
            mGroupedListHeaderTexture = new Scale9Textures( mAtlas.getTexture( "grouped-list-header-skin" ), GROUPED_LIST_HEADER_OR_FOOTER_SCALE9_GRID );
            mGroupedListFooterTexture = new Scale9Textures( mAtlas.getTexture( "grouped-list-footer-skin" ), GROUPED_LIST_HEADER_OR_FOOTER_SCALE9_GRID );

            /* Page indicator */
            mPageIndicatorNormalTexture = mAtlas.getTexture( "page-indicator-normal-skin" );
            mPageIndicatorSelectedTexture = mAtlas.getTexture( "page-indicator-selected-skin" );

            /* Picker list */
            mButtonPickerListUpTexture = new Scale9Textures( mAtlas.getTexture( "button-picker-list-up-skin" ), BUTTON_SCALE9_GRID );
            mPickerListListBackgroundTexture = new Scale9Textures( mAtlas.getTexture( "picker-list-list-background-skin" ), PICKER_LIST_LIST_BACKGROUND_SCALE9_GRID );
            mPickerListButtonIcon = mAtlas.getTexture( "picker-list-button-icon" );
            mPickerListButtonDisabledIcon = mAtlas.getTexture( "picker-list-button-disabled-icon" );
            mPickerListItemRendererUpTexture = new Scale9Textures( mAtlas.getTexture( "picker-list-list-item-up-skin" ), LIST_ITEM_SCALE9_GRID );
            mPickerListItemRendererDownTexture = new Scale9Textures( mAtlas.getTexture( "picker-list-list-item-down-skin" ), LIST_ITEM_SCALE9_GRID );
            mPickerListItemRendererSelectedTexture = new Scale9Textures( mAtlas.getTexture( "picker-list-list-item-selected-skin" ), LIST_ITEM_SCALE9_GRID );

            /* ProgressBar */
            mProgressBarHorizontalFillTexture = new Scale9Textures( mAtlas.getTexture( "progress-bar-horizontal-fill-skin" ), BAR_HORIZONTAL_SCALE9_GRID );
            mProgressBarHorizontalFillDisabledTexture = new Scale9Textures( mAtlas.getTexture( "progress-bar-horizontal-fill-disabled-skin" ), BAR_HORIZONTAL_SCALE9_GRID );
            mProgressBarHorizontalBackgroundTexture = new Scale9Textures( mAtlas.getTexture( "progress-bar-horizontal-background-skin" ), BAR_HORIZONTAL_SCALE9_GRID );
            mProgressBarHorizontalBackgroundDisabledTexture = new Scale9Textures( mAtlas.getTexture( "progress-bar-horizontal-background-disabled-skin" ), BAR_HORIZONTAL_SCALE9_GRID );
            mProgressBarVerticalFillTexture = new Scale9Textures( mAtlas.getTexture( "progress-bar-vertical-fill-skin" ), BAR_VERTICAL_SCALE9_GRID );
            mProgressBarVerticalFillDisabledTexture = new Scale9Textures( mAtlas.getTexture( "progress-bar-vertical-fill-disabled-skin" ), BAR_VERTICAL_SCALE9_GRID );
            mProgressBarVerticalBackgroundTexture = new Scale9Textures( mAtlas.getTexture( "progress-bar-vertical-background-skin" ), BAR_VERTICAL_SCALE9_GRID );
            mProgressBarVerticalBackgroundDisabledTexture = new Scale9Textures( mAtlas.getTexture( "progress-bar-vertical-background-disabled-skin" ), BAR_VERTICAL_SCALE9_GRID );

            /* Radio */
            mRadioUpIconTexture = mAtlas.getTexture( "radio-up-icon" );
            mRadioDownIconTexture = mAtlas.getTexture( "radio-down-icon" );
            mRadioDisabledIconTexture = mAtlas.getTexture( "radio-disabled-icon" );
            mRadioSelectedUpIconTexture = mAtlas.getTexture( "radio-selected-up-icon" );
            mRadioSelectedDownIconTexture = mAtlas.getTexture( "radio-selected-down-icon" );
            mRadioSelectedDisabledIconTexture = mAtlas.getTexture( "radio-selected-disabled-icon" );

            /* Scroll bar */
            mVerticalScrollBarTexture = new Scale3Textures( mAtlas.getTexture( "simple-scroll-bar-vertical-thumb-skin" ), SCROLL_BAR_REGION1, SCROLL_BAR_REGION2, Scale3Textures.DIRECTION_VERTICAL );
            mHorizontalScrollBarTexture = new Scale3Textures( mAtlas.getTexture( "simple-scroll-bar-horizontal-thumb-skin" ), SCROLL_BAR_REGION1, SCROLL_BAR_REGION2, Scale3Textures.DIRECTION_HORIZONTAL );

            /* Slider */
            mSliderHorizontalMinimalTrackTexture = new Scale9Textures( mAtlas.getTexture( "slider-horizontal-minimum-track-skin" ), BAR_HORIZONTAL_SCALE9_GRID );
            mSliderHorizontalMaximumTrackTexture = new Scale9Textures( mAtlas.getTexture( "slider-horizontal-maximum-track-skin" ), BAR_HORIZONTAL_SCALE9_GRID );
            mSliderHorizontalDisabledTrackTexture = new Scale9Textures( mAtlas.getTexture( "slider-horizontal-disabled-track-skin" ), BAR_HORIZONTAL_SCALE9_GRID );
            mSliderVerticalMinimumTrackTexture = new Scale9Textures( mAtlas.getTexture( "slider-vertical-minimum-track-skin" ), BAR_VERTICAL_SCALE9_GRID );
            mSliderVerticalMaximumTrackTexture = new Scale9Textures( mAtlas.getTexture( "slider-vertical-maximum-track-skin" ), BAR_VERTICAL_SCALE9_GRID );
            mSliderVerticalDisabledTrackTexture = new Scale9Textures( mAtlas.getTexture( "slider-vertical-disabled-track-skin" ), BAR_VERTICAL_SCALE9_GRID );

            /* Spinner list */
            mSpinnerListSelectionOverlayTexture = new Scale9Textures( mAtlas.getTexture( "spinner-list-selection-overlay-skin" ), SPINNER_LIST_OVERLAY_SCALE9_GRID );

            /* TabBar */
            mTabUpTexture = new Scale9Textures( mAtlas.getTexture( "tab-up-skin" ), TAB_SCALE9_GRID );
            mTabDownTexture = new Scale9Textures( mAtlas.getTexture( "tab-down-skin" ), TAB_SCALE9_GRID );
            mTabSelectedTexture = new Scale9Textures( mAtlas.getTexture( "tab-selected-up-skin" ), TAB_SCALE9_GRID );
            mTabSelectedDownTexture = new Scale9Textures( mAtlas.getTexture( "tab-selected-down-skin" ), TAB_SCALE9_GRID );
            mTabSelectedDisabledTexture = new Scale9Textures( mAtlas.getTexture( "tab-selected-disabled-skin" ), TAB_SCALE9_GRID );

            /* Text & search inputs */
            mTextInputUpTexture = new Scale9Textures( mAtlas.getTexture( "text-input-up-skin" ), BUTTON_SCALE9_GRID );
            mTextInputFocusedTexture = new Scale9Textures( mAtlas.getTexture( "text-input-focused-skin" ), BUTTON_SCALE9_GRID );
            mTextInputDisabledTexture = new Scale9Textures( mAtlas.getTexture( "text-input-disabled-skin" ), BUTTON_SCALE9_GRID );
            mSearchInputUpTexture = new Scale9Textures( mAtlas.getTexture( "search-input-up-skin" ), SEARCH_INPUT_SCALE9_GRID );
            mSearchInputFocusedTexture = new Scale9Textures( mAtlas.getTexture( "search-input-focused-skin" ), SEARCH_INPUT_SCALE9_GRID );
            mSearchInputDisabledTexture = new Scale9Textures( mAtlas.getTexture( "search-input-disabled-skin" ), SEARCH_INPUT_SCALE9_GRID );
            mSearchIconTexture = mAtlas.getTexture( "search-input-icon" );

            /* ToggleSwitch */
            mToggleSwitchOnTexture = new Scale9Textures( mAtlas.getTexture( "toggle-switch-on-skin" ), BUTTON_SCALE9_GRID );
        }

        protected function initializeFonts():void {
            mSmallFontSize = Math.round( 24 * mScale );
            mRegularFontSize = Math.round( 32 * mScale );
            mLargeFontSize = Math.round( 42 * mScale );

            /* These are for components that do not use FTE */
            mScrollTextTextFormat = new TextFormat( "_sans", mRegularFontSize, COLOR_TEXT_DARK );
            mScrollTextDisabledTextFormat = new TextFormat( "_sans", mRegularFontSize, COLOR_TEXT_DARK_DISABLED );

            mRegularFontDescription = new FontDescription( FONT_NAME, FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE );

            /* UI */
            mLightUIElementFormat = new ElementFormat( mRegularFontDescription, mRegularFontSize, COLOR_TEXT_LIGHT );
            mLightUIDisabledElementFormat = new ElementFormat( mRegularFontDescription, mRegularFontSize, COLOR_TEXT_LIGHT_DISABLED );
            mDarkUIElementFormat = new ElementFormat( mRegularFontDescription, mRegularFontSize, COLOR_TEXT_DARK );
            mDarkUIDisabledElementFormat = new ElementFormat( mRegularFontDescription, mRegularFontSize, COLOR_TEXT_DARK_DISABLED );
            mDarkUISmallElementFormat = new ElementFormat( mRegularFontDescription, mSmallFontSize, COLOR_TEXT_DARK );
            mDarkUISmallDisabledElementFormat = new ElementFormat( mRegularFontDescription, mSmallFontSize, COLOR_TEXT_DARK_DISABLED );
            mDangerButtonDisabledElementFormat = new ElementFormat( mRegularFontDescription, mRegularFontSize, COLOR_TEXT_DANGER_DISABLED );
            mBlueUIElementFormat = new ElementFormat( mRegularFontDescription, mRegularFontSize, COLOR_TEXT_BLUE );
            mBlueUIDisabledElementFormat = new ElementFormat( mRegularFontDescription, mRegularFontSize, COLOR_TEXT_BLUE_DISABLED );
            mDarkUILargeElementFormat = new ElementFormat( mRegularFontDescription, mLargeFontSize, COLOR_TEXT_DARK );
            mDarkUILargeDisabledElementFormat = new ElementFormat( mRegularFontDescription, mLargeFontSize, COLOR_TEXT_DARK_DISABLED );
        }

        protected function initializeGlobals():void {
            FeathersControl.defaultTextRendererFactory = textRendererFactory;

            PopUpManager.overlayFactory = popUpOverlayFactory;
        }

        protected function initializeStyleProviders():void {
            /* Alert */
            getStyleProviderForClass( Alert ).defaultStyleFunction = setAlertStyles;
            getStyleProviderForClass( ButtonGroup ).setFunctionForStyleName( Alert.DEFAULT_CHILD_STYLE_NAME_BUTTON_GROUP, setAlertButtonGroupStyles );
            getStyleProviderForClass( Button ).setFunctionForStyleName( THEME_STYLE_NAME_ALERT_BUTTON_GROUP_BUTTON, setAlertButtonGroupButtonStyles );
            getStyleProviderForClass( Button ).setFunctionForStyleName( THEME_STYLE_NAME_ALERT_BUTTON_GROUP_LAST_BUTTON, setAlertButtonGroupLastButtonStyles );
            getStyleProviderForClass( Header ).setFunctionForStyleName( Alert.DEFAULT_CHILD_STYLE_NAME_HEADER, setHeaderWithoutBackgroundStyles );
            getStyleProviderForClass( TextBlockTextRenderer ).setFunctionForStyleName( Alert.DEFAULT_CHILD_STYLE_NAME_MESSAGE, setAlertMessageTextRendererStyles );

            /* AutoComplete */
            getStyleProviderForClass( AutoComplete ).defaultStyleFunction = setTextInputStyles;
            getStyleProviderForClass( List ).setFunctionForStyleName( AutoComplete.DEFAULT_CHILD_STYLE_NAME_LIST, setAutoCompleteListStyles );

            /* Buttons */
            getStyleProviderForClass( Button ).defaultStyleFunction = setButtonStyles;
            getStyleProviderForClass( Button ).setFunctionForStyleName( Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON, setQuietButtonStyles );
            getStyleProviderForClass( Button ).setFunctionForStyleName( Button.ALTERNATE_STYLE_NAME_DANGER_BUTTON, setDangerButtonStyles );
            getStyleProviderForClass( Button ).setFunctionForStyleName( Button.ALTERNATE_STYLE_NAME_CALL_TO_ACTION_BUTTON, setCallToActionButtonStyles );
            getStyleProviderForClass( Button ).setFunctionForStyleName( Button.ALTERNATE_STYLE_NAME_BACK_BUTTON, setBackButtonStyles );
            getStyleProviderForClass( Button ).setFunctionForStyleName( Button.ALTERNATE_STYLE_NAME_FORWARD_BUTTON, setForwardButtonStyles );
            getStyleProviderForClass( ToggleButton ).defaultStyleFunction = setButtonStyles;
            getStyleProviderForClass( ToggleButton ).setFunctionForStyleName( Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON, setQuietButtonStyles );

            /* ButtonGroup */
            getStyleProviderForClass( ButtonGroup ).defaultStyleFunction = setButtonGroupStyles;
            getStyleProviderForClass( Button ).setFunctionForStyleName( ButtonGroup.DEFAULT_CHILD_STYLE_NAME_BUTTON, setButtonStyles );
            getStyleProviderForClass( ToggleButton ).setFunctionForStyleName( ButtonGroup.DEFAULT_CHILD_STYLE_NAME_BUTTON, setButtonStyles );

            /* Callout */
            getStyleProviderForClass( Callout ).defaultStyleFunction = setCalloutStyles;

            /* Check */
            getStyleProviderForClass( Check ).defaultStyleFunction = setCheckStyles;

            /* Drawers */
            getStyleProviderForClass( Drawers ).defaultStyleFunction = setDrawersStyles;

            /* GroupedList*/
            getStyleProviderForClass( GroupedList ).defaultStyleFunction = setGroupedListStyles;

            /* Header */
            getStyleProviderForClass( Header ).defaultStyleFunction = setHeaderStyles;

            /* Label */
            getStyleProviderForClass( Label ).defaultStyleFunction = setLabelStyles;
            getStyleProviderForClass( Label ).setFunctionForStyleName( Label.ALTERNATE_STYLE_NAME_HEADING, setHeadingLabelStyles );
            getStyleProviderForClass( Label ).setFunctionForStyleName( Label.ALTERNATE_STYLE_NAME_DETAIL, setDetailLabelStyles );

            /* List / Item renderers */
            getStyleProviderForClass( List ).defaultStyleFunction = setListStyles;
            getStyleProviderForClass( DefaultListItemRenderer ).defaultStyleFunction = setItemRendererStyles;
            getStyleProviderForClass( DefaultGroupedListItemRenderer ).defaultStyleFunction = setItemRendererStyles;
            getStyleProviderForClass( DefaultListItemRenderer ).setFunctionForStyleName( THEME_STYLE_NAME_DROP_DOWN_LIST_ITEM_RENDERER, setPickerListItemRendererStyles );
            getStyleProviderForClass( TextBlockTextRenderer ).setFunctionForStyleName( BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_ICON_LABEL, setItemRendererIconLabelStyles );
            getStyleProviderForClass( TextBlockTextRenderer ).setFunctionForStyleName( BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL, setItemRendererAccessoryLabelRendererStyles );
            /* Custom style for the last item in GroupedList (without shadow at the bottom) */
            getStyleProviderForClass( DefaultGroupedListItemRenderer ).setFunctionForStyleName( THEME_STYLE_NAME_GROUPED_LIST_LAST_ITEM_RENDERER, setGroupedListLastItemRendererStyles );
            /* GroupedList header / footer */
            getStyleProviderForClass( DefaultGroupedListHeaderOrFooterRenderer ).defaultStyleFunction = setGroupedListHeaderRendererStyles;
            getStyleProviderForClass( DefaultGroupedListHeaderOrFooterRenderer ).setFunctionForStyleName( GroupedList.DEFAULT_CHILD_STYLE_NAME_FOOTER_RENDERER, setGroupedListFooterRendererStyles );

            /* Numeric stepper */
            getStyleProviderForClass( NumericStepper ).defaultStyleFunction = setNumericStepperStyles;
            getStyleProviderForClass( TextInput ).setFunctionForStyleName( NumericStepper.DEFAULT_CHILD_STYLE_NAME_TEXT_INPUT, setNumericStepperTextInputStyles );
            getStyleProviderForClass( Button ).setFunctionForStyleName( NumericStepper.DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON, setNumericStepperButtonStyles );
            getStyleProviderForClass( Button ).setFunctionForStyleName( NumericStepper.DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON, setNumericStepperButtonStyles );

            /* Page indicator */
            getStyleProviderForClass( PageIndicator ).defaultStyleFunction = setPageIndicatorStyles;

            /* Panel */
            getStyleProviderForClass( Panel ).defaultStyleFunction = setPanelStyles;
            getStyleProviderForClass( Header ).setFunctionForStyleName( Panel.DEFAULT_CHILD_STYLE_NAME_HEADER, setHeaderWithoutBackgroundStyles );

            /* Panel screen */
            getStyleProviderForClass( PanelScreen ).defaultStyleFunction = setPanelStyles;
            getStyleProviderForClass( Header ).setFunctionForStyleName( PanelScreen.DEFAULT_CHILD_STYLE_NAME_HEADER, setPanelScreenHeaderStyles );

            /* Picker list */
            getStyleProviderForClass( List ).setFunctionForStyleName( PickerList.DEFAULT_CHILD_STYLE_NAME_LIST, setPickerListListStyles );
            getStyleProviderForClass( PickerList ).defaultStyleFunction = setPickerListStyles;
            getStyleProviderForClass( Button ).setFunctionForStyleName( PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON, setPickerListButtonStyles );

            /* Progress bar */
            getStyleProviderForClass( ProgressBar ).defaultStyleFunction = setProgressBarStyles;

            /* Radio */
            getStyleProviderForClass( Radio ).defaultStyleFunction = setRadioStyles;

            /* Scroll container */
            getStyleProviderForClass( ScrollContainer ).defaultStyleFunction = setScrollContainerStyles;
            getStyleProviderForClass( ScrollContainer ).setFunctionForStyleName( ScrollContainer.ALTERNATE_STYLE_NAME_TOOLBAR, setToolbarScrollContainerStyles );

            /* Scroll text */
            getStyleProviderForClass( ScrollText ).defaultStyleFunction = setScrollTextStyles;

            /* Simple scroll bar */
            getStyleProviderForClass( SimpleScrollBar ).defaultStyleFunction = setSimpleScrollBarStyles;
            getStyleProviderForClass( Button ).setFunctionForStyleName( THEME_STYLE_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB, setVerticalSimpleScrollBarThumbStyles );
            getStyleProviderForClass( Button ).setFunctionForStyleName( THEME_STYLE_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB, setHorizontalSimpleScrollBarThumbStyles );

            /* Slider */
            getStyleProviderForClass( Slider ).defaultStyleFunction = setSliderStyles;
            getStyleProviderForClass( Button ).setFunctionForStyleName( THEME_STYLE_NAME_HORIZONTAL_SLIDER_THUMB, setHorizontalButtonThumbStyles );
            getStyleProviderForClass( Button ).setFunctionForStyleName( THEME_STYLE_NAME_VERTICAL_SLIDER_THUMB, setVerticalButtonThumbStyles );
            getStyleProviderForClass( Button ).setFunctionForStyleName( THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK, setHorizontalSliderMinimumTrackStyles );
            getStyleProviderForClass( Button ).setFunctionForStyleName( THEME_STYLE_NAME_HORIZONTAL_SLIDER_MAXIMUM_TRACK, setHorizontalSliderMaximumTrackStyles );
            getStyleProviderForClass( Button ).setFunctionForStyleName( THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK, setVerticalSliderMinimumTrackStyles );
            getStyleProviderForClass( Button ).setFunctionForStyleName( THEME_STYLE_NAME_VERTICAL_SLIDER_MAXIMUM_TRACK, setVerticalSliderMaximumTrackStyles );

            /* Spinner list */
            getStyleProviderForClass( SpinnerList ).defaultStyleFunction = setSpinnerListStyles;
            getStyleProviderForClass( DefaultListItemRenderer ).setFunctionForStyleName( THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER, setSpinnerListItemRendererStyles );

            /* Tab bar */
            getStyleProviderForClass( TabBar ).defaultStyleFunction = setTabBarStyles;
            getStyleProviderForClass( ToggleButton ).setFunctionForStyleName( TabBar.DEFAULT_CHILD_STYLE_NAME_TAB, setTabStyles );

            /* Text input */
            getStyleProviderForClass( TextInput ).defaultStyleFunction = setTextInputStyles;
            getStyleProviderForClass( TextInput ).setFunctionForStyleName( TextInput.ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT, setSearchTextInputStyles );

            /* Text area */
            getStyleProviderForClass( TextArea ).defaultStyleFunction = setTextAreaStyles;

            /* Toggle switch */
            getStyleProviderForClass( Button ).setFunctionForStyleName( ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_ON_TRACK, setToggleSwitchOnTrackStyles );
            getStyleProviderForClass( Button ).setFunctionForStyleName( ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_OFF_TRACK, setToggleSwitchOffTrackStyles );
            getStyleProviderForClass( Button ).setFunctionForStyleName( ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, setHorizontalButtonThumbStyles );
            getStyleProviderForClass( ToggleButton ).setFunctionForStyleName( ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, setHorizontalButtonThumbStyles );
            getStyleProviderForClass( ToggleSwitch ).defaultStyleFunction = setToggleSwitchStyles;
        }

        /**
         *
         *
         * Styles
         *
         *
         */

        /**
         * Auto complete
         */

        protected function setAutoCompleteListStyles( list:List ):void {
            setScrollerStyles( list );

            list.maxHeight = 500 * mScale;
            list.paddingLeft = 10 * mScale;
            list.paddingRight = 14 * mScale;
            list.paddingBottom = mSmallPaddingSize;
            list.backgroundSkin = new Scale9Image( mPickerListListBackgroundTexture, mScale );
            list.verticalScrollPolicy = List.SCROLL_POLICY_ON;
            list.customItemRendererStyleName = THEME_STYLE_NAME_DROP_DOWN_LIST_ITEM_RENDERER;
        }

        /**
         * Buttons
         */

        protected function setButtonStyles( button:Button ):void {
            var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            skinSelector.defaultValue = mButtonUpTexture;
            skinSelector.setValueForState( mButtonDownTexture, Button.STATE_DOWN );
            skinSelector.setValueForState( mButtonDisabledTexture, Button.STATE_DISABLED );
            setBaseButtonSize( skinSelector );
            /* Set ToggleButton styles as well */
            if( button is ToggleButton ) {
                skinSelector.defaultSelectedValue = mButtonSelectedUpTexture;
                skinSelector.setValueForState( mButtonSelectedDownTexture, Button.STATE_DOWN, true );
                skinSelector.setValueForState( mButtonSelectedDisabledTexture, Button.STATE_DISABLED, true );
            }

            button.stateToSkinFunction = skinSelector.updateValue;
            setBaseButtonStyles( button );
        }

        protected function setQuietButtonStyles( button:Button ):void {
            var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            skinSelector.defaultValue = null;
            skinSelector.setValueForState( mButtonQuietDownTexture, Button.STATE_DOWN );
            setBaseButtonSize( skinSelector );

            button.stateToSkinFunction = skinSelector.updateValue;
            setBaseButtonStyles( button );
        }

        protected function setDangerButtonStyles( button:Button ):void {
            var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            skinSelector.defaultValue = mButtonDangerUpTexture;
            skinSelector.setValueForState( mButtonDangerDownTexture, Button.STATE_DOWN );
            skinSelector.setValueForState( mButtonDangerDisabledTexture, Button.STATE_DISABLED );
            setBaseButtonSize( skinSelector );

            button.stateToSkinFunction = skinSelector.updateValue;
            setBaseButtonStyles( button );
            /* Override label color */
            button.defaultLabelProperties.elementFormat = mLightUIElementFormat;
            button.disabledLabelProperties.elementFormat = mDangerButtonDisabledElementFormat;
        }

        protected function setCallToActionButtonStyles( button:Button ):void {
            var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            skinSelector.defaultValue = mButtonCallToActionUpTexture;
            skinSelector.setValueForState( mButtonCallToActionDownTexture, Button.STATE_DOWN );
            skinSelector.setValueForState( mButtonCallToActionDisabledTexture, Button.STATE_DISABLED );
            setBaseButtonSize( skinSelector );

            button.stateToSkinFunction = skinSelector.updateValue;
            setBaseButtonStyles( button );
            /* Override label color */
            button.defaultLabelProperties.elementFormat = mLightUIElementFormat;
            button.disabledLabelProperties.elementFormat = mBlueUIDisabledElementFormat;
        }

        protected function setBackButtonStyles( button:Button ):void {
            var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            skinSelector.defaultValue = mButtonBackUpTexture;
            skinSelector.setValueForState( mButtonBackDownTexture, Button.STATE_DOWN );
            skinSelector.setValueForState( mButtonBackDisabledTexture, Button.STATE_DISABLED );
            setBaseButtonSize( skinSelector );

            button.stateToSkinFunction = skinSelector.updateValue;
            setBaseButtonStyles( button );
            /* Override left padding */
            button.paddingLeft = mRegularPaddingSize + mSmallPaddingSize;
        }

        protected function setForwardButtonStyles( button:Button ):void {
            var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            skinSelector.defaultValue = mButtonForwardUpTexture;
            skinSelector.setValueForState( mButtonForwardDownTexture, Button.STATE_DOWN );
            skinSelector.setValueForState( mButtonForwardDisabledTexture, Button.STATE_DISABLED );
            setBaseButtonSize( skinSelector );

            button.stateToSkinFunction = skinSelector.updateValue;
            setBaseButtonStyles( button );
            /* Override right padding */
            button.paddingRight = mRegularPaddingSize + mSmallPaddingSize;
        }

        /**
         * ButtonGroup
         */

        protected function setButtonGroupStyles( group:ButtonGroup ):void {
            group.minWidth = 720 * mScale;
            group.gap = mRegularPaddingSize;
        }

        /**
         * Check
         */

        protected function setCheckStyles( check:Check ):void {
            var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            iconSelector.defaultValue = mCheckUpIconTexture;
            iconSelector.defaultSelectedValue = mCheckSelectedUpIconTexture;
            iconSelector.setValueForState( mCheckDownIconTexture, Button.STATE_DOWN );
            iconSelector.setValueForState( mCheckDisabledIconTexture, Button.STATE_DISABLED );
            iconSelector.setValueForState( mCheckSelectedDownIconTexture, Button.STATE_DOWN, true );
            iconSelector.setValueForState( mCheckSelectedDisabledIconTexture, Button.STATE_DISABLED, true );
            iconSelector.displayObjectProperties =
            {
                scaleX: mScale,
                scaleY: mScale
            };
            check.stateToIconFunction = iconSelector.updateValue;

            check.defaultLabelProperties.elementFormat = mDarkUIElementFormat;
            check.disabledLabelProperties.elementFormat = mDarkUIDisabledElementFormat;
            check.selectedDisabledLabelProperties.elementFormat = mDarkUIDisabledElementFormat;

            check.gap = mSmallPaddingSize;
        }

        /**
         * Radio
         */

        protected function setRadioStyles( radio:Radio ):void {
            var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            iconSelector.defaultValue = mRadioUpIconTexture;
            iconSelector.defaultSelectedValue = mRadioSelectedUpIconTexture;
            iconSelector.setValueForState( mRadioDownIconTexture, Button.STATE_DOWN );
            iconSelector.setValueForState( mRadioDisabledIconTexture, Button.STATE_DISABLED );
            iconSelector.setValueForState( mRadioSelectedDownIconTexture, Button.STATE_DOWN, true );
            iconSelector.setValueForState( mRadioSelectedDisabledIconTexture, Button.STATE_DISABLED, true );
            iconSelector.displayObjectProperties =
            {
                scaleX: mScale,
                scaleY: mScale
            };
            radio.stateToIconFunction = iconSelector.updateValue;

            radio.defaultLabelProperties.elementFormat = mDarkUIElementFormat;
            radio.disabledLabelProperties.elementFormat = mDarkUIDisabledElementFormat;
            radio.selectedDisabledLabelProperties.elementFormat = mDarkUIDisabledElementFormat;

            radio.gap = mSmallPaddingSize;
        }

        /**
         * ToggleSwitch
         */

        protected function setToggleSwitchStyles( toggle:ToggleSwitch ):void {
            toggle.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_ON_OFF;

            toggle.defaultLabelProperties.elementFormat = mDarkUIElementFormat;
            toggle.onLabelProperties.elementFormat = mBlueUIElementFormat;
            toggle.disabledLabelProperties.elementFormat = mDarkUIDisabledElementFormat;
        }

        protected function setToggleSwitchOnTrackStyles( track:Button ):void {
            var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            skinSelector.defaultValue = mToggleSwitchOnTexture;
            skinSelector.setValueForState( mButtonDisabledTexture, Button.STATE_DISABLED );
            setBaseToggleSwitchSize( skinSelector );

            track.stateToSkinFunction = skinSelector.updateValue;
            track.hasLabelTextRenderer = false;
        }

        protected function setToggleSwitchOffTrackStyles( track:Button ):void {
            var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            skinSelector.defaultValue = mButtonDownTexture;
            skinSelector.setValueForState( mButtonDisabledTexture, Button.STATE_DISABLED );
            setBaseToggleSwitchSize( skinSelector );

            track.stateToSkinFunction = skinSelector.updateValue;
            track.hasLabelTextRenderer = false;
        }

        protected function setHorizontalButtonThumbStyles( thumb:Button ):void {
            var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            skinSelector.defaultValue = mButtonThumbHorizontalUpTexture;
            skinSelector.setValueForState( mButtonThumbHorizontalDownTexture, Button.STATE_DOWN );
            skinSelector.setValueForState( mButtonThumbHorizontalDisabledTexture, Button.STATE_DISABLED );
            skinSelector.displayObjectProperties =
            {
                width       : 68 * mScale,
                height      : mControlSize,
                textureScale: mScale
            };
            thumb.stateToSkinFunction = skinSelector.updateValue;
            thumb.hasLabelTextRenderer = false;
        }

        protected function setVerticalButtonThumbStyles( thumb:Button ):void {
            var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            skinSelector.defaultValue = mButtonThumbVerticalUpTexture;
            skinSelector.setValueForState( mButtonThumbVerticalDownTexture, Button.STATE_DOWN );
            skinSelector.setValueForState( mButtonThumbVerticalDisabledTexture, Button.STATE_DISABLED );
            skinSelector.displayObjectProperties =
            {
                width       : mControlSize,
                height      : 68 * mScale,
                textureScale: mScale
            };
            thumb.stateToSkinFunction = skinSelector.updateValue;
            thumb.hasLabelTextRenderer = false;
        }

        /**
         * Progress bar
         */

        protected function setProgressBarStyles( progress:ProgressBar ):void {
            var backgroundSkin:Scale9Image;
            var backgroundDisabledSkin:Scale9Image;
            /* Horizontal background skin */
            if( progress.direction == ProgressBar.DIRECTION_HORIZONTAL ) {
                backgroundSkin = new Scale9Image( mProgressBarHorizontalBackgroundTexture, mScale );
                backgroundSkin.width = mTrackSize;
                backgroundSkin.height = mTrackSize;
                backgroundDisabledSkin = new Scale9Image( mProgressBarHorizontalBackgroundDisabledTexture, mScale );
                backgroundDisabledSkin.width = mTrackSize;
                backgroundDisabledSkin.height = mTrackSize;
            }
            /* Vertical background skin */
            else {
                backgroundSkin = new Scale9Image( mProgressBarVerticalBackgroundTexture, mScale );
                backgroundSkin.width = mTrackSize;
                backgroundSkin.height = mTrackSize;
                backgroundDisabledSkin = new Scale9Image( mProgressBarVerticalBackgroundDisabledTexture, mScale );
                backgroundDisabledSkin.width = mTrackSize;
                backgroundDisabledSkin.height = mTrackSize;
            }
            progress.backgroundSkin = backgroundSkin;
            progress.backgroundDisabledSkin = backgroundDisabledSkin;

            var fillSkin:Scale9Image;
            var fillDisabledSkin:Scale9Image;
            /* Horizontal fill skin */
            if( progress.direction == ProgressBar.DIRECTION_HORIZONTAL ) {
                fillSkin = new Scale9Image( mProgressBarHorizontalFillTexture, mScale );
                fillSkin.width = mTrackSize;
                fillSkin.height = mTrackSize;
                fillDisabledSkin = new Scale9Image( mProgressBarHorizontalFillDisabledTexture, mScale );
                fillDisabledSkin.width = mTrackSize;
                fillDisabledSkin.height = mTrackSize;
            }
            /* Vertical fill skin */
            else {
                fillSkin = new Scale9Image( mProgressBarVerticalFillTexture, mScale );
                fillSkin.width = mTrackSize;
                fillSkin.height = mTrackSize;
                fillDisabledSkin = new Scale9Image( mProgressBarVerticalFillDisabledTexture, mScale );
                fillDisabledSkin.width = mTrackSize;
                fillDisabledSkin.height = mTrackSize;
            }
            progress.fillSkin = fillSkin;
            progress.fillDisabledSkin = fillDisabledSkin;
        }

        /**
         * Label
         */

        protected function setLabelStyles( label:Label ):void {
            label.textRendererProperties.elementFormat = mDarkUIElementFormat;
            label.textRendererProperties.disabledElementFormat = mDarkUIDisabledElementFormat;
        }

        protected function setHeadingLabelStyles( label:Label ):void {
            label.textRendererProperties.elementFormat = mDarkUILargeElementFormat;
            label.textRendererProperties.disabledElementFormat = mDarkUILargeDisabledElementFormat;
        }

        protected function setDetailLabelStyles( label:Label ):void {
            label.textRendererProperties.elementFormat = mDarkUISmallElementFormat;
            label.textRendererProperties.disabledElementFormat = mDarkUISmallDisabledElementFormat;
        }

        /**
         * List
         */

        protected function setListStyles( list:List ):void {
            setScrollerStyles( list );
            list.backgroundSkin = new Quad( 10, 10, COLOR_BACKGROUND_LIGHT );
        }

        protected function setItemRendererStyles( renderer:BaseDefaultItemRenderer ):void {
            var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            skinSelector.defaultValue = mItemRendererUpTexture;
            skinSelector.defaultSelectedValue = mItemRendererSelectedTexture;
            skinSelector.setValueForState( mItemRendererDownTexture, Button.STATE_DOWN );
            skinSelector.displayObjectProperties =
            {
                width       : mControlSize,
                height      : mControlSize,
                textureScale: mScale
            };
            renderer.stateToSkinFunction = skinSelector.updateValue;

            setBaseItemRendererStyles( renderer );
        }

        protected function setGroupedListLastItemRendererStyles( renderer:BaseDefaultItemRenderer ):void {
            var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            skinSelector.defaultValue = mLastItemRendererUpTexture;
            skinSelector.defaultSelectedValue = mLastItemRendererSelectedTexture;
            skinSelector.setValueForState( mLastItemRendererDownTexture, Button.STATE_DOWN );
            skinSelector.displayObjectProperties =
            {
                width       : mControlSize,
                height      : mControlSize,
                textureScale: mScale
            };
            renderer.stateToSkinFunction = skinSelector.updateValue;

            setBaseItemRendererStyles( renderer );
            renderer.paddingTop = 42 * mScale;
        }

        protected function setItemRendererAccessoryLabelRendererStyles( renderer:TextBlockTextRenderer ):void {
            renderer.elementFormat = mDarkUIElementFormat;
        }

        protected function setItemRendererIconLabelStyles( renderer:TextBlockTextRenderer ):void {
            renderer.elementFormat = mDarkUIElementFormat;
        }

        /**
         * Grouped list
         */

        protected function setGroupedListStyles( list:GroupedList ):void {
            setScrollerStyles( list );
            list.backgroundSkin = new Quad( 10, 10, COLOR_BACKGROUND_LIGHT );
            list.customLastItemRendererStyleName = THEME_STYLE_NAME_GROUPED_LIST_LAST_ITEM_RENDERER;
        }

        //see List section for item renderer styles

        protected function setGroupedListHeaderRendererStyles( renderer:DefaultGroupedListHeaderOrFooterRenderer ):void {
            renderer.backgroundSkin = new Scale9Image( mGroupedListHeaderTexture, mScale );

            renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_LEFT;
            renderer.contentLabelProperties.elementFormat = mDarkUIElementFormat;
            renderer.contentLabelProperties.disabledElementFormat = mDarkUIDisabledElementFormat;
            renderer.paddingTop = renderer.paddingBottom = mSmallPaddingSize;
            renderer.paddingLeft = renderer.paddingRight = mRegularPaddingSize;

            renderer.contentLoaderFactory = this.imageLoaderFactory;
        }

        protected function setGroupedListFooterRendererStyles( renderer:DefaultGroupedListHeaderOrFooterRenderer ):void {
            renderer.backgroundSkin = new Scale9Image( mGroupedListFooterTexture, mScale );

            renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_CENTER;
            renderer.contentLabelProperties.elementFormat = mLightUIElementFormat;
            renderer.contentLabelProperties.disabledElementFormat = mLightUIDisabledElementFormat;
            renderer.paddingTop = renderer.paddingBottom = mSmallPaddingSize;
            renderer.paddingLeft = renderer.paddingRight = mRegularPaddingSize;

            renderer.contentLoaderFactory = this.imageLoaderFactory;
        }

        /**
         * Numeric stepper
         */

        protected function setNumericStepperStyles( stepper:NumericStepper ):void {
            stepper.buttonLayoutMode = NumericStepper.BUTTON_LAYOUT_MODE_SPLIT_HORIZONTAL;
            stepper.incrementButtonLabel = "+";
            stepper.decrementButtonLabel = "-";
        }

        protected function setNumericStepperTextInputStyles( input:TextInput ):void {
            var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            skinSelector.defaultValue = mTextInputUpTexture;
            skinSelector.setValueForState( mTextInputDisabledTexture, TextInput.STATE_DISABLED );
            skinSelector.displayObjectProperties =
            {
                width       : mControlSize,
                height      : mControlSize,
                textureScale: mScale
            };
            input.stateToSkinFunction = skinSelector.updateValue;

            input.minWidth = mControlSize;
            input.minHeight = mControlSize;
            input.padding = mSmallPaddingSize;
            input.isEditable = false;
            input.textEditorFactory = stepperTextEditorFactory;
            input.textEditorProperties.elementFormat = mDarkUIElementFormat;
            input.textEditorProperties.disabledElementFormat = mDarkUIDisabledElementFormat;
            input.textEditorProperties.textAlign = TextBlockTextEditor.TEXT_ALIGN_CENTER;
        }

        protected function setNumericStepperButtonStyles( button:Button ):void {
            setQuietButtonStyles( button );
            button.keepDownStateOnRollOut = true;
            button.defaultLabelProperties.elementFormat = mDarkUILargeElementFormat;
            button.disabledLabelProperties.elementFormat = mDarkUILargeDisabledElementFormat;
        }

        /**
         * Picker list
         */

        protected function setPickerListStyles( list:PickerList ):void {
            if( DeviceCapabilities.isTablet( Starling.current.nativeStage ) ) {
                list.popUpContentManager = new DropDownPopUpContentManager();
            } else {
                const manager:VerticalCenteredPopUpContentManager = new VerticalCenteredPopUpContentManager();
                manager.marginLeft = manager.marginRight = manager.marginBottom = manager.marginTop = mRegularPaddingSize;
                list.popUpContentManager = manager;
            }
        }

        protected function setPickerListButtonStyles( button:Button ):void {
            var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            skinSelector.defaultValue = mButtonPickerListUpTexture;
            skinSelector.setValueForState( mButtonDownTexture, Button.STATE_DOWN );
            skinSelector.setValueForState( mButtonDisabledTexture, Button.STATE_DISABLED );
            setBaseButtonSize( skinSelector );

            button.stateToSkinFunction = skinSelector.updateValue;
            setBaseButtonStyles( button );

            var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            iconSelector.setValueTypeHandler( SubTexture, textureValueTypeHandler );
            iconSelector.defaultValue = mPickerListButtonIcon;
            iconSelector.setValueForState( mPickerListButtonDisabledIcon, Button.STATE_DISABLED );
            iconSelector.displayObjectProperties =
            {
                textureScale: mScale,
                snapToPixels: true
            };
            button.stateToIconFunction = iconSelector.updateValue;

            button.gap = Number.POSITIVE_INFINITY;
            button.minGap = mRegularPaddingSize;
            button.iconPosition = Button.ICON_POSITION_RIGHT;
            button.paddingLeft = mRegularPaddingSize;
        }

        protected function setPickerListListStyles( list:List ):void {
            setScrollerStyles( list );

            list.verticalScrollPolicy = List.SCROLL_POLICY_ON;

            if( DeviceCapabilities.isTablet( Starling.current.nativeStage ) ) {
                list.maxHeight = 500 * mScale;
                list.paddingLeft = 10 * mScale;
                list.paddingRight = 14 * mScale;
                list.paddingBottom = mSmallPaddingSize;
                list.backgroundSkin = new Scale9Image( mPickerListListBackgroundTexture, mScale );
            } else {
                list.paddingTop = list.paddingLeft = 6 * mScale;
                list.paddingRight = 10 * mScale;
                list.paddingBottom = 14 * mScale;
                list.backgroundSkin = new Scale9Image( mBackgroundPopUpTexture, mScale );
            }

            list.customItemRendererStyleName = THEME_STYLE_NAME_DROP_DOWN_LIST_ITEM_RENDERER;
        }

        protected function setPickerListItemRendererStyles( renderer:BaseDefaultItemRenderer ):void {
            setBaseDropDownListItemRendererStyles( renderer );
        }

        /**
         * Spinner list
         */

        protected function setSpinnerListStyles( list:SpinnerList ):void {
            list.verticalScrollPolicy = List.SCROLL_POLICY_ON;
            list.paddingTop = list.paddingLeft = 6 * mScale;
            list.paddingRight = 10 * mScale;
            list.paddingBottom = 14 * mScale;
            list.backgroundSkin = new Scale9Image( mBackgroundPopUpTexture, mScale );
            list.selectionOverlaySkin = new Scale9Image( mSpinnerListSelectionOverlayTexture, mScale );
            list.customItemRendererStyleName = THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER;
        }

        protected function setSpinnerListItemRendererStyles( renderer:BaseDefaultItemRenderer ):void {
            /* Style is the same as for the PickerList items, except that the
             * SpinnerList's item does not have a skin for the selected state */
            setBaseDropDownListItemRendererStyles( renderer ).defaultSelectedValue = null;
        }

        /**
         * Scroll container
         */

        protected function setScrollContainerStyles( container:ScrollContainer ):void {
            setScrollerStyles( container );
        }

        protected function setToolbarScrollContainerStyles( container:ScrollContainer ):void {
            this.setScrollerStyles( container );
            if( !container.layout ) {
                var layout:HorizontalLayout = new HorizontalLayout();
                layout.padding = mRegularPaddingSize;
                layout.gap = mRegularPaddingSize;
                container.layout = layout;
            }
            container.minWidth = mControlSize;
            container.minHeight = mControlSize;

            container.backgroundSkin = new Quad( 10, 10, COLOR_BACKGROUND_LIGHT );
        }

        /**
         * Scroll text
         */

        protected function setScrollTextStyles( text:ScrollText ):void {
            this.setScrollerStyles( text );

            text.textFormat = mScrollTextTextFormat;
            text.disabledTextFormat = mScrollTextDisabledTextFormat;
            text.padding = mRegularPaddingSize;
            text.paddingRight = mRegularPaddingSize + mSmallPaddingSize;
        }

        /**
         * Scroll bar
         */

        protected function setSimpleScrollBarStyles( scrollBar:SimpleScrollBar ):void {
            if( scrollBar.direction == SimpleScrollBar.DIRECTION_HORIZONTAL ) {
                scrollBar.customThumbName = THEME_STYLE_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB;
            } else {
                scrollBar.customThumbName = THEME_STYLE_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB;
            }
            const padding:int = mSmallPaddingSize * 0.5;
            scrollBar.paddingTop = padding;
            scrollBar.paddingRight = padding;
            scrollBar.paddingBottom = padding;
        }

        protected function setHorizontalSimpleScrollBarThumbStyles( thumb:Button ):void {
            var defaultSkin:Scale3Image = new Scale3Image( mHorizontalScrollBarTexture, mScale );
            defaultSkin.width = 52 * mScale;
            thumb.defaultSkin = defaultSkin;
            thumb.hasLabelTextRenderer = false;
        }

        protected function setVerticalSimpleScrollBarThumbStyles( thumb:Button ):void {
            var defaultSkin:Scale3Image = new Scale3Image( mVerticalScrollBarTexture, mScale );
            defaultSkin.height = 52 * mScale;
            thumb.defaultSkin = defaultSkin;
            thumb.hasLabelTextRenderer = false;
        }

        /**
         * Page indicator
         */

        protected function setPageIndicatorStyles( pageIndicator:PageIndicator ):void {
            pageIndicator.normalSymbolFactory = pageIndicatorNormalSymbolFactory;
            pageIndicator.selectedSymbolFactory = pageIndicatorSelectedSymbolFactory;
            pageIndicator.gap = mRegularPaddingSize;
            pageIndicator.padding = mRegularPaddingSize;
            pageIndicator.minTouchWidth = mRegularPaddingSize * 2;
            pageIndicator.minTouchHeight = mRegularPaddingSize * 2;
        }

        /**
         * Panel
         */

        protected function setPanelStyles( panel:Panel ):void {
            setScrollerStyles( panel );

            panel.backgroundSkin = new Quad( 1, 1, COLOR_BACKGROUND_LIGHT );

            panel.paddingTop = mSmallPaddingSize;
            panel.paddingRight = mSmallPaddingSize;
            panel.paddingBottom = mSmallPaddingSize;
            panel.paddingLeft = mSmallPaddingSize;
        }

        protected function setHeaderWithoutBackgroundStyles( header:Header ):void {
            header.gap = mRegularPaddingSize;
            header.padding = mRegularPaddingSize;
            header.titleGap = mRegularPaddingSize;
            header.minHeight = mHeaderSize;
            header.titleProperties.elementFormat = mDarkUILargeElementFormat;
        }

        /**
         * Panel Screen
         */

        protected function setPanelScreenHeaderStyles( header:Header ):void {
            setHeaderStyles( header );
            header.useExtraPaddingForOSStatusBar = true;
        }

        /**
         * Header
         */

        protected function setHeaderStyles( header:Header ):void {
            setHeaderWithoutBackgroundStyles( header );

            var backgroundSkin:Scale9Image = new Scale9Image( mHeaderBackgroundTexture, mScale );
            backgroundSkin.width = 80 * mScale;
            backgroundSkin.height = mHeaderSize;
            header.backgroundSkin = backgroundSkin;
            header.titleProperties.elementFormat = mDarkUILargeElementFormat;
        }

        /**
         * Tab Bar
         */

        protected function setTabBarStyles( tabBar:TabBar ):void {
            tabBar.distributeTabSizes = true;
        }

        protected function setTabStyles( tab:ToggleButton ):void {
            /* No skin for disabled state (just different label) */

            tab.defaultSkin = tab.upSkin = new Scale9Image( mTabUpTexture, mScale );
            tab.downSkin = new Scale9Image( mTabDownTexture, mScale );
            tab.defaultSelectedSkin = new Scale9Image( mTabSelectedTexture, mScale );
            tab.selectedDisabledSkin = new Scale9Image( mTabSelectedDisabledTexture, mScale );
            tab.selectedDownSkin = new Scale9Image( mTabSelectedDownTexture, mScale );

            tab.defaultLabelProperties.elementFormat = mDarkUIElementFormat;
            tab.defaultSelectedLabelProperties.elementFormat = mBlueUIElementFormat;
            tab.disabledLabelProperties.elementFormat = mDarkUIDisabledElementFormat;
            tab.selectedDisabledLabelProperties.elementFormat = mBlueUIDisabledElementFormat;

            tab.paddingLeft = tab.paddingRight = mRegularPaddingSize;
            tab.minWidth = tab.minHeight = mWideControlSize;
        }

        /**
         * Slider
         */

        protected function setSliderStyles( slider:Slider ):void {
            slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_MIN_MAX;
            if( slider.direction == Slider.DIRECTION_VERTICAL ) {
                slider.customThumbStyleName = THEME_STYLE_NAME_VERTICAL_SLIDER_THUMB;
                slider.customMinimumTrackStyleName = THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK;
                slider.customMaximumTrackStyleName = THEME_STYLE_NAME_VERTICAL_SLIDER_MAXIMUM_TRACK;
            } else {
                slider.customThumbStyleName = THEME_STYLE_NAME_HORIZONTAL_SLIDER_THUMB;
                slider.customMinimumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK;
                slider.customMaximumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_SLIDER_MAXIMUM_TRACK;
            }
        }

        protected function setHorizontalSliderMinimumTrackStyles( track:Button ):void {
            var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            skinSelector.defaultValue = mSliderHorizontalMinimalTrackTexture;
            skinSelector.setValueForState( mSliderHorizontalDisabledTrackTexture, Button.STATE_DISABLED, false );
            skinSelector.displayObjectProperties =
            {
                textureScale: mScale
            };
            skinSelector.displayObjectProperties.width = mTrackSize;
            skinSelector.displayObjectProperties.height = mTrackSize;
            track.stateToSkinFunction = skinSelector.updateValue;
            track.hasLabelTextRenderer = false;
        }

        protected function setHorizontalSliderMaximumTrackStyles( track:Button ):void {
            var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            skinSelector.defaultValue = mSliderHorizontalMaximumTrackTexture;
            skinSelector.setValueForState( mSliderHorizontalDisabledTrackTexture, Button.STATE_DISABLED, false );
            skinSelector.displayObjectProperties =
            {
                textureScale: mScale
            };
            skinSelector.displayObjectProperties.width = mTrackSize;
            skinSelector.displayObjectProperties.height = mTrackSize;
            track.stateToSkinFunction = skinSelector.updateValue;
            track.hasLabelTextRenderer = false;
        }

        protected function setVerticalSliderMinimumTrackStyles( track:Button ):void {
            var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            skinSelector.defaultValue = mSliderVerticalMinimumTrackTexture;
            skinSelector.setValueForState( mSliderVerticalDisabledTrackTexture, Button.STATE_DISABLED, false );
            skinSelector.displayObjectProperties =
            {
                textureScale: mScale
            };
            skinSelector.displayObjectProperties.width = mTrackSize;
            skinSelector.displayObjectProperties.height = mTrackSize;
            track.stateToSkinFunction = skinSelector.updateValue;
            track.hasLabelTextRenderer = false;
        }

        protected function setVerticalSliderMaximumTrackStyles( track:Button ):void {
            var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            skinSelector.defaultValue = mSliderVerticalMaximumTrackTexture;
            skinSelector.setValueForState( mSliderVerticalDisabledTrackTexture, Button.STATE_DISABLED, false );
            skinSelector.displayObjectProperties =
            {
                textureScale: mScale
            };
            skinSelector.displayObjectProperties.width = mTrackSize;
            skinSelector.displayObjectProperties.height = mTrackSize;
            track.stateToSkinFunction = skinSelector.updateValue;
            track.hasLabelTextRenderer = false;
        }

        /**
         * Text area
         */

        protected function setTextAreaStyles( textArea:TextArea ):void {
            setScrollerStyles( textArea );

            var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            skinSelector.defaultValue = mTextInputUpTexture;
            skinSelector.setValueForState( mTextInputFocusedTexture, TextInput.STATE_FOCUSED );
            skinSelector.setValueForState( mTextInputDisabledTexture, TextInput.STATE_DISABLED );
            skinSelector.displayObjectProperties =
            {
                width       : mControlSize * 2,
                height      : mControlSize * 2,
                textureScale: mScale
            };
            textArea.stateToSkinFunction = skinSelector.updateValue;

            textArea.padding = mRegularPaddingSize;

            textArea.textEditorProperties.textFormat = mScrollTextTextFormat;
            textArea.textEditorProperties.disabledTextFormat = mScrollTextDisabledTextFormat;
        }

        /**
         * Text input
         */

        protected function setTextInputStyles( input:TextInput ):void {
            var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            skinSelector.defaultValue = mTextInputUpTexture;
            skinSelector.setValueForState( mTextInputFocusedTexture, TextInput.STATE_FOCUSED );
            skinSelector.setValueForState( mTextInputDisabledTexture, TextInput.STATE_DISABLED );
            skinSelector.displayObjectProperties =
            {
                width       : 30 * mScale,
                height      : mControlSize,
                textureScale: mScale
            };
            input.stateToSkinFunction = skinSelector.updateValue;

            input.minWidth = 30 * mScale;
            input.paddingLeft = input.paddingRight = mSmallPaddingSize;

            setBaseTextInputStyles( input );
        }

        protected function setSearchTextInputStyles( input:TextInput ):void {
            var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            skinSelector.defaultValue = mSearchInputUpTexture;
            skinSelector.setValueForState( mSearchInputFocusedTexture, TextInput.STATE_FOCUSED );
            skinSelector.setValueForState( mSearchInputDisabledTexture, TextInput.STATE_DISABLED );
            skinSelector.displayObjectProperties =
            {
                width       : mWideControlSize,
                height      : mControlSize,
                textureScale: mScale
            };
            input.stateToSkinFunction = skinSelector.updateValue;

            input.gap = mSmallPaddingSize;
            input.minWidth = mWideControlSize;
            input.paddingLeft = mRegularPaddingSize;
            input.paddingRight = mSmallPaddingSize * 2.5;

            /* Icon */
            var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            iconSelector.setValueTypeHandler( SubTexture, textureValueTypeHandler );
            iconSelector.defaultValue = mSearchIconTexture;
            iconSelector.displayObjectProperties =
            {
                textureScale: mScale,
                snapToPixels: true
            };
            input.stateToIconFunction = iconSelector.updateValue;

            setBaseTextInputStyles( input );
        }

        /**
         * Callout
         */

        protected function setCalloutStyles( callout:Callout ):void {
            var backgroundSkin:Scale9Image = new Scale9Image( mBackgroundPopUpTexture, mScale );
            backgroundSkin.width = mRegularPaddingSize;
            backgroundSkin.height = mRegularPaddingSize;
            callout.backgroundSkin = backgroundSkin;

            var topArrowSkin:Image = new Image( mCalloutTopArrowTexture );
            topArrowSkin.scaleX = topArrowSkin.scaleY = mScale;
            callout.topArrowSkin = topArrowSkin;
            callout.topArrowGap = -16 * mScale;

            var rightArrowSkin:Image = new Image( mCalloutRightArrowTexture );
            rightArrowSkin.scaleX = rightArrowSkin.scaleY = mScale;
            callout.rightArrowSkin = rightArrowSkin;
            callout.rightArrowGap = -14 * mScale;

            var bottomArrowSkin:Image = new Image( mCalloutBottomArrowTexture );
            bottomArrowSkin.scaleX = bottomArrowSkin.scaleY = mScale;
            callout.bottomArrowSkin = bottomArrowSkin;
            callout.bottomArrowGap = -16 * mScale;

            var leftArrowSkin:Image = new Image( mCalloutLeftArrowTexture );
            leftArrowSkin.scaleX = leftArrowSkin.scaleY = mScale;
            callout.leftArrowSkin = leftArrowSkin;
            callout.leftArrowGap = -14 * mScale;

            callout.padding = mRegularPaddingSize;
        }

        /**
         * Alert
         */

        protected function setAlertStyles( alert:Alert ):void {
            setScrollerStyles( alert );

            alert.backgroundSkin = new Scale9Image( mBackgroundPopUpTexture, mScale );

            alert.paddingTop = 0;
            alert.paddingRight = mRegularPaddingSize;
            alert.paddingBottom = mRegularPaddingSize;
            alert.paddingLeft = mRegularPaddingSize;
            alert.gap = mRegularPaddingSize;
            alert.maxWidth = 720 * mScale;
            alert.maxHeight = 720 * mScale;
        }

        //see Panel section for Header styles

        protected function setAlertButtonGroupStyles( group:ButtonGroup ):void {
            group.direction = ButtonGroup.DIRECTION_HORIZONTAL;
            group.horizontalAlign = ButtonGroup.HORIZONTAL_ALIGN_CENTER;
            group.verticalAlign = ButtonGroup.VERTICAL_ALIGN_JUSTIFY;
            group.distributeButtonSizes = false;
            group.gap = mRegularPaddingSize;
            group.padding = mRegularPaddingSize;
            group.paddingTop = 0;
            group.customLastButtonName = THEME_STYLE_NAME_ALERT_BUTTON_GROUP_LAST_BUTTON;
            group.customButtonStyleName = THEME_STYLE_NAME_ALERT_BUTTON_GROUP_BUTTON;
        }

        protected function setAlertButtonGroupButtonStyles( button:Button ):void {
            setButtonStyles( button );
            button.minWidth = mControlSize * 2;
        }

        protected function setAlertButtonGroupLastButtonStyles( button:Button ):void {
            setCallToActionButtonStyles( button );
            button.minWidth = mControlSize * 2;
        }

        protected function setAlertMessageTextRendererStyles( renderer:TextBlockTextRenderer ):void {
            renderer.wordWrap = true;
            renderer.elementFormat = mDarkUIElementFormat;
        }

        /**
         * Drawers
         */

        protected function setDrawersStyles( drawers:Drawers ):void {
            var overlaySkin:Quad = new Quad( 10, 10, COLOR_DRAWER_OVERLAY );
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

        protected function setScrollerStyles( scroller:Scroller ):void {
            scroller.verticalScrollBarFactory = scrollBarFactory;
            scroller.horizontalScrollBarFactory = scrollBarFactory;
        }

        protected function setBaseTextInputStyles( input:TextInput ):void {
            input.textEditorProperties.fontFamily = "Helvetica";
            input.textEditorProperties.fontSize = mRegularFontSize;
            input.textEditorProperties.color = COLOR_TEXT_DARK;
            input.textEditorProperties.disabledColor = COLOR_TEXT_DARK_DISABLED;

            input.promptProperties.elementFormat = mDarkUIElementFormat;
            input.promptProperties.disabledElementFormat = mDarkUIDisabledElementFormat;

            input.minHeight = mControlSize;
            input.paddingTop = mSmallPaddingSize * 0.5;
        }

        protected function setBaseButtonSize( skinSelector:SmartDisplayObjectStateValueSelector ):void {
            skinSelector.displayObjectProperties =
            {
                width       : mControlSize,
                height      : mControlSize,
                textureScale: mScale
            };
        }

        protected function setBaseButtonStyles( button:Button ):void {
            button.defaultLabelProperties.elementFormat = mDarkUIElementFormat;
            button.disabledLabelProperties.elementFormat = mDarkUIDisabledElementFormat;
            button.minHeight = mControlSize;
            button.paddingLeft = button.paddingRight = mRegularPaddingSize;
            button.paddingBottom = button.paddingTop = 30 * mScale;
        }

        protected function setBaseItemRendererStyles( renderer:BaseDefaultItemRenderer ):void {
            renderer.downLabelProperties.elementFormat = mDarkUILargeElementFormat;
            renderer.defaultLabelProperties.elementFormat = mDarkUILargeElementFormat;
            renderer.disabledLabelProperties.elementFormat = mDarkUILargeDisabledElementFormat;
            renderer.defaultSelectedLabelProperties.elementFormat = mDarkUILargeElementFormat;

            renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
            renderer.paddingTop = mRegularPaddingSize;
            renderer.paddingBottom = mRegularPaddingSize;
            renderer.paddingLeft = mRegularPaddingSize;
            renderer.paddingRight = mRegularPaddingSize;
            renderer.gap = mRegularPaddingSize;
            renderer.minGap = mRegularPaddingSize;
            renderer.iconPosition = Button.ICON_POSITION_LEFT;
            renderer.accessoryGap = Number.POSITIVE_INFINITY;
            renderer.minAccessoryGap = mRegularPaddingSize;
            renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
            renderer.minWidth = mControlSize;
            renderer.minHeight = mControlSize;
            renderer.minTouchWidth = mControlSize;
            renderer.minTouchHeight = mControlSize;

            renderer.accessoryLoaderFactory = imageLoaderFactory;
            renderer.iconLoaderFactory = imageLoaderFactory;
        }

        protected function setBaseDropDownListItemRendererStyles( renderer:BaseDefaultItemRenderer ):SmartDisplayObjectStateValueSelector {
            var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
            skinSelector.defaultValue = mPickerListItemRendererUpTexture;
            skinSelector.defaultSelectedValue = mPickerListItemRendererSelectedTexture;
            skinSelector.setValueForState( mPickerListItemRendererDownTexture, Button.STATE_DOWN );
            skinSelector.displayObjectProperties =
            {
                width       : mControlSize,
                height      : mControlSize,
                textureScale: mScale
            };
            renderer.stateToSkinFunction = skinSelector.updateValue;

            renderer.defaultLabelProperties.elementFormat = mDarkUIElementFormat;
            renderer.downLabelProperties.elementFormat = mDarkUIElementFormat;
            renderer.disabledLabelProperties.elementFormat = mDarkUIElementFormat;

            renderer.gap = mRegularPaddingSize;
            renderer.minWidth = mControlSize * 2;
            renderer.itemHasIcon = false;
            renderer.iconPosition = Button.ICON_POSITION_LEFT;
            renderer.accessoryGap = Number.POSITIVE_INFINITY;
            renderer.minAccessoryGap = mRegularPaddingSize;
            renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_CENTER;
            renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
            return skinSelector;
        }

        protected function setBaseToggleSwitchSize( skinSelector:SmartDisplayObjectStateValueSelector ):void {
            skinSelector.displayObjectProperties =
            {
                width       : 140 * mScale,
                height      : mControlSize,
                textureScale: mScale
            };
        }

        /**
         *
         *
         * Font renderers / factories
         *
         *
         */

        protected function textRendererFactory():TextBlockTextRenderer {
            const renderer:TextBlockTextRenderer = new TextBlockTextRenderer();
            renderer.elementFormat = mLightUIElementFormat;
            return renderer;
        }

        protected static function popUpOverlayFactory():DisplayObject {
            var quad:Quad = new Quad( 10, 10, COLOR_MODAL_OVERLAY );
            quad.alpha = ALPHA_MODAL_OVERLAY;
            return quad;
        }

        protected function imageLoaderFactory():ImageLoader {
            var image:ImageLoader = new ImageLoader();
            image.textureScale = mScale;
            return image;
        }

        protected static function scrollBarFactory():SimpleScrollBar {
            return new SimpleScrollBar();
        }

        protected static function stepperTextEditorFactory():TextBlockTextEditor {
            /* We are only using this text editor in the NumericStepper because
             * isEditable is false on the TextInput. this text editor is not
             * suitable for mobile use if the TextInput needs to be editable
             * because it can't use the soft keyboard or other mobile-friendly UI */
            return new TextBlockTextEditor();
        }

        protected function pageIndicatorNormalSymbolFactory():DisplayObject {
            var symbol:ImageLoader = new ImageLoader();
            symbol.source = mPageIndicatorNormalTexture;
            symbol.textureScale = mScale;
            return symbol;
        }

        protected function pageIndicatorSelectedSymbolFactory():DisplayObject {
            var symbol:ImageLoader = new ImageLoader();
            symbol.source = mPageIndicatorSelectedTexture;
            symbol.textureScale = mScale;
            return symbol;
        }

        /**
         *
         *
         * Helpers
         *
         *
         */

        private function textureValueTypeHandler( value:Texture, oldDisplayObject:DisplayObject = null ):DisplayObject {
            var displayObject:ImageLoader = oldDisplayObject as ImageLoader;
            if( !displayObject ) {
                displayObject = new ImageLoader();
            }
            displayObject.source = value;
            return displayObject;
        }

        /**
         * Disposes the atlas before calling super.dispose()
         */
        override public function dispose():void {
            if( mAtlas ) {
                mAtlas.dispose();
                mAtlas = null;
            }
            super.dispose();
        }

        /**
         *
         *
         * Getters / Setters
         *
         *
         */

        /**
         * The original screen density used for scaling.
         */
        public function get originalDPI():int {
            return mOriginalDPI;
        }

        /**
         * Indicates if the theme scales skins to match the screen density of the device.
         */
        public function get scaleToDPI():Boolean {
            return mScaleToDPI;
        }

    }

}
