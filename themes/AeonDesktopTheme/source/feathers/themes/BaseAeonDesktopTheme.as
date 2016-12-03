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
	import feathers.controls.IScrollBar;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.NumericStepper;
	import feathers.controls.PageIndicator;
	import feathers.controls.PageIndicatorInteractionMode;
	import feathers.controls.Panel;
	import feathers.controls.PanelScreen;
	import feathers.controls.PickerList;
	import feathers.controls.ProgressBar;
	import feathers.controls.Radio;
	import feathers.controls.ScrollBar;
	import feathers.controls.ScrollBarDisplayMode;
	import feathers.controls.ScrollContainer;
	import feathers.controls.ScrollInteractionMode;
	import feathers.controls.ScrollPolicy;
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
	import feathers.controls.popups.DropDownPopUpContentManager;
	import feathers.controls.renderers.BaseDefaultItemRenderer;
	import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.controls.text.TextFieldTextEditorViewPort;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.FocusManager;
	import feathers.core.ITextEditor;
	import feathers.core.ITextRenderer;
	import feathers.core.PopUpManager;
	import feathers.core.ToolTipManager;
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
	import feathers.media.VolumeSlider;
	import feathers.skins.ImageSkin;

	import flash.geom.Rectangle;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Stage;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	/**
	 * The base class for the "Aeon" theme for desktop Feathers apps. Handles
	 * everything except asset loading, which is left to subclasses.
	 *
	 * @see AeonDesktopTheme
	 * @see AeonDesktopThemeWithAssetManager
	 */
	public class BaseAeonDesktopTheme extends StyleNameFunctionTheme
	{
		/**
		 * @private
		 * The theme's custom style name for the increment button of a horizontal ScrollBar.
		 */
		protected static const THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON:String = "aeon-horizontal-scroll-bar-increment-button";

		/**
		 * @private
		 * The theme's custom style name for the decrement button of a horizontal ScrollBar.
		 */
		protected static const THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON:String = "aeon-horizontal-scroll-bar-decrement-button";

		/**
		 * @private
		 * The theme's custom style name for the thumb of a horizontal ScrollBar.
		 */
		protected static const THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_THUMB:String = "aeon-horizontal-scroll-bar-thumb";

		/**
		 * @private
		 * The theme's custom style name for the minimum track of a horizontal ScrollBar.
		 */
		protected static const THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_MINIMUM_TRACK:String = "aeon-horizontal-scroll-bar-minimum-track";

		/**
		 * @private
		 * The theme's custom style name for the increment button of a vertical ScrollBar.
		 */
		protected static const THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON:String = "aeon-vertical-scroll-bar-increment-button";

		/**
		 * @private
		 * The theme's custom style name for the decrement button of a vertical ScrollBar.
		 */
		protected static const THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON:String = "aeon-vertical-scroll-bar-decrement-button";

		/**
		 * @private
		 * The theme's custom style name for the thumb of a vertical ScrollBar.
		 */
		protected static const THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_THUMB:String = "aeon-vertical-scroll-bar-thumb";

		/**
		 * @private
		 * The theme's custom style name for the minimum track of a vertical ScrollBar.
		 */
		protected static const THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_MINIMUM_TRACK:String = "aeon-vertical-scroll-bar-minimum-track";

		/**
		 * @private
		 * The theme's custom style name for the thumb of a horizontal SimpleScrollBar.
		 */
		protected static const THEME_STYLE_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB:String = "aeon-horizontal-simple-scroll-bar-thumb";

		/**
		 * @private
		 * The theme's custom style name for the thumb of a vertical SimpleScrollBar.
		 */
		protected static const THEME_STYLE_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB:String = "aeon-vertical-simple-scroll-bar-thumb";

		/**
		 * @private
		 * The theme's custom style name for the thumb of a horizontal Slider.
		 */
		protected static const THEME_STYLE_NAME_HORIZONTAL_SLIDER_THUMB:String = "aeon-horizontal-slider-thumb";

		/**
		 * @private
		 * The theme's custom style name for the minimum track of a horizontal Slider.
		 */
		protected static const THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK:String = "aeon-horizontal-slider-minimum-track";

		/**
		 * @private
		 * The theme's custom style name for the thumb of a vertical Slider.
		 */
		protected static const THEME_STYLE_NAME_VERTICAL_SLIDER_THUMB:String = "aeon-vertical-slider-thumb";

		/**
		 * @private
		 * The theme's custom style name for the minimum track of a vertical Slider.
		 */
		protected static const THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK:String = "aeon-vertical-slider-minimum-track";

		/**
		 * @private
		 * The theme's custom style name for the minimum track of a vertical VolumeSlider.
		 */
		protected static const THEME_STYLE_NAME_VERTICAL_VOLUME_SLIDER_MINIMUM_TRACK:String = "aeon-vertical-volume-slider-minimum-track";

		/**
		 * @private
		 * The theme's custom style name for the maximum track of a vertical VolumeSlider.
		 */
		protected static const THEME_STYLE_NAME_VERTICAL_VOLUME_SLIDER_MAXIMUM_TRACK:String = "aeon-vertical-volume-slider-maximum-track";

		/**
		 * @private
		 * The theme's custom style name for the minimum track of a horizontal VolumeSlider.
		 */
		protected static const THEME_STYLE_NAME_HORIZONTAL_VOLUME_SLIDER_MINIMUM_TRACK:String = "aeon-horizontal-volume-slider-minimum-track";

		/**
		 * @private
		 * The theme's custom style name for the maximum track of a horizontal VolumeSlider.
		 */
		protected static const THEME_STYLE_NAME_HORIZONTAL_VOLUME_SLIDER_MAXIMUM_TRACK:String = "aeon-horizontal-volume-slider-maximum-track";

		/**
		 * @private
		 * The theme's custom style name for the minimum track of a pop-up VolumeSlider.
		 */
		protected static const THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MINIMUM_TRACK:String = "aeon-pop-up-volume-slider-minimum-track";

		/**
		 * @private
		 * The theme's custom style name for the maximum track of a pop-up VolumeSlider.
		 */
		protected static const THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MAXIMUM_TRACK:String = "aeon-pop-up-volume-slider-maximum-track";

		/**
		 * @private
		 * The theme's custom style name for the item renderer of a SpinnerList in a DateTimeSpinner.
		 */
		protected static const THEME_STYLE_NAME_DATE_TIME_SPINNER_LIST_ITEM_RENDERER:String = "aeon-date-time-spinner-list-item-renderer";

		/**
		 * The name of the font used by controls in this theme. This font is not
		 * embedded. It is the default sans-serif system font.
		 */
		public static const FONT_NAME:String = "_sans";

		protected static const FOCUS_INDICATOR_SCALE_9_GRID:Rectangle = new Rectangle(5, 5, 2, 2);
		protected static const TOOL_TIP_SCALE_9_GRID:Rectangle = new Rectangle(5, 5, 1, 1);
		protected static const CALLOUT_SCALE_9_GRID:Rectangle = new Rectangle(5, 5, 1, 1);
		protected static const BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(5, 5, 1, 12);
		protected static const TAB_SCALE_9_GRID:Rectangle = new Rectangle(5, 5, 1, 15);
		protected static const STEPPER_INCREMENT_BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(1, 9, 15, 1);
		protected static const STEPPER_DECREMENT_BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(1, 1, 15, 1);
		protected static const HORIZONTAL_SLIDER_TRACK_SCALE_9_GRID:Rectangle = new Rectangle(3, 0, 1, 4);
		protected static const VERTICAL_SLIDER_TRACK_SCALE_9_GRID:Rectangle = new Rectangle(0, 3, 4, 1);
		protected static const TEXT_INPUT_SCALE_9_GRID:Rectangle = new Rectangle(2, 2, 1, 1);
		protected static const VERTICAL_SCROLL_BAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(2, 5, 6, 42);
		protected static const VERTICAL_SCROLL_BAR_TRACK_SCALE_9_GRID:Rectangle = new Rectangle(2, 1, 11, 2);
		protected static const VERTICAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(2, 2, 11, 10);
		protected static const HORIZONTAL_SCROLL_BAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(5, 2, 42, 6);
		protected static const HORIZONTAL_SCROLL_BAR_TRACK_SCALE_9_GRID:Rectangle = new Rectangle(1, 2, 2, 11);
		protected static const HORIZONTAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(2, 2, 10, 11);
		protected static const SIMPLE_BORDER_SCALE_9_GRID:Rectangle = new Rectangle(2, 2, 2, 2);
		protected static const PANEL_BORDER_SCALE_9_GRID:Rectangle = new Rectangle(5, 5, 1, 1);
		protected static const HEADER_SCALE_9_GRID:Rectangle = new Rectangle(1, 1, 2, 28);
		protected static const SEEK_SLIDER_MINIMUM_TRACK_SCALE_9_GRID:Rectangle = new Rectangle(3, 0, 1, 4);
		protected static const SEEK_SLIDER_MAXIMUM_TRACK_SCALE_9_GRID:Rectangle = new Rectangle(1, 0, 1, 4);
		
		protected static const ITEM_RENDERER_SKIN_TEXTURE_REGION:Rectangle = new Rectangle(1, 1, 4, 4);
		protected static const PROGRESS_BAR_FILL_TEXTURE_REGION:Rectangle = new Rectangle(1, 1, 4, 4);

		protected static const BACKGROUND_COLOR:uint = 0x869CA7;
		protected static const MODAL_OVERLAY_COLOR:uint = 0xDDDDDD;
		protected static const MODAL_OVERLAY_ALPHA:Number = 0.5;
		protected static const PRIMARY_TEXT_COLOR:uint = 0x0B333C;
		protected static const DISABLED_TEXT_COLOR:uint = 0x5B6770;
		protected static const INVERTED_TEXT_COLOR:uint = 0xffffff;
		protected static const VIDEO_OVERLAY_COLOR:uint = 0xc9e0eE;
		protected static const VIDEO_OVERLAY_ALPHA:Number = 0.25;

		/**
		 * The default global text renderer factory for this theme creates a
		 * TextFieldTextRenderer.
		 */
		protected static function textRendererFactory():ITextRenderer
		{
			return new TextFieldTextRenderer();
		}

		/**
		 * The default global text editor factory for this theme creates a
		 * TextFieldTextEditor.
		 */
		protected static function textEditorFactory():ITextEditor
		{
			return new TextFieldTextEditor();
		}

		/**
		 * This theme's scroll bar type is ScrollBar.
		 */
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

		/**
		 * Constructor.
		 */
		public function BaseAeonDesktopTheme()
		{
			super();
		}

		/**
		 * A smaller font size for details.
		 */
		protected var smallFontSize:int;

		/**
		 * A normal font size.
		 */
		protected var regularFontSize:int;

		/**
		 * A larger font size for headers.
		 */
		protected var largeFontSize:int;

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
		 * The size, in pixels, of very smaller padding and gaps.
		 */
		protected var extraSmallGutterSize:int;

		/**
		 * The minimum width, in pixels, of some types of buttons.
		 */
		protected var buttonMinWidth:int;

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
		 * The size, in pixels, of a border around any control.
		 */
		protected var borderSize:int;

		protected var calloutBackgroundMinSize:int;
		protected var calloutArrowOverlapGap:int;
		protected var progressBarFillMinSize:int;
		protected var popUpSize:int;
		protected var popUpVolumeSliderPaddingSize:int;
		protected var bottomDropShadowSize:int;
		protected var leftAndRightDropShadowSize:int;

		/**
		 * The texture atlas that contains skins for this theme. This base class
		 * does not initialize this member variable. Subclasses are expected to
		 * load the assets somehow and set the <code>atlas</code> member
		 * variable before calling <code>initialize()</code>.
		 */
		protected var atlas:TextureAtlas;

		/**
		 * Font styles for most UI controls and text.
		 */
		protected var defaultFontStyles:TextFormat;

		/**
		 * Font styles for most disabled UI controls and text.
		 */
		protected var disabledFontStyles:TextFormat;

		/**
		 * Font styles for larger text.
		 */
		protected var headingFontStyles:TextFormat;

		/**
		 * Font styles for larger, disabled text.
		 */
		protected var headingDisabledFontStyles:TextFormat;

		/**
		 * Font styles for smaller text.
		 */
		protected var detailFontStyles:TextFormat;

		/**
		 * Font styles for smaller, disabled text.
		 */
		protected var detailDisabledFontStyles:TextFormat;

		/**
		 * Font styles for text on dark backgrounds.
		 */
		protected var invertedFontStyles:TextFormat;

		protected var focusIndicatorSkinTexture:Texture;
		protected var toolTipBackgroundSkinTexture:Texture;
		protected var calloutBackgroundSkinTexture:Texture;
		protected var calloutTopArrowSkinTexture:Texture;
		protected var calloutRightArrowSkinTexture:Texture;
		protected var calloutBottomArrowSkinTexture:Texture;
		protected var calloutLeftArrowSkinTexture:Texture;
		protected var dangerCalloutBackgroundSkinTexture:Texture;
		protected var dangerCalloutTopArrowSkinTexture:Texture;
		protected var dangerCalloutRightArrowSkinTexture:Texture;
		protected var dangerCalloutBottomArrowSkinTexture:Texture;
		protected var dangerCalloutLeftArrowSkinTexture:Texture;

		protected var buttonUpSkinTexture:Texture;
		protected var buttonHoverSkinTexture:Texture;
		protected var buttonDownSkinTexture:Texture;
		protected var buttonDisabledSkinTexture:Texture;
		protected var toggleButtonSelectedUpSkinTexture:Texture;
		protected var toggleButtonSelectedHoverSkinTexture:Texture;
		protected var toggleButtonSelectedDownSkinTexture:Texture;
		protected var toggleButtonSelectedDisabledSkinTexture:Texture;
		protected var quietButtonHoverSkinTexture:Texture;
		protected var callToActionButtonUpSkinTexture:Texture;
		protected var callToActionButtonHoverSkinTexture:Texture;
		protected var dangerButtonUpSkinTexture:Texture;
		protected var dangerButtonHoverSkinTexture:Texture;
		protected var dangerButtonDownSkinTexture:Texture;
		protected var backButtonUpIconTexture:Texture;
		protected var backButtonDisabledIconTexture:Texture;
		protected var forwardButtonUpIconTexture:Texture;
		protected var forwardButtonDisabledIconTexture:Texture;

		protected var tabUpSkinTexture:Texture;
		protected var tabHoverSkinTexture:Texture;
		protected var tabDownSkinTexture:Texture;
		protected var tabDisabledSkinTexture:Texture;
		protected var tabSelectedUpSkinTexture:Texture;
		protected var tabSelectedDisabledSkinTexture:Texture;

		protected var stepperIncrementButtonUpSkinTexture:Texture;
		protected var stepperIncrementButtonHoverSkinTexture:Texture;
		protected var stepperIncrementButtonDownSkinTexture:Texture;
		protected var stepperIncrementButtonDisabledSkinTexture:Texture;

		protected var stepperDecrementButtonUpSkinTexture:Texture;
		protected var stepperDecrementButtonHoverSkinTexture:Texture;
		protected var stepperDecrementButtonDownSkinTexture:Texture;
		protected var stepperDecrementButtonDisabledSkinTexture:Texture;

		protected var hSliderThumbUpSkinTexture:Texture;
		protected var hSliderThumbHoverSkinTexture:Texture;
		protected var hSliderThumbDownSkinTexture:Texture;
		protected var hSliderThumbDisabledSkinTexture:Texture;
		protected var hSliderTrackEnabledSkinTexture:Texture;

		protected var vSliderThumbUpSkinTexture:Texture;
		protected var vSliderThumbHoverSkinTexture:Texture;
		protected var vSliderThumbDownSkinTexture:Texture;
		protected var vSliderThumbDisabledSkinTexture:Texture;
		protected var vSliderTrackEnabledSkinTexture:Texture;

		protected var itemRendererUpSkinTexture:Texture;
		protected var itemRendererHoverSkinTexture:Texture;
		protected var itemRendererSelectedUpSkinTexture:Texture;

		protected var headerBackgroundSkinTexture:Texture;
		protected var groupedListHeaderBackgroundSkinTexture:Texture;

		protected var checkUpIconTexture:Texture;
		protected var checkHoverIconTexture:Texture;
		protected var checkDownIconTexture:Texture;
		protected var checkDisabledIconTexture:Texture;
		protected var checkSelectedUpIconTexture:Texture;
		protected var checkSelectedHoverIconTexture:Texture;
		protected var checkSelectedDownIconTexture:Texture;
		protected var checkSelectedDisabledIconTexture:Texture;

		protected var radioUpIconTexture:Texture;
		protected var radioHoverIconTexture:Texture;
		protected var radioDownIconTexture:Texture;
		protected var radioDisabledIconTexture:Texture;
		protected var radioSelectedUpIconTexture:Texture;
		protected var radioSelectedHoverIconTexture:Texture;
		protected var radioSelectedDownIconTexture:Texture;
		protected var radioSelectedDisabledIconTexture:Texture;

		protected var pageIndicatorNormalSkinTexture:Texture;
		protected var pageIndicatorSelectedSkinTexture:Texture;

		protected var pickerListUpIconTexture:Texture;
		protected var pickerListHoverIconTexture:Texture;
		protected var pickerListDownIconTexture:Texture;
		protected var pickerListDisabledIconTexture:Texture;

		protected var textInputBackgroundEnabledSkinTexture:Texture;
		protected var textInputBackgroundDisabledSkinTexture:Texture;
		protected var textInputBackgroundErrorSkinTexture:Texture;
		protected var textInputSearchIconTexture:Texture;
		protected var textInputSearchIconDisabledTexture:Texture;

		protected var vScrollBarThumbUpSkinTexture:Texture;
		protected var vScrollBarThumbHoverSkinTexture:Texture;
		protected var vScrollBarThumbDownSkinTexture:Texture;
		protected var vScrollBarTrackSkinTexture:Texture;
		protected var vScrollBarThumbIconTexture:Texture;
		protected var vScrollBarStepButtonUpSkinTexture:Texture;
		protected var vScrollBarStepButtonHoverSkinTexture:Texture;
		protected var vScrollBarStepButtonDownSkinTexture:Texture;
		protected var vScrollBarStepButtonDisabledSkinTexture:Texture;
		protected var vScrollBarDecrementButtonIconTexture:Texture;
		protected var vScrollBarIncrementButtonIconTexture:Texture;

		protected var hScrollBarThumbUpSkinTexture:Texture;
		protected var hScrollBarThumbHoverSkinTexture:Texture;
		protected var hScrollBarThumbDownSkinTexture:Texture;
		protected var hScrollBarTrackSkinTexture:Texture;
		protected var hScrollBarThumbIconTexture:Texture;
		protected var hScrollBarStepButtonUpSkinTexture:Texture;
		protected var hScrollBarStepButtonHoverSkinTexture:Texture;
		protected var hScrollBarStepButtonDownSkinTexture:Texture;
		protected var hScrollBarStepButtonDisabledSkinTexture:Texture;
		protected var hScrollBarDecrementButtonIconTexture:Texture;
		protected var hScrollBarIncrementButtonIconTexture:Texture;

		protected var simpleBorderBackgroundSkinTexture:Texture;
		protected var insetBorderBackgroundSkinTexture:Texture;
		protected var panelBorderBackgroundSkinTexture:Texture;
		protected var alertBorderBackgroundSkinTexture:Texture;

		protected var progressBarFillSkinTexture:Texture;
		
		protected var listDrillDownAccessoryTexture:Texture;

		//media textures
		protected var playPauseButtonPlayUpIconTexture:Texture;
		protected var playPauseButtonPauseUpIconTexture:Texture;
		protected var overlayPlayPauseButtonPlayUpIconTexture:Texture;
		protected var fullScreenToggleButtonEnterUpIconTexture:Texture;
		protected var fullScreenToggleButtonExitUpIconTexture:Texture;
		protected var muteToggleButtonLoudUpIconTexture:Texture;
		protected var muteToggleButtonMutedUpIconTexture:Texture;
		protected var horizontalVolumeSliderMinimumTrackSkinTexture:Texture;
		protected var horizontalVolumeSliderMaximumTrackSkinTexture:Texture;
		protected var verticalVolumeSliderMinimumTrackSkinTexture:Texture;
		protected var verticalVolumeSliderMaximumTrackSkinTexture:Texture;
		protected var popUpVolumeSliderMinimumTrackSkinTexture:Texture;
		protected var popUpVolumeSliderMaximumTrackSkinTexture:Texture;
		protected var seekSliderMinimumTrackSkinTexture:Texture;
		protected var seekSliderMaximumTrackSkinTexture:Texture;
		protected var seekSliderProgressSkinTexture:Texture;

		/**
		 * Disposes the texture atlas before calling super.dispose()
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

			var stage:Stage = this.starling.stage;
			FocusManager.setEnabledForStage(stage, false);
			ToolTipManager.setEnabledForStage(stage, false);

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
			this.initializeFonts();
			this.initializeTextures();
			this.initializeGlobals();
			this.initializeStage();
			this.initializeStyleProviders();
		}

		/**
		 * Initializes common values used for setting the dimensions of components.
		 */
		protected function initializeDimensions():void
		{
			this.gridSize = 30;
			this.extraSmallGutterSize = 2;
			this.smallGutterSize = 6;
			this.gutterSize = 10;
			this.borderSize = 1;
			this.controlSize = 22;
			this.smallControlSize = 12;
			this.calloutBackgroundMinSize = 5;
			this.progressBarFillMinSize = 7;
			this.buttonMinWidth = 40;
			this.wideControlSize = 152;
			this.popUpSize = this.gridSize * 10 + this.smallGutterSize * 9;
			this.popUpVolumeSliderPaddingSize = 6;
			this.leftAndRightDropShadowSize = 1;
			this.bottomDropShadowSize = 3;
			this.calloutArrowOverlapGap = -1;
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
			var stage:Stage = this.starling.stage;
			FocusManager.setEnabledForStage(stage, true);
			ToolTipManager.setEnabledForStage(stage, true);

			FeathersControl.defaultTextRendererFactory = textRendererFactory;
			FeathersControl.defaultTextEditorFactory = textEditorFactory;

			PopUpManager.overlayFactory = popUpOverlayFactory;
			Callout.stagePadding = this.smallGutterSize;
		}

		/**
		 * Initializes font sizes and formats.
		 */
		protected function initializeFonts():void
		{
			this.smallFontSize = 10;
			this.regularFontSize = 11;
			this.largeFontSize = 13;

			this.defaultFontStyles = new TextFormat(FONT_NAME, this.regularFontSize, PRIMARY_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.disabledFontStyles = new TextFormat(FONT_NAME, this.regularFontSize, DISABLED_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.headingFontStyles = new TextFormat(FONT_NAME, this.largeFontSize, PRIMARY_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.headingDisabledFontStyles = new TextFormat(FONT_NAME, this.largeFontSize, DISABLED_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.detailFontStyles = new TextFormat(FONT_NAME, this.smallFontSize, PRIMARY_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.detailDisabledFontStyles = new TextFormat(FONT_NAME, this.smallFontSize, DISABLED_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.invertedFontStyles = new TextFormat(FONT_NAME, this.regularFontSize, INVERTED_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
		}

		/**
		 * Initializes the textures by extracting them from the atlas and
		 * setting up any scaling grids that are needed.
		 */
		protected function initializeTextures():void
		{
			this.focusIndicatorSkinTexture = this.atlas.getTexture("focus-indicator-skin0000");
			this.toolTipBackgroundSkinTexture = this.atlas.getTexture("tool-tip-background-skin0000");
			this.calloutBackgroundSkinTexture = this.atlas.getTexture("callout-background-skin0000");
			this.calloutTopArrowSkinTexture = this.atlas.getTexture("callout-top-arrow-skin0000");
			this.calloutRightArrowSkinTexture = this.atlas.getTexture("callout-right-arrow-skin0000");
			this.calloutBottomArrowSkinTexture = this.atlas.getTexture("callout-bottom-arrow-skin0000");
			this.calloutLeftArrowSkinTexture = this.atlas.getTexture("callout-left-arrow-skin0000");
			this.dangerCalloutBackgroundSkinTexture = this.atlas.getTexture("danger-callout-background-skin0000");
			this.dangerCalloutTopArrowSkinTexture = this.atlas.getTexture("danger-callout-top-arrow-skin0000");
			this.dangerCalloutRightArrowSkinTexture = this.atlas.getTexture("danger-callout-right-arrow-skin0000");
			this.dangerCalloutBottomArrowSkinTexture = this.atlas.getTexture("danger-callout-bottom-arrow-skin0000");
			this.dangerCalloutLeftArrowSkinTexture = this.atlas.getTexture("danger-callout-left-arrow-skin0000");

			this.buttonUpSkinTexture = this.atlas.getTexture("button-up-skin0000");
			this.buttonHoverSkinTexture = this.atlas.getTexture("button-hover-skin0000");
			this.buttonDownSkinTexture = this.atlas.getTexture("button-down-skin0000");
			this.buttonDisabledSkinTexture = this.atlas.getTexture("button-disabled-skin0000");
			this.toggleButtonSelectedUpSkinTexture = this.atlas.getTexture("toggle-button-selected-up-skin0000");
			this.toggleButtonSelectedHoverSkinTexture = this.atlas.getTexture("toggle-button-selected-hover-skin0000");
			this.toggleButtonSelectedDownSkinTexture = this.atlas.getTexture("toggle-button-selected-down-skin0000");
			this.toggleButtonSelectedDisabledSkinTexture = this.atlas.getTexture("toggle-button-selected-disabled-skin0000");
			this.quietButtonHoverSkinTexture = this.atlas.getTexture("quiet-button-hover-skin0000");
			this.callToActionButtonUpSkinTexture = this.atlas.getTexture("call-to-action-button-up-skin0000");
			this.callToActionButtonHoverSkinTexture = this.atlas.getTexture("call-to-action-button-hover-skin0000");
			this.dangerButtonUpSkinTexture = this.atlas.getTexture("danger-button-up-skin0000");
			this.dangerButtonHoverSkinTexture = this.atlas.getTexture("danger-button-hover-skin0000");
			this.dangerButtonDownSkinTexture = this.atlas.getTexture("danger-button-down-skin0000");
			this.backButtonUpIconTexture = this.atlas.getTexture("back-button-up-icon0000");
			this.backButtonDisabledIconTexture = this.atlas.getTexture("back-button-disabled-icon0000");
			this.forwardButtonUpIconTexture = this.atlas.getTexture("forward-button-up-icon0000");
			this.forwardButtonDisabledIconTexture = this.atlas.getTexture("forward-button-disabled-icon0000");

			this.tabUpSkinTexture = this.atlas.getTexture("tab-up-skin0000");
			this.tabHoverSkinTexture = this.atlas.getTexture("tab-hover-skin0000");
			this.tabDownSkinTexture = this.atlas.getTexture("tab-down-skin0000");
			this.tabDisabledSkinTexture = this.atlas.getTexture("tab-disabled-skin0000");
			this.tabSelectedUpSkinTexture = this.atlas.getTexture("tab-selected-up-skin0000");
			this.tabSelectedDisabledSkinTexture = this.atlas.getTexture("tab-selected-disabled-skin0000");

			this.stepperIncrementButtonUpSkinTexture = this.atlas.getTexture("numeric-stepper-increment-button-up-skin0000");
			this.stepperIncrementButtonHoverSkinTexture = this.atlas.getTexture("numeric-stepper-increment-button-hover-skin0000");
			this.stepperIncrementButtonDownSkinTexture = this.atlas.getTexture("numeric-stepper-increment-button-down-skin0000");
			this.stepperIncrementButtonDisabledSkinTexture = this.atlas.getTexture("numeric-stepper-increment-button-disabled-skin0000");

			this.stepperDecrementButtonUpSkinTexture = this.atlas.getTexture("numeric-stepper-decrement-button-up-skin0000");
			this.stepperDecrementButtonHoverSkinTexture = this.atlas.getTexture("numeric-stepper-decrement-button-hover-skin0000");
			this.stepperDecrementButtonDownSkinTexture = this.atlas.getTexture("numeric-stepper-decrement-button-down-skin0000");
			this.stepperDecrementButtonDisabledSkinTexture = this.atlas.getTexture("numeric-stepper-decrement-button-disabled-skin0000");

			this.hSliderThumbUpSkinTexture = this.atlas.getTexture("horizontal-slider-thumb-up-skin0000");
			this.hSliderThumbHoverSkinTexture = this.atlas.getTexture("horizontal-slider-thumb-hover-skin0000");
			this.hSliderThumbDownSkinTexture = this.atlas.getTexture("horizontal-slider-thumb-down-skin0000");
			this.hSliderThumbDisabledSkinTexture = this.atlas.getTexture("horizontal-slider-thumb-disabled-skin0000");
			this.hSliderTrackEnabledSkinTexture = this.atlas.getTexture("horizontal-slider-track-enabled-skin0000");

			this.vSliderThumbUpSkinTexture = this.atlas.getTexture("vertical-slider-thumb-up-skin0000");
			this.vSliderThumbHoverSkinTexture = this.atlas.getTexture("vertical-slider-thumb-hover-skin0000");
			this.vSliderThumbDownSkinTexture = this.atlas.getTexture("vertical-slider-thumb-down-skin0000");
			this.vSliderThumbDisabledSkinTexture = this.atlas.getTexture("vertical-slider-thumb-disabled-skin0000");
			this.vSliderTrackEnabledSkinTexture = this.atlas.getTexture("vertical-slider-track-enabled-skin0000");

			this.itemRendererUpSkinTexture = Texture.fromTexture(this.atlas.getTexture("item-renderer-up-skin0000"), ITEM_RENDERER_SKIN_TEXTURE_REGION);
			this.itemRendererHoverSkinTexture = Texture.fromTexture(this.atlas.getTexture("item-renderer-hover-skin0000"), ITEM_RENDERER_SKIN_TEXTURE_REGION);
			this.itemRendererSelectedUpSkinTexture = Texture.fromTexture(this.atlas.getTexture("item-renderer-selected-up-skin0000"), ITEM_RENDERER_SKIN_TEXTURE_REGION);

			this.headerBackgroundSkinTexture = this.atlas.getTexture("header-background-skin0000");
			this.groupedListHeaderBackgroundSkinTexture = this.atlas.getTexture("grouped-list-header-background-skin0000");

			this.checkUpIconTexture = this.atlas.getTexture("check-up-icon0000");
			this.checkHoverIconTexture = this.atlas.getTexture("check-hover-icon0000");
			this.checkDownIconTexture = this.atlas.getTexture("check-down-icon0000");
			this.checkDisabledIconTexture = this.atlas.getTexture("check-disabled-icon0000");
			this.checkSelectedUpIconTexture = this.atlas.getTexture("check-selected-up-icon0000");
			this.checkSelectedHoverIconTexture = this.atlas.getTexture("check-selected-hover-icon0000");
			this.checkSelectedDownIconTexture = this.atlas.getTexture("check-selected-down-icon0000");
			this.checkSelectedDisabledIconTexture = this.atlas.getTexture("check-selected-disabled-icon0000");

			this.radioUpIconTexture = this.atlas.getTexture("radio-up-icon0000");
			this.radioHoverIconTexture = this.atlas.getTexture("radio-hover-icon0000");
			this.radioDownIconTexture = this.atlas.getTexture("radio-down-icon0000");
			this.radioDisabledIconTexture = this.atlas.getTexture("radio-disabled-icon0000");
			this.radioSelectedUpIconTexture = this.atlas.getTexture("radio-selected-up-icon0000");
			this.radioSelectedHoverIconTexture = this.atlas.getTexture("radio-selected-hover-icon0000");
			this.radioSelectedDownIconTexture = this.atlas.getTexture("radio-selected-down-icon0000");
			this.radioSelectedDisabledIconTexture = this.atlas.getTexture("radio-selected-disabled-icon0000");

			this.pageIndicatorNormalSkinTexture = this.atlas.getTexture("page-indicator-normal-symbol0000");
			this.pageIndicatorSelectedSkinTexture = this.atlas.getTexture("page-indicator-selected-symbol0000");

			this.pickerListUpIconTexture = this.atlas.getTexture("picker-list-up-icon0000");
			this.pickerListHoverIconTexture = this.atlas.getTexture("picker-list-hover-icon0000");
			this.pickerListDownIconTexture = this.atlas.getTexture("picker-list-down-icon0000");
			this.pickerListDisabledIconTexture = this.atlas.getTexture("picker-list-disabled-icon0000");

			this.textInputBackgroundEnabledSkinTexture = this.atlas.getTexture("text-input-background-enabled-skin0000");
			this.textInputBackgroundDisabledSkinTexture = this.atlas.getTexture("text-input-background-disabled-skin0000");
			this.textInputBackgroundErrorSkinTexture = this.atlas.getTexture("text-input-background-error-skin0000");
			this.textInputSearchIconTexture = this.atlas.getTexture("search-icon0000");
			this.textInputSearchIconDisabledTexture = this.atlas.getTexture("search-icon-disabled0000");

			this.vScrollBarThumbUpSkinTexture = this.atlas.getTexture("vertical-scroll-bar-thumb-up-skin0000");
			this.vScrollBarThumbHoverSkinTexture = this.atlas.getTexture("vertical-scroll-bar-thumb-hover-skin0000");
			this.vScrollBarThumbDownSkinTexture = this.atlas.getTexture("vertical-scroll-bar-thumb-down-skin0000");
			this.vScrollBarTrackSkinTexture = this.atlas.getTexture("vertical-scroll-bar-track-skin0000");
			this.vScrollBarThumbIconTexture = this.atlas.getTexture("vertical-scroll-bar-thumb-icon0000");
			this.vScrollBarStepButtonUpSkinTexture = this.atlas.getTexture("vertical-scroll-bar-step-button-up-skin0000");
			this.vScrollBarStepButtonHoverSkinTexture = this.atlas.getTexture("vertical-scroll-bar-step-button-hover-skin0000");
			this.vScrollBarStepButtonDownSkinTexture = this.atlas.getTexture("vertical-scroll-bar-step-button-down-skin0000");
			this.vScrollBarStepButtonDisabledSkinTexture = this.atlas.getTexture("vertical-scroll-bar-step-button-disabled-skin0000");
			this.vScrollBarDecrementButtonIconTexture = this.atlas.getTexture("vertical-scroll-bar-decrement-button-icon0000");
			this.vScrollBarIncrementButtonIconTexture = this.atlas.getTexture("vertical-scroll-bar-increment-button-icon0000");

			this.hScrollBarThumbUpSkinTexture = this.atlas.getTexture("horizontal-scroll-bar-thumb-up-skin0000");
			this.hScrollBarThumbHoverSkinTexture = this.atlas.getTexture("horizontal-scroll-bar-thumb-hover-skin0000");
			this.hScrollBarThumbDownSkinTexture = this.atlas.getTexture("horizontal-scroll-bar-thumb-down-skin0000");
			this.hScrollBarTrackSkinTexture = this.atlas.getTexture("horizontal-scroll-bar-track-skin0000");
			this.hScrollBarThumbIconTexture = this.atlas.getTexture("horizontal-scroll-bar-thumb-icon0000");
			this.hScrollBarStepButtonUpSkinTexture = this.atlas.getTexture("horizontal-scroll-bar-step-button-up-skin0000");
			this.hScrollBarStepButtonHoverSkinTexture = this.atlas.getTexture("horizontal-scroll-bar-step-button-hover-skin0000");
			this.hScrollBarStepButtonDownSkinTexture = this.atlas.getTexture("horizontal-scroll-bar-step-button-down-skin0000");
			this.hScrollBarStepButtonDisabledSkinTexture = this.atlas.getTexture("horizontal-scroll-bar-step-button-disabled-skin0000");
			this.hScrollBarDecrementButtonIconTexture = this.atlas.getTexture("horizontal-scroll-bar-decrement-button-icon0000");
			this.hScrollBarIncrementButtonIconTexture = this.atlas.getTexture("horizontal-scroll-bar-increment-button-icon0000");

			this.simpleBorderBackgroundSkinTexture = this.atlas.getTexture("simple-border-background-skin0000");
			this.insetBorderBackgroundSkinTexture = this.atlas.getTexture("inset-border-background-skin0000");
			this.panelBorderBackgroundSkinTexture = this.atlas.getTexture("panel-background-skin0000");
			this.alertBorderBackgroundSkinTexture = this.atlas.getTexture("alert-background-skin0000");

			this.progressBarFillSkinTexture = Texture.fromTexture(this.atlas.getTexture("progress-bar-fill-skin0000"), PROGRESS_BAR_FILL_TEXTURE_REGION);

			this.playPauseButtonPlayUpIconTexture = this.atlas.getTexture("play-pause-toggle-button-play-up-icon0000");
			this.playPauseButtonPauseUpIconTexture = this.atlas.getTexture("play-pause-toggle-button-pause-up-icon0000");
			this.overlayPlayPauseButtonPlayUpIconTexture = this.atlas.getTexture("overlay-play-pause-toggle-button-play-up-icon0000");
			this.fullScreenToggleButtonEnterUpIconTexture = this.atlas.getTexture("full-screen-toggle-button-enter-up-icon0000");
			this.fullScreenToggleButtonExitUpIconTexture = this.atlas.getTexture("full-screen-toggle-button-exit-up-icon0000");
			this.muteToggleButtonMutedUpIconTexture = this.atlas.getTexture("mute-toggle-button-muted-up-icon0000");
			this.muteToggleButtonLoudUpIconTexture = this.atlas.getTexture("mute-toggle-button-loud-up-icon0000");
			this.horizontalVolumeSliderMinimumTrackSkinTexture = this.atlas.getTexture("horizontal-volume-slider-minimum-track-skin0000");
			this.horizontalVolumeSliderMaximumTrackSkinTexture = this.atlas.getTexture("horizontal-volume-slider-maximum-track-skin0000");
			this.verticalVolumeSliderMinimumTrackSkinTexture = this.atlas.getTexture("vertical-volume-slider-minimum-track-skin0000");
			this.verticalVolumeSliderMaximumTrackSkinTexture = this.atlas.getTexture("vertical-volume-slider-maximum-track-skin0000");
			this.popUpVolumeSliderMinimumTrackSkinTexture = this.atlas.getTexture("pop-up-volume-slider-minimum-track-skin0000");
			this.popUpVolumeSliderMaximumTrackSkinTexture = this.atlas.getTexture("pop-up-volume-slider-maximum-track-skin0000");
			this.seekSliderMinimumTrackSkinTexture = this.atlas.getTexture("seek-slider-minimum-track-skin0000");
			this.seekSliderMaximumTrackSkinTexture = this.atlas.getTexture("seek-slider-maximum-track-skin0000");
			this.seekSliderProgressSkinTexture = this.atlas.getTexture("seek-slider-progress-skin0000");

			this.listDrillDownAccessoryTexture = this.atlas.getTexture("drill-down-icon0000");
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

			//autocomplete
			this.getStyleProviderForClass(AutoComplete).defaultStyleFunction = this.setTextInputStyles;
			this.getStyleProviderForClass(List).setFunctionForStyleName(AutoComplete.DEFAULT_CHILD_STYLE_NAME_LIST, this.setDropDownListStyles);

			//button
			this.getStyleProviderForClass(Button).defaultStyleFunction = this.setButtonStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_CALL_TO_ACTION_BUTTON, this.setCallToActionButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_DANGER_BUTTON, this.setDangerButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON, this.setBackButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_FORWARD_BUTTON, this.setForwardButtonStyles);

			//button group
			this.getStyleProviderForClass(ButtonGroup).defaultStyleFunction = this.setButtonGroupStyles;

			//callout
			this.getStyleProviderForClass(Callout).defaultStyleFunction = this.setCalloutStyles;

			//check
			this.getStyleProviderForClass(Check).defaultStyleFunction = this.setCheckStyles;

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
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(DefaultGroupedListItemRenderer.ALTERNATE_STYLE_NAME_DRILL_DOWN, this.setDrillDownItemRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(DefaultGroupedListItemRenderer.ALTERNATE_STYLE_NAME_CHECK, this.setCheckItemRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_ITEM_RENDERER, this.setInsetGroupedListItemRendererStyles);

			//header and footer renderers for grouped list
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).defaultStyleFunction = this.setGroupedListHeaderOrFooterRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_HEADER_RENDERER, this.setInsetGroupedListHeaderRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FOOTER_RENDERER, this.setInsetGroupedListFooterRendererStyles);

			//label
			this.getStyleProviderForClass(Label).defaultStyleFunction = this.setLabelStyles;
			this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_STYLE_NAME_HEADING, this.setHeadingLabelStyles);
			this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_STYLE_NAME_DETAIL, this.setDetailLabelStyles);
			this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_STYLE_NAME_TOOL_TIP, this.setToolTipLabelStyles);

			//layout group
			this.getStyleProviderForClass(LayoutGroup).setFunctionForStyleName(LayoutGroup.ALTERNATE_STYLE_NAME_TOOLBAR, this.setToolbarLayoutGroupStyles);

			//list (see also: item renderers)
			this.getStyleProviderForClass(List).defaultStyleFunction = this.setListStyles;

			//numeric stepper
			this.getStyleProviderForClass(NumericStepper).defaultStyleFunction = this.setNumericStepperStyles;
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_TEXT_INPUT, this.setNumericStepperTextInputStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON, this.setNumericStepperIncrementButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON, this.setNumericStepperDecrementButtonStyles);

			//panel
			this.getStyleProviderForClass(Panel).defaultStyleFunction = this.setPanelStyles;
			this.getStyleProviderForClass(Header).setFunctionForStyleName(Panel.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setPanelHeaderStyles);

			//panel screen
			this.getStyleProviderForClass(PanelScreen).defaultStyleFunction = this.setPanelScreenStyles;

			//page indicator
			this.getStyleProviderForClass(PageIndicator).defaultStyleFunction = this.setPageIndicatorStyles;

			//picker list (see also: item renderers)
			this.getStyleProviderForClass(PickerList).defaultStyleFunction = this.setPickerListStyles;
			this.getStyleProviderForClass(List).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_LIST, this.setDropDownListStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setPickerListButtonStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setPickerListButtonStyles);

			//progress bar
			this.getStyleProviderForClass(ProgressBar).defaultStyleFunction = this.setProgressBarStyles;

			//radio
			this.getStyleProviderForClass(Radio).defaultStyleFunction = this.setRadioStyles;

			//scroll bar
			this.getStyleProviderForClass(ScrollBar).setFunctionForStyleName(Scroller.DEFAULT_CHILD_STYLE_NAME_HORIZONTAL_SCROLL_BAR, this.setHorizontalScrollBarStyles);
			this.getStyleProviderForClass(ScrollBar).setFunctionForStyleName(Scroller.DEFAULT_CHILD_STYLE_NAME_VERTICAL_SCROLL_BAR, this.setVerticalScrollBarStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON, this.setHorizontalScrollBarIncrementButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON, this.setHorizontalScrollBarDecrementButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_THUMB, this.setHorizontalScrollBarThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_MINIMUM_TRACK, this.setHorizontalScrollBarMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON, this.setVerticalScrollBarIncrementButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON, this.setVerticalScrollBarDecrementButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_THUMB, this.setVerticalScrollBarThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_MINIMUM_TRACK, this.setVerticalScrollBarMinimumTrackStyles);

			//scroll container
			this.getStyleProviderForClass(ScrollContainer).defaultStyleFunction = this.setScrollContainerStyles;
			this.getStyleProviderForClass(ScrollContainer).setFunctionForStyleName(ScrollContainer.ALTERNATE_STYLE_NAME_TOOLBAR, this.setToolbarScrollContainerStyles);

			//scroll screen
			this.getStyleProviderForClass(ScrollScreen).defaultStyleFunction = this.setScrollScreenStyles;

			//scroll text
			this.getStyleProviderForClass(ScrollText).defaultStyleFunction = this.setScrollTextStyles;

			//simple scroll bar
			this.getStyleProviderForClass(SimpleScrollBar).setFunctionForStyleName(Scroller.DEFAULT_CHILD_STYLE_NAME_HORIZONTAL_SCROLL_BAR, this.setHorizontalSimpleScrollBarStyles);
			this.getStyleProviderForClass(SimpleScrollBar).setFunctionForStyleName(Scroller.DEFAULT_CHILD_STYLE_NAME_VERTICAL_SCROLL_BAR, this.setVerticalSimpleScrollBarStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB, this.setHorizontalSimpleScrollBarThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB, this.setVerticalSimpleScrollBarThumbStyles);

			//slider
			this.getStyleProviderForClass(Slider).defaultStyleFunction = this.setSliderStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SLIDER_THUMB, this.setHorizontalSliderThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK, this.setHorizontalSliderMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SLIDER_THUMB, this.setVerticalSliderThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK, this.setVerticalSliderMinimumTrackStyles);
			
			//spinner list
			this.getStyleProviderForClass(SpinnerList).defaultStyleFunction = this.setSpinnerListStyles;

			//tab bar
			this.getStyleProviderForClass(TabBar).defaultStyleFunction = this.setTabBarStyles;
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(TabBar.DEFAULT_CHILD_STYLE_NAME_TAB, this.setTabStyles);

			//text area
			this.getStyleProviderForClass(TextArea).defaultStyleFunction = this.setTextAreaStyles;
			this.getStyleProviderForClass(TextFieldTextEditorViewPort).setFunctionForStyleName(TextArea.DEFAULT_CHILD_STYLE_NAME_TEXT_EDITOR, this.setTextAreaTextEditorStyles);
			this.getStyleProviderForClass(TextCallout).setFunctionForStyleName(TextArea.DEFAULT_CHILD_STYLE_NAME_ERROR_CALLOUT, this.setTextAreaErrorCalloutStyles);

			//text callout
			this.getStyleProviderForClass(TextCallout).defaultStyleFunction = this.setTextCalloutStyles;

			//text input
			this.getStyleProviderForClass(TextInput).defaultStyleFunction = this.setTextInputStyles;
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName(TextInput.ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT, this.setSearchTextInputStyles);
			this.getStyleProviderForClass(TextCallout).setFunctionForStyleName(TextInput.DEFAULT_CHILD_STYLE_NAME_ERROR_CALLOUT, this.setTextInputErrorCalloutStyles);
			
			//toggle button
			this.getStyleProviderForClass(ToggleButton).defaultStyleFunction = this.setButtonStyles;
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);

			//toggle switch
			this.getStyleProviderForClass(ToggleSwitch).defaultStyleFunction = this.setToggleSwitchStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_ON_TRACK, this.setToggleSwitchOnTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setToggleSwitchThumbStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setToggleSwitchThumbStyles);

			//media controls
			
			//play/pause toggle button
			this.getStyleProviderForClass(PlayPauseToggleButton).defaultStyleFunction = this.setPlayPauseToggleButtonStyles;
			this.getStyleProviderForClass(PlayPauseToggleButton).setFunctionForStyleName(PlayPauseToggleButton.ALTERNATE_STYLE_NAME_OVERLAY_PLAY_PAUSE_TOGGLE_BUTTON, this.setOverlayPlayPauseToggleButtonStyles);

			//full screen toggle button
			this.getStyleProviderForClass(FullScreenToggleButton).defaultStyleFunction = this.setFullScreenToggleButtonStyles;

			//mute toggle button
			this.getStyleProviderForClass(MuteToggleButton).defaultStyleFunction = this.setMuteToggleButtonStyles;
			this.getStyleProviderForClass(VolumeSlider).setFunctionForStyleName(MuteToggleButton.DEFAULT_CHILD_STYLE_NAME_VOLUME_SLIDER, this.setPopUpVolumeSliderStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MINIMUM_TRACK, this.setPopUpVolumeSliderMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MAXIMUM_TRACK, this.setPopUpVolumeSliderMaximumTrackStyles);

			//seek slider
			this.getStyleProviderForClass(SeekSlider).defaultStyleFunction = this.setSeekSliderStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(SeekSlider.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setHorizontalSliderThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(SeekSlider.DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK, this.setSeekSliderMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(SeekSlider.DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK, this.setSeekSliderMaximumTrackStyles);

			//volume slider
			this.getStyleProviderForClass(VolumeSlider).defaultStyleFunction = this.setVolumeSliderStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(VolumeSlider.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setVolumeSliderThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_VOLUME_SLIDER_MINIMUM_TRACK, this.setHorizontalVolumeSliderMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_VOLUME_SLIDER_MAXIMUM_TRACK, this.setHorizontalVolumeSliderMaximumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_VOLUME_SLIDER_MINIMUM_TRACK, this.setVerticalVolumeSliderMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_VOLUME_SLIDER_MAXIMUM_TRACK, this.setVerticalVolumeSliderMaximumTrackStyles);
		}

		protected function pageIndicatorNormalSymbolFactory():Image
		{
			return new Image(this.pageIndicatorNormalSkinTexture);
		}

		protected function pageIndicatorSelectedSymbolFactory():Image
		{
			return new Image(this.pageIndicatorSelectedSkinTexture);
		}

	//-------------------------
	// Shared
	//-------------------------

		protected function setScrollerStyles(scroller:Scroller):void
		{
			scroller.clipContent = true;
			scroller.horizontalScrollBarFactory = scrollBarFactory;
			scroller.verticalScrollBarFactory = scrollBarFactory;
			scroller.interactionMode = ScrollInteractionMode.MOUSE;
			scroller.scrollBarDisplayMode = ScrollBarDisplayMode.FIXED;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			scroller.focusIndicatorSkin = focusIndicatorSkin;
			scroller.focusPadding = 0;
		}

		protected function setDropDownListStyles(list:List):void
		{
			this.setListStyles(list);

			var layout:VerticalLayout = new VerticalLayout();
			layout.useVirtualLayout = true;
			layout.padding = 0;
			layout.gap = 0;
			layout.horizontalAlign = HorizontalAlign.JUSTIFY;
			layout.verticalAlign = VerticalAlign.TOP;
			layout.resetTypicalItemDimensionsOnMeasure = true;
			layout.maxRowCount = 5;
			list.layout = layout;
		}

	//-------------------------
	// Alert
	//-------------------------

		protected function setAlertStyles(alert:Alert):void
		{
			this.setScrollerStyles(alert);

			var backgroundSkin:Image = new Image(this.alertBorderBackgroundSkinTexture);
			backgroundSkin.scale9Grid = PANEL_BORDER_SCALE_9_GRID;
			alert.backgroundSkin = backgroundSkin;

			alert.fontStyles = this.defaultFontStyles;
			alert.disabledFontStyles = this.disabledFontStyles;

			alert.outerPadding = this.borderSize;

			alert.paddingTop = this.smallGutterSize;
			alert.paddingBottom = this.smallGutterSize;
			alert.paddingRight = this.gutterSize;
			alert.paddingLeft = this.gutterSize;
			alert.gap = this.gutterSize;

			alert.maxWidth = this.popUpSize;
			alert.maxHeight = this.popUpSize;
		}

		protected function setAlertButtonGroupStyles(group:ButtonGroup):void
		{
			group.direction = Direction.HORIZONTAL;
			group.horizontalAlign = HorizontalAlign.CENTER;
			group.verticalAlign = VerticalAlign.JUSTIFY;
			group.distributeButtonSizes = false;
			group.gap = this.smallGutterSize;
			group.padding = this.smallGutterSize;
		}

	//-------------------------
	// Button
	//-------------------------

		protected function setBaseButtonStyles(button:Button):void
		{
			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			button.focusIndicatorSkin = focusIndicatorSkin;
			button.focusPadding = -1;

			button.paddingTop = this.extraSmallGutterSize;
			button.paddingBottom = this.extraSmallGutterSize;
			button.paddingLeft = this.smallGutterSize;
			button.paddingRight = this.smallGutterSize;
			button.gap = this.smallGutterSize;
			button.minGap = this.smallGutterSize;
		}

		protected function setButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonUpSkinTexture);
			skin.setTextureForState(ButtonState.HOVER, this.buttonHoverSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				skin.selectedTexture = this.toggleButtonSelectedUpSkinTexture;
				skin.setTextureForState(ButtonState.HOVER_AND_SELECTED, this.toggleButtonSelectedHoverSkinTexture);
				skin.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.toggleButtonSelectedDownSkinTexture);
				skin.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.toggleButtonSelectedDisabledSkinTexture);
			}
			skin.scale9Grid = BUTTON_SCALE_9_GRID;
			skin.width = this.buttonMinWidth;
			skin.height = this.controlSize;
			skin.minWidth = this.buttonMinWidth;
			skin.minHeight = this.controlSize;
			button.defaultSkin = skin;

			button.fontStyles = this.defaultFontStyles;
			button.disabledFontStyles = this.disabledFontStyles;

			this.setBaseButtonStyles(button);
		}

		protected function setQuietButtonStyles(button:Button):void
		{
			var defaultSkin:Quad = new Quad(this.controlSize, this.controlSize, 0xff00ff);
			defaultSkin.alpha = 0;
			button.defaultSkin = defaultSkin;

			var otherSkin:ImageSkin = new ImageSkin(null);
			otherSkin.setTextureForState(ButtonState.HOVER, this.quietButtonHoverSkinTexture);
			otherSkin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			button.setSkinForState(ButtonState.HOVER, otherSkin);
			button.setSkinForState(ButtonState.DOWN, otherSkin);
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				otherSkin.selectedTexture = this.toggleButtonSelectedUpSkinTexture;
				otherSkin.setTextureForState(ButtonState.HOVER_AND_SELECTED, this.toggleButtonSelectedHoverSkinTexture);
				otherSkin.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.toggleButtonSelectedDownSkinTexture);
				otherSkin.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.toggleButtonSelectedDisabledSkinTexture);
				ToggleButton(button).defaultSelectedSkin = otherSkin;
			}
			otherSkin.scale9Grid = BUTTON_SCALE_9_GRID;
			otherSkin.width = this.controlSize;
			otherSkin.height = this.controlSize;
			otherSkin.minWidth = this.controlSize;
			otherSkin.minHeight = this.controlSize;

			button.fontStyles = this.defaultFontStyles;
			button.disabledFontStyles = this.disabledFontStyles;

			this.setBaseButtonStyles(button);
		}

		protected function setCallToActionButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.callToActionButtonUpSkinTexture);
			skin.setTextureForState(ButtonState.HOVER, this.callToActionButtonHoverSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			skin.scale9Grid = BUTTON_SCALE_9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.controlSize;
			skin.minHeight = this.controlSize;
			button.defaultSkin = skin;

			button.fontStyles = this.defaultFontStyles;
			button.disabledFontStyles = this.disabledFontStyles;

			this.setBaseButtonStyles(button);
		}

		protected function setDangerButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.dangerButtonUpSkinTexture);
			skin.setTextureForState(ButtonState.HOVER, this.dangerButtonHoverSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.dangerButtonDownSkinTexture);
			skin.scale9Grid = BUTTON_SCALE_9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.controlSize;
			skin.minHeight = this.controlSize;
			button.defaultSkin = skin;

			button.fontStyles = this.defaultFontStyles;
			button.disabledFontStyles = this.disabledFontStyles;

			this.setBaseButtonStyles(button);
		}

		protected function setBackButtonStyles(button:Button):void
		{
			this.setButtonStyles(button);

			var icon:ImageSkin = new ImageSkin(this.backButtonUpIconTexture);
			icon.disabledTexture = this.backButtonDisabledIconTexture;
			button.defaultIcon = icon;

			button.iconPosition = RelativePosition.LEFT_BASELINE;
		}

		protected function setForwardButtonStyles(button:Button):void
		{
			this.setButtonStyles(button);

			var icon:ImageSkin = new ImageSkin(this.forwardButtonUpIconTexture);
			icon.disabledTexture = this.forwardButtonDisabledIconTexture;
			button.defaultIcon = icon;

			button.iconPosition = RelativePosition.RIGHT_BASELINE;
		}

	//-------------------------
	// ButtonGroup
	//-------------------------

		protected function setButtonGroupStyles(group:ButtonGroup):void
		{
			group.gap = this.smallGutterSize;
		}

	//-------------------------
	// Callout
	//-------------------------

		protected function setCalloutStyles(callout:Callout):void
		{
			var backgroundSkin:Image = new Image(this.calloutBackgroundSkinTexture);
			backgroundSkin.scale9Grid = CALLOUT_SCALE_9_GRID;
			callout.backgroundSkin = backgroundSkin;

			var topArrowSkin:Image = new Image(this.calloutTopArrowSkinTexture);
			callout.topArrowSkin = topArrowSkin;
			callout.topArrowGap = this.calloutArrowOverlapGap;
			var rightArrowSkin:Image = new Image(this.calloutRightArrowSkinTexture);
			callout.rightArrowSkin = rightArrowSkin;
			callout.rightArrowGap = this.calloutArrowOverlapGap - this.leftAndRightDropShadowSize;
			var bottomArrowSkin:Image = new Image(this.calloutBottomArrowSkinTexture);
			callout.bottomArrowSkin = bottomArrowSkin;
			callout.bottomArrowGap = this.calloutArrowOverlapGap - this.bottomDropShadowSize;
			var leftArrowSkin:Image = new Image(this.calloutLeftArrowSkinTexture);
			callout.leftArrowSkin = leftArrowSkin;
			callout.leftArrowGap = this.calloutArrowOverlapGap - this.leftAndRightDropShadowSize;

			callout.paddingTop = this.smallGutterSize;
			callout.paddingBottom = this.smallGutterSize + this.bottomDropShadowSize;
			callout.paddingRight = this.gutterSize + this.leftAndRightDropShadowSize;
			callout.paddingLeft = this.gutterSize + this.leftAndRightDropShadowSize;
		}

		protected function setDangerCalloutStyles(callout:Callout):void
		{
			var backgroundSkin:Image = new Image(this.dangerCalloutBackgroundSkinTexture);
			backgroundSkin.scale9Grid = CALLOUT_SCALE_9_GRID;
			callout.backgroundSkin = backgroundSkin;

			var topArrowSkin:Image = new Image(this.dangerCalloutTopArrowSkinTexture);
			callout.topArrowSkin = topArrowSkin;
			callout.topArrowGap = this.calloutArrowOverlapGap;
			var rightArrowSkin:Image = new Image(this.dangerCalloutRightArrowSkinTexture);
			callout.rightArrowSkin = rightArrowSkin;
			callout.rightArrowGap = this.calloutArrowOverlapGap - this.leftAndRightDropShadowSize;
			var bottomArrowSkin:Image = new Image(this.dangerCalloutBottomArrowSkinTexture);
			callout.bottomArrowSkin = bottomArrowSkin;
			callout.bottomArrowGap = this.calloutArrowOverlapGap - this.bottomDropShadowSize;
			var leftArrowSkin:Image = new Image(this.dangerCalloutLeftArrowSkinTexture);
			callout.leftArrowSkin = leftArrowSkin;
			callout.leftArrowGap = this.calloutArrowOverlapGap - this.leftAndRightDropShadowSize;

			callout.paddingTop = this.smallGutterSize;
			callout.paddingBottom = this.smallGutterSize + this.bottomDropShadowSize;
			callout.paddingRight = this.gutterSize + this.leftAndRightDropShadowSize;
			callout.paddingLeft = this.gutterSize + this.leftAndRightDropShadowSize;
		}

	//-------------------------
	// Check
	//-------------------------

		protected function setCheckStyles(check:Check):void
		{
			var skin:Quad = new Quad(this.controlSize, this.controlSize);
			skin.alpha = 0;
			check.defaultSkin = skin;

			var icon:ImageSkin = new ImageSkin(this.checkUpIconTexture);
			icon.selectedTexture = this.checkSelectedUpIconTexture;
			icon.setTextureForState(ButtonState.HOVER, this.checkHoverIconTexture);
			icon.setTextureForState(ButtonState.DOWN, this.checkDownIconTexture);
			icon.setTextureForState(ButtonState.DISABLED, this.checkDisabledIconTexture);
			icon.setTextureForState(ButtonState.HOVER_AND_SELECTED, this.checkSelectedHoverIconTexture);
			icon.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.checkSelectedDownIconTexture);
			icon.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.checkSelectedDisabledIconTexture);
			check.defaultIcon = icon;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			check.focusIndicatorSkin = focusIndicatorSkin;
			check.focusPadding = -2;

			check.fontStyles = this.defaultFontStyles;
			check.disabledFontStyles = this.disabledFontStyles;

			check.horizontalAlign = HorizontalAlign.LEFT;
			check.verticalAlign = VerticalAlign.MIDDLE;

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
			this.setItemRendererStyles(itemRenderer);
			itemRenderer.accessoryPosition = RelativePosition.LEFT;
			itemRenderer.accessoryGap = this.smallGutterSize;
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

			list.verticalScrollPolicy = ScrollPolicy.AUTO;

			var backgroundSkin:Image = new Image(this.simpleBorderBackgroundSkinTexture);
			backgroundSkin.scale9Grid = SIMPLE_BORDER_SCALE_9_GRID;
			list.backgroundSkin = backgroundSkin;

			list.padding = this.borderSize;
		}

		//see List section for item renderer styles

		protected function setGroupedListHeaderOrFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			var backgroundSkin:ImageSkin = new ImageSkin(this.groupedListHeaderBackgroundSkinTexture);
			backgroundSkin.scale9Grid = HEADER_SCALE_9_GRID;
			backgroundSkin.height = this.controlSize;
			backgroundSkin.minWidth = this.controlSize;
			backgroundSkin.minHeight = this.controlSize;
			renderer.backgroundSkin = backgroundSkin;

			renderer.fontStyles = this.defaultFontStyles;
			renderer.disabledFontStyles = this.disabledFontStyles;

			renderer.paddingTop = this.extraSmallGutterSize;
			renderer.paddingBottom = this.extraSmallGutterSize;
			renderer.paddingRight = this.smallGutterSize;
			renderer.paddingLeft = this.smallGutterSize;
		}

		protected function setInsetGroupedListStyles(list:GroupedList):void
		{
			this.setScrollerStyles(list);

			list.verticalScrollPolicy = ScrollPolicy.AUTO;

			var backgroundSkin:Image = new Image(this.insetBorderBackgroundSkinTexture);
			backgroundSkin.scale9Grid = SIMPLE_BORDER_SCALE_9_GRID;
			list.backgroundSkin = backgroundSkin;

			list.padding = this.borderSize;

			list.customItemRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_ITEM_RENDERER;
			list.customHeaderRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_HEADER_RENDERER;
			list.customFooterRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FOOTER_RENDERER;

			var layout:VerticalLayout = new VerticalLayout();
			layout.useVirtualLayout = true;
			layout.paddingTop = this.gutterSize;
			layout.paddingBottom = this.gutterSize;
			layout.gap = 0;
			layout.horizontalAlign = HorizontalAlign.JUSTIFY;
			layout.verticalAlign = VerticalAlign.TOP;
			list.layout = layout;
		}

		protected function setInsetGroupedListItemRendererStyles(itemRenderer:BaseDefaultItemRenderer):void
		{
			var skin:ImageSkin = new ImageSkin(this.itemRendererUpSkinTexture);
			skin.selectedTexture = this.itemRendererSelectedUpSkinTexture;
			skin.setTextureForState(ButtonState.HOVER, this.itemRendererHoverSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.itemRendererSelectedUpSkinTexture);
			skin.minWidth = this.controlSize;
			skin.minHeight = this.controlSize;
			itemRenderer.defaultSkin = skin;

			itemRenderer.fontStyles = this.defaultFontStyles;
			itemRenderer.disabledFontStyles = this.disabledFontStyles;
			itemRenderer.iconLabelFontStyles = this.defaultFontStyles;
			itemRenderer.iconLabelDisabledFontStyles = this.disabledFontStyles;
			itemRenderer.accessoryLabelFontStyles = this.defaultFontStyles;
			itemRenderer.accessoryLabelDisabledFontStyles = this.disabledFontStyles;

			itemRenderer.horizontalAlign = HorizontalAlign.LEFT;

			itemRenderer.iconPosition = RelativePosition.LEFT;
			itemRenderer.accessoryPosition = RelativePosition.RIGHT;

			itemRenderer.paddingTop = this.extraSmallGutterSize;
			itemRenderer.paddingBottom = this.extraSmallGutterSize;
			itemRenderer.paddingRight = this.gutterSize;
			itemRenderer.paddingLeft = this.gutterSize;
			itemRenderer.gap = this.extraSmallGutterSize;
			itemRenderer.minGap = this.extraSmallGutterSize;
			itemRenderer.accessoryGap = Number.POSITIVE_INFINITY;
			itemRenderer.minAccessoryGap = this.smallGutterSize;

			itemRenderer.useStateDelayTimer = false;
		}

		protected function setInsetGroupedListHeaderRendererStyles(headerRenderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			var skin:Quad = new Quad(this.controlSize, this.controlSize);
			skin.alpha = 0;
			headerRenderer.backgroundSkin = skin;

			headerRenderer.fontStyles = this.defaultFontStyles;
			headerRenderer.disabledFontStyles = this.disabledFontStyles;

			headerRenderer.paddingTop = this.gutterSize;
			headerRenderer.paddingBottom = this.smallGutterSize;
			headerRenderer.paddingRight = this.gutterSize;
			headerRenderer.paddingLeft = this.gutterSize;
		}

		protected function setInsetGroupedListFooterRendererStyles(footerRenderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			var skin:Quad = new Quad(this.controlSize, this.controlSize);
			skin.alpha = 0;
			footerRenderer.backgroundSkin = skin;

			footerRenderer.fontStyles = this.defaultFontStyles;
			footerRenderer.disabledFontStyles = this.disabledFontStyles;

			footerRenderer.paddingTop = this.smallGutterSize;
			footerRenderer.paddingBottom = this.smallGutterSize;
			footerRenderer.paddingRight = this.gutterSize;
			footerRenderer.paddingLeft = this.gutterSize;
		}

	//-------------------------
	// Header
	//-------------------------

		protected function setHeaderStyles(header:Header):void
		{
			var backgroundSkin:ImageSkin = new ImageSkin(this.headerBackgroundSkinTexture);
			backgroundSkin.scale9Grid = HEADER_SCALE_9_GRID;
			backgroundSkin.minWidth = this.gridSize;
			backgroundSkin.minHeight = this.gridSize;
			header.backgroundSkin = backgroundSkin;

			header.fontStyles = this.defaultFontStyles;
			header.disabledFontStyles = this.disabledFontStyles;

			header.paddingTop = this.extraSmallGutterSize;
			header.paddingBottom = this.extraSmallGutterSize + this.borderSize;
			header.paddingLeft = this.smallGutterSize;
			header.paddingRight = this.smallGutterSize;

			header.gap = this.extraSmallGutterSize;
			header.titleGap = this.gutterSize;
		}

	//-------------------------
	// Label
	//-------------------------

		protected function setLabelStyles(label:Label):void
		{
			label.fontStyles = this.defaultFontStyles;
			label.disabledFontStyles = this.disabledFontStyles;
		}

		protected function setHeadingLabelStyles(label:Label):void
		{
			label.fontStyles = this.headingFontStyles;
			label.disabledFontStyles = this.headingDisabledFontStyles;
		}

		protected function setDetailLabelStyles(label:Label):void
		{
			label.fontStyles = this.detailFontStyles;
			label.disabledFontStyles = this.detailDisabledFontStyles;
		}

		protected function setToolTipLabelStyles(label:Label):void
		{
			var backgroundSkin:Image = new Image(this.toolTipBackgroundSkinTexture);
			backgroundSkin.scale9Grid = TOOL_TIP_SCALE_9_GRID;
			label.backgroundSkin = backgroundSkin;

			label.fontStyles = this.defaultFontStyles;
			label.disabledFontStyles = this.disabledFontStyles;

			label.paddingTop = this.extraSmallGutterSize;
			label.paddingRight = this.smallGutterSize + this.leftAndRightDropShadowSize;
			label.paddingBottom = this.extraSmallGutterSize + this.bottomDropShadowSize;
			label.paddingLeft = this.smallGutterSize + this.leftAndRightDropShadowSize;
		}

	//-------------------------
	// LayoutGroup
	//-------------------------

		protected function setToolbarLayoutGroupStyles(group:LayoutGroup):void
		{
			if(!group.layout)
			{
				var layout:HorizontalLayout = new HorizontalLayout();
				layout.paddingTop = this.extraSmallGutterSize;
				layout.paddingBottom = this.extraSmallGutterSize;
				layout.paddingRight = this.smallGutterSize;
				layout.paddingLeft = this.smallGutterSize;
				layout.gap = this.smallGutterSize;
				layout.verticalAlign = VerticalAlign.MIDDLE;
				group.layout = layout;
			}

			group.minHeight = this.gridSize;

			var backgroundSkin:Image = new Image(this.headerBackgroundSkinTexture);
			backgroundSkin.scale9Grid = HEADER_SCALE_9_GRID;
			group.backgroundSkin = backgroundSkin;
		}

	//-------------------------
	// List
	//-------------------------

		protected function setListStyles(list:List):void
		{
			this.setScrollerStyles(list);

			list.verticalScrollPolicy = ScrollPolicy.AUTO;

			var backgroundSkin:Image = new Image(this.simpleBorderBackgroundSkinTexture);
			backgroundSkin.scale9Grid = SIMPLE_BORDER_SCALE_9_GRID;
			backgroundSkin.width = this.controlSize;
			backgroundSkin.height = this.controlSize;
			list.backgroundSkin = backgroundSkin;

			list.padding = this.borderSize;
		}

		protected function setItemRendererStyles(itemRenderer:BaseDefaultItemRenderer):void
		{
			var skin:ImageSkin = new ImageSkin(this.itemRendererUpSkinTexture);
			skin.selectedTexture = this.itemRendererSelectedUpSkinTexture;
			skin.setTextureForState(ButtonState.HOVER, this.itemRendererHoverSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.itemRendererSelectedUpSkinTexture);
			skin.minWidth = this.controlSize;
			skin.minHeight = this.controlSize;
			itemRenderer.defaultSkin = skin;

			itemRenderer.fontStyles = this.defaultFontStyles;
			itemRenderer.disabledFontStyles = this.disabledFontStyles;
			itemRenderer.iconLabelFontStyles = this.defaultFontStyles;
			itemRenderer.iconLabelDisabledFontStyles = this.disabledFontStyles;
			itemRenderer.accessoryLabelFontStyles = this.defaultFontStyles;
			itemRenderer.accessoryLabelDisabledFontStyles = this.disabledFontStyles;

			itemRenderer.horizontalAlign = HorizontalAlign.LEFT;

			itemRenderer.iconPosition = RelativePosition.LEFT;
			itemRenderer.accessoryPosition = RelativePosition.RIGHT;

			itemRenderer.paddingTop = this.extraSmallGutterSize;
			itemRenderer.paddingBottom = this.extraSmallGutterSize;
			itemRenderer.paddingRight = this.smallGutterSize;
			itemRenderer.paddingLeft = this.smallGutterSize;
			itemRenderer.gap = this.extraSmallGutterSize;
			itemRenderer.minGap = this.extraSmallGutterSize;
			itemRenderer.accessoryGap = Number.POSITIVE_INFINITY;
			itemRenderer.minAccessoryGap = this.smallGutterSize;

			itemRenderer.useStateDelayTimer = false;
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
			var skin:ImageSkin = new ImageSkin(this.itemRendererUpSkinTexture)
			skin.minWidth = this.controlSize;
			skin.minHeight = this.controlSize;
			itemRenderer.defaultSkin = skin;

			itemRenderer.itemHasIcon = false;

			var icon:ImageSkin = new ImageSkin(this.checkUpIconTexture);
			icon.selectedTexture = this.checkSelectedUpIconTexture;
			icon.setTextureForState(ButtonState.HOVER, this.checkHoverIconTexture);
			icon.setTextureForState(ButtonState.DOWN, this.checkDownIconTexture);
			icon.setTextureForState(ButtonState.DISABLED, this.checkDisabledIconTexture);
			icon.setTextureForState(ButtonState.HOVER_AND_SELECTED, this.checkSelectedHoverIconTexture);
			icon.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.checkSelectedDownIconTexture);
			icon.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.checkSelectedDisabledIconTexture);
			itemRenderer.defaultIcon = icon;

			itemRenderer.fontStyles = this.defaultFontStyles;
			itemRenderer.disabledFontStyles = this.disabledFontStyles;
			itemRenderer.iconLabelFontStyles = this.defaultFontStyles;
			itemRenderer.iconLabelDisabledFontStyles = this.disabledFontStyles;
			itemRenderer.accessoryLabelFontStyles = this.defaultFontStyles;
			itemRenderer.accessoryLabelDisabledFontStyles = this.disabledFontStyles;

			itemRenderer.horizontalAlign = HorizontalAlign.LEFT;

			itemRenderer.iconPosition = RelativePosition.LEFT;
			itemRenderer.accessoryPosition = RelativePosition.RIGHT;

			itemRenderer.paddingTop = this.extraSmallGutterSize;
			itemRenderer.paddingBottom = this.extraSmallGutterSize;
			itemRenderer.paddingRight = this.smallGutterSize;
			itemRenderer.paddingLeft = this.smallGutterSize;
			itemRenderer.gap = this.smallGutterSize;
			itemRenderer.minGap = this.smallGutterSize;
			itemRenderer.accessoryGap = Number.POSITIVE_INFINITY;
			itemRenderer.minAccessoryGap = this.smallGutterSize;

			itemRenderer.useStateDelayTimer = false;
		}

	//-------------------------
	// NumericStepper
	//-------------------------

		protected function setNumericStepperStyles(stepper:NumericStepper):void
		{
			stepper.buttonLayoutMode = StepperButtonLayoutMode.RIGHT_SIDE_VERTICAL;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			stepper.focusIndicatorSkin = focusIndicatorSkin;
			stepper.focusPadding = -1;
		}

		protected function setNumericStepperIncrementButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.stepperIncrementButtonUpSkinTexture);
			skin.setTextureForState(ButtonState.HOVER, this.stepperIncrementButtonHoverSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.stepperIncrementButtonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.stepperIncrementButtonDisabledSkinTexture);
			skin.scale9Grid = STEPPER_INCREMENT_BUTTON_SCALE_9_GRID;
			button.defaultSkin = skin;
			button.keepDownStateOnRollOut = true;

			button.hasLabelTextRenderer = false;
		}

		protected function setNumericStepperDecrementButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.stepperDecrementButtonUpSkinTexture);
			skin.setTextureForState(ButtonState.HOVER, this.stepperDecrementButtonHoverSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.stepperDecrementButtonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.stepperDecrementButtonDisabledSkinTexture);
			skin.scale9Grid = STEPPER_DECREMENT_BUTTON_SCALE_9_GRID;
			button.defaultSkin = skin;
			button.keepDownStateOnRollOut = true;

			button.hasLabelTextRenderer = false;
		}

		protected function setNumericStepperTextInputStyles(input:TextInput):void
		{
			var backgroundSkin:ImageSkin = new ImageSkin(this.textInputBackgroundEnabledSkinTexture);
			backgroundSkin.disabledTexture = this.textInputBackgroundDisabledSkinTexture;
			backgroundSkin.scale9Grid = TEXT_INPUT_SCALE_9_GRID;
			backgroundSkin.width = this.controlSize;
			backgroundSkin.height = this.controlSize;
			backgroundSkin.minWidth = this.controlSize;
			backgroundSkin.minHeight = this.controlSize;
			input.backgroundSkin = backgroundSkin;

			input.fontStyles = this.defaultFontStyles;
			input.disabledFontStyles = this.disabledFontStyles;

			input.gap = this.extraSmallGutterSize;
			input.paddingTop = this.extraSmallGutterSize;
			input.paddingBottom = this.extraSmallGutterSize;
			input.paddingRight = this.smallGutterSize;
			input.paddingLeft = this.smallGutterSize;
		}

	//-------------------------
	// PanelScreen
	//-------------------------

		protected function setPanelScreenStyles(screen:PanelScreen):void
		{
			this.setScrollerStyles(screen);
		}

	//-------------------------
	// PageIndicator
	//-------------------------

		protected function setPageIndicatorStyles(pageIndicator:PageIndicator):void
		{
			pageIndicator.interactionMode = PageIndicatorInteractionMode.PRECISE;

			pageIndicator.normalSymbolFactory = this.pageIndicatorNormalSymbolFactory;
			pageIndicator.selectedSymbolFactory = this.pageIndicatorSelectedSymbolFactory;

			pageIndicator.gap = this.gutterSize;
			pageIndicator.padding = this.smallGutterSize;
		}

	//-------------------------
	// Panel
	//-------------------------

		protected function setPanelStyles(panel:Panel):void
		{
			this.setScrollerStyles(panel);

			var backgroundSkin:Image = new Image(this.panelBorderBackgroundSkinTexture);
			backgroundSkin.scale9Grid = PANEL_BORDER_SCALE_9_GRID;
			panel.backgroundSkin = backgroundSkin;

			panel.paddingTop = 0;
			panel.paddingRight = this.gutterSize;
			panel.paddingBottom = this.gutterSize;
			panel.paddingLeft = this.gutterSize;
		}

		protected function setPanelHeaderStyles(header:Header):void
		{
			header.fontStyles = this.defaultFontStyles;
			header.disabledFontStyles = this.disabledFontStyles;

			header.minHeight = this.gridSize;

			header.paddingTop = this.extraSmallGutterSize;
			header.paddingBottom = this.extraSmallGutterSize;
			header.paddingLeft = this.gutterSize;
			header.paddingRight = this.gutterSize;
			header.gap = this.extraSmallGutterSize;
			header.titleGap = this.smallGutterSize;
		}

	//-------------------------
	// PickerList
	//-------------------------

		protected function setPickerListStyles(list:PickerList):void
		{
			list.popUpContentManager = new DropDownPopUpContentManager();
		}

		protected function setPickerListButtonStyles(button:Button):void
		{
			this.setButtonStyles(button);

			var icon:ImageSkin = new ImageSkin(this.pickerListUpIconTexture);
			icon.setTextureForState(ButtonState.HOVER, this.pickerListHoverIconTexture);
			icon.setTextureForState(ButtonState.DOWN, this.pickerListDownIconTexture);
			icon.setTextureForState(ButtonState.DISABLED, this.pickerListDisabledIconTexture);
			button.defaultIcon = icon;

			button.gap = Number.POSITIVE_INFINITY; //fill as completely as possible
			button.minGap = this.smallGutterSize;
			button.horizontalAlign = HorizontalAlign.LEFT;
			button.iconPosition = RelativePosition.RIGHT;
			button.paddingRight = this.smallGutterSize;
		}

		//for the PickerList's pop-up list, see setDropDownListStyles()

	//-------------------------
	// ProgressBar
	//-------------------------

		protected function setProgressBarStyles(progress:ProgressBar):void
		{
			var backgroundSkin:Image = new Image(this.simpleBorderBackgroundSkinTexture);
			backgroundSkin.scale9Grid = SIMPLE_BORDER_SCALE_9_GRID;
			if(progress.direction == Direction.VERTICAL)
			{
				backgroundSkin.height = this.wideControlSize;
			}
			else
			{
				backgroundSkin.width = this.wideControlSize;
			}
			progress.backgroundSkin = backgroundSkin;

			var fillSkin:Image = new Image(this.progressBarFillSkinTexture);
			if(progress.direction == Direction.VERTICAL)
			{
				fillSkin.height = 0;
			}
			else
			{
				fillSkin.width = 0;
			}
			progress.fillSkin = fillSkin;

			progress.padding = this.borderSize;
		}

	//-------------------------
	// Radio
	//-------------------------

		protected function setRadioStyles(radio:Radio):void
		{
			var skin:Quad = new Quad(this.controlSize, this.controlSize);
			skin.alpha = 0;
			radio.defaultSkin = skin;

			var icon:ImageSkin = new ImageSkin(this.radioUpIconTexture);
			icon.selectedTexture = this.radioSelectedUpIconTexture;
			icon.setTextureForState(ButtonState.HOVER, this.radioHoverIconTexture);
			icon.setTextureForState(ButtonState.DOWN, this.radioDownIconTexture);
			icon.setTextureForState(ButtonState.DISABLED, this.radioDisabledIconTexture);
			icon.setTextureForState(ButtonState.HOVER_AND_SELECTED, this.radioSelectedHoverIconTexture);
			icon.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.radioSelectedDownIconTexture);
			icon.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.radioSelectedDisabledIconTexture);
			radio.defaultIcon = icon;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			radio.focusIndicatorSkin = focusIndicatorSkin;
			radio.focusPadding = -2;

			radio.fontStyles = this.defaultFontStyles;
			radio.disabledFontStyles = this.disabledFontStyles;

			radio.horizontalAlign = HorizontalAlign.LEFT;
			radio.verticalAlign = VerticalAlign.MIDDLE;

			radio.gap = this.smallGutterSize;
		}

	//-------------------------
	// ScrollBar
	//-------------------------

		protected function setHorizontalScrollBarStyles(scrollBar:ScrollBar):void
		{
			scrollBar.trackLayoutMode = TrackLayoutMode.SINGLE;

			scrollBar.customIncrementButtonStyleName = THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON;
			scrollBar.customDecrementButtonStyleName = THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON;
			scrollBar.customThumbStyleName = THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_THUMB;
			scrollBar.customMinimumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_MINIMUM_TRACK;
		}

		protected function setVerticalScrollBarStyles(scrollBar:ScrollBar):void
		{
			scrollBar.trackLayoutMode = TrackLayoutMode.SINGLE;

			scrollBar.customIncrementButtonStyleName = THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON;
			scrollBar.customDecrementButtonStyleName = THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON;
			scrollBar.customThumbStyleName = THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_THUMB;
			scrollBar.customMinimumTrackStyleName = THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_MINIMUM_TRACK;
		}

		protected function setHorizontalScrollBarIncrementButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.hScrollBarStepButtonUpSkinTexture);
			skin.setTextureForState(ButtonState.HOVER, this.hScrollBarStepButtonHoverSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.hScrollBarStepButtonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.hScrollBarStepButtonDisabledSkinTexture);
			skin.scale9Grid = HORIZONTAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID;
			button.defaultSkin = skin;

			button.defaultIcon = new Image(this.hScrollBarIncrementButtonIconTexture);

			var incrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
			incrementButtonDisabledIcon.alpha = 0;
			button.disabledIcon = incrementButtonDisabledIcon;

			button.hasLabelTextRenderer = false;
		}

		protected function setHorizontalScrollBarDecrementButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(hScrollBarStepButtonUpSkinTexture);
			skin.setTextureForState(ButtonState.HOVER, this.hScrollBarStepButtonHoverSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.hScrollBarStepButtonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.hScrollBarStepButtonDisabledSkinTexture);
			skin.scale9Grid = HORIZONTAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID;
			button.defaultSkin = skin;

			button.defaultIcon = new Image(this.hScrollBarDecrementButtonIconTexture);

			var decrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
			decrementButtonDisabledIcon.alpha = 0;
			button.disabledIcon = decrementButtonDisabledIcon;

			button.hasLabelTextRenderer = false;
		}

		protected function setHorizontalScrollBarThumbStyles(thumb:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.hScrollBarThumbUpSkinTexture);
			skin.setTextureForState(ButtonState.HOVER, this.hScrollBarThumbHoverSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.hScrollBarThumbDownSkinTexture);
			skin.scale9Grid = HORIZONTAL_SCROLL_BAR_THUMB_SCALE_9_GRID;
			skin.minWidth = this.smallControlSize;
			thumb.defaultSkin = skin;

			thumb.defaultIcon = new Image(this.hScrollBarThumbIconTexture);
			thumb.verticalAlign = VerticalAlign.MIDDLE;
			thumb.paddingBottom = this.extraSmallGutterSize;

			thumb.hasLabelTextRenderer = false;
		}

		protected function setHorizontalScrollBarMinimumTrackStyles(track:Button):void
		{
			var defaultSkin:Image = new Image(this.hScrollBarTrackSkinTexture);
			defaultSkin.scale9Grid = HORIZONTAL_SCROLL_BAR_TRACK_SCALE_9_GRID;
			track.defaultSkin = defaultSkin;

			track.hasLabelTextRenderer = false;
		}

		protected function setVerticalScrollBarIncrementButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.vScrollBarStepButtonUpSkinTexture);
			skin.setTextureForState(ButtonState.HOVER, this.vScrollBarStepButtonHoverSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.vScrollBarStepButtonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.vScrollBarStepButtonDisabledSkinTexture);
			skin.scale9Grid = VERTICAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID;
			button.defaultSkin = skin;

			button.defaultIcon = new Image(this.vScrollBarIncrementButtonIconTexture);

			var incrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
			incrementButtonDisabledIcon.alpha = 0;
			button.disabledIcon = incrementButtonDisabledIcon;

			button.hasLabelTextRenderer = false;
		}

		protected function setVerticalScrollBarDecrementButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.vScrollBarStepButtonUpSkinTexture);
			skin.setTextureForState(ButtonState.HOVER, this.vScrollBarStepButtonHoverSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.vScrollBarStepButtonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.vScrollBarStepButtonDisabledSkinTexture);
			skin.scale9Grid = VERTICAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID;
			button.defaultSkin = skin;

			button.defaultIcon = new Image(this.vScrollBarDecrementButtonIconTexture);

			var decrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
			decrementButtonDisabledIcon.alpha = 0;
			button.disabledIcon = decrementButtonDisabledIcon;

			button.hasLabelTextRenderer = false;
		}

		protected function setVerticalScrollBarThumbStyles(thumb:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.vScrollBarThumbUpSkinTexture);
			skin.setTextureForState(ButtonState.HOVER, this.vScrollBarThumbHoverSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.vScrollBarThumbDownSkinTexture);
			skin.scale9Grid = VERTICAL_SCROLL_BAR_THUMB_SCALE_9_GRID;
			skin.minHeight = this.smallControlSize;
			thumb.defaultSkin = skin;

			thumb.defaultIcon = new Image(this.vScrollBarThumbIconTexture);
			thumb.horizontalAlign = HorizontalAlign.CENTER;
			thumb.paddingRight = this.extraSmallGutterSize;

			thumb.hasLabelTextRenderer = false;
		}

		protected function setVerticalScrollBarMinimumTrackStyles(track:Button):void
		{
			var defaultSkin:Image = new Image(this.vScrollBarTrackSkinTexture);
			defaultSkin.scale9Grid = VERTICAL_SCROLL_BAR_TRACK_SCALE_9_GRID;
			track.defaultSkin = defaultSkin;

			track.hasLabelTextRenderer = false;
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
				layout.paddingTop = this.extraSmallGutterSize;
				layout.paddingBottom = this.extraSmallGutterSize;
				layout.paddingRight = this.smallGutterSize;
				layout.paddingLeft = this.smallGutterSize;
				layout.gap = this.extraSmallGutterSize;
				layout.verticalAlign = VerticalAlign.MIDDLE;
				container.layout = layout;
			}

			var backgroundSkin:Image = new Image(this.headerBackgroundSkinTexture);
			backgroundSkin.scale9Grid = HEADER_SCALE_9_GRID;
			container.backgroundSkin = backgroundSkin;

			container.minHeight = this.gridSize;
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

			text.fontStyles = this.defaultFontStyles;
			text.disabledFontStyles = this.disabledFontStyles;

			text.padding = this.gutterSize;
		}

	//-------------------------
	// SimpleScrollBar
	//-------------------------

		protected function setHorizontalSimpleScrollBarStyles(scrollBar:SimpleScrollBar):void
		{
			scrollBar.customThumbStyleName = THEME_STYLE_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB;
		}

		protected function setVerticalSimpleScrollBarStyles(scrollBar:SimpleScrollBar):void
		{
			scrollBar.customThumbStyleName = THEME_STYLE_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB;
		}

		protected function setHorizontalSimpleScrollBarThumbStyles(thumb:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.hScrollBarThumbUpSkinTexture);
			skin.setTextureForState(ButtonState.HOVER, this.hScrollBarThumbHoverSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.hScrollBarThumbDownSkinTexture);
			skin.scale9Grid = HORIZONTAL_SCROLL_BAR_THUMB_SCALE_9_GRID;
			thumb.defaultSkin = skin;

			thumb.defaultIcon = new Image(this.hScrollBarThumbIconTexture);
			thumb.verticalAlign = VerticalAlign.TOP;
			thumb.paddingTop = this.smallGutterSize;

			thumb.hasLabelTextRenderer = false;
		}

		protected function setVerticalSimpleScrollBarThumbStyles(thumb:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.vScrollBarThumbUpSkinTexture);
			skin.setTextureForState(ButtonState.HOVER, this.vScrollBarThumbHoverSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.vScrollBarThumbDownSkinTexture);
			skin.scale9Grid = VERTICAL_SCROLL_BAR_THUMB_SCALE_9_GRID;
			thumb.defaultSkin = skin;

			thumb.defaultIcon = new Image(this.vScrollBarThumbIconTexture);
			thumb.horizontalAlign = HorizontalAlign.LEFT;
			thumb.paddingLeft = this.smallGutterSize;

			thumb.hasLabelTextRenderer = false;
		}

	//-------------------------
	// Slider
	//-------------------------

		protected function setSliderStyles(slider:Slider):void
		{
			slider.trackLayoutMode = TrackLayoutMode.SINGLE;
			slider.minimumPadding = slider.maximumPadding = -vSliderThumbUpSkinTexture.height / 2;

			if(slider.direction == Direction.VERTICAL)
			{
				slider.customThumbStyleName = THEME_STYLE_NAME_VERTICAL_SLIDER_THUMB;
				slider.customMinimumTrackStyleName = THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK;

				slider.focusPaddingLeft = slider.focusPaddingRight = -2;
				slider.focusPaddingTop = slider.focusPaddingBottom = -2 + slider.minimumPadding;
			}
			else //horizontal
			{
				slider.customThumbStyleName = THEME_STYLE_NAME_HORIZONTAL_SLIDER_THUMB;
				slider.customMinimumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK;

				slider.focusPaddingTop = slider.focusPaddingBottom = -2;
				slider.focusPaddingLeft = slider.focusPaddingRight = -2 + slider.minimumPadding;
			}

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			slider.focusIndicatorSkin = focusIndicatorSkin;
		}

		protected function setHorizontalSliderThumbStyles(thumb:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.hSliderThumbUpSkinTexture);
			skin.setTextureForState(ButtonState.HOVER, this.hSliderThumbHoverSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.hSliderThumbDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.hSliderThumbDisabledSkinTexture);
			thumb.defaultSkin = skin;

			thumb.hasLabelTextRenderer = false;
		}

		protected function setHorizontalSliderMinimumTrackStyles(track:Button):void
		{
			var defaultSkin:Image = new Image(this.hSliderTrackEnabledSkinTexture);
			defaultSkin.scale9Grid = HORIZONTAL_SLIDER_TRACK_SCALE_9_GRID;
			defaultSkin.width = this.wideControlSize;
			track.defaultSkin = defaultSkin;

			track.minTouchHeight = this.controlSize;

			track.hasLabelTextRenderer = false;
		}

		protected function setVerticalSliderThumbStyles(thumb:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.vSliderThumbUpSkinTexture);
			skin.setTextureForState(ButtonState.HOVER, this.vSliderThumbHoverSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.vSliderThumbDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.vSliderThumbDisabledSkinTexture);
			thumb.defaultSkin = skin;

			thumb.hasLabelTextRenderer = false;
		}

		protected function setVerticalSliderMinimumTrackStyles(track:Button):void
		{
			var defaultSkin:Image = new Image(this.vSliderTrackEnabledSkinTexture);
			defaultSkin.scale9Grid = VERTICAL_SLIDER_TRACK_SCALE_9_GRID;
			defaultSkin.height = this.wideControlSize;
			track.defaultSkin = defaultSkin;

			track.minTouchWidth = this.controlSize;

			track.hasLabelTextRenderer = false;
		}

	//-------------------------
	// SpinnerList
	//-------------------------

		protected function setSpinnerListStyles(list:SpinnerList):void
		{
			this.setListStyles(list);
		}

	//-------------------------
	// TabBar
	//-------------------------

		protected function setTabBarStyles(tabBar:TabBar):void
		{
			tabBar.distributeTabSizes = false;
			tabBar.horizontalAlign = HorizontalAlign.LEFT;
			tabBar.verticalAlign = VerticalAlign.JUSTIFY;
		}

		protected function setTabStyles(tab:ToggleButton):void
		{
			var skin:ImageSkin = new ImageSkin(this.tabUpSkinTexture);
			skin.selectedTexture = this.tabSelectedUpSkinTexture;
			skin.setTextureForState(ButtonState.HOVER, this.tabHoverSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.tabDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.tabDisabledSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.tabSelectedDisabledSkinTexture);
			skin.scale9Grid = TAB_SCALE_9_GRID;
			skin.minWidth = this.buttonMinWidth;
			skin.minHeight = this.controlSize;
			tab.defaultSkin = skin;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			tab.focusIndicatorSkin = focusIndicatorSkin;

			tab.fontStyles = this.defaultFontStyles;
			tab.disabledFontStyles = this.disabledFontStyles;

			tab.paddingTop = this.extraSmallGutterSize;
			tab.paddingBottom = this.extraSmallGutterSize;
			tab.paddingLeft = this.smallGutterSize;
			tab.paddingRight = this.smallGutterSize;
			tab.gap = this.extraSmallGutterSize;
		}

	//-------------------------
	// TextArea
	//-------------------------

		protected function setTextAreaStyles(textArea:TextArea):void
		{
			this.setScrollerStyles(textArea);

			var skin:ImageSkin = new ImageSkin(this.textInputBackgroundEnabledSkinTexture);
			skin.disabledTexture = this.textInputBackgroundDisabledSkinTexture;
			skin.setTextureForState(TextInputState.ERROR, this.textInputBackgroundErrorSkinTexture);
			skin.scale9Grid = TEXT_INPUT_SCALE_9_GRID;
			skin.width = this.wideControlSize * 2;
			skin.height = this.wideControlSize;
			textArea.backgroundSkin = skin;

			textArea.fontStyles = this.defaultFontStyles;
			textArea.disabledFontStyles = this.disabledFontStyles;

			textArea.focusPadding = -2;
			textArea.padding = this.borderSize;
		}

		protected function setTextAreaTextEditorStyles(textEditor:TextFieldTextEditorViewPort):void
		{
			textEditor.paddingTop = this.extraSmallGutterSize;
			textEditor.paddingRight = this.smallGutterSize;
			textEditor.paddingBottom = this.extraSmallGutterSize;
			textEditor.paddingLeft = this.smallGutterSize;
		}

		protected function setTextAreaErrorCalloutStyles(callout:TextCallout):void
		{
			this.setDangerTextCalloutStyles(callout);
			callout.verticalAlign = VerticalAlign.TOP;
			callout.horizontalAlign = HorizontalAlign.LEFT;
			callout.supportedPositions = new <String>[RelativePosition.RIGHT,
				RelativePosition.TOP, RelativePosition.BOTTOM, RelativePosition.LEFT];
		}

	//-------------------------
	// TextCallout
	//-------------------------

		protected function setTextCalloutStyles(callout:TextCallout):void
		{
			this.setCalloutStyles(callout);

			callout.fontStyles = this.defaultFontStyles;
			callout.disabledFontStyles = this.disabledFontStyles;
		}

		protected function setDangerTextCalloutStyles(callout:TextCallout):void
		{
			this.setDangerCalloutStyles(callout);

			callout.fontStyles = this.invertedFontStyles;
			callout.disabledFontStyles = this.disabledFontStyles;
		}

	//-------------------------
	// TextInput
	//-------------------------

		protected function setBaseTextInputStyles(input:TextInput):void
		{
			var skin:ImageSkin = new ImageSkin(this.textInputBackgroundEnabledSkinTexture);
			skin.disabledTexture = this.textInputBackgroundDisabledSkinTexture;
			skin.setTextureForState(TextInputState.ERROR, this.textInputBackgroundErrorSkinTexture);
			skin.scale9Grid = TEXT_INPUT_SCALE_9_GRID;
			skin.width = this.wideControlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.wideControlSize;
			skin.minHeight = this.controlSize;
			input.backgroundSkin = skin;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			input.focusIndicatorSkin = focusIndicatorSkin;
			input.focusPadding = -2;

			input.gap = this.extraSmallGutterSize;
			input.paddingTop = this.extraSmallGutterSize;
			input.paddingBottom = this.extraSmallGutterSize;
			input.paddingRight = this.smallGutterSize;
			input.paddingLeft = this.smallGutterSize;
		}

		protected function setTextInputStyles(input:TextInput):void
		{
			this.setBaseTextInputStyles(input);

			input.fontStyles = this.defaultFontStyles;
			input.disabledFontStyles = this.disabledFontStyles;

			input.promptFontStyles = this.defaultFontStyles;
			input.promptDisabledFontStyles = this.disabledFontStyles;
		}

		protected function setSearchTextInputStyles(input:TextInput):void
		{
			this.setBaseTextInputStyles(input);

			var icon:ImageSkin = new ImageSkin(this.textInputSearchIconTexture);
			icon.disabledTexture = this.textInputSearchIconDisabledTexture;
			input.defaultIcon = icon;

			input.fontStyles = this.defaultFontStyles;
			input.disabledFontStyles = this.disabledFontStyles;

			input.promptFontStyles = this.defaultFontStyles;
			input.promptDisabledFontStyles = this.disabledFontStyles;
		}

		protected function setTextInputErrorCalloutStyles(callout:TextCallout):void
		{
			this.setDangerTextCalloutStyles(callout);

			callout.verticalAlign = VerticalAlign.TOP;
			callout.horizontalAlign = HorizontalAlign.LEFT;
			callout.supportedPositions = new <String>[RelativePosition.RIGHT,
				RelativePosition.TOP, RelativePosition.BOTTOM, RelativePosition.LEFT];
		}

	//-------------------------
	// ToggleSwitch
	//-------------------------

		protected function setToggleSwitchStyles(toggle:ToggleSwitch):void
		{
			toggle.onLabelFontStyles = this.defaultFontStyles;
			toggle.onLabelDisabledFontStyles = this.disabledFontStyles;

			toggle.offLabelFontStyles = this.defaultFontStyles;
			toggle.offLabelDisabledFontStyles = this.disabledFontStyles;

			toggle.trackLayoutMode = TrackLayoutMode.SINGLE;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			toggle.focusIndicatorSkin = focusIndicatorSkin;
			toggle.focusPadding = -1;
		}

		protected function setToggleSwitchOnTrackStyles(track:Button):void
		{
			var defaultSkin:Image = new Image(this.toggleButtonSelectedUpSkinTexture);
			defaultSkin.scale9Grid = BUTTON_SCALE_9_GRID;
			defaultSkin.width = 2 * this.controlSize + this.smallControlSize;
			track.defaultSkin = defaultSkin;

			track.hasLabelTextRenderer = false;
		}

		protected function setToggleSwitchThumbStyles(thumb:Button):void
		{
			this.setButtonStyles(thumb);
			
			thumb.width = this.controlSize;
			thumb.height = this.controlSize;

			thumb.hasLabelTextRenderer = false;
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
			otherSkin.setTextureForState(ButtonState.HOVER, this.quietButtonHoverSkinTexture);
			otherSkin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			otherSkin.setTextureForState(ButtonState.HOVER_AND_SELECTED, this.toggleButtonSelectedHoverSkinTexture);
			otherSkin.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.toggleButtonSelectedDownSkinTexture);
			otherSkin.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.toggleButtonSelectedDisabledSkinTexture);
			otherSkin.width = this.controlSize;
			otherSkin.height = this.controlSize;
			otherSkin.minWidth = this.controlSize;
			otherSkin.minHeight = this.controlSize;
			button.setSkinForState(ButtonState.HOVER, otherSkin);
			button.setSkinForState(ButtonState.DOWN, otherSkin);
			button.setSkinForState(ButtonState.HOVER_AND_SELECTED, otherSkin);
			button.setSkinForState(ButtonState.DOWN_AND_SELECTED, otherSkin);
			button.setSkinForState(ButtonState.DISABLED_AND_SELECTED, otherSkin);

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			button.focusIndicatorSkin = focusIndicatorSkin;
			button.focusPadding = -1;

			var icon:ImageSkin = new ImageSkin(this.playPauseButtonPlayUpIconTexture);
			icon.selectedTexture = this.playPauseButtonPauseUpIconTexture;
			button.defaultIcon = icon;

			button.hasLabelTextRenderer = false;

			button.paddingTop = this.extraSmallGutterSize;
			button.paddingRight = this.smallGutterSize;
			button.paddingBottom = this.extraSmallGutterSize;
			button.paddingLeft = this.smallGutterSize;
			button.gap = this.smallGutterSize;
		}

		protected function setOverlayPlayPauseToggleButtonStyles(button:PlayPauseToggleButton):void
		{
			var icon:ImageSkin = new ImageSkin(null);
			icon.setTextureForState(ButtonState.UP, this.overlayPlayPauseButtonPlayUpIconTexture);
			icon.setTextureForState(ButtonState.HOVER, this.overlayPlayPauseButtonPlayUpIconTexture);
			icon.setTextureForState(ButtonState.DOWN, this.overlayPlayPauseButtonPlayUpIconTexture);
			button.defaultIcon = icon;

			button.isFocusEnabled = false;

			button.hasLabelTextRenderer = false;

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
			otherSkin.setTextureForState(ButtonState.HOVER, this.quietButtonHoverSkinTexture);
			otherSkin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			otherSkin.setTextureForState(ButtonState.HOVER_AND_SELECTED, this.toggleButtonSelectedHoverSkinTexture);
			otherSkin.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.toggleButtonSelectedDownSkinTexture);
			otherSkin.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.toggleButtonSelectedDisabledSkinTexture);
			otherSkin.width = this.controlSize;
			otherSkin.height = this.controlSize;
			otherSkin.minWidth = this.controlSize;
			otherSkin.minHeight = this.controlSize;
			button.setSkinForState(ButtonState.HOVER, otherSkin);
			button.setSkinForState(ButtonState.DOWN, otherSkin);
			button.setSkinForState(ButtonState.HOVER_AND_SELECTED, otherSkin);
			button.setSkinForState(ButtonState.DOWN_AND_SELECTED, otherSkin);
			button.setSkinForState(ButtonState.DISABLED_AND_SELECTED, otherSkin);

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			button.focusIndicatorSkin = focusIndicatorSkin;
			button.focusPadding = -1;

			var icon:ImageSkin = new ImageSkin(this.fullScreenToggleButtonEnterUpIconTexture);
			icon.selectedTexture = this.fullScreenToggleButtonExitUpIconTexture;
			button.defaultIcon = icon;

			button.hasLabelTextRenderer = false;

			button.paddingTop = this.extraSmallGutterSize;
			button.paddingRight = this.smallGutterSize;
			button.paddingBottom = this.extraSmallGutterSize;
			button.paddingLeft = this.smallGutterSize;
			button.gap = this.smallGutterSize;
		}

	//-------------------------
	// VolumeSlider
	//-------------------------

		protected function setVolumeSliderStyles(slider:VolumeSlider):void
		{
			slider.trackLayoutMode = TrackLayoutMode.SPLIT;
			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			slider.focusIndicatorSkin = focusIndicatorSkin;
			slider.focusPadding = -1;
			slider.showThumb = false;
			if(slider.direction == Direction.VERTICAL)
			{
				slider.customMinimumTrackStyleName = THEME_STYLE_NAME_VERTICAL_VOLUME_SLIDER_MINIMUM_TRACK;
				slider.customMaximumTrackStyleName = THEME_STYLE_NAME_VERTICAL_VOLUME_SLIDER_MAXIMUM_TRACK;
				slider.width = this.verticalVolumeSliderMinimumTrackSkinTexture.width;
				slider.height = this.verticalVolumeSliderMinimumTrackSkinTexture.height;
			}
			else //horizontal
			{
				slider.customMinimumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_VOLUME_SLIDER_MINIMUM_TRACK;
				slider.customMaximumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_VOLUME_SLIDER_MAXIMUM_TRACK;
				slider.width = this.horizontalVolumeSliderMinimumTrackSkinTexture.width;
				slider.height = this.horizontalVolumeSliderMinimumTrackSkinTexture.height;
			}
		}

		protected function setVolumeSliderThumbStyles(button:Button):void
		{
			var thumbSize:Number = 6;
			button.defaultSkin = new Quad(thumbSize, thumbSize);
			button.defaultSkin.width = 0;
			button.defaultSkin.height = 0;
			button.hasLabelTextRenderer = false;
		}

		protected function setHorizontalVolumeSliderMinimumTrackStyles(track:Button):void
		{
			var defaultSkin:ImageLoader = new ImageLoader();
			defaultSkin.scaleContent = false;
			defaultSkin.source = this.horizontalVolumeSliderMinimumTrackSkinTexture;
			track.defaultSkin = defaultSkin;
			track.hasLabelTextRenderer = false;
		}

		protected function setHorizontalVolumeSliderMaximumTrackStyles(track:Button):void
		{
			var defaultSkin:ImageLoader = new ImageLoader();
			defaultSkin.scaleContent = false;
			defaultSkin.horizontalAlign = HorizontalAlign.RIGHT;
			defaultSkin.source = this.horizontalVolumeSliderMaximumTrackSkinTexture;
			track.defaultSkin = defaultSkin;
			track.hasLabelTextRenderer = false;
		}

		protected function setVerticalVolumeSliderMinimumTrackStyles(track:Button):void
		{
			var defaultSkin:ImageLoader = new ImageLoader();
			defaultSkin.scaleContent = false;
			defaultSkin.verticalAlign = VerticalAlign.BOTTOM;
			defaultSkin.source = this.verticalVolumeSliderMinimumTrackSkinTexture;
			track.defaultSkin = defaultSkin;
			track.hasLabelTextRenderer = false;
		}

		protected function setVerticalVolumeSliderMaximumTrackStyles(track:Button):void
		{
			var defaultSkin:ImageLoader = new ImageLoader();
			defaultSkin.scaleContent = false;
			defaultSkin.source = this.verticalVolumeSliderMaximumTrackSkinTexture;
			track.defaultSkin = defaultSkin;
			track.hasLabelTextRenderer = false;
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
			otherSkin.setTextureForState(ButtonState.HOVER, this.quietButtonHoverSkinTexture);
			otherSkin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			otherSkin.setTextureForState(ButtonState.HOVER_AND_SELECTED, this.toggleButtonSelectedHoverSkinTexture);
			otherSkin.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.toggleButtonSelectedDownSkinTexture);
			otherSkin.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.toggleButtonSelectedDisabledSkinTexture);
			otherSkin.width = this.controlSize;
			otherSkin.height = this.controlSize;
			otherSkin.minWidth = this.controlSize;
			otherSkin.minHeight = this.controlSize;
			button.setSkinForState(ButtonState.HOVER, otherSkin);
			button.setSkinForState(ButtonState.DOWN, otherSkin);
			button.setSkinForState(ButtonState.HOVER_AND_SELECTED, otherSkin);
			button.setSkinForState(ButtonState.DOWN_AND_SELECTED, otherSkin);
			button.setSkinForState(ButtonState.DISABLED_AND_SELECTED, otherSkin);

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			button.focusIndicatorSkin = focusIndicatorSkin;
			button.focusPadding = -1;

			var icon:ImageSkin = new ImageSkin(this.muteToggleButtonLoudUpIconTexture);
			icon.selectedTexture = this.muteToggleButtonMutedUpIconTexture;
			button.defaultIcon = icon;

			button.showVolumeSliderOnHover = true;
			button.hasLabelTextRenderer = false;

			button.paddingTop = this.extraSmallGutterSize;
			button.paddingRight = this.smallGutterSize;
			button.paddingBottom = this.extraSmallGutterSize;
			button.paddingLeft = this.smallGutterSize;
			button.gap = this.smallGutterSize;
		}

		protected function setPopUpVolumeSliderStyles(slider:VolumeSlider):void
		{
			slider.direction = Direction.VERTICAL;
			slider.trackLayoutMode = TrackLayoutMode.SPLIT;
			slider.showThumb = false;
			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			slider.focusIndicatorSkin = focusIndicatorSkin;
			slider.focusPadding = 4;
			slider.width = this.popUpVolumeSliderMinimumTrackSkinTexture.width;
			slider.height = this.popUpVolumeSliderMinimumTrackSkinTexture.height;
			slider.minimumPadding = this.popUpVolumeSliderPaddingSize;
			slider.maximumPadding = this.popUpVolumeSliderPaddingSize;
			slider.customMinimumTrackStyleName = THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MINIMUM_TRACK;
			slider.customMaximumTrackStyleName = THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MAXIMUM_TRACK;
		}

		protected function setPopUpVolumeSliderMinimumTrackStyles(track:Button):void
		{
			var defaultSkin:ImageLoader = new ImageLoader();
			defaultSkin.scaleContent = false;
			defaultSkin.verticalAlign = VerticalAlign.BOTTOM;
			defaultSkin.source = this.popUpVolumeSliderMinimumTrackSkinTexture;
			track.defaultSkin = defaultSkin;
			track.hasLabelTextRenderer = false;
		}

		protected function setPopUpVolumeSliderMaximumTrackStyles(track:Button):void
		{
			var defaultSkin:ImageLoader = new ImageLoader();
			defaultSkin.scaleContent = false;
			defaultSkin.source = this.popUpVolumeSliderMaximumTrackSkinTexture;
			track.defaultSkin = defaultSkin;
			track.hasLabelTextRenderer = false;
		}

	//-------------------------
	// SeekSlider
	//-------------------------

		protected function setSeekSliderStyles(slider:SeekSlider):void
		{
			slider.direction = Direction.HORIZONTAL;
			slider.trackLayoutMode = TrackLayoutMode.SPLIT;

			slider.minimumPadding = slider.maximumPadding = -this.vSliderThumbUpSkinTexture.height / 2;

			slider.focusPaddingTop = slider.focusPaddingBottom = -2;
			slider.focusPaddingLeft = slider.focusPaddingRight = -2 + slider.minimumPadding;

			var progressSkin:Image = new Image(this.seekSliderProgressSkinTexture);
			progressSkin.scale9Grid = SEEK_SLIDER_MAXIMUM_TRACK_SCALE_9_GRID;
			progressSkin.width = this.smallControlSize;
			slider.progressSkin = progressSkin;
		}

		protected function setSeekSliderMinimumTrackStyles(track:Button):void
		{
			var defaultSkin:ImageSkin = new ImageSkin(this.seekSliderMinimumTrackSkinTexture);
			defaultSkin.scale9Grid = SEEK_SLIDER_MINIMUM_TRACK_SCALE_9_GRID;
			defaultSkin.width = this.wideControlSize;
			defaultSkin.minWidth = this.wideControlSize;
			track.defaultSkin = defaultSkin;

			track.minTouchHeight = this.controlSize;
			track.hasLabelTextRenderer = false;
		}

		protected function setSeekSliderMaximumTrackStyles(track:Button):void
		{
			var defaultSkin:ImageSkin = new ImageSkin(this.seekSliderMaximumTrackSkinTexture);
			defaultSkin.scale9Grid = SEEK_SLIDER_MAXIMUM_TRACK_SCALE_9_GRID;
			defaultSkin.width = this.wideControlSize;
			defaultSkin.minWidth = this.wideControlSize;
			track.defaultSkin = defaultSkin;

			track.minTouchHeight = this.controlSize;
			track.hasLabelTextRenderer = false;
		}
	}
}
