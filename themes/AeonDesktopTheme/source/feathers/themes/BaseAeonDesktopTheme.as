/*
 Copyright (c) 2014 Josh Tynjala

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
	import feathers.controls.Callout;
	import feathers.controls.Check;
	import feathers.controls.Drawers;
	import feathers.controls.GroupedList;
	import feathers.controls.Header;
	import feathers.controls.IScrollBar;
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
	import feathers.controls.Screen;
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
	import feathers.controls.ToggleSwitch;
	import feathers.controls.popups.DropDownPopUpContentManager;
	import feathers.controls.renderers.BaseDefaultItemRenderer;
	import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.FocusManager;
	import feathers.core.ITextEditor;
	import feathers.core.ITextRenderer;
	import feathers.core.PopUpManager;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.skins.SmartDisplayObjectStateValueSelector;
	import feathers.skins.StandardIcons;
	import feathers.system.DeviceCapabilities;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;

	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.SubTexture;
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
		protected static const THEME_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON:String = "aeon-horizontal-scroll-bar-increment-button";
		protected static const THEME_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON:String = "aeon-horizontal-scroll-bar-decrement-button";
		protected static const THEME_NAME_HORIZONTAL_SCROLL_BAR_THUMB:String = "aeon-horizontal-scroll-bar-thumb";
		protected static const THEME_NAME_HORIZONTAL_SCROLL_BAR_MINIMUM_TRACK:String = "aeon-horizontal-scroll-bar-minimum-track";

		protected static const THEME_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON:String = "aeon-vertical-scroll-bar-increment-button";
		protected static const THEME_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON:String = "aeon-vertical-scroll-bar-decrement-button";
		protected static const THEME_NAME_VERTICAL_SCROLL_BAR_THUMB:String = "aeon-vertical-scroll-bar-thumb";
		protected static const THEME_NAME_VERTICAL_SCROLL_BAR_MINIMUM_TRACK:String = "aeon-vertical-scroll-bar-minimum-track";

		protected static const THEME_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB:String = "aeon-horizontal-simple-scroll-bar-thumb";
		protected static const THEME_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB:String = "aeon-vertical-simple-scroll-bar-thumb";

		protected static const THEME_NAME_HORIZONTAL_SLIDER_THUMB:String = "aeon-horizontal-slider-thumb";
		protected static const THEME_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK:String = "aeon-horizontal-slider-minimum-track";

		protected static const THEME_NAME_VERTICAL_SLIDER_THUMB:String = "aeon-vertical-slider-thumb";
		protected static const THEME_NAME_VERTICAL_SLIDER_MINIMUM_TRACK:String = "aeon-vertical-slider-minimum-track";

		protected static const ATLAS_NAME:String = "aeon";
		protected static const FONT_NAME:String = "_sans";

		protected static const FOCUS_INDICATOR_SCALE_9_GRID:Rectangle = new Rectangle(5, 4, 1, 14);
		protected static const BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(6, 6, 70, 10);
		protected static const SELECTED_BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(6, 6, 52, 10);
		protected static const TAB_SCALE_9_GRID:Rectangle = new Rectangle(4, 4, 55, 16);
		protected static const STEPPER_INCREMENT_BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(1, 9, 15, 1);
		protected static const STEPPER_DECREMENT_BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(1, 1, 15, 1);
		protected static const HSLIDER_FIRST_REGION:Number = 2;
		protected static const HSLIDER_SECOND_REGION:Number = 75;
		protected static const TEXT_INPUT_SCALE_9_GRID:Rectangle = new Rectangle(2, 2, 148, 18);
		protected static const VERTICAL_SCROLL_BAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(2, 5, 6, 42);
		protected static const VERTICAL_SCROLL_BAR_TRACK_SCALE_9_GRID:Rectangle = new Rectangle(2, 1, 11, 2);
		protected static const VERTICAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(2, 2, 11, 10);
		protected static const HORIZONTAL_SCROLL_BAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(5, 2, 42, 6);
		protected static const HORIZONTAL_SCROLL_BAR_TRACK_SCALE_9_GRID:Rectangle = new Rectangle(1, 2, 2, 11);
		protected static const HORIZONTAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(2, 2, 10, 11);
		protected static const SIMPLE_BORDER_SCALE_9_GRID:Rectangle = new Rectangle(2, 2, 2, 2);
		protected static const PANEL_BORDER_SCALE_9_GRID:Rectangle = new Rectangle(6, 6, 2, 2);
		protected static const HEADER_SCALE_9_GRID:Rectangle = new Rectangle(0, 0, 4, 28);

		protected static const BACKGROUND_COLOR:uint = 0x869CA7;
		protected static const MODAL_OVERLAY_COLOR:uint = 0xDDDDDD;
		protected static const PRIMARY_TEXT_COLOR:uint = 0x0B333C;
		protected static const DISABLED_TEXT_COLOR:uint = 0x5B6770;
		protected static const MODAL_OVERLAY_ALPHA:Number = 0.5;

		protected static function textRendererFactory():ITextRenderer
		{
			return new TextFieldTextRenderer();
		}

		protected static function textEditorFactory():ITextEditor
		{
			return new TextFieldTextEditor();
		}

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

		public function BaseAeonDesktopTheme()
		{
			super();
		}

		public function get originalDPI():int
		{
			return DeviceCapabilities.dpi;
		}

		public function get scaleToDPI():Boolean
		{
			return false;
		}

		protected var atlas:TextureAtlas;
		protected var atlasTexture:Texture;

		protected var defaultTextFormat:TextFormat;
		protected var disabledTextFormat:TextFormat;
		protected var headingTextFormat:TextFormat;
		protected var headingDisabledTextFormat:TextFormat;
		protected var detailTextFormat:TextFormat;
		protected var detailDisabledTextFormat:TextFormat;
		protected var headerTitleTextFormat:TextFormat;

		protected var focusIndicatorSkinTextures:Scale9Textures;

		protected var buttonUpSkinTextures:Scale9Textures;
		protected var buttonHoverSkinTextures:Scale9Textures;
		protected var buttonDownSkinTextures:Scale9Textures;
		protected var buttonDisabledSkinTextures:Scale9Textures;
		protected var buttonSelectedUpSkinTextures:Scale9Textures;
		protected var buttonSelectedHoverSkinTextures:Scale9Textures;
		protected var buttonSelectedDownSkinTextures:Scale9Textures;
		protected var buttonSelectedDisabledSkinTextures:Scale9Textures;

		protected var tabUpSkinTextures:Scale9Textures;
		protected var tabHoverSkinTextures:Scale9Textures;
		protected var tabDownSkinTextures:Scale9Textures;
		protected var tabDisabledSkinTextures:Scale9Textures;
		protected var tabSelectedUpSkinTextures:Scale9Textures;
		protected var tabSelectedDisabledSkinTextures:Scale9Textures;

		protected var stepperIncrementButtonUpSkinTextures:Scale9Textures;
		protected var stepperIncrementButtonHoverSkinTextures:Scale9Textures;
		protected var stepperIncrementButtonDownSkinTextures:Scale9Textures;
		protected var stepperIncrementButtonDisabledSkinTextures:Scale9Textures;

		protected var stepperDecrementButtonUpSkinTextures:Scale9Textures;
		protected var stepperDecrementButtonHoverSkinTextures:Scale9Textures;
		protected var stepperDecrementButtonDownSkinTextures:Scale9Textures;
		protected var stepperDecrementButtonDisabledSkinTextures:Scale9Textures;

		protected var hSliderThumbUpSkinTexture:Texture;
		protected var hSliderThumbHoverSkinTexture:Texture;
		protected var hSliderThumbDownSkinTexture:Texture;
		protected var hSliderThumbDisabledSkinTexture:Texture;
		protected var hSliderTrackSkinTextures:Scale3Textures;

		protected var vSliderThumbUpSkinTexture:Texture;
		protected var vSliderThumbHoverSkinTexture:Texture;
		protected var vSliderThumbDownSkinTexture:Texture;
		protected var vSliderThumbDisabledSkinTexture:Texture;
		protected var vSliderTrackSkinTextures:Scale3Textures;

		protected var itemRendererUpSkinTexture:Texture;
		protected var itemRendererHoverSkinTexture:Texture;
		protected var itemRendererSelectedUpSkinTexture:Texture;

		protected var headerBackgroundSkinTextures:Scale9Textures;
		protected var groupedListHeaderBackgroundSkinTextures:Scale9Textures;

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

		protected var textInputBackgroundSkinTextures:Scale9Textures;
		protected var textInputBackgroundDisabledSkinTextures:Scale9Textures;
		protected var textInputSearchIconTexture:Texture;

		protected var vScrollBarThumbUpSkinTextures:Scale9Textures;
		protected var vScrollBarThumbHoverSkinTextures:Scale9Textures;
		protected var vScrollBarThumbDownSkinTextures:Scale9Textures;
		protected var vScrollBarTrackSkinTextures:Scale9Textures;
		protected var vScrollBarThumbIconTexture:Texture;
		protected var vScrollBarStepButtonUpSkinTextures:Scale9Textures;
		protected var vScrollBarStepButtonHoverSkinTextures:Scale9Textures;
		protected var vScrollBarStepButtonDownSkinTextures:Scale9Textures;
		protected var vScrollBarStepButtonDisabledSkinTextures:Scale9Textures;
		protected var vScrollBarDecrementButtonIconTexture:Texture;
		protected var vScrollBarIncrementButtonIconTexture:Texture;

		protected var hScrollBarThumbUpSkinTextures:Scale9Textures;
		protected var hScrollBarThumbHoverSkinTextures:Scale9Textures;
		protected var hScrollBarThumbDownSkinTextures:Scale9Textures;
		protected var hScrollBarTrackSkinTextures:Scale9Textures;
		protected var hScrollBarThumbIconTexture:Texture;
		protected var hScrollBarStepButtonUpSkinTextures:Scale9Textures;
		protected var hScrollBarStepButtonHoverSkinTextures:Scale9Textures;
		protected var hScrollBarStepButtonDownSkinTextures:Scale9Textures;
		protected var hScrollBarStepButtonDisabledSkinTextures:Scale9Textures;
		protected var hScrollBarDecrementButtonIconTexture:Texture;
		protected var hScrollBarIncrementButtonIconTexture:Texture;

		protected var simpleBorderBackgroundSkinTextures:Scale9Textures;
		protected var panelBorderBackgroundSkinTextures:Scale9Textures;

		protected var progressBarFillSkinTexture:Texture;

		public function dispose():void
		{
			if(this.atlas)
			{
				this.atlas.dispose();
				this.atlas = null;
				//no need to dispose the atlas texture because the atlas will do that
				this.atlasTexture = null;
			}
		}

		protected function initializeStage():void
		{
			Starling.current.stage.color = BACKGROUND_COLOR;
			Starling.current.nativeStage.color = BACKGROUND_COLOR;
		}

		protected function initialize():void
		{
			this.initializeFonts();
			this.initializeTextures();
			this.initializeGlobals()
			this.initializeStage();
			this.initializeStyleProviders();
		}

		protected function initializeGlobals():void
		{
			FocusManager.isEnabled = true;

			FeathersControl.defaultTextRendererFactory = textRendererFactory;
			FeathersControl.defaultTextEditorFactory = textEditorFactory;

			PopUpManager.overlayFactory = popUpOverlayFactory;
			Callout.stagePaddingTop = Callout.stagePaddingRight = Callout.stagePaddingBottom =
				Callout.stagePaddingLeft = 16;
		}

		protected function initializeFonts():void
		{
			this.defaultTextFormat = new TextFormat(FONT_NAME, 11, PRIMARY_TEXT_COLOR, false, false, false, null, null, TextFormatAlign.LEFT, 0, 0, 0, 0);
			this.disabledTextFormat = new TextFormat(FONT_NAME, 11, DISABLED_TEXT_COLOR, false, false, false, null, null, TextFormatAlign.LEFT, 0, 0, 0, 0);
			this.headerTitleTextFormat = new TextFormat(FONT_NAME, 12, PRIMARY_TEXT_COLOR, false, false, false, null, null, TextFormatAlign.LEFT, 0, 0, 0, 0);
			this.headingTextFormat = new TextFormat(FONT_NAME, 14, PRIMARY_TEXT_COLOR, false, false, false, null, null, TextFormatAlign.LEFT, 0, 0, 0, 0);
			this.headingDisabledTextFormat = new TextFormat(FONT_NAME, 14, DISABLED_TEXT_COLOR, false, false, false, null, null, TextFormatAlign.LEFT, 0, 0, 0, 0);
			this.detailTextFormat = new TextFormat(FONT_NAME, 10, PRIMARY_TEXT_COLOR, false, false, false, null, null, TextFormatAlign.LEFT, 0, 0, 0, 0);
			this.detailDisabledTextFormat = new TextFormat(FONT_NAME, 10, DISABLED_TEXT_COLOR, false, false, false, null, null, TextFormatAlign.LEFT, 0, 0, 0, 0);
		}

		protected function initializeTextures():void
		{
			this.focusIndicatorSkinTextures = new Scale9Textures(this.atlas.getTexture("focus-indicator-skin"), FOCUS_INDICATOR_SCALE_9_GRID);

			this.buttonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-up-skin"), BUTTON_SCALE_9_GRID);
			this.buttonHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("button-hover-skin"), BUTTON_SCALE_9_GRID);
			this.buttonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("button-down-skin"), BUTTON_SCALE_9_GRID);
			this.buttonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("button-disabled-skin"), BUTTON_SCALE_9_GRID);
			this.buttonSelectedUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-selected-up-skin"), SELECTED_BUTTON_SCALE_9_GRID);
			this.buttonSelectedHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("button-selected-hover-skin"), SELECTED_BUTTON_SCALE_9_GRID);
			this.buttonSelectedDownSkinTextures = new Scale9Textures(this.atlas.getTexture("button-selected-down-skin"), SELECTED_BUTTON_SCALE_9_GRID);
			this.buttonSelectedDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("button-selected-disabled-skin"), SELECTED_BUTTON_SCALE_9_GRID);

			this.tabUpSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-up-skin"), TAB_SCALE_9_GRID);
			this.tabHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-hover-skin"), TAB_SCALE_9_GRID);
			this.tabDownSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-down-skin"), TAB_SCALE_9_GRID);
			this.tabDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-disabled-skin"), TAB_SCALE_9_GRID);
			this.tabSelectedUpSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-up-skin"), TAB_SCALE_9_GRID);
			this.tabSelectedDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-disabled-skin"), TAB_SCALE_9_GRID);

			this.stepperIncrementButtonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("numeric-stepper-increment-button-up-skin"), STEPPER_INCREMENT_BUTTON_SCALE_9_GRID);
			this.stepperIncrementButtonHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("numeric-stepper-increment-button-hover-skin"), STEPPER_INCREMENT_BUTTON_SCALE_9_GRID);
			this.stepperIncrementButtonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("numeric-stepper-increment-button-down-skin"), STEPPER_INCREMENT_BUTTON_SCALE_9_GRID);
			this.stepperIncrementButtonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("numeric-stepper-increment-button-disabled-skin"), STEPPER_INCREMENT_BUTTON_SCALE_9_GRID);

			this.stepperDecrementButtonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("numeric-stepper-decrement-button-up-skin"), STEPPER_DECREMENT_BUTTON_SCALE_9_GRID);
			this.stepperDecrementButtonHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("numeric-stepper-decrement-button-hover-skin"), STEPPER_DECREMENT_BUTTON_SCALE_9_GRID);
			this.stepperDecrementButtonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("numeric-stepper-decrement-button-down-skin"), STEPPER_DECREMENT_BUTTON_SCALE_9_GRID);
			this.stepperDecrementButtonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("numeric-stepper-decrement-button-disabled-skin"), STEPPER_DECREMENT_BUTTON_SCALE_9_GRID);

			this.hSliderThumbUpSkinTexture = this.atlas.getTexture("hslider-thumb-up-skin");
			this.hSliderThumbHoverSkinTexture = this.atlas.getTexture("hslider-thumb-hover-skin");
			this.hSliderThumbDownSkinTexture = this.atlas.getTexture("hslider-thumb-down-skin");
			this.hSliderThumbDisabledSkinTexture = this.atlas.getTexture("hslider-thumb-disabled-skin");
			this.hSliderTrackSkinTextures = new Scale3Textures(this.atlas.getTexture("hslider-track-skin"), HSLIDER_FIRST_REGION, HSLIDER_SECOND_REGION, Scale3Textures.DIRECTION_HORIZONTAL);

			this.vSliderThumbUpSkinTexture = this.atlas.getTexture("vslider-thumb-up-skin");
			this.vSliderThumbHoverSkinTexture = this.atlas.getTexture("vslider-thumb-hover-skin");
			this.vSliderThumbDownSkinTexture = this.atlas.getTexture("vslider-thumb-down-skin");
			this.vSliderThumbDisabledSkinTexture = this.atlas.getTexture("vslider-thumb-disabled-skin");
			this.vSliderTrackSkinTextures = new Scale3Textures(this.atlas.getTexture("vslider-track-skin"), HSLIDER_FIRST_REGION, HSLIDER_SECOND_REGION, Scale3Textures.DIRECTION_VERTICAL);

			this.itemRendererUpSkinTexture = this.atlas.getTexture("item-renderer-up-skin");
			this.itemRendererHoverSkinTexture = this.atlas.getTexture("item-renderer-hover-skin");
			this.itemRendererSelectedUpSkinTexture = this.atlas.getTexture("item-renderer-selected-up-skin");

			this.headerBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("header-background-skin"), HEADER_SCALE_9_GRID);
			this.groupedListHeaderBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("grouped-list-header-background-skin"), HEADER_SCALE_9_GRID);

			this.checkUpIconTexture = this.atlas.getTexture("check-up-icon");
			this.checkHoverIconTexture = this.atlas.getTexture("check-hover-icon");
			this.checkDownIconTexture = this.atlas.getTexture("check-down-icon");
			this.checkDisabledIconTexture = this.atlas.getTexture("check-disabled-icon");
			this.checkSelectedUpIconTexture = this.atlas.getTexture("check-selected-up-icon");
			this.checkSelectedHoverIconTexture = this.atlas.getTexture("check-selected-hover-icon");
			this.checkSelectedDownIconTexture = this.atlas.getTexture("check-selected-down-icon");
			this.checkSelectedDisabledIconTexture = this.atlas.getTexture("check-selected-disabled-icon");

			this.radioUpIconTexture = this.atlas.getTexture("radio-up-icon");
			this.radioHoverIconTexture = this.atlas.getTexture("radio-hover-icon");
			this.radioDownIconTexture = this.atlas.getTexture("radio-down-icon");
			this.radioDisabledIconTexture = this.atlas.getTexture("radio-disabled-icon");
			this.radioSelectedUpIconTexture = this.atlas.getTexture("radio-selected-up-icon");
			this.radioSelectedHoverIconTexture = this.atlas.getTexture("radio-selected-hover-icon");
			this.radioSelectedDownIconTexture = this.atlas.getTexture("radio-selected-down-icon");
			this.radioSelectedDisabledIconTexture = this.atlas.getTexture("radio-selected-disabled-icon");

			this.pageIndicatorNormalSkinTexture = this.atlas.getTexture("page-indicator-normal-skin");
			this.pageIndicatorSelectedSkinTexture = this.atlas.getTexture("page-indicator-selected-skin");

			this.pickerListUpIconTexture = this.atlas.getTexture("picker-list-up-icon");
			this.pickerListHoverIconTexture = this.atlas.getTexture("picker-list-hover-icon");
			this.pickerListDownIconTexture = this.atlas.getTexture("picker-list-down-icon");
			this.pickerListDisabledIconTexture = this.atlas.getTexture("picker-list-disabled-icon");

			this.textInputBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("text-input-background-skin"), TEXT_INPUT_SCALE_9_GRID);
			this.textInputBackgroundDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("text-input-background-disabled-skin"), TEXT_INPUT_SCALE_9_GRID);
			this.textInputSearchIconTexture = this.atlas.getTexture("search-icon");

			this.vScrollBarThumbUpSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-thumb-up-skin"), VERTICAL_SCROLL_BAR_THUMB_SCALE_9_GRID);
			this.vScrollBarThumbHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-thumb-hover-skin"), VERTICAL_SCROLL_BAR_THUMB_SCALE_9_GRID);
			this.vScrollBarThumbDownSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-thumb-down-skin"), VERTICAL_SCROLL_BAR_THUMB_SCALE_9_GRID);
			this.vScrollBarTrackSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-track-skin"), VERTICAL_SCROLL_BAR_TRACK_SCALE_9_GRID);
			this.vScrollBarThumbIconTexture = this.atlas.getTexture("vertical-scroll-bar-thumb-icon");
			this.vScrollBarStepButtonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-step-button-up-skin"), VERTICAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID);
			this.vScrollBarStepButtonHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-step-button-hover-skin"), VERTICAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID);
			this.vScrollBarStepButtonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-step-button-down-skin"), VERTICAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID);
			this.vScrollBarStepButtonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-step-button-disabled-skin"), VERTICAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID);
			this.vScrollBarDecrementButtonIconTexture = this.atlas.getTexture("vertical-scroll-bar-decrement-button-icon");
			this.vScrollBarIncrementButtonIconTexture = this.atlas.getTexture("vertical-scroll-bar-increment-button-icon");

			this.hScrollBarThumbUpSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-thumb-up-skin"), HORIZONTAL_SCROLL_BAR_THUMB_SCALE_9_GRID);
			this.hScrollBarThumbHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-thumb-hover-skin"), HORIZONTAL_SCROLL_BAR_THUMB_SCALE_9_GRID);
			this.hScrollBarThumbDownSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-thumb-down-skin"), HORIZONTAL_SCROLL_BAR_THUMB_SCALE_9_GRID);
			this.hScrollBarTrackSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-track-skin"), HORIZONTAL_SCROLL_BAR_TRACK_SCALE_9_GRID);
			this.hScrollBarThumbIconTexture = this.atlas.getTexture("horizontal-scroll-bar-thumb-icon");
			this.hScrollBarStepButtonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-step-button-up-skin"), HORIZONTAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID);
			this.hScrollBarStepButtonHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-step-button-hover-skin"), HORIZONTAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID);
			this.hScrollBarStepButtonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-step-button-down-skin"), HORIZONTAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID);
			this.hScrollBarStepButtonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-step-button-disabled-skin"), HORIZONTAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID);
			this.hScrollBarDecrementButtonIconTexture = this.atlas.getTexture("horizontal-scroll-bar-decrement-button-icon");
			this.hScrollBarIncrementButtonIconTexture = this.atlas.getTexture("horizontal-scroll-bar-increment-button-icon");

			this.simpleBorderBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("simple-border-background-skin"), SIMPLE_BORDER_SCALE_9_GRID);
			this.panelBorderBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("panel-background-skin"), PANEL_BORDER_SCALE_9_GRID);

			this.progressBarFillSkinTexture = this.atlas.getTexture("progress-bar-fill-skin");

			StandardIcons.listDrillDownAccessoryTexture = this.atlas.getTexture("list-accessory-drill-down-icon");
		}

		protected function initializeStyleProviders():void
		{
			//alert
			this.getStyleProviderForClass(Alert).defaultStyleFunction = this.setAlertStyles;
			this.getStyleProviderForClass(Header).setFunctionForStyleName(Alert.DEFAULT_CHILD_NAME_HEADER, this.setPanelHeaderStyles);
			this.getStyleProviderForClass(ButtonGroup).setFunctionForStyleName(Alert.DEFAULT_CHILD_NAME_BUTTON_GROUP, this.setAlertButtonGroupStyles);
			this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName(Alert.DEFAULT_CHILD_NAME_MESSAGE, this.setAlertMessageTextRendererStyles);

			//button
			this.getStyleProviderForClass(Button).defaultStyleFunction = this.setButtonStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);

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
			this.getStyleProviderForClass(GroupedList).setFunctionForStyleName(GroupedList.ALTERNATE_NAME_INSET_GROUPED_LIST, this.setInsetGroupedListStyles);

			//header
			this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;

			//item renderers for lists
			this.getStyleProviderForClass(DefaultListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_NAME_ACCESSORY_LABEL, this.setItemRendererAccessoryLabelStyles);
			this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_NAME_ICON_LABEL, this.setItemRendererIconLabelStyles);

			//header and footer renderers for grouped list
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).defaultStyleFunction = this.setGroupedListHeaderOrFooterRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_NAME_INSET_HEADER_RENDERER, this.setInsetGroupedListHeaderOrFooterRendererStyles);

			//label
			this.getStyleProviderForClass(Label).defaultStyleFunction = this.setLabelStyles;
			this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_NAME_HEADING, this.setHeadingLabelStyles);
			this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_NAME_DETAIL, this.setDetailLabelStyles);

			//list (see also: item renderers)
			this.getStyleProviderForClass(List).defaultStyleFunction = this.setListStyles;

			//numeric stepper
			this.getStyleProviderForClass(NumericStepper).defaultStyleFunction = this.setNumericStepperStyles;
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_NAME_TEXT_INPUT, this.setNumericStepperTextInputStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_NAME_INCREMENT_BUTTON, this.setNumericStepperIncrementButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_NAME_DECREMENT_BUTTON, this.setNumericStepperDecrementButtonStyles);

			//panel
			this.getStyleProviderForClass(Panel).defaultStyleFunction = this.setPanelStyles;
			this.getStyleProviderForClass(Header).setFunctionForStyleName(Panel.DEFAULT_CHILD_NAME_HEADER, this.setPanelHeaderStyles);

			//panel screen
			this.getStyleProviderForClass(PanelScreen).defaultStyleFunction = this.setPanelScreenStyles;

			//page indicator
			this.getStyleProviderForClass(PageIndicator).defaultStyleFunction = this.setPageIndicatorStyles;

			//picker list (see also: item renderers)
			this.getStyleProviderForClass(PickerList).defaultStyleFunction = this.setPickerListStyles;
			this.getStyleProviderForClass(List).setFunctionForStyleName(PickerList.DEFAULT_CHILD_NAME_LIST, this.setPickerListListStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(PickerList.DEFAULT_CHILD_NAME_BUTTON, this.setPickerListButtonStyles);

			//progress bar
			this.getStyleProviderForClass(ProgressBar).defaultStyleFunction = this.setProgressBarStyles;

			//radio
			this.getStyleProviderForClass(Radio).defaultStyleFunction = this.setRadioStyles;

			//screen
			this.getStyleProviderForClass(Screen).defaultStyleFunction = this.setScreenStyles;

			//scroll bar
			this.getStyleProviderForClass(ScrollBar).setFunctionForStyleName(Scroller.DEFAULT_CHILD_NAME_HORIZONTAL_SCROLL_BAR, this.setHorizontalScrollBarStyles);
			this.getStyleProviderForClass(ScrollBar).setFunctionForStyleName(Scroller.DEFAULT_CHILD_NAME_VERTICAL_SCROLL_BAR, this.setVerticalScrollBarStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON, this.setHorizontalScrollBarIncrementButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON, this.setHorizontalScrollBarDecrementButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_HORIZONTAL_SCROLL_BAR_THUMB, this.setHorizontalScrollBarThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_HORIZONTAL_SCROLL_BAR_MINIMUM_TRACK, this.setHorizontalScrollBarMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON, this.setVerticalScrollBarIncrementButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON, this.setVerticalScrollBarDecrementButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SCROLL_BAR_THUMB, this.setVerticalScrollBarThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SCROLL_BAR_MINIMUM_TRACK, this.setVerticalScrollBarMinimumTrackStyles);

			//scroll container
			this.getStyleProviderForClass(ScrollContainer).defaultStyleFunction = this.setScrollContainerStyles;
			this.getStyleProviderForClass(ScrollContainer).setFunctionForStyleName(ScrollContainer.ALTERNATE_NAME_TOOLBAR, this.setToolbarScrollContainerStyles);

			//scroll screen
			this.getStyleProviderForClass(ScrollScreen).defaultStyleFunction = this.setScrollScreenStyles;

			//scroll text
			this.getStyleProviderForClass(ScrollText).defaultStyleFunction = this.setScrollTextStyles;

			//simple scroll bar
			this.getStyleProviderForClass(SimpleScrollBar).setFunctionForStyleName(Scroller.DEFAULT_CHILD_NAME_HORIZONTAL_SCROLL_BAR, this.setHorizontalSimpleScrollBarStyles);
			this.getStyleProviderForClass(SimpleScrollBar).setFunctionForStyleName(Scroller.DEFAULT_CHILD_NAME_VERTICAL_SCROLL_BAR, this.setVerticalSimpleScrollBarStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB, this.setHorizontalSimpleScrollBarThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB, this.setVerticalSimpleScrollBarThumbStyles);

			//slider
			this.getStyleProviderForClass(Slider).defaultStyleFunction = this.setSliderStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_HORIZONTAL_SLIDER_THUMB, this.setHorizontalSliderThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK, this.setHorizontalSliderMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SLIDER_THUMB, this.setVerticalSliderThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SLIDER_MINIMUM_TRACK, this.setVerticalSliderMinimumTrackStyles);

			//tab bar
			this.getStyleProviderForClass(TabBar).defaultStyleFunction = this.setTabBarStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(TabBar.DEFAULT_CHILD_NAME_TAB, this.setTabStyles);

			//text area
			this.getStyleProviderForClass(TextArea).defaultStyleFunction = this.setTextAreaStyles;

			//text input
			this.getStyleProviderForClass(TextInput).defaultStyleFunction = this.setTextInputStyles;
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName(TextInput.ALTERNATE_NAME_SEARCH_TEXT_INPUT, this.setSearchTextInputStyles);

			//toggle switch
			this.getStyleProviderForClass(ToggleSwitch).defaultStyleFunction = this.setToggleSwitchStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_NAME_ON_TRACK, this.setToggleSwitchOnTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_NAME_THUMB, this.setToggleSwitchThumbStyles);
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
			scroller.interactionMode = ScrollContainer.INTERACTION_MODE_MOUSE;
			scroller.scrollBarDisplayMode = ScrollContainer.SCROLL_BAR_DISPLAY_MODE_FIXED;
		}

	//-------------------------
	// Alert
	//-------------------------

		protected function setAlertStyles(alert:Alert):void
		{
			this.setScrollerStyles(alert);

			alert.backgroundSkin = new Scale9Image(panelBorderBackgroundSkinTextures);

			alert.paddingTop = 0;
			alert.paddingRight = 14;
			alert.paddingBottom = 0;
			alert.paddingLeft = 14;
			alert.gap = 12;

			alert.maxWidth = alert.maxHeight = 300;
		}

		protected function setAlertButtonGroupStyles(group:ButtonGroup):void
		{
			group.direction = ButtonGroup.DIRECTION_HORIZONTAL;
			group.horizontalAlign = ButtonGroup.HORIZONTAL_ALIGN_CENTER;
			group.verticalAlign = ButtonGroup.VERTICAL_ALIGN_JUSTIFY;
			group.gap = 4;
			group.paddingTop = 12;
			group.paddingRight = 12;
			group.paddingBottom = 12;
			group.paddingLeft = 12;
		}

		protected function setAlertMessageTextRendererStyles(renderer:TextFieldTextRenderer):void
		{
			renderer.textFormat = this.defaultTextFormat;
			renderer.wordWrap = true;
		}

	//-------------------------
	// Button
	//-------------------------

		protected function setBaseButtonStyles(button:Button):void
		{
			button.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			button.focusPadding = -1;

			button.defaultLabelProperties.textFormat = this.defaultTextFormat;
			button.disabledLabelProperties.textFormat = this.disabledTextFormat;

			button.paddingTop = button.paddingBottom = 2;
			button.paddingLeft = button.paddingRight = 10;
			button.gap = 2;
			button.minGap = 2;
			button.minWidth = button.minHeight = 12;
		}

		protected function setButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.defaultSelectedValue = this.buttonSelectedUpSkinTextures;
			skinSelector.setValueForState(this.buttonHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.buttonSelectedHoverSkinTextures, Button.STATE_HOVER, true);
			skinSelector.setValueForState(this.buttonSelectedDownSkinTextures, Button.STATE_DOWN, true);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
		}

		protected function setQuietButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = null;
			skinSelector.defaultSelectedValue = this.buttonSelectedUpSkinTextures;
			skinSelector.setValueForState(this.buttonHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.buttonSelectedHoverSkinTextures, Button.STATE_HOVER, true);
			skinSelector.setValueForState(this.buttonSelectedDownSkinTextures, Button.STATE_DOWN, true);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
		}

	//-------------------------
	// ButtonGroup
	//-------------------------

		protected function setButtonGroupStyles(group:ButtonGroup):void
		{
			group.gap = 4;
		}

	//-------------------------
	// Callout
	//-------------------------

		protected function setCalloutStyles(callout:Callout):void
		{
			callout.backgroundSkin = new Scale9Image(panelBorderBackgroundSkinTextures);

			var arrowSkin:Quad = new Quad(8, 8, 0xff00ff);
			arrowSkin.alpha = 0;
			callout.topArrowSkin =  callout.rightArrowSkin =  callout.bottomArrowSkin =
				callout.leftArrowSkin = arrowSkin;

			callout.paddingTop = callout.paddingBottom = 6;
			callout.paddingRight = callout.paddingLeft = 10;
		}

	//-------------------------
	// Check
	//-------------------------

		protected function setCheckStyles(check:Check):void
		{
			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
			iconSelector.defaultValue = this.checkUpIconTexture;
			iconSelector.defaultSelectedValue = this.checkSelectedUpIconTexture;
			iconSelector.setValueForState(this.checkHoverIconTexture, Button.STATE_HOVER, false);
			iconSelector.setValueForState(this.checkDownIconTexture, Button.STATE_DOWN, false);
			iconSelector.setValueForState(this.checkDisabledIconTexture, Button.STATE_DISABLED, false);
			iconSelector.setValueForState(this.checkSelectedHoverIconTexture, Button.STATE_HOVER, true);
			iconSelector.setValueForState(this.checkSelectedDownIconTexture, Button.STATE_DOWN, true);
			iconSelector.setValueForState(this.checkSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
			iconSelector.displayObjectProperties =
			{
				snapToPixels: true
			};
			check.stateToIconFunction = iconSelector.updateValue;

			check.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			check.focusPadding = -2;

			check.defaultLabelProperties.textFormat = this.defaultTextFormat;
			check.disabledLabelProperties.textFormat = this.disabledTextFormat;

			check.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			check.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;

			check.gap = 4;
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

			list.verticalScrollPolicy = GroupedList.SCROLL_POLICY_AUTO;

			list.backgroundSkin = new Scale9Image(simpleBorderBackgroundSkinTextures);

			list.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			list.focusPadding = -1;

			list.paddingTop = list.paddingRight = list.paddingBottom =
				list.paddingLeft = 1;
		}

		//see List section for item renderer styles

		protected function setGroupedListHeaderOrFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			renderer.backgroundSkin = new Scale9Image(groupedListHeaderBackgroundSkinTextures);
			renderer.backgroundSkin.height = 18;

			renderer.contentLabelProperties.textFormat = this.defaultTextFormat;

			renderer.paddingTop = renderer.paddingBottom = 2;
			renderer.paddingRight = renderer.paddingLeft = 6;
			renderer.minWidth = renderer.minHeight = 18;
		}

		protected function setInsetGroupedListStyles(list:GroupedList):void
		{
			this.setScrollerStyles(list);

			list.verticalScrollPolicy = GroupedList.SCROLL_POLICY_AUTO;

			list.headerRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_HEADER_RENDERER;
			list.footerRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_FOOTER_RENDERER;

			var layout:VerticalLayout = new VerticalLayout();
			layout.useVirtualLayout = true;
			layout.padding = 10;
			layout.paddingTop = 0;
			layout.gap = 0;
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			list.layout = layout;
		}

		protected function setInsetGroupedListHeaderOrFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			renderer.contentLabelProperties.textFormat = this.defaultTextFormat;

			renderer.paddingTop = 8;
			renderer.paddingBottom = 2;
			renderer.paddingRight = renderer.paddingLeft = 6;
			renderer.minWidth = renderer.minHeight = 18;
		}

	//-------------------------
	// Header
	//-------------------------

		protected function setHeaderStyles(header:Header):void
		{
			header.backgroundSkin = new Scale9Image(headerBackgroundSkinTextures);

			header.minHeight = 22;

			header.titleProperties.textFormat = this.headerTitleTextFormat;

			header.paddingTop = header.paddingBottom = 4;
			header.paddingRight = header.paddingLeft = 6;

			header.gap = 2;
			header.titleGap = 4;
		}

	//-------------------------
	// Label
	//-------------------------

		protected function setLabelStyles(label:Label):void
		{
			label.textRendererProperties.textFormat = this.defaultTextFormat;
			label.textRendererProperties.disabledTextFormat = this.disabledTextFormat;
		}

		protected function setHeadingLabelStyles(label:Label):void
		{
			label.textRendererProperties.textFormat = this.headingTextFormat;
			label.textRendererProperties.disabledTextFormat = this.headingDisabledTextFormat;
		}

		protected function setDetailLabelStyles(label:Label):void
		{
			label.textRendererProperties.textFormat = this.detailTextFormat;
			label.textRendererProperties.disabledTextFormat = this.detailDisabledTextFormat;
		}

	//-------------------------
	// List
	//-------------------------

		protected function setListStyles(list:List):void
		{
			this.setScrollerStyles(list);

			list.verticalScrollPolicy = List.SCROLL_POLICY_AUTO;

			list.backgroundSkin = new Scale9Image(simpleBorderBackgroundSkinTextures);

			list.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			list.focusPadding = -1;

			list.paddingTop = list.paddingRight = list.paddingBottom =
				list.paddingLeft = 1;
		}

		protected function setItemRendererStyles(renderer:BaseDefaultItemRenderer):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.itemRendererUpSkinTexture;
			skinSelector.defaultSelectedValue = this.itemRendererSelectedUpSkinTexture;
			skinSelector.setValueForState(this.itemRendererHoverSkinTexture, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.itemRendererSelectedUpSkinTexture, Button.STATE_DOWN, false);
			renderer.stateToSkinFunction = skinSelector.updateValue;

			renderer.defaultLabelProperties.textFormat = this.defaultTextFormat;
			renderer.disabledLabelProperties.textFormat = this.disabledTextFormat;

			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;

			renderer.iconPosition = Button.ICON_POSITION_LEFT;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;

			renderer.paddingTop = renderer.paddingBottom = 2;
			renderer.paddingRight = renderer.paddingLeft = 6;
			renderer.gap = 2;
			renderer.minGap = 2;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.minAccessoryGap = 2;
			renderer.minWidth = renderer.minHeight = 22;
		}

		protected function setItemRendererAccessoryLabelStyles(renderer:TextFieldTextRenderer):void
		{
			renderer.textFormat = this.defaultTextFormat;
		}

		protected function setItemRendererIconLabelStyles(renderer:TextFieldTextRenderer):void
		{
			renderer.textFormat = this.defaultTextFormat;
		}

	//-------------------------
	// NumericStepper
	//-------------------------

		protected function setNumericStepperStyles(stepper:NumericStepper):void
		{
			stepper.buttonLayoutMode = NumericStepper.BUTTON_LAYOUT_MODE_RIGHT_SIDE_VERTICAL;

			stepper.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			stepper.focusPadding = -1;
		}

		protected function setNumericStepperIncrementButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.stepperIncrementButtonUpSkinTextures;
			skinSelector.setValueForState(this.stepperIncrementButtonHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.stepperIncrementButtonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.stepperIncrementButtonDisabledSkinTextures, Button.STATE_DISABLED, false);
			button.stateToSkinFunction = skinSelector.updateValue;
		}

		protected function setNumericStepperDecrementButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.stepperDecrementButtonUpSkinTextures;
			skinSelector.setValueForState(this.stepperDecrementButtonHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.stepperDecrementButtonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.stepperDecrementButtonDisabledSkinTextures, Button.STATE_DISABLED, false);
			button.stateToSkinFunction = skinSelector.updateValue;
		}

		protected function setNumericStepperTextInputStyles(input:TextInput):void
		{
			input.minWidth = input.minHeight = 22;
			input.gap = 2;
			input.paddingTop = input.paddingBottom = 2;
			input.paddingRight = input.paddingLeft = 4;
			input.textEditorProperties.textFormat = this.defaultTextFormat;

			var backgroundSkin:Scale9Image = new Scale9Image(textInputBackgroundSkinTextures);
			backgroundSkin.width = backgroundSkin.height;
			input.backgroundSkin = backgroundSkin;

			var backgroundDisabledSkin:Scale9Image = new Scale9Image(textInputBackgroundDisabledSkinTextures);
			backgroundDisabledSkin.width = backgroundDisabledSkin.height;
			input.backgroundDisabledSkin = backgroundDisabledSkin;
		}

	//-------------------------
	// PageIndicator
	//-------------------------

		protected function setPageIndicatorStyles(pageIndicator:PageIndicator):void
		{
			pageIndicator.interactionMode = PageIndicator.INTERACTION_MODE_PRECISE;
			pageIndicator.normalSymbolFactory = this.pageIndicatorNormalSymbolFactory;
			pageIndicator.selectedSymbolFactory = this.pageIndicatorSelectedSymbolFactory;
			pageIndicator.gap = 12;
			pageIndicator.paddingTop = pageIndicator.paddingRight = pageIndicator.paddingBottom =
				pageIndicator.paddingLeft = 12;
			pageIndicator.minTouchWidth = pageIndicator.minTouchHeight = 12;
		}

	//-------------------------
	// Panel
	//-------------------------

		protected function setPanelStyles(panel:Panel):void
		{
			this.setScrollerStyles(panel);

			panel.backgroundSkin = new Scale9Image(panelBorderBackgroundSkinTextures);

			panel.paddingTop = 0;
			panel.paddingRight = 10;
			panel.paddingBottom = 10;
			panel.paddingLeft = 10;
		}

		protected function setPanelHeaderStyles(header:Header):void
		{
			header.titleProperties.textFormat = this.headerTitleTextFormat;

			header.minHeight = 22;

			header.paddingTop = header.paddingBottom = 6;
			header.paddingRight = header.paddingLeft = 6;

			header.gap = 2;
			header.titleGap = 4;
		}

	//-------------------------
	// PanelScreen
	//-------------------------

		protected function setPanelScreenStyles(screen:PanelScreen):void
		{
			this.setScrollerStyles(screen);

			screen.originalDPI = this.originalDPI;
		}

	//-------------------------
	// PickerList
	//-------------------------

		protected function setPickerListStyles(list:PickerList):void
		{
			list.popUpContentManager = new DropDownPopUpContentManager();
		}

		protected function setPickerListListStyles(list:List):void
		{
			this.setListStyles(list);
			list.maxHeight = 110;
		}

		protected function setPickerListButtonStyles(button:Button):void
		{
			this.setButtonStyles(button);

			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.defaultValue = this.pickerListUpIconTexture;
			iconSelector.setValueForState(this.pickerListHoverIconTexture, Button.STATE_HOVER, false);
			iconSelector.setValueForState(this.pickerListDownIconTexture, Button.STATE_DOWN, false);
			iconSelector.setValueForState(this.pickerListDisabledIconTexture, Button.STATE_DISABLED, false);
			button.stateToIconFunction = iconSelector.updateValue;

			button.gap = Number.POSITIVE_INFINITY; //fill as completely as possible
			button.minGap = 10;
			button.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			button.iconPosition = Button.ICON_POSITION_RIGHT;
			button.paddingRight = 6;
		}

	//-------------------------
	// ProgressBar
	//-------------------------

		protected function setProgressBarStyles(progress:ProgressBar):void
		{
			var backgroundSkin:Scale9Image = new Scale9Image(simpleBorderBackgroundSkinTextures);
			if(progress.direction == ProgressBar.DIRECTION_VERTICAL)
			{
				backgroundSkin.height = backgroundSkin.width * 30;
			}
			else
			{
				backgroundSkin.width = backgroundSkin.height * 30;
			}
			progress.backgroundSkin = backgroundSkin;

			var fillSkin:Image = new Image(progressBarFillSkinTexture);
			if(progress.direction == ProgressBar.DIRECTION_VERTICAL)
			{
				fillSkin.height = 0;
			}
			else
			{
				fillSkin.width = 0;
			}
			progress.fillSkin = fillSkin;

			progress.paddingTop = progress.paddingRight = progress.paddingBottom =
				progress.paddingLeft = 1;
		}

	//-------------------------
	// Radio
	//-------------------------

		protected function setRadioStyles(radio:Radio):void
		{
			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.defaultValue = this.radioUpIconTexture;
			iconSelector.defaultSelectedValue = this.radioSelectedUpIconTexture;
			iconSelector.setValueForState(this.radioHoverIconTexture, Button.STATE_HOVER, false);
			iconSelector.setValueForState(this.radioDownIconTexture, Button.STATE_DOWN, false);
			iconSelector.setValueForState(this.radioDisabledIconTexture, Button.STATE_DISABLED, false);
			iconSelector.setValueForState(this.radioSelectedHoverIconTexture, Button.STATE_HOVER, true);
			iconSelector.setValueForState(this.radioSelectedDownIconTexture, Button.STATE_DOWN, true);
			iconSelector.setValueForState(this.radioSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
			radio.stateToIconFunction = iconSelector.updateValue;

			radio.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			radio.focusPadding = -2;

			radio.defaultLabelProperties.textFormat = this.defaultTextFormat;
			radio.disabledLabelProperties.textFormat = this.disabledTextFormat;

			radio.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			radio.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;

			radio.gap = 4;
		}

	//-------------------------
	// Screen
	//-------------------------

		protected function setScreenStyles(screen:Screen):void
		{
			screen.originalDPI = this.originalDPI;
		}

	//-------------------------
	// ScrollBar
	//-------------------------

		protected function setHorizontalScrollBarStyles(scrollBar:ScrollBar):void
		{
			scrollBar.direction = ScrollBar.DIRECTION_HORIZONTAL;
			scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;

			scrollBar.customIncrementButtonName = THEME_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON;
			scrollBar.customDecrementButtonName = THEME_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON;
			scrollBar.customThumbName = THEME_NAME_HORIZONTAL_SCROLL_BAR_THUMB;
			scrollBar.customMinimumTrackName = THEME_NAME_HORIZONTAL_SCROLL_BAR_MINIMUM_TRACK;
		}

		protected function setVerticalScrollBarStyles(scrollBar:ScrollBar):void
		{
			scrollBar.direction = ScrollBar.DIRECTION_VERTICAL;
			scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;

			scrollBar.customIncrementButtonName = THEME_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON;
			scrollBar.customDecrementButtonName = THEME_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON;
			scrollBar.customThumbName = THEME_NAME_VERTICAL_SCROLL_BAR_THUMB;
			scrollBar.customMinimumTrackName = THEME_NAME_VERTICAL_SCROLL_BAR_MINIMUM_TRACK;
		}

		protected function setHorizontalScrollBarIncrementButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.hScrollBarStepButtonUpSkinTextures;
			skinSelector.setValueForState(this.hScrollBarStepButtonHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.hScrollBarStepButtonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.hScrollBarStepButtonDisabledSkinTextures, Button.STATE_DISABLED, false);
			button.stateToSkinFunction = skinSelector.updateValue;

			button.defaultIcon = new Image(this.hScrollBarIncrementButtonIconTexture);

			var incrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
			incrementButtonDisabledIcon.alpha = 0;
			button.disabledIcon = incrementButtonDisabledIcon;
		}

		protected function setHorizontalScrollBarDecrementButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = hScrollBarStepButtonUpSkinTextures;
			skinSelector.setValueForState(this.hScrollBarStepButtonHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.hScrollBarStepButtonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.hScrollBarStepButtonDisabledSkinTextures, Button.STATE_DISABLED, false);
			button.stateToSkinFunction = skinSelector.updateValue;

			button.defaultIcon = new Image(this.hScrollBarDecrementButtonIconTexture);

			var decrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
			decrementButtonDisabledIcon.alpha = 0;
			button.disabledIcon = decrementButtonDisabledIcon;
		}

		protected function setHorizontalScrollBarThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.hScrollBarThumbUpSkinTextures;
			skinSelector.setValueForState(this.hScrollBarThumbHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.hScrollBarThumbDownSkinTextures, Button.STATE_DOWN, false);
			thumb.stateToSkinFunction = skinSelector.updateValue;

			thumb.defaultIcon = new Image(this.hScrollBarThumbIconTexture);
			thumb.verticalAlign = Button.VERTICAL_ALIGN_TOP;
			thumb.paddingTop = 4;
		}

		protected function setHorizontalScrollBarMinimumTrackStyles(track:Button):void
		{
			track.defaultSkin = new Scale9Image(this.hScrollBarTrackSkinTextures);
		}

		protected function setVerticalScrollBarIncrementButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.vScrollBarStepButtonUpSkinTextures;
			skinSelector.setValueForState(this.vScrollBarStepButtonHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.vScrollBarStepButtonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.vScrollBarStepButtonDisabledSkinTextures, Button.STATE_DISABLED, false);
			button.stateToSkinFunction = skinSelector.updateValue;

			button.defaultIcon = new Image(this.vScrollBarIncrementButtonIconTexture);

			var incrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
			incrementButtonDisabledIcon.alpha = 0;
			button.disabledIcon = incrementButtonDisabledIcon;
		}

		protected function setVerticalScrollBarDecrementButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.vScrollBarStepButtonUpSkinTextures;
			skinSelector.setValueForState(this.vScrollBarStepButtonHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.vScrollBarStepButtonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.vScrollBarStepButtonDisabledSkinTextures, Button.STATE_DISABLED, false);
			button.stateToSkinFunction = skinSelector.updateValue;

			button.defaultIcon = new Image(this.vScrollBarDecrementButtonIconTexture);

			var decrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
			decrementButtonDisabledIcon.alpha = 0;
			button.disabledIcon = decrementButtonDisabledIcon;
		}

		protected function setVerticalScrollBarThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.vScrollBarThumbUpSkinTextures;
			skinSelector.setValueForState(this.vScrollBarThumbHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.vScrollBarThumbDownSkinTextures, Button.STATE_DOWN, false);
			thumb.stateToSkinFunction = skinSelector.updateValue;

			thumb.defaultIcon = new Image(this.vScrollBarThumbIconTexture);
			thumb.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			thumb.paddingLeft = 4;
		}

		protected function setVerticalScrollBarMinimumTrackStyles(track:Button):void
		{
			track.defaultSkin = new Scale9Image(this.vScrollBarTrackSkinTextures);
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
				layout.paddingTop = layout.paddingBottom = 2;
				layout.paddingRight = layout.paddingLeft = 6;
				layout.gap = 2;
				container.layout = layout;
			}

			container.minHeight = 22;

			container.backgroundSkin = new Scale9Image(headerBackgroundSkinTextures);
		}

	//-------------------------
	// ScrollScreen
	//-------------------------

		protected function setScrollScreenStyles(screen:ScrollScreen):void
		{
			this.setScrollerStyles(screen);

			screen.originalDPI = this.originalDPI;
		}

	//-------------------------
	// ScrollText
	//-------------------------

		protected function setScrollTextStyles(text:ScrollText):void
		{
			this.setScrollerStyles(text);

			text.textFormat = this.defaultTextFormat;
			text.disabledTextFormat = this.disabledTextFormat;
			text.paddingTop = text.paddingRight = text.paddingBottom = text.paddingLeft = 8;
		}

	//-------------------------
	// SimpleScrollBar
	//-------------------------

		protected function setHorizontalSimpleScrollBarStyles(scrollBar:SimpleScrollBar):void
		{
			scrollBar.customThumbName = THEME_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB;
		}

		protected function setVerticalSimpleScrollBarStyles(scrollBar:SimpleScrollBar):void
		{
			scrollBar.customThumbName = THEME_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB;
		}

		protected function setHorizontalSimpleScrollBarThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.hScrollBarThumbUpSkinTextures;
			skinSelector.setValueForState(this.hScrollBarThumbHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.hScrollBarThumbDownSkinTextures, Button.STATE_DOWN, false);
			thumb.stateToSkinFunction = skinSelector.updateValue;

			thumb.defaultIcon = new Image(this.hScrollBarThumbIconTexture);
			thumb.verticalAlign = Button.VERTICAL_ALIGN_TOP;
			thumb.paddingTop = 4;
		}

		protected function setVerticalSimpleScrollBarThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.vScrollBarThumbUpSkinTextures;
			skinSelector.setValueForState(this.vScrollBarThumbHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.vScrollBarThumbDownSkinTextures, Button.STATE_DOWN, false);
			thumb.stateToSkinFunction = skinSelector.updateValue;

			thumb.defaultIcon = new Image(this.vScrollBarThumbIconTexture);
			thumb.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			thumb.paddingLeft = 4;
		}

	//-------------------------
	// Slider
	//-------------------------

		protected function setSliderStyles(slider:Slider):void
		{
			slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_SINGLE;
			slider.minimumPadding = slider.maximumPadding = -vSliderThumbUpSkinTexture.height / 2;

			if(slider.direction == Slider.DIRECTION_VERTICAL)
			{
				slider.customThumbName = THEME_NAME_VERTICAL_SLIDER_THUMB;
				slider.customMinimumTrackName = THEME_NAME_VERTICAL_SLIDER_MINIMUM_TRACK;

				slider.focusPaddingLeft = slider.focusPaddingRight = -2;
				slider.focusPaddingTop = slider.focusPaddingBottom = -2 + slider.minimumPadding;
			}
			else //horizontal
			{
				slider.customThumbName = THEME_NAME_HORIZONTAL_SLIDER_THUMB;
				slider.customMinimumTrackName = THEME_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK;

				slider.focusPaddingTop = slider.focusPaddingBottom = -2;
				slider.focusPaddingLeft = slider.focusPaddingRight = -2 + slider.minimumPadding;
			}

			slider.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
		}

		protected function setHorizontalSliderThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.hSliderThumbUpSkinTexture;
			skinSelector.setValueForState(this.hSliderThumbHoverSkinTexture, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.hSliderThumbDownSkinTexture, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.hSliderThumbDisabledSkinTexture, Button.STATE_DISABLED, false);
			thumb.stateToSkinFunction = skinSelector.updateValue;
		}

		protected function setHorizontalSliderMinimumTrackStyles(track:Button):void
		{
			track.defaultSkin = new Scale3Image(this.hSliderTrackSkinTextures);
		}

		protected function setVerticalSliderThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.vSliderThumbUpSkinTexture;
			skinSelector.setValueForState(this.vSliderThumbHoverSkinTexture, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.vSliderThumbDownSkinTexture, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.vSliderThumbDisabledSkinTexture, Button.STATE_DISABLED, false);
			thumb.stateToSkinFunction = skinSelector.updateValue;
		}

		protected function setVerticalSliderMinimumTrackStyles(track:Button):void
		{
			track.defaultSkin = new Scale3Image(this.vSliderTrackSkinTextures);
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

		protected function setTabStyles(tab:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.tabUpSkinTextures;
			skinSelector.defaultSelectedValue = this.tabSelectedUpSkinTextures;
			skinSelector.setValueForState(this.tabHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.tabDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.tabDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.tabSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			tab.stateToSkinFunction = skinSelector.updateValue;

			tab.defaultLabelProperties.textFormat = this.defaultTextFormat;
			tab.disabledLabelProperties.textFormat = this.disabledTextFormat;

			tab.paddingTop = tab.paddingBottom = 2;
			tab.paddingLeft = tab.paddingRight = 10;
			tab.gap = 2;
			tab.minWidth = tab.minHeight = 12;
		}

	//-------------------------
	// TextArea
	//-------------------------

		protected function setTextAreaStyles(textArea:TextArea):void
		{
			this.setScrollerStyles(textArea);

			textArea.textEditorProperties.textFormat = this.defaultTextFormat;

			textArea.paddingTop = 2;
			textArea.paddingBottom = 2;
			textArea.paddingRight = 2;
			textArea.paddingLeft = 4;

			textArea.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			textArea.focusPadding = -1;

			var backgroundSkin:Scale9Image = new Scale9Image(textInputBackgroundSkinTextures);
			backgroundSkin.width = 264;
			backgroundSkin.height = 88;
			textArea.backgroundSkin = backgroundSkin;

			var backgroundDisabledSkin:Scale9Image = new Scale9Image(textInputBackgroundDisabledSkinTextures);
			backgroundDisabledSkin.width = 264;
			backgroundDisabledSkin.height = 88;
			textArea.backgroundDisabledSkin = backgroundDisabledSkin;
		}

	//-------------------------
	// TextInput
	//-------------------------

		protected function setBaseTextInputStyles(input:TextInput):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.textInputBackgroundSkinTextures;
			skinSelector.setValueForState(this.textInputBackgroundDisabledSkinTextures, TextInput.STATE_DISABLED);
			input.stateToSkinFunction = skinSelector.updateValue;

			input.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			input.focusPadding = -1;

			input.minWidth = input.minHeight = 22;
			input.gap = 2;
			input.paddingTop = input.paddingBottom = 2;
			input.paddingRight = input.paddingLeft = 4;

			input.textEditorProperties.textFormat = this.defaultTextFormat;
			input.promptProperties.textFormat = this.defaultTextFormat;
		}

		protected function setTextInputStyles(input:TextInput):void
		{
			this.setBaseTextInputStyles(input);
		}

		protected function setSearchTextInputStyles(input:TextInput):void
		{
			this.setBaseTextInputStyles(input);

			var searchIcon:ImageLoader = new ImageLoader();
			searchIcon.source = this.textInputSearchIconTexture;
			searchIcon.snapToPixels = true;
			input.defaultIcon = searchIcon;
		}

	//-------------------------
	// ToggleSwitch
	//-------------------------

		protected function setToggleSwitchStyles(toggle:ToggleSwitch):void
		{
			toggle.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;
			toggle.labelAlign = ToggleSwitch.LABEL_ALIGN_MIDDLE;
			toggle.defaultLabelProperties.textFormat = this.defaultTextFormat;
			toggle.disabledLabelProperties.textFormat = this.disabledTextFormat;

			toggle.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			toggle.focusPadding = -1;
		}

		protected function setToggleSwitchOnTrackStyles(track:Button):void
		{
			track.defaultSkin = new Scale9Image(buttonSelectedUpSkinTextures);
		}

		protected function setToggleSwitchThumbStyles(thumb:Button):void
		{
			this.setButtonStyles(thumb);

			var frame:Rectangle = this.buttonUpSkinTextures.texture.frame;
			if(frame)
			{
				thumb.width = thumb.height = buttonUpSkinTextures.texture.frame.height;
			}
			else
			{
				thumb.width = thumb.height = buttonUpSkinTextures.texture.height;
			}
		}
	}
}
