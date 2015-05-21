/*
 Copyright 2012-2015 Joshua Tynjala

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
	import feathers.controls.ScrollBar;
	import feathers.controls.ScrollContainer;
	import feathers.controls.ScrollScreen;
	import feathers.controls.ScrollText;
	import feathers.controls.Scroller;
	import feathers.controls.SimpleScrollBar;
	import feathers.controls.Slider;
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
	import feathers.core.FeathersControl;
	import feathers.core.FocusManager;
	import feathers.core.PopUpManager;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.media.FullScreenToggleButton;
	import feathers.media.MuteToggleButton;
	import feathers.media.PlayPauseToggleButton;
	import feathers.media.SeekSlider;
	import feathers.media.VideoPlayer;
	import feathers.media.VolumeSlider;
	import feathers.skins.SmartDisplayObjectStateValueSelector;
	import feathers.skins.StandardIcons;
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
		protected static const BACK_BUTTON_SCALE3_REGION1:Number = 13;
		protected static const BACK_BUTTON_SCALE3_REGION2:Number = 1;
		protected static const FORWARD_BUTTON_SCALE3_REGION1:Number = 3;
		protected static const FORWARD_BUTTON_SCALE3_REGION2:Number = 1;
		protected static const FOCUS_INDICATOR_SCALE_9_GRID:Rectangle = new Rectangle(5, 5, 1, 1);
		protected static const TAB_SCALE9_GRID:Rectangle = new Rectangle(7, 7, 1, 11);
		protected static const SCROLL_BAR_THUMB_REGION1:int = 5;
		protected static const SCROLL_BAR_THUMB_REGION2:int = 14;
		
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
		 * SmartDisplayObjectValueSelectors will use ImageLoader instead of
		 * Image so that we can use extra features like pixel snapping.
		 */
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

		/**
		 * Constructor.
		 */
		public function BaseMetalWorksDesktopTheme()
		{
		}

		/**
		 * Skins are scaled by a value based on the content scale factor.
		 */
		protected var scale:Number = 1;

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

		protected var focusIndicatorSkinTextures:Scale9Textures;
		protected var headerBackgroundSkinTexture:Texture;
		protected var headerPopupBackgroundSkinTexture:Texture;
		protected var backgroundSkinTextures:Scale9Textures;
		protected var backgroundDisabledSkinTextures:Scale9Textures;
		protected var backgroundFocusedSkinTextures:Scale9Textures;
		protected var listBackgroundSkinTextures:Scale9Textures;
		protected var buttonUpSkinTextures:Scale9Textures;
		protected var buttonDownSkinTextures:Scale9Textures;
		protected var buttonDisabledSkinTextures:Scale9Textures;
		protected var toggleButtonSelectedUpSkinTextures:Scale9Textures;
		protected var toggleButtonSelectedDisabledSkinTextures:Scale9Textures;
		protected var buttonQuietHoverSkinTextures:Scale9Textures;
		protected var buttonCallToActionUpSkinTextures:Scale9Textures;
		protected var buttonCallToActionDownSkinTextures:Scale9Textures;
		protected var buttonDangerUpSkinTextures:Scale9Textures;
		protected var buttonDangerDownSkinTextures:Scale9Textures;
		protected var buttonBackUpSkinTextures:Scale3Textures;
		protected var buttonBackDownSkinTextures:Scale3Textures;
		protected var buttonBackDisabledSkinTextures:Scale3Textures;
		protected var buttonForwardUpSkinTextures:Scale3Textures;
		protected var buttonForwardDownSkinTextures:Scale3Textures;
		protected var buttonForwardDisabledSkinTextures:Scale3Textures;
		protected var pickerListButtonIconTexture:Texture;
		protected var pickerListButtonIconSelectedTexture:Texture;
		protected var pickerListButtonIconDisabledTexture:Texture;
		protected var tabUpSkinTextures:Scale9Textures;
		protected var tabDownSkinTextures:Scale9Textures;
		protected var tabDisabledSkinTextures:Scale9Textures;
		protected var tabSelectedSkinTextures:Scale9Textures;
		protected var tabSelectedDisabledSkinTextures:Scale9Textures;
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
		protected var backgroundPopUpSkinTextures:Scale9Textures;
		protected var calloutTopArrowSkinTexture:Texture;
		protected var calloutRightArrowSkinTexture:Texture;
		protected var calloutBottomArrowSkinTexture:Texture;
		protected var calloutLeftArrowSkinTexture:Texture;
		protected var horizontalSimpleScrollBarThumbSkinTextures:Scale3Textures;
		protected var horizontalScrollBarDecrementButtonIconTexture:Texture;
		protected var horizontalScrollBarDecrementButtonDisabledIconTexture:Texture;
		protected var horizontalScrollBarDecrementButtonUpSkinTextures:Scale9Textures;
		protected var horizontalScrollBarDecrementButtonDownSkinTextures:Scale9Textures;
		protected var horizontalScrollBarDecrementButtonDisabledSkinTextures:Scale9Textures;
		protected var horizontalScrollBarIncrementButtonIconTexture:Texture;
		protected var horizontalScrollBarIncrementButtonDisabledIconTexture:Texture;
		protected var horizontalScrollBarIncrementButtonUpSkinTextures:Scale9Textures;
		protected var horizontalScrollBarIncrementButtonDownSkinTextures:Scale9Textures;
		protected var horizontalScrollBarIncrementButtonDisabledSkinTextures:Scale9Textures;
		protected var verticalSimpleScrollBarThumbSkinTextures:Scale3Textures;
		protected var verticalScrollBarDecrementButtonIconTexture:Texture;
		protected var verticalScrollBarDecrementButtonDisabledIconTexture:Texture;
		protected var verticalScrollBarDecrementButtonUpSkinTextures:Scale9Textures;
		protected var verticalScrollBarDecrementButtonDownSkinTextures:Scale9Textures;
		protected var verticalScrollBarDecrementButtonDisabledSkinTextures:Scale9Textures;
		protected var verticalScrollBarIncrementButtonIconTexture:Texture;
		protected var verticalScrollBarIncrementButtonDisabledIconTexture:Texture;
		protected var verticalScrollBarIncrementButtonUpSkinTextures:Scale9Textures;
		protected var verticalScrollBarIncrementButtonDownSkinTextures:Scale9Textures;
		protected var verticalScrollBarIncrementButtonDisabledSkinTextures:Scale9Textures;
		protected var searchIconTexture:Texture;
		protected var searchIconDisabledTexture:Texture;

		//media textures
		protected var playPauseButtonPlayUpIconTexture:Texture;
		protected var playPauseButtonPlayDownIconTexture:Texture;
		protected var playPauseButtonPauseUpIconTexture:Texture;
		protected var playPauseButtonPauseDownIconTexture:Texture;
		protected var largePlayPauseButtonPlayUpIconTexture:Texture;
		protected var largePlayPauseButtonPlayDownIconTexture:Texture;
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
		protected var popUpVolumeSliderTrackSkinTextures:Scale9Textures;

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
			this.initializeScale();
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

			FocusManager.setEnabledForStage(Starling.current.stage, true);
		}

		/**
		 * Initializes the value used for scaling things like textures and font
		 * sizes.
		 */
		protected function initializeScale():void
		{
			//Starling automatically accounts for the contentScaleFactor on Mac
			//HiDPI screens, and converts pixels to points, so we don't need to
			//do any scaling for that.
			this.scale = 1;
		}

		/**
		 * Initializes common values used for setting the dimensions of components.
		 */
		protected function initializeDimensions():void
		{
			this.gridSize = Math.round(30 * this.scale);
			this.extraSmallGutterSize = Math.round(2 * this.scale);
			this.smallGutterSize = Math.round(4 * this.scale);
			this.gutterSize = Math.round(8 * this.scale);
			this.borderSize = Math.max(1, Math.round(1 * this.scale));
			this.controlSize = Math.round(22 * this.scale);
			this.smallControlSize = Math.round(12 * this.scale);
			this.calloutBackgroundMinSize = Math.round(5 * this.scale);
			this.progressBarFillMinSize = Math.round(7 * this.scale);
			this.scrollBarGutterSize = Math.round(4 * this.scale);
			this.calloutArrowOverlapGap = Math.min(-2, Math.round(-2 * this.scale));
			this.focusPaddingSize = Math.min(-1, Math.round(-2 * this.scale));
			this.buttonMinWidth = this.gridSize * 2 + this.gutterSize;
			this.wideControlSize = this.gridSize * 4 + this.gutterSize * 3;
			this.popUpSize = this.gridSize * 10 + this.smallGutterSize * 9;
			this.popUpVolumeSliderPaddingSize = Math.round(10 * this.scale);
		}

		/**
		 * Initializes font sizes and formats.
		 */
		protected function initializeFonts():void
		{
			this.smallFontSize = Math.round(11 * this.scale);
			this.regularFontSize = Math.round(14 * this.scale);
			this.largeFontSize = Math.round(18 * this.scale);

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
			var backgroundSkinTexture:Texture = this.atlas.getTexture("background-skin0000");
			var backgroundDisabledSkinTexture:Texture = this.atlas.getTexture("background-disabled-skin0000");
			var backgroundFocusedSkinTexture:Texture = this.atlas.getTexture("background-focused-skin0000");
			var backgroundPopUpSkinTexture:Texture = this.atlas.getTexture("background-popup-skin0000");

			var checkUpIconTexture:Texture = this.atlas.getTexture("check-up-icon0000");
			var checkDownIconTexture:Texture = this.atlas.getTexture("check-down-icon0000");
			var checkDisabledIconTexture:Texture = this.atlas.getTexture("check-disabled-icon0000");

			this.focusIndicatorSkinTextures = new Scale9Textures(this.atlas.getTexture("focus-indicator-skin0000"), FOCUS_INDICATOR_SCALE_9_GRID);

			this.backgroundSkinTextures = new Scale9Textures(backgroundSkinTexture, DEFAULT_SCALE9_GRID);
			this.backgroundDisabledSkinTextures = new Scale9Textures(backgroundDisabledSkinTexture, DEFAULT_SCALE9_GRID);
			this.backgroundFocusedSkinTextures = new Scale9Textures(backgroundFocusedSkinTexture, DEFAULT_SCALE9_GRID);
			this.backgroundPopUpSkinTextures = new Scale9Textures(backgroundPopUpSkinTexture, SIMPLE_SCALE9_GRID);
			this.listBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("list-background-skin0000"), DEFAULT_SCALE9_GRID);

			this.buttonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-up-skin0000"), BUTTON_SCALE9_GRID);
			this.buttonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("button-down-skin0000"), BUTTON_SCALE9_GRID);
			this.buttonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("button-disabled-skin0000"), BUTTON_SCALE9_GRID);
			this.toggleButtonSelectedUpSkinTextures = new Scale9Textures(this.atlas.getTexture("toggle-button-selected-up-skin0000"), TOGGLE_BUTTON_SCALE9_GRID);
			this.toggleButtonSelectedDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("toggle-button-selected-disabled-skin0000"), TOGGLE_BUTTON_SCALE9_GRID);
			this.buttonQuietHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("quiet-button-hover-skin0000"), BUTTON_SCALE9_GRID);
			this.buttonCallToActionUpSkinTextures = new Scale9Textures(this.atlas.getTexture("call-to-action-button-up-skin0000"), BUTTON_SCALE9_GRID);
			this.buttonCallToActionDownSkinTextures = new Scale9Textures(this.atlas.getTexture("call-to-action-button-down-skin0000"), BUTTON_SCALE9_GRID);
			this.buttonDangerUpSkinTextures = new Scale9Textures(this.atlas.getTexture("danger-button-up-skin0000"), BUTTON_SCALE9_GRID);
			this.buttonDangerDownSkinTextures = new Scale9Textures(this.atlas.getTexture("danger-button-down-skin0000"), BUTTON_SCALE9_GRID);
			this.buttonBackUpSkinTextures = new Scale3Textures(this.atlas.getTexture("back-button-up-skin0000"), BACK_BUTTON_SCALE3_REGION1, BACK_BUTTON_SCALE3_REGION2);
			this.buttonBackDownSkinTextures = new Scale3Textures(this.atlas.getTexture("back-button-down-skin0000"), BACK_BUTTON_SCALE3_REGION1, BACK_BUTTON_SCALE3_REGION2);
			this.buttonBackDisabledSkinTextures = new Scale3Textures(this.atlas.getTexture("back-button-disabled-skin0000"), BACK_BUTTON_SCALE3_REGION1, BACK_BUTTON_SCALE3_REGION2);
			this.buttonForwardUpSkinTextures = new Scale3Textures(this.atlas.getTexture("forward-button-up-skin0000"), FORWARD_BUTTON_SCALE3_REGION1, FORWARD_BUTTON_SCALE3_REGION2);
			this.buttonForwardDownSkinTextures = new Scale3Textures(this.atlas.getTexture("forward-button-down-skin0000"), FORWARD_BUTTON_SCALE3_REGION1, FORWARD_BUTTON_SCALE3_REGION2);
			this.buttonForwardDisabledSkinTextures = new Scale3Textures(this.atlas.getTexture("forward-button-disabled-skin0000"), FORWARD_BUTTON_SCALE3_REGION1, FORWARD_BUTTON_SCALE3_REGION2);

			this.tabUpSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-up-skin0000"), TAB_SCALE9_GRID);
			this.tabDownSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-down-skin0000"), TAB_SCALE9_GRID);
			this.tabDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-disabled-skin0000"), TAB_SCALE9_GRID);
			this.tabSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-up-skin0000"), TAB_SCALE9_GRID);
			this.tabSelectedDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-disabled-skin0000"), TAB_SCALE9_GRID);

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

			this.horizontalSimpleScrollBarThumbSkinTextures = new Scale3Textures(this.atlas.getTexture("horizontal-simple-scroll-bar-thumb-skin0000"), SCROLL_BAR_THUMB_REGION1, SCROLL_BAR_THUMB_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
			this.horizontalScrollBarDecrementButtonIconTexture = this.atlas.getTexture("horizontal-scroll-bar-decrement-button-icon0000");
			this.horizontalScrollBarDecrementButtonDisabledIconTexture = this.atlas.getTexture("horizontal-scroll-bar-decrement-button-disabled-icon0000");
			this.horizontalScrollBarDecrementButtonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-decrement-button-up-skin0000"), SCROLL_BAR_STEP_BUTTON_SCALE9_GRID);
			this.horizontalScrollBarDecrementButtonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-decrement-button-down-skin0000"), SCROLL_BAR_STEP_BUTTON_SCALE9_GRID);
			this.horizontalScrollBarDecrementButtonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-decrement-button-disabled-skin0000"), SCROLL_BAR_STEP_BUTTON_SCALE9_GRID);
			this.horizontalScrollBarIncrementButtonIconTexture = this.atlas.getTexture("horizontal-scroll-bar-increment-button-icon0000");
			this.horizontalScrollBarIncrementButtonDisabledIconTexture = this.atlas.getTexture("horizontal-scroll-bar-increment-button-disabled-icon0000");
			this.horizontalScrollBarIncrementButtonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-increment-button-up-skin0000"), SCROLL_BAR_STEP_BUTTON_SCALE9_GRID);
			this.horizontalScrollBarIncrementButtonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-increment-button-down-skin0000"), SCROLL_BAR_STEP_BUTTON_SCALE9_GRID);
			this.horizontalScrollBarIncrementButtonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-increment-button-disabled-skin0000"), SCROLL_BAR_STEP_BUTTON_SCALE9_GRID);

			this.verticalSimpleScrollBarThumbSkinTextures = new Scale3Textures(this.atlas.getTexture("vertical-simple-scroll-bar-thumb-skin0000"), SCROLL_BAR_THUMB_REGION1, SCROLL_BAR_THUMB_REGION2, Scale3Textures.DIRECTION_VERTICAL);
			this.verticalScrollBarDecrementButtonIconTexture = this.atlas.getTexture("vertical-scroll-bar-decrement-button-icon0000");
			this.verticalScrollBarDecrementButtonDisabledIconTexture = this.atlas.getTexture("vertical-scroll-bar-decrement-button-disabled-icon0000");
			this.verticalScrollBarDecrementButtonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-decrement-button-up-skin0000"), SCROLL_BAR_STEP_BUTTON_SCALE9_GRID);
			this.verticalScrollBarDecrementButtonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-decrement-button-down-skin0000"), SCROLL_BAR_STEP_BUTTON_SCALE9_GRID);
			this.verticalScrollBarDecrementButtonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-decrement-button-disabled-skin0000"), SCROLL_BAR_STEP_BUTTON_SCALE9_GRID);
			this.verticalScrollBarIncrementButtonIconTexture = this.atlas.getTexture("vertical-scroll-bar-increment-button-icon0000");
			this.verticalScrollBarIncrementButtonDisabledIconTexture = this.atlas.getTexture("vertical-scroll-bar-increment-button-disabled-icon0000");
			this.verticalScrollBarIncrementButtonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-increment-button-up-skin0000"), SCROLL_BAR_STEP_BUTTON_SCALE9_GRID);
			this.verticalScrollBarIncrementButtonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-increment-button-down-skin0000"), SCROLL_BAR_STEP_BUTTON_SCALE9_GRID);
			this.verticalScrollBarIncrementButtonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-increment-button-disabled-skin0000"), SCROLL_BAR_STEP_BUTTON_SCALE9_GRID);

			StandardIcons.listDrillDownAccessoryTexture = this.atlas.getTexture("item-renderer-drill-down-accessory-icon0000");

			this.playPauseButtonPlayUpIconTexture = this.atlas.getTexture("play-pause-toggle-button-play-up-icon0000");
			this.playPauseButtonPlayDownIconTexture = this.atlas.getTexture("play-pause-toggle-button-play-down-icon0000");
			this.playPauseButtonPauseUpIconTexture = this.atlas.getTexture("play-pause-toggle-button-pause-up-icon0000");
			this.playPauseButtonPauseDownIconTexture = this.atlas.getTexture("play-pause-toggle-button-pause-down-icon0000");
			this.largePlayPauseButtonPlayUpIconTexture = this.atlas.getTexture("large-play-pause-toggle-button-play-up-icon0000");
			this.largePlayPauseButtonPlayDownIconTexture = this.atlas.getTexture("large-play-pause-toggle-button-play-down-icon0000");
			this.fullScreenToggleButtonEnterUpIconTexture = this.atlas.getTexture("full-screen-toggle-button-enter-up-icon0000");
			this.fullScreenToggleButtonEnterDownIconTexture = this.atlas.getTexture("full-screen-toggle-button-enter-down-icon0000");
			this.fullScreenToggleButtonExitUpIconTexture = this.atlas.getTexture("full-screen-toggle-button-exit-up-icon0000");
			this.fullScreenToggleButtonExitDownIconTexture = this.atlas.getTexture("full-screen-toggle-button-exit-down-icon0000");
			this.muteToggleButtonMutedUpIconTexture = this.atlas.getTexture("mute-toggle-button-muted-up-icon0000");
			this.muteToggleButtonMutedDownIconTexture = this.atlas.getTexture("mute-toggle-button-muted-down-icon0000");
			this.muteToggleButtonLoudUpIconTexture = this.atlas.getTexture("mute-toggle-button-loud-up-icon0000");
			this.muteToggleButtonLoudDownIconTexture = this.atlas.getTexture("mute-toggle-button-loud-down-icon0000");
			this.popUpVolumeSliderTrackSkinTextures = new Scale9Textures(this.atlas.getTexture("pop-up-volume-slider-track-skin0000"), VOLUME_SLIDER_TRACK_SCALE9_GRID);
			this.volumeSliderMinimumTrackSkinTexture = this.atlas.getTexture("volume-slider-minimum-track-skin0000");
			this.volumeSliderMaximumTrackSkinTexture = this.atlas.getTexture("volume-slider-maximum-track-skin0000");
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

			//callout
			this.getStyleProviderForClass(Callout).defaultStyleFunction = this.setCalloutStyles;

			//check
			this.getStyleProviderForClass(Check).defaultStyleFunction = this.setCheckStyles;

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
			this.getStyleProviderForClass(DefaultListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL, this.setItemRendererAccessoryLabelRendererStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_ICON_LABEL, this.setItemRendererIconLabelStyles);

			//labels
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

			//tab bar
			this.getStyleProviderForClass(TabBar).defaultStyleFunction = this.setTabBarStyles;
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(TabBar.DEFAULT_CHILD_STYLE_NAME_TAB, this.setTabStyles);

			//text input
			this.getStyleProviderForClass(TextInput).defaultStyleFunction = this.setTextInputStyles;
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName(TextInput.ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT, this.setSearchTextInputStyles);

			//text area
			this.getStyleProviderForClass(TextArea).defaultStyleFunction = this.setTextAreaStyles;

			//toggle button
			this.getStyleProviderForClass(ToggleButton).defaultStyleFunction = this.setButtonStyles;
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(Button.ALTERNATE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);

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
			this.getStyleProviderForClass(PlayPauseToggleButton).setFunctionForStyleName(PlayPauseToggleButton.ALTERNATE_STYLE_NAME_LARGE_PLAY_PAUSE_TOGGLE_BUTTON, this.setLargePlayPauseToggleButtonStyles);

			//full screen toggle button
			this.getStyleProviderForClass(FullScreenToggleButton).defaultStyleFunction = this.setFullScreenToggleButtonStyles;

			//mute toggle button
			this.getStyleProviderForClass(MuteToggleButton).defaultStyleFunction = this.setMuteToggleButtonStyles;

			//seek slider
			this.getStyleProviderForClass(SeekSlider).defaultStyleFunction = this.setSeekSliderStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(SeekSlider.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setSeekSliderThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(SeekSlider.DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK, this.setSeekSliderMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(SeekSlider.DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK, this.setSeekSliderMaximumTrackStyles);

			//volume slider
			this.getStyleProviderForClass(VolumeSlider).defaultStyleFunction = this.setVolumeSliderStyles;
			this.getStyleProviderForClass(VolumeSlider).setFunctionForStyleName(MuteToggleButton.DEFAULT_CHILD_STYLE_NAME_VOLUME_SLIDER, this.setPopUpVolumeSliderStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(VolumeSlider.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setVolumeSliderThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(VolumeSlider.DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK, this.setVolumeSliderMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(VolumeSlider.DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK, this.setVolumeSliderMaximumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_THUMB, this.setSliderThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MINIMUM_TRACK, this.setPopUpVolumeSliderTrackStyles);
		}

		protected function pageIndicatorNormalSymbolFactory():DisplayObject
		{
			var symbol:ImageLoader = new ImageLoader();
			symbol.source = this.pageIndicatorNormalSkinTexture;
			symbol.textureScale = this.scale;
			return symbol;
		}

		protected function pageIndicatorSelectedSymbolFactory():DisplayObject
		{
			var symbol:ImageLoader = new ImageLoader();
			symbol.source = this.pageIndicatorSelectedSkinTexture;
			symbol.textureScale = this.scale;
			return symbol;
		}

		protected function imageLoaderFactory():ImageLoader
		{
			var image:ImageLoader = new ImageLoader();
			image.textureScale = this.scale;
			return image;
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

			scroller.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
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

			var backgroundSkin:Scale9Image = new Scale9Image(this.backgroundPopUpSkinTextures, this.scale);
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
			button.defaultLabelProperties.elementFormat = this.darkUIElementFormat;
			button.disabledLabelProperties.elementFormat = this.darkUIDisabledElementFormat;
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				ToggleButton(button).selectedDisabledLabelProperties.elementFormat = this.darkUIDisabledElementFormat;
			}

			button.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
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
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				skinSelector.defaultSelectedValue = this.toggleButtonSelectedUpSkinTextures;
				skinSelector.setValueForState(this.toggleButtonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			}
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
			button.minWidth = this.buttonMinWidth;
			button.minHeight = this.controlSize;
		}

		protected function setCallToActionButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonCallToActionUpSkinTextures;
			skinSelector.setValueForState(this.buttonCallToActionDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
			button.minWidth = this.buttonMinWidth;
			button.minHeight = this.controlSize;
		}

		protected function setQuietButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = null;
			skinSelector.setValueForState(this.buttonQuietHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(null, Button.STATE_DISABLED, false);
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				skinSelector.defaultSelectedValue = this.toggleButtonSelectedUpSkinTextures;
				skinSelector.setValueForState(this.toggleButtonSelectedDisabledSkinTextures, Button.STATE_DISABLED, false);
			}
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
			button.focusPadding = this.focusPaddingSize;

			button.defaultLabelProperties.elementFormat = this.lightUIElementFormat;
			button.downLabelProperties.elementFormat = this.darkUIElementFormat;
			button.disabledLabelProperties.elementFormat = this.lightUIDisabledElementFormat;
			if(button is ToggleButton)
			{
				var toggleButton:ToggleButton = ToggleButton(button);
				toggleButton.defaultSelectedLabelProperties.elementFormat = this.darkUIElementFormat;
				toggleButton.selectedDisabledLabelProperties.elementFormat = this.darkUIDisabledElementFormat;
			}

			button.paddingTop = this.smallGutterSize;
			button.paddingBottom = this.smallGutterSize;
			button.paddingLeft = this.gutterSize;
			button.paddingRight = this.gutterSize;
			button.gap = this.smallGutterSize;
			button.minGap = this.smallGutterSize;
			button.minWidth = this.controlSize;
			button.minHeight = this.controlSize;
		}

		protected function setDangerButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonDangerUpSkinTextures;
			skinSelector.setValueForState(this.buttonDangerDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
			button.minWidth = this.buttonMinWidth;
			button.minHeight = this.controlSize;
		}

		protected function setBackButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonBackUpSkinTextures;
			skinSelector.setValueForState(this.buttonBackDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonBackDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
			button.paddingLeft = 2 * this.gutterSize;
			button.minWidth = this.controlSize;
			button.minHeight = this.controlSize;
		}

		protected function setForwardButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonForwardUpSkinTextures;
			skinSelector.setValueForState(this.buttonForwardDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonForwardDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
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
			var backgroundSkin:Scale9Image = new Scale9Image(this.backgroundPopUpSkinTextures, this.scale);
			backgroundSkin.width = this.calloutBackgroundMinSize;
			backgroundSkin.height = this.calloutBackgroundMinSize;
			callout.backgroundSkin = backgroundSkin;

			var topArrowSkin:Image = new Image(this.calloutTopArrowSkinTexture);
			topArrowSkin.scaleX = topArrowSkin.scaleY = this.scale;
			callout.topArrowSkin = topArrowSkin;
			callout.topArrowGap = this.calloutArrowOverlapGap;

			var rightArrowSkin:Image = new Image(this.calloutRightArrowSkinTexture);
			rightArrowSkin.scaleX = rightArrowSkin.scaleY = this.scale;
			callout.rightArrowSkin = rightArrowSkin;
			callout.rightArrowGap = this.calloutArrowOverlapGap;

			var bottomArrowSkin:Image = new Image(this.calloutBottomArrowSkinTexture);
			bottomArrowSkin.scaleX = bottomArrowSkin.scaleY = this.scale;
			callout.bottomArrowSkin = bottomArrowSkin;
			callout.bottomArrowGap = this.calloutArrowOverlapGap;

			var leftArrowSkin:Image = new Image(this.calloutLeftArrowSkinTexture);
			leftArrowSkin.scaleX = leftArrowSkin.scaleY = this.scale;
			callout.leftArrowSkin = leftArrowSkin;
			callout.leftArrowGap = this.calloutArrowOverlapGap;

			callout.padding = this.gutterSize;
		}

	//-------------------------
	// Check
	//-------------------------

		protected function setCheckStyles(check:Check):void
		{
			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.defaultValue = this.checkUpIconTexture;
			iconSelector.defaultSelectedValue = this.checkSelectedUpIconTexture;
			iconSelector.setValueForState(this.checkDownIconTexture, Button.STATE_DOWN, false);
			iconSelector.setValueForState(this.checkDisabledIconTexture, Button.STATE_DISABLED, false);
			iconSelector.setValueForState(this.checkSelectedDownIconTexture, Button.STATE_DOWN, true);
			iconSelector.setValueForState(this.checkSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
			iconSelector.displayObjectProperties =
			{
				scaleX: this.scale,
				scaleY: this.scale
			};
			check.stateToIconFunction = iconSelector.updateValue;

			check.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
			check.focusPaddingLeft = this.focusPaddingSize;
			check.focusPaddingRight = this.focusPaddingSize;

			check.defaultLabelProperties.elementFormat = this.lightUIElementFormat;
			check.disabledLabelProperties.elementFormat = this.lightUIDisabledElementFormat;
			check.selectedDisabledLabelProperties.elementFormat = this.lightUIDisabledElementFormat;

			check.gap = this.smallGutterSize;
			check.minWidth = this.controlSize;
			check.minHeight = this.controlSize;
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
			list.backgroundSkin = new Scale9Image(this.listBackgroundSkinTextures, this.scale);
			list.backgroundDisabledSkin = new Scale9Image(this.backgroundDisabledSkinTextures, this.scale);

			list.verticalScrollPolicy = List.SCROLL_POLICY_AUTO;
		}

		//see List section for item renderer styles

		protected function setGroupedListHeaderRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			renderer.backgroundSkin = new Quad(this.controlSize, this.controlSize, GROUPED_LIST_HEADER_BACKGROUND_COLOR);

			renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_LEFT;
			renderer.contentLabelProperties.elementFormat = this.lightUIElementFormat;
			renderer.contentLabelProperties.disabledElementFormat = this.lightUIDisabledElementFormat;

			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;
			renderer.paddingRight = this.gutterSize;
			renderer.minWidth = this.controlSize;
			renderer.minHeight = this.controlSize;

			renderer.contentLoaderFactory = this.imageLoaderFactory;
		}

		protected function setGroupedListFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			renderer.backgroundSkin = new Quad(this.controlSize, this.controlSize, GROUPED_LIST_FOOTER_BACKGROUND_COLOR);

			renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_CENTER;
			renderer.contentLabelProperties.elementFormat = this.lightElementFormat;
			renderer.contentLabelProperties.disabledElementFormat = this.lightUIDisabledElementFormat;

			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;
			renderer.paddingRight = this.gutterSize;
			renderer.minWidth = renderer.minHeight = this.controlSize;

			renderer.contentLoaderFactory = this.imageLoaderFactory;
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

			var backgroundSkin:TiledImage = new TiledImage(this.headerBackgroundSkinTexture, this.scale);
			backgroundSkin.width = this.controlSize;
			backgroundSkin.height = this.controlSize;
			header.backgroundSkin = backgroundSkin;
			header.titleProperties.elementFormat = this.lightElementFormat;
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

			var backgroundSkin:TiledImage = new TiledImage(this.headerBackgroundSkinTexture, this.scale);
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
			list.backgroundSkin = new Scale9Image(this.listBackgroundSkinTextures, this.scale);
			list.backgroundDisabledSkin = new Scale9Image(this.backgroundDisabledSkinTextures, this.scale);

			list.verticalScrollPolicy = List.SCROLL_POLICY_AUTO;
		}

		protected function setItemRendererStyles(renderer:BaseDefaultItemRenderer):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.itemRendererUpSkinTexture;
			skinSelector.defaultSelectedValue = this.itemRendererSelectedUpSkinTexture;
			skinSelector.setValueForState(this.itemRendererHoverSkinTexture, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.itemRendererSelectedUpSkinTexture, Button.STATE_DOWN, false);
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.controlSize
			};
			renderer.stateToSkinFunction = skinSelector.updateValue;

			renderer.defaultLabelProperties.elementFormat = this.lightElementFormat;
			renderer.hoverLabelProperties.elementFormat = this.darkElementFormat;
			renderer.downLabelProperties.elementFormat = this.darkElementFormat;
			renderer.defaultSelectedLabelProperties.elementFormat = this.darkElementFormat;
			renderer.disabledLabelProperties.elementFormat = this.disabledElementFormat;

			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;
			renderer.paddingRight = this.gutterSize;
			renderer.gap = this.smallGutterSize;
			renderer.minGap = this.smallGutterSize;
			renderer.iconPosition = Button.ICON_POSITION_LEFT;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.minAccessoryGap = this.smallGutterSize;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
			renderer.minWidth = this.controlSize;
			renderer.minHeight = this.controlSize;

			renderer.useStateDelayTimer = false;

			renderer.accessoryLoaderFactory = this.imageLoaderFactory;
			renderer.iconLoaderFactory = this.imageLoaderFactory;
		}

		protected function setItemRendererAccessoryLabelRendererStyles(renderer:TextBlockTextRenderer):void
		{
			renderer.elementFormat = this.lightElementFormat;
		}

		protected function setItemRendererIconLabelStyles(renderer:TextBlockTextRenderer):void
		{
			renderer.elementFormat = this.lightElementFormat;
		}

	//-------------------------
	// NumericStepper
	//-------------------------

		protected function setNumericStepperStyles(stepper:NumericStepper):void
		{
			stepper.buttonLayoutMode = NumericStepper.BUTTON_LAYOUT_MODE_RIGHT_SIDE_VERTICAL;

			stepper.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
			stepper.focusPadding = this.focusPaddingSize;
		}

		protected function setNumericStepperTextInputStyles(input:TextInput):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.backgroundSkinTextures;
			skinSelector.setValueForState(this.backgroundDisabledSkinTextures, TextInput.STATE_DISABLED);
			skinSelector.setValueForState(this.backgroundFocusedSkinTextures, TextInput.STATE_FOCUSED);
			skinSelector.displayObjectProperties =
			{
				width: this.gridSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			input.stateToSkinFunction = skinSelector.updateValue;

			input.minWidth = this.gridSize;
			input.minHeight = this.controlSize;
			input.gap = this.smallGutterSize;
			input.paddingTop = this.smallGutterSize;
			input.paddingBottom = this.smallGutterSize;
			input.paddingLeft = this.gutterSize;
			input.paddingRight = this.gutterSize;

			input.textEditorProperties.cursorSkin = new Quad(1, 1, LIGHT_TEXT_COLOR);
			input.textEditorProperties.selectionSkin = new Quad(1, 1, TEXT_SELECTION_BACKGROUND_COLOR);
			input.textEditorProperties.elementFormat = this.lightUIElementFormat;
			input.textEditorProperties.disabledElementFormat = this.lightUIDisabledElementFormat;
			input.textEditorProperties.textAlign = TextBlockTextEditor.TEXT_ALIGN_CENTER;
		}

		protected function setNumericStepperDecrementButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.verticalScrollBarIncrementButtonUpSkinTextures;
			skinSelector.setValueForState(this.verticalScrollBarIncrementButtonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.verticalScrollBarIncrementButtonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.smallControlSize,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

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
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.verticalScrollBarDecrementButtonUpSkinTextures;
			skinSelector.setValueForState(this.verticalScrollBarDecrementButtonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.verticalScrollBarDecrementButtonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.smallControlSize,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

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

			var backgroundSkin:Scale9Image = new Scale9Image(this.backgroundPopUpSkinTextures, this.scale);
			panel.backgroundSkin = backgroundSkin;
			panel.padding = this.gutterSize;
			panel.outerPadding = this.borderSize;
		}

		protected function setPopupHeaderStyles(header:Header):void
		{
			header.minWidth = this.gridSize;
			header.minHeight = this.gridSize;
			header.paddingTop = this.smallGutterSize;
			header.paddingBottom = this.smallGutterSize;
			header.paddingRight = this.gutterSize;
			header.paddingLeft = this.gutterSize;
			header.gap = this.smallGutterSize;
			header.titleGap = this.smallGutterSize;

			var backgroundSkin:TiledImage = new TiledImage(this.headerPopupBackgroundSkinTexture, this.scale);
			backgroundSkin.width = backgroundSkin.height = this.controlSize;
			header.backgroundSkin = backgroundSkin;
			header.titleProperties.elementFormat = this.lightElementFormat;
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
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
			iconSelector.defaultValue = this.pickerListButtonIconTexture;
			iconSelector.setValueForState(this.pickerListButtonIconDisabledTexture, Button.STATE_DISABLED, false);
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				iconSelector.defaultSelectedValue = this.pickerListButtonIconSelectedTexture;
				iconSelector.setValueForState(this.pickerListButtonIconDisabledTexture, Button.STATE_DISABLED, true);
			}
			iconSelector.displayObjectProperties =
			{
				snapToPixels: true,
				textureScale: this.scale
			}
			button.stateToIconFunction = iconSelector.updateValue;

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
			var backgroundSkin:Scale9Image = new Scale9Image(this.backgroundSkinTextures, this.scale);
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

			var backgroundDisabledSkin:Scale9Image = new Scale9Image(this.backgroundDisabledSkinTextures, this.scale);
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

			var fillSkin:Scale9Image = new Scale9Image(this.buttonUpSkinTextures, this.scale);
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

			var fillDisabledSkin:Scale9Image = new Scale9Image(this.buttonDisabledSkinTextures, this.scale);
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
			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.defaultValue = this.radioUpIconTexture;
			iconSelector.defaultSelectedValue = this.radioSelectedUpIconTexture;
			iconSelector.setValueForState(this.radioDownIconTexture, Button.STATE_DOWN, false);
			iconSelector.setValueForState(this.radioDisabledIconTexture, Button.STATE_DISABLED, false);
			iconSelector.setValueForState(this.radioSelectedDownIconTexture, Button.STATE_DOWN, true);
			iconSelector.setValueForState(this.radioSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
			iconSelector.displayObjectProperties =
			{
				scaleX: this.scale,
				scaleY: this.scale
			};
			radio.stateToIconFunction = iconSelector.updateValue;

			radio.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
			radio.focusPaddingLeft = this.focusPaddingSize;
			radio.focusPaddingRight = this.focusPaddingSize;

			radio.defaultLabelProperties.elementFormat = this.lightUIElementFormat;
			radio.disabledLabelProperties.elementFormat = this.lightUIDisabledElementFormat;
			radio.selectedDisabledLabelProperties.elementFormat = this.lightUIDisabledElementFormat;

			radio.gap = this.smallGutterSize;
			radio.minWidth = this.controlSize;
			radio.minHeight = this.controlSize;
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
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.horizontalScrollBarIncrementButtonUpSkinTextures;
			skinSelector.setValueForState(this.horizontalScrollBarIncrementButtonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.horizontalScrollBarIncrementButtonDisabledSkinTextures, Button.STATE_DISABLED, false);
			button.stateToSkinFunction = skinSelector.updateValue;
			skinSelector.displayObjectProperties =
			{
				width: this.smallControlSize,
				height: this.smallControlSize,
				textureScale: this.scale
			};

			button.defaultIcon = new Image(this.horizontalScrollBarIncrementButtonIconTexture);
			button.disabledIcon = new Image(this.horizontalScrollBarIncrementButtonDisabledIconTexture);

			var incrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
			incrementButtonDisabledIcon.alpha = 0;
			button.disabledIcon = incrementButtonDisabledIcon;

			button.hasLabelTextRenderer = false;
		}

		protected function setHorizontalScrollBarDecrementButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.horizontalScrollBarDecrementButtonUpSkinTextures;
			skinSelector.setValueForState(this.horizontalScrollBarDecrementButtonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.horizontalScrollBarDecrementButtonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: this.smallControlSize,
				height: this.smallControlSize,
				textureScale: this.scale
			};

			button.stateToSkinFunction = skinSelector.updateValue;

			button.defaultIcon = new Image(this.horizontalScrollBarDecrementButtonIconTexture);
			button.disabledIcon = new Image(this.horizontalScrollBarDecrementButtonDisabledIconTexture);

			var decrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
			decrementButtonDisabledIcon.alpha = 0;
			button.disabledIcon = decrementButtonDisabledIcon;

			button.hasLabelTextRenderer = false;
		}

		protected function setHorizontalScrollBarThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: this.smallControlSize,
				height: this.smallControlSize,
				textureScale: this.scale
			};
			thumb.stateToSkinFunction = skinSelector.updateValue;

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
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.verticalScrollBarIncrementButtonUpSkinTextures;
			skinSelector.setValueForState(this.verticalScrollBarIncrementButtonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.verticalScrollBarIncrementButtonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: this.smallControlSize,
				height: this.smallControlSize,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.defaultIcon = new Image(this.verticalScrollBarIncrementButtonIconTexture);
			button.disabledIcon = new Image(this.verticalScrollBarIncrementButtonDisabledIconTexture);

			var incrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
			incrementButtonDisabledIcon.alpha = 0;
			button.disabledIcon = incrementButtonDisabledIcon;

			button.hasLabelTextRenderer = false;
		}

		protected function setVerticalScrollBarDecrementButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.verticalScrollBarDecrementButtonUpSkinTextures;
			skinSelector.setValueForState(this.verticalScrollBarDecrementButtonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.verticalScrollBarDecrementButtonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: this.smallControlSize,
				height: this.smallControlSize,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.defaultIcon = new Image(this.verticalScrollBarDecrementButtonIconTexture);
			button.disabledIcon = new Image(this.verticalScrollBarDecrementButtonDisabledIconTexture);

			var decrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
			decrementButtonDisabledIcon.alpha = 0;
			button.disabledIcon = decrementButtonDisabledIcon;

			button.hasLabelTextRenderer = false;
		}

		protected function setVerticalScrollBarThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: this.smallControlSize,
				height: this.smallControlSize,
				textureScale: this.scale
			};
			thumb.stateToSkinFunction = skinSelector.updateValue;

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

			var backgroundSkin:TiledImage = new TiledImage(this.headerBackgroundSkinTexture, this.scale);
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
			var defaultSkin:Scale3Image = new Scale3Image(this.horizontalSimpleScrollBarThumbSkinTextures, this.scale);
			defaultSkin.width = this.smallControlSize;
			thumb.defaultSkin = defaultSkin;

			thumb.hasLabelTextRenderer = false;
		}

		protected function setVerticalSimpleScrollBarThumbStyles(thumb:Button):void
		{
			var defaultSkin:Scale3Image = new Scale3Image(this.verticalSimpleScrollBarThumbSkinTextures, this.scale);
			defaultSkin.height = this.smallControlSize;
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
			slider.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
			slider.focusPadding = this.focusPaddingSize;
		}

		protected function setSliderThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: this.smallControlSize,
				height: this.smallControlSize,
				textureScale: this.scale
			};
			thumb.stateToSkinFunction = skinSelector.updateValue;

			thumb.minWidth = this.smallControlSize;
			thumb.minHeight = this.smallControlSize;

			thumb.hasLabelTextRenderer = false;
		}

		protected function setHorizontalSliderMinimumTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.backgroundSkinTextures;
			skinSelector.setValueForState(this.backgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			skinSelector.displayObjectProperties.width = this.wideControlSize;
			skinSelector.displayObjectProperties.height = this.smallControlSize;
			track.stateToSkinFunction = skinSelector.updateValue;

			track.hasLabelTextRenderer = false;
		}

		protected function setHorizontalSliderMaximumTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.backgroundSkinTextures;
			skinSelector.setValueForState(this.backgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			skinSelector.displayObjectProperties.width = this.wideControlSize;
			skinSelector.displayObjectProperties.height = this.smallControlSize;
			track.stateToSkinFunction = skinSelector.updateValue;

			track.hasLabelTextRenderer = false;
		}

		protected function setVerticalSliderMinimumTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.backgroundSkinTextures;
			skinSelector.setValueForState(this.backgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			skinSelector.displayObjectProperties.width = this.smallControlSize;
			skinSelector.displayObjectProperties.height = this.wideControlSize;
			track.stateToSkinFunction = skinSelector.updateValue;

			track.hasLabelTextRenderer = false;
		}

		protected function setVerticalSliderMaximumTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.backgroundSkinTextures;
			skinSelector.setValueForState(this.backgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			skinSelector.displayObjectProperties.width = this.smallControlSize;
			skinSelector.displayObjectProperties.height = this.wideControlSize;
			track.stateToSkinFunction = skinSelector.updateValue;

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
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.tabUpSkinTextures;
			skinSelector.defaultSelectedValue = this.tabSelectedSkinTextures;
			skinSelector.setValueForState(this.tabDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.tabDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.tabSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			tab.stateToSkinFunction = skinSelector.updateValue;

			tab.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
			tab.focusPadding = this.focusPaddingSize;

			tab.defaultLabelProperties.elementFormat = this.lightUIElementFormat;
			tab.downLabelProperties.elementFormat = this.darkUIElementFormat;
			tab.defaultSelectedLabelProperties.elementFormat = this.darkUIElementFormat;
			tab.disabledLabelProperties.elementFormat = this.lightUIDisabledElementFormat;
			tab.selectedDisabledLabelProperties.elementFormat = this.darkUIDisabledElementFormat;

			tab.paddingTop = this.smallGutterSize;
			tab.paddingBottom = this.smallGutterSize;
			tab.paddingLeft = this.gutterSize;
			tab.paddingRight = this.gutterSize;
			tab.gap = this.smallGutterSize;
			tab.minWidth = this.controlSize;
			tab.minHeight = this.controlSize;
		}

	//-------------------------
	// TextArea
	//-------------------------

		protected function setTextAreaStyles(textArea:TextArea):void
		{
			this.setScrollerStyles(textArea);

			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.backgroundSkinTextures;
			skinSelector.setValueForState(this.backgroundDisabledSkinTextures, TextArea.STATE_DISABLED);
			skinSelector.setValueForState(this.backgroundFocusedSkinTextures, TextArea.STATE_FOCUSED);
			skinSelector.displayObjectProperties =
			{
				width: this.wideControlSize * 2,
				height: this.wideControlSize,
				textureScale: this.scale
			};
			textArea.stateToSkinFunction = skinSelector.updateValue;

			textArea.padding = this.borderSize;

			textArea.textEditorProperties.textFormat = this.scrollTextTextFormat;
			textArea.textEditorProperties.disabledTextFormat = this.scrollTextDisabledTextFormat;
			textArea.textEditorProperties.paddingTop = this.extraSmallGutterSize;
			textArea.textEditorProperties.paddingRight = this.smallGutterSize;
			textArea.textEditorProperties.paddingBottom = this.extraSmallGutterSize;
			textArea.textEditorProperties.paddingLeft = this.smallGutterSize;
		}

	//-------------------------
	// TextInput
	//-------------------------

		protected function setBaseTextInputStyles(input:TextInput):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.backgroundSkinTextures;
			skinSelector.setValueForState(this.backgroundDisabledSkinTextures, TextInput.STATE_DISABLED);
			skinSelector.setValueForState(this.backgroundFocusedSkinTextures, TextInput.STATE_FOCUSED);
			skinSelector.displayObjectProperties =
			{
				width: this.wideControlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			input.stateToSkinFunction = skinSelector.updateValue;

			input.minWidth = this.controlSize;
			input.minHeight = this.controlSize;
			input.gap = this.smallGutterSize;
			input.paddingTop = this.smallGutterSize;
			input.paddingBottom = this.smallGutterSize;
			input.paddingLeft = this.gutterSize;
			input.paddingRight = this.gutterSize;

			input.textEditorProperties.elementFormat = this.lightElementFormat;
			input.textEditorProperties.disabledElementFormat = this.disabledElementFormat;
			input.textEditorProperties.cursorSkin = new Quad(1, 1, LIGHT_TEXT_COLOR);
			input.textEditorProperties.selectionSkin = new Quad(1, 1, TEXT_SELECTION_BACKGROUND_COLOR);

			input.promptProperties.elementFormat = this.lightElementFormat;
			input.promptProperties.disabledElementFormat = this.disabledElementFormat;
		}

		protected function setTextInputStyles(input:TextInput):void
		{
			this.setBaseTextInputStyles(input);
		}

		protected function setSearchTextInputStyles(input:TextInput):void
		{
			this.setBaseTextInputStyles(input);

			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
			iconSelector.defaultValue = this.searchIconTexture;
			iconSelector.setValueForState(this.searchIconDisabledTexture, TextInput.STATE_DISABLED, false);
			iconSelector.displayObjectProperties =
			{
				snapToPixels: true,
				textureScale: this.scale
			}
			input.stateToIconFunction = iconSelector.updateValue;
		}

	//-------------------------
	// ToggleSwitch
	//-------------------------

		protected function setToggleSwitchStyles(toggle:ToggleSwitch):void
		{
			toggle.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;

			toggle.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
			toggle.focusPadding = this.focusPaddingSize;

			toggle.defaultLabelProperties.elementFormat = this.lightUIElementFormat;
			toggle.disabledLabelProperties.elementFormat = this.lightUIDisabledElementFormat;
			toggle.onLabelProperties.elementFormat = this.selectedUIElementFormat;
		}

		protected function setToggleSwitchThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: this.controlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			thumb.stateToSkinFunction = skinSelector.updateValue;

			thumb.minWidth = this.controlSize;
			thumb.minHeight = this.controlSize;

			thumb.hasLabelTextRenderer = false;
		}

		protected function setToggleSwitchTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.backgroundSkinTextures;
			skinSelector.setValueForState(this.backgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: Math.round(this.controlSize * 2.5),
				height: this.controlSize,
				textureScale: this.scale
			};
			track.stateToSkinFunction = skinSelector.updateValue;

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
			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.defaultValue = this.playPauseButtonPlayUpIconTexture;
			iconSelector.defaultSelectedValue = this.playPauseButtonPauseUpIconTexture;
			iconSelector.setValueForState(this.playPauseButtonPlayDownIconTexture, Button.STATE_DOWN, false);
			iconSelector.setValueForState(this.playPauseButtonPauseDownIconTexture, Button.STATE_DOWN, true);
			iconSelector.displayObjectProperties =
			{
				scaleX: this.scale,
				scaleY: this.scale
			};
			button.stateToIconFunction = iconSelector.updateValue;

			button.hasLabelTextRenderer = false;

			button.minWidth = this.controlSize;
			button.minHeight = this.controlSize;
		}

		protected function setLargePlayPauseToggleButtonStyles(button:PlayPauseToggleButton):void
		{
			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.setValueForState(this.largePlayPauseButtonPlayUpIconTexture, Button.STATE_UP, false);
			iconSelector.setValueForState(this.largePlayPauseButtonPlayUpIconTexture, Button.STATE_HOVER, false);
			iconSelector.setValueForState(this.largePlayPauseButtonPlayDownIconTexture, Button.STATE_DOWN, false);
			iconSelector.displayObjectProperties =
			{
				scaleX: this.scale,
				scaleY: this.scale
			};
			button.stateToIconFunction = iconSelector.updateValue;

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
			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.defaultValue = this.fullScreenToggleButtonEnterUpIconTexture;
			iconSelector.defaultSelectedValue = this.fullScreenToggleButtonExitUpIconTexture;
			iconSelector.setValueForState(this.fullScreenToggleButtonEnterDownIconTexture, Button.STATE_DOWN, false);
			iconSelector.setValueForState(this.fullScreenToggleButtonExitDownIconTexture, Button.STATE_DOWN, true);
			iconSelector.displayObjectProperties =
			{
				scaleX: this.scale,
				scaleY: this.scale
			};
			button.stateToIconFunction = iconSelector.updateValue;

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
			slider.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
			slider.focusPadding = this.focusPaddingSize;
			slider.showThumb = false;
			slider.minWidth = this.volumeSliderMinimumTrackSkinTexture.width;
			slider.minHeight = this.volumeSliderMinimumTrackSkinTexture.height;
		}

		protected function setVolumeSliderThumbStyles(button:Button):void
		{
			var thumbSize:Number = 6 * this.scale;
			button.defaultSkin = new Quad(thumbSize, thumbSize);
			button.defaultSkin.width = 0;
			button.hasLabelTextRenderer = false;
		}

		protected function setVolumeSliderMinimumTrackStyles(track:Button):void
		{
			var defaultSkin:ImageLoader = new ImageLoader();
			defaultSkin.scaleContent = false;
			defaultSkin.source = this.volumeSliderMinimumTrackSkinTexture;
			track.defaultSkin = defaultSkin;
		}

		protected function setVolumeSliderMaximumTrackStyles(track:Button):void
		{
			var defaultSkin:ImageLoader = new ImageLoader();
			defaultSkin.scaleContent = false;
			defaultSkin.horizontalAlign = ImageLoader.HORIZONTAL_ALIGN_RIGHT;
			defaultSkin.source = this.volumeSliderMaximumTrackSkinTexture;
			track.defaultSkin = defaultSkin;
		}

		protected function setPopUpVolumeSliderStyles(slider:VolumeSlider):void
		{
			slider.direction = VolumeSlider.DIRECTION_VERTICAL;
			slider.trackLayoutMode = VolumeSlider.TRACK_LAYOUT_MODE_SINGLE;
			slider.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
			slider.focusPadding = this.focusPaddingSize;
			slider.minimumPadding = this.popUpVolumeSliderPaddingSize;
			slider.maximumPadding = this.popUpVolumeSliderPaddingSize;
			slider.customThumbStyleName = THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_THUMB;
			slider.customMinimumTrackStyleName = THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MINIMUM_TRACK;
		}

		protected function setPopUpVolumeSliderTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.popUpVolumeSliderTrackSkinTextures;
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			skinSelector.displayObjectProperties.width = this.gridSize;
			skinSelector.displayObjectProperties.height = this.wideControlSize;
			track.stateToSkinFunction = skinSelector.updateValue;

			track.hasLabelTextRenderer = false;
		}

	//-------------------------
	// MuteToggleButton
	//-------------------------

		protected function setMuteToggleButtonStyles(button:MuteToggleButton):void
		{
			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.defaultValue = this.muteToggleButtonLoudUpIconTexture;
			iconSelector.defaultSelectedValue = this.muteToggleButtonMutedUpIconTexture;
			iconSelector.setValueForState(this.muteToggleButtonLoudDownIconTexture, Button.STATE_DOWN, false);
			iconSelector.setValueForState(this.muteToggleButtonMutedDownIconTexture, Button.STATE_DOWN, true);
			iconSelector.displayObjectProperties =
			{
				scaleX: this.scale,
				scaleY: this.scale
			};
			button.stateToIconFunction = iconSelector.updateValue;

			button.showVolumeSliderOnHover = true;
			button.hasLabelTextRenderer = false;

			button.minWidth = this.controlSize;
			button.minHeight = this.controlSize;
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
		}

		protected function setSeekSliderThumbStyles(button:Button):void
		{
			var thumbSize:Number = 6 * this.scale;
			button.defaultSkin = new Quad(thumbSize, thumbSize);
			button.hasLabelTextRenderer = false;
		}

		protected function setSeekSliderMinimumTrackStyles(button:Button):void
		{
			var defaultSkin:Scale9Image = new Scale9Image(this.buttonUpSkinTextures, this.scale);
			defaultSkin.width = this.wideControlSize;
			defaultSkin.height = this.smallControlSize;
			button.defaultSkin = defaultSkin;
			button.hasLabelTextRenderer = false;
		}

		protected function setSeekSliderMaximumTrackStyles(button:Button):void
		{
			var defaultSkin:Scale9Image = new Scale9Image(this.backgroundSkinTextures, this.scale);
			defaultSkin.width = this.wideControlSize;
			defaultSkin.height = this.smallControlSize;
			button.defaultSkin = defaultSkin;
			button.hasLabelTextRenderer = false;
		}

	}
}
