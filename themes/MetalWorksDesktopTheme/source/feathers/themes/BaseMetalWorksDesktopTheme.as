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
	import feathers.controls.text.TextBlockTextEditor;
	import feathers.controls.text.TextBlockTextRenderer;
	import feathers.controls.text.TextFieldTextEditorViewPort;
	import feathers.core.FeathersControl;
	import feathers.core.FocusManager;
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
	import feathers.media.VideoPlayer;
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
	 * The base class for the "Metal Works" theme for desktop Feathers apps.
	 * Handles everything except asset loading, which is left to subclasses.
	 *
	 * @see MetalWorksDesktopTheme
	 * @see MetalWorksDesktopThemeWithAssetManager
	 */
	public class BaseMetalWorksDesktopTheme extends StyleNameFunctionTheme
	{
		[Embed(source="/../assets/fonts/SourceSansPro-Regular.ttf",fontFamily="SourceSansPro",fontWeight="normal",mimeType="application/x-font",embedAsCFF="true")]
		protected static const SOURCE_SANS_PRO_REGULAR:Class;

		[Embed(source="/../assets/fonts/SourceSansPro-Semibold.ttf",fontFamily="SourceSansPro",fontWeight="bold",mimeType="application/x-font",embedAsCFF="true")]
		protected static const SOURCE_SANS_PRO_SEMIBOLD:Class;

		/**
		 * The name of the embedded font used by controls in this theme. Comes
		 * in normal and bold weights.
		 */
		public static const FONT_NAME:String = "SourceSansPro";

		/**
		 * The stack of fonts to use for controls that don't use embedded fonts.
		 */
		public static const FONT_NAME_STACK:String = "Source Sans Pro,Helvetica,_sans";

		protected static const PRIMARY_BACKGROUND_COLOR:uint = 0x4a4137;
		protected static const LIGHT_TEXT_COLOR:uint = 0xe5e5e5;
		protected static const DARK_TEXT_COLOR:uint = 0x1a1816;
		protected static const SELECTED_TEXT_COLOR:uint = 0xff9900;
		protected static const LIGHT_DISABLED_TEXT_COLOR:uint = 0x8a8a8a;
		protected static const DARK_DISABLED_TEXT_COLOR:uint = 0x383430;
		protected static const GROUPED_LIST_HEADER_BACKGROUND_COLOR:uint = 0x292523;
		protected static const GROUPED_LIST_FOOTER_BACKGROUND_COLOR:uint = 0x292523;
		protected static const SCROLL_BAR_TRACK_COLOR:uint = 0x1a1816;
		protected static const SCROLL_BAR_TRACK_DOWN_COLOR:uint = 0xff7700;
		protected static const TEXT_SELECTION_BACKGROUND_COLOR:uint = 0x574f46;
		protected static const MODAL_OVERLAY_COLOR:uint = 0x29241e;
		protected static const MODAL_OVERLAY_ALPHA:Number = 0.8;
		protected static const DRAWER_OVERLAY_COLOR:uint = 0x29241e;
		protected static const DRAWER_OVERLAY_ALPHA:Number = 0.4;
		protected static const VIDEO_OVERLAY_COLOR:uint = 0x1a1816;
		protected static const VIDEO_OVERLAY_ALPHA:Number = 0.2;

		protected static const DEFAULT_SCALE9_GRID:Rectangle = new Rectangle(3, 3, 1, 1);
		protected static const SIMPLE_SCALE9_GRID:Rectangle = new Rectangle(2, 2, 1, 1);
		protected static const BUTTON_SCALE9_GRID:Rectangle = new Rectangle(3, 3, 1, 16);
		protected static const TOGGLE_BUTTON_SCALE9_GRID:Rectangle = new Rectangle(4, 4, 1, 14);
		protected static const SCROLL_BAR_STEP_BUTTON_SCALE9_GRID:Rectangle = new Rectangle(3, 3, 6, 6);
		protected static const VOLUME_SLIDER_TRACK_SCALE9_GRID:Rectangle = new Rectangle(12, 12, 1, 1);
		protected static const BACK_BUTTON_SCALE9_GRID:Rectangle = new Rectangle(13, 0, 1, 22);
		protected static const FORWARD_BUTTON_SCALE9_GRID:Rectangle = new Rectangle(3, 0, 1, 22);
		protected static const FOCUS_INDICATOR_SCALE_9_GRID:Rectangle = new Rectangle(5, 5, 1, 1);
		protected static const TAB_SCALE9_GRID:Rectangle = new Rectangle(7, 7, 1, 11);
		protected static const HORIZONTAL_SCROLL_BAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(5, 0, 14, 10);
		protected static const VERTICAL_SCROLL_BAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(0, 5, 10, 14);
		
		protected static const ITEM_RENDERER_SKIN_TEXTURE_REGION:Rectangle = new Rectangle(1, 1, 1, 1);
		protected static const ITEM_RENDERER_SELECTED_SKIN_TEXTURE_REGION:Rectangle = new Rectangle(1, 1, 1, 22);

		/**
		 * @private
		 * The theme's custom style name for the increment button of a horizontal ScrollBar.
		 */
		protected static const THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON:String = "metalworks-desktop-horizontal-scroll-bar-increment-button";

		/**
		 * @private
		 * The theme's custom style name for the decrement button of a horizontal ScrollBar.
		 */
		protected static const THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON:String = "metalworks-desktop-horizontal-scroll-bar-decrement-button";

		/**
		 * @private
		 * The theme's custom style name for the thumb of a horizontal ScrollBar.
		 */
		protected static const THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_THUMB:String = "metalworks-desktop-horizontal-scroll-bar-thumb";

		/**
		 * @private
		 * The theme's custom style name for the minimum track of a horizontal ScrollBar.
		 */
		protected static const THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_MINIMUM_TRACK:String = "metalworks-desktop-horizontal-scroll-bar-minimum-track";

		/**
		 * @private
		 * The theme's custom style name for the maximum track of a horizontal ScrollBar.
		 */
		protected static const THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_MAXIMUM_TRACK:String = "metalworks-desktop-horizontal-scroll-bar-maximum-track";

		/**
		 * @private
		 * The theme's custom style name for the increment button of a vertical ScrollBar.
		 */
		protected static const THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON:String = "metalworks-desktop-vertical-scroll-bar-increment-button";

		/**
		 * @private
		 * The theme's custom style name for the decrement button of a vertical ScrollBar.
		 */
		protected static const THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON:String = "metalworks-desktop-vertical-scroll-bar-decrement-button";

		/**
		 * @private
		 * The theme's custom style name for the thumb of a vertical ScrollBar.
		 */
		protected static const THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_THUMB:String = "metalworks-desktop-vertical-scroll-bar-thumb";

		/**
		 * @private
		 * The theme's custom style name for the minimum track of a vertical ScrollBar.
		 */
		protected static const THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_MINIMUM_TRACK:String = "metalworks-desktop-vertical-scroll-bar-minimum-track";

		/**
		 * @private
		 * The theme's custom style name for the maximum track of a vertical ScrollBar.
		 */
		protected static const THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_MAXIMUM_TRACK:String = "metalworks-desktop-vertical-scroll-bar-maximum-track";

		/**
		 * @private
		 * The theme's custom style name for the thumb of a horizontal SimpleScrollBar.
		 */
		protected static const THEME_STYLE_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB:String = "metalworks-desktop-horizontal-simple-scroll-bar-thumb";

		/**
		 * @private
		 * The theme's custom style name for the thumb of a vertical SimpleScrollBar.
		 */
		protected static const THEME_STYLE_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB:String = "metalworks-desktop-vertical-simple-scroll-bar-thumb";

		/**
		 * @private
		 * The theme's custom style name for the minimum track of a horizontal slider.
		 */
		protected static const THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK:String = "metalworks-desktop-horizontal-slider-minimum-track";

		/**
		 * @private
		 * The theme's custom style name for the maximum track of a horizontal slider.
		 */
		protected static const THEME_STYLE_NAME_HORIZONTAL_SLIDER_MAXIMUM_TRACK:String = "metalworks-desktop-horizontal-slider-maximum-track";

		/**
		 * @private
		 * The theme's custom style name for the minimum track of a vertical slider.
		 */
		protected static const THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK:String = "metalworks-desktop-vertical-slider-minimum-track";

		/**
		 * @private
		 * The theme's custom style name for the maximum track of a vertical slider.
		 */
		protected static const THEME_STYLE_NAME_VERTICAL_SLIDER_MAXIMUM_TRACK:String = "metalworks-desktop-vertical-slider-maximum-track";

		/**
		 * @private
		 */
		protected static const THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_THUMB:String = "metalworks-desktop-pop-up-volume-slider-thumb";

		/**
		 * @private
		 */
		protected static const THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MINIMUM_TRACK:String = "metalworks-desktop-pop-up-volume-slider-minimum-track";

		/**
		 * @private
		 */
		protected static const THEME_STYLE_NAME_DATE_TIME_SPINNER_LIST_ITEM_RENDERER:String = "metalworks-desktop-date-time-spinner-list-item-renderer";

		/**
		 * The default global text renderer factory for this theme creates a
		 * TextBlockTextRenderer.
		 */
		protected static function textRendererFactory():TextBlockTextRenderer
		{
			return new TextBlockTextRenderer();
		}

		/**
		 * The default global text editor factory for this theme creates a
		 * TextBlockTextEditor.
		 */
		protected static function textEditorFactory():TextBlockTextEditor
		{
			return new TextBlockTextEditor();
		}

		/**
		 * This theme's scroll bar type is ScrollBar.
		 */
		protected static function scrollBarFactory():ScrollBar
		{
			return new ScrollBar();
		}

		protected static function popUpOverlayFactory():DisplayObject
		{
			var quad:Quad = new Quad(100, 100, MODAL_OVERLAY_COLOR);
			quad.alpha = MODAL_OVERLAY_ALPHA;
			return quad;
		}

		protected static function pickerListButtonFactory():ToggleButton
		{
			return new ToggleButton();
		}

		/**
		 * Constructor.
		 */
		public function BaseMetalWorksDesktopTheme()
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

		/**
		 * The size, in pixels, of the focus indicator skin's padding.
		 */
		protected var focusPaddingSize:int;

		protected var calloutArrowOverlapGap:int;
		protected var calloutBackgroundMinSize:int;
		protected var progressBarFillMinSize:int;
		protected var scrollBarGutterSize:int;
		protected var popUpSize:int;
		protected var popUpVolumeSliderPaddingSize:int;

		/**
		 * The font styles for standard-sized, light text.
		 */
		protected var lightFontStyles:TextFormat;

		/**
		 * The font styles for standard-sized, dark text.
		 */
		protected var darkFontStyles:TextFormat;

		/**
		 * The font styles for standard-sized, selected text.
		 */
		protected var selectedFontStyles:TextFormat;

		/**
		 * The font styles for standard-sized, light, disabled text.
		 */
		protected var lightDisabledFontStyles:TextFormat;

		/**
		 * The font styles for light UI text.
		 */
		protected var lightUIFontStyles:TextFormat;

		/**
		 * The font styles for dark UI text.
		 */
		protected var darkUIFontStyles:TextFormat;

		/**
		 * The font styles for selected UI text.
		 */
		protected var selectedUIFontStyles:TextFormat;

		/**
		 * The font styles for light disabled UI text.
		 */
		protected var lightDisabledUIFontStyles:TextFormat;

		/**
		 * The font styles for light, centered UI text.
		 */
		protected var lightCenteredUIFontStyles:TextFormat;

		/**
		 * The font styles for light, centered, disabled UI text.
		 */
		protected var lightCenteredDisabledUIFontStyles:TextFormat;

		/**
		 * The font styles for small, light text.
		 */
		protected var smallLightFontStyles:TextFormat;

		/**
		 * The font styles for small, light, disabled text.
		 */
		protected var smallLightDisabledFontStyles:TextFormat;

		/**
		 * The font styles for large, light text.
		 */
		protected var largeLightFontStyles:TextFormat;

		/**
		 * The font styles for large, dark text.
		 */
		protected var largeDarkFontStyles:TextFormat;

		/**
		 * The font styles for large, light, disabled text.
		 */
		protected var largeLightDisabledFontStyles:TextFormat;

		/**
		 * The font styles for dark, disabled UI text.
		 */
		protected var darkDisabledUIFontStyles:TextFormat;

		/**
		 * ScrollText uses TextField instead of FTE, so it has a separate TextFormat.
		 */
		protected var lightScrollTextFontStyles:TextFormat;

		/**
		 * ScrollText uses TextField instead of FTE, so it has a separate disabled TextFormat.
		 */
		protected var lightDisabledScrollTextFontStyles:TextFormat;

		/**
		 * The texture atlas that contains skins for this theme. This base class
		 * does not initialize this member variable. Subclasses are expected to
		 * load the assets somehow and set the <code>atlas</code> member
		 * variable before calling <code>initialize()</code>.
		 */
		protected var atlas:TextureAtlas;

		protected var focusIndicatorSkinTexture:Texture;
		protected var headerBackgroundSkinTexture:Texture;
		protected var headerPopupBackgroundSkinTexture:Texture;
		protected var backgroundSkinTexture:Texture;
		protected var backgroundDisabledSkinTexture:Texture;
		protected var backgroundFocusedSkinTexture:Texture;
		protected var backgroundDangerSkinTexture:Texture;
		protected var listBackgroundSkinTexture:Texture;
		protected var buttonUpSkinTexture:Texture;
		protected var buttonDownSkinTexture:Texture;
		protected var buttonDisabledSkinTexture:Texture;
		protected var toggleButtonSelectedUpSkinTexture:Texture;
		protected var toggleButtonSelectedDisabledSkinTexture:Texture;
		protected var buttonQuietHoverSkinTexture:Texture;
		protected var buttonCallToActionUpSkinTexture:Texture;
		protected var buttonCallToActionDownSkinTexture:Texture;
		protected var buttonDangerUpSkinTexture:Texture;
		protected var buttonDangerDownSkinTexture:Texture;
		protected var buttonBackUpSkinTexture:Texture;
		protected var buttonBackDownSkinTexture:Texture;
		protected var buttonBackDisabledSkinTexture:Texture;
		protected var buttonForwardUpSkinTexture:Texture;
		protected var buttonForwardDownSkinTexture:Texture;
		protected var buttonForwardDisabledSkinTexture:Texture;
		protected var pickerListButtonIconTexture:Texture;
		protected var pickerListButtonIconSelectedTexture:Texture;
		protected var pickerListButtonIconDisabledTexture:Texture;
		protected var tabUpSkinTexture:Texture;
		protected var tabDownSkinTexture:Texture;
		protected var tabDisabledSkinTexture:Texture;
		protected var tabSelectedSkinTexture:Texture;
		protected var tabSelectedDisabledSkinTexture:Texture;
		protected var radioUpIconTexture:Texture;
		protected var radioDownIconTexture:Texture;
		protected var radioDisabledIconTexture:Texture;
		protected var radioSelectedUpIconTexture:Texture;
		protected var radioSelectedDownIconTexture:Texture;
		protected var radioSelectedDisabledIconTexture:Texture;
		protected var checkUpIconTexture:Texture;
		protected var checkDownIconTexture:Texture;
		protected var checkDisabledIconTexture:Texture;
		protected var checkSelectedUpIconTexture:Texture;
		protected var checkSelectedDownIconTexture:Texture;
		protected var checkSelectedDisabledIconTexture:Texture;
		protected var pageIndicatorNormalSkinTexture:Texture;
		protected var pageIndicatorSelectedSkinTexture:Texture;
		protected var itemRendererUpSkinTexture:Texture;
		protected var itemRendererHoverSkinTexture:Texture;
		protected var itemRendererSelectedUpSkinTexture:Texture;
		protected var backgroundPopUpSkinTexture:Texture;
		protected var backgroundDangerPopUpSkinTexture:Texture;
		protected var calloutTopArrowSkinTexture:Texture;
		protected var calloutRightArrowSkinTexture:Texture;
		protected var calloutBottomArrowSkinTexture:Texture;
		protected var calloutLeftArrowSkinTexture:Texture;
		protected var dangerCalloutTopArrowSkinTexture:Texture;
		protected var dangerCalloutRightArrowSkinTexture:Texture;
		protected var dangerCalloutBottomArrowSkinTexture:Texture;
		protected var dangerCalloutLeftArrowSkinTexture:Texture;
		protected var horizontalSimpleScrollBarThumbSkinTexture:Texture;
		protected var horizontalScrollBarDecrementButtonIconTexture:Texture;
		protected var horizontalScrollBarDecrementButtonDisabledIconTexture:Texture;
		protected var horizontalScrollBarDecrementButtonUpSkinTexture:Texture;
		protected var horizontalScrollBarDecrementButtonDownSkinTexture:Texture;
		protected var horizontalScrollBarDecrementButtonDisabledSkinTexture:Texture;
		protected var horizontalScrollBarIncrementButtonIconTexture:Texture;
		protected var horizontalScrollBarIncrementButtonDisabledIconTexture:Texture;
		protected var horizontalScrollBarIncrementButtonUpSkinTexture:Texture;
		protected var horizontalScrollBarIncrementButtonDownSkinTexture:Texture;
		protected var horizontalScrollBarIncrementButtonDisabledSkinTexture:Texture;
		protected var verticalSimpleScrollBarThumbSkinTexture:Texture;
		protected var verticalScrollBarDecrementButtonIconTexture:Texture;
		protected var verticalScrollBarDecrementButtonDisabledIconTexture:Texture;
		protected var verticalScrollBarDecrementButtonUpSkinTexture:Texture;
		protected var verticalScrollBarDecrementButtonDownSkinTexture:Texture;
		protected var verticalScrollBarDecrementButtonDisabledSkinTexture:Texture;
		protected var verticalScrollBarIncrementButtonIconTexture:Texture;
		protected var verticalScrollBarIncrementButtonDisabledIconTexture:Texture;
		protected var verticalScrollBarIncrementButtonUpSkinTexture:Texture;
		protected var verticalScrollBarIncrementButtonDownSkinTexture:Texture;
		protected var verticalScrollBarIncrementButtonDisabledSkinTexture:Texture;
		protected var searchIconTexture:Texture;
		protected var searchIconDisabledTexture:Texture;
		protected var listDrillDownAccessoryTexture:Texture;
		protected var listDrillDownAccessorySelectedTexture:Texture;

		//media textures
		protected var playPauseButtonPlayUpIconTexture:Texture;
		protected var playPauseButtonPlayDownIconTexture:Texture;
		protected var playPauseButtonPauseUpIconTexture:Texture;
		protected var playPauseButtonPauseDownIconTexture:Texture;
		protected var overlayPlayPauseButtonPlayUpIconTexture:Texture;
		protected var overlayPlayPauseButtonPlayDownIconTexture:Texture;
		protected var fullScreenToggleButtonEnterUpIconTexture:Texture;
		protected var fullScreenToggleButtonEnterDownIconTexture:Texture;
		protected var fullScreenToggleButtonExitUpIconTexture:Texture;
		protected var fullScreenToggleButtonExitDownIconTexture:Texture;
		protected var muteToggleButtonLoudUpIconTexture:Texture;
		protected var muteToggleButtonLoudDownIconTexture:Texture;
		protected var muteToggleButtonMutedUpIconTexture:Texture;
		protected var muteToggleButtonMutedDownIconTexture:Texture;
		protected var volumeSliderMinimumTrackSkinTexture:Texture;
		protected var volumeSliderMaximumTrackSkinTexture:Texture;
		protected var popUpVolumeSliderTrackSkinTexture:Texture;
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
		 * Sets the stage background color.
		 */
		protected function initializeStage():void
		{
			this.starling.stage.color = PRIMARY_BACKGROUND_COLOR;
			this.starling.nativeStage.color = PRIMARY_BACKGROUND_COLOR;
		}

		/**
		 * Initializes global variables (not including global style providers).
		 */
		protected function initializeGlobals():void
		{
			FeathersControl.defaultTextRendererFactory = textRendererFactory;
			FeathersControl.defaultTextEditorFactory = textEditorFactory;

			PopUpManager.overlayFactory = popUpOverlayFactory;
			Callout.stagePadding = this.smallGutterSize;

			var stage:Stage = this.starling.stage;
			FocusManager.setEnabledForStage(stage, true);
			ToolTipManager.setEnabledForStage(stage, true);
		}

		/**
		 * Initializes common values used for setting the dimensions of components.
		 */
		protected function initializeDimensions():void
		{
			this.gridSize = 30;
			this.extraSmallGutterSize = 2;
			this.smallGutterSize = 4;
			this.gutterSize = 8;
			this.borderSize = 1;
			this.controlSize = 22;
			this.smallControlSize = 12;
			this.calloutBackgroundMinSize = 5;
			this.progressBarFillMinSize = 7;
			this.scrollBarGutterSize = 4;
			this.calloutArrowOverlapGap = -2;
			this.focusPaddingSize = -2;
			this.buttonMinWidth = this.gridSize * 2 + this.gutterSize;
			this.wideControlSize = this.gridSize * 4 + this.gutterSize * 3;
			this.popUpSize = this.gridSize * 10 + this.smallGutterSize * 9;
			this.popUpVolumeSliderPaddingSize = 10;
		}

		/**
		 * Initializes font sizes and formats.
		 */
		protected function initializeFonts():void
		{
			this.smallFontSize = 11;
			this.regularFontSize = 14;
			this.largeFontSize = 18;

			this.lightFontStyles = new TextFormat(FONT_NAME, this.regularFontSize, LIGHT_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.darkFontStyles = new TextFormat(FONT_NAME, this.regularFontSize, DARK_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.selectedFontStyles = new TextFormat(FONT_NAME, this.regularFontSize, SELECTED_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.lightDisabledFontStyles = new TextFormat(FONT_NAME, this.regularFontSize, LIGHT_DISABLED_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);

			this.smallLightFontStyles = new TextFormat(FONT_NAME, this.smallFontSize, LIGHT_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.smallLightDisabledFontStyles = new TextFormat(FONT_NAME, this.smallFontSize, LIGHT_DISABLED_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);

			this.largeLightFontStyles = new TextFormat(FONT_NAME, this.largeFontSize, LIGHT_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.largeDarkFontStyles = new TextFormat(FONT_NAME, this.largeFontSize, DARK_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.largeLightDisabledFontStyles = new TextFormat(FONT_NAME, this.largeFontSize, LIGHT_DISABLED_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);

			this.lightUIFontStyles = new TextFormat(FONT_NAME, this.regularFontSize, LIGHT_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.lightUIFontStyles.bold = true;
			this.darkUIFontStyles = new TextFormat(FONT_NAME, this.regularFontSize, DARK_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.darkUIFontStyles.bold = true;
			this.selectedUIFontStyles = new TextFormat(FONT_NAME, this.regularFontSize, SELECTED_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.selectedUIFontStyles.bold = true;
			this.lightDisabledUIFontStyles = new TextFormat(FONT_NAME, this.regularFontSize, LIGHT_DISABLED_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.lightDisabledUIFontStyles.bold = true;
			this.darkDisabledUIFontStyles = new TextFormat(FONT_NAME, this.regularFontSize, DARK_DISABLED_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.darkDisabledUIFontStyles.bold = true;
			this.lightCenteredUIFontStyles = new TextFormat(FONT_NAME, this.regularFontSize, LIGHT_TEXT_COLOR, HorizontalAlign.CENTER, VerticalAlign.TOP);
			this.lightCenteredUIFontStyles.bold = true;
			this.lightCenteredDisabledUIFontStyles = new TextFormat(FONT_NAME, this.regularFontSize, LIGHT_DISABLED_TEXT_COLOR, HorizontalAlign.CENTER, VerticalAlign.TOP);
			this.lightCenteredDisabledUIFontStyles.bold = true;

			this.lightScrollTextFontStyles = new TextFormat(FONT_NAME_STACK, this.regularFontSize, LIGHT_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.lightDisabledScrollTextFontStyles = new TextFormat(FONT_NAME_STACK, this.regularFontSize, LIGHT_DISABLED_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
		}

		/**
		 * Initializes the textures by extracting them from the atlas and
		 * setting up any scaling grids that are needed.
		 */
		protected function initializeTextures():void
		{
			var checkUpIconTexture:Texture = this.atlas.getTexture("check-up-icon0000");
			var checkDownIconTexture:Texture = this.atlas.getTexture("check-down-icon0000");
			var checkDisabledIconTexture:Texture = this.atlas.getTexture("check-disabled-icon0000");

			this.focusIndicatorSkinTexture = this.atlas.getTexture("focus-indicator-skin0000");

			this.backgroundSkinTexture = this.atlas.getTexture("background-skin0000");
			this.backgroundDisabledSkinTexture = this.atlas.getTexture("background-disabled-skin0000");
			this.backgroundFocusedSkinTexture = this.atlas.getTexture("background-focused-skin0000");
			this.backgroundDangerSkinTexture = this.atlas.getTexture("background-danger-skin0000");
			this.backgroundPopUpSkinTexture = this.atlas.getTexture("background-popup-skin0000");
			this.backgroundDangerPopUpSkinTexture = this.atlas.getTexture("background-danger-popup-skin0000");
			this.listBackgroundSkinTexture = this.atlas.getTexture("list-background-skin0000");

			this.buttonUpSkinTexture = this.atlas.getTexture("button-up-skin0000");
			this.buttonDownSkinTexture = this.atlas.getTexture("button-down-skin0000");
			this.buttonDisabledSkinTexture = this.atlas.getTexture("button-disabled-skin0000");
			this.toggleButtonSelectedUpSkinTexture = this.atlas.getTexture("toggle-button-selected-up-skin0000");
			this.toggleButtonSelectedDisabledSkinTexture = this.atlas.getTexture("toggle-button-selected-disabled-skin0000");
			this.buttonQuietHoverSkinTexture = this.atlas.getTexture("quiet-button-hover-skin0000");
			this.buttonCallToActionUpSkinTexture = this.atlas.getTexture("call-to-action-button-up-skin0000");
			this.buttonCallToActionDownSkinTexture = this.atlas.getTexture("call-to-action-button-down-skin0000");
			this.buttonDangerUpSkinTexture = this.atlas.getTexture("danger-button-up-skin0000");
			this.buttonDangerDownSkinTexture = this.atlas.getTexture("danger-button-down-skin0000");
			this.buttonBackUpSkinTexture = this.atlas.getTexture("back-button-up-skin0000");
			this.buttonBackDownSkinTexture = this.atlas.getTexture("back-button-down-skin0000");
			this.buttonBackDisabledSkinTexture = this.atlas.getTexture("back-button-disabled-skin0000");
			this.buttonForwardUpSkinTexture = this.atlas.getTexture("forward-button-up-skin0000");
			this.buttonForwardDownSkinTexture = this.atlas.getTexture("forward-button-down-skin0000");
			this.buttonForwardDisabledSkinTexture = this.atlas.getTexture("forward-button-disabled-skin0000");

			this.tabUpSkinTexture = this.atlas.getTexture("tab-up-skin0000");
			this.tabDownSkinTexture = this.atlas.getTexture("tab-down-skin0000");
			this.tabDisabledSkinTexture = this.atlas.getTexture("tab-disabled-skin0000");
			this.tabSelectedSkinTexture = this.atlas.getTexture("tab-selected-up-skin0000");
			this.tabSelectedDisabledSkinTexture = this.atlas.getTexture("tab-selected-disabled-skin0000");

			this.pickerListButtonIconTexture = this.atlas.getTexture("picker-list-icon0000");
			this.pickerListButtonIconSelectedTexture = this.atlas.getTexture("picker-list-selected-icon0000");
			this.pickerListButtonIconDisabledTexture = this.atlas.getTexture("picker-list-disabled-icon0000");

			this.radioUpIconTexture = checkUpIconTexture;
			this.radioDownIconTexture = checkDownIconTexture;
			this.radioDisabledIconTexture = checkDisabledIconTexture;
			this.radioSelectedUpIconTexture = this.atlas.getTexture("radio-selected-up-icon0000");
			this.radioSelectedDownIconTexture = this.atlas.getTexture("radio-selected-down-icon0000");
			this.radioSelectedDisabledIconTexture = this.atlas.getTexture("radio-selected-disabled-icon0000");

			this.checkUpIconTexture = checkUpIconTexture;
			this.checkDownIconTexture = checkDownIconTexture;
			this.checkDisabledIconTexture = checkDisabledIconTexture;
			this.checkSelectedUpIconTexture = this.atlas.getTexture("check-selected-up-icon0000");
			this.checkSelectedDownIconTexture = this.atlas.getTexture("check-selected-down-icon0000");
			this.checkSelectedDisabledIconTexture = this.atlas.getTexture("check-selected-disabled-icon0000");

			this.pageIndicatorSelectedSkinTexture = this.atlas.getTexture("page-indicator-selected-symbol0000");
			this.pageIndicatorNormalSkinTexture = this.atlas.getTexture("page-indicator-symbol0000");

			this.searchIconTexture = this.atlas.getTexture("search-icon0000");
			this.searchIconDisabledTexture = this.atlas.getTexture("search-disabled-icon0000");

			this.itemRendererUpSkinTexture = Texture.fromTexture(this.atlas.getTexture("item-renderer-up-skin0000"), ITEM_RENDERER_SKIN_TEXTURE_REGION);
			this.itemRendererHoverSkinTexture = Texture.fromTexture(this.atlas.getTexture("item-renderer-hover-skin0000"), ITEM_RENDERER_SKIN_TEXTURE_REGION);
			this.itemRendererSelectedUpSkinTexture = Texture.fromTexture(this.atlas.getTexture("item-renderer-selected-up-skin0000"), ITEM_RENDERER_SELECTED_SKIN_TEXTURE_REGION);

			this.headerBackgroundSkinTexture = this.atlas.getTexture("header-background-skin0000");
			this.headerPopupBackgroundSkinTexture = this.atlas.getTexture("header-popup-background-skin0000");

			this.calloutTopArrowSkinTexture = this.atlas.getTexture("callout-arrow-top-skin0000");
			this.calloutRightArrowSkinTexture = this.atlas.getTexture("callout-arrow-right-skin0000");
			this.calloutBottomArrowSkinTexture = this.atlas.getTexture("callout-arrow-bottom-skin0000");
			this.calloutLeftArrowSkinTexture = this.atlas.getTexture("callout-arrow-left-skin0000");
			this.dangerCalloutTopArrowSkinTexture = this.atlas.getTexture("danger-callout-arrow-top-skin0000");
			this.dangerCalloutRightArrowSkinTexture = this.atlas.getTexture("danger-callout-arrow-right-skin0000");
			this.dangerCalloutBottomArrowSkinTexture = this.atlas.getTexture("danger-callout-arrow-bottom-skin0000");
			this.dangerCalloutLeftArrowSkinTexture = this.atlas.getTexture("danger-callout-arrow-left-skin0000");

			this.horizontalSimpleScrollBarThumbSkinTexture = this.atlas.getTexture("horizontal-simple-scroll-bar-thumb-skin0000");
			this.horizontalScrollBarDecrementButtonIconTexture = this.atlas.getTexture("horizontal-scroll-bar-decrement-button-icon0000");
			this.horizontalScrollBarDecrementButtonDisabledIconTexture = this.atlas.getTexture("horizontal-scroll-bar-decrement-button-disabled-icon0000");
			this.horizontalScrollBarDecrementButtonUpSkinTexture = this.atlas.getTexture("horizontal-scroll-bar-decrement-button-up-skin0000");
			this.horizontalScrollBarDecrementButtonDownSkinTexture = this.atlas.getTexture("horizontal-scroll-bar-decrement-button-down-skin0000");
			this.horizontalScrollBarDecrementButtonDisabledSkinTexture = this.atlas.getTexture("horizontal-scroll-bar-decrement-button-disabled-skin0000");
			this.horizontalScrollBarIncrementButtonIconTexture = this.atlas.getTexture("horizontal-scroll-bar-increment-button-icon0000");
			this.horizontalScrollBarIncrementButtonDisabledIconTexture = this.atlas.getTexture("horizontal-scroll-bar-increment-button-disabled-icon0000");
			this.horizontalScrollBarIncrementButtonUpSkinTexture = this.atlas.getTexture("horizontal-scroll-bar-increment-button-up-skin0000");
			this.horizontalScrollBarIncrementButtonDownSkinTexture = this.atlas.getTexture("horizontal-scroll-bar-increment-button-down-skin0000");
			this.horizontalScrollBarIncrementButtonDisabledSkinTexture = this.atlas.getTexture("horizontal-scroll-bar-increment-button-disabled-skin0000");

			this.verticalSimpleScrollBarThumbSkinTexture = this.atlas.getTexture("vertical-simple-scroll-bar-thumb-skin0000");
			this.verticalScrollBarDecrementButtonIconTexture = this.atlas.getTexture("vertical-scroll-bar-decrement-button-icon0000");
			this.verticalScrollBarDecrementButtonDisabledIconTexture = this.atlas.getTexture("vertical-scroll-bar-decrement-button-disabled-icon0000");
			this.verticalScrollBarDecrementButtonUpSkinTexture = this.atlas.getTexture("vertical-scroll-bar-decrement-button-up-skin0000");
			this.verticalScrollBarDecrementButtonDownSkinTexture = this.atlas.getTexture("vertical-scroll-bar-decrement-button-down-skin0000");
			this.verticalScrollBarDecrementButtonDisabledSkinTexture = this.atlas.getTexture("vertical-scroll-bar-decrement-button-disabled-skin0000");
			this.verticalScrollBarIncrementButtonIconTexture = this.atlas.getTexture("vertical-scroll-bar-increment-button-icon0000");
			this.verticalScrollBarIncrementButtonDisabledIconTexture = this.atlas.getTexture("vertical-scroll-bar-increment-button-disabled-icon0000");
			this.verticalScrollBarIncrementButtonUpSkinTexture = this.atlas.getTexture("vertical-scroll-bar-increment-button-up-skin0000");
			this.verticalScrollBarIncrementButtonDownSkinTexture = this.atlas.getTexture("vertical-scroll-bar-increment-button-down-skin0000");
			this.verticalScrollBarIncrementButtonDisabledSkinTexture = this.atlas.getTexture("vertical-scroll-bar-increment-button-disabled-skin0000");

			this.listDrillDownAccessoryTexture = this.atlas.getTexture("item-renderer-drill-down-accessory-icon0000");
			this.listDrillDownAccessorySelectedTexture = this.atlas.getTexture("item-renderer-drill-down-accessory-selected-icon0000");

			this.playPauseButtonPlayUpIconTexture = this.atlas.getTexture("play-pause-toggle-button-play-up-icon0000");
			this.playPauseButtonPlayDownIconTexture = this.atlas.getTexture("play-pause-toggle-button-play-down-icon0000");
			this.playPauseButtonPauseUpIconTexture = this.atlas.getTexture("play-pause-toggle-button-pause-up-icon0000");
			this.playPauseButtonPauseDownIconTexture = this.atlas.getTexture("play-pause-toggle-button-pause-down-icon0000");
			this.overlayPlayPauseButtonPlayUpIconTexture = this.atlas.getTexture("overlay-play-pause-toggle-button-play-up-icon0000");
			this.overlayPlayPauseButtonPlayDownIconTexture = this.atlas.getTexture("overlay-play-pause-toggle-button-play-down-icon0000");
			this.fullScreenToggleButtonEnterUpIconTexture = this.atlas.getTexture("full-screen-toggle-button-enter-up-icon0000");
			this.fullScreenToggleButtonEnterDownIconTexture = this.atlas.getTexture("full-screen-toggle-button-enter-down-icon0000");
			this.fullScreenToggleButtonExitUpIconTexture = this.atlas.getTexture("full-screen-toggle-button-exit-up-icon0000");
			this.fullScreenToggleButtonExitDownIconTexture = this.atlas.getTexture("full-screen-toggle-button-exit-down-icon0000");
			this.muteToggleButtonMutedUpIconTexture = this.atlas.getTexture("mute-toggle-button-muted-up-icon0000");
			this.muteToggleButtonMutedDownIconTexture = this.atlas.getTexture("mute-toggle-button-muted-down-icon0000");
			this.muteToggleButtonLoudUpIconTexture = this.atlas.getTexture("mute-toggle-button-loud-up-icon0000");
			this.muteToggleButtonLoudDownIconTexture = this.atlas.getTexture("mute-toggle-button-loud-down-icon0000");
			this.popUpVolumeSliderTrackSkinTexture = this.atlas.getTexture("pop-up-volume-slider-track-skin0000");
			this.volumeSliderMinimumTrackSkinTexture = this.atlas.getTexture("volume-slider-minimum-track-skin0000");
			this.volumeSliderMaximumTrackSkinTexture = this.atlas.getTexture("volume-slider-maximum-track-skin0000");
			this.seekSliderProgressSkinTexture = this.atlas.getTexture("seek-slider-progress-skin0000");
		}

		/**
		 * Sets global style providers for all components.
		 */
		protected function initializeStyleProviders():void
		{
			//alert
			this.getStyleProviderForClass(Alert).defaultStyleFunction = this.setAlertStyles;
			this.getStyleProviderForClass(Header).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setPopupHeaderStyles);
			this.getStyleProviderForClass(ButtonGroup).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_BUTTON_GROUP, this.setAlertButtonGroupStyles);

			//autocomplete
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

			//callout
			this.getStyleProviderForClass(Callout).defaultStyleFunction = this.setCalloutStyles;

			//check
			this.getStyleProviderForClass(Check).defaultStyleFunction = this.setCheckStyles;

			//date time spinner
			this.getStyleProviderForClass(SpinnerList).setFunctionForStyleName(DateTimeSpinner.DEFAULT_CHILD_STYLE_NAME_LIST, this.setDateTimeSpinnerListStyles);
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_DATE_TIME_SPINNER_LIST_ITEM_RENDERER, this.setDateTimeSpinnerListItemRendererStyles);

			//drawers
			this.getStyleProviderForClass(Drawers).defaultStyleFunction = this.setDrawersStyles;

			//grouped list (see also: item renderers)
			this.getStyleProviderForClass(GroupedList).defaultStyleFunction = this.setGroupedListStyles;

			//header
			this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;

			//header and footer renderers for grouped list
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).defaultStyleFunction = this.setGroupedListHeaderRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.DEFAULT_CHILD_STYLE_NAME_FOOTER_RENDERER, this.setGroupedListFooterRendererStyles);

			//item renderers for lists
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(DefaultGroupedListItemRenderer.ALTERNATE_STYLE_NAME_DRILL_DOWN, this.setDrillDownItemRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(DefaultGroupedListItemRenderer.ALTERNATE_STYLE_NAME_CHECK, this.setCheckItemRendererStyles);
			this.getStyleProviderForClass(DefaultListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(DefaultListItemRenderer.ALTERNATE_STYLE_NAME_DRILL_DOWN, this.setDrillDownItemRendererStyles);
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(DefaultListItemRenderer.ALTERNATE_STYLE_NAME_CHECK, this.setCheckItemRendererStyles);

			//labels
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
			this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON, this.setNumericStepperDecrementButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON, this.setNumericStepperIncrementButtonStyles);

			//page indicator
			this.getStyleProviderForClass(PageIndicator).defaultStyleFunction = this.setPageIndicatorStyles;

			//panel
			this.getStyleProviderForClass(Panel).defaultStyleFunction = this.setPanelStyles;
			this.getStyleProviderForClass(Header).setFunctionForStyleName(Panel.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setPopupHeaderStyles);

			//panel screen
			this.getStyleProviderForClass(PanelScreen).defaultStyleFunction = this.setPanelScreenStyles;
			this.getStyleProviderForClass(Header).setFunctionForStyleName(PanelScreen.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setPanelScreenHeaderStyles);

			//picker list (see also: list and item renderers)
			this.getStyleProviderForClass(PickerList).defaultStyleFunction = this.setPickerListStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setPickerListButtonStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setPickerListButtonStyles);
			this.getStyleProviderForClass(List).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_LIST, this.setDropDownListStyles);

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
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_MAXIMUM_TRACK, this.setHorizontalScrollBarMaximumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON, this.setVerticalScrollBarIncrementButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON, this.setVerticalScrollBarDecrementButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_THUMB, this.setVerticalScrollBarThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_MINIMUM_TRACK, this.setVerticalScrollBarMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_MAXIMUM_TRACK, this.setVerticalScrollBarMaximumTrackStyles);

			//scroll container
			this.getStyleProviderForClass(ScrollContainer).defaultStyleFunction = this.setScrollContainerStyles;
			this.getStyleProviderForClass(ScrollContainer).setFunctionForStyleName(ScrollContainer.ALTERNATE_STYLE_NAME_TOOLBAR, this.setToolbarScrollContainerStyles);

			//scroll screen
			this.getStyleProviderForClass(ScrollScreen).defaultStyleFunction = this.setScrollScreenStyles;

			//scroll text
			this.getStyleProviderForClass(ScrollText).defaultStyleFunction = this.setScrollTextStyles;

			//simple scroll bar
			this.getStyleProviderForClass(SimpleScrollBar).defaultStyleFunction = this.setSimpleScrollBarStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB, this.setHorizontalSimpleScrollBarThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB, this.setVerticalSimpleScrollBarThumbStyles);

			//slider
			this.getStyleProviderForClass(Slider).defaultStyleFunction = this.setSliderStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Slider.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setSliderThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK, this.setHorizontalSliderMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SLIDER_MAXIMUM_TRACK, this.setHorizontalSliderMaximumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK, this.setVerticalSliderMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SLIDER_MAXIMUM_TRACK, this.setVerticalSliderMaximumTrackStyles);
			
			//spinner list
			this.getStyleProviderForClass(SpinnerList).defaultStyleFunction = this.setSpinnerListStyles;

			//tab bar
			this.getStyleProviderForClass(TabBar).defaultStyleFunction = this.setTabBarStyles;
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(TabBar.DEFAULT_CHILD_STYLE_NAME_TAB, this.setTabStyles);

			//text input
			this.getStyleProviderForClass(TextInput).defaultStyleFunction = this.setTextInputStyles;
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName(TextInput.ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT, this.setSearchTextInputStyles);
			this.getStyleProviderForClass(TextBlockTextEditor).setFunctionForStyleName(TextInput.DEFAULT_CHILD_STYLE_NAME_TEXT_EDITOR, this.setTextInputTextEditorStyles);
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
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_ON_TRACK, this.setToggleSwitchTrackStyles);
			//we don't need a style function for the off track in this theme
			//the toggle switch layout uses a single track

			//media controls
			this.getStyleProviderForClass(VideoPlayer).defaultStyleFunction = this.setVideoPlayerStyles;

			//play/pause toggle button
			this.getStyleProviderForClass(PlayPauseToggleButton).defaultStyleFunction = this.setPlayPauseToggleButtonStyles;
			this.getStyleProviderForClass(PlayPauseToggleButton).setFunctionForStyleName(PlayPauseToggleButton.ALTERNATE_STYLE_NAME_OVERLAY_PLAY_PAUSE_TOGGLE_BUTTON, this.setOverlayPlayPauseToggleButtonStyles);

			//full screen toggle button
			this.getStyleProviderForClass(FullScreenToggleButton).defaultStyleFunction = this.setFullScreenToggleButtonStyles;

			//mute toggle button
			this.getStyleProviderForClass(MuteToggleButton).defaultStyleFunction = this.setMuteToggleButtonStyles;
			this.getStyleProviderForClass(VolumeSlider).setFunctionForStyleName(MuteToggleButton.DEFAULT_CHILD_STYLE_NAME_VOLUME_SLIDER, this.setPopUpVolumeSliderStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_THUMB, this.setSliderThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MINIMUM_TRACK, this.setPopUpVolumeSliderTrackStyles);

			//seek slider
			this.getStyleProviderForClass(SeekSlider).defaultStyleFunction = this.setSeekSliderStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(SeekSlider.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setSeekSliderThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(SeekSlider.DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK, this.setSeekSliderMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(SeekSlider.DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK, this.setSeekSliderMaximumTrackStyles);

			//volume slider
			this.getStyleProviderForClass(VolumeSlider).defaultStyleFunction = this.setVolumeSliderStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(VolumeSlider.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setVolumeSliderThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(VolumeSlider.DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK, this.setVolumeSliderMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(VolumeSlider.DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK, this.setVolumeSliderMaximumTrackStyles);
		}

		protected function pageIndicatorNormalSymbolFactory():DisplayObject
		{
			var symbol:ImageLoader = new ImageLoader();
			symbol.source = this.pageIndicatorNormalSkinTexture;
			return symbol;
		}

		protected function pageIndicatorSelectedSymbolFactory():DisplayObject
		{
			var symbol:ImageLoader = new ImageLoader();
			symbol.source = this.pageIndicatorSelectedSkinTexture;
			return symbol;
		}

	//-------------------------
	// Shared
	//-------------------------

		protected function setScrollerStyles(scroller:Scroller):void
		{
			scroller.horizontalScrollBarFactory = scrollBarFactory;
			scroller.verticalScrollBarFactory = scrollBarFactory;
			scroller.scrollBarDisplayMode = ScrollBarDisplayMode.FIXED;
			scroller.interactionMode = ScrollInteractionMode.MOUSE;

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

			var backgroundSkin:Image = new Image(this.backgroundPopUpSkinTexture);
			backgroundSkin.scale9Grid = SIMPLE_SCALE9_GRID;
			alert.backgroundSkin = backgroundSkin;

			alert.fontStyles = this.lightFontStyles;
			alert.disabledFontStyles = this.lightDisabledFontStyles;

			alert.paddingTop = this.gutterSize;
			alert.paddingRight = this.gutterSize;
			alert.paddingBottom = this.smallGutterSize;
			alert.paddingLeft = this.gutterSize;
			alert.outerPadding = this.borderSize;
			alert.gap = this.smallGutterSize;
			alert.maxWidth = this.popUpSize;
			alert.maxHeight = this.popUpSize;
		}

		//see Panel section for Header styles

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
			button.focusPadding = this.focusPaddingSize;

			button.paddingTop = this.smallGutterSize;
			button.paddingBottom = this.smallGutterSize;
			button.paddingLeft = this.gutterSize;
			button.paddingRight = this.gutterSize;
			button.gap = this.smallGutterSize;
			button.minGap = this.smallGutterSize;
		}

		protected function setButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.buttonMinWidth;
			skin.minHeight = this.controlSize;
			button.defaultSkin = skin;
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				var selectedSkin:ImageSkin = new ImageSkin(this.toggleButtonSelectedUpSkinTexture);
				skin.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.toggleButtonSelectedDisabledSkinTexture);
				selectedSkin.scale9Grid = TOGGLE_BUTTON_SCALE9_GRID;
				selectedSkin.width = this.controlSize;
				selectedSkin.height = this.controlSize;
				ToggleButton(button).defaultSelectedSkin = selectedSkin;
			}

			button.fontStyles = this.darkUIFontStyles;
			button.disabledFontStyles = this.darkDisabledUIFontStyles;

			this.setBaseButtonStyles(button);
		}

		protected function setCallToActionButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonCallToActionUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonCallToActionDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.buttonMinWidth;
			skin.minHeight = this.controlSize;
			button.defaultSkin = skin;

			button.fontStyles = this.darkUIFontStyles;
			button.disabledFontStyles = this.darkDisabledUIFontStyles;

			this.setBaseButtonStyles(button);
		}

		protected function setQuietButtonStyles(button:Button):void
		{
			var defaultSkin:Quad = new Quad(this.controlSize, this.controlSize, 0xff00ff);
			defaultSkin.alpha = 0;
			button.defaultSkin = defaultSkin;

			var otherSkin:ImageSkin = new ImageSkin(null);
			otherSkin.setTextureForState(ButtonState.HOVER, this.buttonQuietHoverSkinTexture);
			otherSkin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			button.hoverSkin = otherSkin;
			button.downSkin = otherSkin;
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				var toggleButton:ToggleButton = ToggleButton(button);
				otherSkin.selectedTexture = this.toggleButtonSelectedUpSkinTexture;
				otherSkin.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.toggleButtonSelectedDisabledSkinTexture);
				toggleButton.defaultSelectedSkin = otherSkin;
				toggleButton.setSkinForState(ButtonState.DISABLED_AND_SELECTED, otherSkin);
			}
			otherSkin.scale9Grid = BUTTON_SCALE9_GRID;
			otherSkin.width = this.controlSize;
			otherSkin.height = this.controlSize;
			otherSkin.minWidth = this.controlSize;
			otherSkin.minHeight = this.controlSize;

			button.fontStyles = this.lightUIFontStyles;
			button.disabledFontStyles = this.lightDisabledUIFontStyles;
			button.setFontStylesForState(ButtonState.DOWN, this.darkUIFontStyles);
			button.setFontStylesForState(ButtonState.DISABLED, this.lightDisabledUIFontStyles);
			if(button is ToggleButton)
			{
				toggleButton.selectedFontStyles = this.darkUIFontStyles;
				toggleButton.setFontStylesForState(ButtonState.DISABLED_AND_SELECTED, this.darkDisabledUIFontStyles);
			}

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
		}

		protected function setDangerButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonDangerUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDangerDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.buttonMinWidth;
			skin.height = this.controlSize;
			skin.minWidth = this.buttonMinWidth;
			skin.minHeight = this.controlSize;
			button.defaultSkin = skin;

			button.fontStyles = this.darkUIFontStyles;
			button.disabledFontStyles = this.darkDisabledUIFontStyles;

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

			button.fontStyles = this.darkUIFontStyles;
			button.disabledFontStyles = this.darkDisabledUIFontStyles;

			this.setBaseButtonStyles(button);

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

			button.fontStyles = this.darkUIFontStyles;
			button.disabledFontStyles = this.darkDisabledUIFontStyles;

			this.setBaseButtonStyles(button);

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
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.wideControlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.wideControlSize;
			skin.minHeight = this.controlSize;
			button.defaultSkin = skin;
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				var selectedSkin:ImageSkin = new ImageSkin(this.toggleButtonSelectedUpSkinTexture);
				skin.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.toggleButtonSelectedDisabledSkinTexture);
				selectedSkin.scale9Grid = TOGGLE_BUTTON_SCALE9_GRID;
				selectedSkin.width = this.controlSize;
				selectedSkin.height = this.controlSize;
				ToggleButton(button).defaultSelectedSkin = selectedSkin;
			}

			button.fontStyles = this.darkUIFontStyles;
			button.disabledFontStyles = this.darkDisabledUIFontStyles;

			this.setBaseButtonStyles(button);
		}

	//-------------------------
	// Callout
	//-------------------------

		protected function setCalloutStyles(callout:Callout):void
		{
			var backgroundSkin:Image = new Image(this.backgroundPopUpSkinTexture);
			backgroundSkin.scale9Grid = SIMPLE_SCALE9_GRID;
			backgroundSkin.width = this.calloutBackgroundMinSize;
			backgroundSkin.height = this.calloutBackgroundMinSize;
			callout.backgroundSkin = backgroundSkin;

			var topArrowSkin:Image = new Image(this.calloutTopArrowSkinTexture);
			callout.topArrowSkin = topArrowSkin;
			callout.topArrowGap = this.calloutArrowOverlapGap;

			var rightArrowSkin:Image = new Image(this.calloutRightArrowSkinTexture);
			callout.rightArrowSkin = rightArrowSkin;
			callout.rightArrowGap = this.calloutArrowOverlapGap;

			var bottomArrowSkin:Image = new Image(this.calloutBottomArrowSkinTexture);
			callout.bottomArrowSkin = bottomArrowSkin;
			callout.bottomArrowGap = this.calloutArrowOverlapGap;

			var leftArrowSkin:Image = new Image(this.calloutLeftArrowSkinTexture);
			callout.leftArrowSkin = leftArrowSkin;
			callout.leftArrowGap = this.calloutArrowOverlapGap;

			callout.padding = this.gutterSize;
		}

		protected function setDangerCalloutStyles(callout:Callout):void
		{
			var backgroundSkin:Image = new Image(this.backgroundDangerPopUpSkinTexture);
			backgroundSkin.scale9Grid = SIMPLE_SCALE9_GRID;
			backgroundSkin.width = this.calloutBackgroundMinSize;
			backgroundSkin.height = this.calloutBackgroundMinSize;
			callout.backgroundSkin = backgroundSkin;

			var topArrowSkin:Image = new Image(this.dangerCalloutTopArrowSkinTexture);
			callout.topArrowSkin = topArrowSkin;
			callout.topArrowGap = this.calloutArrowOverlapGap;

			var rightArrowSkin:Image = new Image(this.dangerCalloutRightArrowSkinTexture);
			callout.rightArrowSkin = rightArrowSkin;
			callout.rightArrowGap = this.calloutArrowOverlapGap;

			var bottomArrowSkin:Image = new Image(this.dangerCalloutBottomArrowSkinTexture);
			callout.bottomArrowSkin = bottomArrowSkin;
			callout.bottomArrowGap = this.calloutArrowOverlapGap;

			var leftArrowSkin:Image = new Image(this.dangerCalloutLeftArrowSkinTexture);
			callout.leftArrowSkin = leftArrowSkin;
			callout.leftArrowGap = this.calloutArrowOverlapGap;

			callout.padding = this.gutterSize;
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
			icon.setTextureForState(ButtonState.DOWN, this.checkDownIconTexture);
			icon.setTextureForState(ButtonState.DISABLED, this.checkDisabledIconTexture);
			icon.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.checkSelectedDownIconTexture);
			icon.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.checkSelectedDisabledIconTexture);
			check.defaultIcon = icon;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			check.focusIndicatorSkin = focusIndicatorSkin;
			check.focusPaddingLeft = this.focusPaddingSize;
			check.focusPaddingRight = this.focusPaddingSize;

			check.fontStyles = this.lightUIFontStyles;
			check.disabledFontStyles = this.lightDisabledUIFontStyles;

			check.horizontalAlign = HorizontalAlign.LEFT;
			check.gap = this.smallGutterSize;
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
			this.setItemRendererStyles(itemRenderer);

			itemRenderer.accessoryPosition = RelativePosition.LEFT;
			itemRenderer.accessoryGap = this.smallGutterSize;
		}

	//-------------------------
	// Drawers
	//-------------------------

		protected function setDrawersStyles(drawers:Drawers):void
		{
			var overlaySkin:Quad = new Quad(1, 1, DRAWER_OVERLAY_COLOR);
			overlaySkin.alpha = DRAWER_OVERLAY_ALPHA;
			drawers.overlaySkin = overlaySkin;
		}

	//-------------------------
	// GroupedList
	//-------------------------

		protected function setGroupedListStyles(list:GroupedList):void
		{
			this.setScrollerStyles(list);

			list.padding = this.borderSize;

			var backgroundSkin:Image = new Image(this.listBackgroundSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE9_GRID;
			list.backgroundSkin = backgroundSkin;

			var backgroundDisabledSkin:Image = new Image(this.backgroundDisabledSkinTexture);
			backgroundDisabledSkin.scale9Grid = DEFAULT_SCALE9_GRID;
			list.backgroundDisabledSkin = backgroundDisabledSkin;

			list.verticalScrollPolicy = ScrollPolicy.AUTO;
		}

		//see List section for item renderer styles

		protected function setGroupedListHeaderRendererStyles(headerRenderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			headerRenderer.backgroundSkin = new Quad(this.controlSize, this.controlSize, GROUPED_LIST_HEADER_BACKGROUND_COLOR);

			headerRenderer.fontStyles = this.lightUIFontStyles;
			headerRenderer.disabledFontStyles = this.lightDisabledUIFontStyles;

			headerRenderer.horizontalAlign = HorizontalAlign.LEFT;

			headerRenderer.paddingTop = this.smallGutterSize;
			headerRenderer.paddingBottom = this.smallGutterSize;
			headerRenderer.paddingLeft = this.gutterSize;
			headerRenderer.paddingRight = this.gutterSize;
		}

		protected function setGroupedListFooterRendererStyles(footerRenderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			footerRenderer.backgroundSkin = new Quad(this.controlSize, this.controlSize, GROUPED_LIST_FOOTER_BACKGROUND_COLOR);

			footerRenderer.fontStyles = this.lightFontStyles;
			footerRenderer.disabledFontStyles = this.lightDisabledFontStyles;

			footerRenderer.horizontalAlign = HorizontalAlign.CENTER;

			footerRenderer.paddingTop = this.smallGutterSize;
			footerRenderer.paddingBottom = this.smallGutterSize;
			footerRenderer.paddingLeft = this.gutterSize;
			footerRenderer.paddingRight = this.gutterSize;
		}

	//-------------------------
	// Header
	//-------------------------

		protected function setHeaderStyles(header:Header):void
		{
			header.paddingTop = this.smallGutterSize;
			header.paddingBottom = this.smallGutterSize;
			header.paddingRight = this.gutterSize;
			header.paddingLeft = this.gutterSize;
			header.gap = this.smallGutterSize;
			header.titleGap = this.smallGutterSize;

			header.fontStyles = this.lightFontStyles;
			header.disabledFontStyles = this.lightDisabledFontStyles;

			var backgroundSkin:ImageSkin = new ImageSkin(this.headerBackgroundSkinTexture);
			backgroundSkin.tileGrid = new Rectangle();
			backgroundSkin.width = this.controlSize;
			backgroundSkin.height = this.controlSize;
			backgroundSkin.minWidth = this.gridSize;
			backgroundSkin.minHeight = this.gridSize;
			header.backgroundSkin = backgroundSkin;
		}

	//-------------------------
	// Label
	//-------------------------

		protected function setLabelStyles(label:Label):void
		{
			label.fontStyles = this.lightFontStyles;
			label.disabledFontStyles = this.lightDisabledFontStyles;
		}

		protected function setHeadingLabelStyles(label:Label):void
		{
			label.fontStyles = this.largeLightFontStyles;
			label.disabledFontStyles = this.largeLightDisabledFontStyles;
		}

		protected function setDetailLabelStyles(label:Label):void
		{
			label.fontStyles = this.smallLightFontStyles;
			label.disabledFontStyles = this.smallLightDisabledFontStyles;
		}

		protected function setToolTipLabelStyles(label:Label):void
		{
			var backgroundSkin:Image = new Image(this.backgroundSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE9_GRID;
			label.backgroundSkin = backgroundSkin;

			label.fontStyles = this.lightFontStyles;
			label.disabledFontStyles = this.lightDisabledFontStyles;

			label.padding = this.smallGutterSize;
		}

	//-------------------------
	// LayoutGroup
	//-------------------------

		protected function setToolbarLayoutGroupStyles(group:LayoutGroup):void
		{
			if(!group.layout)
			{
				var layout:HorizontalLayout = new HorizontalLayout();
				layout.padding = this.gutterSize;
				layout.gap = this.smallGutterSize;
				layout.verticalAlign = VerticalAlign.MIDDLE;
				group.layout = layout;
			}

			var backgroundSkin:ImageSkin = new ImageSkin(this.headerBackgroundSkinTexture);
			backgroundSkin.tileGrid = new Rectangle();
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

			list.padding = this.borderSize;

			var backgroundSkin:Image = new Image(this.listBackgroundSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE9_GRID;
			backgroundSkin.width = this.controlSize;
			backgroundSkin.height = this.controlSize;
			list.backgroundSkin = backgroundSkin;

			var backgroundDisabledSkin:Image = new Image(this.backgroundDisabledSkinTexture);
			backgroundDisabledSkin.scale9Grid = DEFAULT_SCALE9_GRID;
			backgroundDisabledSkin.width = this.controlSize;
			backgroundDisabledSkin.height = this.controlSize;
			list.backgroundDisabledSkin = backgroundDisabledSkin;

			list.verticalScrollPolicy = ScrollPolicy.AUTO;
		}

		protected function setItemRendererStyles(itemRenderer:BaseDefaultItemRenderer):void
		{
			var skin:ImageSkin = new ImageSkin(this.itemRendererUpSkinTexture);
			skin.selectedTexture = this.itemRendererSelectedUpSkinTexture;
			skin.setTextureForState(ButtonState.HOVER, this.itemRendererHoverSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.itemRendererSelectedUpSkinTexture);
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.controlSize;
			skin.minHeight = this.controlSize;
			itemRenderer.defaultSkin = skin;

			itemRenderer.fontStyles = this.lightFontStyles;
			itemRenderer.disabledFontStyles = this.lightDisabledFontStyles;
			itemRenderer.selectedFontStyles = this.darkFontStyles;
			itemRenderer.setFontStylesForState(ButtonState.DOWN, this.darkFontStyles);
			itemRenderer.setFontStylesForState(ButtonState.HOVER, this.darkFontStyles);

			itemRenderer.iconLabelFontStyles = this.lightFontStyles;
			itemRenderer.iconLabelDisabledFontStyles = this.lightDisabledFontStyles;
			itemRenderer.iconLabelSelectedFontStyles = this.darkFontStyles;
			itemRenderer.setIconLabelFontStylesForState(ButtonState.DOWN, this.darkFontStyles);
			itemRenderer.setIconLabelFontStylesForState(ButtonState.HOVER, this.darkFontStyles);

			itemRenderer.accessoryLabelFontStyles = this.lightFontStyles;
			itemRenderer.accessoryLabelDisabledFontStyles = this.lightDisabledFontStyles;
			itemRenderer.accessoryLabelSelectedFontStyles = this.darkFontStyles;
			itemRenderer.setAccessoryLabelFontStylesForState(ButtonState.DOWN, this.darkFontStyles);
			itemRenderer.setAccessoryLabelFontStylesForState(ButtonState.HOVER, this.darkFontStyles);

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

			itemRenderer.useStateDelayTimer = false;
		}

		protected function setDrillDownItemRendererStyles(itemRenderer:BaseDefaultItemRenderer):void
		{
			this.setItemRendererStyles(itemRenderer);

			itemRenderer.itemHasAccessory = false;

			var defaultAccessory:ImageSkin = new ImageSkin(this.listDrillDownAccessoryTexture);
			defaultAccessory.selectedTexture = this.listDrillDownAccessorySelectedTexture;
			defaultAccessory.setTextureForState(ButtonState.HOVER, this.listDrillDownAccessorySelectedTexture);
			defaultAccessory.setTextureForState(ButtonState.DOWN, this.listDrillDownAccessorySelectedTexture);
			itemRenderer.defaultAccessory = defaultAccessory;
		}

		protected function setCheckItemRendererStyles(itemRenderer:BaseDefaultItemRenderer):void
		{
			var skin:ImageSkin = new ImageSkin(this.itemRendererUpSkinTexture);
			skin.width = this.controlSize;
			skin.width = this.controlSize;
			skin.minWidth = this.controlSize;
			skin.minHeight = this.controlSize;
			itemRenderer.defaultSkin = skin;

			itemRenderer.itemHasIcon = false;

			var icon:ImageSkin = new ImageSkin(this.checkUpIconTexture);
			icon.selectedTexture = this.checkSelectedUpIconTexture;
			icon.setTextureForState(ButtonState.DOWN, this.checkDownIconTexture);
			icon.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.checkSelectedDownIconTexture);
			itemRenderer.defaultIcon = icon;

			itemRenderer.fontStyles = this.lightFontStyles;
			itemRenderer.disabledFontStyles = this.lightDisabledFontStyles;
			itemRenderer.iconLabelFontStyles = this.lightFontStyles;
			itemRenderer.iconLabelDisabledFontStyles = this.lightDisabledFontStyles;
			itemRenderer.accessoryLabelFontStyles = this.lightFontStyles;
			itemRenderer.accessoryLabelDisabledFontStyles = this.lightDisabledFontStyles;

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
			stepper.focusPadding = this.focusPaddingSize;
		}

		protected function setNumericStepperTextInputStyles(input:TextInput):void
		{
			var skin:ImageSkin = new ImageSkin(this.backgroundSkinTexture);
			skin.setTextureForState(TextInputState.DISABLED, this.backgroundDisabledSkinTexture);
			skin.setTextureForState(TextInputState.FOCUSED, this.backgroundFocusedSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE9_GRID;
			skin.width = this.gridSize;
			skin.height = this.controlSize;
			skin.minWidth = this.gridSize;
			skin.minHeight = this.controlSize;
			input.backgroundSkin = skin;

			input.fontStyles = this.lightCenteredUIFontStyles;
			input.disabledFontStyles = this.lightCenteredDisabledUIFontStyles;

			input.gap = this.smallGutterSize;
			input.paddingTop = this.smallGutterSize;
			input.paddingBottom = this.smallGutterSize;
			input.paddingLeft = this.gutterSize;
			input.paddingRight = this.gutterSize;
		}

		protected function setNumericStepperDecrementButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.verticalScrollBarIncrementButtonUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.verticalScrollBarIncrementButtonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.verticalScrollBarIncrementButtonDisabledSkinTexture);
			skin.scale9Grid = SCROLL_BAR_STEP_BUTTON_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.smallControlSize;
			button.defaultSkin = skin;

			button.defaultIcon = new Image(this.verticalScrollBarIncrementButtonIconTexture);
			button.disabledIcon = new Image(this.verticalScrollBarIncrementButtonDisabledIconTexture);

			var incrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
			incrementButtonDisabledIcon.alpha = 0;
			button.disabledIcon = incrementButtonDisabledIcon;

			button.keepDownStateOnRollOut = true;
			button.hasLabelTextRenderer = false;
		}

		protected function setNumericStepperIncrementButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.verticalScrollBarDecrementButtonUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.verticalScrollBarDecrementButtonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.verticalScrollBarDecrementButtonDisabledSkinTexture);
			skin.scale9Grid = SCROLL_BAR_STEP_BUTTON_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.smallControlSize;
			button.defaultSkin = skin;

			button.defaultIcon = new Image(this.verticalScrollBarDecrementButtonIconTexture);
			button.disabledIcon = new Image(this.verticalScrollBarDecrementButtonDisabledIconTexture);

			var incrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
			incrementButtonDisabledIcon.alpha = 0;
			button.disabledIcon = incrementButtonDisabledIcon;

			button.keepDownStateOnRollOut = true;
			button.hasLabelTextRenderer = false;
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

			var backgroundSkin:Image = new Image(this.backgroundPopUpSkinTexture);
			backgroundSkin.scale9Grid = SIMPLE_SCALE9_GRID;
			panel.backgroundSkin = backgroundSkin;

			panel.padding = this.gutterSize;
			panel.outerPadding = this.borderSize;
		}

		protected function setPopupHeaderStyles(header:Header):void
		{
			var backgroundSkin:ImageSkin = new ImageSkin(this.headerPopupBackgroundSkinTexture);
			backgroundSkin.tileGrid = new Rectangle();
			backgroundSkin.width = this.controlSize;
			backgroundSkin.height = this.controlSize;
			backgroundSkin.minWidth = this.gridSize;
			backgroundSkin.minHeight = this.gridSize;
			header.backgroundSkin = backgroundSkin;

			header.fontStyles = this.lightFontStyles;
			header.disabledFontStyles = this.lightDisabledFontStyles;

			header.paddingTop = this.smallGutterSize;
			header.paddingBottom = this.smallGutterSize;
			header.paddingRight = this.gutterSize;
			header.paddingLeft = this.gutterSize;
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
			list.popUpContentManager = new DropDownPopUpContentManager();
			list.toggleButtonOnOpenAndClose = true;
			list.buttonFactory = pickerListButtonFactory;
		}

		protected function setPickerListButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.buttonMinWidth;
			skin.height = this.controlSize;
			skin.minWidth = this.buttonMinWidth;
			skin.minHeight = this.controlSize;
			button.defaultSkin = skin;

			var icon:ImageSkin = new ImageSkin(this.pickerListButtonIconTexture);
			icon.setTextureForState(ButtonState.DISABLED, this.pickerListButtonIconDisabledTexture);
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				icon.selectedTexture = this.pickerListButtonIconSelectedTexture;
				icon.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.pickerListButtonIconDisabledTexture);
			}
			button.defaultIcon = icon;

			button.fontStyles = this.darkUIFontStyles;
			button.disabledFontStyles = this.darkDisabledUIFontStyles;

			this.setBaseButtonStyles(button);

			button.gap = Number.POSITIVE_INFINITY; //fill as completely as possible
			button.horizontalAlign = HorizontalAlign.LEFT;
			button.iconPosition = RelativePosition.RIGHT;
		}

		//for the PickerList's pop-up list, see setDropDownListStyles()

	//-------------------------
	// ProgressBar
	//-------------------------

		protected function setProgressBarStyles(progress:ProgressBar):void
		{
			var backgroundSkin:Image = new Image(this.backgroundSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE9_GRID;
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

			var backgroundDisabledSkin:Image = new Image(this.backgroundDisabledSkinTexture);
			backgroundDisabledSkin.scale9Grid = DEFAULT_SCALE9_GRID;
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
			fillSkin.scale9Grid = BUTTON_SCALE9_GRID;
			if(progress.direction == Direction.VERTICAL)
			{
				fillSkin.width = this.smallControlSize;
				fillSkin.height = this.progressBarFillMinSize;
			}
			else
			{
				fillSkin.width = this.progressBarFillMinSize;
				fillSkin.height = this.smallControlSize;
			}
			progress.fillSkin = fillSkin;

			var fillDisabledSkin:Image = new Image(this.buttonDisabledSkinTexture);
			fillDisabledSkin.scale9Grid = BUTTON_SCALE9_GRID;
			if(progress.direction == Direction.VERTICAL)
			{
				fillDisabledSkin.width = this.smallControlSize;
				fillDisabledSkin.height = this.progressBarFillMinSize;
			}
			else
			{
				fillDisabledSkin.width = this.progressBarFillMinSize;
				fillDisabledSkin.height = this.smallControlSize;
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

			var icon:ImageSkin = new ImageSkin(this.radioUpIconTexture);
			icon.selectedTexture = this.radioSelectedUpIconTexture;
			icon.setTextureForState(ButtonState.DOWN, this.radioDownIconTexture);
			icon.setTextureForState(ButtonState.DISABLED, this.radioDisabledIconTexture);
			icon.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.radioSelectedDownIconTexture);
			icon.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.radioSelectedDisabledIconTexture);
			radio.defaultIcon = icon;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			radio.focusIndicatorSkin = focusIndicatorSkin;
			radio.focusPaddingLeft = this.focusPaddingSize;
			radio.focusPaddingRight = this.focusPaddingSize;

			radio.fontStyles = this.lightUIFontStyles;
			radio.disabledFontStyles = this.lightDisabledUIFontStyles;

			radio.horizontalAlign = HorizontalAlign.LEFT;
			radio.gap = this.smallGutterSize;
		}

	//-------------------------
	// ScrollBar
	//-------------------------

		protected function setHorizontalScrollBarStyles(scrollBar:ScrollBar):void
		{
			scrollBar.direction = Direction.HORIZONTAL;
			scrollBar.trackLayoutMode = TrackLayoutMode.SINGLE;

			scrollBar.customIncrementButtonStyleName = THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON;
			scrollBar.customDecrementButtonStyleName = THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON;
			scrollBar.customThumbStyleName = THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_THUMB;
			scrollBar.customMinimumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_MINIMUM_TRACK;
		}

		protected function setVerticalScrollBarStyles(scrollBar:ScrollBar):void
		{
			scrollBar.direction = Direction.VERTICAL;
			scrollBar.trackLayoutMode = TrackLayoutMode.SPLIT;

			scrollBar.customIncrementButtonStyleName = THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON;
			scrollBar.customDecrementButtonStyleName = THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON;
			scrollBar.customThumbStyleName = THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_THUMB;
			scrollBar.customMinimumTrackStyleName = THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_MINIMUM_TRACK;
			scrollBar.customMaximumTrackStyleName = THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_MAXIMUM_TRACK;
		}

		protected function setHorizontalScrollBarIncrementButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.horizontalScrollBarIncrementButtonUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.horizontalScrollBarIncrementButtonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.horizontalScrollBarIncrementButtonDisabledSkinTexture);
			skin.scale9Grid = SCROLL_BAR_STEP_BUTTON_SCALE9_GRID;
			skin.width = this.smallControlSize;
			skin.height = this.smallControlSize;
			button.defaultSkin = skin;

			button.defaultIcon = new Image(this.horizontalScrollBarIncrementButtonIconTexture);
			button.disabledIcon = new Image(this.horizontalScrollBarIncrementButtonDisabledIconTexture);

			var incrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
			incrementButtonDisabledIcon.alpha = 0;
			button.disabledIcon = incrementButtonDisabledIcon;

			button.hasLabelTextRenderer = false;
		}

		protected function setHorizontalScrollBarDecrementButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.horizontalScrollBarDecrementButtonUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.horizontalScrollBarDecrementButtonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.horizontalScrollBarDecrementButtonDisabledSkinTexture);
			skin.scale9Grid = SCROLL_BAR_STEP_BUTTON_SCALE9_GRID;
			skin.width = this.smallControlSize;
			skin.height = this.smallControlSize;
			button.defaultSkin = skin;

			button.defaultIcon = new Image(this.horizontalScrollBarDecrementButtonIconTexture);
			button.disabledIcon = new Image(this.horizontalScrollBarDecrementButtonDisabledIconTexture);

			var decrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
			decrementButtonDisabledIcon.alpha = 0;
			button.disabledIcon = decrementButtonDisabledIcon;

			button.hasLabelTextRenderer = false;
		}

		protected function setHorizontalScrollBarThumbStyles(thumb:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.smallControlSize;
			skin.height = this.smallControlSize;
			skin.minHeight = this.smallControlSize;
			thumb.defaultSkin = skin;

			thumb.hasLabelTextRenderer = false;
		}

		protected function setHorizontalScrollBarMinimumTrackStyles(track:Button):void
		{
			track.defaultSkin = new Quad(this.smallControlSize, this.smallControlSize, SCROLL_BAR_TRACK_COLOR);
			track.downSkin = new Quad(this.smallControlSize, this.smallControlSize, SCROLL_BAR_TRACK_DOWN_COLOR);

			track.hasLabelTextRenderer = false;
		}

		protected function setHorizontalScrollBarMaximumTrackStyles(track:Button):void
		{
			track.defaultSkin = new Quad(this.smallControlSize, this.smallControlSize, SCROLL_BAR_TRACK_COLOR);
			track.downSkin = new Quad(this.smallControlSize, this.smallControlSize, SCROLL_BAR_TRACK_DOWN_COLOR);

			track.hasLabelTextRenderer = false;
		}

		protected function setVerticalScrollBarIncrementButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.verticalScrollBarIncrementButtonUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.verticalScrollBarIncrementButtonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.verticalScrollBarIncrementButtonDisabledSkinTexture);
			skin.scale9Grid = SCROLL_BAR_STEP_BUTTON_SCALE9_GRID;
			skin.width = this.smallControlSize;
			skin.height = this.smallControlSize;
			button.defaultSkin = skin;

			button.defaultIcon = new Image(this.verticalScrollBarIncrementButtonIconTexture);
			button.disabledIcon = new Image(this.verticalScrollBarIncrementButtonDisabledIconTexture);

			var incrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
			incrementButtonDisabledIcon.alpha = 0;
			button.disabledIcon = incrementButtonDisabledIcon;

			button.hasLabelTextRenderer = false;
		}

		protected function setVerticalScrollBarDecrementButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.verticalScrollBarDecrementButtonUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.verticalScrollBarDecrementButtonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.verticalScrollBarDecrementButtonDisabledSkinTexture);
			skin.scale9Grid = SCROLL_BAR_STEP_BUTTON_SCALE9_GRID;
			skin.width = this.smallControlSize;
			skin.height = this.smallControlSize;
			button.defaultSkin = skin;

			button.defaultIcon = new Image(this.verticalScrollBarDecrementButtonIconTexture);
			button.disabledIcon = new Image(this.verticalScrollBarDecrementButtonDisabledIconTexture);

			var decrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
			decrementButtonDisabledIcon.alpha = 0;
			button.disabledIcon = decrementButtonDisabledIcon;

			button.hasLabelTextRenderer = false;
		}

		protected function setVerticalScrollBarThumbStyles(thumb:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.smallControlSize;
			skin.height = this.smallControlSize;
			skin.minHeight = this.smallControlSize;
			thumb.defaultSkin = skin;

			thumb.hasLabelTextRenderer = false;
		}

		protected function setVerticalScrollBarMinimumTrackStyles(track:Button):void
		{
			track.defaultSkin = new Quad(this.smallControlSize, this.smallControlSize, SCROLL_BAR_TRACK_COLOR);
			track.downSkin = new Quad(this.smallControlSize, this.smallControlSize, SCROLL_BAR_TRACK_DOWN_COLOR);

			track.hasLabelTextRenderer = false;
		}

		protected function setVerticalScrollBarMaximumTrackStyles(track:Button):void
		{
			track.defaultSkin = new Quad(this.smallControlSize, this.smallControlSize, SCROLL_BAR_TRACK_COLOR);
			track.downSkin = new Quad(this.smallControlSize, this.smallControlSize, SCROLL_BAR_TRACK_DOWN_COLOR);

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
				layout.padding = this.gutterSize;
				layout.gap = this.smallGutterSize;
				container.layout = layout;
			}

			var backgroundSkin:ImageSkin = new ImageSkin(this.headerBackgroundSkinTexture);
			backgroundSkin.tileGrid = new Rectangle();
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

			text.fontStyles = this.lightScrollTextFontStyles;
			text.disabledFontStyles = this.lightDisabledScrollTextFontStyles;

			text.padding = this.gutterSize;
		}

	//-------------------------
	// SimpleScrollBar
	//-------------------------

		protected function setSimpleScrollBarStyles(scrollBar:SimpleScrollBar):void
		{
			if(scrollBar.direction == Direction.HORIZONTAL)
			{
				scrollBar.paddingRight = this.scrollBarGutterSize;
				scrollBar.paddingBottom = this.scrollBarGutterSize;
				scrollBar.paddingLeft = this.scrollBarGutterSize;
				scrollBar.customThumbStyleName = THEME_STYLE_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB;
			}
			else
			{
				scrollBar.paddingTop = this.scrollBarGutterSize;
				scrollBar.paddingRight = this.scrollBarGutterSize;
				scrollBar.paddingBottom = this.scrollBarGutterSize;
				scrollBar.customThumbStyleName = THEME_STYLE_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB;
			}
		}

		protected function setHorizontalSimpleScrollBarThumbStyles(thumb:Button):void
		{
			var defaultSkin:Image = new Image(this.horizontalSimpleScrollBarThumbSkinTexture);
			defaultSkin.width = this.smallControlSize;
			defaultSkin.scale9Grid = HORIZONTAL_SCROLL_BAR_THUMB_SCALE_9_GRID;
			thumb.defaultSkin = defaultSkin;

			thumb.hasLabelTextRenderer = false;
		}

		protected function setVerticalSimpleScrollBarThumbStyles(thumb:Button):void
		{
			var defaultSkin:Image = new Image(this.verticalSimpleScrollBarThumbSkinTexture);
			defaultSkin.height = this.smallControlSize;
			defaultSkin.scale9Grid = VERTICAL_SCROLL_BAR_THUMB_SCALE_9_GRID;
			thumb.defaultSkin = defaultSkin;

			thumb.hasLabelTextRenderer = false;
		}

	//-------------------------
	// Slider
	//-------------------------

		protected function setSliderStyles(slider:Slider):void
		{
			slider.trackLayoutMode = TrackLayoutMode.SPLIT;
			if(slider.direction == Direction.VERTICAL)
			{
				slider.customMinimumTrackStyleName = THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK;
				slider.customMaximumTrackStyleName = THEME_STYLE_NAME_VERTICAL_SLIDER_MAXIMUM_TRACK;
			}
			else //horizontal
			{
				slider.customMinimumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK;
				slider.customMaximumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_SLIDER_MAXIMUM_TRACK;
			}

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			slider.focusIndicatorSkin = focusIndicatorSkin;
			slider.focusPadding = this.focusPaddingSize;
		}

		protected function setSliderThumbStyles(thumb:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.smallControlSize;
			skin.height = this.smallControlSize;
			skin.minWidth = this.smallControlSize;
			skin.minHeight = this.smallControlSize;
			thumb.defaultSkin = skin;

			thumb.hasLabelTextRenderer = false;
		}

		protected function setHorizontalSliderMinimumTrackStyles(track:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.backgroundSkinTexture);
			skin.disabledTexture = this.backgroundDisabledSkinTexture;
			skin.scale9Grid = DEFAULT_SCALE9_GRID;
			skin.width = this.wideControlSize;
			skin.height = this.smallControlSize;
			skin.minWidth = this.wideControlSize;
			skin.minHeight = this.smallControlSize;
			track.defaultSkin = skin;

			track.hasLabelTextRenderer = false;
		}

		protected function setHorizontalSliderMaximumTrackStyles(track:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.backgroundSkinTexture);
			skin.disabledTexture = this.backgroundDisabledSkinTexture;
			skin.scale9Grid = DEFAULT_SCALE9_GRID;
			skin.width = this.wideControlSize;
			skin.height = this.smallControlSize;
			skin.minWidth = this.wideControlSize;
			skin.minHeight = this.smallControlSize;
			track.defaultSkin = skin;

			track.hasLabelTextRenderer = false;
		}

		protected function setVerticalSliderMinimumTrackStyles(track:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.backgroundSkinTexture);
			skin.disabledTexture = this.backgroundDisabledSkinTexture;
			skin.scale9Grid = DEFAULT_SCALE9_GRID;
			skin.width = this.smallControlSize;
			skin.height = this.wideControlSize;
			skin.minWidth = this.smallControlSize;
			skin.minHeight = this.wideControlSize;
			track.defaultSkin = skin;

			track.hasLabelTextRenderer = false;
		}

		protected function setVerticalSliderMaximumTrackStyles(track:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.backgroundSkinTexture);
			skin.disabledTexture = this.backgroundDisabledSkinTexture;
			skin.scale9Grid = DEFAULT_SCALE9_GRID;
			skin.width = this.smallControlSize;
			skin.height = this.wideControlSize;
			skin.minWidth = this.smallControlSize;
			skin.minHeight = this.wideControlSize;
			track.defaultSkin = skin;

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
			skin.selectedTexture = this.tabSelectedSkinTexture;
			skin.setTextureForState(ButtonState.DOWN, this.tabDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.tabDisabledSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.tabSelectedDisabledSkinTexture);
			skin.scale9Grid = TAB_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.controlSize;
			skin.minHeight = this.controlSize;
			tab.defaultSkin = skin;

			tab.fontStyles = this.lightUIFontStyles;
			tab.selectedFontStyles = this.darkUIFontStyles;
			tab.setFontStylesForState(ButtonState.DOWN, this.darkUIFontStyles);
			tab.setFontStylesForState(ButtonState.DISABLED, this.lightDisabledUIFontStyles);
			tab.setFontStylesForState(ButtonState.DISABLED_AND_SELECTED, this.darkDisabledUIFontStyles);

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			tab.focusIndicatorSkin = focusIndicatorSkin;
			tab.focusPadding = this.focusPaddingSize;

			tab.paddingTop = this.smallGutterSize;
			tab.paddingBottom = this.smallGutterSize;
			tab.paddingLeft = this.gutterSize;
			tab.paddingRight = this.gutterSize;
			tab.gap = this.smallGutterSize;
		}

	//-------------------------
	// TextArea
	//-------------------------

		protected function setTextAreaStyles(textArea:TextArea):void
		{
			this.setScrollerStyles(textArea);

			var skin:ImageSkin = new ImageSkin(this.backgroundSkinTexture);
			skin.setTextureForState(TextInputState.DISABLED, this.backgroundDisabledSkinTexture);
			skin.setTextureForState(TextInputState.FOCUSED, this.backgroundFocusedSkinTexture);
			skin.setTextureForState(TextInputState.ERROR, this.backgroundDangerSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE9_GRID;
			skin.width = this.wideControlSize * 2;
			skin.height = this.wideControlSize;
			textArea.backgroundSkin = skin;

			textArea.fontStyles = this.lightScrollTextFontStyles;
			textArea.disabledFontStyles = this.lightDisabledScrollTextFontStyles;

			textArea.padding = this.borderSize;
		}

		protected function setTextAreaTextEditorStyles(textEditor:TextFieldTextEditorViewPort):void
		{
			textEditor.padding = this.smallGutterSize;
		}

		protected function setTextAreaErrorCalloutStyles(callout:TextCallout):void
		{
			this.setDangerCalloutStyles(callout);

			callout.fontStyles = this.lightFontStyles;
			callout.disabledFontStyles = this.lightDisabledFontStyles;

			callout.horizontalAlign = HorizontalAlign.LEFT;
			callout.verticalAlign = VerticalAlign.TOP;
		}

	//-------------------------
	// TextCallout
	//-------------------------

		protected function setTextCalloutStyles(callout:TextCallout):void
		{
			this.setCalloutStyles(callout);

			callout.fontStyles = this.lightFontStyles;
			callout.disabledFontStyles = this.lightDisabledFontStyles;
		}

	//-------------------------
	// TextInput
	//-------------------------

		protected function setBaseTextInputStyles(input:TextInput):void
		{
			var skin:ImageSkin = new ImageSkin(this.backgroundSkinTexture);
			skin.setTextureForState(TextInputState.DISABLED, this.backgroundDisabledSkinTexture);
			skin.setTextureForState(TextInputState.FOCUSED, this.backgroundFocusedSkinTexture);
			skin.setTextureForState(TextInputState.ERROR, this.backgroundDangerSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE9_GRID;
			skin.width = this.wideControlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.controlSize;
			skin.minHeight = this.controlSize;
			input.backgroundSkin = skin;

			input.fontStyles = this.lightFontStyles;
			input.disabledFontStyles = this.lightDisabledFontStyles;

			input.promptFontStyles = this.lightFontStyles;
			input.promptDisabledFontStyles = this.lightDisabledFontStyles;

			input.gap = this.smallGutterSize;
			input.paddingTop = this.smallGutterSize;
			input.paddingBottom = this.smallGutterSize;
			input.paddingLeft = this.gutterSize;
			input.paddingRight = this.gutterSize;
		}

		protected function setTextInputStyles(input:TextInput):void
		{
			this.setBaseTextInputStyles(input);
		}

		protected function setTextInputTextEditorStyles(textEditor:TextBlockTextEditor):void
		{
			textEditor.cursorSkin = new Quad(1, 1, LIGHT_TEXT_COLOR);
			textEditor.selectionSkin = new Quad(1, 1, TEXT_SELECTION_BACKGROUND_COLOR);
		}

		protected function setTextInputErrorCalloutStyles(callout:TextCallout):void
		{
			this.setDangerCalloutStyles(callout);

			callout.fontStyles = this.lightFontStyles;
			callout.disabledFontStyles = this.lightDisabledFontStyles;

			callout.horizontalAlign = HorizontalAlign.LEFT;
			callout.verticalAlign = VerticalAlign.TOP;
		}

		protected function setSearchTextInputStyles(input:TextInput):void
		{
			this.setBaseTextInputStyles(input);

			var icon:ImageSkin = new ImageSkin(this.searchIconTexture);
			icon.disabledTexture = this.searchIconDisabledTexture;
			input.defaultIcon = icon;
		}

	//-------------------------
	// ToggleSwitch
	//-------------------------

		protected function setToggleSwitchStyles(toggle:ToggleSwitch):void
		{
			toggle.trackLayoutMode = TrackLayoutMode.SINGLE;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			toggle.focusIndicatorSkin = focusIndicatorSkin;
			toggle.focusPadding = this.focusPaddingSize;

			toggle.offLabelFontStyles = this.lightUIFontStyles;
			toggle.offLabelDisabledFontStyles = this.lightDisabledUIFontStyles;

			toggle.onLabelFontStyles = this.selectedUIFontStyles;
			toggle.onLabelDisabledFontStyles = this.lightDisabledUIFontStyles;
		}

		protected function setToggleSwitchThumbStyles(thumb:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.controlSize;
			skin.minHeight = this.controlSize;
			thumb.defaultSkin = skin;

			thumb.hasLabelTextRenderer = false;
		}

		protected function setToggleSwitchTrackStyles(track:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.backgroundSkinTexture);
			skin.disabledTexture = this.backgroundDisabledSkinTexture;
			skin.scale9Grid = DEFAULT_SCALE9_GRID;
			skin.width = Math.round(this.controlSize * 2.5);
			skin.height = this.controlSize;
			track.defaultSkin = skin;

			track.hasLabelTextRenderer = false;
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
			var skin:Quad = new Quad(this.controlSize, this.controlSize);
			skin.alpha = 0;
			button.defaultSkin = skin;

			var icon:ImageSkin = new ImageSkin(this.playPauseButtonPlayUpIconTexture);
			icon.selectedTexture = this.playPauseButtonPauseUpIconTexture;
			icon.setTextureForState(ButtonState.DOWN, this.playPauseButtonPlayDownIconTexture);
			icon.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.playPauseButtonPauseDownIconTexture);
			button.defaultIcon = icon;

			button.hasLabelTextRenderer = false;
		}

		protected function setOverlayPlayPauseToggleButtonStyles(button:PlayPauseToggleButton):void
		{
			var icon:ImageSkin = new ImageSkin(null);
			icon.setTextureForState(ButtonState.UP, this.overlayPlayPauseButtonPlayUpIconTexture);
			icon.setTextureForState(ButtonState.HOVER, this.overlayPlayPauseButtonPlayUpIconTexture);
			icon.setTextureForState(ButtonState.DOWN, this.overlayPlayPauseButtonPlayDownIconTexture);
			button.setIconForState(ButtonState.UP, icon);
			button.setIconForState(ButtonState.HOVER, icon);
			button.setIconForState(ButtonState.DOWN, icon);

			var defaultIcon:Quad = new Quad(1, 1, 0xff00ff);
			defaultIcon.alpha = 0;
			button.defaultIcon = defaultIcon;

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
			var skin:Quad = new Quad(this.controlSize, this.controlSize);
			skin.alpha = 0;
			button.defaultSkin = skin;

			var icon:ImageSkin = new ImageSkin(this.fullScreenToggleButtonEnterUpIconTexture);
			icon.selectedTexture = this.fullScreenToggleButtonExitUpIconTexture;
			icon.setTextureForState(ButtonState.DOWN, this.fullScreenToggleButtonEnterDownIconTexture);
			icon.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.fullScreenToggleButtonExitDownIconTexture);
			button.defaultIcon = icon;

			button.hasLabelTextRenderer = false;
		}

	//-------------------------
	// VolumeSlider
	//-------------------------

		protected function setVolumeSliderStyles(slider:VolumeSlider):void
		{
			slider.direction = Direction.HORIZONTAL;
			slider.trackLayoutMode = TrackLayoutMode.SPLIT;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			slider.focusIndicatorSkin = focusIndicatorSkin;
			slider.focusPadding = this.focusPaddingSize;

			slider.showThumb = false;
		}

		protected function setVolumeSliderThumbStyles(thumb:Button):void
		{
			var thumbSize:Number = 6;
			var defaultSkin:Quad = new Quad(thumbSize, thumbSize);
			defaultSkin.width = 0;
			defaultSkin.height = 0;
			thumb.defaultSkin = defaultSkin;
			thumb.hasLabelTextRenderer = false;
		}

		protected function setVolumeSliderMinimumTrackStyles(track:Button):void
		{
			var defaultSkin:ImageLoader = new ImageLoader();
			defaultSkin.scaleContent = false;
			defaultSkin.source = this.volumeSliderMinimumTrackSkinTexture;
			track.defaultSkin = defaultSkin;
			track.hasLabelTextRenderer = false;
		}

		protected function setVolumeSliderMaximumTrackStyles(track:Button):void
		{
			var defaultSkin:ImageLoader = new ImageLoader();
			defaultSkin.scaleContent = false;
			defaultSkin.horizontalAlign = HorizontalAlign.RIGHT;
			defaultSkin.source = this.volumeSliderMaximumTrackSkinTexture;
			track.defaultSkin = defaultSkin;
			track.hasLabelTextRenderer = false;
		}

	//-------------------------
	// MuteToggleButton
	//-------------------------

		protected function setMuteToggleButtonStyles(button:MuteToggleButton):void
		{
			var skin:Quad = new Quad(this.controlSize, this.controlSize);
			skin.alpha = 0;
			button.defaultSkin = skin;

			var icon:ImageSkin = new ImageSkin(this.muteToggleButtonLoudUpIconTexture);
			icon.selectedTexture = this.muteToggleButtonMutedUpIconTexture;
			icon.setTextureForState(ButtonState.DOWN, this.muteToggleButtonLoudDownIconTexture);
			icon.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.muteToggleButtonMutedDownIconTexture);
			button.defaultIcon = icon;

			button.showVolumeSliderOnHover = true;
			button.hasLabelTextRenderer = false;
		}

		protected function setPopUpVolumeSliderStyles(slider:VolumeSlider):void
		{
			slider.direction = Direction.VERTICAL;
			slider.trackLayoutMode = TrackLayoutMode.SINGLE;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			slider.focusIndicatorSkin = focusIndicatorSkin;
			slider.focusPadding = this.focusPaddingSize;

			slider.minimumPadding = this.popUpVolumeSliderPaddingSize;
			slider.maximumPadding = this.popUpVolumeSliderPaddingSize;
			slider.customThumbStyleName = THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_THUMB;
			slider.customMinimumTrackStyleName = THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MINIMUM_TRACK;
		}

		protected function setPopUpVolumeSliderTrackStyles(track:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.popUpVolumeSliderTrackSkinTexture);
			skin.scale9Grid = VOLUME_SLIDER_TRACK_SCALE9_GRID;
			skin.width = this.gridSize;
			skin.height = this.wideControlSize;
			track.defaultSkin = skin;

			track.hasLabelTextRenderer = false;
		}

	//-------------------------
	// SeekSlider
	//-------------------------

		protected function setSeekSliderStyles(slider:SeekSlider):void
		{
			slider.trackLayoutMode = TrackLayoutMode.SPLIT;
			slider.showThumb = false;
			var progressSkin:Image = new Image(this.seekSliderProgressSkinTexture);
			progressSkin.scale9Grid = DEFAULT_SCALE9_GRID;
			progressSkin.width = this.smallControlSize;
			progressSkin.height = this.smallControlSize;
			slider.progressSkin = progressSkin;
		}

		protected function setSeekSliderThumbStyles(thumb:Button):void
		{
			var thumbSize:Number = 6;
			var defaultSkin:Quad = new Quad(thumbSize, thumbSize);
			defaultSkin.width = 0;
			defaultSkin.height = 0;
			thumb.defaultSkin = defaultSkin;
			thumb.hasLabelTextRenderer = false;
		}

		protected function setSeekSliderMinimumTrackStyles(track:Button):void
		{
			var defaultSkin:ImageSkin = new ImageSkin(this.buttonUpSkinTexture);
			defaultSkin.scale9Grid = BUTTON_SCALE9_GRID;
			defaultSkin.width = this.wideControlSize;
			defaultSkin.height = this.smallControlSize;
			defaultSkin.minWidth = this.wideControlSize;
			defaultSkin.minHeight = this.smallControlSize;
			track.defaultSkin = defaultSkin;
			track.hasLabelTextRenderer = false;
		}

		protected function setSeekSliderMaximumTrackStyles(track:Button):void
		{
			var defaultSkin:ImageSkin = new ImageSkin(this.backgroundSkinTexture);
			defaultSkin.scale9Grid = DEFAULT_SCALE9_GRID;
			defaultSkin.width = this.wideControlSize;
			defaultSkin.height = this.smallControlSize;
			defaultSkin.minWidth = this.wideControlSize;
			defaultSkin.minHeight = this.smallControlSize;
			track.defaultSkin = defaultSkin;
			track.hasLabelTextRenderer = false;
		}

	}
}
