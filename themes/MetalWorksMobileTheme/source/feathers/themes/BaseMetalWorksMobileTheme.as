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
	import feathers.media.FullScreenToggleButton;
	import feathers.media.MuteToggleButton;
	import feathers.media.PlayPauseToggleButton;
	import feathers.media.SeekSlider;
	import feathers.media.VolumeSlider;
	import feathers.skins.ImageSkin;
	import feathers.system.DeviceCapabilities;

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
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	/**
	 * The base class for the "Metal Works" theme for mobile Feathers apps.
	 * Handles everything except asset loading, which is left to subclasses.
	 *
	 * @see MetalWorksMobileTheme
	 * @see MetalWorksMobileThemeWithAssetManager
	 */
	public class BaseMetalWorksMobileTheme extends StyleNameFunctionTheme
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
		protected static const LIST_BACKGROUND_COLOR:uint = 0x383430;
		protected static const GROUPED_LIST_HEADER_BACKGROUND_COLOR:uint = 0x2e2a26;
		protected static const GROUPED_LIST_FOOTER_BACKGROUND_COLOR:uint = 0x2e2a26;
		protected static const MODAL_OVERLAY_COLOR:uint = 0x29241e;
		protected static const MODAL_OVERLAY_ALPHA:Number = 0.8;
		protected static const DRAWER_OVERLAY_COLOR:uint = 0x29241e;
		protected static const DRAWER_OVERLAY_ALPHA:Number = 0.4;
		protected static const VIDEO_OVERLAY_COLOR:uint = 0x1a1816;
		protected static const VIDEO_OVERLAY_ALPHA:Number = 0.2;

		protected static const DEFAULT_BACKGROUND_SCALE9_GRID:Rectangle = new Rectangle(4, 4, 1, 1);
		protected static const BUTTON_SCALE9_GRID:Rectangle = new Rectangle(4, 4, 1, 20);
		protected static const SMALL_BACKGROUND_SCALE9_GRID:Rectangle = new Rectangle(2, 2, 1, 1);
		protected static const BACK_BUTTON_SCALE9_GRID:Rectangle = new Rectangle(13, 0, 1, 28);
		protected static const FORWARD_BUTTON_SCALE9_GRID:Rectangle = new Rectangle(3, 0, 1, 28);
		protected static const ITEM_RENDERER_SCALE9_GRID:Rectangle = new Rectangle(1, 1, 1, 42);
		protected static const INSET_ITEM_RENDERER_MIDDLE_SCALE9_GRID:Rectangle = new Rectangle(2, 2, 1, 40);
		protected static const INSET_ITEM_RENDERER_FIRST_SCALE9_GRID:Rectangle = new Rectangle(7, 7, 1, 35);
		protected static const INSET_ITEM_RENDERER_LAST_SCALE9_GRID:Rectangle = new Rectangle(7, 2, 1, 35);
		protected static const INSET_ITEM_RENDERER_SINGLE_SCALE9_GRID:Rectangle = new Rectangle(7, 7, 1, 30);
		protected static const TAB_SCALE9_GRID:Rectangle = new Rectangle(11, 11, 1, 22);
		protected static const SPINNER_LIST_SELECTION_OVERLAY_SCALE9_GRID:Rectangle = new Rectangle(2, 6, 1, 32);
		protected static const HORIZONTAL_SCROLL_BAR_THUMB_SCALE9_GRID:Rectangle = new Rectangle(4, 0, 4, 5);
		protected static const VERTICAL_SCROLL_BAR_THUMB_SCALE9_GRID:Rectangle = new Rectangle(0, 4, 5, 4);

		protected static const HEADER_SKIN_TEXTURE_REGION:Rectangle = new Rectangle(1, 1, 128, 64);
		protected static const TAB_SKIN_TEXTURE_REGION:Rectangle = new Rectangle(1, 0, 22, 44);
		
		/**
		 * @private
		 * The theme's custom style name for a "quiet" button's label text renderer.
		 */
		protected static const THEME_STYLE_NAME_QUIET_BUTTON_LABEL:String = "metal-works-mobile-quiet-button-label";

		/**
		 * @private
		 * The theme's custom style name for a ButtonGroup button's label text renderer.
		 */
		protected static const THEME_STYLE_NAME_BUTTON_GROUP_BUTTON_LABEL:String = "metal-works-mobile-button-group-button-label";

		/**
		 * @private
		 * The theme's custom style name for a tab's label text renderer.
		 */
		protected static const THEME_STYLE_NAME_TAB_LABEL:String = "metal-works-mobile-tab-label";

		/**
		 * @private
		 * The theme's custom style name for a GroupedList footer's label text renderer.
		 */
		protected static const THEME_STYLE_NAME_GROUPED_LIST_FOOTER_CONTENT_LABEL:String = "metal-works-mobile-grouped-list-footer-content-label";

		/**
		 * @private
		 * The theme's custom style name for the label text renderer of an item
		 * renderer with the "check" style.
		 */
		protected static const THEME_STYLE_NAME_CHECK_ITEM_RENDERER_LABEL:String = "metal-works-mobile-check-item-renderer-label";

		/**
		 * @private
		 * The theme's custom style name for the icon label text renderer of an
		 * item renderer with the "check" style.
		 */
		protected static const THEME_STYLE_NAME_CHECK_ITEM_RENDERER_ICON_LABEL:String = "metal-works-mobile-check-item-renderer-icon-label";

		/**
		 * @private
		 * The theme's custom style name for the accessory label text renderer
		 * of an item renderer with the "check" style.
		 */
		protected static const THEME_STYLE_NAME_CHECK_ITEM_RENDERER_ACCESSORY_LABEL:String = "metal-works-mobile-check-item-renderer-accessory-label";

		/**
		 * @private
		 * The theme's custom style name for item renderers in a SpinnerList.
		 */
		protected static const THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER:String = "metal-works-mobile-spinner-list-item-renderer";

		/**
		 * @private
		 * The theme's custom style name for the SpinnerList's item renderer's label text renderer.
		 */
		protected static const THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER_LABEL:String = "metal-works-mobile-spinner-list-item-renderer-label";

		/**
		 * @private
		 * The theme's custom style name for the SpinnerList's item renderer's icon label text renderer.
		 */
		protected static const THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER_ICON_LABEL:String = "metal-works-mobile-spinner-list-item-renderer-icon-label";

		/**
		 * @private
		 * The theme's custom style name for the SpinnerList's item renderer's accessory label text renderer.
		 */
		protected static const THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER_ACCESSORY_LABEL:String = "metal-works-mobile-spinner-list-item-renderer-accessory-label";

		/**
		 * @private
		 * The theme's custom style name for buttons in an Alert's button group.
		 */
		protected static const THEME_STYLE_NAME_ALERT_BUTTON_GROUP_BUTTON:String = "metal-works-mobile-alert-button-group-button";

		/**
		 * @private
		 * The theme's custom style name for the thumb of a horizontal SimpleScrollBar.
		 */
		protected static const THEME_STYLE_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB:String = "metal-works-mobile-horizontal-simple-scroll-bar-thumb";

		/**
		 * @private
		 * The theme's custom style name for the thumb of a vertical SimpleScrollBar.
		 */
		protected static const THEME_STYLE_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB:String = "metal-works-mobile-vertical-simple-scroll-bar-thumb";

		/**
		 * @private
		 * The theme's custom style name for the minimum track of a horizontal slider.
		 */
		protected static const THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK:String = "metal-works-mobile-horizontal-slider-minimum-track";

		/**
		 * @private
		 * The theme's custom style name for the maximum track of a horizontal slider.
		 */
		protected static const THEME_STYLE_NAME_HORIZONTAL_SLIDER_MAXIMUM_TRACK:String = "metal-works-mobile-horizontal-slider-maximum-track";

		/**
		 * @private
		 * The theme's custom style name for the minimum track of a vertical slider.
		 */
		protected static const THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK:String = "metal-works-mobile-vertical-slider-minimum-track";

		/**
		 * @private
		 * The theme's custom style name for the maximum track of a vertical slider.
		 */
		protected static const THEME_STYLE_NAME_VERTICAL_SLIDER_MAXIMUM_TRACK:String = "metal-works-mobile-vertical-slider-maximum-track";
		
		/**
		 * @private
		 * The theme's custom style name for the text editor of the NumericStepper's TextInput.
		 */
		protected static const THEME_STYLE_NAME_NUMERIC_STEPPER_TEXT_INPUT_EDITOR:String = "metal-works-mobile-numeric-stepper-text-input-editor";

		/**
		 * @private
		 * The theme's custom style name for the item renderer of the DateTimeSpinner's SpinnerLists.
		 */
		protected static const THEME_STYLE_NAME_DATE_TIME_SPINNER_LIST_ITEM_RENDERER:String = "metal-works-mobile-date-time-spinner-list-item-renderer";

		/**
		 * @private
		 * The theme's custom style name for the text renderer of a heading Label.
		 */
		protected static const THEME_STYLE_NAME_HEADING_LABEL_TEXT_RENDERER:String = "metal-works-mobile-heading-label-text-renderer";

		/**
		 * @private
		 * The theme's custom style name for the text renderer of a detail Label.
		 */
		protected static const THEME_STYLE_NAME_DETAIL_LABEL_TEXT_RENDERER:String = "metal-works-mobile-detail-label-text-renderer";

		/**
		 * The default global text renderer factory for this theme creates a
		 * TextBlockTextRenderer.
		 */
		protected static function textRendererFactory():ITextRenderer
		{
			return new TextBlockTextRenderer();
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
		 * TextBlockTextEditor.
		 */
		protected static function stepperTextEditorFactory():TextBlockTextEditor
		{
			//we're only using this text editor in the NumericStepper because
			//isEditable is false on the TextInput. this text editor is not
			//suitable for mobile use if the TextInput needs to be editable
			//because it can't use the soft keyboard or other mobile-friendly UI
			return new TextBlockTextEditor();
		}

		/**
		 * The pop-up factory for a PickerList creates a SpinnerList.
		 */
		protected static function pickerListSpinnerListFactory():SpinnerList
		{
			return new SpinnerList();
		}

		/**
		 * This theme's scroll bar type is SimpleScrollBar.
		 */
		protected static function scrollBarFactory():SimpleScrollBar
		{
			return new SimpleScrollBar();
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
		public function BaseMetalWorksMobileTheme()
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
		 * An extra large font size.
		 */
		protected var extraLargeFontSize:int;

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
		 * The size, in pixels, of smaller padding and gaps within controls.
		 */
		protected var smallControlGutterSize:int;

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
		 * The size, in pixels, of borders;
		 */
		protected var borderSize:int;

		protected var popUpFillSize:int;
		protected var calloutBackgroundMinSize:int;
		protected var calloutArrowOverlapGap:int;
		protected var scrollBarGutterSize:int;

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
		 * An ElementFormat used for Header components.
		 */
		protected var headerElementFormat:ElementFormat;

		/**
		 * An ElementFormat used for Header components when disabled.
		 */
		protected var headerDisabledElementFormat:ElementFormat;

		/**
		 * An ElementFormat with a dark tint meant for UI controls.
		 */
		protected var darkUIElementFormat:ElementFormat;

		/**
		 * An ElementFormat with a light tint meant for UI controls.
		 */
		protected var lightUIElementFormat:ElementFormat;

		/**
		 * An ElementFormat with a highlighted tint meant for selected UI controls.
		 */
		protected var selectedUIElementFormat:ElementFormat;

		/**
		 * An ElementFormat with a light tint meant for disabled UI controls.
		 */
		protected var lightUIDisabledElementFormat:ElementFormat;

		/**
		 * An ElementFormat with a dark tint meant for disabled UI controls.
		 */
		protected var darkUIDisabledElementFormat:ElementFormat;

		/**
		 * An ElementFormat with a dark tint meant for larger UI controls.
		 */
		protected var largeUIDarkElementFormat:ElementFormat;

		/**
		 * An ElementFormat with a light tint meant for larger UI controls.
		 */
		protected var largeUILightElementFormat:ElementFormat;

		/**
		 * An ElementFormat with a highlighted tint meant for larger UI controls.
		 */
		protected var largeUISelectedElementFormat:ElementFormat;

		/**
		 * An ElementFormat with a dark tint meant for larger disabled UI controls.
		 */
		protected var largeUIDarkDisabledElementFormat:ElementFormat;

		/**
		 * An ElementFormat with a light tint meant for larger disabled UI controls.
		 */
		protected var largeUILightDisabledElementFormat:ElementFormat;

		/**
		 * An ElementFormat with a dark tint meant for larger text.
		 */
		protected var largeDarkElementFormat:ElementFormat;

		/**
		 * An ElementFormat with a light tint meant for larger text.
		 */
		protected var largeLightElementFormat:ElementFormat;

		/**
		 * An ElementFormat meant for larger disabled text.
		 */
		protected var largeDisabledElementFormat:ElementFormat;

		/**
		 * An ElementFormat with a dark tint meant for regular text.
		 */
		protected var darkElementFormat:ElementFormat;

		/**
		 * An ElementFormat with a light tint meant for regular text.
		 */
		protected var lightElementFormat:ElementFormat;

		/**
		 * An ElementFormat meant for regular, disabled text.
		 */
		protected var disabledElementFormat:ElementFormat;

		/**
		 * An ElementFormat with a light tint meant for smaller text.
		 */
		protected var smallLightElementFormat:ElementFormat;

		/**
		 * An ElementFormat meant for smaller, disabled text.
		 */
		protected var smallDisabledElementFormat:ElementFormat;

		/**
		 * The texture atlas that contains skins for this theme. This base class
		 * does not initialize this member variable. Subclasses are expected to
		 * load the assets somehow and set the <code>atlas</code> member
		 * variable before calling <code>initialize()</code>.
		 */
		protected var atlas:TextureAtlas;

		protected var headerBackgroundSkinTexture:Texture;
		protected var popUpHeaderBackgroundSkinTexture:Texture;
		protected var backgroundSkinTexture:Texture;
		protected var backgroundDisabledSkinTexture:Texture;
		protected var backgroundInsetSkinTexture:Texture;
		protected var backgroundInsetDisabledSkinTexture:Texture;
		protected var backgroundInsetFocusedSkinTexture:Texture;
		protected var backgroundInsetDangerSkinTexture:Texture;
		protected var backgroundLightBorderSkinTexture:Texture;
		protected var backgroundDarkBorderSkinTexture:Texture;
		protected var backgroundDangerBorderSkinTexture:Texture;
		protected var buttonUpSkinTexture:Texture;
		protected var buttonDownSkinTexture:Texture;
		protected var buttonDisabledSkinTexture:Texture;
		protected var buttonSelectedUpSkinTexture:Texture;
		protected var buttonSelectedDisabledSkinTexture:Texture;
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
		protected var pickerListButtonSelectedIconTexture:Texture;
		protected var pickerListButtonIconDisabledTexture:Texture;
		protected var tabUpSkinTexture:Texture;
		protected var tabDownSkinTexture:Texture;
		protected var tabDisabledSkinTexture:Texture;
		protected var tabSelectedUpSkinTexture:Texture;
		protected var tabSelectedDisabledSkinTexture:Texture;
		protected var pickerListItemSelectedIconTexture:Texture;
		protected var spinnerListSelectionOverlaySkinTexture:Texture;
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
		protected var itemRendererSelectedSkinTexture:Texture;
		protected var insetItemRendererUpSkinTexture:Texture;
		protected var insetItemRendererSelectedSkinTexture:Texture;
		protected var insetItemRendererFirstUpSkinTexture:Texture;
		protected var insetItemRendererFirstSelectedSkinTexture:Texture;
		protected var insetItemRendererLastUpSkinTexture:Texture;
		protected var insetItemRendererLastSelectedSkinTexture:Texture;
		protected var insetItemRendererSingleUpSkinTexture:Texture;
		protected var insetItemRendererSingleSelectedSkinTexture:Texture;
		protected var calloutTopArrowSkinTexture:Texture;
		protected var calloutRightArrowSkinTexture:Texture;
		protected var calloutBottomArrowSkinTexture:Texture;
		protected var calloutLeftArrowSkinTexture:Texture;
		protected var dangerCalloutTopArrowSkinTexture:Texture;
		protected var dangerCalloutRightArrowSkinTexture:Texture;
		protected var dangerCalloutBottomArrowSkinTexture:Texture;
		protected var dangerCalloutLeftArrowSkinTexture:Texture;
		protected var verticalScrollBarThumbSkinTexture:Texture;
		protected var horizontalScrollBarThumbSkinTexture:Texture;
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
		protected var seekSliderProgressSkinTexture:Texture;

		/**
		 * Disposes the atlas before calling super.dispose()
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
		}

		/**
		 * Initializes common values used for setting the dimensions of components.
		 */
		protected function initializeDimensions():void
		{
			this.gridSize = 44;
			this.smallControlGutterSize = 6;
			this.smallGutterSize = 8;
			this.gutterSize = 12;
			this.controlSize = 28;
			this.smallControlSize = 12;
			this.popUpFillSize = 276;
			this.calloutBackgroundMinSize = 12;
			this.calloutArrowOverlapGap = -2;
			this.scrollBarGutterSize = 2;
			this.wideControlSize = this.gridSize * 3 + this.gutterSize * 2;
			this.borderSize = 1;
		}

		/**
		 * Initializes font sizes and formats.
		 */
		protected function initializeFonts():void
		{
			this.smallFontSize = 10;
			this.regularFontSize = 12;
			this.largeFontSize = 14;
			this.extraLargeFontSize = 18;

			//these are for components that don't use FTE
			this.scrollTextTextFormat = new TextFormat("_sans", this.regularFontSize, LIGHT_TEXT_COLOR);
			this.scrollTextDisabledTextFormat = new TextFormat("_sans", this.regularFontSize, DISABLED_TEXT_COLOR);

			this.regularFontDescription = new FontDescription(FONT_NAME, FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE);
			this.boldFontDescription = new FontDescription(FONT_NAME, FontWeight.BOLD, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE);

			this.headerElementFormat = new ElementFormat(this.boldFontDescription, this.extraLargeFontSize, LIGHT_TEXT_COLOR);
			this.headerDisabledElementFormat = new ElementFormat(this.boldFontDescription, this.extraLargeFontSize, DISABLED_TEXT_COLOR);

			this.darkUIElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, DARK_TEXT_COLOR);
			this.lightUIElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, LIGHT_TEXT_COLOR);
			this.selectedUIElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, SELECTED_TEXT_COLOR);
			this.lightUIDisabledElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, DISABLED_TEXT_COLOR);
			this.darkUIDisabledElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, DARK_DISABLED_TEXT_COLOR);

			this.largeUIDarkElementFormat = new ElementFormat(this.boldFontDescription, this.largeFontSize, DARK_TEXT_COLOR);
			this.largeUILightElementFormat = new ElementFormat(this.boldFontDescription, this.largeFontSize, LIGHT_TEXT_COLOR);
			this.largeUISelectedElementFormat = new ElementFormat(this.boldFontDescription, this.largeFontSize, SELECTED_TEXT_COLOR);
			this.largeUIDarkDisabledElementFormat = new ElementFormat(this.boldFontDescription, this.largeFontSize, DARK_DISABLED_TEXT_COLOR);
			this.largeUILightDisabledElementFormat = new ElementFormat(this.boldFontDescription, this.largeFontSize, DISABLED_TEXT_COLOR);

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
			this.backgroundSkinTexture = this.atlas.getTexture("background-skin0000");
			this.backgroundDisabledSkinTexture = this.atlas.getTexture("background-disabled-skin0000");
			this.backgroundInsetSkinTexture = this.atlas.getTexture("background-inset-skin0000");
			this.backgroundInsetDisabledSkinTexture = this.atlas.getTexture("background-inset-disabled-skin0000");
			this.backgroundInsetFocusedSkinTexture = this.atlas.getTexture("background-focused-skin0000");
			this.backgroundInsetDangerSkinTexture = this.atlas.getTexture("background-inset-danger-skin0000");
			this.backgroundLightBorderSkinTexture = this.atlas.getTexture("background-light-border-skin0000");
			this.backgroundDarkBorderSkinTexture = this.atlas.getTexture("background-dark-border-skin0000");
			this.backgroundDangerBorderSkinTexture = this.atlas.getTexture("background-danger-border-skin0000");

			this.buttonUpSkinTexture = this.atlas.getTexture("button-up-skin0000");
			this.buttonDownSkinTexture = this.atlas.getTexture("button-down-skin0000");
			this.buttonDisabledSkinTexture = this.atlas.getTexture("button-disabled-skin0000");
			this.buttonSelectedUpSkinTexture = this.atlas.getTexture("toggle-button-selected-up-skin0000");
			this.buttonSelectedDisabledSkinTexture = this.atlas.getTexture("toggle-button-selected-disabled-skin0000");
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

			this.tabUpSkinTexture = Texture.fromTexture(this.atlas.getTexture("tab-up-skin0000"), TAB_SKIN_TEXTURE_REGION);
			this.tabDownSkinTexture = Texture.fromTexture(this.atlas.getTexture("tab-down-skin0000"), TAB_SKIN_TEXTURE_REGION);
			this.tabDisabledSkinTexture = Texture.fromTexture(this.atlas.getTexture("tab-disabled-skin0000"), TAB_SKIN_TEXTURE_REGION);
			this.tabSelectedUpSkinTexture = Texture.fromTexture(this.atlas.getTexture("tab-selected-up-skin0000"), TAB_SKIN_TEXTURE_REGION);
			this.tabSelectedDisabledSkinTexture = Texture.fromTexture(this.atlas.getTexture("tab-selected-disabled-skin0000"), TAB_SKIN_TEXTURE_REGION);

			this.pickerListButtonIconTexture = this.atlas.getTexture("picker-list-button-icon0000");
			this.pickerListButtonSelectedIconTexture = this.atlas.getTexture("picker-list-button-selected-icon0000");
			this.pickerListButtonIconDisabledTexture = this.atlas.getTexture("picker-list-button-disabled-icon0000");
			this.pickerListItemSelectedIconTexture = this.atlas.getTexture("picker-list-item-renderer-selected-icon0000");

			this.spinnerListSelectionOverlaySkinTexture = this.atlas.getTexture("spinner-list-selection-overlay-skin0000");

			this.checkUpIconTexture = this.atlas.getTexture("check-up-icon0000");
			this.checkDownIconTexture = this.atlas.getTexture("check-down-icon0000");
			this.checkDisabledIconTexture = this.atlas.getTexture("check-disabled-icon0000");
			this.checkSelectedUpIconTexture = this.atlas.getTexture("check-selected-up-icon0000");
			this.checkSelectedDownIconTexture = this.atlas.getTexture("check-selected-down-icon0000");
			this.checkSelectedDisabledIconTexture = this.atlas.getTexture("check-selected-disabled-icon0000");

			this.radioUpIconTexture = this.checkUpIconTexture;
			this.radioDownIconTexture = this.checkDownIconTexture;
			this.radioDisabledIconTexture = this.checkDisabledIconTexture;
			this.radioSelectedUpIconTexture = this.atlas.getTexture("radio-selected-up-icon0000");
			this.radioSelectedDownIconTexture = this.atlas.getTexture("radio-selected-down-icon0000");
			this.radioSelectedDisabledIconTexture = this.atlas.getTexture("radio-selected-disabled-icon0000");

			this.pageIndicatorSelectedSkinTexture = this.atlas.getTexture("page-indicator-selected-symbol0000");
			this.pageIndicatorNormalSkinTexture = this.atlas.getTexture("page-indicator-symbol0000");

			this.searchIconTexture = this.atlas.getTexture("search-icon0000");
			this.searchIconDisabledTexture = this.atlas.getTexture("search-disabled-icon0000");

			this.itemRendererUpSkinTexture = this.atlas.getTexture("item-renderer-up-skin0000");
			this.itemRendererSelectedSkinTexture = this.atlas.getTexture("item-renderer-selected-up-skin0000");
			this.insetItemRendererUpSkinTexture = this.atlas.getTexture("inset-item-renderer-up-skin0000");
			this.insetItemRendererSelectedSkinTexture = this.atlas.getTexture("inset-item-renderer-selected-up-skin0000");
			this.insetItemRendererFirstUpSkinTexture = this.atlas.getTexture("first-inset-item-renderer-up-skin0000");
			this.insetItemRendererFirstSelectedSkinTexture = this.atlas.getTexture("first-inset-item-renderer-selected-up-skin0000");
			this.insetItemRendererLastUpSkinTexture = this.atlas.getTexture("last-inset-item-renderer-up-skin0000");
			this.insetItemRendererLastSelectedSkinTexture = this.atlas.getTexture("last-inset-item-renderer-selected-up-skin0000");
			this.insetItemRendererSingleUpSkinTexture = this.atlas.getTexture("single-inset-item-renderer-up-skin0000");
			this.insetItemRendererSingleSelectedSkinTexture = this.atlas.getTexture("single-inset-item-renderer-selected-up-skin0000");

			var headerBackgroundSkinTexture:Texture = this.atlas.getTexture("header-background-skin0000");
			var popUpHeaderBackgroundSkinTexture:Texture = this.atlas.getTexture("header-popup-background-skin0000");
			this.headerBackgroundSkinTexture = Texture.fromTexture(headerBackgroundSkinTexture, HEADER_SKIN_TEXTURE_REGION);
			this.popUpHeaderBackgroundSkinTexture = Texture.fromTexture(popUpHeaderBackgroundSkinTexture, HEADER_SKIN_TEXTURE_REGION);

			this.calloutTopArrowSkinTexture = this.atlas.getTexture("callout-arrow-top-skin0000");
			this.calloutRightArrowSkinTexture = this.atlas.getTexture("callout-arrow-right-skin0000");
			this.calloutBottomArrowSkinTexture = this.atlas.getTexture("callout-arrow-bottom-skin0000");
			this.calloutLeftArrowSkinTexture = this.atlas.getTexture("callout-arrow-left-skin0000");
			this.dangerCalloutTopArrowSkinTexture = this.atlas.getTexture("danger-callout-arrow-top-skin0000");
			this.dangerCalloutRightArrowSkinTexture = this.atlas.getTexture("danger-callout-arrow-right-skin0000");
			this.dangerCalloutBottomArrowSkinTexture = this.atlas.getTexture("danger-callout-arrow-bottom-skin0000");
			this.dangerCalloutLeftArrowSkinTexture = this.atlas.getTexture("danger-callout-arrow-left-skin0000");

			this.horizontalScrollBarThumbSkinTexture = this.atlas.getTexture("horizontal-simple-scroll-bar-thumb-skin0000");
			this.verticalScrollBarThumbSkinTexture = this.atlas.getTexture("vertical-simple-scroll-bar-thumb-skin0000");

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
			this.getStyleProviderForClass(ButtonGroup).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_BUTTON_GROUP, this.setAlertButtonGroupStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_ALERT_BUTTON_GROUP_BUTTON, this.setAlertButtonGroupButtonStyles);
			this.getStyleProviderForClass(Header).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setPopUpHeaderStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_MESSAGE, this.setAlertMessageTextRendererStyles);

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
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ButtonGroup.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setButtonGroupButtonStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ButtonGroup.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setButtonGroupButtonStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(THEME_STYLE_NAME_BUTTON_GROUP_BUTTON_LABEL, this.setButtonGroupButtonLabelStyles);

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
			this.getStyleProviderForClass(GroupedList).setFunctionForStyleName(GroupedList.ALTERNATE_STYLE_NAME_INSET_GROUPED_LIST, this.setInsetGroupedListStyles);
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_ITEM_RENDERER, this.setInsetGroupedListMiddleItemRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FIRST_ITEM_RENDERER, this.setInsetGroupedListFirstItemRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_LAST_ITEM_RENDERER, this.setInsetGroupedListLastItemRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_SINGLE_ITEM_RENDERER, this.setInsetGroupedListSingleItemRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(DefaultGroupedListItemRenderer.ALTERNATE_STYLE_NAME_DRILL_DOWN, this.setDrillDownItemRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(DefaultGroupedListItemRenderer.ALTERNATE_STYLE_NAME_CHECK, this.setCheckItemRendererStyles);

			//header
			this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(Header.DEFAULT_CHILD_STYLE_NAME_TITLE, this.setHeaderTitleStyles);

			//header and footer renderers for grouped list
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).defaultStyleFunction = this.setGroupedListHeaderRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.DEFAULT_CHILD_STYLE_NAME_FOOTER_RENDERER, this.setGroupedListFooterRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_HEADER_RENDERER, this.setInsetGroupedListHeaderRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FOOTER_RENDERER, this.setInsetGroupedListFooterRendererStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(DefaultGroupedListHeaderOrFooterRenderer.DEFAULT_CHILD_STYLE_NAME_CONTENT_LABEL, this.setGroupedListHeaderContentLabelStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(THEME_STYLE_NAME_GROUPED_LIST_FOOTER_CONTENT_LABEL, this.setGroupedListFooterContentLabelStyles);

			//labels
			this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_STYLE_NAME_HEADING, this.setHeadingLabelStyles);
			this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_STYLE_NAME_DETAIL, this.setDetailLabelStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(Label.DEFAULT_CHILD_STYLE_NAME_TEXT_RENDERER, this.setLabelTextRendererStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(THEME_STYLE_NAME_HEADING_LABEL_TEXT_RENDERER, this.setHeadingLabelTextRendererStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(THEME_STYLE_NAME_DETAIL_LABEL_TEXT_RENDERER, this.setDetailLabelTextRendererStyles);

			//layout group
			this.getStyleProviderForClass(LayoutGroup).setFunctionForStyleName(LayoutGroup.ALTERNATE_STYLE_NAME_TOOLBAR, setToolbarLayoutGroupStyles);

			//list (see also: item renderers)
			this.getStyleProviderForClass(List).defaultStyleFunction = this.setListStyles;
			this.getStyleProviderForClass(DefaultListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(DefaultListItemRenderer.ALTERNATE_STYLE_NAME_DRILL_DOWN, this.setDrillDownItemRendererStyles);
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(DefaultListItemRenderer.ALTERNATE_STYLE_NAME_CHECK, this.setCheckItemRendererStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_LABEL, this.setItemRendererLabelStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL, this.setItemRendererAccessoryLabelStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_ICON_LABEL, this.setItemRendererIconLabelStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(THEME_STYLE_NAME_CHECK_ITEM_RENDERER_LABEL, this.setCheckItemRendererLabelStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(THEME_STYLE_NAME_CHECK_ITEM_RENDERER_ICON_LABEL, this.setCheckItemRendererIconLabelStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(THEME_STYLE_NAME_CHECK_ITEM_RENDERER_ACCESSORY_LABEL, this.setCheckItemRendererAccessoryLabelStyles);

			//numeric stepper
			this.getStyleProviderForClass(NumericStepper).defaultStyleFunction = this.setNumericStepperStyles;
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_TEXT_INPUT, this.setNumericStepperTextInputStyles);
			this.getStyleProviderForClass(TextBlockTextEditor).setFunctionForStyleName(THEME_STYLE_NAME_NUMERIC_STEPPER_TEXT_INPUT_EDITOR, this.setNumericStepperTextInputEditorStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON, this.setNumericStepperButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON, this.setNumericStepperButtonStyles);

			//page indicator
			this.getStyleProviderForClass(PageIndicator).defaultStyleFunction = this.setPageIndicatorStyles;

			//panel
			this.getStyleProviderForClass(Panel).defaultStyleFunction = this.setPanelStyles;
			this.getStyleProviderForClass(Header).setFunctionForStyleName(Panel.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setPopUpHeaderStyles);

			//panel screen
			this.getStyleProviderForClass(PanelScreen).defaultStyleFunction = this.setPanelScreenStyles;
			this.getStyleProviderForClass(Header).setFunctionForStyleName(PanelScreen.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setPanelScreenHeaderStyles);

			//picker list (see also: list and item renderers)
			this.getStyleProviderForClass(PickerList).defaultStyleFunction = this.setPickerListStyles;
			this.getStyleProviderForClass(List).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_LIST, this.setPickerListPopUpListStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setPickerListButtonStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setPickerListButtonStyles);

			//progress bar
			this.getStyleProviderForClass(ProgressBar).defaultStyleFunction = this.setProgressBarStyles;

			//radio
			this.getStyleProviderForClass(Radio).defaultStyleFunction = this.setRadioStyles;
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(Radio.DEFAULT_CHILD_STYLE_NAME_LABEL, this.setRadioLabelStyles);

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
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Slider.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setSimpleButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK, this.setHorizontalSliderMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SLIDER_MAXIMUM_TRACK, this.setHorizontalSliderMaximumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK, this.setVerticalSliderMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SLIDER_MAXIMUM_TRACK, this.setVerticalSliderMaximumTrackStyles);

			//spinner list
			this.getStyleProviderForClass(SpinnerList).defaultStyleFunction = this.setSpinnerListStyles;
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER, this.setSpinnerListItemRendererStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER_LABEL, this.setSpinnerListItemRendererLabelStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER_ICON_LABEL, this.setSpinnerListItemRendererIconLabelStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER_ACCESSORY_LABEL, this.setSpinnerListItemRendererAccessoryLabelStyles);

			//tab bar
			this.getStyleProviderForClass(TabBar).defaultStyleFunction = this.setTabBarStyles;
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(TabBar.DEFAULT_CHILD_STYLE_NAME_TAB, this.setTabStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(THEME_STYLE_NAME_TAB_LABEL, this.setTabLabelStyles);

			//text input
			this.getStyleProviderForClass(TextInput).defaultStyleFunction = this.setTextInputStyles;
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName(TextInput.ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT, this.setSearchTextInputStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(TextInput.DEFAULT_CHILD_STYLE_NAME_PROMPT, this.setTextInputPromptStyles);
			this.getStyleProviderForClass(StageTextTextEditor).setFunctionForStyleName(TextInput.DEFAULT_CHILD_STYLE_NAME_TEXT_EDITOR, this.setTextInputTextEditorStyles);
			this.getStyleProviderForClass(TextCallout).setFunctionForStyleName(TextInput.DEFAULT_CHILD_STYLE_NAME_ERROR_CALLOUT, this.setTextInputErrorCalloutStyles);

			//text area
			this.getStyleProviderForClass(TextArea).defaultStyleFunction = this.setTextAreaStyles;
			this.getStyleProviderForClass(TextFieldTextEditorViewPort).setFunctionForStyleName(TextArea.DEFAULT_CHILD_STYLE_NAME_TEXT_EDITOR, this.setTextAreaTextEditorStyles);
			this.getStyleProviderForClass(TextCallout).setFunctionForStyleName(TextArea.DEFAULT_CHILD_STYLE_NAME_ERROR_CALLOUT, this.setTextAreaErrorCalloutStyles);

			//text callout
			this.getStyleProviderForClass(TextCallout).defaultStyleFunction = this.setTextCalloutStyles;
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(TextCallout.DEFAULT_CHILD_STYLE_NAME_TEXT_RENDERER, this.setTextCalloutTextRendererStyles);

			//toggle button
			this.getStyleProviderForClass(ToggleButton).defaultStyleFunction = this.setButtonStyles;
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);

			//toggle switch
			this.getStyleProviderForClass(ToggleSwitch).defaultStyleFunction = this.setToggleSwitchStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setSimpleButtonStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setSimpleButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_ON_TRACK, this.setToggleSwitchTrackStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_OFF_LABEL, this.setToggleSwitchOffLabelStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_ON_LABEL, this.setToggleSwitchOnLabelStyles);
			//we don't need a style function for the off track in this theme
			//the toggle switch layout uses a single track
			
			//media controls
			
			//play/pause toggle button
			this.getStyleProviderForClass(PlayPauseToggleButton).defaultStyleFunction = this.setPlayPauseToggleButtonStyles;
			this.getStyleProviderForClass(PlayPauseToggleButton).setFunctionForStyleName(PlayPauseToggleButton.ALTERNATE_STYLE_NAME_OVERLAY_PLAY_PAUSE_TOGGLE_BUTTON, this.setOverlayPlayPauseToggleButtonStyles);

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
		}

		protected function setSimpleButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			button.defaultSkin = skin;
			
			button.hasLabelTextRenderer = false;

			button.minWidth = button.minHeight = this.controlSize;
			button.minTouchWidth = button.minTouchHeight = this.gridSize;
		}

	//-------------------------
	// Alert
	//-------------------------

		protected function setAlertStyles(alert:Alert):void
		{
			this.setScrollerStyles(alert);

			var backgroundSkin:Image = new Image(this.backgroundLightBorderSkinTexture);
			backgroundSkin.scale9Grid = SMALL_BACKGROUND_SCALE9_GRID;
			alert.backgroundSkin = backgroundSkin;

			alert.paddingTop = this.gutterSize;
			alert.paddingRight = this.gutterSize;
			alert.paddingBottom = this.smallGutterSize;
			alert.paddingLeft = this.gutterSize;
			alert.outerPadding = this.borderSize;
			alert.gap = this.smallGutterSize;
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
			group.gap = this.smallGutterSize;
			group.padding = this.smallGutterSize;
			group.customButtonStyleName = THEME_STYLE_NAME_ALERT_BUTTON_GROUP_BUTTON;
		}

		protected function setAlertButtonGroupButtonStyles(button:Button):void
		{
			this.setButtonStyles(button);
			button.minWidth = 2 * this.controlSize;
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
			button.paddingTop = this.smallControlGutterSize;
			button.paddingBottom = this.smallControlGutterSize;
			button.paddingLeft = this.gutterSize;
			button.paddingRight = this.gutterSize;
			button.gap = this.smallControlGutterSize;
			button.minGap = this.smallControlGutterSize;
			button.minWidth = button.minHeight = this.controlSize;
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
				skin.selectedTexture = this.buttonSelectedUpSkinTexture;
				skin.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.buttonSelectedDisabledSkinTexture);
			}
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			button.defaultSkin = skin;
			this.setBaseButtonStyles(button);
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
		}

		protected function setQuietButtonStyles(button:Button):void
		{
			var defaultSkin:Quad = new Quad(this.controlSize, this.controlSize, 0xff00ff);
			defaultSkin.alpha = 0;
			button.defaultSkin = defaultSkin;
			
			var otherSkin:ImageSkin = new ImageSkin(null);
			otherSkin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			otherSkin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			button.downSkin = otherSkin;
			button.disabledSkin = otherSkin;
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				otherSkin.selectedTexture = this.buttonSelectedUpSkinTexture;
				ToggleButton(button).defaultSelectedSkin = otherSkin;
			}
			otherSkin.scale9Grid = BUTTON_SCALE9_GRID;
			otherSkin.width = this.controlSize;
			otherSkin.height = this.controlSize;
			
			button.customLabelStyleName = THEME_STYLE_NAME_QUIET_BUTTON_LABEL;

			button.paddingTop = this.smallControlGutterSize;
			button.paddingBottom = this.smallControlGutterSize;
			button.paddingLeft = this.smallGutterSize;
			button.paddingRight = this.smallGutterSize;
			button.gap = this.smallControlGutterSize;
			button.minGap = this.smallControlGutterSize;
			button.minWidth = button.minHeight = this.controlSize;
			button.minTouchWidth = button.minTouchHeight = this.gridSize;
		}
		
		protected function setQuietButtonLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightUIElementFormat;
			textRenderer.selectedElementFormat = this.darkUIElementFormat;
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
			
			button.paddingLeft = this.gutterSize + this.smallGutterSize;
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
			
			button.paddingRight = this.gutterSize + this.smallGutterSize;
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
				skin.selectedTexture = this.buttonSelectedUpSkinTexture;
				skin.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.buttonSelectedDisabledSkinTexture);
			}
			skin.scale9Grid = BUTTON_SCALE9_GRID;
			skin.width = this.gridSize;
			skin.height = this.gridSize;
			button.defaultSkin = skin;
			
			button.customLabelStyleName = THEME_STYLE_NAME_BUTTON_GROUP_BUTTON_LABEL;

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
		
		protected function setButtonGroupButtonLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.largeUIDarkElementFormat;
			textRenderer.disabledElementFormat = this.largeUIDarkDisabledElementFormat;
		}

	//-------------------------
	// Callout
	//-------------------------

		protected function setCalloutStyles(callout:Callout):void
		{
			var backgroundSkin:Image = new Image(this.backgroundLightBorderSkinTexture);
			backgroundSkin.scale9Grid = SMALL_BACKGROUND_SCALE9_GRID;
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

			callout.padding = this.smallGutterSize;
		}

		protected function setDangerCalloutStyles(callout:Callout):void
		{
			var backgroundSkin:Image = new Image(this.backgroundDangerBorderSkinTexture);
			backgroundSkin.scale9Grid = SMALL_BACKGROUND_SCALE9_GRID;
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

			callout.padding = this.smallGutterSize;
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

			check.horizontalAlign = HorizontalAlign.LEFT;
			check.gap = this.smallControlGutterSize;
			check.minGap = this.smallControlGutterSize;
			check.minWidth = this.controlSize;
			check.minHeight = this.controlSize;
			check.minTouchWidth = this.gridSize;
			check.minTouchHeight = this.gridSize;
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
			this.setSpinnerListStyles(list);
			list.customItemRendererStyleName = THEME_STYLE_NAME_DATE_TIME_SPINNER_LIST_ITEM_RENDERER;
		}

		protected function setDateTimeSpinnerListItemRendererStyles(itemRenderer:DefaultListItemRenderer):void
		{
			this.setSpinnerListItemRendererStyles(itemRenderer);
			itemRenderer.accessoryPosition = RelativePosition.LEFT;
			itemRenderer.gap = this.smallGutterSize;
			itemRenderer.minGap = this.smallGutterSize;
			itemRenderer.accessoryGap = this.smallGutterSize;
			itemRenderer.minAccessoryGap = this.smallGutterSize;
		}
		
	//-------------------------
	// Drawers
	//-------------------------

		protected function setDrawersStyles(drawers:Drawers):void
		{
			var overlaySkin:Quad = new Quad(10, 10, DRAWER_OVERLAY_COLOR);
			overlaySkin.alpha = DRAWER_OVERLAY_ALPHA;
			drawers.overlaySkin = overlaySkin;

			var topDrawerDivider:Quad = new Quad(this.borderSize, this.borderSize, DRAWER_OVERLAY_COLOR);
			drawers.topDrawerDivider = topDrawerDivider;

			var rightDrawerDivider:Quad = new Quad(this.borderSize, this.borderSize, DRAWER_OVERLAY_COLOR);
			drawers.rightDrawerDivider = rightDrawerDivider;

			var bottomDrawerDivider:Quad = new Quad(this.borderSize, this.borderSize, DRAWER_OVERLAY_COLOR);
			drawers.bottomDrawerDivider = bottomDrawerDivider;

			var leftDrawerDivider:Quad = new Quad(this.borderSize, this.borderSize, DRAWER_OVERLAY_COLOR);
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

		protected function setGroupedListHeaderRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			renderer.backgroundSkin = new Quad(1, 1, GROUPED_LIST_HEADER_BACKGROUND_COLOR);

			renderer.horizontalAlign = HorizontalAlign.LEFT;
			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.smallGutterSize + this.gutterSize;
			renderer.paddingRight = this.gutterSize;
		}

		protected function setGroupedListFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			renderer.backgroundSkin = new Quad(1, 1, GROUPED_LIST_FOOTER_BACKGROUND_COLOR);
			
			renderer.customContentLabelStyleName = THEME_STYLE_NAME_GROUPED_LIST_FOOTER_CONTENT_LABEL;

			renderer.horizontalAlign = HorizontalAlign.CENTER;
			renderer.paddingTop = renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.smallGutterSize + this.gutterSize;
			renderer.paddingRight = this.gutterSize;
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

		protected function setInsetGroupedListStyles(list:GroupedList):void
		{
			list.customItemRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_ITEM_RENDERER;
			list.customFirstItemRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FIRST_ITEM_RENDERER;
			list.customLastItemRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_LAST_ITEM_RENDERER;
			list.customSingleItemRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_SINGLE_ITEM_RENDERER;
			list.customHeaderRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_HEADER_RENDERER;
			list.customFooterRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FOOTER_RENDERER;

			var layout:VerticalLayout = new VerticalLayout();
			layout.useVirtualLayout = true;
			layout.padding = this.smallGutterSize;
			layout.gap = 0;
			layout.horizontalAlign = HorizontalAlign.JUSTIFY;
			layout.verticalAlign = VerticalAlign.TOP;
			list.layout = layout;
		}

		protected function setInsetGroupedListItemRendererStyles(renderer:DefaultGroupedListItemRenderer, defaultSkinTexture:Texture, selectedAndDownSkinTexture:Texture, scale9Grid:Rectangle):void
		{
			var skin:ImageSkin = new ImageSkin(defaultSkinTexture);
			skin.selectedTexture = selectedAndDownSkinTexture;
			skin.setTextureForState(ButtonState.DOWN, selectedAndDownSkinTexture);
			skin.scale9Grid = scale9Grid;
			skin.width = this.gridSize;
			skin.height = this.gridSize;
			renderer.defaultSkin = skin;

			renderer.horizontalAlign = HorizontalAlign.LEFT;
			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize + this.smallGutterSize;
			renderer.paddingRight = this.gutterSize;
			renderer.gap = this.gutterSize;
			renderer.minGap = this.gutterSize;
			renderer.iconPosition = RelativePosition.LEFT;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.minAccessoryGap = this.gutterSize;
			renderer.accessoryPosition = RelativePosition.RIGHT;
			renderer.minWidth = renderer.minHeight = this.gridSize;
			renderer.minTouchWidth = renderer.minTouchHeight = this.gridSize;
		}

		protected function setInsetGroupedListMiddleItemRendererStyles(renderer:DefaultGroupedListItemRenderer):void
		{
			this.setInsetGroupedListItemRendererStyles(renderer, this.insetItemRendererUpSkinTexture, this.insetItemRendererSelectedSkinTexture, INSET_ITEM_RENDERER_MIDDLE_SCALE9_GRID);
		}

		protected function setInsetGroupedListFirstItemRendererStyles(renderer:DefaultGroupedListItemRenderer):void
		{
			this.setInsetGroupedListItemRendererStyles(renderer, this.insetItemRendererFirstUpSkinTexture, this.insetItemRendererFirstSelectedSkinTexture, INSET_ITEM_RENDERER_FIRST_SCALE9_GRID);
		}

		protected function setInsetGroupedListLastItemRendererStyles(renderer:DefaultGroupedListItemRenderer):void
		{
			this.setInsetGroupedListItemRendererStyles(renderer, this.insetItemRendererLastUpSkinTexture, this.insetItemRendererLastSelectedSkinTexture, INSET_ITEM_RENDERER_LAST_SCALE9_GRID);
		}

		protected function setInsetGroupedListSingleItemRendererStyles(renderer:DefaultGroupedListItemRenderer):void
		{
			this.setInsetGroupedListItemRendererStyles(renderer, this.insetItemRendererSingleUpSkinTexture, this.insetItemRendererSingleSelectedSkinTexture, INSET_ITEM_RENDERER_SINGLE_SCALE9_GRID);
		}

		protected function setInsetGroupedListHeaderRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			var defaultSkin:Quad = new Quad(1, 1, 0xff00ff);
			defaultSkin.alpha = 0;
			renderer.backgroundSkin = defaultSkin;

			renderer.horizontalAlign = HorizontalAlign.LEFT;
			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize + this.smallGutterSize;
			renderer.paddingRight = this.gutterSize;
			renderer.minWidth = this.controlSize;
			renderer.minHeight = this.controlSize;
		}

		protected function setInsetGroupedListFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			var defaultSkin:Quad = new Quad(1, 1, 0xff00ff);
			defaultSkin.alpha = 0;
			renderer.backgroundSkin = defaultSkin;

			renderer.customContentLabelStyleName = THEME_STYLE_NAME_GROUPED_LIST_FOOTER_CONTENT_LABEL;

			renderer.horizontalAlign = HorizontalAlign.CENTER;
			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize + this.smallGutterSize;
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

			var backgroundSkin:Image = new Image(this.headerBackgroundSkinTexture);
			backgroundSkin.tileGrid = new Rectangle();
			backgroundSkin.width = this.gridSize;
			backgroundSkin.height = this.gridSize;
			header.backgroundSkin = backgroundSkin;
		}
		
		protected function setHeaderTitleStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.headerElementFormat;
			textRenderer.disabledElementFormat = this.headerDisabledElementFormat;
		}

	//-------------------------
	// Label
	//-------------------------

		protected function setLabelTextRendererStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightElementFormat;
			textRenderer.disabledElementFormat = this.disabledElementFormat;
		}

		protected function setHeadingLabelStyles(label:Label):void
		{
			label.customTextRendererStyleName = THEME_STYLE_NAME_HEADING_LABEL_TEXT_RENDERER;
		}

		protected function setHeadingLabelTextRendererStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.largeLightElementFormat;
			textRenderer.disabledElementFormat = this.largeDisabledElementFormat;
		}

		protected function setDetailLabelStyles(label:Label):void
		{
			label.customTextRendererStyleName = THEME_STYLE_NAME_DETAIL_LABEL_TEXT_RENDERER;
		}

		protected function setDetailLabelTextRendererStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.smallLightElementFormat;
			textRenderer.disabledElementFormat = this.smallDisabledElementFormat;
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

			var backgroundSkin:Image = new Image(this.headerBackgroundSkinTexture);
			backgroundSkin.tileGrid = new Rectangle();
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
			var backgroundSkin:Quad = new Quad(this.gridSize, this.gridSize, LIST_BACKGROUND_COLOR);
			list.backgroundSkin = backgroundSkin;
		}

		protected function setItemRendererStyles(renderer:BaseDefaultItemRenderer):void
		{
			var skin:ImageSkin = new ImageSkin(this.itemRendererUpSkinTexture);
			skin.selectedTexture = this.itemRendererSelectedSkinTexture;
			skin.setTextureForState(ButtonState.DOWN, this.itemRendererSelectedSkinTexture);
			skin.scale9Grid = ITEM_RENDERER_SCALE9_GRID;
			skin.width = this.gridSize;
			skin.height = this.gridSize;
			renderer.defaultSkin = skin;

			renderer.horizontalAlign = HorizontalAlign.LEFT;
			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;
			renderer.paddingRight = this.gutterSize;
			renderer.gap = this.gutterSize;
			renderer.minGap = this.gutterSize;
			renderer.iconPosition = RelativePosition.LEFT;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.minAccessoryGap = this.gutterSize;
			renderer.accessoryPosition = RelativePosition.RIGHT;
			renderer.minWidth = this.gridSize;
			renderer.minHeight = this.gridSize;
			renderer.minTouchWidth = this.gridSize;
			renderer.minTouchHeight = this.gridSize;
		}
		
		protected function setDrillDownItemRendererStyles(itemRenderer:DefaultListItemRenderer):void
		{
			this.setItemRendererStyles(itemRenderer);
			
			itemRenderer.itemHasAccessory = false;

			var accessorySkin:ImageSkin = new ImageSkin(this.listDrillDownAccessoryTexture);
			accessorySkin.selectedTexture = this.listDrillDownAccessorySelectedTexture;
			accessorySkin.setTextureForState(ButtonState.DOWN, this.listDrillDownAccessorySelectedTexture);
			itemRenderer.defaultAccessory = accessorySkin;
		}

		protected function setCheckItemRendererStyles(renderer:BaseDefaultItemRenderer):void
		{
			var skin:ImageSkin = new ImageSkin(this.itemRendererUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.itemRendererSelectedSkinTexture);
			skin.scale9Grid = ITEM_RENDERER_SCALE9_GRID;
			skin.width = this.gridSize;
			skin.height = this.gridSize;
			renderer.defaultSkin = skin;

			var defaultSelectedIcon:ImageLoader = new ImageLoader();
			defaultSelectedIcon.source = this.pickerListItemSelectedIconTexture;
			renderer.defaultSelectedIcon = defaultSelectedIcon;
			defaultSelectedIcon.validate();

			var defaultIcon:Quad = new Quad(defaultSelectedIcon.width, defaultSelectedIcon.height, 0xff00ff);
			defaultIcon.alpha = 0;
			renderer.defaultIcon = defaultIcon;

			renderer.customLabelStyleName = THEME_STYLE_NAME_CHECK_ITEM_RENDERER_LABEL;
			renderer.customIconLabelStyleName = THEME_STYLE_NAME_CHECK_ITEM_RENDERER_ICON_LABEL;
			renderer.customAccessoryLabelStyleName = THEME_STYLE_NAME_CHECK_ITEM_RENDERER_ACCESSORY_LABEL;

			renderer.itemHasIcon = false;
			renderer.horizontalAlign = HorizontalAlign.LEFT;
			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;
			renderer.paddingRight = this.gutterSize;
			renderer.gap = Number.POSITIVE_INFINITY;
			renderer.minGap = this.gutterSize;
			renderer.iconPosition = RelativePosition.RIGHT;
			renderer.accessoryGap = this.smallGutterSize;
			renderer.minAccessoryGap = this.smallGutterSize;
			renderer.accessoryPosition = RelativePosition.BOTTOM;
			renderer.layoutOrder = ItemRendererLayoutOrder.LABEL_ACCESSORY_ICON;
			renderer.minWidth = this.gridSize;
			renderer.minHeight = this.gridSize;
			renderer.minTouchWidth = this.gridSize;
			renderer.minTouchHeight = this.gridSize;
		}

		protected function setItemRendererLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.largeLightElementFormat;
			textRenderer.disabledElementFormat = this.largeDisabledElementFormat;
			textRenderer.selectedElementFormat = this.largeDarkElementFormat;
			textRenderer.setElementFormatForState(ToggleButton.STATE_DOWN, this.largeDarkElementFormat);
		}

		protected function setItemRendererAccessoryLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightElementFormat;
			textRenderer.disabledElementFormat = this.disabledElementFormat;
			textRenderer.selectedElementFormat = this.darkElementFormat;
			textRenderer.setElementFormatForState(ToggleButton.STATE_DOWN, this.darkElementFormat);
		}

		protected function setItemRendererIconLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightElementFormat;
			textRenderer.disabledElementFormat = this.disabledElementFormat;
			textRenderer.selectedElementFormat = this.darkElementFormat;
			textRenderer.setElementFormatForState(ToggleButton.STATE_DOWN, this.darkElementFormat);
		}

		protected function setCheckItemRendererLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.largeLightElementFormat;
			textRenderer.disabledElementFormat = this.largeDisabledElementFormat;
			textRenderer.setElementFormatForState(ToggleButton.STATE_DOWN, this.largeDarkElementFormat);
		}

		protected function setCheckItemRendererAccessoryLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightElementFormat;
			textRenderer.disabledElementFormat = this.disabledElementFormat;
		}

		protected function setCheckItemRendererIconLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightElementFormat;
			textRenderer.disabledElementFormat = this.disabledElementFormat;
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
			var backgroundSkin:Image = new Image(this.backgroundSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
			backgroundSkin.width = this.controlSize;
			backgroundSkin.height = this.controlSize;
			input.backgroundSkin = backgroundSkin;

			var backgroundDisabledSkin:Image = new Image(this.backgroundDisabledSkinTexture);
			backgroundDisabledSkin.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
			backgroundDisabledSkin.width = this.controlSize;
			backgroundDisabledSkin.height = this.controlSize;
			input.backgroundDisabledSkin = backgroundDisabledSkin;

			var backgroundFocusedSkin:Image = new Image(this.backgroundInsetFocusedSkinTexture);
			backgroundFocusedSkin.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
			backgroundFocusedSkin.width = this.controlSize;
			backgroundFocusedSkin.height = this.controlSize;
			input.backgroundFocusedSkin = backgroundFocusedSkin;

			input.textEditorFactory = stepperTextEditorFactory;
			input.customTextEditorStyleName = THEME_STYLE_NAME_NUMERIC_STEPPER_TEXT_INPUT_EDITOR;

			input.minWidth = this.controlSize;
			input.minHeight = this.controlSize;
			input.minTouchWidth = this.gridSize;
			input.minTouchHeight = this.gridSize;
			input.gap = this.smallControlGutterSize;
			input.paddingTop = this.smallControlGutterSize;
			input.paddingRight = this.smallGutterSize;
			input.paddingBottom = this.smallControlGutterSize;
			input.paddingLeft = this.smallGutterSize;
			input.isEditable = false;
			input.isSelectable = false;
		}
		
		protected function setNumericStepperTextInputEditorStyles(textEditor:TextBlockTextEditor):void
		{
			textEditor.elementFormat = this.lightUIElementFormat;
			textEditor.disabledElementFormat = this.lightUIDisabledElementFormat;
			textEditor.textAlign = TextBlockTextEditor.TEXT_ALIGN_CENTER;
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

			var backgroundSkin:Image = new Image(this.backgroundLightBorderSkinTexture);
			backgroundSkin.scale9Grid = SMALL_BACKGROUND_SCALE9_GRID;
			panel.backgroundSkin = backgroundSkin;
			panel.padding = this.smallGutterSize;
			panel.outerPadding = this.borderSize;
		}

		protected function setPopUpHeaderStyles(header:Header):void
		{
			header.minWidth = this.gridSize;
			header.minHeight = this.gridSize;
			header.padding = this.smallGutterSize;
			header.gap = this.smallGutterSize;
			header.titleGap = this.smallGutterSize;

			var backgroundSkin:Image = new Image(this.popUpHeaderBackgroundSkinTexture);
			backgroundSkin.tileGrid = new Rectangle();
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
				
				var backgroundSkin:Image = new Image(this.backgroundSkinTexture);
				backgroundSkin.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
				backgroundSkin.width = this.gridSize;
				backgroundSkin.height = this.gridSize;
				list.backgroundSkin = backgroundSkin;
				list.padding = this.smallGutterSize;
				
				var layout:VerticalLayout = new VerticalLayout();
				layout.horizontalAlign = HorizontalAlign.JUSTIFY;
				layout.requestedRowCount = 4;
				list.layout = layout;
			}

			list.customItemRendererStyleName = DefaultListItemRenderer.ALTERNATE_STYLE_NAME_CHECK;
		}

		protected function setPickerListButtonStyles(button:Button):void
		{
			this.setButtonStyles(button);

			var icon:ImageSkin = new ImageSkin(this.pickerListButtonIconTexture);
			icon.selectedTexture = this.pickerListButtonSelectedIconTexture;
			icon.setTextureForState(ButtonState.DISABLED, this.pickerListButtonIconDisabledTexture);
			button.defaultIcon = icon;

			button.gap = Number.POSITIVE_INFINITY;
			button.minGap = this.gutterSize;
			button.iconPosition = RelativePosition.RIGHT;
		}
		
	//-------------------------
	// ProgressBar
	//-------------------------

		protected function setProgressBarStyles(progress:ProgressBar):void
		{
			var backgroundSkin:Image = new Image(this.backgroundSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
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
			backgroundDisabledSkin.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
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
				fillSkin.height = this.smallControlSize;
			}
			else
			{
				fillSkin.width = this.smallControlSize;
				fillSkin.height = this.smallControlSize;
			}
			progress.fillSkin = fillSkin;

			var fillDisabledSkin:Image = new Image(this.buttonDisabledSkinTexture);
			fillDisabledSkin.scale9Grid = BUTTON_SCALE9_GRID;
			if(progress.direction == Direction.VERTICAL)
			{
				fillDisabledSkin.width = this.smallControlSize;
				fillDisabledSkin.height = this.smallControlSize;
			}
			else
			{
				fillDisabledSkin.width = this.smallControlSize;
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

			radio.horizontalAlign = HorizontalAlign.LEFT;
			radio.gap = this.smallControlGutterSize;
			radio.minGap = this.smallControlGutterSize;
			radio.minWidth = this.controlSize;
			radio.minHeight = this.controlSize;
			radio.minTouchWidth = this.gridSize;
			radio.minTouchHeight = this.gridSize;
		}
		
		protected function setRadioLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightUIElementFormat;
			textRenderer.disabledElementFormat = this.lightUIDisabledElementFormat;
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
				layout.verticalAlign = VerticalAlign.MIDDLE;
				container.layout = layout;
			}
			container.minWidth = this.gridSize;
			container.minHeight = this.gridSize;

			var backgroundSkin:Image = new Image(this.headerBackgroundSkinTexture);
			backgroundSkin.tileGrid = new Rectangle();
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
			var defaultSkin:Image = new Image(this.horizontalScrollBarThumbSkinTexture);
			defaultSkin.scale9Grid = HORIZONTAL_SCROLL_BAR_THUMB_SCALE9_GRID;
			defaultSkin.width = this.smallGutterSize;
			thumb.defaultSkin = defaultSkin;
			thumb.hasLabelTextRenderer = false;
		}

		protected function setVerticalSimpleScrollBarThumbStyles(thumb:Button):void
		{
			var defaultSkin:Image = new Image(this.verticalScrollBarThumbSkinTexture);
			defaultSkin.scale9Grid = VERTICAL_SCROLL_BAR_THUMB_SCALE9_GRID;
			defaultSkin.height = this.smallGutterSize;
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
				slider.minWidth = this.controlSize;
			}
			else //horizontal
			{
				slider.customMinimumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK;
				slider.customMaximumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_SLIDER_MAXIMUM_TRACK;
				slider.minHeight = this.controlSize;
			}
		}

		protected function setHorizontalSliderMinimumTrackStyles(track:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.backgroundSkinTexture);
			skin.disabledTexture = this.backgroundDisabledSkinTexture;
			skin.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
			skin.width = this.wideControlSize;
			skin.height = this.controlSize;
			track.defaultSkin = skin;
			
			track.hasLabelTextRenderer = false;
		}

		protected function setHorizontalSliderMaximumTrackStyles(track:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.backgroundSkinTexture);
			skin.disabledTexture = this.backgroundDisabledSkinTexture;
			skin.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
			skin.width = this.wideControlSize;
			skin.height = this.controlSize;
			track.defaultSkin = skin;
			
			track.hasLabelTextRenderer = false;
		}

		protected function setVerticalSliderMinimumTrackStyles(track:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.backgroundSkinTexture);
			skin.disabledTexture = this.backgroundDisabledSkinTexture;
			skin.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.wideControlSize;
			track.defaultSkin = skin;
			
			track.hasLabelTextRenderer = false;
		}

		protected function setVerticalSliderMaximumTrackStyles(track:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.backgroundSkinTexture);
			skin.disabledTexture = this.backgroundDisabledSkinTexture;
			skin.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
			skin.width = this.controlSize;
			skin.height = this.wideControlSize;
			track.defaultSkin = skin;
			
			track.hasLabelTextRenderer = false;
		}

	//-------------------------
	// SpinnerList
	//-------------------------

		protected function setSpinnerListStyles(list:SpinnerList):void
		{
			this.setScrollerStyles(list);
			
			var backgroundSkin:Image = new Image(this.backgroundDarkBorderSkinTexture);
			backgroundSkin.scale9Grid = SMALL_BACKGROUND_SCALE9_GRID;
			list.backgroundSkin = backgroundSkin;
			
			var selectionOverlaySkin:Image = new Image(this.spinnerListSelectionOverlaySkinTexture);
			selectionOverlaySkin.scale9Grid = SPINNER_LIST_SELECTION_OVERLAY_SCALE9_GRID;
			list.selectionOverlaySkin = selectionOverlaySkin;
			
			list.customItemRendererStyleName = THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER;

			list.paddingTop = this.borderSize;
			list.paddingBottom = this.borderSize;
		}

		protected function setSpinnerListItemRendererStyles(renderer:DefaultListItemRenderer):void
		{
			var defaultSkin:Quad = new Quad(1, 1, 0xff00ff);
			defaultSkin.alpha = 0;
			renderer.defaultSkin = defaultSkin;
			
			renderer.customLabelStyleName = THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER_LABEL;
			renderer.customIconLabelStyleName = THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER_ICON_LABEL;
			renderer.customAccessoryLabelStyleName = THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER_ACCESSORY_LABEL;

			renderer.horizontalAlign = HorizontalAlign.LEFT;
			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;
			renderer.paddingRight = this.gutterSize;
			renderer.gap = this.gutterSize;
			renderer.minGap = this.gutterSize;
			renderer.iconPosition = RelativePosition.LEFT;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.minAccessoryGap = this.gutterSize;
			renderer.accessoryPosition = RelativePosition.RIGHT;
			renderer.minWidth = this.gridSize;
			renderer.minHeight = this.gridSize;
			renderer.minTouchWidth = this.gridSize;
			renderer.minTouchHeight = this.gridSize;
		}
		
		protected function setSpinnerListItemRendererLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.largeLightElementFormat;
			textRenderer.disabledElementFormat = this.largeDisabledElementFormat;
		}

		protected function setSpinnerListItemRendererIconLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightElementFormat;
			textRenderer.disabledElementFormat = this.disabledElementFormat;
		}

		protected function setSpinnerListItemRendererAccessoryLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightElementFormat;
			textRenderer.disabledElementFormat = this.disabledElementFormat;
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
			var skin:ImageSkin = new ImageSkin(this.tabUpSkinTexture);
			skin.selectedTexture = this.tabSelectedUpSkinTexture;
			skin.setTextureForState(ButtonState.DOWN, this.tabDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.tabDisabledSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED_AND_SELECTED, this.tabSelectedDisabledSkinTexture);
			skin.scale9Grid = TAB_SCALE9_GRID;
			skin.width = this.gridSize;
			skin.height = this.gridSize;
			tab.defaultSkin = skin;
			
			tab.customLabelStyleName = THEME_STYLE_NAME_TAB_LABEL;

			tab.paddingTop = this.smallGutterSize;
			tab.paddingBottom = this.smallGutterSize;
			tab.paddingLeft = this.gutterSize;
			tab.paddingRight = this.gutterSize;
			tab.gap = this.smallGutterSize;
			tab.minGap = this.smallGutterSize;
			tab.minWidth = tab.minHeight = this.gridSize;
			tab.minTouchWidth = tab.minTouchHeight = this.gridSize;
		}

		protected function setTabLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightUIElementFormat;
			textRenderer.disabledElementFormat = this.lightUIDisabledElementFormat;
			textRenderer.selectedElementFormat = this.darkUIElementFormat;
		}

	//-------------------------
	// TextArea
	//-------------------------

		protected function setTextAreaStyles(textArea:TextArea):void
		{
			this.setScrollerStyles(textArea);

			var skin:ImageSkin = new ImageSkin(this.backgroundInsetSkinTexture);
			skin.setTextureForState(TextInputState.DISABLED, this.backgroundDisabledSkinTexture);
			skin.setTextureForState(TextInputState.FOCUSED, this.backgroundInsetFocusedSkinTexture);
			skin.setTextureForState(TextInputState.ERROR, this.backgroundInsetDangerSkinTexture);
			skin.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
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
			this.setDangerCalloutStyles(callout);
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

		protected function setTextCalloutTextRendererStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightElementFormat;
		}

	//-------------------------
	// TextInput
	//-------------------------

		protected function setBaseTextInputStyles(input:TextInput):void
		{
			var skin:ImageSkin = new ImageSkin(this.backgroundInsetSkinTexture);
			skin.setTextureForState(TextInputState.DISABLED, this.backgroundInsetDisabledSkinTexture);
			skin.setTextureForState(TextInputState.FOCUSED, this.backgroundInsetFocusedSkinTexture);
			skin.setTextureForState(TextInputState.ERROR, this.backgroundInsetDangerSkinTexture);
			skin.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
			skin.width = this.wideControlSize;
			skin.height = this.controlSize;
			input.backgroundSkin = skin;

			input.minWidth = this.controlSize;
			input.minHeight = this.controlSize;
			input.minTouchWidth = this.gridSize;
			input.minTouchHeight = this.gridSize;
			input.gap = this.smallControlGutterSize;
			input.paddingTop = this.smallControlGutterSize;
			input.paddingRight = this.smallGutterSize;
			input.paddingBottom = this.smallControlGutterSize;
			input.paddingLeft = this.smallGutterSize;
			input.verticalAlign = VerticalAlign.MIDDLE;
		}

		protected function setTextInputStyles(input:TextInput):void
		{
			this.setBaseTextInputStyles(input);
		}
		
		protected function setTextInputTextEditorStyles(textEditor:StageTextTextEditor):void
		{
			textEditor.fontFamily = "Helvetica";
			textEditor.fontSize = this.regularFontSize;
			textEditor.color = LIGHT_TEXT_COLOR;
			textEditor.disabledColor = DISABLED_TEXT_COLOR;
		}

		protected function setTextInputPromptStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightElementFormat;
			textRenderer.disabledElementFormat = this.disabledElementFormat;
		}

		protected function setTextInputErrorCalloutStyles(callout:TextCallout):void
		{
			this.setDangerCalloutStyles(callout);
			callout.horizontalAlign = HorizontalAlign.LEFT;
			callout.verticalAlign = VerticalAlign.TOP;
		}

		protected function setSearchTextInputStyles(input:TextInput):void
		{
			this.setBaseTextInputStyles(input);

			var icon:ImageSkin = new ImageSkin(this.searchIconTexture);
			icon.setTextureForState(TextInputState.DISABLED, this.searchIconDisabledTexture);
			input.defaultIcon = icon;
		}

	//-------------------------
	// ToggleSwitch
	//-------------------------

		protected function setToggleSwitchStyles(toggle:ToggleSwitch):void
		{
			toggle.trackLayoutMode = TrackLayoutMode.SINGLE;
		}

		//see Shared section for thumb styles

		protected function setToggleSwitchTrackStyles(track:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.backgroundSkinTexture);
			skin.disabledTexture = this.backgroundDisabledSkinTexture;
			skin.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
			skin.width = Math.round(this.controlSize * 2.5);
			skin.height = this.controlSize;
			track.defaultSkin = skin;
			track.hasLabelTextRenderer = false;
		}

		protected function setToggleSwitchOffLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.lightUIElementFormat;
			textRenderer.disabledElementFormat = this.lightUIDisabledElementFormat;
		}
		
		protected function setToggleSwitchOnLabelStyles(textRenderer:TextBlockTextRenderer):void
		{
			textRenderer.elementFormat = this.selectedUIElementFormat;
			textRenderer.disabledElementFormat = this.lightUIDisabledElementFormat;
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
			button.minTouchWidth = this.gridSize;
			button.minTouchHeight = this.gridSize;
		}

		protected function setOverlayPlayPauseToggleButtonStyles(button:PlayPauseToggleButton):void
		{
			var icon:ImageSkin = new ImageSkin(null);
			icon.setTextureForState(ButtonState.UP, this.overlayPlayPauseButtonPlayUpIconTexture);
			icon.setTextureForState(ButtonState.HOVER, this.overlayPlayPauseButtonPlayUpIconTexture);
			icon.setTextureForState(ButtonState.DOWN, this.overlayPlayPauseButtonPlayDownIconTexture);
			button.defaultIcon = icon;

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
			button.minTouchWidth = this.gridSize;
			button.minTouchHeight = this.gridSize;
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

			button.hasLabelTextRenderer = false;
			button.showVolumeSliderOnHover = false;

			button.minWidth = this.controlSize;
			button.minHeight = this.controlSize;
			button.minTouchWidth = this.gridSize;
			button.minTouchHeight = this.gridSize;
		}

	//-------------------------
	// SeekSlider
	//-------------------------

		protected function setSeekSliderStyles(slider:SeekSlider):void
		{
			slider.trackLayoutMode = TrackLayoutMode.SPLIT;
			slider.showThumb = false;
			if(slider.direction == Direction.VERTICAL)
			{
				slider.minWidth = this.smallControlSize;
				slider.minHeight = this.controlSize;
			}
			else //horizontal
			{
				slider.minWidth = this.controlSize;
				slider.minHeight = this.smallControlSize;
			}
			var progressSkin:Image = new Image(this.seekSliderProgressSkinTexture);
			progressSkin.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
			progressSkin.width = this.smallControlSize;
			progressSkin.height = this.smallControlSize;
			slider.progressSkin = progressSkin;
		}

		protected function setSeekSliderThumbStyles(thumb:Button):void
		{
			var thumbSize:Number = 6;
			thumb.defaultSkin = new Quad(thumbSize, thumbSize);
			thumb.hasLabelTextRenderer = false;
			thumb.minTouchWidth = this.gridSize;
			thumb.minTouchHeight = this.gridSize;
		}

		protected function setSeekSliderMinimumTrackStyles(track:Button):void
		{
			var defaultSkin:Image = new Image(this.buttonUpSkinTexture);
			defaultSkin.scale9Grid = BUTTON_SCALE9_GRID;
			defaultSkin.width = this.wideControlSize;
			defaultSkin.height = this.smallControlSize;
			track.defaultSkin = defaultSkin;
			track.hasLabelTextRenderer = false;
			track.minTouchHeight = this.gridSize;
		}

		protected function setSeekSliderMaximumTrackStyles(track:Button):void
		{
			var defaultSkin:Image = new Image(this.backgroundSkinTexture);
			defaultSkin.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
			defaultSkin.width = this.wideControlSize;
			defaultSkin.height = this.smallControlSize;
			track.defaultSkin = defaultSkin;
			track.hasLabelTextRenderer = false;
			track.minTouchHeight = this.gridSize;
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
