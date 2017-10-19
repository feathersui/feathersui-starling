/*
Copyright 2012-2017 Bowler Hat LLC

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
	import feathers.controls.StepperButtonLayoutMode;
	import feathers.controls.TabBar;
	import feathers.controls.TextArea;
	import feathers.controls.TextCallout;
	import feathers.controls.TextInput;
	import feathers.controls.TextInputState;
	import feathers.controls.ToggleButton;
	import feathers.controls.ToggleSwitch;
	import feathers.controls.TrackLayoutMode;
	import feathers.controls.Tree;
	import feathers.controls.popups.BottomDrawerPopUpContentManager;
	import feathers.controls.popups.CalloutPopUpContentManager;
	import feathers.controls.renderers.BaseDefaultItemRenderer;
	import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.DefaultTreeItemRenderer;
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

	import flash.geom.Rectangle;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;
	import starling.display.Stage;
	import feathers.core.FocusManager;
	import feathers.controls.DataGrid;
	import feathers.controls.renderers.DefaultDataGridCellRenderer;
	import feathers.controls.renderers.DefaultDataGridHeaderRenderer;

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
		 * The stack of fonts to use for controls that don't use embedded fonts.
		 */
		public static const FONT_NAME_STACK:String = "PF Ronda Seven,Roboto,Helvetica,Arial,_sans";

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

		/**
		 * @private
		 * The theme's custom style name for the item renderer of the
		 * SpinnerList in a DateTimeSpinner.
		 */
		protected static const THEME_STYLE_NAME_DATE_TIME_SPINNER_LIST_ITEM_RENDERER:String = "minimal-mobile-date-time-spinner-list-item-renderer";

		/**
		 * @private
		 * The theme's custom style name for item renderers in a PickerList.
		 */
		protected static const THEME_STYLE_NAME_TABLET_PICKER_LIST_ITEM_RENDERER:String = "minimal-mobile-tablet-picker-list-item-renderer";

		/**
		 * @private
		 * The theme's custom style name for a button in an Alert's button group.
		 */
		protected static const THEME_STYLE_NAME_ALERT_BUTTON_GROUP_BUTTON:String = "minimal-mobile-alert-button-group-button";

		protected static const FONT_TEXTURE_NAME:String = "pf_ronda_seven_0";

		protected static const DEFAULT_SCALE_9_GRID:Rectangle = new Rectangle(4, 4, 1, 1);
		protected static const SCROLLBAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(1, 1, 2, 2);
		protected static const ITEM_RENDERER_SCALE_9_GRID:Rectangle = new Rectangle(1, 3, 1, 1);
		protected static const TAB_SCALE_9_GRID:Rectangle = new Rectangle(11, 11, 1, 1);
		protected static const HEADER_SCALE_9_GRID:Rectangle = new Rectangle(1, 3, 1, 1);
		protected static const SPINNER_LIST_SELECTION_OVERLAY_SCALE9_GRID:Rectangle = new Rectangle(1, 3, 1, 1);
		protected static const SEEK_SLIDER_PROGRESS_SKIN_SCALE9_GRID:Rectangle = new Rectangle(0, 2, 2, 10);
		protected static const BACK_BUTTON_SCALE9_GRID:Rectangle = new Rectangle(16, 0, 1, 28);
		protected static const FORWARD_BUTTON_SCALE9_GRID:Rectangle = new Rectangle(3, 0, 1, 28);
		protected static const FOCUS_INDICATOR_SCALE_9_GRID:Rectangle = new Rectangle(5, 5, 1, 1);
		protected static const DATA_GRID_HEADER_DIVIDER_SCALE_9_GRID:Rectangle = new Rectangle(0, 1, 4, 3);
		protected static const DATA_GRID_HEADER_RENDERER_SCALE_9_GRID:Rectangle = new Rectangle(1, 1, 1, 1);
		protected static const DATA_GRID_COLUMN_RESIZE_SKIN_SCALE_9_GRID:Rectangle = new Rectangle(0, 1, 2, 3);
		protected static const DATA_GRID_COLUMN_DROP_INDICATOR_SCALE_9_GRID:Rectangle = new Rectangle(0, 1, 2, 3);

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
		protected static const DATA_GRID_COLUMN_OVERLAY_COLOR:uint = 0xeeeeee;
		protected static const DATA_GRID_COLUMN_OVERLAY_ALPHA:Number = 0.6;

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
		protected var fontSize:int = 12;

		/**
		 * A larger font size for headers.
		 */
		protected var largeFontSize:int = 16;

		/**
		 * A smaller font size for details.
		 */
		protected var smallFontSize:int = 8;

		/**
		 * The texture atlas that contains skins for this theme. This base class
		 * does not initialize this member variable. Subclasses are expected to
		 * load the assets somehow and set the <code>atlas</code> member
		 * variable before calling <code>initialize()</code>.
		 */
		protected var atlas:TextureAtlas;

		protected var focusIndicatorSkinTexture:Texture;

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

		protected var treeDisclosureOpenIconTexture:Texture;
		protected var treeDisclosureClosedIconTexture:Texture;

		protected var dataGridHeaderRendererSkinTexture:Texture;
		protected var dataGridHeaderDividerSkinTexture:Texture;
		protected var dataGridColumnResizeSkinTexture:Texture;
		protected var dataGridColumnDropIndicatorSkinTexture:Texture;
		protected var dataGridHeaderSortDescendingIconTexture:Texture;
		protected var dataGridHeaderSortAscendingIconTexture:Texture;
		protected var dataGridCellRendererDownSkinTexture:Texture;
		protected var dataGridCellRendererSelectedUpSkinTexture:Texture;

		/**
		 * The size, in pixels, of major regions in the grid. Used for sizing
		 * containers and larger UI controls.
		 */
		protected var gridSize:int = 44;

		/**
		 * The size, in pixels, of minor regions in the grid. Used for larger
		 * padding and gaps.
		 */
		protected var gutterSize:int = 11;

		/**
		 * The size, in pixels, of smaller padding and gaps within the major
		 * regions in the grid.
		 */
		protected var smallGutterSize:int = 6;

		/**
		 * The width, in pixels, of UI controls that span across multiple grid regions.
		 */
		protected var wideControlSize:int = 154;

		/**
		 * The size, in pixels, of a typical UI control.
		 */
		protected var controlSize:int = 30;

		/**
		 * The size, in pixels, of smaller UI controls.
		 */
		protected var smallControlSize:int = 16;

		/**
		 * The size, in pixels, of a UI control's border.
		 */
		protected var borderSize:int = 2;

		protected var simpleScrollBarThumbSize:int = 4;
		protected var calloutBackgroundMinSize:int = 6;
		protected var calloutBottomRightArrowOverlapGapSize:Number = -10.5;
		protected var calloutTopLeftArrowOverlapGapSize:int = -4;
		protected var popUpFillSize:int = 276;
		protected var dropShadowSize:int = 6;
		protected var focusPaddingSize:int = -4;
		protected var tabFocusPaddingSize:int = 4;

		protected var primaryFontStyles:TextFormat;
		protected var disabledFontStyles:TextFormat;
		protected var centeredFontStyles:TextFormat;
		protected var centeredDisabledFontStyles:TextFormat;
		protected var headingFontStyles:TextFormat;
		protected var headingDisabledFontStyles:TextFormat;
		protected var detailFontStyles:TextFormat;
		protected var detailDisabledFontStyles:TextFormat;
		protected var dangerFontStyles:TextFormat;
		protected var scrollTextFontStyles:TextFormat;
		protected var scrollTextDisabledFontStyles:TextFormat;

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
			TextField.unregisterCompositor(FONT_NAME);

			//don't forget to call super.dispose()!
			super.dispose();
		}

		/**
		 * Initializes the theme. Expected to be called by subclasses after the
		 * assets have been loaded and the skin texture atlas has been created.
		 */
		protected function initialize():void
		{
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
			this.starling.stage.color = BACKGROUND_COLOR;
			this.starling.nativeStage.color = BACKGROUND_COLOR;
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

			var stage:Stage = this.starling.stage;
			FocusManager.setEnabledForStage(stage, true);
		}

		/**
		 * Initializes the textures by extracting them from the atlas and
		 * setting up any scaling grids that are needed.
		 */
		protected function initializeTextures():void
		{
			this.focusIndicatorSkinTexture = this.atlas.getTexture("focus-indicator-skin0000");

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

			this.treeDisclosureOpenIconTexture = this.atlas.getTexture("tree-disclosure-open-icon0000");
			this.treeDisclosureClosedIconTexture = this.atlas.getTexture("tree-disclosure-closed-icon0000");

			this.dataGridHeaderRendererSkinTexture = this.atlas.getTexture("data-grid-header-renderer-skin0000");
			this.dataGridHeaderDividerSkinTexture = this.atlas.getTexture("data-grid-header-divider-skin0000");
			this.dataGridColumnResizeSkinTexture = this.atlas.getTexture("data-grid-column-resize-skin0000");
			this.dataGridColumnDropIndicatorSkinTexture = this.atlas.getTexture("data-grid-column-drop-indicator-skin0000");
			this.dataGridHeaderSortDescendingIconTexture = this.atlas.getTexture("data-grid-header-sort-descending-icon0000");
			this.dataGridHeaderSortAscendingIconTexture = this.atlas.getTexture("data-grid-header-sort-ascending-icon0000");
			this.dataGridCellRendererDownSkinTexture = this.atlas.getTexture("data-grid-cell-renderer-down-skin0000");
			this.dataGridCellRendererSelectedUpSkinTexture = this.atlas.getTexture("data-grid-cell-renderer-selected-up-skin0000");
		}

		/**
		 * Initializes font sizes and formats.
		 */
		protected function initializeFonts():void
		{
			this.primaryFontStyles = new TextFormat(FONT_NAME, this.fontSize, PRIMARY_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.disabledFontStyles = new TextFormat(FONT_NAME, this.fontSize, DISABLED_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.centeredFontStyles = new TextFormat(FONT_NAME, this.fontSize, PRIMARY_TEXT_COLOR, HorizontalAlign.CENTER, VerticalAlign.TOP);
			this.centeredDisabledFontStyles = new TextFormat(FONT_NAME, this.fontSize, DISABLED_TEXT_COLOR, HorizontalAlign.CENTER, VerticalAlign.TOP);
			this.headingFontStyles = new TextFormat(FONT_NAME, this.largeFontSize, PRIMARY_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.headingDisabledFontStyles = new TextFormat(FONT_NAME, this.largeFontSize, DISABLED_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.detailFontStyles = new TextFormat(FONT_NAME, this.smallFontSize, PRIMARY_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.detailDisabledFontStyles = new TextFormat(FONT_NAME, this.smallFontSize, DISABLED_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.dangerFontStyles = new TextFormat(FONT_NAME, this.fontSize, DANGER_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.scrollTextFontStyles = new TextFormat(FONT_NAME_STACK, this.fontSize, PRIMARY_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.scrollTextDisabledFontStyles = new TextFormat(FONT_NAME_STACK, this.fontSize, DISABLED_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
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
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_ALERT_BUTTON_GROUP_BUTTON, this.setAlertButtonGroupButtonStyles);

			//auto-complete
			this.getStyleProviderForClass(AutoComplete).defaultStyleFunction = this.setTextInputStyles;
			this.getStyleProviderForClass(List).setFunctionForStyleName(AutoComplete.DEFAULT_CHILD_STYLE_NAME_LIST, this.setDropDownListStyles);

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

			//data grid
			this.getStyleProviderForClass(DataGrid).defaultStyleFunction = this.setDataGridStyles;
			this.getStyleProviderForClass(DefaultDataGridHeaderRenderer).defaultStyleFunction = this.setDataGridHeaderRendererStyles;
			this.getStyleProviderForClass(DefaultDataGridCellRenderer).defaultStyleFunction = this.setDataGridCellRendererStyles;

			//date time spinner
			this.getStyleProviderForClass(DateTimeSpinner).defaultStyleFunction = this.setDateTimeSpinnerStyles;
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_DATE_TIME_SPINNER_LIST_ITEM_RENDERER, this.setDateTimeSpinnerListItemRendererStyles);

			//drawers
			this.getStyleProviderForClass(Drawers).defaultStyleFunction = this.setDrawersStyles;

			//grouped list (see also: item renderers)
			this.getStyleProviderForClass(GroupedList).defaultStyleFunction = this.setGroupedListStyles;
			this.getStyleProviderForClass(GroupedList).setFunctionForStyleName(GroupedList.ALTERNATE_STYLE_NAME_INSET_GROUPED_LIST, this.setInsetGroupedListStyles);

			//header
			this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;

			//item renderers for lists
			this.getStyleProviderForClass(DefaultListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(DefaultListItemRenderer.ALTERNATE_STYLE_NAME_DRILL_DOWN, this.setDrillDownItemRendererStyles);
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(DefaultListItemRenderer.ALTERNATE_STYLE_NAME_CHECK, this.setCheckItemRendererStyles);
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER, this.setSpinnerListItemRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(DefaultGroupedListItemRenderer.ALTERNATE_STYLE_NAME_DRILL_DOWN, this.setDrillDownItemRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(DefaultGroupedListItemRenderer.ALTERNATE_STYLE_NAME_CHECK, this.setCheckItemRendererStyles);

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
			this.getStyleProviderForClass(List).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_LIST, this.setPickerListPopUpListStyles);
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_TABLET_PICKER_LIST_ITEM_RENDERER, this.setTabletPickerListItemRendererStyles);
			
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
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(TabBar.DEFAULT_CHILD_STYLE_NAME_TAB, this.setTabStyles);

			//text input
			this.getStyleProviderForClass(TextInput).defaultStyleFunction = this.setTextInputStyles;
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName(TextInput.ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT, this.setSearchTextInputStyles);
			this.getStyleProviderForClass(TextCallout).setFunctionForStyleName(TextInput.DEFAULT_CHILD_STYLE_NAME_ERROR_CALLOUT, this.setTextInputErrorCalloutStyles);

			//text area
			this.getStyleProviderForClass(TextArea).defaultStyleFunction = this.setTextAreaStyles;
			this.getStyleProviderForClass(TextFieldTextEditorViewPort).setFunctionForStyleName(TextArea.DEFAULT_CHILD_STYLE_NAME_TEXT_EDITOR, this.setTextAreaTextEditorStyles);
			this.getStyleProviderForClass(TextCallout).setFunctionForStyleName(TextArea.DEFAULT_CHILD_STYLE_NAME_ERROR_CALLOUT, this.setTextAreaErrorCalloutStyles);

			//text callout
			this.getStyleProviderForClass(TextCallout).defaultStyleFunction = this.setTextCalloutStyles;

			//toggle button
			this.getStyleProviderForClass(ToggleButton).defaultStyleFunction = this.setButtonStyles;
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);

			//toggle switch
			this.getStyleProviderForClass(ToggleSwitch).defaultStyleFunction = this.setToggleSwitchStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setToggleSwitchThumbStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setToggleSwitchThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_ON_TRACK, this.setToggleSwitchOnTrackStyles);

			//tree
			this.getStyleProviderForClass(Tree).defaultStyleFunction = this.setTreeStyles;
			this.getStyleProviderForClass(DefaultTreeItemRenderer).defaultStyleFunction = this.setTreeItemRendererStyles;

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

		protected function dataGridHeaderDividerFactory():DisplayObject
		{
			var skin:ImageSkin = new ImageSkin(this.dataGridHeaderDividerSkinTexture);
			skin.scale9Grid = DATA_GRID_HEADER_DIVIDER_SCALE_9_GRID;
			return skin;
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

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			scroller.focusIndicatorSkin = focusIndicatorSkin;
			scroller.focusPadding = 0;
		}

		protected function setDropDownListStyles(list:List):void
		{
			var backgroundSkin:Quad = new Quad(this.gridSize, this.gridSize, LIST_BACKGROUND_COLOR);
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

			var backgroundSkin:Image = new Image(this.popUpBackgroundSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			backgroundSkin.width = this.controlSize;
			backgroundSkin.height = this.controlSize;
			alert.backgroundSkin = backgroundSkin;

			alert.fontStyles = this.primaryFontStyles.clone();
			alert.disabledFontStyles = this.disabledFontStyles.clone();

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
			group.customButtonStyleName = THEME_STYLE_NAME_ALERT_BUTTON_GROUP_BUTTON;
			group.direction = Direction.VERTICAL;
			group.horizontalAlign = HorizontalAlign.JUSTIFY;
			group.verticalAlign = VerticalAlign.JUSTIFY;
			group.gap = this.smallGutterSize;
			group.padding = this.smallGutterSize;
		}

		protected function setAlertButtonGroupButtonStyles(button:Button):void
		{
			this.setButtonGroupButtonStyles(button);
		}

	//-------------------------
	// Button
	//-------------------------

		protected function setBaseButtonStyles(button:Button):void
		{
			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			button.focusIndicatorSkin = focusIndicatorSkin;
			button.focusPadding = this.focusPaddingSize;

			button.paddingTop = this.smallGutterSize;
			button.paddingBottom = this.smallGutterSize;
			button.paddingLeft = this.gutterSize;
			button.paddingRight = this.gutterSize;
			button.gap = this.smallGutterSize;
			button.minGap = this.smallGutterSize;
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
			skin.minWidth = this.smallControlSize;
			skin.minHeight = this.smallControlSize;
			button.defaultSkin = skin;

			button.fontStyles = this.primaryFontStyles.clone();
			button.disabledFontStyles = this.disabledFontStyles.clone();

			this.setBaseButtonStyles(button);
		}

		protected function setCallToActionButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonCallToActionUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.smallControlSize;
			skin.minHeight = this.smallControlSize;
			button.defaultSkin = skin;

			button.fontStyles = this.primaryFontStyles.clone();
			button.disabledFontStyles = this.disabledFontStyles.clone();

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
			otherSkin.minWidth = this.controlSize;
			otherSkin.minHeight = this.controlSize;

			button.fontStyles = this.primaryFontStyles.clone();
			button.disabledFontStyles = this.disabledFontStyles.clone();

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
			skin.minWidth = this.controlSize;
			skin.minHeight = this.controlSize;
			button.defaultSkin = skin;

			button.fontStyles = this.dangerFontStyles.clone();
			button.disabledFontStyles = this.disabledFontStyles.clone();

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
			skin.minWidth = this.controlSize;
			skin.minHeight = this.controlSize;
			button.defaultSkin = skin;

			button.fontStyles = this.primaryFontStyles.clone();
			button.disabledFontStyles = this.disabledFontStyles.clone();

			this.setBaseButtonStyles(button);

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
			skin.minWidth = this.controlSize;
			skin.minHeight = this.controlSize;
			button.defaultSkin = skin;

			button.fontStyles = this.primaryFontStyles.clone();
			button.disabledFontStyles = this.disabledFontStyles.clone();

			this.setBaseButtonStyles(button);

			button.height = this.controlSize;
			button.paddingRight = 2 * this.gutterSize;
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
			skin.width = this.popUpFillSize;
			skin.height = this.gridSize;
			skin.minWidth = this.popUpFillSize;
			button.minHeight = this.gridSize;
			button.defaultSkin = skin;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			button.focusIndicatorSkin = focusIndicatorSkin;
			button.focusPadding = this.focusPaddingSize;

			button.fontStyles = this.primaryFontStyles.clone();
			button.disabledFontStyles = this.disabledFontStyles.clone();

			button.paddingTop = this.smallGutterSize;
			button.paddingBottom = this.smallGutterSize;
			button.paddingLeft = this.gutterSize;
			button.paddingRight = this.gutterSize;
			button.gap = this.smallGutterSize;
			button.minGap = this.smallGutterSize;
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
			var skin:Quad = new Quad(this.controlSize, this.controlSize);
			skin.alpha = 0;
			check.defaultSkin = skin;

			var icon:ImageSkin = new ImageSkin(this.checkIconTexture);
			icon.selectedTexture = this.checkSelectedIconTexture;
			icon.setTextureForState(ButtonState.DISABLED, this.checkDisabledIconTexture);
			icon.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.checkSelectedDisabledIconTexture);
			check.defaultIcon = icon;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			check.focusIndicatorSkin = focusIndicatorSkin;
			check.focusPaddingLeft = this.focusPaddingSize;
			check.focusPaddingRight = this.focusPaddingSize;

			check.fontStyles = this.primaryFontStyles.clone();
			check.disabledFontStyles = this.disabledFontStyles.clone();

			check.gap = this.smallGutterSize;
			check.horizontalAlign = HorizontalAlign.LEFT;
			check.verticalAlign = VerticalAlign.MIDDLE;
			check.minTouchWidth = this.gridSize;
			check.minTouchHeight = this.gridSize;
		}

	//-------------------------
	// DataGrid
	//-------------------------

		protected function setDataGridStyles(grid:DataGrid):void
		{
			this.setScrollerStyles(grid);

			grid.backgroundSkin = new Quad(this.gridSize, this.gridSize, LIST_BACKGROUND_COLOR);

			var columnDragOverlaySkin:Quad = new Quad(1, 1, DATA_GRID_COLUMN_OVERLAY_COLOR);
			columnDragOverlaySkin.alpha = DATA_GRID_COLUMN_OVERLAY_ALPHA;
			grid.columnDragOverlaySkin = columnDragOverlaySkin;

			var columnResizeSkin:ImageSkin = new ImageSkin(this.dataGridColumnResizeSkinTexture);
			columnResizeSkin.scale9Grid = DATA_GRID_COLUMN_RESIZE_SKIN_SCALE_9_GRID;
			grid.columnResizeSkin = columnResizeSkin;

			var columnDropIndicatorSkin:ImageSkin = new ImageSkin(this.dataGridColumnDropIndicatorSkinTexture);
			columnDropIndicatorSkin.scale9Grid = DATA_GRID_COLUMN_DROP_INDICATOR_SCALE_9_GRID;
			grid.columnDropIndicatorSkin = columnDropIndicatorSkin;

			grid.headerDividerFactory = this.dataGridHeaderDividerFactory;
		}

		protected function setDataGridHeaderRendererStyles(headerRenderer:DefaultDataGridHeaderRenderer):void
		{
			var backgroundSkin:ImageSkin = new ImageSkin(this.dataGridHeaderRendererSkinTexture);
			backgroundSkin.scale9Grid = DATA_GRID_HEADER_RENDERER_SCALE_9_GRID;
			backgroundSkin.width = this.controlSize;
			backgroundSkin.height = this.controlSize;
			backgroundSkin.minWidth = this.controlSize;
			backgroundSkin.minHeight = this.controlSize;
			headerRenderer.backgroundSkin = backgroundSkin;

			headerRenderer.sortAscendingIcon = new ImageSkin(this.dataGridHeaderSortAscendingIconTexture);
			headerRenderer.sortDescendingIcon = new ImageSkin(this.dataGridHeaderSortDescendingIconTexture);

			headerRenderer.fontStyles = this.primaryFontStyles.clone();
			headerRenderer.disabledFontStyles = this.disabledFontStyles.clone();

			headerRenderer.paddingTop = this.smallGutterSize;
			headerRenderer.paddingBottom = this.smallGutterSize;
			headerRenderer.paddingLeft = this.gutterSize;
			headerRenderer.paddingRight = this.gutterSize;
			//headerRenderer.gap = this.gutterSize;
			//headerRenderer.minGap = this.gutterSize;
		}

		protected function setDataGridCellRendererStyles(cellRenderer:DefaultDataGridCellRenderer):void
		{
			var defaultSkin:ImageSkin = new ImageSkin(this.itemRendererUpSkinTexture);
			defaultSkin.setTextureForState(ButtonState.DOWN, this.dataGridCellRendererDownSkinTexture);
			defaultSkin.selectedTexture = this.dataGridCellRendererSelectedUpSkinTexture;
			defaultSkin.scale9Grid = ITEM_RENDERER_SCALE_9_GRID;
			defaultSkin.width = this.gridSize;
			defaultSkin.height = this.gridSize;
			defaultSkin.minWidth = this.gridSize;
			defaultSkin.minHeight = this.gridSize;
			cellRenderer.defaultSkin = defaultSkin;

			cellRenderer.fontStyles = this.primaryFontStyles.clone();
			cellRenderer.disabledFontStyles = this.disabledFontStyles.clone();
			cellRenderer.iconLabelFontStyles = this.primaryFontStyles.clone();
			cellRenderer.iconLabelDisabledFontStyles = this.disabledFontStyles.clone();
			cellRenderer.accessoryLabelFontStyles = this.primaryFontStyles.clone();
			cellRenderer.accessoryLabelDisabledFontStyles = this.disabledFontStyles.clone();

			cellRenderer.paddingTop = this.smallGutterSize;
			cellRenderer.paddingBottom = this.smallGutterSize;
			cellRenderer.paddingLeft = this.gutterSize;
			cellRenderer.paddingRight = this.gutterSize;
			cellRenderer.gap = this.gutterSize;
			cellRenderer.minGap = this.gutterSize;
			cellRenderer.accessoryGap = Number.POSITIVE_INFINITY;
			cellRenderer.minAccessoryGap = this.gutterSize;
			cellRenderer.minTouchWidth = this.gridSize;
			cellRenderer.minTouchHeight = this.gridSize;
			cellRenderer.horizontalAlign = HorizontalAlign.LEFT;
			cellRenderer.iconPosition = RelativePosition.LEFT;
			cellRenderer.accessoryPosition = RelativePosition.RIGHT;
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

			renderer.fontStyles = this.primaryFontStyles.clone();
			renderer.disabledFontStyles = this.disabledFontStyles.clone();

			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;
			renderer.paddingRight = this.gutterSize;
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
			var skin:Quad = new Quad(this.controlSize, this.controlSize);
			skin.alpha = 0;
			renderer.backgroundSkin = skin;

			renderer.fontStyles = this.primaryFontStyles.clone();
			renderer.disabledFontStyles = this.disabledFontStyles.clone();

			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;
			renderer.paddingRight = this.gutterSize;
		}

	//-------------------------
	// Header
	//-------------------------

		protected function setHeaderStyles(header:Header):void
		{
			var backgroundSkin:ImageSkin = new ImageSkin(this.headerSkinTexture);
			backgroundSkin.scale9Grid = HEADER_SCALE_9_GRID;
			backgroundSkin.width = this.gridSize;
			backgroundSkin.height = this.gridSize;
			backgroundSkin.minWidth = this.gridSize;
			backgroundSkin.minHeight = this.gridSize;
			header.backgroundSkin = backgroundSkin;

			header.fontStyles = this.primaryFontStyles.clone();
			header.disabledFontStyles = this.disabledFontStyles.clone();

			header.padding = this.smallGutterSize;
			header.gap = this.smallGutterSize;
			header.titleGap = this.smallGutterSize;
		}

	//-------------------------
	// Label
	//-------------------------

		protected function setLabelStyles(label:Label):void
		{
			label.fontStyles = this.primaryFontStyles.clone();
			label.disabledFontStyles = this.disabledFontStyles.clone();
		}

		protected function setHeadingLabelStyles(label:Label):void
		{
			label.fontStyles = this.headingFontStyles.clone();
			label.disabledFontStyles = this.headingDisabledFontStyles.clone();
		}

		protected function setDetailLabelStyles(label:Label):void
		{
			label.fontStyles = this.detailFontStyles.clone();
			label.disabledFontStyles = this.detailDisabledFontStyles.clone();
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

			var backgroundSkin:ImageSkin = new ImageSkin(this.headerSkinTexture);
			backgroundSkin.scale9Grid = HEADER_SCALE_9_GRID;
			backgroundSkin.width = this.gridSize;
			backgroundSkin.height = this.gridSize;
			backgroundSkin.minWidth = this.gridSize;
			backgroundSkin.minHeight = this.gridSize;
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

		protected function setItemRendererStyles(itemRenderer:BaseDefaultItemRenderer):void
		{
			var defaultSkin:ImageSkin = new ImageSkin(this.itemRendererUpSkinTexture);
			defaultSkin.scale9Grid = ITEM_RENDERER_SCALE_9_GRID;
			defaultSkin.width = this.gridSize;
			defaultSkin.height = this.gridSize;
			defaultSkin.minWidth = this.gridSize;
			defaultSkin.minHeight = this.gridSize;
			itemRenderer.defaultSkin = defaultSkin;

			//different scale9Grid, so needs a separate skin
			var otherSkin:ImageSkin = new ImageSkin(this.itemRendererDownSkinTexture);
			otherSkin.selectedTexture = this.itemRendererSelectedUpSkinTexture;
			otherSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			otherSkin.width = this.gridSize;
			otherSkin.height = this.gridSize;
			otherSkin.minWidth = this.gridSize;
			otherSkin.minHeight = this.gridSize;
			itemRenderer.defaultSelectedSkin = otherSkin;
			itemRenderer.setSkinForState(ButtonState.DOWN, otherSkin);

			itemRenderer.fontStyles = this.primaryFontStyles.clone();
			itemRenderer.disabledFontStyles = this.disabledFontStyles.clone();
			itemRenderer.iconLabelFontStyles = this.primaryFontStyles.clone();
			itemRenderer.iconLabelDisabledFontStyles = this.disabledFontStyles.clone();
			itemRenderer.accessoryLabelFontStyles = this.primaryFontStyles.clone();
			itemRenderer.accessoryLabelDisabledFontStyles = this.disabledFontStyles.clone();

			itemRenderer.paddingTop = this.smallGutterSize;
			itemRenderer.paddingBottom = this.smallGutterSize;
			itemRenderer.paddingLeft = this.gutterSize;
			itemRenderer.paddingRight = this.gutterSize;
			itemRenderer.gap = this.gutterSize;
			itemRenderer.minGap = this.gutterSize;
			itemRenderer.accessoryGap = Number.POSITIVE_INFINITY;
			itemRenderer.minAccessoryGap = this.gutterSize;
			itemRenderer.minTouchWidth = this.gridSize;
			itemRenderer.minTouchHeight = this.gridSize;
			itemRenderer.horizontalAlign = HorizontalAlign.LEFT;
			itemRenderer.iconPosition = RelativePosition.LEFT;
			itemRenderer.accessoryPosition = RelativePosition.RIGHT;
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
			var defaultSkin:ImageSkin = new ImageSkin(this.itemRendererUpSkinTexture);
			defaultSkin.scale9Grid = ITEM_RENDERER_SCALE_9_GRID;
			defaultSkin.width = this.gridSize;
			defaultSkin.height = this.gridSize;
			defaultSkin.minWidth = this.gridSize;
			defaultSkin.minHeight = this.gridSize;
			itemRenderer.defaultSkin = defaultSkin;

			//different scale9Grid, so needs a separate skin
			var otherSkin:ImageSkin = new ImageSkin(this.itemRendererDownSkinTexture);
			otherSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			otherSkin.width = this.gridSize;
			otherSkin.height = this.gridSize;
			otherSkin.minWidth = this.gridSize;
			otherSkin.minHeight = this.gridSize;
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

			itemRenderer.fontStyles = this.primaryFontStyles.clone();
			itemRenderer.disabledFontStyles = this.disabledFontStyles.clone();
			itemRenderer.iconLabelFontStyles = this.primaryFontStyles.clone();
			itemRenderer.iconLabelDisabledFontStyles = this.disabledFontStyles.clone();
			itemRenderer.accessoryLabelFontStyles = this.primaryFontStyles.clone();
			itemRenderer.accessoryLabelDisabledFontStyles = this.disabledFontStyles.clone();

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
			itemRenderer.minTouchWidth = this.gridSize;
			itemRenderer.minTouchHeight = this.gridSize;
		}

	//-------------------------
	// NumericStepper
	//-------------------------

		protected function setNumericStepperStyles(stepper:NumericStepper):void
		{
			stepper.buttonLayoutMode = StepperButtonLayoutMode.SPLIT_HORIZONTAL;
			stepper.incrementButtonLabel = "+";
			stepper.decrementButtonLabel = "-";

			stepper.useLeftAndRightKeys = true;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			stepper.focusIndicatorSkin = focusIndicatorSkin;
			stepper.focusPadding = this.focusPaddingSize;
		}

		protected function setNumericStepperTextInputStyles(input:TextInput):void
		{
			input.minTouchWidth = this.gridSize;
			input.minTouchHeight = this.gridSize;
			input.gap = this.smallGutterSize;
			input.padding = this.smallGutterSize;
			input.isEditable = false;
			input.isSelectable = false;
			input.textEditorFactory = numericStepperTextEditorFactory;

			input.fontStyles = this.centeredFontStyles.clone();
			input.disabledFontStyles = this.centeredDisabledFontStyles.clone();

			var skin:ImageSkin = new ImageSkin(this.insetBackgroundSkinTexture);
			skin.setTextureForState(TextInputState.DISABLED, this.insetBackgroundDisabledSkinTexture);
			skin.setTextureForState(TextInputState.FOCUSED, this.insetBackgroundFocusedSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.gridSize;
			skin.height = this.controlSize;
			skin.minWidth = this.controlSize;
			skin.minHeight = this.controlSize;
			input.backgroundSkin = skin;
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
			var backgroundSkin:ImageSkin = new ImageSkin(this.panelHeaderSkinTexture);
			backgroundSkin.scale9Grid = HEADER_SCALE_9_GRID;
			backgroundSkin.width = this.gridSize;
			backgroundSkin.height = this.gridSize;
			backgroundSkin.minWidth = this.gridSize;
			backgroundSkin.minHeight = this.gridSize;
			header.backgroundSkin = backgroundSkin;

			header.fontStyles = this.primaryFontStyles.clone();
			header.disabledFontStyles = this.disabledFontStyles.clone();

			header.padding = this.smallGutterSize;
			header.gap = this.smallGutterSize;
			header.titleGap = this.smallGutterSize;
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
			if(DeviceCapabilities.isPhone(this.starling.nativeStage))
			{
				list.listFactory = pickerListSpinnerListFactory;
				list.popUpContentManager = new BottomDrawerPopUpContentManager();
			}
			else //tablet or desktop
			{
				list.popUpContentManager = new CalloutPopUpContentManager();
				list.customItemRendererStyleName = THEME_STYLE_NAME_TABLET_PICKER_LIST_ITEM_RENDERER;
			}
		}

		protected function setPickerListPopUpListStyles(list:List):void
		{
			this.setDropDownListStyles(list);
		}

		protected function setTabletPickerListItemRendererStyles(itemRenderer:BaseDefaultItemRenderer):void
		{
			var defaultSkin:ImageSkin = new ImageSkin(this.itemRendererUpSkinTexture);
			defaultSkin.scale9Grid = ITEM_RENDERER_SCALE_9_GRID;
			defaultSkin.width = this.popUpFillSize;
			defaultSkin.height = this.gridSize;
			defaultSkin.minWidth = this.popUpFillSize;
			defaultSkin.minHeight = this.gridSize;
			itemRenderer.defaultSkin = defaultSkin;

			//different scale9Grid, so needs a separate skin
			var otherSkin:ImageSkin = new ImageSkin(this.itemRendererDownSkinTexture);
			otherSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			otherSkin.width = this.popUpFillSize;
			otherSkin.height = this.gridSize;
			otherSkin.minWidth = this.popUpFillSize;
			otherSkin.minHeight = this.gridSize;
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

			itemRenderer.fontStyles = this.primaryFontStyles.clone();
			itemRenderer.disabledFontStyles = this.disabledFontStyles.clone();
			itemRenderer.iconLabelFontStyles = this.primaryFontStyles.clone();
			itemRenderer.iconLabelDisabledFontStyles = this.disabledFontStyles.clone();
			itemRenderer.accessoryLabelFontStyles = this.primaryFontStyles.clone();
			itemRenderer.accessoryLabelDisabledFontStyles = this.disabledFontStyles.clone();

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
			itemRenderer.minTouchWidth = this.gridSize;
			itemRenderer.minTouchHeight = this.gridSize;
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

			button.fontStyles = this.primaryFontStyles.clone();
			button.disabledFontStyles = this.disabledFontStyles.clone();

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
			var skin:Quad = new Quad(this.controlSize, this.controlSize);
			skin.alpha = 0;
			radio.defaultSkin = skin;

			var icon:ImageSkin = new ImageSkin(this.radioIconTexture);
			icon.selectedTexture = this.radioSelectedIconTexture;
			icon.setTextureForState(ButtonState.DISABLED, this.radioDisabledIconTexture);
			icon.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.radioSelectedDisabledIconTexture);
			radio.defaultIcon = icon;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			radio.focusIndicatorSkin = focusIndicatorSkin;
			radio.focusPadding = this.focusPaddingSize;

			radio.fontStyles = this.primaryFontStyles.clone();
			radio.disabledFontStyles = this.disabledFontStyles.clone();

			radio.gap = this.smallGutterSize;
			radio.horizontalAlign = HorizontalAlign.LEFT;
			radio.verticalAlign = VerticalAlign.MIDDLE;
			radio.minTouchWidth = this.gridSize;
			radio.minTouchHeight = this.gridSize;
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

			var backgroundSkin:ImageSkin = new ImageSkin(this.headerSkinTexture);
			backgroundSkin.scale9Grid = HEADER_SCALE_9_GRID;
			backgroundSkin.width = this.gridSize;
			backgroundSkin.height = this.gridSize;
			backgroundSkin.minWidth = this.gridSize;
			backgroundSkin.minHeight = this.gridSize;
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

			text.fontStyles = this.scrollTextFontStyles.clone();
			text.disabledFontStyles = this.scrollTextDisabledFontStyles.clone();

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

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			slider.focusIndicatorSkin = focusIndicatorSkin;
			slider.focusPadding = this.focusPaddingSize;
		}

		protected function setHorizontalSliderMinimumTrackStyles(track:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.insetBackgroundSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.insetBackgroundDisabledSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.wideControlSize;
			skin.height = this.smallControlSize;
			skin.minHeight = this.smallControlSize;
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
			skin.minWidth = this.smallControlSize;
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

		protected function setSpinnerListItemRendererStyles(itemRenderer:BaseDefaultItemRenderer):void
		{
			var skin:Quad = new Quad(this.gridSize, this.gridSize);
			skin.alpha = 0;
			itemRenderer.defaultSkin = skin;

			//if it's not selected, we don't want it to be highlighted, so we're
			//borrowing the less prominent disabled color
			itemRenderer.fontStyles = this.disabledFontStyles.clone();
			itemRenderer.selectedFontStyles = this.primaryFontStyles.clone();
			itemRenderer.disabledFontStyles = this.disabledFontStyles.clone();
			itemRenderer.iconLabelFontStyles = this.disabledFontStyles.clone();
			itemRenderer.iconLabelSelectedFontStyles = this.primaryFontStyles.clone();
			itemRenderer.iconLabelDisabledFontStyles = this.disabledFontStyles.clone();
			itemRenderer.accessoryLabelFontStyles = this.disabledFontStyles.clone();
			itemRenderer.accessoryLabelSelectedFontStyles = this.primaryFontStyles.clone();
			itemRenderer.accessoryLabelDisabledFontStyles = this.disabledFontStyles.clone();

			itemRenderer.paddingTop = this.smallGutterSize;
			itemRenderer.paddingBottom = this.smallGutterSize;
			itemRenderer.paddingLeft = this.gutterSize;
			itemRenderer.paddingRight = this.gutterSize;
			itemRenderer.gap = Number.POSITIVE_INFINITY;
			itemRenderer.minGap = this.gutterSize;
			itemRenderer.iconPosition = RelativePosition.RIGHT;
			itemRenderer.horizontalAlign = HorizontalAlign.LEFT;
			itemRenderer.accessoryGap = Number.POSITIVE_INFINITY;
			itemRenderer.minAccessoryGap = this.gutterSize;
			itemRenderer.accessoryPosition = RelativePosition.RIGHT;
			itemRenderer.minTouchWidth = this.gridSize;
			itemRenderer.minTouchHeight = this.gridSize;
			itemRenderer.isQuickHitAreaEnabled = true;
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
			defaultSkin.minWidth = this.gridSize;
			defaultSkin.minHeight = this.gridSize;
			tab.defaultSkin = defaultSkin;

			var otherSkin:ImageSkin = new ImageSkin(this.tabSelectedSkinTexture);
			otherSkin.setTextureForState(ButtonState.DOWN, this.tabDownSkinTexture);
			otherSkin.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.tabSelectedDisabledSkinTexture);
			otherSkin.scale9Grid = TAB_SCALE_9_GRID;
			otherSkin.width = this.gridSize;
			otherSkin.height = this.gridSize;
			otherSkin.minWidth = this.gridSize;
			otherSkin.minHeight = this.gridSize;
			tab.defaultSelectedSkin = otherSkin;
			tab.setSkinForState(ButtonState.DOWN, otherSkin);

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			tab.focusIndicatorSkin = focusIndicatorSkin;
			tab.focusPadding = this.tabFocusPaddingSize;

			tab.fontStyles = this.primaryFontStyles.clone();
			tab.disabledFontStyles = this.disabledFontStyles.clone();

			tab.iconPosition = RelativePosition.TOP;
			tab.padding = this.gutterSize;
			tab.gap = this.smallGutterSize;
			tab.minGap = this.smallGutterSize;
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

			textArea.fontStyles = this.scrollTextFontStyles.clone();
			textArea.disabledFontStyles = this.scrollTextDisabledFontStyles.clone();

			textArea.textEditorFactory = textAreaTextEditorFactory;
		}

		protected function setTextAreaTextEditorStyles(textEditor:TextFieldTextEditorViewPort):void
		{
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

			callout.fontStyles = this.primaryFontStyles.clone();
			callout.disabledFontStyles = this.disabledFontStyles.clone();
		}

		protected function setDangerTextCalloutStyles(callout:TextCallout):void
		{
			this.setDangerCalloutStyles(callout);

			callout.fontStyles = this.dangerFontStyles.clone();
			callout.disabledFontStyles = this.disabledFontStyles.clone();
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
			skin.minWidth = this.wideControlSize;
			skin.minHeight = this.controlSize;
			input.backgroundSkin = skin;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			input.focusIndicatorSkin = focusIndicatorSkin;
			input.focusPadding = this.focusPaddingSize;

			input.minTouchWidth = this.gridSize;
			input.minTouchHeight = this.gridSize;
			input.gap = this.smallGutterSize;
			input.padding = this.smallGutterSize;
		}

		protected function setTextInputStyles(input:TextInput):void
		{
			this.setBaseTextInputStyles(input);

			input.fontStyles = this.scrollTextFontStyles.clone();
			input.disabledFontStyles = this.scrollTextDisabledFontStyles.clone();

			input.promptFontStyles = this.primaryFontStyles.clone();
			input.promptDisabledFontStyles = this.disabledFontStyles.clone();
		}

		protected function setSearchTextInputStyles(input:TextInput):void
		{
			this.setBaseTextInputStyles(input);

			input.fontStyles = this.scrollTextFontStyles.clone();
			input.disabledFontStyles = this.scrollTextDisabledFontStyles.clone();

			input.promptFontStyles = this.primaryFontStyles.clone();
			input.promptDisabledFontStyles = this.disabledFontStyles.clone();

			var icon:ImageSkin = new ImageSkin(this.searchIconTexture);
			icon.disabledTexture = this.searchIconDisabledTexture;
			input.defaultIcon = icon;
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

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			toggleSwitch.focusIndicatorSkin = focusIndicatorSkin;
			toggleSwitch.focusPadding = this.focusPaddingSize;

			toggleSwitch.onLabelFontStyles = this.primaryFontStyles.clone();
			toggleSwitch.onLabelDisabledFontStyles = this.disabledFontStyles.clone();
			toggleSwitch.offLabelFontStyles = this.primaryFontStyles.clone();
			toggleSwitch.offLabelDisabledFontStyles = this.disabledFontStyles.clone();
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
	// Tree
	//-------------------------

		protected function setTreeStyles(tree:Tree):void
		{
			this.setScrollerStyles(tree);

			tree.backgroundSkin = new Quad(this.gridSize, this.gridSize, LIST_BACKGROUND_COLOR);
		}

		protected function setTreeItemRendererStyles(itemRenderer:DefaultTreeItemRenderer):void
		{
			this.setItemRendererStyles(itemRenderer);

			itemRenderer.indentation = this.treeDisclosureOpenIconTexture.width;

			var disclosureOpenIcon:ImageSkin = new ImageSkin(this.treeDisclosureOpenIconTexture);
			disclosureOpenIcon.textureSmoothing = TextureSmoothing.NONE;
			disclosureOpenIcon.pixelSnapping = true;
			//make sure the hit area is large enough for touch screens
			disclosureOpenIcon.minTouchWidth = this.gridSize;
			disclosureOpenIcon.minTouchHeight = this.gridSize;
			itemRenderer.disclosureOpenIcon = disclosureOpenIcon;

			var disclosureClosedIcon:ImageSkin = new ImageSkin(this.treeDisclosureClosedIconTexture);
			disclosureClosedIcon.textureSmoothing = TextureSmoothing.NONE;
			disclosureClosedIcon.pixelSnapping = true;
			disclosureClosedIcon.minTouchWidth = this.gridSize;
			disclosureClosedIcon.minTouchHeight = this.gridSize;
			itemRenderer.disclosureClosedIcon = disclosureClosedIcon;
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
			otherSkin.minWidth = this.controlSize;
			otherSkin.minHeight = this.controlSize;
			button.setSkinForState(ButtonState.DOWN, otherSkin);
			button.setSkinForState(ButtonState.DOWN_AND_SELECTED, otherSkin);

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			button.focusIndicatorSkin = focusIndicatorSkin;
			button.focusPadding = this.focusPaddingSize;

			var icon:ImageSkin = new ImageSkin(this.playPauseButtonPlayUpIconTexture);
			icon.selectedTexture = this.playPauseButtonPauseUpIconTexture;
			icon.textureSmoothing = TextureSmoothing.NONE;
			button.defaultIcon = icon;

			button.hasLabelTextRenderer = false;

			button.padding = this.smallGutterSize;
			button.gap = this.smallGutterSize;
			button.minGap = this.smallGutterSize;
		}

		protected function setOverlayPlayPauseToggleButtonStyles(button:PlayPauseToggleButton):void
		{
			var icon:ImageSkin = new ImageSkin(null);
			icon.setTextureForState(ButtonState.UP, this.overlayPlayPauseButtonPlayUpIconTexture);
			icon.setTextureForState(ButtonState.HOVER, this.overlayPlayPauseButtonPlayUpIconTexture);
			button.defaultIcon = icon;

			button.hasLabelTextRenderer = false;

			var skin:Quad = new Quad(this.overlayPlayPauseButtonPlayUpIconTexture.width,
				this.overlayPlayPauseButtonPlayUpIconTexture.height);
			skin.alpha = 0;
			button.defaultSkin = skin;

			var overlaySkin:Quad = new Quad(1, 1, VIDEO_OVERLAY_COLOR);
			overlaySkin.alpha = VIDEO_OVERLAY_ALPHA;
			button.upSkin = overlaySkin;
			button.hoverSkin = overlaySkin;
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
			otherSkin.minWidth = this.controlSize;
			otherSkin.minHeight = this.controlSize;
			button.setSkinForState(ButtonState.DOWN, otherSkin);
			button.setSkinForState(ButtonState.DOWN_AND_SELECTED, otherSkin);

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			button.focusIndicatorSkin = focusIndicatorSkin;
			button.focusPadding = this.focusPaddingSize;

			var icon:ImageSkin = new ImageSkin(this.fullScreenToggleButtonEnterUpIconTexture);
			icon.selectedTexture = this.fullScreenToggleButtonExitUpIconTexture;
			icon.textureSmoothing = TextureSmoothing.NONE;
			button.defaultIcon = icon;

			button.hasLabelTextRenderer = false;

			button.padding = this.smallGutterSize;
			button.gap = this.smallGutterSize;
			button.minGap = this.smallGutterSize;
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
			otherSkin.minWidth = this.controlSize;
			otherSkin.minHeight = this.controlSize;
			button.setSkinForState(ButtonState.DOWN, otherSkin);
			button.setSkinForState(ButtonState.DOWN_AND_SELECTED, otherSkin);

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			button.focusIndicatorSkin = focusIndicatorSkin;
			button.focusPadding = this.focusPaddingSize;

			var icon:ImageSkin = new ImageSkin(this.muteToggleButtonLoudUpIconTexture);
			icon.selectedTexture = this.muteToggleButtonMutedUpIconTexture;
			icon.textureSmoothing = TextureSmoothing.NONE;
			button.defaultIcon = icon;

			button.hasLabelTextRenderer = false;
			button.showVolumeSliderOnHover = false;

			button.padding = this.smallGutterSize;
			button.gap = this.smallGutterSize;
			button.minGap = this.smallGutterSize;
		}

	//-------------------------
	// SeekSlider
	//-------------------------

		protected function setSeekSliderStyles(slider:SeekSlider):void
		{
			slider.direction = Direction.HORIZONTAL;
			slider.trackLayoutMode = TrackLayoutMode.SINGLE;

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
