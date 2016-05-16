/*
Copyright 2012-2016 Bowler Hat LLC

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
	import feathers.controls.ButtonState;
	import feathers.controls.Callout;
	import feathers.controls.Check;
	import feathers.controls.DateTimeSpinner;
	import feathers.controls.Drawers;
	import feathers.controls.GroupedList;
	import feathers.controls.Header;
	import feathers.controls.ImageLoader;
	import feathers.controls.ItemRendererLayoutOrder;
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
	import feathers.controls.text.BitmapFontTextEditor;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.controls.text.ITextEditorViewPort;
	import feathers.controls.text.StageTextTextEditor;
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
	import feathers.media.FullScreenToggleButton;
	import feathers.media.MuteToggleButton;
	import feathers.media.PlayPauseToggleButton;
	import feathers.media.SeekSlider;
	import feathers.media.VideoPlayer;
	import feathers.media.VolumeSlider;
	import feathers.skins.ImageSkin;
	import feathers.system.DeviceCapabilities;
	import feathers.text.BitmapFontTextFormat;

	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.text.TextField;
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
		 * The theme's custom style name for item renderers in a SpinnerList.
		 */
		protected static const THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER:String = "minimal-mobile-spinner-list-item-renderer";

		/**
		 * @private
		 * The theme's custom style name for the label text renderer inside item
		 * renderers in a SpinnerList.
		 */
		protected static const THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER_LABEL:String = "minimal-mobile-spinner-list-item-renderer-label";

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

		/**
		 * @private
		 * The theme's custom style name for the text editor of the text input
		 * in a NumericStepper.
		 */
		protected static const THEME_STYLE_NAME_NUMERIC_STEPPER_TEXT_INPUT_TEXT_EDITOR:String = "minimal-mobile-numeric-stepper-text-input-text-editor";

		/**
		 * @private
		 * The theme's custom style name for the item renderer of the
		 * SpinnerList in a DateTimeSpinner.
		 */
		protected static const THEME_STYLE_NAME_DATE_TIME_SPINNER_LIST_ITEM_RENDERER:String = "minimal-mobile-date-time-spinner-list-item-renderer";

		/**
		 * @private
		 * The theme's custom style name for the text renderer that displays an
		 * error message or is related to a destructive action.
		 */
		protected static const THEME_STYLE_NAME_DANGER_TEXT_RENDERER:String = "minimal-mobile-theme-danger-text-callout-text-renderer";

		/**
		 * @private
		 * The theme's custom style name for the text renderer of a heading Label.
		 */
		protected static const THEME_STYLE_NAME_HEADING_LABEL_TEXT_RENDERER:String = "minimal-mobile-heading-label-text-renderer";

		/**
		 * @private
		 * The theme's custom style name for the text renderer of a detail Label.
		 */
		protected static const THEME_STYLE_NAME_DETAIL_LABEL_TEXT_RENDERER:String = "minimal-mobile-detail-label-text-renderer";

		protected static const FONT_TEXTURE_NAME:String = "pf_ronda_seven_0";

		protected static const DEFAULT_SCALE_9_GRID:Rectangle = new Rectangle(4, 4, 1, 1);
		protected static const SCROLLBAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(1, 1, 2, 2);
		protected static const ITEM_RENDERER_SCALE_9_GRID:Rectangle = new Rectangle(0, 3, 2, 1);
		protected static const TAB_SCALE_9_GRID:Rectangle = new Rectangle(11, 11, 1, 1);
		protected static const HEADER_SCALE_9_GRID:Rectangle = new Rectangle(1, 3, 1, 1);
		protected static const SPINNER_LIST_SELECTION_OVERLAY_SCALE9_GRID:Rectangle = new Rectangle(1, 3, 1, 1);
		protected static const SEEK_SLIDER_PROGRESS_SKIN_SCALE9_GRID:Rectangle = new Rectangle(0, 2, 2, 10);
		protected static const BACK_BUTTON_SCALE9_GRID:Rectangle = new Rectangle(16, 0, 1, 28);
		protected static const FORWARD_BUTTON_SCALE9_GRID:Rectangle = new Rectangle(3, 0, 1, 28);

		protected static const BACKGROUND_COLOR:uint = 0xf3f3f3;
		protected static const LIST_BACKGROUND_COLOR:uint = 0xf8f8f8;
		protected static const LIST_HEADER_BACKGROUND_COLOR:uint = 0xeeeeee;
		protected static const DRAWERS_DIVIDER_COLOR:uint = 0xebebeb;
		protected static const PRIMARY_TEXT_COLOR:uint = 0x666666;
		protected static const DISABLED_TEXT_COLOR:uint = 0x999999;
		protected static const DANGER_TEXT_COLOR:uint = 0x990000;
		protected static const MODAL_OVERLAY_COLOR:uint = 0xcccccc;
		protected static const MODAL_OVERLAY_ALPHA:Number = 0.4;
		protected static const VIDEO_OVERLAY_COLOR:uint = 0xcccccc;
		protected static const VIDEO_OVERLAY_ALPHA:Number = 0.2;

		/**
		 * The default global text renderer factory for this theme creates a
		 * BitmapFontTextRenderer.
		 */
		protected static function textRendererFactory():ITextRenderer
		{
			var renderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
			//since it's a pixel font, we don't want to smooth it.
			renderer.textureSmoothing = TextureSmoothing.NONE;
			return renderer;
		}

		/**
		 * The default global text editor factory for this theme creates a
		 * StageTextTextEditor.
		 */
		protected static function textEditorFactory():ITextEditor
		{
			return new StageTextTextEditor();
		}

		/**
		 * The text editor factory for a TextArea creates a
		 * TextFieldTextEditorViewPort.
		 */
		protected static function textAreaTextEditorFactory():ITextEditorViewPort
		{
			return new TextFieldTextEditorViewPort();
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
			editor.textureSmoothing = TextureSmoothing.NONE;
			return editor;
		}

		protected static function pickerListButtonFactory():ToggleButton
		{
			return new ToggleButton();
		}
		
		protected static function pickerListSpinnerListFactory():SpinnerList
		{
			return new SpinnerList();
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
		 * Constructor.
		 *
		 * @param scaleToDPI Determines if the theme's skins will be scaled based on the screen density and content scale factor.
		 */
		public function BaseMinimalMobileTheme()
		{
			super();
		}

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
		 * The texture atlas that contains skins for this theme. This base class
		 * does not initialize this member variable. Subclasses are expected to
		 * load the assets somehow and set the <code>atlas</code> member
		 * variable before calling <code>initialize()</code>.
		 */
		protected var atlas:TextureAtlas;

		protected var buttonUpSkinTexture:Texture;
		protected var buttonDownSkinTexture:Texture;
		protected var buttonDisabledSkinTexture:Texture;
		protected var buttonSelectedSkinTexture:Texture;
		protected var buttonSelectedDisabledSkinTexture:Texture;
		protected var buttonCallToActionUpSkinTexture:Texture;
		protected var buttonDangerUpSkinTexture:Texture;
		protected var buttonDangerDownSkinTexture:Texture;
		protected var buttonBackUpSkinTexture:Texture;
		protected var buttonBackDownSkinTexture:Texture;
		protected var buttonBackDisabledSkinTexture:Texture;
		protected var buttonForwardUpSkinTexture:Texture;
		protected var buttonForwardDownSkinTexture:Texture;
		protected var buttonForwardDisabledSkinTexture:Texture;

		protected var tabDownSkinTexture:Texture;
		protected var tabSelectedSkinTexture:Texture;
		protected var tabSelectedDisabledSkinTexture:Texture;

		protected var thumbSkinTexture:Texture;
		protected var thumbDisabledSkinTexture:Texture;

		protected var scrollBarThumbSkinTexture:Texture;

		protected var insetBackgroundSkinTexture:Texture;
		protected var insetBackgroundDisabledSkinTexture:Texture;
		protected var insetBackgroundFocusedSkinTexture:Texture;
		protected var insetBackgroundDangerSkinTexture:Texture;

		protected var pickerListButtonIconUpTexture:Texture;
		protected var pickerListButtonIconSelectedTexture:Texture;
		protected var pickerListButtonIconDisabledTexture:Texture;
		protected var searchIconTexture:Texture;
		protected var searchIconDisabledTexture:Texture;

		protected var itemRendererUpSkinTexture:Texture;
		protected var itemRendererDownSkinTexture:Texture;
		protected var itemRendererSelectedUpSkinTexture:Texture;
		protected var checkItemRendererSelectedIconTexture:Texture;
		protected var spinnerListSelectionOverlaySkinTexture:Texture;

		protected var headerSkinTexture:Texture;
		protected var panelHeaderSkinTexture:Texture;

		protected var panelBackgroundSkinTexture:Texture;
		protected var popUpBackgroundSkinTexture:Texture;
		protected var dangerPopUpBackgroundSkinTexture:Texture;
		protected var calloutTopArrowSkinTexture:Texture;
		protected var calloutBottomArrowSkinTexture:Texture;
		protected var calloutLeftArrowSkinTexture:Texture;
		protected var calloutRightArrowSkinTexture:Texture;
		protected var dangerCalloutTopArrowSkinTexture:Texture;
		protected var dangerCalloutBottomArrowSkinTexture:Texture;
		protected var dangerCalloutLeftArrowSkinTexture:Texture;
		protected var dangerCalloutRightArrowSkinTexture:Texture;

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

		//media textures
		protected var playPauseButtonPlayUpIconTexture:Texture;
		protected var playPauseButtonPauseUpIconTexture:Texture;
		protected var overlayPlayPauseButtonPlayUpIconTexture:Texture;
		protected var fullScreenToggleButtonEnterUpIconTexture:Texture;
		protected var fullScreenToggleButtonExitUpIconTexture:Texture;
		protected var muteToggleButtonLoudUpIconTexture:Texture;
		protected var muteToggleButtonMutedUpIconTexture:Texture;
		protected var seekSliderProgressSkinTexture:Texture;
		protected var volumeSliderMinimumTrackSkinTexture:Texture;
		protected var volumeSliderMaximumTrackSkinTexture:Texture;
		
		protected var listDrillDownAccessoryTexture:Texture;

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
		protected var calloutBackgroundMinSize:int;
		protected var calloutBottomRightArrowOverlapGapSize:Number;
		protected var calloutTopLeftArrowOverlapGapSize:int;
		protected var popUpFillSize:int;
		protected var dropShadowSize:int;

		protected var primaryTextFormat:BitmapFontTextFormat;
		protected var disabledTextFormat:BitmapFontTextFormat;
		protected var centeredTextFormat:BitmapFontTextFormat;
		protected var centeredDisabledTextFormat:BitmapFontTextFormat;
		protected var headingTextFormat:BitmapFontTextFormat;
		protected var headingDisabledTextFormat:BitmapFontTextFormat;
		protected var detailTextFormat:BitmapFontTextFormat;
		protected var detailDisabledTextFormat:BitmapFontTextFormat;
		protected var dangerTextFormat:BitmapFontTextFormat;

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
		 * Initializes common values used for setting the dimensions of components.
		 */
		protected function initializeDimensions():void
		{
			this.gridSize = 44;
			this.smallGutterSize = 6;
			this.gutterSize = 11;
			this.borderSize = 2;
			this.dropShadowSize = 6;
			this.controlSize = 30;
			this.smallControlSize = 16;
			this.popUpFillSize = 276;
			this.wideControlSize = this.gridSize * 3 + this.gutterSize * 2;
			this.simpleScrollBarThumbSize = 4;
			this.calloutBackgroundMinSize = 6;
			this.calloutTopLeftArrowOverlapGapSize = -4;
			this.calloutBottomRightArrowOverlapGapSize = -10.5;
		}

		/**
		 * Initializes the textures by extracting them from the atlas and
		 * setting up any scaling grids that are needed.
		 */
		protected function initializeTextures():void
		{
			this.buttonUpSkinTexture = this.atlas.getTexture("button-up-skin0000");
			this.buttonDownSkinTexture = this.atlas.getTexture("button-down-skin0000");
			this.buttonDisabledSkinTexture = this.atlas.getTexture("button-disabled-skin0000");
			this.buttonSelectedSkinTexture = this.atlas.getTexture("inset-background-enabled-skin0000");
			this.buttonSelectedDisabledSkinTexture = this.atlas.getTexture("inset-background-disabled-skin0000");
			this.buttonCallToActionUpSkinTexture = this.atlas.getTexture("call-to-action-button-up-skin0000");
			this.buttonDangerUpSkinTexture = this.atlas.getTexture("danger-button-up-skin0000");
			this.buttonDangerDownSkinTexture = this.atlas.getTexture("danger-button-down-skin0000");
			this.buttonBackUpSkinTexture = this.atlas.getTexture("back-button-up-skin0000");
			this.buttonBackDownSkinTexture = this.atlas.getTexture("back-button-down-skin0000");
			this.buttonBackDisabledSkinTexture = this.atlas.getTexture("back-button-disabled-skin0000");
			this.buttonForwardUpSkinTexture = this.atlas.getTexture("forward-button-up-skin0000");
			this.buttonForwardDownSkinTexture = this.atlas.getTexture("forward-button-down-skin0000");
			this.buttonForwardDisabledSkinTexture = this.atlas.getTexture("forward-button-disabled-skin0000");

			this.tabDownSkinTexture = this.atlas.getTexture("tab-down-skin0000");
			this.tabSelectedSkinTexture = this.atlas.getTexture("tab-selected-up-skin0000");
			this.tabSelectedDisabledSkinTexture = this.atlas.getTexture("tab-selected-disabled-skin0000");

			this.thumbSkinTexture = this.atlas.getTexture("face-up-skin0000");
			this.thumbDisabledSkinTexture = this.atlas.getTexture("face-disabled-skin0000");

			this.scrollBarThumbSkinTexture = this.atlas.getTexture("simple-scroll-bar-thumb-skin0000");

			this.insetBackgroundSkinTexture = this.atlas.getTexture("inset-background-enabled-skin0000");
			this.insetBackgroundDisabledSkinTexture = this.atlas.getTexture("inset-background-disabled-skin0000");
			this.insetBackgroundFocusedSkinTexture = this.atlas.getTexture("inset-background-focused-skin0000");
			this.insetBackgroundDangerSkinTexture = this.atlas.getTexture("inset-background-danger-skin0000");

			this.pickerListButtonIconUpTexture = this.atlas.getTexture("picker-list-icon0000");
			this.pickerListButtonIconSelectedTexture = this.atlas.getTexture("picker-list-selected-icon0000");
			this.pickerListButtonIconDisabledTexture = this.atlas.getTexture("picker-list-disabled-icon0000");
			this.searchIconTexture = this.atlas.getTexture("search-enabled-icon0000");
			this.searchIconDisabledTexture = this.atlas.getTexture("search-disabled-icon0000");

			this.itemRendererUpSkinTexture = this.atlas.getTexture("item-renderer-up-skin0000");
			this.itemRendererDownSkinTexture = this.atlas.getTexture("item-renderer-down-skin0000");
			this.itemRendererSelectedUpSkinTexture = this.atlas.getTexture("item-renderer-selected-up-skin0000");
			this.checkItemRendererSelectedIconTexture = this.atlas.getTexture("check-item-renderer-selected-icon0000");

			this.spinnerListSelectionOverlaySkinTexture = this.atlas.getTexture("spinner-list-selection-overlay-skin0000");

			this.headerSkinTexture = this.atlas.getTexture("header-background-skin0000");
			this.panelHeaderSkinTexture = this.atlas.getTexture("panel-header-background-skin0000");

			this.panelBackgroundSkinTexture = this.atlas.getTexture("panel-background-skin0000");
			this.popUpBackgroundSkinTexture = this.atlas.getTexture("pop-up-background-skin0000");
			this.dangerPopUpBackgroundSkinTexture = this.atlas.getTexture("danger-pop-up-background-skin0000");
			this.calloutTopArrowSkinTexture = this.atlas.getTexture("callout-top-arrow-skin0000");
			this.calloutBottomArrowSkinTexture = this.atlas.getTexture("callout-bottom-arrow-skin0000");
			this.calloutLeftArrowSkinTexture = this.atlas.getTexture("callout-left-arrow-skin0000");
			this.calloutRightArrowSkinTexture = this.atlas.getTexture("callout-right-arrow-skin0000");
			this.dangerCalloutTopArrowSkinTexture = this.atlas.getTexture("danger-callout-top-arrow-skin0000");
			this.dangerCalloutBottomArrowSkinTexture = this.atlas.getTexture("danger-callout-bottom-arrow-skin0000");
			this.dangerCalloutLeftArrowSkinTexture = this.atlas.getTexture("danger-callout-left-arrow-skin0000");
			this.dangerCalloutRightArrowSkinTexture = this.atlas.getTexture("danger-callout-right-arrow-skin0000");

			this.checkIconTexture = this.atlas.getTexture("check-up-icon0000");
			this.checkDisabledIconTexture = this.atlas.getTexture("check-disabled-icon0000");
			this.checkSelectedIconTexture = this.atlas.getTexture("check-selected-up-icon0000");
			this.checkSelectedDisabledIconTexture = this.atlas.getTexture("check-selected-disabled-icon0000");

			this.radioIconTexture = this.atlas.getTexture("radio-up-icon0000");
			this.radioDisabledIconTexture = this.atlas.getTexture("radio-disabled-icon0000");
			this.radioSelectedIconTexture = this.atlas.getTexture("radio-selected-up-icon0000");
			this.radioSelectedDisabledIconTexture = this.atlas.getTexture("radio-selected-disabled-icon0000");

			this.pageIndicatorNormalSkinTexture = this.atlas.getTexture("page-indicator-symbol0000");
			this.pageIndicatorSelectedSkinTexture = this.atlas.getTexture("page-indicator-selected-symbol0000");

			this.playPauseButtonPlayUpIconTexture = this.atlas.getTexture("play-pause-toggle-button-play-up-icon0000");
			this.playPauseButtonPauseUpIconTexture = this.atlas.getTexture("play-pause-toggle-button-pause-up-icon0000");
			this.overlayPlayPauseButtonPlayUpIconTexture = this.atlas.getTexture("overlay-play-pause-toggle-button-play-up-icon0000");
			this.fullScreenToggleButtonEnterUpIconTexture = this.atlas.getTexture("full-screen-toggle-button-enter-up-icon0000");
			this.fullScreenToggleButtonExitUpIconTexture = this.atlas.getTexture("full-screen-toggle-button-exit-up-icon0000");
			this.muteToggleButtonMutedUpIconTexture = this.atlas.getTexture("mute-toggle-button-muted-up-icon0000");
			this.muteToggleButtonLoudUpIconTexture = this.atlas.getTexture("mute-toggle-button-loud-up-icon0000");
			this.volumeSliderMinimumTrackSkinTexture = this.atlas.getTexture("volume-slider-minimum-track-skin0000");
			this.volumeSliderMaximumTrackSkinTexture = this.atlas.getTexture("volume-slider-maximum-track-skin0000");
			this.seekSliderProgressSkinTexture = this.atlas.getTexture("seek-slider-progress-skin0000");

			this.listDrillDownAccessoryTexture = this.atlas.getTexture("list-accessory-drill-down-icon0000");
		}

		/**
		 * Initializes font sizes and formats.
		 */
		protected function initializeFonts():void
		{
			this.fontSize = 12;
			this.largeFontSize = 16;
			this.smallFontSize = 8;

			this.primaryTextFormat = new BitmapFontTextFormat(FONT_NAME, this.fontSize, PRIMARY_TEXT_COLOR);
			this.disabledTextFormat = new BitmapFontTextFormat(FONT_NAME, this.fontSize, DISABLED_TEXT_COLOR);
			this.centeredTextFormat = new BitmapFontTextFormat(FONT_NAME, this.fontSize, PRIMARY_TEXT_COLOR, TextFormatAlign.CENTER);
			this.centeredDisabledTextFormat = new BitmapFontTextFormat(FONT_NAME, this.fontSize, DISABLED_TEXT_COLOR, TextFormatAlign.CENTER);
			this.headingTextFormat = new BitmapFontTextFormat(FONT_NAME, this.largeFontSize, PRIMARY_TEXT_COLOR);
			this.headingDisabledTextFormat = new BitmapFontTextFormat(FONT_NAME, this.largeFontSize, DISABLED_TEXT_COLOR);
			this.detailTextFormat = new BitmapFontTextFormat(FONT_NAME, this.smallFontSize, PRIMARY_TEXT_COLOR);
			this.detailDisabledTextFormat = new BitmapFontTextFormat(FONT_NAME, this.smallFontSize, DISABLED_TEXT_COLOR);
			this.dangerTextFormat = new BitmapFontTextFormat(FONT_NAME, this.fontSize, DANGER_TEXT_COLOR);

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
			this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(Button.DEFAULT_CHILD_STYLE_NAME_LABEL, this.setButtonLabelStyles);
			this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(THEME_STYLE_NAME_DANGER_TEXT_RENDERER, this.setDangerTextRendererStyles);

			//button group
			this.getStyleProviderForClass(ButtonGroup).defaultStyleFunction = this.setButtonGroupStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ButtonGroup.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setButtonGroupButtonStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ButtonGroup.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setButtonGroupButtonStyles);

			//callout
			this.getStyleProviderForClass(Callout).defaultStyleFunction = this.setCalloutStyles;

			//check
			this.getStyleProviderForClass(Check).defaultStyleFunction = this.setCheckStyles;
			this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(Check.DEFAULT_CHILD_STYLE_NAME_LABEL, this.setCheckLabelStyles);

			//date time spinner
			this.getStyleProviderForClass(SpinnerList).setFunctionForStyleName(DateTimeSpinner.DEFAULT_CHILD_STYLE_NAME_LIST, this.setDateTimeSpinnerListStyles);
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_DATE_TIME_SPINNER_LIST_ITEM_RENDERER, this.setDateTimeSpinnerListItemRendererStyles);

			//drawers
			this.getStyleProviderForClass(Drawers).defaultStyleFunction = this.setDrawersStyles;

			//grouped list (see also: item renderers)
			this.getStyleProviderForClass(GroupedList).defaultStyleFunction = this.setGroupedListStyles;
			this.getStyleProviderForClass(GroupedList).setFunctionForStyleName(GroupedList.ALTERNATE_STYLE_NAME_INSET_GROUPED_LIST, this.setInsetGroupedListStyles);

			//header
			this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;
			this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(Header.DEFAULT_CHILD_STYLE_NAME_TITLE, this.setHeaderTitleStyles);

			//item renderers for lists
			this.getStyleProviderForClass(DefaultListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(DefaultListItemRenderer.ALTERNATE_STYLE_NAME_DRILL_DOWN, this.setDrillDownItemRendererStyles);
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(DefaultListItemRenderer.ALTERNATE_STYLE_NAME_CHECK, this.setCheckItemRendererStyles);
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER, this.setSpinnerListItemRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(DefaultGroupedListItemRenderer.ALTERNATE_STYLE_NAME_DRILL_DOWN, this.setDrillDownItemRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(DefaultGroupedListItemRenderer.ALTERNATE_STYLE_NAME_CHECK, this.setCheckItemRendererStyles);
			this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_LABEL, this.setItemRendererLabelStyles);
			this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL, this.setItemRendererAccessoryLabelStyles);
			this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_ICON_LABEL, this.setItemRendererIconLabelStyles);
			this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER_LABEL, this.setSpinnerListItemRendererLabelStyles);

			//header and footer renderers for grouped list
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).defaultStyleFunction = this.setGroupedListHeaderOrFooterRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_HEADER_RENDERER, this.setInsetGroupedListHeaderOrFooterRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FOOTER_RENDERER, this.setInsetGroupedListHeaderOrFooterRendererStyles);
			this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(DefaultGroupedListHeaderOrFooterRenderer.DEFAULT_CHILD_STYLE_NAME_CONTENT_LABEL, this.setGroupedListHeaderOrFooterRendererContentLabelStyles);

			//label
			this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_STYLE_NAME_HEADING, this.setHeadingLabelStyles);
			this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_STYLE_NAME_DETAIL, this.setDetailLabelStyles);
			this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(Label.DEFAULT_CHILD_STYLE_NAME_TEXT_RENDERER, this.setLabelTextRendererStyles);
			this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(THEME_STYLE_NAME_HEADING_LABEL_TEXT_RENDERER, this.setHeadingLabelTextRendererStyles);
			this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(THEME_STYLE_NAME_DETAIL_LABEL_TEXT_RENDERER, this.setDetailLabelTextRendererStyles);

			//layout group
			this.getStyleProviderForClass(LayoutGroup).setFunctionForStyleName(LayoutGroup.ALTERNATE_STYLE_NAME_TOOLBAR, this.setToolbarLayoutGroupStyles);

			//list (see also: item renderers)
			this.getStyleProviderForClass(List).defaultStyleFunction = this.setListStyles;

			//numeric stepper
			this.getStyleProviderForClass(NumericStepper).defaultStyleFunction = this.setNumericStepperStyles;
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_TEXT_INPUT, this.setNumericStepperTextInputStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON, this.setNumericStepperButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON, this.setNumericStepperButtonStyles);
			this.getStyleProviderForClass(BitmapFontTextEditor).setFunctionForStyleName(THEME_STYLE_NAME_NUMERIC_STEPPER_TEXT_INPUT_TEXT_EDITOR, this.setNumericStepperTextInputTextEditorStyles);

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
			this.getStyleProviderForClass(List).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_LIST, this.setPickerListPopUpListStyles);
			
			//progress bar
			this.getStyleProviderForClass(ProgressBar).defaultStyleFunction = this.setProgressBarStyles;

			//radio
			this.getStyleProviderForClass(Radio).defaultStyleFunction = this.setRadioStyles;
			this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(Radio.DEFAULT_CHILD_STYLE_NAME_LABEL, this.setRadioLabelStyles);

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
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(TabBar.DEFAULT_CHILD_STYLE_NAME_TAB, this.setTabStyles);

			//text input
			this.getStyleProviderForClass(TextInput).defaultStyleFunction = this.setTextInputStyles;
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName(TextInput.ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT, this.setSearchTextInputStyles);
			this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(TextInput.DEFAULT_CHILD_STYLE_NAME_PROMPT, this.setTextInputPromptStyles);
			this.getStyleProviderForClass(StageTextTextEditor).setFunctionForStyleName(TextInput.DEFAULT_CHILD_STYLE_NAME_TEXT_EDITOR, this.setTextInputTextEditorStyles);
			this.getStyleProviderForClass(TextCallout).setFunctionForStyleName(TextInput.DEFAULT_CHILD_STYLE_NAME_ERROR_CALLOUT, this.setTextInputErrorCalloutStyles);

			//text area
			this.getStyleProviderForClass(TextArea).defaultStyleFunction = this.setTextAreaStyles;
			this.getStyleProviderForClass(TextFieldTextEditorViewPort).setFunctionForStyleName(TextArea.DEFAULT_CHILD_STYLE_NAME_TEXT_EDITOR, this.setTextAreaTextEditorStyles);
			this.getStyleProviderForClass(TextCallout).setFunctionForStyleName(TextArea.DEFAULT_CHILD_STYLE_NAME_ERROR_CALLOUT, this.setTextAreaErrorCalloutStyles);

			//text callout
			this.getStyleProviderForClass(TextCallout).defaultStyleFunction = this.setTextCalloutStyles;
			this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(TextCallout.DEFAULT_CHILD_STYLE_NAME_TEXT_RENDERER, this.setTextCalloutTextRendererStyles);

			//toggle button
			this.getStyleProviderForClass(ToggleButton).defaultStyleFunction = this.setButtonStyles;
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);

			//toggle switch
			this.getStyleProviderForClass(ToggleSwitch).defaultStyleFunction = this.setToggleSwitchStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setToggleSwitchThumbStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setToggleSwitchThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_ON_TRACK, this.setToggleSwitchOnTrackStyles);
			this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_ON_LABEL, this.setToggleSwitchOnLabelStyles);
			this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_OFF_LABEL, this.setToggleSwitchOffLabelStyles);


			//media controls
			this.getStyleProviderForClass(VideoPlayer).defaultStyleFunction = this.setVideoPlayerStyles;

			//play/pause toggle button
			this.getStyleProviderForClass(PlayPauseToggleButton).defaultStyleFunction = this.setPlayPauseToggleButtonStyles;
			this.getStyleProviderForClass(PlayPauseToggleButton).setFunctionForStyleName(PlayPauseToggleButton.ALTERNATE_STYLE_NAME_OVERLAY_PLAY_PAUSE_TOGGLE_BUTTON, this.setOverlayPlayPauseToggleButtonStyles);

			//full screen toggle button
			this.getStyleProviderForClass(FullScreenToggleButton).defaultStyleFunction = this.setFullScreenToggleButtonStyles;

			//mute toggle button
			this.getStyleProviderForClass(MuteToggleButton).defaultStyleFunction = this.setMuteToggleButtonStyles;

			//seek slider
			this.getStyleProviderForClass(SeekSlider).defaultStyleFunction = this.setSeekSliderStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(SeekSlider.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setSliderThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(SeekSlider.DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK, this.setHorizontalSliderMinimumTrackStyles);

			//volume slider
			this.getStyleProviderForClass(VolumeSlider).defaultStyleFunction = this.setVolumeSliderStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(VolumeSlider.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setVolumeSliderThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(VolumeSlider.DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK, this.setVolumeSliderMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(VolumeSlider.DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK, this.setVolumeSliderMaximumTrackStyles);

		}

		protected function pageIndicatorNormalSymbolFactory():DisplayObject
		{
			return new Image(this.pageIndicatorNormalSkinTexture);
		}

		protected function pageIndicatorSelectedSymbolFactory():DisplayObject
		{
			return new Image(this.pageIndicatorSelectedSkinTexture);
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

			var backgroundSkin:Image = new Image(this.popUpBackgroundSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			backgroundSkin.width = this.controlSize;
			backgroundSkin.height = this.controlSize;
			alert.backgroundSkin = backgroundSkin;

			alert.paddingTop = this.gutterSize;
			alert.paddingRight = this.gutterSize;
			alert.paddingBottom = this.smallGutterSize;
			alert.paddingLeft = this.gutterSize;
			alert.outerPadding = this.borderSize;
			alert.outerPaddingBottom = this.borderSize + this.dropShadowSize;
			alert.outerPaddingRight = this.borderSize + this.dropShadowSize;
			alert.gap = this.smallGutterSize;
			alert.maxWidth = this.popUpFillSize;
			alert.maxHeight = this.popUpFillSize;
		}

		protected function setAlertButtonGroupStyles(group:ButtonGroup):void
		{
			group.direction = Direction.VERTICAL;
			group.horizontalAlign = HorizontalAlign.JUSTIFY;
			group.verticalAlign = VerticalAlign.JUSTIFY;
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
			button.paddingTop = this.smallGutterSize;
			button.paddingBottom = this.smallGutterSize;
			button.paddingLeft = this.gutterSize;
			button.paddingRight = this.gutterSize;
			button.gap = this.smallGutterSize;
			button.minGap = this.smallGutterSize;
			button.minWidth = this.smallControlSize;
			button.minHeight = this.smallControlSize;
			button.minTouchWidth = this.gridSize;
			button.minTouchHeight = this.gridSize;
		}

		protected function setButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				skin.selectedTexture = this.buttonSelectedSkinTexture;
				skin.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.buttonDownSkinTexture);
				skin.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.buttonSelectedDisabledSkinTexture);
			}
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			button.defaultSkin = skin;
			this.setBaseButtonStyles(button);
		}
		
		protected function setButtonLabelStyles(textRenderer:BitmapFontTextRenderer):void
		{
			textRenderer.textFormat = this.primaryTextFormat;
			textRenderer.disabledTextFormat = this.disabledTextFormat;
		}

		protected function setCallToActionButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonCallToActionUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			button.defaultSkin = skin;
			this.setBaseButtonStyles(button);
		}

		protected function setQuietButtonStyles(button:Button):void
		{
			var defaultSkin:Quad = new Quad(this.controlSize, this.controlSize, 0xff00ff);
			defaultSkin.alpha = 0;
			button.defaultSkin = defaultSkin;
			
			var otherSkin:ImageSkin = new ImageSkin(null);
			otherSkin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				otherSkin.selectedTexture = this.buttonSelectedSkinTexture;
				otherSkin.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.buttonDownSkinTexture);
				otherSkin.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.buttonSelectedDisabledSkinTexture);
				ToggleButton(button).defaultSelectedSkin = otherSkin;
				button.setSkinForState(ButtonState.DOWN_AND_SELECTED, otherSkin);
				button.setSkinForState(ButtonState.DISABLED_AND_SELECTED, otherSkin);
			}
			button.setSkinForState(ButtonState.DOWN, otherSkin);
			otherSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			otherSkin.width = this.controlSize;
			otherSkin.height = this.controlSize;
			this.setBaseButtonStyles(button);
		}

		protected function setDangerButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonDangerUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDangerDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			button.defaultSkin = skin;
			button.customLabelStyleName = THEME_STYLE_NAME_DANGER_TEXT_RENDERER;
			this.setBaseButtonStyles(button);
		}

		protected function setBackButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonBackUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonBackDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonBackDisabledSkinTexture);
			skin.scale9Grid = BACK_BUTTON_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			button.defaultSkin = skin;
			this.setBaseButtonStyles(button);
			button.minWidth = this.controlSize;
			button.height = this.controlSize;
			button.paddingLeft = 2 * this.gutterSize;
		}

		protected function setForwardButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonForwardUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonForwardDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonForwardDisabledSkinTexture);
			skin.scale9Grid = FORWARD_BUTTON_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			button.defaultSkin = skin;
			this.setBaseButtonStyles(button);
			button.minWidth = this.controlSize;
			button.height = this.controlSize;
			button.paddingRight = 2 * this.gutterSize;
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
			var skin:ImageSkin = new ImageSkin(this.buttonUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				skin.selectedTexture = this.buttonSelectedSkinTexture;
				skin.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.buttonDownSkinTexture);
				skin.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.buttonSelectedDisabledSkinTexture);
			}
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.gridSize;
			skin.height = this.gridSize;
			button.defaultSkin = skin;

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
			callout.padding = this.smallGutterSize;
			callout.paddingRight = this.gutterSize + this.dropShadowSize;
			callout.paddingBottom = this.gutterSize + this.dropShadowSize;
			
			var backgroundSkin:Image = new Image(this.popUpBackgroundSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			backgroundSkin.width = this.calloutBackgroundMinSize;
			backgroundSkin.height = this.calloutBackgroundMinSize;
			callout.backgroundSkin = backgroundSkin;

			var topArrowSkin:Image = new Image(this.calloutTopArrowSkinTexture);
			callout.topArrowSkin = topArrowSkin;
			callout.topArrowGap = this.calloutTopLeftArrowOverlapGapSize;

			var bottomArrowSkin:Image = new Image(this.calloutBottomArrowSkinTexture);
			callout.bottomArrowSkin = bottomArrowSkin;
			callout.bottomArrowGap = this.calloutBottomRightArrowOverlapGapSize;

			var leftArrowSkin:Image = new Image(this.calloutLeftArrowSkinTexture);
			callout.leftArrowSkin = leftArrowSkin;
			callout.leftArrowGap = this.calloutTopLeftArrowOverlapGapSize;

			var rightArrowSkin:Image = new Image(this.calloutRightArrowSkinTexture);
			callout.rightArrowSkin = rightArrowSkin;
			callout.rightArrowGap = this.calloutBottomRightArrowOverlapGapSize;
		}

		protected function setDangerCalloutStyles(callout:Callout):void
		{
			callout.padding = this.smallGutterSize;
			callout.paddingRight = this.gutterSize + this.dropShadowSize;
			callout.paddingBottom = this.gutterSize + this.dropShadowSize;

			var backgroundSkin:Image = new Image(this.dangerPopUpBackgroundSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			backgroundSkin.width = this.calloutBackgroundMinSize;
			backgroundSkin.height = this.calloutBackgroundMinSize;
			callout.backgroundSkin = backgroundSkin;

			var topArrowSkin:Image = new Image(this.dangerCalloutTopArrowSkinTexture);
			callout.topArrowSkin = topArrowSkin;
			callout.topArrowGap = this.calloutTopLeftArrowOverlapGapSize;

			var bottomArrowSkin:Image = new Image(this.dangerCalloutBottomArrowSkinTexture);
			callout.bottomArrowSkin = bottomArrowSkin;
			callout.bottomArrowGap = this.calloutBottomRightArrowOverlapGapSize;

			var leftArrowSkin:Image = new Image(this.dangerCalloutLeftArrowSkinTexture);
			callout.leftArrowSkin = leftArrowSkin;
			callout.leftArrowGap = this.calloutTopLeftArrowOverlapGapSize;

			var rightArrowSkin:Image = new Image(this.dangerCalloutRightArrowSkinTexture);
			callout.rightArrowSkin = rightArrowSkin;
			callout.rightArrowGap = this.calloutBottomRightArrowOverlapGapSize;
		}

	//-------------------------
	// Check
	//-------------------------

		protected function setCheckStyles(check:Check):void
		{
			var icon:ImageSkin = new ImageSkin(this.checkIconTexture);
			icon.selectedTexture = this.checkSelectedIconTexture;
			icon.setTextureForState(ButtonState.DISABLED, this.checkDisabledIconTexture);
			icon.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.checkSelectedDisabledIconTexture);
			check.defaultIcon = icon;

			check.gap = this.smallGutterSize;
			check.minWidth = this.controlSize;
			check.minHeight = this.controlSize;
			check.minTouchWidth = this.gridSize;
			check.minTouchHeight = this.gridSize;
			check.horizontalAlign = HorizontalAlign.LEFT;
			check.verticalAlign = VerticalAlign.MIDDLE;
		}
		
		protected function setCheckLabelStyles(textRenderer:BitmapFontTextRenderer):void
		{
			textRenderer.textFormat = this.primaryTextFormat;
			textRenderer.disabledTextFormat = this.disabledTextFormat;
		}

	//-------------------------
	// DateTimeSpinner
	//-------------------------

		protected function setDateTimeSpinnerListStyles(list:SpinnerList):void
		{
			this.setSpinnerListStyles(list);
			list.customItemRendererStyleName = THEME_STYLE_NAME_DATE_TIME_SPINNER_LIST_ITEM_RENDERER;
		}

		protected function setDateTimeSpinnerListItemRendererStyles(itemRenderer:DefaultListItemRenderer):void
		{
			this.setSpinnerListItemRendererStyles(itemRenderer);
			itemRenderer.accessoryPosition = RelativePosition.LEFT;
			itemRenderer.gap = this.gutterSize;
			itemRenderer.minGap = this.gutterSize;
			itemRenderer.accessoryGap = this.gutterSize;
			itemRenderer.minAccessoryGap = this.gutterSize;
		}

	//-------------------------
	// Drawers
	//-------------------------

		protected function setDrawersStyles(drawers:Drawers):void
		{
			var overlaySkin:Quad = new Quad(10, 10, MODAL_OVERLAY_COLOR);
			overlaySkin.alpha = MODAL_OVERLAY_ALPHA;
			drawers.overlaySkin = overlaySkin;

			var topDrawerDivider:Quad = new Quad(this.borderSize, this.borderSize, DRAWERS_DIVIDER_COLOR);
			drawers.topDrawerDivider = topDrawerDivider;

			var rightDrawerDivider:Quad = new Quad(this.borderSize, this.borderSize, DRAWERS_DIVIDER_COLOR);
			drawers.rightDrawerDivider = rightDrawerDivider;

			var bottomDrawerDivider:Quad = new Quad(this.borderSize, this.borderSize, DRAWERS_DIVIDER_COLOR);
			drawers.bottomDrawerDivider = bottomDrawerDivider;

			var leftDrawerDivider:Quad = new Quad(this.borderSize, this.borderSize, DRAWERS_DIVIDER_COLOR);
			drawers.leftDrawerDivider = leftDrawerDivider;
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

			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;
			renderer.paddingRight = this.gutterSize;
		}

		protected function setGroupedListHeaderOrFooterRendererContentLabelStyles(textRenderer:BitmapFontTextRenderer):void
		{
			textRenderer.textFormat = this.primaryTextFormat;
			textRenderer.disabledTextFormat = this.disabledTextFormat;
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
			layout.horizontalAlign = HorizontalAlign.JUSTIFY;
			layout.verticalAlign = VerticalAlign.TOP;
			list.layout = layout;
		}

		protected function setInsetGroupedListHeaderOrFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;
			renderer.paddingRight = this.gutterSize;
			renderer.minWidth = this.controlSize;
			renderer.minHeight = this.controlSize;
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

			var backgroundSkin:Image = new Image(this.headerSkinTexture);
			backgroundSkin.scale9Grid = HEADER_SCALE_9_GRID;
			backgroundSkin.width = this.gridSize;
			backgroundSkin.height = this.gridSize;
			header.backgroundSkin = backgroundSkin;
		}

		protected function setHeaderTitleStyles(textRenderer:BitmapFontTextRenderer):void
		{
			textRenderer.textFormat = this.primaryTextFormat;
			textRenderer.disabledTextFormat = this.disabledTextFormat;
		}

	//-------------------------
	// Label
	//-------------------------

		protected function setLabelTextRendererStyles(textRenderer:BitmapFontTextRenderer):void
		{
			textRenderer.textFormat = this.primaryTextFormat;
			textRenderer.disabledTextFormat = this.disabledTextFormat;
		}

		protected function setHeadingLabelStyles(label:Label):void
		{
			label.customTextRendererStyleName = THEME_STYLE_NAME_HEADING_LABEL_TEXT_RENDERER;
		}

		protected function setHeadingLabelTextRendererStyles(textRenderer:BitmapFontTextRenderer):void
		{
			textRenderer.textFormat = this.headingTextFormat;
			textRenderer.disabledTextFormat = this.headingDisabledTextFormat;
		}

		protected function setDetailLabelStyles(label:Label):void
		{
			label.customTextRendererStyleName = THEME_STYLE_NAME_DETAIL_LABEL_TEXT_RENDERER;
		}

		protected function setDetailLabelTextRendererStyles(textRenderer:BitmapFontTextRenderer):void
		{
			textRenderer.textFormat = this.detailTextFormat;
			textRenderer.disabledTextFormat = this.detailDisabledTextFormat;
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
				layout.verticalAlign = VerticalAlign.MIDDLE;
				group.layout = layout;
			}

			group.minWidth = this.gridSize;
			group.minHeight = this.gridSize;

			var backgroundSkin:Image = new Image(this.headerSkinTexture);
			backgroundSkin.scale9Grid = HEADER_SCALE_9_GRID;
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
			var defaultSkin:Image = new Image(this.itemRendererUpSkinTexture);
			defaultSkin.scale9Grid = ITEM_RENDERER_SCALE_9_GRID;
			defaultSkin.width = this.gridSize;
			defaultSkin.height = this.gridSize;
			renderer.defaultSkin = defaultSkin;
			
			var otherSkin:ImageSkin = new ImageSkin(null);
			otherSkin.defaultTexture = this.itemRendererDownSkinTexture;
			otherSkin.selectedTexture = this.itemRendererSelectedUpSkinTexture;
			otherSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			otherSkin.width = this.gridSize;
			otherSkin.height = this.gridSize;
			renderer.defaultSelectedSkin = otherSkin;
			renderer.setSkinForState(ButtonState.DOWN, otherSkin);

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
			renderer.horizontalAlign = HorizontalAlign.LEFT;
			renderer.iconPosition = RelativePosition.LEFT;
			renderer.accessoryPosition = RelativePosition.RIGHT;
		}

		protected function setDrillDownItemRendererStyles(itemRenderer:BaseDefaultItemRenderer):void
		{
			this.setItemRendererStyles(itemRenderer);
			
			itemRenderer.itemHasAccessory = false;
			var defaultAccessory:ImageLoader = new ImageLoader();
			defaultAccessory.source = this.listDrillDownAccessoryTexture;
			itemRenderer.defaultAccessory = defaultAccessory;
		}

		protected function setCheckItemRendererStyles(itemRenderer:BaseDefaultItemRenderer):void
		{
			var defaultSkin:Image = new Image(this.itemRendererUpSkinTexture);
			defaultSkin.scale9Grid = ITEM_RENDERER_SCALE_9_GRID;
			defaultSkin.width = this.gridSize;
			defaultSkin.height = this.gridSize;
			itemRenderer.defaultSkin = defaultSkin;

			var otherSkin:Image = new Image(this.itemRendererDownSkinTexture);
			otherSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			otherSkin.width = this.gridSize;
			otherSkin.height = this.gridSize;
			itemRenderer.setSkinForState(ButtonState.DOWN, otherSkin);

			var defaultSelectedIcon:ImageLoader = new ImageLoader();
			defaultSelectedIcon.source = this.checkItemRendererSelectedIconTexture;
			itemRenderer.defaultSelectedIcon = defaultSelectedIcon;

			var frame:Rectangle = this.checkItemRendererSelectedIconTexture.frame;
			if(frame)
			{
				var iconWidth:Number = frame.width;
				var iconHeight:Number = frame.height;
			}
			else
			{
				iconWidth = this.checkItemRendererSelectedIconTexture.width;
				iconHeight = this.checkItemRendererSelectedIconTexture.height;
			}
			var defaultIcon:Quad = new Quad(iconWidth, iconHeight, 0xff00ff);
			defaultIcon.alpha = 0;
			itemRenderer.defaultIcon = defaultIcon;
			
			itemRenderer.itemHasIcon = false;

			itemRenderer.paddingTop = this.smallGutterSize;
			itemRenderer.paddingBottom = this.smallGutterSize;
			itemRenderer.paddingLeft = this.gutterSize;
			itemRenderer.paddingRight = this.gutterSize;
			itemRenderer.gap = Number.POSITIVE_INFINITY;
			itemRenderer.minGap = this.gutterSize;
			itemRenderer.iconPosition = RelativePosition.RIGHT;
			itemRenderer.horizontalAlign = HorizontalAlign.LEFT;
			itemRenderer.accessoryGap = this.smallGutterSize;
			itemRenderer.minAccessoryGap = this.smallGutterSize;
			itemRenderer.accessoryPosition = RelativePosition.BOTTOM;
			itemRenderer.layoutOrder = ItemRendererLayoutOrder.LABEL_ACCESSORY_ICON;
			itemRenderer.minWidth = this.gridSize;
			itemRenderer.minHeight = this.gridSize;
			itemRenderer.minTouchWidth = this.gridSize;
			itemRenderer.minTouchHeight = this.gridSize;
		}
		
		protected function setItemRendererLabelStyles(textRenderer:BitmapFontTextRenderer):void
		{
			textRenderer.textFormat = this.primaryTextFormat;
			textRenderer.disabledTextFormat = this.disabledTextFormat;
		}

		protected function setItemRendererAccessoryLabelStyles(textRenderer:BitmapFontTextRenderer):void
		{
			textRenderer.textFormat = this.primaryTextFormat;
			textRenderer.disabledTextFormat = this.disabledTextFormat;
		}

		protected function setItemRendererIconLabelStyles(textRenderer:BitmapFontTextRenderer):void
		{
			textRenderer.textFormat = this.primaryTextFormat;
			textRenderer.disabledTextFormat = this.disabledTextFormat;
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
			input.isSelectable = false;
			input.textEditorFactory = numericStepperTextEditorFactory;
			input.customTextEditorStyleName = THEME_STYLE_NAME_NUMERIC_STEPPER_TEXT_INPUT_TEXT_EDITOR;

			var skin:ImageSkin = new ImageSkin(this.insetBackgroundSkinTexture);
			skin.setTextureForState(TextInputState.DISABLED, this.insetBackgroundDisabledSkinTexture);
			skin.setTextureForState(TextInputState.FOCUSED, this.insetBackgroundFocusedSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.gridSize;
			skin.height = this.controlSize;
			input.backgroundSkin = skin;
		}
		
		protected function setNumericStepperTextInputTextEditorStyles(textEditor:BitmapFontTextEditor):void
		{
			textEditor.textFormat = this.centeredTextFormat;
			textEditor.disabledTextFormat = this.centeredDisabledTextFormat;
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

			var backgroundSkin:Image = new Image(this.panelBackgroundSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			backgroundSkin.width = this.smallControlSize;
			backgroundSkin.height = this.smallControlSize;
			panel.backgroundSkin = backgroundSkin;
			
			panel.outerPadding = this.borderSize;
			panel.padding = this.smallGutterSize;
		}

		protected function setPanelHeaderStyles(header:Header):void
		{
			header.minWidth = this.gridSize;
			header.minHeight = this.gridSize;
			header.padding = this.smallGutterSize;
			header.gap = this.smallGutterSize;
			header.titleGap = this.smallGutterSize;

			var backgroundSkin:Image = new Image(this.panelHeaderSkinTexture);
			backgroundSkin.scale9Grid = HEADER_SCALE_9_GRID;
			backgroundSkin.width = this.gridSize;
			backgroundSkin.height = this.gridSize;
			header.backgroundSkin = backgroundSkin;
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
			list.toggleButtonOnOpenAndClose = true;
			list.buttonFactory = pickerListButtonFactory;
			if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				list.popUpContentManager = new CalloutPopUpContentManager();
			}
			else
			{
				list.listFactory = pickerListSpinnerListFactory;
				list.popUpContentManager = new BottomDrawerPopUpContentManager();
			}
		}

		protected function setPickerListPopUpListStyles(list:List):void
		{
			list.customItemRendererStyleName = DefaultListItemRenderer.ALTERNATE_STYLE_NAME_CHECK;
			if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				list.minWidth = this.popUpFillSize;
				list.maxHeight = this.popUpFillSize;
			}
			else //phone
			{
				//the pop-up list should be a SpinnerList in this case, but we
				//should provide a reasonable fallback skin if the listFactory
				//on the PickerList returns a List instead. we don't want the
				//List to be too big for the BottomDrawerPopUpContentManager

				var layout:VerticalLayout = new VerticalLayout();
				layout.horizontalAlign = HorizontalAlign.JUSTIFY;
				layout.requestedRowCount = 4;
				list.layout = layout;
			}
		}

		protected function setPickerListButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			button.defaultSkin = skin;

			var icon:ImageSkin = new ImageSkin(this.pickerListButtonIconUpTexture);
			icon.disabledTexture = this.pickerListButtonIconDisabledTexture;
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				icon.selectedTexture = this.pickerListButtonIconSelectedTexture;
			}
			button.defaultIcon = icon;

			this.setBaseButtonStyles(button);

			button.gap = Number.POSITIVE_INFINITY; //fill as completely as possible
			button.minGap = this.gutterSize;
			button.iconPosition = RelativePosition.RIGHT;
			button.horizontalAlign = HorizontalAlign.LEFT;
		}

	//-------------------------
	// ProgressBar
	//-------------------------

		protected function setProgressBarStyles(progress:ProgressBar):void
		{
			var backgroundSkin:Image = new Image(this.insetBackgroundSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			if(progress.direction == Direction.VERTICAL)
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

			var backgroundDisabledSkin:Image = new Image(this.insetBackgroundDisabledSkinTexture);
			backgroundDisabledSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			if(progress.direction == Direction.VERTICAL)
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

			var fillSkin:Image = new Image(this.buttonUpSkinTexture);
			fillSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			if(progress.direction == Direction.VERTICAL)
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

			var fillDisabledSkin:Image = new Image(this.buttonDisabledSkinTexture);
			fillDisabledSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			if(progress.direction == Direction.VERTICAL)
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
			var icon:ImageSkin = new ImageSkin(this.radioIconTexture);
			icon.selectedTexture = this.radioSelectedIconTexture;
			icon.setTextureForState(ButtonState.DISABLED, this.radioDisabledIconTexture);
			icon.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.radioSelectedDisabledIconTexture);
			radio.defaultIcon = icon;

			radio.gap = this.smallGutterSize;
			radio.minWidth = this.controlSize;
			radio.minHeight = this.controlSize;
			radio.minTouchWidth = this.gridSize;
			radio.minTouchHeight = this.gridSize;
			radio.horizontalAlign = HorizontalAlign.LEFT;
			radio.verticalAlign = VerticalAlign.MIDDLE;
		}

		protected function setRadioLabelStyles(textRenderer:BitmapFontTextRenderer):void
		{
			textRenderer.textFormat = this.primaryTextFormat;
			textRenderer.disabledTextFormat = this.disabledTextFormat;
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

			var backgroundSkin:Image = new Image(this.headerSkinTexture);
			backgroundSkin.scale9Grid = HEADER_SCALE_9_GRID;
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
			var defaultSkin:Image = new Image(this.scrollBarThumbSkinTexture);
			defaultSkin.scale9Grid = SCROLLBAR_THUMB_SCALE_9_GRID;
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
			slider.trackLayoutMode = TrackLayoutMode.SINGLE;

			if(slider.direction == Direction.VERTICAL)
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
			var skin:ImageSkin = new ImageSkin(this.insetBackgroundSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.insetBackgroundDisabledSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.wideControlSize;
			skin.height = this.smallControlSize;
			track.defaultSkin = skin;

			track.minTouchHeight = this.gridSize;
			
			track.hasLabelTextRenderer = false;
		}

		protected function setVerticalSliderMinimumTrackStyles(track:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.insetBackgroundSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.insetBackgroundDisabledSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.smallControlSize;
			skin.height = this.wideControlSize;
			track.defaultSkin = skin;

			track.minTouchWidth = this.gridSize;

			track.hasLabelTextRenderer = false;
		}

		protected function setSliderThumbStyles(thumb:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.thumbSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.thumbDisabledSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.smallControlSize;
			skin.height = this.smallControlSize;
			thumb.defaultSkin = skin;
			
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
			
			var selectionOverlaySkin:Image = new Image(this.spinnerListSelectionOverlaySkinTexture);
			selectionOverlaySkin.scale9Grid = SPINNER_LIST_SELECTION_OVERLAY_SCALE9_GRID;
			list.selectionOverlaySkin = selectionOverlaySkin;
		}

		protected function setSpinnerListItemRendererStyles(renderer:BaseDefaultItemRenderer):void
		{
			renderer.customLabelStyleName = THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER_LABEL;
			renderer.customIconLabelStyleName = THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER_LABEL;
			renderer.customAccessoryLabelStyleName = THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER_LABEL;

			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;
			renderer.paddingRight = this.gutterSize;
			renderer.gap = Number.POSITIVE_INFINITY;
			renderer.minGap = this.gutterSize;
			renderer.iconPosition = RelativePosition.RIGHT;
			renderer.horizontalAlign = HorizontalAlign.LEFT;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.minAccessoryGap = this.gutterSize;
			renderer.accessoryPosition = RelativePosition.RIGHT;
			renderer.minWidth = this.gridSize;
			renderer.minHeight = this.gridSize;
			renderer.minTouchWidth = this.gridSize;
			renderer.minTouchHeight = this.gridSize;
			renderer.isQuickHitAreaEnabled = true;
		}
		
		protected function setSpinnerListItemRendererLabelStyles(textRenderer:BitmapFontTextRenderer):void
		{
			//if it's not selected, we don't want it to be highlighted, so we're
			//borrowing the less prominent disabled color
			textRenderer.textFormat = this.disabledTextFormat;
			textRenderer.selectedTextFormat = this.primaryTextFormat;
			textRenderer.disabledTextFormat = this.disabledTextFormat;
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
			var defaultSkin:ImageSkin = new ImageSkin(this.headerSkinTexture);
			defaultSkin.scale9Grid = HEADER_SCALE_9_GRID;
			defaultSkin.width = this.gridSize;
			defaultSkin.height = this.gridSize;
			tab.defaultSkin = defaultSkin;
			
			var otherSkin:ImageSkin = new ImageSkin(this.tabSelectedSkinTexture);
			otherSkin.setTextureForState(ButtonState.DOWN, this.tabDownSkinTexture);
			otherSkin.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.tabSelectedDisabledSkinTexture);
			otherSkin.scale9Grid = TAB_SCALE_9_GRID;
			otherSkin.width = this.gridSize;
			otherSkin.height = this.gridSize;
			tab.defaultSelectedSkin = otherSkin;
			tab.setSkinForState(ButtonState.DOWN, otherSkin);

			tab.iconPosition = RelativePosition.TOP;
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

			var skin:ImageSkin = new ImageSkin(this.insetBackgroundSkinTexture);
			skin.setTextureForState(TextInputState.DISABLED, this.insetBackgroundDisabledSkinTexture);
			skin.setTextureForState(TextInputState.FOCUSED, this.insetBackgroundFocusedSkinTexture);
			skin.setTextureForState(TextInputState.ERROR, this.insetBackgroundDangerSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.wideControlSize;
			skin.height = this.wideControlSize;
			textArea.backgroundSkin = skin;

			textArea.textEditorFactory = textAreaTextEditorFactory;
		}

		protected function setTextAreaTextEditorStyles(textEditor:TextFieldTextEditorViewPort):void
		{
			textEditor.textFormat = this.scrollTextTextFormat;
			textEditor.disabledTextFormat = this.scrollTextDisabledTextFormat;
			
			textEditor.padding = this.smallGutterSize;
		}

		protected function setTextAreaErrorCalloutStyles(callout:TextCallout):void
		{
			this.setDangerTextCalloutStyles(callout);
			callout.horizontalAlign = HorizontalAlign.LEFT;
			callout.verticalAlign = VerticalAlign.TOP;
		}

	//-------------------------
	// TextCallout
	//-------------------------

		protected function setTextCalloutStyles(callout:TextCallout):void
		{
			this.setCalloutStyles(callout);
		}

		protected function setDangerTextCalloutStyles(callout:TextCallout):void
		{
			this.setDangerCalloutStyles(callout);
			callout.customTextRendererStyleName = THEME_STYLE_NAME_DANGER_TEXT_RENDERER;
		}

		protected function setTextCalloutTextRendererStyles(textRenderer:BitmapFontTextRenderer):void
		{
			textRenderer.textFormat = this.primaryTextFormat;
		}

		protected function setDangerTextRendererStyles(textRenderer:BitmapFontTextRenderer):void
		{
			textRenderer.textFormat = this.dangerTextFormat;
		}

	//-------------------------
	// TextInput
	//-------------------------

		protected function setBaseTextInputStyles(input:TextInput):void
		{
			var skin:ImageSkin = new ImageSkin(this.insetBackgroundSkinTexture);
			skin.setTextureForState(TextInputState.DISABLED, this.insetBackgroundDisabledSkinTexture);
			skin.setTextureForState(TextInputState.FOCUSED, this.insetBackgroundFocusedSkinTexture);
			skin.setTextureForState(TextInputState.ERROR, this.insetBackgroundDangerSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.wideControlSize;
			skin.height = this.controlSize;
			input.backgroundSkin = skin;

			input.minWidth = this.controlSize;
			input.minHeight = this.controlSize;
			input.minTouchWidth = this.gridSize;
			input.minTouchHeight = this.gridSize;
			input.gap = this.smallGutterSize;
			input.padding = this.smallGutterSize;
		}

		protected function setTextInputStyles(input:TextInput):void
		{
			this.setBaseTextInputStyles(input);
		}

		protected function setSearchTextInputStyles(input:TextInput):void
		{
			this.setBaseTextInputStyles(input);

			var icon:ImageSkin = new ImageSkin(this.searchIconTexture);
			icon.disabledTexture = this.searchIconDisabledTexture;
			input.defaultIcon = icon;
		}
		
		protected function setTextInputTextEditorStyles(textEditor:StageTextTextEditor):void
		{
			textEditor.fontFamily = "_sans";
			textEditor.fontSize = this.fontSize;
			textEditor.color = PRIMARY_TEXT_COLOR;
			textEditor.disabledColor = DISABLED_TEXT_COLOR;
		}

		protected function setTextInputPromptStyles(textRenderer:BitmapFontTextRenderer):void
		{
			textRenderer.textFormat = this.primaryTextFormat;
			textRenderer.disabledTextFormat = this.disabledTextFormat;
		}

		protected function setTextInputErrorCalloutStyles(callout:TextCallout):void
		{
			this.setDangerTextCalloutStyles(callout);
			callout.horizontalAlign = HorizontalAlign.LEFT;
			callout.verticalAlign = VerticalAlign.TOP;
		}

	//-------------------------
	// ToggleSwitch
	//-------------------------

		protected function setToggleSwitchStyles(toggleSwitch:ToggleSwitch):void
		{
			toggleSwitch.trackLayoutMode = TrackLayoutMode.SINGLE;
		}
		
		protected function setToggleSwitchOnLabelStyles(textRenderer:BitmapFontTextRenderer):void
		{
			textRenderer.textFormat = this.primaryTextFormat;
			textRenderer.disabledTextFormat = this.disabledTextFormat;
		}

		protected function setToggleSwitchOffLabelStyles(textRenderer:BitmapFontTextRenderer):void
		{
			textRenderer.textFormat = this.primaryTextFormat;
			textRenderer.disabledTextFormat = this.disabledTextFormat;
		}

		protected function setToggleSwitchOnTrackStyles(track:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.insetBackgroundSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.insetBackgroundDisabledSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = Math.round(this.controlSize * 2.5);
			skin.height = this.controlSize;
			track.defaultSkin = skin;
			track.minTouchWidth = this.gridSize;
			track.minTouchHeight = this.gridSize;

			track.hasLabelTextRenderer = false;
		}

		protected function setToggleSwitchThumbStyles(thumb:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.thumbSkinTexture);
			skin.disabledTexture = this.thumbDisabledSkinTexture;
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			thumb.defaultSkin = skin;
			
			thumb.minTouchWidth = this.gridSize;
			thumb.minTouchHeight = this.gridSize;

			thumb.hasLabelTextRenderer = false;
		}

	//-------------------------
	// VideoPlayer
	//-------------------------

		protected function setVideoPlayerStyles(player:VideoPlayer):void
		{
			player.backgroundSkin = new Quad(1, 1, 0x000000);
		}

	//-------------------------
	// PlayPauseToggleButton
	//-------------------------

		protected function setPlayPauseToggleButtonStyles(button:PlayPauseToggleButton):void
		{
			var defaultSkin:Quad = new Quad(this.controlSize, this.controlSize, 0xff00ff);
			defaultSkin.alpha = 0;
			button.defaultSkin = defaultSkin;
			
			var otherSkin:ImageSkin = new ImageSkin(null);
			otherSkin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			otherSkin.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.buttonDownSkinTexture);
			otherSkin.width = this.controlSize;
			otherSkin.height = this.controlSize;
			button.setSkinForState(ButtonState.DOWN, otherSkin);
			button.setSkinForState(ButtonState.DOWN_AND_SELECTED, otherSkin);

			var icon:ImageSkin = new ImageSkin(this.playPauseButtonPlayUpIconTexture);
			icon.selectedTexture = this.playPauseButtonPauseUpIconTexture;
			icon.textureSmoothing = TextureSmoothing.NONE;
			button.defaultIcon = icon;

			button.hasLabelTextRenderer = false;

			button.padding = this.smallGutterSize;
			button.gap = this.smallGutterSize;
			button.minGap = this.smallGutterSize;
			button.minWidth = this.controlSize;
			button.minHeight = this.controlSize;
		}

		protected function setOverlayPlayPauseToggleButtonStyles(button:PlayPauseToggleButton):void
		{
			var icon:ImageSkin = new ImageSkin(null);
			icon.setTextureForState(ButtonState.UP, this.overlayPlayPauseButtonPlayUpIconTexture);
			icon.setTextureForState(ButtonState.HOVER, this.overlayPlayPauseButtonPlayUpIconTexture);
			button.defaultIcon = icon;

			button.hasLabelTextRenderer = false;

			var overlaySkin:Quad = new Quad(1, 1, VIDEO_OVERLAY_COLOR);
			overlaySkin.alpha = VIDEO_OVERLAY_ALPHA;
			button.upSkin = overlaySkin;
			button.hoverSkin = overlaySkin;

			//since the selected states don't have a skin, the minWidth and
			//minHeight values will ensure that the button doesn't resize!
			button.minWidth = this.overlayPlayPauseButtonPlayUpIconTexture.width;
			button.minHeight = this.overlayPlayPauseButtonPlayUpIconTexture.height;
		}

	//-------------------------
	// FullScreenToggleButton
	//-------------------------

		protected function setFullScreenToggleButtonStyles(button:FullScreenToggleButton):void
		{
			var defaultSkin:Quad = new Quad(this.controlSize, this.controlSize, 0xff00ff);
			defaultSkin.alpha = 0;
			button.defaultSkin = defaultSkin;

			var otherSkin:ImageSkin = new ImageSkin(null);
			otherSkin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			otherSkin.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.buttonDownSkinTexture);
			otherSkin.width = this.controlSize;
			otherSkin.height = this.controlSize;
			button.setSkinForState(ButtonState.DOWN, otherSkin);
			button.setSkinForState(ButtonState.DOWN_AND_SELECTED, otherSkin);

			var icon:ImageSkin = new ImageSkin(this.fullScreenToggleButtonEnterUpIconTexture);
			icon.selectedTexture = this.fullScreenToggleButtonExitUpIconTexture;
			icon.textureSmoothing = TextureSmoothing.NONE;
			button.defaultIcon = icon;

			button.hasLabelTextRenderer = false;

			button.padding = this.smallGutterSize;
			button.gap = this.smallGutterSize;
			button.minGap = this.smallGutterSize;
			button.minWidth = this.controlSize;
			button.minHeight = this.controlSize;
		}

	//-------------------------
	// MuteToggleButton
	//-------------------------

		protected function setMuteToggleButtonStyles(button:MuteToggleButton):void
		{
			var defaultSkin:Quad = new Quad(this.controlSize, this.controlSize, 0xff00ff);
			defaultSkin.alpha = 0;
			button.defaultSkin = defaultSkin;

			var otherSkin:ImageSkin = new ImageSkin(null);
			otherSkin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			otherSkin.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.buttonDownSkinTexture);
			otherSkin.width = this.controlSize;
			otherSkin.height = this.controlSize;
			button.setSkinForState(ButtonState.DOWN, otherSkin);
			button.setSkinForState(ButtonState.DOWN_AND_SELECTED, otherSkin);

			var icon:ImageSkin = new ImageSkin(this.muteToggleButtonLoudUpIconTexture);
			icon.selectedTexture = this.muteToggleButtonMutedUpIconTexture;
			icon.textureSmoothing = TextureSmoothing.NONE;
			button.defaultIcon = icon;

			button.hasLabelTextRenderer = false;
			button.showVolumeSliderOnHover = false;

			button.padding = this.smallGutterSize;
			button.gap = this.smallGutterSize;
			button.minGap = this.smallGutterSize;
			button.minWidth = this.controlSize;
			button.minHeight = this.controlSize;
		}

	//-------------------------
	// SeekSlider
	//-------------------------

		protected function setSeekSliderStyles(slider:SeekSlider):void
		{
			slider.direction = Direction.HORIZONTAL;
			slider.trackLayoutMode = TrackLayoutMode.SINGLE;
			slider.minWidth = this.controlSize;
			slider.minHeight = this.smallControlSize;
			
			var progressSkin:Image = new Image(this.seekSliderProgressSkinTexture);
			progressSkin.scale9Grid = SEEK_SLIDER_PROGRESS_SKIN_SCALE9_GRID;
			slider.progressSkin = progressSkin;
		}

	//-------------------------
	// VolumeSlider
	//-------------------------

		protected function setVolumeSliderStyles(slider:VolumeSlider):void
		{
			slider.direction = Direction.HORIZONTAL;
			slider.trackLayoutMode = TrackLayoutMode.SPLIT;
			slider.showThumb = false;
			slider.minWidth = this.volumeSliderMinimumTrackSkinTexture.width;
			slider.minHeight = this.volumeSliderMinimumTrackSkinTexture.height;
		}

		protected function setVolumeSliderThumbStyles(thumb:Button):void
		{
			var thumbSize:Number = 6;
			thumb.defaultSkin = new Quad(thumbSize, thumbSize);
			thumb.defaultSkin.width = 0;
			thumb.defaultSkin.height = 0;
			
			thumb.hasLabelTextRenderer = false;
		}

		protected function setVolumeSliderMinimumTrackStyles(track:Button):void
		{
			var defaultSkin:ImageLoader = new ImageLoader();
			defaultSkin.scaleContent = false;
			defaultSkin.source = this.volumeSliderMinimumTrackSkinTexture;
			track.defaultSkin = defaultSkin;

			track.hasLabelTextRenderer = false;

			track.minTouchHeight = this.gridSize;
		}

		protected function setVolumeSliderMaximumTrackStyles(track:Button):void
		{
			var defaultSkin:ImageLoader = new ImageLoader();
			defaultSkin.scaleContent = false;
			defaultSkin.horizontalAlign = HorizontalAlign.RIGHT;
			defaultSkin.source = this.volumeSliderMaximumTrackSkinTexture;
			track.defaultSkin = defaultSkin;
			
			track.hasLabelTextRenderer = false;

			track.minTouchHeight = this.gridSize;
		}
	}
}
