/*
Copyright 2012-2015 Bowler Hat LLC

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
	import feathers.controls.ScrollBar;
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
	import feathers.display.TiledImage;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.media.FullScreenToggleButton;
	import feathers.media.MuteToggleButton;
	import feathers.media.PlayPauseToggleButton;
	import feathers.media.SeekSlider;
	import feathers.media.VideoPlayer;
	import feathers.media.VolumeSlider;
	import feathers.skins.ImageSkin;
	import feathers.skins.StandardIcons;

	import flash.geom.Rectangle;

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
	import starling.display.Stage;
	import starling.textures.SubTexture;
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

		protected static const PRIMARY_BACKGROUND_COLOR:uint = 0x4a4137;
		protected static const LIGHT_TEXT_COLOR:uint = 0xe5e5e5;
		protected static const DARK_TEXT_COLOR:uint = 0x1a1816;
		protected static const SELECTED_TEXT_COLOR:uint = 0xff9900;
		protected static const DISABLED_TEXT_COLOR:uint = 0x8a8a8a;
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
		protected static const THEME_STYLE_NAME_QUIET_BUTTON_LABEL:String = "metalworks-desktop-quiet-button-label";

		/**
		 * @private
		 */
		protected static const THEME_STYLE_NAME_POP_UP_HEADER_TITLE:String = "metalworks-desktop-pop-up-header-title";

		/**
		 * @private
		 */
		protected static const THEME_STYLE_NAME_CHECK_ITEM_RENDERER_LABEL:String = "metalworks-desktop-check-item-renderer-label";

		/**
		 * @private
		 */
		protected static const THEME_STYLE_NAME_CHECK_ITEM_RENDERER_ICON_LABEL:String = "metalworks-desktop-check-item-renderer-icon-label";

		/**
		 * @private
		 */
		protected static const THEME_STYLE_NAME_CHECK_ITEM_RENDERER_ACCESSORY_LABEL:String = "metalworks-desktop-check-item-renderer-accessory-label";

		/**
		 * @private
		 */
		protected static const THEME_STYLE_NAME_GROUPED_LIST_FOOTER_CONTENT_LABEL:String = "metalworks-desktop-grouped-list-footer-content-label";

		/**
		 * @private
		 */
		protected static const THEME_STYLE_NAME_TAB_LABEL:String = "metalworks-desktop-tab-bar-tab-label";

		/**
		 * @private
		 */
		protected static const THEME_STYLE_NAME_NUMERIC_STEPPER_TEXT_INPUT_TEXT_EDITOR:String = "metalworks-desktop-numeric-stepper-text-input-text-editor";

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
		 * The FTE FontDescription used for text of a normal weight.
		 */
		protected var regularFontDescription:FontDescription;

		/**
		 * The FTE FontDescription used for text of a bold weight.
		 */
		protected var boldFontDescription:FontDescription;

		/**
		 * ScrollText uses TextField instead of FTE, so it has a separate TextFormat.
		 */
		protected var scrollTextTextFormat:TextFormat;

		/**
		 * ScrollText uses TextField instead of FTE, so it has a separate disabled TextFormat.
		 */
		protected var scrollTextDisabledTextFormat:TextFormat;

		/**
		 * An ElementFormat with a dark tint used for UI controls.
		 */
		protected var darkUIElementFormat:ElementFormat;

		/**
		 * An ElementFormat with a light tint used for UI controls.
		 */
		protected var lightUIElementFormat:ElementFormat;

		/**
		 * An ElementFormat with a highlighted tint used for selected UI controls.
		 */
		protected var selectedUIElementFormat:ElementFormat;

		/**
		 * An ElementFormat with a light tint used for disabled UI controls.
		 */
		protected var lightUIDisabledElementFormat:ElementFormat;

		/**
		 * An ElementFormat with a dark tint used for disabled UI controls.
		 */
		protected var darkUIDisabledElementFormat:ElementFormat;

		/**
		 * An ElementFormat with a dark tint used for larger UI controls.
		 */
		protected var largeDarkElementFormat:ElementFormat;

		/**
		 * An ElementFormat with a light tint used for larger UI controls.
		 */
		protected var largeLightElementFormat:ElementFormat;

		/**
		 * An ElementFormat used for larger, disabled UI controls.
		 */
		protected var largeDisabledElementFormat:ElementFormat;


		/**
		 * An ElementFormat with a dark tint used for text.
		 */
		protected var darkElementFormat:ElementFormat;

		/**
		 * An ElementFormat with a light tint used for text.
		 */
		protected var lightElementFormat:ElementFormat;

		/**
		 * An ElementFormat used for disabled text.
		 */
		protected var disabledElementFormat:ElementFormat;

		/**
		 * An ElementFormat with a light tint used for smaller text.
		 */
		protected var smallLightElementFormat:ElementFormat;

		/**
		 * An ElementFormat used for smaller, disabled text.
		 */
		protected var smallDisabledElementFormat:ElementFormat;

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
		protected var calloutTopArrowSkinTexture:Texture;
		protected var calloutRightArrowSkinTexture:Texture;
		protected var calloutBottomArrowSkinTexture:Texture;
		protected var calloutLeftArrowSkinTexture:Texture;
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
			Starling.current.stage.color = PRIMARY_BACKGROUND_COLOR;
			Starling.current.nativeStage.color = PRIMARY_BACKGROUND_COLOR;
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

			var stage:Stage = Starling.current.stage;
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

			//these are for components that don't use FTE
			this.scrollTextTextFormat = new TextFormat("_sans", this.regularFontSize, LIGHT_TEXT_COLOR);
			this.scrollTextDisabledTextFormat = new TextFormat("_sans", this.regularFontSize, DISABLED_TEXT_COLOR);

			this.regularFontDescription = new FontDescription(FONT_NAME, FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE);
			this.boldFontDescription = new FontDescription(FONT_NAME, FontWeight.BOLD, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE);

			this.darkUIElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, DARK_TEXT_COLOR);
			this.lightUIElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, LIGHT_TEXT_COLOR);
			this.selectedUIElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, SELECTED_TEXT_COLOR);
			this.lightUIDisabledElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, DISABLED_TEXT_COLOR);
			this.darkUIDisabledElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, DARK_DISABLED_TEXT_COLOR);

			this.darkElementFormat = new ElementFormat(this.regularFontDescription, this.regularFontSize, DARK_TEXT_COLOR);
			this.lightElementFormat = new ElementFormat(this.regularFontDescription, this.regularFontSize, LIGHT_TEXT_COLOR);
			this.disabledElementFormat = new ElementFormat(this.regularFontDescription, this.regularFontSize, DISABLED_TEXT_COLOR);

			this.smallLightElementFormat = new ElementFormat(this.regularFontDescription, this.smallFontSize, LIGHT_TEXT_COLOR);
			this.smallDisabledElementFormat = new ElementFormat(this.regularFontDescription, this.smallFontSize, DISABLED_TEXT_COLOR);

			this.largeDarkElementFormat = new ElementFormat(this.regularFontDescription, this.largeFontSize, DARK_TEXT_COLOR);
			this.largeLightElementFormat = new ElementFormat(this.regularFontDescription, this.largeFontSize, LIGHT_TEXT_COLOR);
			this.largeDisabledElementFormat = new ElementFormat(this.regularFontDescription, this.largeFontSize, DISABLED_TEXT_COLOR);
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
			this.backgroundPopUpSkinTexture = this.atlas.getTexture("background-popup-skin0000");
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
			
			//in a future version of Feathers, the StandardIcons class will be
			//removed. it's still used here to support legacy code.
			StandardIcons.listDrillDownAccessoryTexture = this.listDrillDownAccessoryTexture;

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
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_MESSAGE, this.setAlertMessageTextRendererStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(THEME_STYLE_NAME_POP_UP_HEADER_TITLE, this.setPopupHeaderTitleStyles);

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
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(Button.DEFAULT_CHILD_STYLE_NAME_LABEL, this.setButtonLabelStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(THEME_STYLE_NAME_QUIET_BUTTON_LABEL, this.setQuietButtonLabelStyles);

			//button group
			this.getStyleProviderForClass(ButtonGroup).defaultStyleFunction = this.setButtonGroupStyles;

			//callout
			this.getStyleProviderForClass(Callout).defaultStyleFunction = this.setCalloutStyles;

			//check
			this.getStyleProviderForClass(Check).defaultStyleFunction = this.setCheckStyles;
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(Check.DEFAULT_CHILD_STYLE_NAME_LABEL, this.setCheckLabelStyles);

			//date time spinner
			this.getStyleProviderForClass(SpinnerList).setFunctionForStyleName(DateTimeSpinner.DEFAULT_CHILD_STYLE_NAME_LIST, this.setDateTimeSpinnerListStyles);
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_DATE_TIME_SPINNER_LIST_ITEM_RENDERER, this.setDateTimeSpinnerListItemRendererStyles);

			//drawers
			this.getStyleProviderForClass(Drawers).defaultStyleFunction = this.setDrawersStyles;

			//grouped list (see also: item renderers)
			this.getStyleProviderForClass(GroupedList).defaultStyleFunction = this.setGroupedListStyles;

			//header
			this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(Header.DEFAULT_CHILD_STYLE_NAME_TITLE, this.setHeaderTitleProperties);

			//header and footer renderers for grouped list
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).defaultStyleFunction = this.setGroupedListHeaderRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.DEFAULT_CHILD_STYLE_NAME_FOOTER_RENDERER, this.setGroupedListFooterRendererStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(DefaultGroupedListHeaderOrFooterRenderer.DEFAULT_CHILD_STYLE_NAME_CONTENT_LABEL, this.setGroupedListHeaderContentLabelStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(THEME_STYLE_NAME_GROUPED_LIST_FOOTER_CONTENT_LABEL, this.setGroupedListFooterContentLabelStyles);

			//item renderers for lists
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(DefaultGroupedListItemRenderer.ALTERNATE_STYLE_NAME_DRILL_DOWN, this.setDrillDownItemRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(DefaultGroupedListItemRenderer.ALTERNATE_STYLE_NAME_CHECK, this.setCheckItemRendererStyles);
			this.getStyleProviderForClass(DefaultListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(DefaultListItemRenderer.ALTERNATE_STYLE_NAME_DRILL_DOWN, this.setDrillDownItemRendererStyles);
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(DefaultListItemRenderer.ALTERNATE_STYLE_NAME_CHECK, this.setCheckItemRendererStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_LABEL, this.setItemRendererLabelStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL, this.setItemRendererAccessoryLabelStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_ICON_LABEL, this.setItemRendererIconLabelStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(THEME_STYLE_NAME_CHECK_ITEM_RENDERER_LABEL, this.setCheckItemRendererLabelStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(THEME_STYLE_NAME_CHECK_ITEM_RENDERER_ICON_LABEL, this.setCheckItemRendererIconLabelStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(THEME_STYLE_NAME_CHECK_ITEM_RENDERER_ACCESSORY_LABEL, this.setCheckItemRendererAccessoryLabelStyles);

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
			this.getStyleProviderForClass(TextBlockTextEditor).setFunctionForStyleName(THEME_STYLE_NAME_NUMERIC_STEPPER_TEXT_INPUT_TEXT_EDITOR, this.setNumericStepperTextInputTextEditorStyles);
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
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(Radio.DEFAULT_CHILD_STYLE_NAME_LABEL, this.setRadioLabelStyles);

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

			//tab bar
			this.getStyleProviderForClass(TabBar).defaultStyleFunction = this.setTabBarStyles;
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(TabBar.DEFAULT_CHILD_STYLE_NAME_TAB, this.setTabStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(THEME_STYLE_NAME_TAB_LABEL, this.setTabLabelStyles);

			//text input
			this.getStyleProviderForClass(TextInput).defaultStyleFunction = this.setTextInputStyles;
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName(TextInput.ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT, this.setSearchTextInputStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(TextInput.DEFAULT_CHILD_STYLE_NAME_PROMPT, this.setTextInputPromptStyles);
			this.getStyleProviderForClass(TextBlockTextEditor).setFunctionForStyleName(TextInput.DEFAULT_CHILD_STYLE_NAME_TEXT_EDITOR, this.setTextInputTextEditorStyles);

			//text area
			this.getStyleProviderForClass(TextArea).defaultStyleFunction = this.setTextAreaStyles;
			this.getStyleProviderForClass(TextFieldTextEditorViewPort).setFunctionForStyleName(TextArea.DEFAULT_CHILD_STYLE_NAME_TEXT_EDITOR, this.setTextAreaTextEditorStyles);

			//toggle button
			this.getStyleProviderForClass(ToggleButton).defaultStyleFunction = this.setButtonStyles;
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);

			//toggle switch
			this.getStyleProviderForClass(ToggleSwitch).defaultStyleFunction = this.setToggleSwitchStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setToggleSwitchThumbStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setToggleSwitchThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_ON_TRACK, this.setToggleSwitchTrackStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_ON_LABEL, this.setToggleSwitchOnLabelStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_OFF_LABEL, this.setToggleSwitchOffLabelStyles);
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
			scroller.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
			scroller.interactionMode = Scroller.INTERACTION_MODE_MOUSE;

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
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			layout.resetTypicalItemDimensionsOnMeasure = true;
			list.layout = layout;
			list.maxHeight = this.wideControlSize;
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
			group.direction = ButtonGroup.DIRECTION_HORIZONTAL;
			group.horizontalAlign = ButtonGroup.HORIZONTAL_ALIGN_CENTER;
			group.verticalAlign = ButtonGroup.VERTICAL_ALIGN_JUSTIFY;
			group.distributeButtonSizes = false;
			group.gap = this.smallGutterSize;
			group.padding = this.smallGutterSize;
		}

		protected function setAlertMessageTextRendererStyles(renderer:TextBlockTextRenderer):void
		{
			renderer.wordWrap = true;
			renderer.elementFormat = this.lightElementFormat;
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
			button.minWidth = this.smallControlSize;
			button.minHeight = this.smallControlSize;
		}

		protected function setButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
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
			
			this.setBaseButtonStyles(button);
			
			button.minWidth = this.buttonMinWidth;
			button.minHeight = this.controlSize;
		}
		
		protected function setButtonLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.darkUIElementFormat;
			textRenderer.disabledElementFormat = this.darkUIDisabledElementFormat;
		}

		protected function setCallToActionButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonCallToActionUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonCallToActionDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			button.defaultSkin = skin;
			
			this.setBaseButtonStyles(button);
			
			button.minWidth = this.buttonMinWidth;
			button.minHeight = this.controlSize;
		}

		protected function setQuietButtonStyles(button:Button):void
		{
			var defaultSkin:Quad = new Quad(this.controlSize, this.controlSize, 0xff00ff);
			defaultSkin.alpha = 0;
			button.defaultSkin = defaultSkin;
			
			var otherSkin:ImageSkin = new ImageSkin();
			otherSkin.setTextureForState(ButtonState.HOVER, this.buttonQuietHoverSkinTexture);
			otherSkin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			button.hoverSkin = otherSkin;
			button.downSkin = otherSkin;
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				otherSkin.selectedTexture = this.toggleButtonSelectedUpSkinTexture;
				otherSkin.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.toggleButtonSelectedDisabledSkinTexture);
				ToggleButton(button).defaultSelectedSkin = otherSkin;
				button.setSkinForState(ButtonState.DISABLED_AND_SELECTED, otherSkin);
			}
			otherSkin.scale9Grid = BUTTON_SCALE9_GRID;
			otherSkin.width = this.controlSize;
			otherSkin.height = this.controlSize;

			button.customLabelStyleName = THEME_STYLE_NAME_QUIET_BUTTON_LABEL;

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
			button.minWidth = this.controlSize;
			button.minHeight = this.controlSize;
		}
		
		protected function setQuietButtonLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightUIElementFormat;
			textRenderer.selectedElementFormat = this.darkUIElementFormat;
			textRenderer.disabledElementFormat = this.lightUIDisabledElementFormat;
			textRenderer.setElementFormatForState(Button.STATE_DOWN, this.darkUIElementFormat);
			textRenderer.setElementFormatForState(Button.STATE_DISABLED, this.lightUIDisabledElementFormat);
			if(textRenderer.stateContext is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				textRenderer.setElementFormatForState(ToggleButton.STATE_DISABLED_AND_SELECTED, this.darkUIDisabledElementFormat);
			}
		}

		protected function setDangerButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonDangerUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDangerDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			button.defaultSkin = skin;
			this.setBaseButtonStyles(button);
			button.minWidth = this.buttonMinWidth;
			button.minHeight = this.controlSize;
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
			
			button.paddingLeft = 2 * this.gutterSize;
			button.minWidth = this.controlSize;
			button.minHeight = this.controlSize;
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
			
			button.paddingRight = 2 * this.gutterSize;
			button.minWidth = this.controlSize;
			button.minHeight = this.controlSize;
		}

	//-------------------------
	// ButtonGroup
	//-------------------------

		protected function setButtonGroupStyles(group:ButtonGroup):void
		{
			group.minWidth = this.wideControlSize;
			group.gap = this.smallGutterSize;
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

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			check.focusIndicatorSkin = focusIndicatorSkin;
			check.focusPaddingLeft = this.focusPaddingSize;
			check.focusPaddingRight = this.focusPaddingSize;

			check.horizontalAlign = Check.HORIZONTAL_ALIGN_LEFT;
			check.gap = this.smallGutterSize;
			check.minWidth = this.controlSize;
			check.minHeight = this.controlSize;
		}

		protected function setCheckLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightUIElementFormat;
			textRenderer.disabledElementFormat = this.lightUIDisabledElementFormat;
		}

	//-------------------------
	// DateTimeSpinner
	//-------------------------

		protected function setDateTimeSpinnerListStyles(list:SpinnerList):void
		{
			this.setListStyles(list);
			list.customItemRendererStyleName = THEME_STYLE_NAME_DATE_TIME_SPINNER_LIST_ITEM_RENDERER;
		}

		protected function setDateTimeSpinnerListItemRendererStyles(itemRenderer:DefaultListItemRenderer):void
		{
			this.setItemRendererStyles(itemRenderer);
			itemRenderer.accessoryPosition = DefaultListItemRenderer.ACCESSORY_POSITION_LEFT;
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

			list.verticalScrollPolicy = List.SCROLL_POLICY_AUTO;
		}

		//see List section for item renderer styles

		protected function setGroupedListHeaderRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			renderer.backgroundSkin = new Quad(this.controlSize, this.controlSize, GROUPED_LIST_HEADER_BACKGROUND_COLOR);

			renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_LEFT;

			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;
			renderer.paddingRight = this.gutterSize;
			renderer.minWidth = this.controlSize;
			renderer.minHeight = this.controlSize;
		}

		protected function setGroupedListFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			renderer.backgroundSkin = new Quad(this.controlSize, this.controlSize, GROUPED_LIST_FOOTER_BACKGROUND_COLOR);

			renderer.customContentLabelStyleName = THEME_STYLE_NAME_GROUPED_LIST_FOOTER_CONTENT_LABEL;

			renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_CENTER;

			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;
			renderer.paddingRight = this.gutterSize;
			renderer.minWidth = renderer.minHeight = this.controlSize;
		}

		protected function setGroupedListHeaderContentLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightUIElementFormat;
			textRenderer.disabledElementFormat = this.lightUIDisabledElementFormat;
		}

		protected function setGroupedListFooterContentLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightElementFormat;
			textRenderer.disabledElementFormat = this.disabledElementFormat;
		}

	//-------------------------
	// Header
	//-------------------------

		protected function setHeaderStyles(header:Header):void
		{
			header.minWidth = this.gridSize;
			header.minHeight = this.gridSize;
			header.paddingTop = this.smallGutterSize;
			header.paddingBottom = this.smallGutterSize;
			header.paddingRight = this.gutterSize;
			header.paddingLeft = this.gutterSize;
			header.gap = this.smallGutterSize;
			header.titleGap = this.smallGutterSize;

			var backgroundSkin:TiledImage = new TiledImage(this.headerBackgroundSkinTexture);
			backgroundSkin.width = this.controlSize;
			backgroundSkin.height = this.controlSize;
			header.backgroundSkin = backgroundSkin;
		}

		protected function setHeaderTitleProperties(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightElementFormat;
			textRenderer.disabledElementFormat = this.disabledElementFormat;
		}

	//-------------------------
	// Label
	//-------------------------

		protected function setLabelStyles(label:Label):void
		{
			label.textRendererProperties.elementFormat = this.lightElementFormat;
			label.textRendererProperties.disabledElementFormat = this.disabledElementFormat;
		}

		protected function setHeadingLabelStyles(label:Label):void
		{
			label.textRendererProperties.elementFormat = this.largeLightElementFormat;
			label.textRendererProperties.disabledElementFormat = this.largeDisabledElementFormat;
		}

		protected function setDetailLabelStyles(label:Label):void
		{
			label.textRendererProperties.elementFormat = this.smallLightElementFormat;
			label.textRendererProperties.disabledElementFormat = this.smallDisabledElementFormat;
		}
		
		protected function setToolTipLabelStyles(label:Label):void
		{
			var backgroundSkin:Image = new Image(this.backgroundSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE9_GRID;
			label.backgroundSkin = backgroundSkin;
			
			label.textRendererProperties.elementFormat = this.lightElementFormat;
			label.textRendererProperties.disabledElementFormat = this.disabledElementFormat;
			
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
				layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
				group.layout = layout;
			}

			var backgroundSkin:TiledImage = new TiledImage(this.headerBackgroundSkinTexture);
			backgroundSkin.width = this.gridSize;
			backgroundSkin.height = this.gridSize;
			group.backgroundSkin = backgroundSkin;

			group.minWidth = this.gridSize;
			group.minHeight = this.gridSize;
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
			list.backgroundSkin = backgroundSkin;
			
			var backgroundDisabledSkin:Image = new Image(this.backgroundDisabledSkinTexture);
			backgroundDisabledSkin.scale9Grid = DEFAULT_SCALE9_GRID;
			list.backgroundDisabledSkin = backgroundDisabledSkin;

			list.verticalScrollPolicy = List.SCROLL_POLICY_AUTO;
		}

		protected function setItemRendererStyles(renderer:BaseDefaultItemRenderer):void
		{
			var skin:ImageSkin = new ImageSkin(this.itemRendererUpSkinTexture);
			skin.selectedTexture = this.itemRendererSelectedUpSkinTexture;
			skin.setTextureForState(ButtonState.HOVER, this.itemRendererHoverSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.itemRendererSelectedUpSkinTexture);
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			renderer.defaultSkin = skin;

			renderer.horizontalAlign = BaseDefaultItemRenderer.HORIZONTAL_ALIGN_LEFT;
			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;
			renderer.paddingRight = this.gutterSize;
			renderer.gap = this.smallGutterSize;
			renderer.minGap = this.smallGutterSize;
			renderer.iconPosition = BaseDefaultItemRenderer.ICON_POSITION_LEFT;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.minAccessoryGap = this.smallGutterSize;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
			renderer.minWidth = this.controlSize;
			renderer.minHeight = this.controlSize;

			renderer.useStateDelayTimer = false;
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
			itemRenderer.defaultSkin = new Image(this.itemRendererUpSkinTexture);

			itemRenderer.itemHasIcon = false;

			var icon:ImageSkin = new ImageSkin(this.checkUpIconTexture);
			icon.selectedTexture = this.checkSelectedUpIconTexture;
			icon.setTextureForState(ButtonState.DOWN, this.checkDownIconTexture);
			icon.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.checkSelectedDownIconTexture);
			itemRenderer.defaultIcon = icon;
			
			itemRenderer.customLabelStyleName = THEME_STYLE_NAME_CHECK_ITEM_RENDERER_LABEL;
			itemRenderer.customIconLabelStyleName = THEME_STYLE_NAME_CHECK_ITEM_RENDERER_ICON_LABEL;
			itemRenderer.customAccessoryLabelStyleName = THEME_STYLE_NAME_CHECK_ITEM_RENDERER_ACCESSORY_LABEL;

			itemRenderer.horizontalAlign = BaseDefaultItemRenderer.HORIZONTAL_ALIGN_LEFT;
			itemRenderer.paddingTop = this.smallGutterSize;
			itemRenderer.paddingBottom = this.smallGutterSize;
			itemRenderer.paddingLeft = this.gutterSize;
			itemRenderer.paddingRight = this.gutterSize;
			itemRenderer.gap = this.smallGutterSize;
			itemRenderer.minGap = this.smallGutterSize;
			itemRenderer.iconPosition = BaseDefaultItemRenderer.ICON_POSITION_LEFT;
			itemRenderer.accessoryGap = Number.POSITIVE_INFINITY;
			itemRenderer.minAccessoryGap = this.smallGutterSize;
			itemRenderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
			itemRenderer.minWidth = this.controlSize;
			itemRenderer.minHeight = this.controlSize;

			itemRenderer.useStateDelayTimer = false;
		}

		protected function setItemRendererLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightElementFormat;
			textRenderer.disabledElementFormat = this.disabledElementFormat;
			textRenderer.selectedElementFormat = this.darkElementFormat;
			textRenderer.setElementFormatForState(BaseDefaultItemRenderer.STATE_DOWN, this.darkElementFormat);
			textRenderer.setElementFormatForState(BaseDefaultItemRenderer.STATE_HOVER, this.darkElementFormat);
		}

		protected function setItemRendererIconLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightElementFormat;
			textRenderer.disabledElementFormat = this.disabledElementFormat;
			textRenderer.selectedElementFormat = this.darkElementFormat;
			textRenderer.setElementFormatForState(BaseDefaultItemRenderer.STATE_DOWN, this.darkElementFormat);
			textRenderer.setElementFormatForState(BaseDefaultItemRenderer.STATE_HOVER, this.darkElementFormat);
		}

		protected function setItemRendererAccessoryLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightElementFormat;
			textRenderer.disabledElementFormat = this.disabledElementFormat;
			textRenderer.selectedElementFormat = this.darkElementFormat;
			textRenderer.setElementFormatForState(BaseDefaultItemRenderer.STATE_DOWN, this.darkElementFormat);
			textRenderer.setElementFormatForState(BaseDefaultItemRenderer.STATE_HOVER, this.darkElementFormat);
		}

		protected function setCheckItemRendererLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightElementFormat;
			textRenderer.disabledElementFormat = this.disabledElementFormat;
		}

		protected function setCheckItemRendererIconLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightElementFormat;
			textRenderer.disabledElementFormat = this.disabledElementFormat;
		}

		protected function setCheckItemRendererAccessoryLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightElementFormat;
			textRenderer.disabledElementFormat = this.disabledElementFormat;
		}

	//-------------------------
	// NumericStepper
	//-------------------------

		protected function setNumericStepperStyles(stepper:NumericStepper):void
		{
			stepper.buttonLayoutMode = NumericStepper.BUTTON_LAYOUT_MODE_RIGHT_SIDE_VERTICAL;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			stepper.focusIndicatorSkin = focusIndicatorSkin;
			stepper.focusPadding = this.focusPaddingSize;
		}

		protected function setNumericStepperTextInputStyles(input:TextInput):void
		{
			var skin:ImageSkin = new ImageSkin(this.backgroundSkinTexture);
			skin.setTextureForState(TextInput.STATE_DISABLED, this.backgroundDisabledSkinTexture);
			skin.setTextureForState(TextInput.STATE_FOCUSED, this.backgroundFocusedSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE9_GRID;
			skin.width = this.gridSize;
			skin.height = this.controlSize;
			input.backgroundSkin = skin;
			
			input.customTextEditorStyleName = THEME_STYLE_NAME_NUMERIC_STEPPER_TEXT_INPUT_TEXT_EDITOR;

			input.minWidth = this.gridSize;
			input.minHeight = this.controlSize;
			input.gap = this.smallGutterSize;
			input.paddingTop = this.smallGutterSize;
			input.paddingBottom = this.smallGutterSize;
			input.paddingLeft = this.gutterSize;
			input.paddingRight = this.gutterSize;
		}
		
		protected function setNumericStepperTextInputTextEditorStyles(textEditor:TextBlockTextEditor):void
		{
			textEditor.cursorSkin = new Quad(1, 1, LIGHT_TEXT_COLOR);
			textEditor.selectionSkin = new Quad(1, 1, TEXT_SELECTION_BACKGROUND_COLOR);
			textEditor.elementFormat = this.lightUIElementFormat;
			textEditor.disabledElementFormat = this.lightUIDisabledElementFormat;
			textEditor.textAlign = TextBlockTextEditor.TEXT_ALIGN_CENTER;
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
			pageIndicator.interactionMode = PageIndicator.INTERACTION_MODE_PRECISE;

			pageIndicator.normalSymbolFactory = this.pageIndicatorNormalSymbolFactory;
			pageIndicator.selectedSymbolFactory = this.pageIndicatorSelectedSymbolFactory;

			pageIndicator.gap = this.gutterSize;
			pageIndicator.padding = this.smallGutterSize;
			pageIndicator.minWidth = this.controlSize;
			pageIndicator.minHeight = this.controlSize;
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
			header.customTitleStyleName = THEME_STYLE_NAME_POP_UP_HEADER_TITLE;
			
			header.minWidth = this.gridSize;
			header.minHeight = this.gridSize;
			header.paddingTop = this.smallGutterSize;
			header.paddingBottom = this.smallGutterSize;
			header.paddingRight = this.gutterSize;
			header.paddingLeft = this.gutterSize;
			header.gap = this.smallGutterSize;
			header.titleGap = this.smallGutterSize;

			var backgroundSkin:TiledImage = new TiledImage(this.headerPopupBackgroundSkinTexture);
			backgroundSkin.width = backgroundSkin.height = this.controlSize;
			header.backgroundSkin = backgroundSkin;
		}

		protected function setPopupHeaderTitleStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightElementFormat;
			textRenderer.disabledElementFormat = this.disabledElementFormat;
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
			skin.width = this.controlSize;
			skin.height = this.controlSize;
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

			this.setBaseButtonStyles(button);

			button.gap = Number.POSITIVE_INFINITY; //fill as completely as possible
			button.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			button.iconPosition = Button.ICON_POSITION_RIGHT;
			button.minWidth = this.buttonMinWidth;
			button.minHeight = this.controlSize;
		}

	//-------------------------
	// ProgressBar
	//-------------------------

		protected function setProgressBarStyles(progress:ProgressBar):void
		{
			var backgroundSkin:Image = new Image(this.backgroundSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE9_GRID;
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

			var backgroundDisabledSkin:Image = new Image(this.backgroundDisabledSkinTexture);
			backgroundDisabledSkin.scale9Grid = DEFAULT_SCALE9_GRID;
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

			var fillSkin:Image = new Image(this.buttonUpSkinTexture);
			fillSkin.scale9Grid = BUTTON_SCALE9_GRID;
			if(progress.direction == ProgressBar.DIRECTION_VERTICAL)
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
			if(progress.direction == ProgressBar.DIRECTION_VERTICAL)
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

			radio.horizontalAlign = Radio.HORIZONTAL_ALIGN_LEFT;
			radio.gap = this.smallGutterSize;
			radio.minWidth = this.controlSize;
			radio.minHeight = this.controlSize;
		}

		protected function setRadioLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightUIElementFormat;
			textRenderer.disabledElementFormat = this.lightUIDisabledElementFormat;
		}

	//-------------------------
	// ScrollBar
	//-------------------------

		protected function setHorizontalScrollBarStyles(scrollBar:ScrollBar):void
		{
			scrollBar.direction = ScrollBar.DIRECTION_HORIZONTAL;
			scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;

			scrollBar.customIncrementButtonStyleName = THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON;
			scrollBar.customDecrementButtonStyleName = THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON;
			scrollBar.customThumbStyleName = THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_THUMB;
			scrollBar.customMinimumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_MINIMUM_TRACK;
		}

		protected function setVerticalScrollBarStyles(scrollBar:ScrollBar):void
		{
			scrollBar.direction = ScrollBar.DIRECTION_VERTICAL;
			scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_MIN_MAX;

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
			container.minWidth = this.gridSize;
			container.minHeight = this.gridSize;

			var backgroundSkin:TiledImage = new TiledImage(this.headerBackgroundSkinTexture);
			backgroundSkin.width = backgroundSkin.height = this.gridSize;
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
		}

	//-------------------------
	// SimpleScrollBar
	//-------------------------

		protected function setSimpleScrollBarStyles(scrollBar:SimpleScrollBar):void
		{
			if(scrollBar.direction == SimpleScrollBar.DIRECTION_HORIZONTAL)
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
			slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_MIN_MAX;
			if(slider.direction == Slider.DIRECTION_VERTICAL)
			{
				slider.customMinimumTrackStyleName = THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK;
				slider.customMaximumTrackStyleName = THEME_STYLE_NAME_VERTICAL_SLIDER_MAXIMUM_TRACK;
				slider.minHeight = this.controlSize;
			}
			else //horizontal
			{
				slider.customMinimumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK;
				slider.customMaximumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_SLIDER_MAXIMUM_TRACK;
				slider.minWidth = this.controlSize;
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
			thumb.defaultSkin = skin;

			thumb.minWidth = this.smallControlSize;
			thumb.minHeight = this.smallControlSize;

			thumb.hasLabelTextRenderer = false;
		}

		protected function setHorizontalSliderMinimumTrackStyles(track:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.backgroundSkinTexture);
			skin.disabledTexture = this.backgroundDisabledSkinTexture;
			skin.scale9Grid = DEFAULT_SCALE9_GRID;
			skin.width = this.wideControlSize;
			skin.height = this.smallControlSize;
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
			track.defaultSkin = skin;

			track.hasLabelTextRenderer = false;
		}

	//-------------------------
	// TabBar
	//-------------------------

		protected function setTabBarStyles(tabBar:TabBar):void
		{
			tabBar.distributeTabSizes = false;
			tabBar.horizontalAlign = TabBar.HORIZONTAL_ALIGN_LEFT;
			tabBar.verticalAlign = TabBar.VERTICAL_ALIGN_JUSTIFY;
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
			tab.defaultSkin = skin;
			
			tab.customLabelStyleName = THEME_STYLE_NAME_TAB_LABEL;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			tab.focusIndicatorSkin = focusIndicatorSkin;
			tab.focusPadding = this.focusPaddingSize;

			tab.paddingTop = this.smallGutterSize;
			tab.paddingBottom = this.smallGutterSize;
			tab.paddingLeft = this.gutterSize;
			tab.paddingRight = this.gutterSize;
			tab.gap = this.smallGutterSize;
			tab.minWidth = this.controlSize;
			tab.minHeight = this.controlSize;
		}

		protected function setTabLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightUIElementFormat;
			textRenderer.selectedElementFormat = this.darkUIElementFormat;
			textRenderer.setElementFormatForState(ToggleButton.STATE_DOWN, this.darkUIElementFormat);
			textRenderer.setElementFormatForState(ToggleButton.STATE_DISABLED, this.lightUIDisabledElementFormat);
			textRenderer.setElementFormatForState(ToggleButton.STATE_DISABLED_AND_SELECTED, this.darkUIDisabledElementFormat);
		}

	//-------------------------
	// TextArea
	//-------------------------

		protected function setTextAreaStyles(textArea:TextArea):void
		{
			this.setScrollerStyles(textArea);

			var skin:ImageSkin = new ImageSkin(this.backgroundSkinTexture);
			skin.setTextureForState(TextArea.STATE_DISABLED, this.backgroundDisabledSkinTexture);
			skin.setTextureForState(TextArea.STATE_FOCUSED, this.backgroundFocusedSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE9_GRID;
			skin.width = this.wideControlSize * 2;
			skin.height = this.wideControlSize;
			textArea.backgroundSkin = skin;

			textArea.padding = this.borderSize;
		}

		protected function setTextAreaTextEditorStyles(textEditor:TextFieldTextEditorViewPort):void
		{
			textEditor.textFormat = this.scrollTextTextFormat;
			textEditor.disabledTextFormat = this.scrollTextDisabledTextFormat;
			textEditor.paddingTop = this.extraSmallGutterSize;
			textEditor.paddingRight = this.smallGutterSize;
			textEditor.paddingBottom = this.extraSmallGutterSize;
			textEditor.paddingLeft = this.smallGutterSize;
		}

	//-------------------------
	// TextInput
	//-------------------------

		protected function setBaseTextInputStyles(input:TextInput):void
		{
			var skin:ImageSkin = new ImageSkin(this.backgroundSkinTexture);
			skin.setTextureForState(TextInput.STATE_DISABLED, this.backgroundDisabledSkinTexture);
			skin.setTextureForState(TextInput.STATE_FOCUSED, this.backgroundFocusedSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE9_GRID;
			skin.width = this.wideControlSize;
			skin.height = this.controlSize;
			input.backgroundSkin = skin;

			input.minWidth = this.controlSize;
			input.minHeight = this.controlSize;
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
			textEditor.elementFormat = this.lightElementFormat;
			textEditor.disabledElementFormat = this.disabledElementFormat;
		}

		protected function setTextInputPromptStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightElementFormat;
			textRenderer.disabledElementFormat = this.disabledElementFormat;
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
			toggle.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			toggle.focusIndicatorSkin = focusIndicatorSkin;
			toggle.focusPadding = this.focusPaddingSize;
		}

		protected function setToggleSwitchOnLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.selectedUIElementFormat;
			textRenderer.disabledElementFormat = this.lightUIDisabledElementFormat;
		}

		protected function setToggleSwitchOffLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightUIElementFormat;
			textRenderer.disabledElementFormat = this.lightUIDisabledElementFormat;
		}

		protected function setToggleSwitchThumbStyles(thumb:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			thumb.defaultSkin = skin;

			thumb.minWidth = this.controlSize;
			thumb.minHeight = this.controlSize;

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
			var icon:ImageSkin = new ImageSkin(this.playPauseButtonPlayUpIconTexture);
			icon.selectedTexture = this.playPauseButtonPauseUpIconTexture;
			icon.setTextureForState(ButtonState.DOWN, this.playPauseButtonPlayDownIconTexture);
			icon.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.playPauseButtonPauseDownIconTexture);
			button.defaultIcon = icon;

			button.hasLabelTextRenderer = false;

			button.minWidth = this.controlSize;
			button.minHeight = this.controlSize;
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
			var icon:ImageSkin = new ImageSkin(this.fullScreenToggleButtonEnterUpIconTexture);
			icon.selectedTexture = this.fullScreenToggleButtonExitUpIconTexture;
			icon.setTextureForState(ButtonState.DOWN, this.fullScreenToggleButtonEnterDownIconTexture);
			icon.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.fullScreenToggleButtonExitDownIconTexture);
			button.defaultIcon = icon;

			button.hasLabelTextRenderer = false;

			button.minWidth = this.controlSize;
			button.minHeight = this.controlSize;
		}

	//-------------------------
	// VolumeSlider
	//-------------------------

		protected function setVolumeSliderStyles(slider:VolumeSlider):void
		{
			slider.direction = VolumeSlider.DIRECTION_HORIZONTAL;
			slider.trackLayoutMode = VolumeSlider.TRACK_LAYOUT_MODE_MIN_MAX;
			
			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
			slider.focusIndicatorSkin = focusIndicatorSkin;
			slider.focusPadding = this.focusPaddingSize;
			
			slider.showThumb = false;
			slider.minWidth = this.volumeSliderMinimumTrackSkinTexture.width;
			slider.minHeight = this.volumeSliderMinimumTrackSkinTexture.height;
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
			defaultSkin.horizontalAlign = ImageLoader.HORIZONTAL_ALIGN_RIGHT;
			defaultSkin.source = this.volumeSliderMaximumTrackSkinTexture;
			track.defaultSkin = defaultSkin;
			track.hasLabelTextRenderer = false;
		}

	//-------------------------
	// MuteToggleButton
	//-------------------------

		protected function setMuteToggleButtonStyles(button:MuteToggleButton):void
		{
			var icon:ImageSkin = new ImageSkin(this.muteToggleButtonLoudUpIconTexture);
			icon.selectedTexture = this.muteToggleButtonMutedUpIconTexture;
			icon.setTextureForState(ButtonState.DOWN, this.muteToggleButtonLoudDownIconTexture);
			icon.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.muteToggleButtonMutedDownIconTexture);
			button.defaultIcon = icon;

			button.showVolumeSliderOnHover = true;
			button.hasLabelTextRenderer = false;

			button.minWidth = this.controlSize;
			button.minHeight = this.controlSize;
		}

		protected function setPopUpVolumeSliderStyles(slider:VolumeSlider):void
		{
			slider.direction = VolumeSlider.DIRECTION_VERTICAL;
			slider.trackLayoutMode = VolumeSlider.TRACK_LAYOUT_MODE_SINGLE;
			
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
			slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_MIN_MAX;
			slider.showThumb = false;
			if(slider.direction == SeekSlider.DIRECTION_VERTICAL)
			{
				slider.minWidth = this.smallControlSize;
				slider.minHeight = this.wideControlSize;
			}
			else //horizontal
			{
				slider.minWidth = this.wideControlSize;
				slider.minHeight = this.smallControlSize;
			}
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
			var defaultSkin:Image = new Image(this.buttonUpSkinTexture);
			defaultSkin.scale9Grid = BUTTON_SCALE9_GRID;
			defaultSkin.width = this.wideControlSize;
			defaultSkin.height = this.smallControlSize;
			track.defaultSkin = defaultSkin;
			track.hasLabelTextRenderer = false;
		}

		protected function setSeekSliderMaximumTrackStyles(track:Button):void
		{
			var defaultSkin:Image = new Image(this.backgroundSkinTexture);
			defaultSkin.scale9Grid = DEFAULT_SCALE9_GRID;
			defaultSkin.width = this.wideControlSize;
			defaultSkin.height = this.smallControlSize;
			track.defaultSkin = defaultSkin;
			track.hasLabelTextRenderer = false;
		}

	}
}
