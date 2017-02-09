/*
Copyright 2012-2017 Bowler Hat LLC, Marcel Piestansky

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
	import feathers.controls.ButtonState;
	import feathers.controls.Callout;
	import feathers.controls.Check;
	import feathers.controls.DateTimeSpinner;
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
	import feathers.controls.ScrollPolicy;
	import feathers.controls.ScrollText;
	import feathers.controls.Scroller;
	import feathers.controls.SimpleScrollBar;
	import feathers.controls.Slider;
	import feathers.controls.SpinnerList;
	import feathers.controls.StepperButtonLayoutMode;
	import feathers.controls.TabBar;
	import feathers.controls.TextArea;
	import feathers.controls.TextCallout;
	import feathers.controls.TextInput;
	import feathers.controls.TextInputState;
	import feathers.controls.ToggleButton;
	import feathers.controls.ToggleSwitch;
	import feathers.controls.TrackLayoutMode;
	import feathers.controls.popups.BottomDrawerPopUpContentManager;
	import feathers.controls.popups.CalloutPopUpContentManager;
	import feathers.controls.renderers.BaseDefaultItemRenderer;
	import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.text.ITextEditorViewPort;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.controls.text.TextBlockTextEditor;
	import feathers.controls.text.TextBlockTextRenderer;
	import feathers.controls.text.TextFieldTextEditorViewPort;
	import feathers.core.FeathersControl;
	import feathers.core.ITextEditor;
	import feathers.core.ITextRenderer;
	import feathers.core.PopUpManager;
	import feathers.layout.Direction;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.RelativePosition;
	import feathers.layout.VerticalAlign;
	import feathers.layout.VerticalLayout;
	import feathers.skins.ImageSkin;
	import feathers.system.DeviceCapabilities;

	import flash.geom.Rectangle;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.text.TextFormat;
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
		 * The stack of fonts to use for controls that don't use embedded fonts.
		 */
		public static const FONT_NAME_STACK:String = "Source Sans Pro,Helvetica,_sans";

		protected static const COLOR_TEXT_DARK:uint = 0x454545;
		protected static const COLOR_TEXT_LIGHT:uint = 0xFFFFFF;
		protected static const COLOR_TEXT_SELECTED:uint = 0x0083E8;
		protected static const COLOR_TEXT_DARK_DISABLED:uint = 0x848585;
		protected static const COLOR_TEXT_SELECTED_DISABLED:uint = 0xC6DFF3;
		protected static const COLOR_TEXT_ACTION_DISABLED:uint = 0xC6DFF3;
		protected static const COLOR_TEXT_DANGER_DISABLED:uint = 0xF7B4AF;
		protected static const COLOR_BACKGROUND_LIGHT:uint = 0xDFE2E2;
		protected static const COLOR_SPINNER_LIST_BACKGROUND:uint = 0xE5E9E8;
		protected static const COLOR_MODAL_OVERLAY:uint = 0xDFE2E2;
		protected static const ALPHA_MODAL_OVERLAY:Number = 0.8;
		protected static const COLOR_DRAWER_OVERLAY:uint = 0x454545;
		protected static const ALPHA_DRAWER_OVERLAY:Number = 0.8;
		protected static const COLOR_DRAWERS_DIVIDER:uint = 0x9DACA9;

		protected static const BUTTON_SCALE9_GRID:Rectangle = new Rectangle(7, 7, 1, 1);
		protected static const BACK_BUTTON_SCALE9_GRID:Rectangle = new Rectangle(26, 5, 10, 40);
		protected static const FORWARD_BUTTON_SCALE9_GRID:Rectangle = new Rectangle(5, 5, 10, 10);
		protected static const TEXT_INPUT_SCALE9_GRID:Rectangle = new Rectangle(7, 7, 1, 1);
		protected static const HORIZONTAL_MINIMUM_TRACK_SCALE9_GRID:Rectangle = new Rectangle(5, 0, 1, 13);
		protected static const HORIZONTAL_MAXIMUM_TRACK_SCALE9_GRID:Rectangle = new Rectangle(0, 0, 1, 13);
		protected static const VERTICAL_MINIMUM_TRACK_SCALE9_GRID:Rectangle = new Rectangle(0, 0, 13, 1);
		protected static const VERTICAL_MAXIMUM_TRACK_SCALE9_GRID:Rectangle = new Rectangle(0, 5, 13, 1);
		protected static const BAR_HORIZONTAL_SCALE9_GRID:Rectangle = new Rectangle(8, 8, 1, 1);
		protected static const BAR_VERTICAL_SCALE9_GRID:Rectangle = new Rectangle(8, 8, 1, 1);
		protected static const HEADER_BACKGROUND_SCALE9_GRID:Rectangle = new Rectangle(3, 3, 10, 56);
		protected static const TAB_SCALE9_GRID:Rectangle = new Rectangle(3, 3, 5, 5);
		protected static const SEARCH_INPUT_SCALE9_GRID:Rectangle = new Rectangle(25, 25, 10, 1);
		protected static const BACKGROUND_POPUP_SCALE9_GRID:Rectangle = new Rectangle(5, 5, 10, 10);
		protected static const POP_UP_DRAWER_BACKGROUND_SCALE9_GRID:Rectangle = new Rectangle(1, 3, 3, 4);
		protected static const LIST_ITEM_SCALE9_GRID:Rectangle = new Rectangle(2, 2, 1, 6);
		protected static const GROUPED_LIST_HEADER_OR_FOOTER_SCALE9_GRID:Rectangle = new Rectangle(2, 2, 1, 6);
		protected static const SPINNER_LIST_OVERLAY_SCALE9_GRID:Rectangle = new Rectangle(2, 5, 1, 1);
		protected static const HORIZONTAL_SIMPLE_SCROLL_BAR_SCALE9_GRID:Rectangle = new Rectangle(5, 0, 3, 6);
		protected static const VERTICAL_SIMPLE_SCROLL_BAR_SCALE9_GRID:Rectangle = new Rectangle(0, 5, 6, 3);

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
		protected static const THEME_STYLE_NAME_DATE_TIME_SPINNER_LIST_ITEM_RENDERER:String = "topcoat-light-mobile-date-time-spinner-list-item-renderer";
		protected static const THEME_STYLE_NAME_POP_UP_DRAWER:String = "topcoat-light-mobile-pop-up-drawer";
		protected static const THEME_STYLE_NAME_POP_UP_DRAWER_HEADER:String = "topcoat-light-mobile-pop-up-drawer-header";
		protected static const THEME_STYLE_NAME_TABLET_PICKER_LIST_ITEM_RENDERER:String = "topcoat-light-mobile-tablet-picker-list-item-renderer";

		public function BaseTopcoatLightMobileTheme()
		{
			super();
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
		protected var shadowSize:int;
		protected var calloutBackgroundMinSize:int;
		protected var calloutVerticalArrowGap:int;
		protected var calloutHorizontalArrowGap:int;

		protected var smallFontSize:int;
		protected var regularFontSize:int;
		protected var largeFontSize:int;

		protected var darkFontStyles:TextFormat;
		protected var lightFontStyles:TextFormat;
		protected var selectedFontStyles:TextFormat;
		protected var darkDisabledFontStyles:TextFormat;
		protected var selectedDisabledFontStyles:TextFormat;
		protected var actionDisabledFontStyles:TextFormat;
		protected var dangerDisabledFontStyles:TextFormat;
		protected var darkCenteredFontStyles:TextFormat;
		protected var darkCenteredDisabledFontStyles:TextFormat;
		protected var smallDarkFontStyles:TextFormat;
		protected var smallSelectedFontStyles:TextFormat;
		protected var smallDarkDisabledFontStyles:TextFormat;
		protected var largeDarkFontStyles:TextFormat;
		protected var largeDarkDisabledFontStyles:TextFormat;
		protected var darkScrollTextFontStyles:TextFormat;
		protected var darkScrollTextDisabledFontStyles:TextFormat;

		/**
		 * The texture atlas that contains skins for this theme. This base class
		 * does not initialize this member variable. Subclasses are expected to
		 * load the assets somehow and set the <code>atlas</code> member
		 * variable before calling <code>initialize()</code>.
		 */
		protected var atlas:TextureAtlas;

		protected var buttonUpTexture:Texture;
		protected var buttonDownTexture:Texture;
		protected var buttonDisabledTexture:Texture;
		protected var quietButtonDownTexture:Texture;
		protected var backButtonUpTexture:Texture;
		protected var backButtonDownTexture:Texture;
		protected var backButtonDisabledTexture:Texture;
		protected var forwardButtonUpTexture:Texture;
		protected var forwardButtonDownTexture:Texture;
		protected var forwardButtonDisabledTexture:Texture;
		protected var dangerButtonUpTexture:Texture;
		protected var dangerButtonDownTexture:Texture;
		protected var dangerButtonDisabledTexture:Texture;
		protected var callToActionButtonUpTexture:Texture;
		protected var callToActionButtonDownTexture:Texture;
		protected var callToActionButtonDisabledTexture:Texture;
		protected var toggleButtonSelectedUpTexture:Texture;
		protected var toggleButtonSelectedDisabledTexture:Texture;
		protected var toggleSwitchOnTrackTexture:Texture;
		protected var toggleSwitchOnTrackDisabledTexture:Texture;
		protected var toggleSwitchOffTrackTexture:Texture;
		protected var toggleSwitchOffTrackDisabledTexture:Texture;
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
		protected var horizontalProgressBarFillTexture:Texture;
		protected var horizontalProgressBarFillDisabledTexture:Texture;
		protected var horizontalProgressBarBackgroundTexture:Texture;
		protected var horizontalProgressBarBackgroundDisabledTexture:Texture;
		protected var verticalProgressBarFillTexture:Texture;
		protected var verticalProgressBarFillDisabledTexture:Texture;
		protected var verticalProgressBarBackgroundTexture:Texture;
		protected var verticalProgressBarBackgroundDisabledTexture:Texture;
		protected var headerBackgroundSkinTexture:Texture;
		protected var verticalSimpleScrollBarThumbTexture:Texture;
		protected var horizontalSimpleScrollBarThumbTexture:Texture;
		protected var tabUpTexture:Texture;
		protected var tabDownTexture:Texture;
		protected var tabSelectedUpTexture:Texture;
		protected var tabSelectedDisabledTexture:Texture;
		protected var horizontalSliderMinimumTrackTexture:Texture;
		protected var horizontalSliderMinimumTrackDisabledTexture:Texture;
		protected var horizontalSliderMaximumTrackTexture:Texture;
		protected var horizontalSliderMaximumTrackDisabledTexture:Texture;
		protected var verticalSliderMinimumTrackTexture:Texture;
		protected var verticalSliderMinimumTrackDisabledTexture:Texture;
		protected var verticalSliderMaximumTrackTexture:Texture;
		protected var verticalSliderMaximumTrackDisabledTexture:Texture;
		protected var textInputBackgroundEnabledTexture:Texture;
		protected var textInputBackgroundFocusedTexture:Texture;
		protected var textInputBackgroundErrorTexture:Texture;
		protected var textInputBackgroundDisabledTexture:Texture;
		protected var searchTextInputBackgroundEnabledTexture:Texture;
		protected var searchTextInputBackgroundFocusedTexture:Texture;
		protected var searchTextInputBackgroundDisabledTexture:Texture;
		protected var searchIconTexture:Texture;
		protected var popUpBackgroundTexture:Texture;
		protected var calloutTopArrowTexture:Texture;
		protected var calloutRightArrowTexture:Texture;
		protected var calloutBottomArrowTexture:Texture;
		protected var calloutLeftArrowTexture:Texture;
		protected var itemRendererUpTexture:Texture;
		protected var itemRendererDownTexture:Texture;
		protected var itemRendererSelectedTexture:Texture;
		protected var firstItemRendererUpTexture:Texture;
		protected var groupedListHeaderTexture:Texture;
		protected var groupedListFooterTexture:Texture;
		protected var pickerListButtonIcon:Texture;
		protected var pickerListButtonDisabledIcon:Texture;
		protected var popUpDrawerBackgroundTexture:Texture;
		protected var spinnerListSelectionOverlayTexture:Texture;
		protected var pageIndicatorNormalTexture:Texture;
		protected var pageIndicatorSelectedTexture:Texture;

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
			this.initializeDimensions();
			this.initializeFonts();
			this.initializeTextures();
			this.initializeGlobals();
			this.initializeStage();
			this.initializeStyleProviders();
		}

		protected function initializeStage():void
		{
			this.starling.stage.color = COLOR_BACKGROUND_LIGHT;
			this.starling.nativeStage.color = COLOR_BACKGROUND_LIGHT;
		}

		protected function initializeDimensions():void
		{
			this.gridSize = 70;
			this.gutterSize = 20;
			this.smallGutterSize = 10;
			this.extraSmallGutterSize = 5;
			this.borderSize = 1;
			this.controlSize = 50;
			this.smallControlSize = 16;
			this.wideControlSize = 230;
			this.popUpFillSize = 300;
			this.thumbSize = 34;
			this.calloutBackgroundMinSize = 53;
			this.calloutVerticalArrowGap = -8;
			this.calloutHorizontalArrowGap = -7;
			this.shadowSize = 2;
		}

		protected function initializeTextures():void
		{
			this.popUpBackgroundTexture = this.atlas.getTexture("background-popup-skin0000");
			this.popUpDrawerBackgroundTexture = this.atlas.getTexture("pop-up-drawer-background-skin0000");

			this.buttonUpTexture = this.atlas.getTexture("button-up-skin0000");
			this.buttonDownTexture = this.atlas.getTexture("button-down-skin0000");
			this.buttonDisabledTexture = this.atlas.getTexture("button-disabled-skin0000");
			this.quietButtonDownTexture = this.atlas.getTexture("button-down-skin0000");
			this.dangerButtonUpTexture = this.atlas.getTexture("button-danger-up-skin0000");
			this.dangerButtonDownTexture = this.atlas.getTexture("button-danger-down-skin0000");
			this.dangerButtonDisabledTexture = this.atlas.getTexture("button-danger-disabled-skin0000");
			this.callToActionButtonUpTexture = this.atlas.getTexture("button-call-to-action-up-skin0000");
			this.callToActionButtonDownTexture = this.atlas.getTexture("button-call-to-action-down-skin0000");
			this.callToActionButtonDisabledTexture = this.atlas.getTexture("button-call-to-action-disabled-skin0000");
			this.backButtonUpTexture = this.atlas.getTexture("button-back-up-skin0000");
			this.backButtonDownTexture = this.atlas.getTexture("button-back-down-skin0000");
			this.backButtonDisabledTexture = this.atlas.getTexture("button-back-disabled-skin0000");
			this.forwardButtonUpTexture = this.atlas.getTexture("button-forward-up-skin0000");
			this.forwardButtonDownTexture = this.atlas.getTexture("button-forward-down-skin0000");
			this.forwardButtonDisabledTexture = this.atlas.getTexture("button-forward-disabled-skin0000");
			this.toggleButtonSelectedUpTexture = this.atlas.getTexture("toggle-button-selected-up-skin0000");
			this.toggleButtonSelectedDisabledTexture = this.atlas.getTexture("toggle-button-selected-disabled-skin0000");
			
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

			this.headerBackgroundSkinTexture = this.atlas.getTexture("header-background-skin0000");

			this.itemRendererUpTexture = this.atlas.getTexture("list-item-up-skin0000");
			this.itemRendererDownTexture = this.atlas.getTexture("list-item-down-skin0000");
			this.itemRendererSelectedTexture = this.atlas.getTexture("list-item-selected-skin0000");
			this.firstItemRendererUpTexture = this.atlas.getTexture("list-first-item-up-skin0000");
			this.groupedListHeaderTexture = this.atlas.getTexture("grouped-list-header-skin0000");
			this.groupedListFooterTexture = this.atlas.getTexture("grouped-list-footer-skin0000");

			this.pageIndicatorNormalTexture = this.atlas.getTexture("page-indicator-normal-skin0000");
			this.pageIndicatorSelectedTexture = this.atlas.getTexture("page-indicator-selected-skin0000");

			this.pickerListButtonIcon = this.atlas.getTexture("picker-list-button-icon0000");
			this.pickerListButtonDisabledIcon = this.atlas.getTexture("picker-list-button-disabled-icon0000");
			
			this.horizontalProgressBarFillTexture = this.atlas.getTexture("progress-bar-horizontal-fill-skin0000");
			this.horizontalProgressBarFillDisabledTexture = this.atlas.getTexture("progress-bar-horizontal-fill-disabled-skin0000");
			this.horizontalProgressBarBackgroundTexture = this.atlas.getTexture("progress-bar-horizontal-background-skin0000");
			this.horizontalProgressBarBackgroundDisabledTexture = this.atlas.getTexture("progress-bar-horizontal-background-disabled-skin0000");
			this.verticalProgressBarFillTexture = this.atlas.getTexture("progress-bar-vertical-fill-skin0000");
			this.verticalProgressBarFillDisabledTexture = this.atlas.getTexture("progress-bar-vertical-fill-disabled-skin0000");
			this.verticalProgressBarBackgroundTexture = this.atlas.getTexture("progress-bar-vertical-background-skin0000");
			this.verticalProgressBarBackgroundDisabledTexture = this.atlas.getTexture("progress-bar-vertical-background-disabled-skin0000");

			this.radioUpIconTexture = this.atlas.getTexture("radio-up-icon0000");
			this.radioDownIconTexture = this.atlas.getTexture("radio-down-icon0000");
			this.radioDisabledIconTexture = this.atlas.getTexture("radio-disabled-icon0000");
			this.radioSelectedUpIconTexture = this.atlas.getTexture("radio-selected-up-icon0000");
			this.radioSelectedDownIconTexture = this.atlas.getTexture("radio-selected-down-icon0000");
			this.radioSelectedDisabledIconTexture = this.atlas.getTexture("radio-selected-disabled-icon0000");

			this.verticalSimpleScrollBarThumbTexture = this.atlas.getTexture("simple-scroll-bar-vertical-thumb-skin0000");
			this.horizontalSimpleScrollBarThumbTexture = this.atlas.getTexture("simple-scroll-bar-horizontal-thumb-skin0000");

			this.horizontalSliderMinimumTrackTexture = this.atlas.getTexture("slider-horizontal-minimum-track-skin0000");
			this.horizontalSliderMinimumTrackDisabledTexture = this.atlas.getTexture("slider-horizontal-minimum-track-disabled-skin0000");
			this.horizontalSliderMaximumTrackTexture = this.atlas.getTexture("slider-horizontal-maximum-track-skin0000");
			this.horizontalSliderMaximumTrackDisabledTexture = this.atlas.getTexture("slider-horizontal-maximum-track-disabled-skin0000");
			this.verticalSliderMinimumTrackTexture = this.atlas.getTexture("slider-vertical-minimum-track-skin0000");
			this.verticalSliderMinimumTrackDisabledTexture = this.atlas.getTexture("slider-vertical-minimum-track-disabled-skin0000");
			this.verticalSliderMaximumTrackTexture = this.atlas.getTexture("slider-vertical-maximum-track-skin0000");
			this.verticalSliderMaximumTrackDisabledTexture = this.atlas.getTexture("slider-vertical-maximum-track-disabled-skin0000");

			this.spinnerListSelectionOverlayTexture = this.atlas.getTexture("spinner-list-selection-overlay-skin0000");

			this.tabUpTexture = this.atlas.getTexture("tab-up-skin0000");
			this.tabDownTexture = this.atlas.getTexture("tab-down-skin0000");
			this.tabSelectedUpTexture = this.atlas.getTexture("tab-selected-up-skin0000");
			this.tabSelectedDisabledTexture = this.atlas.getTexture("tab-selected-disabled-skin0000");

			this.textInputBackgroundEnabledTexture = this.atlas.getTexture("text-input-up-skin0000");
			this.textInputBackgroundFocusedTexture = this.atlas.getTexture("text-input-focused-skin0000");
			this.textInputBackgroundErrorTexture = this.atlas.getTexture("text-input-error-skin0000");
			this.textInputBackgroundDisabledTexture = this.atlas.getTexture("text-input-disabled-skin0000");
			this.searchTextInputBackgroundEnabledTexture = this.atlas.getTexture("search-input-up-skin0000");
			this.searchTextInputBackgroundFocusedTexture = this.atlas.getTexture("search-input-focused-skin0000");
			this.searchTextInputBackgroundDisabledTexture = this.atlas.getTexture("search-input-disabled-skin0000");
			this.searchIconTexture = this.atlas.getTexture("search-input-icon0000");

			this.toggleSwitchOnTrackTexture = this.atlas.getTexture("toggle-switch-on-track-skin0000");
			this.toggleSwitchOnTrackDisabledTexture = this.atlas.getTexture("toggle-switch-on-track-disabled-skin0000");
			this.toggleSwitchOffTrackTexture = this.atlas.getTexture("toggle-switch-off-track-skin0000");
			this.toggleSwitchOffTrackDisabledTexture = this.atlas.getTexture("toggle-switch-off-track-disabled-skin0000");
		}

		protected function initializeFonts():void
		{
			this.smallFontSize = 14;
			this.regularFontSize = 16;
			this.largeFontSize = 20;

			this.darkFontStyles = new TextFormat(FONT_NAME, this.regularFontSize, COLOR_TEXT_DARK, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.lightFontStyles = new TextFormat(FONT_NAME, this.regularFontSize, COLOR_TEXT_LIGHT, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.selectedFontStyles = new TextFormat(FONT_NAME, this.regularFontSize, COLOR_TEXT_SELECTED, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.darkDisabledFontStyles = new TextFormat(FONT_NAME, this.regularFontSize, COLOR_TEXT_DARK_DISABLED, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.selectedDisabledFontStyles = new TextFormat(FONT_NAME, this.regularFontSize, COLOR_TEXT_SELECTED_DISABLED, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.dangerDisabledFontStyles = new TextFormat(FONT_NAME, this.regularFontSize, COLOR_TEXT_DANGER_DISABLED, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.actionDisabledFontStyles = new TextFormat(FONT_NAME, this.regularFontSize, COLOR_TEXT_ACTION_DISABLED, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.darkCenteredFontStyles = new TextFormat(FONT_NAME, this.regularFontSize, COLOR_TEXT_DARK, HorizontalAlign.CENTER, VerticalAlign.TOP);
			this.darkCenteredDisabledFontStyles = new TextFormat(FONT_NAME, this.regularFontSize, COLOR_TEXT_DARK_DISABLED, HorizontalAlign.CENTER, VerticalAlign.TOP);

			this.smallDarkFontStyles = new TextFormat(FONT_NAME, this.smallFontSize, COLOR_TEXT_DARK, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.smallSelectedFontStyles = new TextFormat(FONT_NAME, this.smallFontSize, COLOR_TEXT_SELECTED, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.smallDarkDisabledFontStyles = new TextFormat(FONT_NAME, this.smallFontSize, COLOR_TEXT_DARK_DISABLED, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.largeDarkFontStyles = new TextFormat(FONT_NAME, this.largeFontSize, COLOR_TEXT_DARK, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.largeDarkDisabledFontStyles = new TextFormat(FONT_NAME, this.largeFontSize, COLOR_TEXT_DARK_DISABLED, HorizontalAlign.LEFT, VerticalAlign.TOP);

			this.darkScrollTextFontStyles = new TextFormat(FONT_NAME_STACK, this.regularFontSize, COLOR_TEXT_DARK, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.darkScrollTextDisabledFontStyles = new TextFormat(FONT_NAME_STACK, this.regularFontSize, COLOR_TEXT_DARK_DISABLED, HorizontalAlign.LEFT, VerticalAlign.TOP);
		}

		protected function initializeGlobals():void
		{
			FeathersControl.defaultTextRendererFactory = textRendererFactory;
			FeathersControl.defaultTextEditorFactory = textEditorFactory;

			PopUpManager.overlayFactory = popUpOverlayFactory;
			Callout.stagePadding = this.smallGutterSize;
		}

		protected function initializeStyleProviders():void
		{
			//alert
			this.getStyleProviderForClass(Alert).defaultStyleFunction = this.setAlertStyles;
			this.getStyleProviderForClass(ButtonGroup).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_BUTTON_GROUP, this.setAlertButtonGroupStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_ALERT_BUTTON_GROUP_BUTTON, this.setAlertButtonGroupButtonStyles);
			this.getStyleProviderForClass(Header).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setHeaderWithoutBackgroundStyles);

			//auto complete
			this.getStyleProviderForClass(AutoComplete).defaultStyleFunction = this.setTextInputStyles;
			this.getStyleProviderForClass(List).setFunctionForStyleName(AutoComplete.DEFAULT_CHILD_STYLE_NAME_LIST, this.setDropDownListStyles);

			//button
			this.getStyleProviderForClass(Button).defaultStyleFunction = this.setButtonStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_DANGER_BUTTON, this.setDangerButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_CALL_TO_ACTION_BUTTON, this.setCallToActionButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON, this.setBackButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_FORWARD_BUTTON, this.setForwardButtonStyles);

			//button group
			this.getStyleProviderForClass(ButtonGroup).defaultStyleFunction = this.setButtonGroupStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ButtonGroup.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setButtonGroupButtonStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ButtonGroup.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setButtonStyles);

			//callout
			this.getStyleProviderForClass(Callout).defaultStyleFunction = this.setCalloutStyles;

			//check
			this.getStyleProviderForClass(Check).defaultStyleFunction = this.setCheckStyles;

			//date time spinner
			this.getStyleProviderForClass(DateTimeSpinner).defaultStyleFunction = this.setDateTimeSpinnerStyles;
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_DATE_TIME_SPINNER_LIST_ITEM_RENDERER, this.setDateTimeSpinnerListItemRendererStyles);

			//drawers
			this.getStyleProviderForClass(Drawers).defaultStyleFunction = this.setDrawersStyles;

			//grouped list
			this.getStyleProviderForClass(GroupedList).defaultStyleFunction = this.setGroupedListStyles;
			this.getStyleProviderForClass(GroupedList).setFunctionForStyleName(GroupedList.ALTERNATE_STYLE_NAME_INSET_GROUPED_LIST, this.setInsetGroupedListStyles);
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).defaultStyleFunction = this.setGroupedListHeaderRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.DEFAULT_CHILD_STYLE_NAME_FOOTER_RENDERER, this.setGroupedListFooterRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_HEADER_RENDERER, this.setGroupedListInsetHeaderRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FOOTER_RENDERER, this.setGroupedListInsetFooterRendererStyles);
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
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_TABLET_PICKER_LIST_ITEM_RENDERER, this.setTabletPickerListItemRendererStyles);

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
			this.getStyleProviderForClass(TextFieldTextEditorViewPort).setFunctionForStyleName(TextArea.DEFAULT_CHILD_STYLE_NAME_TEXT_EDITOR, this.setTextAreaTextEditorStyles);

			//text callout
			this.getStyleProviderForClass(TextCallout).defaultStyleFunction = this.setTextCalloutStyles;

			//toggle button
			this.getStyleProviderForClass(ToggleButton).defaultStyleFunction = this.setToggleButtonStyles;
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);

			//toggle switch
			this.getStyleProviderForClass(ToggleSwitch).defaultStyleFunction = this.setToggleSwitchStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_ON_TRACK, this.setToggleSwitchOnTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_OFF_TRACK, this.setToggleSwitchOffTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setHorizontalThumbStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setHorizontalThumbStyles);
		}

		protected static function textRendererFactory():ITextRenderer
		{
			return new TextBlockTextRenderer();
		}
		
		protected static function textEditorFactory():ITextEditor
		{
			return new StageTextTextEditor();
		}
		
		protected static function textAreaTextEditorFactory():ITextEditorViewPort
		{
			return new TextFieldTextEditorViewPort();
		}

		protected static function popUpOverlayFactory():DisplayObject
		{
			var quad:Quad = new Quad(10, 10, COLOR_MODAL_OVERLAY);
			quad.alpha = ALPHA_MODAL_OVERLAY;
			return quad;
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

		protected function pageIndicatorNormalSymbolFactory():DisplayObject
		{
			var symbol:ImageLoader = new ImageLoader();
			symbol.source = this.pageIndicatorNormalTexture;
			return symbol;
		}

		protected function pageIndicatorSelectedSymbolFactory():DisplayObject
		{
			var symbol:ImageLoader = new ImageLoader();
			symbol.source = this.pageIndicatorSelectedTexture;
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

		protected function setDropDownListStyles(list:List):void
		{
			var backgroundSkin:Quad = new Quad(10, 10, COLOR_SPINNER_LIST_BACKGROUND);
			list.backgroundSkin = backgroundSkin;

			var layout:VerticalLayout = new VerticalLayout();
			layout.horizontalAlign = HorizontalAlign.JUSTIFY;
			layout.maxRowCount = 4;
			list.layout = layout;
		}

	//-------------------------
	// Alert
	//-------------------------

		protected function setAlertStyles(alert:Alert):void
		{
			this.setScrollerStyles(alert);

			var backgroundSkin:Image = new Image(this.popUpBackgroundTexture);
			backgroundSkin.scale9Grid = BACKGROUND_POPUP_SCALE9_GRID;
			alert.backgroundSkin = backgroundSkin;

			alert.fontStyles = this.darkFontStyles;
			alert.disabledFontStyles = this.darkDisabledFontStyles;

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
			group.direction = Direction.HORIZONTAL;
			group.horizontalAlign = HorizontalAlign.CENTER;
			group.verticalAlign = VerticalAlign.JUSTIFY;
			group.distributeButtonSizes = false;
			group.gap = this.gutterSize;
			group.padding = this.gutterSize;
			group.paddingTop = 0;
			group.customLastButtonStyleName = THEME_STYLE_NAME_ALERT_BUTTON_GROUP_LAST_BUTTON;
			group.customButtonStyleName = THEME_STYLE_NAME_ALERT_BUTTON_GROUP_BUTTON;
		}

		protected function setAlertButtonGroupButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonUpTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledTexture);
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				skin.selectedTexture = this.toggleButtonSelectedUpTexture;
				skin.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.toggleButtonSelectedDisabledTexture);
			}
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.controlSize * 2;
			skin.minHeight = this.controlSize;
			button.defaultSkin = skin;

			button.fontStyles = this.darkFontStyles;
			button.disabledFontStyles = this.darkDisabledFontStyles;

			this.setBaseButtonStyles(button);
		}

	//-------------------------
	// Button
	//-------------------------

		protected function setBaseButtonStyles(button:Button):void
		{
			button.paddingBottom = this.smallGutterSize;
			button.paddingTop = this.smallGutterSize;
			button.paddingRight = this.gutterSize;
			button.paddingLeft = this.gutterSize;
			button.gap = this.smallGutterSize;
		}

		protected function setButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonUpTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledTexture);
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				skin.selectedTexture = this.toggleButtonSelectedUpTexture;
				skin.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.toggleButtonSelectedDisabledTexture);
			}
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			button.defaultSkin = skin;

			button.fontStyles = this.darkFontStyles;
			button.disabledFontStyles = this.darkDisabledFontStyles;

			this.setBaseButtonStyles(button);
		}

		protected function setQuietButtonStyles(button:Button):void
		{
			var downSkin:Image = new Image(this.quietButtonDownTexture);
			downSkin.scale9Grid = BUTTON_SCALE9_GRID;
			button.setSkinForState(ButtonState.DOWN, downSkin);

			var defaultSkin:Quad = new Quad(this.controlSize, this.controlSize, 0xff00ff);
			defaultSkin.alpha = 0;
			button.defaultSkin = defaultSkin;

			button.fontStyles = this.darkFontStyles;
			button.disabledFontStyles = this.darkDisabledFontStyles;

			this.setBaseButtonStyles(button);
		}

		protected function setDangerButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.dangerButtonUpTexture);
			skin.setTextureForState(ButtonState.DOWN, this.dangerButtonDownTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.dangerButtonDisabledTexture);
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			button.defaultSkin = skin;

			button.fontStyles = this.lightFontStyles;
			button.disabledFontStyles = this.dangerDisabledFontStyles;

			this.setBaseButtonStyles(button);
		}

		protected function setCallToActionButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.callToActionButtonUpTexture);
			skin.setTextureForState(ButtonState.DOWN, this.callToActionButtonDownTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.callToActionButtonDisabledTexture);
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			button.defaultSkin = skin;

			button.fontStyles = this.lightFontStyles;
			button.disabledFontStyles = this.actionDisabledFontStyles;

			this.setBaseButtonStyles(button);
		}

		protected function setBackButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.backButtonUpTexture);
			skin.setTextureForState(ButtonState.DOWN, this.backButtonDownTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.backButtonDisabledTexture);
			skin.scale9Grid = BACK_BUTTON_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			button.defaultSkin = skin;

			button.fontStyles = this.darkFontStyles;
			button.disabledFontStyles = this.darkDisabledFontStyles;

			this.setBaseButtonStyles(button);

			button.paddingLeft = this.gutterSize + this.smallGutterSize;
		}

		protected function setForwardButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.forwardButtonUpTexture);
			skin.setTextureForState(ButtonState.DOWN, this.forwardButtonDownTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.forwardButtonDisabledTexture);
			skin.scale9Grid = FORWARD_BUTTON_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			button.defaultSkin = skin;

			button.fontStyles = this.darkFontStyles;
			button.disabledFontStyles = this.darkDisabledFontStyles;

			setBaseButtonStyles(button);

			button.paddingRight = this.gutterSize + this.smallGutterSize;
		}

	//-------------------------
	// ButtonGroup
	//-------------------------

		protected function setButtonGroupStyles(group:ButtonGroup):void
		{
			group.gap = this.smallGutterSize;
		}

		protected function setButtonGroupButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonUpTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledTexture);
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				skin.selectedTexture = this.toggleButtonSelectedUpTexture;
				skin.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.toggleButtonSelectedDisabledTexture);
			}
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.wideControlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.wideControlSize;
			skin.minHeight = this.controlSize;
			button.defaultSkin = skin;

			button.fontStyles = this.darkFontStyles;
			button.disabledFontStyles = this.darkDisabledFontStyles;

			this.setBaseButtonStyles(button);
		}

	//-------------------------
	// Callout
	//-------------------------

		protected function setCalloutStyles(callout:Callout):void
		{
			var backgroundSkin:Image = new Image(this.popUpBackgroundTexture);
			backgroundSkin.scale9Grid = BACKGROUND_POPUP_SCALE9_GRID;
			backgroundSkin.width = this.calloutBackgroundMinSize;
			backgroundSkin.height = this.calloutBackgroundMinSize;
			callout.backgroundSkin = backgroundSkin;

			var topArrowSkin:Image = new Image(this.calloutTopArrowTexture);
			callout.topArrowSkin = topArrowSkin;
			callout.topArrowGap = this.calloutVerticalArrowGap;

			var rightArrowSkin:Image = new Image(this.calloutRightArrowTexture);
			callout.rightArrowSkin = rightArrowSkin;
			callout.rightArrowGap = this.calloutHorizontalArrowGap;

			var bottomArrowSkin:Image = new Image(this.calloutBottomArrowTexture);
			callout.bottomArrowSkin = bottomArrowSkin;
			callout.bottomArrowGap = this.calloutVerticalArrowGap;

			var leftArrowSkin:Image = new Image(this.calloutLeftArrowTexture);
			callout.leftArrowSkin = leftArrowSkin;
			callout.leftArrowGap = this.calloutHorizontalArrowGap;

			callout.padding = this.gutterSize;
		}

	//-------------------------
	// Check
	//-------------------------

		protected function setCheckStyles(check:Check):void
		{
			var icon:ImageSkin = new ImageSkin(this.checkUpIconTexture);
			icon.selectedTexture = this.checkSelectedUpIconTexture;
			icon.setTextureForState(ButtonState.DOWN, this.checkDownIconTexture);
			icon.setTextureForState(ButtonState.DISABLED, this.checkDisabledIconTexture);
			icon.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.checkSelectedDownIconTexture);
			icon.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.checkSelectedDisabledIconTexture);
			check.defaultIcon = icon;

			check.fontStyles = this.darkFontStyles;
			check.disabledFontStyles = this.darkDisabledFontStyles;

			check.gap = this.smallGutterSize;
		}

	//-------------------------
	// DateTimeSpinner
	//-------------------------

		protected function setDateTimeSpinnerStyles(spinner:DateTimeSpinner):void
		{
			spinner.customItemRendererStyleName = THEME_STYLE_NAME_DATE_TIME_SPINNER_LIST_ITEM_RENDERER;
		}

		protected function setDateTimeSpinnerListItemRendererStyles(itemRenderer:DefaultListItemRenderer):void
		{
			this.setSpinnerListItemRendererStyles(itemRenderer);

			itemRenderer.paddingLeft = this.smallGutterSize;
			itemRenderer.paddingRight = this.smallGutterSize;
			itemRenderer.gap = this.extraSmallGutterSize;
			itemRenderer.minGap = this.extraSmallGutterSize;
			itemRenderer.accessoryGap = this.extraSmallGutterSize;
			itemRenderer.minAccessoryGap = this.extraSmallGutterSize;
			itemRenderer.accessoryPosition = RelativePosition.LEFT;
		}

	//-------------------------
	// Drawers
	//-------------------------

		protected function setDrawersStyles(drawers:Drawers):void
		{
			var overlaySkin:Quad = new Quad(10, 10, COLOR_DRAWER_OVERLAY);
			overlaySkin.alpha = ALPHA_DRAWER_OVERLAY;
			drawers.overlaySkin = overlaySkin;

			var topDrawerDivider:Quad = new Quad(this.borderSize, this.borderSize, COLOR_DRAWERS_DIVIDER);
			drawers.topDrawerDivider = topDrawerDivider;

			var rightDrawerDivider:Quad = new Quad(this.borderSize, this.borderSize, COLOR_DRAWERS_DIVIDER);
			drawers.rightDrawerDivider = rightDrawerDivider;

			var bottomDrawerDivider:Quad = new Quad(this.borderSize, this.borderSize, COLOR_DRAWERS_DIVIDER);
			drawers.bottomDrawerDivider = bottomDrawerDivider;

			var leftDrawerDivider:Quad = new Quad(this.borderSize, this.borderSize, COLOR_DRAWERS_DIVIDER);
			drawers.leftDrawerDivider = leftDrawerDivider;
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

		protected function setInsetGroupedListStyles(list:GroupedList):void
		{
			this.setGroupedListStyles(list);
			list.customHeaderRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_HEADER_RENDERER;
			list.customFooterRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FOOTER_RENDERER;
		}

		//see List section for item renderer styles

		protected function setGroupedListFirstItemRendererStyles(itemRenderer:BaseDefaultItemRenderer):void
		{
			var skin:ImageSkin = new ImageSkin(this.firstItemRendererUpTexture);
			skin.selectedTexture = this.itemRendererSelectedTexture;
			skin.setTextureForState(ButtonState.DOWN, this.itemRendererDownTexture);
			skin.scale9Grid = LIST_ITEM_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			itemRenderer.defaultSkin = skin;

			itemRenderer.fontStyles = this.darkFontStyles;
			itemRenderer.disabledFontStyles = this.darkDisabledFontStyles;

			itemRenderer.iconLabelFontStyles = this.smallDarkFontStyles;
			itemRenderer.iconLabelDisabledFontStyles = this.smallDarkDisabledFontStyles;

			itemRenderer.accessoryLabelFontStyles = this.smallDarkFontStyles;
			itemRenderer.accessoryLabelDisabledFontStyles = this.smallDarkDisabledFontStyles;

			this.setBaseItemRendererStyles(itemRenderer);
		}

		protected function setGroupedListHeaderRendererStyles(headerRenderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			var backgroundSkin:Image = new Image(this.groupedListHeaderTexture);
			backgroundSkin.scale9Grid = GROUPED_LIST_HEADER_OR_FOOTER_SCALE9_GRID;
			headerRenderer.backgroundSkin = backgroundSkin;

			headerRenderer.fontStyles = this.smallDarkFontStyles;
			headerRenderer.disabledFontStyles = this.smallDarkDisabledFontStyles;

			headerRenderer.horizontalAlign = HorizontalAlign.LEFT;
			headerRenderer.paddingTop = this.smallGutterSize;
			headerRenderer.paddingRight = this.gutterSize;
			headerRenderer.paddingBottom = this.smallGutterSize;
			headerRenderer.paddingLeft = this.gutterSize;
		}

		protected function setGroupedListInsetHeaderRendererStyles(headerRenderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			headerRenderer.fontStyles = this.smallDarkFontStyles;
			headerRenderer.disabledFontStyles = this.smallDarkDisabledFontStyles;

			headerRenderer.horizontalAlign = HorizontalAlign.LEFT;
			headerRenderer.paddingTop = this.gutterSize;
			headerRenderer.paddingRight = this.gutterSize;
			headerRenderer.paddingBottom = this.smallGutterSize;
			headerRenderer.paddingLeft = this.gutterSize;
		}

		protected function setGroupedListFooterRendererStyles(footerRenderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			var backgroundSkin:Image = new Image(this.groupedListFooterTexture);
			backgroundSkin.scale9Grid = GROUPED_LIST_HEADER_OR_FOOTER_SCALE9_GRID;
			footerRenderer.backgroundSkin = backgroundSkin;

			footerRenderer.fontStyles = this.smallDarkFontStyles;
			footerRenderer.disabledFontStyles = this.smallDarkDisabledFontStyles;

			footerRenderer.horizontalAlign = HorizontalAlign.CENTER;
			footerRenderer.paddingTop = this.smallGutterSize;
			footerRenderer.paddingRight = this.gutterSize;
			footerRenderer.paddingBottom = this.smallGutterSize;
			footerRenderer.paddingLeft = this.gutterSize;
		}

		protected function setGroupedListInsetFooterRendererStyles(footerRenderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			footerRenderer.fontStyles = this.darkFontStyles;
			footerRenderer.disabledFontStyles = this.darkDisabledFontStyles;

			footerRenderer.horizontalAlign = HorizontalAlign.LEFT;
			footerRenderer.paddingTop = this.smallGutterSize;
			footerRenderer.paddingRight = this.gutterSize;
			footerRenderer.paddingBottom = this.gutterSize;
			footerRenderer.paddingLeft = this.gutterSize;
		}

	//-------------------------
	// Header
	//-------------------------

		protected function setHeaderStyles(header:Header):void
		{
			this.setHeaderWithoutBackgroundStyles(header);

			header.fontStyles = this.largeDarkFontStyles;
			header.disabledFontStyles = this.largeDarkDisabledFontStyles;

			var backgroundSkin:Image = new Image(this.headerBackgroundSkinTexture);
			backgroundSkin.scale9Grid = HEADER_BACKGROUND_SCALE9_GRID;
			backgroundSkin.width = this.gridSize;
			backgroundSkin.height = this.gridSize;
			header.backgroundSkin = backgroundSkin;
		}

	//-------------------------
	// Label
	//-------------------------

		protected function setLabelStyles(label:Label):void
		{
			label.fontStyles = this.darkFontStyles;
			label.disabledFontStyles = this.darkDisabledFontStyles;
		}

		protected function setHeadingLabelStyles(label:Label):void
		{
			label.fontStyles = this.largeDarkFontStyles;
			label.disabledFontStyles = this.largeDarkDisabledFontStyles;
		}

		protected function setDetailLabelStyles(label:Label):void
		{
			label.fontStyles = this.smallDarkFontStyles;
			label.disabledFontStyles = this.smallDarkDisabledFontStyles;
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

			group.backgroundSkin = new Quad(this.controlSize, this.controlSize, COLOR_BACKGROUND_LIGHT);
		}

	//-------------------------
	// List
	//-------------------------

		protected function setListStyles(list:List):void
		{
			this.setScrollerStyles(list);
			list.backgroundSkin = new Quad(10, 10, COLOR_BACKGROUND_LIGHT);
		}

		protected function setBaseItemRendererStyles(itemRenderer:BaseDefaultItemRenderer):void
		{
			itemRenderer.horizontalAlign = HorizontalAlign.LEFT;
			itemRenderer.paddingTop = this.smallGutterSize;
			itemRenderer.paddingRight = this.gutterSize;
			itemRenderer.paddingBottom = this.smallGutterSize;
			itemRenderer.paddingLeft = this.gutterSize;
			itemRenderer.gap = this.gutterSize;
			itemRenderer.minGap = this.gutterSize;
			itemRenderer.iconPosition = RelativePosition.LEFT;
			itemRenderer.accessoryGap = Number.POSITIVE_INFINITY;
			itemRenderer.minAccessoryGap = this.gutterSize;
			itemRenderer.accessoryPosition = RelativePosition.RIGHT;
			itemRenderer.minTouchWidth = this.controlSize;
			itemRenderer.minTouchHeight = this.controlSize;
		}

		protected function setItemRendererStyles(itemRenderer:BaseDefaultItemRenderer):void
		{
			var skin:ImageSkin = new ImageSkin(this.itemRendererUpTexture);
			skin.selectedTexture = this.itemRendererSelectedTexture;
			skin.setTextureForState(ButtonState.DOWN, this.itemRendererDownTexture);
			skin.scale9Grid = LIST_ITEM_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.controlSize;
			skin.minHeight = this.controlSize;
			itemRenderer.defaultSkin = skin;

			itemRenderer.fontStyles = this.darkFontStyles;
			itemRenderer.disabledFontStyles = this.darkDisabledFontStyles;

			itemRenderer.iconLabelFontStyles = this.smallDarkFontStyles;
			itemRenderer.iconLabelDisabledFontStyles = this.smallDarkDisabledFontStyles;

			itemRenderer.accessoryLabelFontStyles = this.smallDarkFontStyles;
			itemRenderer.accessoryLabelDisabledFontStyles = this.smallDarkDisabledFontStyles;

			this.setBaseItemRendererStyles(itemRenderer);
		}

	//-------------------------
	// NumericStepper
	//-------------------------

		protected function setNumericStepperStyles(stepper:NumericStepper):void
		{
			stepper.buttonLayoutMode = StepperButtonLayoutMode.SPLIT_HORIZONTAL;
			stepper.incrementButtonLabel = "+";
			stepper.decrementButtonLabel = "-";
		}

		protected function setNumericStepperTextInputStyles(input:TextInput):void
		{
			var skin:ImageSkin = new ImageSkin(this.textInputBackgroundEnabledTexture);
			skin.disabledTexture = this.textInputBackgroundDisabledTexture;
			skin.scale9Grid = TEXT_INPUT_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.controlSize;
			skin.minHeight = this.controlSize;
			input.backgroundSkin = skin;

			input.textEditorFactory = stepperTextEditorFactory;
			input.fontStyles = this.darkCenteredFontStyles;
			input.disabledFontStyles = this.darkCenteredDisabledFontStyles;

			input.padding = this.smallGutterSize;
			input.isEditable = false;
			input.isSelectable = false;
		}

		protected function setNumericStepperButtonStyles(button:Button):void
		{
			setQuietButtonStyles(button);

			button.keepDownStateOnRollOut = true;

			button.fontStyles = this.largeDarkFontStyles;
			button.disabledFontStyles = this.largeDarkDisabledFontStyles;
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

			var backgroundSkin:Image = new Image(this.popUpBackgroundTexture);
			backgroundSkin.scale9Grid = BACKGROUND_POPUP_SCALE9_GRID;
			panel.backgroundSkin = backgroundSkin;

			panel.paddingTop = this.smallGutterSize;
			panel.paddingRight = this.smallGutterSize;
			panel.paddingBottom = this.smallGutterSize;
			panel.paddingLeft = this.smallGutterSize;
		}

		protected function setHeaderWithoutBackgroundStyles(header:Header):void
		{
			header.fontStyles = this.largeDarkFontStyles;
			header.disabledFontStyles = this.largeDarkDisabledFontStyles;

			header.gap = this.gutterSize;
			header.paddingTop = this.smallGutterSize;
			header.paddingRight = this.smallGutterSize;
			header.paddingBottom = this.smallGutterSize;
			header.paddingLeft = this.smallGutterSize;
			header.titleGap = this.smallGutterSize;
			header.minHeight = this.gridSize;
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
	// PickerList
	//-------------------------

		protected function setPickerListStyles(list:PickerList):void
		{
			if(DeviceCapabilities.isPhone(this.starling.nativeStage))
			{
				list.listFactory = pickerListSpinnerListFactory;

				var popUpContentManager:BottomDrawerPopUpContentManager = new BottomDrawerPopUpContentManager();
				popUpContentManager.customPanelStyleName = THEME_STYLE_NAME_POP_UP_DRAWER;
				list.popUpContentManager = popUpContentManager;
			}
			else
			{
				list.popUpContentManager = new CalloutPopUpContentManager();
				list.customItemRendererStyleName = THEME_STYLE_NAME_TABLET_PICKER_LIST_ITEM_RENDERER;
			}
		}

		protected function setPickerListButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonUpTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledTexture);
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			button.defaultSkin = skin;

			var icon:ImageSkin = new ImageSkin(this.pickerListButtonIcon);
			icon.disabledTexture = this.pickerListButtonDisabledIcon;
			button.defaultIcon = icon;

			button.fontStyles = this.darkFontStyles;
			button.disabledFontStyles = this.darkDisabledFontStyles;

			this.setBaseButtonStyles(button);

			button.gap = Number.POSITIVE_INFINITY;
			button.minGap = this.gutterSize;
			button.iconPosition = RelativePosition.RIGHT;
			button.paddingLeft = this.gutterSize;
		}

		protected function setPickerListListStyles(list:List):void
		{
			this.setDropDownListStyles(list);
		}

		protected function setTabletPickerListItemRendererStyles(itemRenderer:BaseDefaultItemRenderer):void
		{
			var skin:ImageSkin = new ImageSkin(this.itemRendererUpTexture);
			skin.selectedTexture = this.itemRendererSelectedTexture;
			skin.setTextureForState(ButtonState.DOWN, this.itemRendererDownTexture);
			skin.scale9Grid = LIST_ITEM_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.popUpFillSize;
			skin.minHeight = this.controlSize;
			itemRenderer.defaultSkin = skin;

			itemRenderer.fontStyles = this.darkFontStyles;
			itemRenderer.disabledFontStyles = this.darkDisabledFontStyles;

			itemRenderer.iconLabelFontStyles = this.smallDarkFontStyles;
			itemRenderer.iconLabelDisabledFontStyles = this.smallDarkDisabledFontStyles;

			itemRenderer.accessoryLabelFontStyles = this.smallDarkFontStyles;
			itemRenderer.accessoryLabelDisabledFontStyles = this.smallDarkDisabledFontStyles;

			this.setBaseItemRendererStyles(itemRenderer);
		}

		protected function setPickerListPopUpDrawerStyles(panel:Panel):void
		{
			this.setScrollerStyles(panel);

			panel.customHeaderStyleName = THEME_STYLE_NAME_POP_UP_DRAWER_HEADER;

			var backgroundSkin:Image = new Image(this.popUpDrawerBackgroundTexture);
			backgroundSkin.scale9Grid = POP_UP_DRAWER_BACKGROUND_SCALE9_GRID;
			panel.backgroundSkin = backgroundSkin;

			panel.outerPaddingTop = this.shadowSize;
		}

	//-------------------------
	// ProgressBar
	//-------------------------

		protected function setProgressBarStyles(progress:ProgressBar):void
		{
			var backgroundSkin:Image;
			var backgroundDisabledSkin:Image;
			/* Horizontal background skin */
			if(progress.direction === Direction.HORIZONTAL)
			{
				backgroundSkin = new Image(this.horizontalProgressBarBackgroundTexture);
				backgroundSkin.scale9Grid = BAR_HORIZONTAL_SCALE9_GRID;
				backgroundSkin.width = this.wideControlSize;
				backgroundSkin.height = this.smallControlSize;
				backgroundDisabledSkin = new Image(this.horizontalProgressBarBackgroundDisabledTexture);
				backgroundDisabledSkin.scale9Grid = BAR_HORIZONTAL_SCALE9_GRID;
				backgroundDisabledSkin.width = this.wideControlSize;
				backgroundDisabledSkin.height = this.smallControlSize;
			}
			else //vertical
			{
				backgroundSkin = new Image(this.verticalProgressBarBackgroundTexture);
				backgroundSkin.scale9Grid = BAR_VERTICAL_SCALE9_GRID;
				backgroundSkin.width = this.smallControlSize;
				backgroundSkin.height = this.wideControlSize;
				backgroundDisabledSkin = new Image(this.verticalProgressBarBackgroundDisabledTexture);
				backgroundDisabledSkin.scale9Grid = BAR_VERTICAL_SCALE9_GRID;
				backgroundDisabledSkin.width = this.smallControlSize;
				backgroundDisabledSkin.height = this.wideControlSize;
			}
			progress.backgroundSkin = backgroundSkin;
			progress.backgroundDisabledSkin = backgroundDisabledSkin;

			var fillSkin:Image;
			var fillDisabledSkin:Image;
			/* Horizontal fill skin */
			if(progress.direction === Direction.HORIZONTAL)
			{
				fillSkin = new Image(this.horizontalProgressBarFillTexture);
				fillSkin.scale9Grid = BAR_HORIZONTAL_SCALE9_GRID;
				fillSkin.width = this.smallControlSize;
				fillSkin.height = this.smallControlSize;
				fillDisabledSkin = new Image(this.horizontalProgressBarFillDisabledTexture);
				fillDisabledSkin.scale9Grid = BAR_HORIZONTAL_SCALE9_GRID;
				fillDisabledSkin.width = this.smallControlSize;
				fillDisabledSkin.height = this.smallControlSize;
			}
			else //vertical
			{
				fillSkin = new Image(this.verticalProgressBarFillTexture);
				fillSkin.scale9Grid = BAR_VERTICAL_SCALE9_GRID;
				fillSkin.width = this.smallControlSize;
				fillSkin.height = this.smallControlSize;
				fillDisabledSkin = new Image(verticalProgressBarFillDisabledTexture);
				fillDisabledSkin.scale9Grid = BAR_VERTICAL_SCALE9_GRID;
				fillDisabledSkin.width = this.smallControlSize;
				fillDisabledSkin.height = this.smallControlSize;
			}
			progress.fillSkin = fillSkin;
			progress.fillDisabledSkin = fillDisabledSkin;
		}

	//-------------------------
	// Radio
	//-------------------------

		protected function setRadioStyles(radio:Radio):void
		{
			var icon:ImageSkin = new ImageSkin(this.radioUpIconTexture);
			icon.selectedTexture = this.radioSelectedUpIconTexture;
			icon.setTextureForState(ButtonState.DOWN, this.radioDownIconTexture);
			icon.setTextureForState(ButtonState.DISABLED, this.radioDisabledIconTexture);
			icon.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.radioSelectedDownIconTexture);
			icon.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.radioSelectedDisabledIconTexture);
			radio.defaultIcon = icon;

			radio.fontStyles = this.darkFontStyles;
			radio.disabledFontStyles = this.darkDisabledFontStyles;

			radio.gap = this.smallGutterSize;
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

			container.backgroundSkin = new Quad(this.controlSize, this.controlSize, COLOR_BACKGROUND_LIGHT);
		}

	//-------------------------
	// ScrollText
	//-------------------------

		protected function setScrollTextStyles(text:ScrollText):void
		{
			this.setScrollerStyles(text);

			text.fontStyles = this.darkScrollTextFontStyles;
			text.disabledFontStyles = this.darkScrollTextDisabledFontStyles;

			text.padding = this.gutterSize;
			text.paddingRight = this.gutterSize + this.smallGutterSize;
		}

	//-------------------------
	// SimpleScrollBar
	//-------------------------

		protected function setSimpleScrollBarStyles(scrollBar:SimpleScrollBar):void
		{
			if(scrollBar.direction === Direction.HORIZONTAL)
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
			var defaultSkin:Image = new Image(this.horizontalSimpleScrollBarThumbTexture);
			defaultSkin.scale9Grid = HORIZONTAL_SIMPLE_SCROLL_BAR_SCALE9_GRID;
			thumb.defaultSkin = defaultSkin;

			thumb.hasLabelTextRenderer = false;
		}

		protected function setVerticalSimpleScrollBarThumbStyles(thumb:Button):void
		{
			var defaultSkin:Image = new Image(this.verticalSimpleScrollBarThumbTexture);
			defaultSkin.scale9Grid = VERTICAL_SIMPLE_SCROLL_BAR_SCALE9_GRID;
			thumb.defaultSkin = defaultSkin;

			thumb.hasLabelTextRenderer = false;
		}

	//-------------------------
	// SpinnerList
	//-------------------------

		protected function setSpinnerListStyles(list:SpinnerList):void
		{
			list.verticalScrollPolicy = ScrollPolicy.ON;
			list.backgroundSkin = new Quad(this.controlSize, this.controlSize, COLOR_SPINNER_LIST_BACKGROUND);
			var selectionOverlaySkin:Image = new Image(this.spinnerListSelectionOverlayTexture);
			selectionOverlaySkin.scale9Grid = SPINNER_LIST_OVERLAY_SCALE9_GRID;
			list.selectionOverlaySkin = selectionOverlaySkin;
			list.customItemRendererStyleName = THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER;
		}

		protected function setSpinnerListItemRendererStyles(itemRenderer:DefaultListItemRenderer):void
		{
			var defaultSkin:Quad = new Quad(this.gridSize, this.gridSize, 0xff00ff);
			defaultSkin.alpha = 0;
			itemRenderer.defaultSkin = defaultSkin;

			itemRenderer.fontStyles = this.darkFontStyles;
			itemRenderer.disabledFontStyles = this.darkDisabledFontStyles;
			itemRenderer.selectedFontStyles = this.selectedFontStyles;

			itemRenderer.iconLabelFontStyles = this.smallDarkFontStyles;
			itemRenderer.iconLabelDisabledFontStyles = this.smallDarkDisabledFontStyles;
			itemRenderer.iconLabelSelectedFontStyles = this.smallSelectedFontStyles;

			itemRenderer.accessoryLabelFontStyles = this.smallDarkFontStyles;
			itemRenderer.accessoryLabelDisabledFontStyles = this.smallDarkDisabledFontStyles;
			itemRenderer.accessoryLabelSelectedFontStyles = this.smallSelectedFontStyles;

			itemRenderer.horizontalAlign = HorizontalAlign.LEFT;
			itemRenderer.paddingTop = this.smallGutterSize;
			itemRenderer.paddingBottom = this.smallGutterSize;
			itemRenderer.paddingLeft = this.gutterSize;
			itemRenderer.paddingRight = this.gutterSize;
			itemRenderer.gap = this.smallGutterSize;
			itemRenderer.minGap = this.smallGutterSize;
			itemRenderer.iconPosition = RelativePosition.LEFT;
			itemRenderer.accessoryGap = Number.POSITIVE_INFINITY;
			itemRenderer.minAccessoryGap = this.smallGutterSize;
			itemRenderer.accessoryPosition = RelativePosition.RIGHT;
		}

	//-------------------------
	// Slider
	//-------------------------

		protected function setSliderStyles(slider:Slider):void
		{
			slider.trackLayoutMode = TrackLayoutMode.SPLIT;
			if(slider.direction === Direction.VERTICAL)
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
			var skin:ImageSkin = new ImageSkin(this.horizontalSliderMinimumTrackTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.horizontalSliderMinimumTrackDisabledTexture);
			skin.scale9Grid = HORIZONTAL_MINIMUM_TRACK_SCALE9_GRID;
			skin.width = this.wideControlSize - this.thumbSize / 2;
			skin.height = this.smallControlSize;
			track.defaultSkin = skin;
			
			track.hasLabelTextRenderer = false;
		}

		protected function setHorizontalSliderMaximumTrackStyles(track:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.horizontalSliderMaximumTrackTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.horizontalSliderMaximumTrackDisabledTexture);
			skin.scale9Grid = HORIZONTAL_MAXIMUM_TRACK_SCALE9_GRID;
			skin.width = this.wideControlSize - this.thumbSize / 2;
			skin.height = this.smallControlSize;
			track.defaultSkin = skin;
			
			track.hasLabelTextRenderer = false;
		}

		protected function setVerticalSliderMinimumTrackStyles(track:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.verticalSliderMinimumTrackTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.verticalSliderMinimumTrackDisabledTexture);
			skin.scale9Grid = VERTICAL_MINIMUM_TRACK_SCALE9_GRID;
			skin.width = this.smallControlSize;
			skin.height = this.wideControlSize - this.thumbSize / 2;
			track.defaultSkin = skin;
			track.hasLabelTextRenderer = false;
		}

		protected function setVerticalSliderMaximumTrackStyles(track:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.verticalSliderMaximumTrackTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.verticalSliderMaximumTrackDisabledTexture);
			skin.scale9Grid = VERTICAL_MAXIMUM_TRACK_SCALE9_GRID;
			skin.width = this.smallControlSize;
			skin.height = this.wideControlSize - this.thumbSize / 2;
			track.defaultSkin = skin;
			track.hasLabelTextRenderer = false;
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
			var skin:ImageSkin = new ImageSkin(this.tabUpTexture);
			skin.selectedTexture = this.tabSelectedUpTexture;
			skin.setTextureForState(ButtonState.DOWN, this.tabDownTexture);
			skin.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.tabSelectedDisabledTexture);
			skin.scale9Grid = TAB_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.gridSize;
			skin.minWidth = this.controlSize;
			skin.minHeight = this.gridSize;
			tab.defaultSkin = skin;

			tab.fontStyles = this.darkFontStyles;
			tab.disabledFontStyles = this.darkDisabledFontStyles;
			tab.selectedFontStyles = this.selectedFontStyles;
			tab.setFontStylesForState(ButtonState.DISABLED_AND_SELECTED, this.selectedDisabledFontStyles);

			tab.paddingLeft = this.gutterSize;
			tab.paddingRight = this.gutterSize;
		}

	//-------------------------
	// TextArea
	//-------------------------

		protected function setTextAreaStyles(textArea:TextArea):void
		{
			this.setScrollerStyles(textArea);

			var skin:ImageSkin = new ImageSkin(this.textInputBackgroundEnabledTexture);
			skin.disabledTexture = this.textInputBackgroundDisabledTexture;
			skin.setTextureForState(TextInputState.FOCUSED, this.textInputBackgroundFocusedTexture);
			skin.setTextureForState(TextInputState.ERROR, this.textInputBackgroundErrorTexture);
			skin.scale9Grid = TEXT_INPUT_SCALE9_GRID;
			skin.width = this.wideControlSize;
			skin.height = this.wideControlSize;
			textArea.backgroundSkin = skin;

			textArea.fontStyles = this.darkScrollTextFontStyles;
			textArea.disabledFontStyles = this.darkScrollTextDisabledFontStyles;

			textArea.textEditorFactory = textAreaTextEditorFactory;
		}

		protected function setTextAreaTextEditorStyles(textEditor:TextFieldTextEditorViewPort):void
		{
			textEditor.padding = this.smallGutterSize;
		}

	//-------------------------
	// TextCallout
	//-------------------------

		protected function setTextCalloutStyles(callout:TextCallout):void
		{
			this.setCalloutStyles(callout);

			callout.fontStyles = this.darkFontStyles;
			callout.disabledFontStyles = this.darkDisabledFontStyles
		}

	//-------------------------
	// TextInput
	//-------------------------

		protected function setBaseTextInputStyles(input:TextInput):void
		{
			input.paddingTop = this.smallGutterSize;
			input.paddingRight = this.gutterSize;
			input.paddingBottom = this.smallGutterSize;
			input.paddingLeft = this.gutterSize;
			input.gap = this.smallGutterSize;
		}

		protected function setTextInputStyles(input:TextInput):void
		{
			var skin:ImageSkin = new ImageSkin(this.textInputBackgroundEnabledTexture);
			skin.disabledTexture = this.textInputBackgroundDisabledTexture;
			skin.setTextureForState(TextInputState.FOCUSED, this.textInputBackgroundFocusedTexture);
			skin.setTextureForState(TextInputState.ERROR, this.textInputBackgroundErrorTexture);
			skin.scale9Grid = TEXT_INPUT_SCALE9_GRID;
			skin.width = this.wideControlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.wideControlSize;
			skin.minHeight = this.controlSize;
			input.backgroundSkin = skin;

			input.fontStyles = this.darkScrollTextFontStyles;
			input.disabledFontStyles = this.darkScrollTextDisabledFontStyles;

			input.promptFontStyles = this.darkFontStyles;
			input.promptDisabledFontStyles = this.darkDisabledFontStyles;

			this.setBaseTextInputStyles(input);
		}

		protected function setSearchTextInputStyles(input:TextInput):void
		{
			var skin:ImageSkin = new ImageSkin(this.searchTextInputBackgroundEnabledTexture);
			skin.disabledTexture = this.searchTextInputBackgroundDisabledTexture;
			skin.setTextureForState(TextInputState.FOCUSED, this.searchTextInputBackgroundFocusedTexture);
			skin.scale9Grid = SEARCH_INPUT_SCALE9_GRID;
			skin.width = this.wideControlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.wideControlSize;
			skin.minHeight = this.controlSize;
			input.backgroundSkin = skin;

			var icon:Image = new Image(this.searchIconTexture);
			input.defaultIcon = icon;

			input.fontStyles = this.darkScrollTextFontStyles;
			input.disabledFontStyles = this.darkScrollTextDisabledFontStyles;

			input.promptFontStyles = this.darkFontStyles;
			input.promptDisabledFontStyles = this.darkDisabledFontStyles;

			this.setBaseTextInputStyles(input);
		}

	//-------------------------
	// ToggleButton
	//-------------------------

		protected function setToggleButtonStyles(button:ToggleButton):void
		{
			this.setButtonStyles(button);

			button.fontStyles = this.darkFontStyles;
			button.disabledFontStyles = this.darkDisabledFontStyles;
			button.selectedFontStyles = this.selectedFontStyles;
			button.setFontStylesForState(ButtonState.DISABLED_AND_SELECTED, this.selectedDisabledFontStyles);
		}

	//-------------------------
	// ToggleSwitch
	//-------------------------

		protected function setToggleSwitchStyles(toggle:ToggleSwitch):void
		{
			toggle.offLabelFontStyles = this.darkFontStyles;
			toggle.offLabelDisabledFontStyles = this.darkDisabledFontStyles;
			toggle.onLabelFontStyles = this.selectedFontStyles;
			toggle.onLabelDisabledFontStyles = this.darkDisabledFontStyles;

			toggle.trackLayoutMode = TrackLayoutMode.SPLIT;
		}

		protected function setToggleSwitchOnTrackStyles(track:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.toggleSwitchOnTrackTexture);
			skin.disabledTexture = this.toggleSwitchOnTrackDisabledTexture;
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.gridSize;
			skin.height = this.controlSize;

			track.defaultSkin = skin;
			track.hasLabelTextRenderer = false;
		}

		protected function setToggleSwitchOffTrackStyles(track:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.toggleSwitchOffTrackTexture);
			skin.disabledTexture = this.toggleSwitchOffTrackDisabledTexture;
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.gridSize;
			skin.height = this.controlSize;

			track.defaultSkin = skin;
			track.hasLabelTextRenderer = false;
		}

		protected function setHorizontalThumbStyles(thumb:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonUpTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledTexture);
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.thumbSize;
			skin.height = this.controlSize;
			thumb.defaultSkin = skin;
			thumb.hasLabelTextRenderer = false;
		}

		protected function setVerticalThumbStyles(thumb:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonUpTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledTexture);
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.thumbSize;
			thumb.defaultSkin = skin;
			thumb.hasLabelTextRenderer = false;
		}

	}

}
