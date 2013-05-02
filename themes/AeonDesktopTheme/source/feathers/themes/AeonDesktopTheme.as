/*
 Copyright (c) 2012 Josh Tynjala

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
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Callout;
	import feathers.controls.Check;
	import feathers.controls.GroupedList;
	import feathers.controls.Header;
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
	import feathers.controls.ScrollText;
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
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.DisplayListWatcher;
	import feathers.core.FeathersControl;
	import feathers.core.FocusManager;
	import feathers.core.IFeathersControl;
	import feathers.core.ITextEditor;
	import feathers.core.ITextRenderer;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.skins.StandardIcons;
	import feathers.system.DeviceCapabilities;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class AeonDesktopTheme extends DisplayListWatcher
	{
		[Embed(source="/../assets/images/aeon.png")]
		protected static const ATLAS_IMAGE:Class;

		[Embed(source="/../assets/images/aeon.xml",mimeType="application/octet-stream")]
		protected static const ATLAS_XML:Class;

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
		protected static const PRIMARY_TEXT_COLOR:uint = 0x0B333C;
		protected static const DISABLED_TEXT_COLOR:uint = 0xAAB3B3;

		protected static function verticalScrollBarFactory():ScrollBar
		{
			const scrollBar:ScrollBar = new ScrollBar();
			scrollBar.direction = ScrollBar.DIRECTION_VERTICAL;
			return scrollBar;
		}

		protected static function horizontalScrollBarFactory():ScrollBar
		{
			const scrollBar:ScrollBar = new ScrollBar();
			scrollBar.direction = ScrollBar.DIRECTION_HORIZONTAL;
			return scrollBar;
		}

		protected static function textRendererFactory():ITextRenderer
		{
			return new TextFieldTextRenderer();
		}

		protected static function textEditorFactory():ITextEditor
		{
			return new TextFieldTextEditor();
		}

		public function AeonDesktopTheme(container:DisplayObjectContainer = null)
		{
			if(!container)
			{
				container = Starling.current.stage;
			}
			super(container);
			Starling.current.nativeStage.color = BACKGROUND_COLOR;
			if(this.root.stage)
			{
				this.root.stage.color = BACKGROUND_COLOR;
			}
			else
			{
				this.root.addEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);
			}
			this.initialize();
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
		protected var atlasBitmapData:BitmapData;

		protected var defaultTextFormat:TextFormat;
		protected var disabledTextFormat:TextFormat;

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
		protected var hScrollBarTrackTextures:Scale9Textures;
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

		override public function dispose():void
		{
			if(this.root)
			{
				this.root.removeEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);
			}
			if(this.atlas)
			{
				this.atlas.dispose();
				this.atlas = null;
			}
			if(this.atlasBitmapData)
			{
				this.atlasBitmapData.dispose();
				this.atlasBitmapData = null;
			}
			super.dispose();
		}

		protected function initialize():void
		{
			FocusManager.isEnabled = true;

			FeathersControl.defaultTextRendererFactory = textRendererFactory;
			FeathersControl.defaultTextEditorFactory = textEditorFactory;

			Callout.stagePaddingTop = Callout.stagePaddingRight = Callout.stagePaddingBottom =
				Callout.stagePaddingLeft = 16;

			const atlasBitmapData:BitmapData = (new ATLAS_IMAGE()).bitmapData;
			this.atlas = new TextureAtlas(Texture.fromBitmapData(atlasBitmapData, false), XML(new ATLAS_XML()));
			if(Starling.handleLostContext)
			{
				this.atlasBitmapData = atlasBitmapData;
			}
			else
			{
				atlasBitmapData.dispose();
			}

			this.defaultTextFormat = new TextFormat("_sans", 11, PRIMARY_TEXT_COLOR, false, false, false, null, null, TextFormatAlign.LEFT, 0, 0, 0, 0);
			this.disabledTextFormat = new TextFormat("_sans", 11, DISABLED_TEXT_COLOR, false, false, false, null, null, TextFormatAlign.LEFT, 0, 0, 0, 0);

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
			this.hScrollBarTrackTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-track-skin"), HORIZONTAL_SCROLL_BAR_TRACK_SCALE_9_GRID);
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

			this.setInitializerForClassAndSubclasses(Screen, screenInitializer);
			this.setInitializerForClass(Label, labelInitializer);
			this.setInitializerForClass(ScrollText, scrollTextInitializer);
			this.setInitializerForClass(BitmapFontTextRenderer, itemRendererAccessoryLabelInitializer, BaseDefaultItemRenderer.DEFAULT_CHILD_NAME_ACCESSORY_LABEL);
			this.setInitializerForClass(Button, buttonInitializer);
			this.setInitializerForClass(Button, tabInitializer, TabBar.DEFAULT_CHILD_NAME_TAB);
			this.setInitializerForClass(Button, toggleSwitchOnTrackInitializer, ToggleSwitch.DEFAULT_CHILD_NAME_ON_TRACK);
			this.setInitializerForClass(Button, toggleSwitchThumbInitializer, ToggleSwitch.DEFAULT_CHILD_NAME_THUMB);
			this.setInitializerForClass(Button, pickerListButtonInitializer, PickerList.DEFAULT_CHILD_NAME_BUTTON);
			this.setInitializerForClass(Button, stepperIncrementButtonInitializer, NumericStepper.DEFAULT_CHILD_NAME_INCREMENT_BUTTON);
			this.setInitializerForClass(Button, stepperDecrementButtonInitializer, NumericStepper.DEFAULT_CHILD_NAME_DECREMENT_BUTTON);
			this.setInitializerForClass(Button, nothingInitializer, SimpleScrollBar.DEFAULT_CHILD_NAME_THUMB);
			this.setInitializerForClass(Button, nothingInitializer, ScrollBar.DEFAULT_CHILD_NAME_THUMB);
			this.setInitializerForClass(Button, nothingInitializer, ScrollBar.DEFAULT_CHILD_NAME_DECREMENT_BUTTON);
			this.setInitializerForClass(Button, nothingInitializer, ScrollBar.DEFAULT_CHILD_NAME_INCREMENT_BUTTON);
			this.setInitializerForClass(Button, nothingInitializer, ScrollBar.DEFAULT_CHILD_NAME_MINIMUM_TRACK);
			this.setInitializerForClass(Button, nothingInitializer, ScrollBar.DEFAULT_CHILD_NAME_MAXIMUM_TRACK);
			this.setInitializerForClass(Button, nothingInitializer, Slider.DEFAULT_CHILD_NAME_THUMB);
			this.setInitializerForClass(Button, nothingInitializer, Slider.DEFAULT_CHILD_NAME_MINIMUM_TRACK);
			this.setInitializerForClass(Button, nothingInitializer, Slider.DEFAULT_CHILD_NAME_MAXIMUM_TRACK);
			this.setInitializerForClass(ButtonGroup, buttonGroupInitializer);
			this.setInitializerForClass(Check, checkInitializer);
			this.setInitializerForClass(Radio, radioInitializer);
			this.setInitializerForClass(ToggleSwitch, toggleSwitchInitializer);
			this.setInitializerForClass(Slider, sliderInitializer);
			this.setInitializerForClass(NumericStepper, numericStepperInitializer);
			this.setInitializerForClass(SimpleScrollBar, simpleScrollBarInitializer);
			this.setInitializerForClass(ScrollBar, scrollBarInitializer);
			this.setInitializerForClass(TextInput, textInputInitializer);
			this.setInitializerForClass(TextInput, numericStepperTextInputInitializer, NumericStepper.DEFAULT_CHILD_NAME_TEXT_INPUT);
			this.setInitializerForClass(TextArea, textAreaInitializer);
			this.setInitializerForClass(PageIndicator, pageIndicatorInitializer);
			this.setInitializerForClass(ProgressBar, progressBarInitializer);
			this.setInitializerForClass(List, listInitializer);
			this.setInitializerForClass(List, pickerListListInitializer, PickerList.DEFAULT_CHILD_NAME_LIST);
			this.setInitializerForClass(GroupedList, groupedListInitializer);
			this.setInitializerForClass(PickerList, pickerListInitializer);
			this.setInitializerForClass(DefaultListItemRenderer, defaultItemRendererInitializer);
			this.setInitializerForClass(DefaultGroupedListItemRenderer, defaultItemRendererInitializer);
			this.setInitializerForClass(DefaultGroupedListHeaderOrFooterRenderer, defaultHeaderOrFooterRendererInitializer);
			this.setInitializerForClass(Header, headerInitializer);
			this.setInitializerForClass(Header, panelHeaderInitializer, Panel.DEFAULT_CHILD_NAME_HEADER);
			this.setInitializerForClass(Callout, calloutInitializer);
			this.setInitializerForClass(ScrollContainer, scrollContainerInitializer);
			this.setInitializerForClass(Panel, panelInitializer);
		}

		protected function pageIndicatorNormalSymbolFactory():Image
		{
			return new Image(this.pageIndicatorNormalSkinTexture);
		}

		protected function pageIndicatorSelectedSymbolFactory():Image
		{
			return new Image(this.pageIndicatorSelectedSkinTexture);
		}

		protected function nothingInitializer(target:IFeathersControl):void
		{
			//do nothing
		}

		protected function screenInitializer(screen:Screen):void
		{
			screen.originalDPI = this.originalDPI;
		}

		protected function panelScreenInitializer(screen:PanelScreen):void
		{
			screen.originalDPI = this.originalDPI;

			screen.horizontalScrollBarFactory = horizontalScrollBarFactory;
			screen.verticalScrollBarFactory = verticalScrollBarFactory;
		}

		protected function labelInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.defaultTextFormat;
		}

		protected function scrollTextInitializer(text:ScrollText):void
		{
			text.textFormat = this.defaultTextFormat;
			text.paddingTop = text.paddingRight = text.paddingBottom = text.paddingLeft = 8;

			text.horizontalScrollBarFactory = horizontalScrollBarFactory;
			text.verticalScrollBarFactory = verticalScrollBarFactory;

			text.interactionMode = ScrollText.INTERACTION_MODE_MOUSE;
			text.scrollBarDisplayMode = ScrollText.SCROLL_BAR_DISPLAY_MODE_FIXED;

			text.verticalScrollPolicy = ScrollText.SCROLL_POLICY_AUTO;
			text.horizontalScrollPolicy = ScrollText.SCROLL_POLICY_AUTO;
		}

		protected function itemRendererAccessoryLabelInitializer(renderer:TextFieldTextRenderer):void
		{
			renderer.textFormat = this.defaultTextFormat;
		}

		protected function buttonInitializer(button:Button):void
		{
			button.defaultSkin = new Scale9Image(buttonUpSkinTextures);
			button.hoverSkin = new Scale9Image(buttonHoverSkinTextures);
			button.downSkin = new Scale9Image(buttonDownSkinTextures);
			button.disabledSkin = new Scale9Image(buttonDisabledSkinTextures);
			button.defaultSelectedSkin = new Scale9Image(buttonSelectedUpSkinTextures);
			button.selectedHoverSkin = new Scale9Image(buttonSelectedHoverSkinTextures);
			button.selectedDownSkin = new Scale9Image(buttonSelectedDownSkinTextures);
			button.selectedDisabledSkin = new Scale9Image(buttonSelectedDisabledSkinTextures);

			button.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			button.focusPadding = -1;

			button.defaultLabelProperties.textFormat = this.defaultTextFormat;
			button.disabledLabelProperties.textFormat = this.disabledTextFormat;

			button.paddingTop = button.paddingBottom = 2;
			button.paddingLeft = button.paddingRight = 10;
			button.gap = 2;
			button.minWidth = button.minHeight = 12;
		}

		protected function pickerListButtonInitializer(button:Button):void
		{
			this.buttonInitializer(button);

			button.defaultIcon = new Image(pickerListUpIconTexture);
			button.hoverIcon = new Image(pickerListHoverIconTexture);
			button.downIcon = new Image(pickerListDownIconTexture);
			button.disabledIcon = new Image(pickerListDisabledIconTexture);
			button.gap = Number.POSITIVE_INFINITY; //fill as completely as possible
			button.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			button.iconPosition = Button.ICON_POSITION_RIGHT;
			button.paddingRight = 6;
		}

		protected function toggleSwitchOnTrackInitializer(track:Button):void
		{
			track.defaultSkin = new Scale9Image(buttonSelectedUpSkinTextures);
		}

		protected function toggleSwitchThumbInitializer(thumb:Button):void
		{
			this.buttonInitializer(thumb);
			thumb.width = thumb.height = buttonUpSkinTextures.texture.frame.height;
		}

		protected function checkInitializer(check:Check):void
		{
			check.defaultIcon = new Image(checkUpIconTexture);
			check.hoverIcon = new Image(checkHoverIconTexture);
			check.downIcon = new Image(checkDownIconTexture);
			check.disabledIcon = new Image(checkDisabledIconTexture);
			check.defaultSelectedIcon = new Image(checkSelectedUpIconTexture);
			check.selectedHoverIcon = new Image(checkSelectedHoverIconTexture);
			check.selectedDownIcon = new Image(checkSelectedDownIconTexture);
			check.selectedDisabledIcon = new Image(checkSelectedDisabledIconTexture);

			check.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			check.focusPadding = -2;

			check.defaultLabelProperties.textFormat = this.defaultTextFormat;
			check.disabledLabelProperties.textFormat = this.disabledTextFormat;

			check.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			check.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;

			check.gap = 4;
		}

		protected function radioInitializer(radio:Radio):void
		{
			radio.defaultIcon = new Image(radioUpIconTexture);
			radio.hoverIcon = new Image(radioHoverIconTexture);
			radio.downIcon = new Image(radioDownIconTexture);
			radio.disabledIcon = new Image(radioDisabledIconTexture);
			radio.defaultSelectedIcon = new Image(radioSelectedUpIconTexture);
			radio.selectedHoverIcon = new Image(radioSelectedHoverIconTexture);
			radio.selectedDownIcon = new Image(radioSelectedDownIconTexture);
			radio.selectedDisabledIcon = new Image(radioSelectedDisabledIconTexture);

			radio.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			radio.focusPadding = -2;

			radio.defaultLabelProperties.textFormat = this.defaultTextFormat;
			radio.disabledLabelProperties.textFormat = this.disabledTextFormat;

			radio.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			radio.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;

			radio.gap = 4;
		}

		protected function tabInitializer(tab:Button):void
		{
			tab.defaultSkin = new Scale9Image(tabUpSkinTextures);
			tab.hoverSkin = new Scale9Image(tabHoverSkinTextures);
			tab.downSkin = new Scale9Image(tabDownSkinTextures);
			tab.disabledSkin = new Scale9Image(tabDisabledSkinTextures);
			tab.defaultSelectedSkin = new Scale9Image(tabSelectedUpSkinTextures);
			tab.selectedDisabledSkin = new Scale9Image(tabSelectedDisabledSkinTextures);

			tab.defaultLabelProperties.textFormat = this.defaultTextFormat;
			tab.disabledLabelProperties.textFormat = this.disabledTextFormat;

			tab.paddingTop = tab.paddingBottom = 2;
			tab.paddingLeft = tab.paddingRight = 10;
			tab.gap = 2;
			tab.minWidth = tab.minHeight = 12;
		}

		protected function stepperIncrementButtonInitializer(button:Button):void
		{
			button.defaultSkin = new Scale9Image(stepperIncrementButtonUpSkinTextures);
			button.hoverSkin = new Scale9Image(stepperIncrementButtonHoverSkinTextures);
			button.downSkin = new Scale9Image(stepperIncrementButtonDownSkinTextures);
			button.disabledSkin = new Scale9Image(stepperIncrementButtonDisabledSkinTextures);
		}

		protected function stepperDecrementButtonInitializer(button:Button):void
		{
			button.defaultSkin = new Scale9Image(stepperDecrementButtonUpSkinTextures);
			button.hoverSkin = new Scale9Image(stepperDecrementButtonHoverSkinTextures);
			button.downSkin = new Scale9Image(stepperDecrementButtonDownSkinTextures);
			button.disabledSkin = new Scale9Image(stepperDecrementButtonDisabledSkinTextures);
		}

		protected function toggleSwitchInitializer(toggle:ToggleSwitch):void
		{
			toggle.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;
			toggle.labelAlign = ToggleSwitch.LABEL_ALIGN_MIDDLE;
			toggle.defaultLabelProperties.textFormat = this.defaultTextFormat;
			toggle.disabledLabelProperties.textFormat = this.disabledTextFormat;

			toggle.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			toggle.focusPadding = -1;
		}

		protected function buttonGroupInitializer(group:ButtonGroup):void
		{
			group.gap = 4;
		}

		protected function sliderInitializer(slider:Slider):void
		{
			slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_SINGLE;
			slider.minimumPadding = slider.maximumPadding = -vSliderThumbUpSkinTexture.height / 2;

			if(slider.direction == Slider.DIRECTION_VERTICAL)
			{
				slider.thumbProperties.defaultSkin = new Image(vSliderThumbUpSkinTexture);
				slider.thumbProperties.hoverSkin = new Image(vSliderThumbHoverSkinTexture);
				slider.thumbProperties.downSkin = new Image(vSliderThumbDownSkinTexture);
				slider.thumbProperties.disabledSkin = new Image(vSliderThumbDisabledSkinTexture);
				slider.minimumTrackProperties.defaultSkin = new Scale3Image(vSliderTrackSkinTextures);
				slider.focusPaddingLeft = slider.focusPaddingRight = -2;
				slider.focusPaddingTop = slider.focusPaddingBottom = -2 + slider.minimumPadding;
			}
			else //horizontal
			{
				slider.thumbProperties.defaultSkin = new Image(hSliderThumbUpSkinTexture);
				slider.thumbProperties.hoverSkin = new Image(hSliderThumbHoverSkinTexture);
				slider.thumbProperties.downSkin = new Image(hSliderThumbDownSkinTexture);
				slider.thumbProperties.disabledSkin = new Image(hSliderThumbDisabledSkinTexture);
				slider.minimumTrackProperties.defaultSkin = new Scale3Image(hSliderTrackSkinTextures);
				slider.focusPaddingTop = slider.focusPaddingBottom = -2;
				slider.focusPaddingLeft = slider.focusPaddingRight = -2 + slider.minimumPadding;
			}

			slider.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
		}

		protected function numericStepperInitializer(stepper:NumericStepper):void
		{
			stepper.buttonLayoutMode = NumericStepper.BUTTON_LAYOUT_MODE_RIGHT_SIDE_VERTICAL;

			stepper.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			stepper.focusPadding = -1;
		}

		protected function simpleScrollBarInitializer(scrollBar:SimpleScrollBar):void
		{
			if(scrollBar.direction == Slider.DIRECTION_VERTICAL)
			{
				scrollBar.thumbProperties.defaultSkin = new Scale9Image(vScrollBarThumbUpSkinTextures);
				scrollBar.thumbProperties.hoverSkin = new Scale9Image(vScrollBarThumbHoverSkinTextures);
				scrollBar.thumbProperties.downSkin = new Scale9Image(vScrollBarThumbDownSkinTextures);
				scrollBar.thumbProperties.defaultIcon = new Image(vScrollBarThumbIconTexture);
				scrollBar.thumbProperties.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
				scrollBar.thumbProperties.paddingLeft = 4;
			}
			else //horizontal
			{
				scrollBar.thumbProperties.defaultSkin = new Scale9Image(hScrollBarThumbUpSkinTextures);
				scrollBar.thumbProperties.hoverSkin = new Scale9Image(hScrollBarThumbHoverSkinTextures);
				scrollBar.thumbProperties.downSkin = new Scale9Image(hScrollBarThumbDownSkinTextures);
				scrollBar.thumbProperties.defaultIcon = new Image(hScrollBarThumbIconTexture);
				scrollBar.thumbProperties.verticalAlign = Button.VERTICAL_ALIGN_TOP;
				scrollBar.thumbProperties.paddingTop = 4;
			}
		}

		protected function scrollBarInitializer(scrollBar:ScrollBar):void
		{
			scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;

			const decrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
			decrementButtonDisabledIcon.alpha = 0;
			scrollBar.decrementButtonProperties.disabledIcon = decrementButtonDisabledIcon;

			const incrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
			incrementButtonDisabledIcon.alpha = 0;
			scrollBar.incrementButtonProperties.disabledIcon = incrementButtonDisabledIcon;

			if(scrollBar.direction == Slider.DIRECTION_VERTICAL)
			{
				scrollBar.decrementButtonProperties.defaultSkin = new Scale9Image(vScrollBarStepButtonUpSkinTextures);
				scrollBar.decrementButtonProperties.hoverSkin = new Scale9Image(vScrollBarStepButtonHoverSkinTextures);
				scrollBar.decrementButtonProperties.downSkin = new Scale9Image(vScrollBarStepButtonDownSkinTextures);
				scrollBar.decrementButtonProperties.disabledSkin = new Scale9Image(vScrollBarStepButtonDisabledSkinTextures);
				scrollBar.decrementButtonProperties.defaultIcon = new Image(vScrollBarDecrementButtonIconTexture);

				scrollBar.incrementButtonProperties.defaultSkin = new Scale9Image(vScrollBarStepButtonUpSkinTextures);
				scrollBar.incrementButtonProperties.hoverSkin = new Scale9Image(vScrollBarStepButtonHoverSkinTextures);
				scrollBar.incrementButtonProperties.downSkin = new Scale9Image(vScrollBarStepButtonDownSkinTextures);
				scrollBar.incrementButtonProperties.disabledSkin = new Scale9Image(vScrollBarStepButtonDisabledSkinTextures);
				scrollBar.incrementButtonProperties.defaultIcon = new Image(vScrollBarIncrementButtonIconTexture);

				var thumbSkin:Scale9Image = new Scale9Image(vScrollBarThumbUpSkinTextures);
				thumbSkin.height = thumbSkin.width;
				scrollBar.thumbProperties.defaultSkin = thumbSkin;
				thumbSkin = new Scale9Image(vScrollBarThumbHoverSkinTextures);
				thumbSkin.height = thumbSkin.width;
				scrollBar.thumbProperties.hoverSkin = thumbSkin;
				thumbSkin = new Scale9Image(vScrollBarThumbDownSkinTextures);
				thumbSkin.height = thumbSkin.width;
				scrollBar.thumbProperties.downSkin = thumbSkin;
				scrollBar.thumbProperties.defaultIcon = new Image(vScrollBarThumbIconTexture);
				scrollBar.thumbProperties.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
				scrollBar.thumbProperties.paddingLeft = 4;

				scrollBar.minimumTrackProperties.defaultSkin = new Scale9Image(vScrollBarTrackSkinTextures);
			}
			else //horizontal
			{
				scrollBar.decrementButtonProperties.defaultSkin = new Scale9Image(hScrollBarStepButtonUpSkinTextures);
				scrollBar.decrementButtonProperties.hoverSkin = new Scale9Image(hScrollBarStepButtonHoverSkinTextures);
				scrollBar.decrementButtonProperties.downSkin = new Scale9Image(hScrollBarStepButtonDownSkinTextures);
				scrollBar.decrementButtonProperties.disabledSkin = new Scale9Image(hScrollBarStepButtonDisabledSkinTextures);
				scrollBar.decrementButtonProperties.defaultIcon = new Image(hScrollBarDecrementButtonIconTexture);

				scrollBar.incrementButtonProperties.defaultSkin = new Scale9Image(hScrollBarStepButtonUpSkinTextures);
				scrollBar.incrementButtonProperties.hoverSkin = new Scale9Image(hScrollBarStepButtonHoverSkinTextures);
				scrollBar.incrementButtonProperties.downSkin = new Scale9Image(hScrollBarStepButtonDownSkinTextures);
				scrollBar.incrementButtonProperties.disabledSkin = new Scale9Image(hScrollBarStepButtonDisabledSkinTextures);
				scrollBar.incrementButtonProperties.defaultIcon = new Image(hScrollBarIncrementButtonIconTexture);

				thumbSkin = new Scale9Image(hScrollBarThumbUpSkinTextures);
				thumbSkin.width = thumbSkin.height;
				scrollBar.thumbProperties.defaultSkin = thumbSkin;
				thumbSkin = new Scale9Image(hScrollBarThumbHoverSkinTextures);
				thumbSkin.width = thumbSkin.height;
				scrollBar.thumbProperties.hoverSkin = thumbSkin;
				thumbSkin = new Scale9Image(hScrollBarThumbDownSkinTextures);
				thumbSkin.width = thumbSkin.height;
				scrollBar.thumbProperties.downSkin = thumbSkin;
				scrollBar.thumbProperties.defaultIcon = new Image(hScrollBarThumbIconTexture);
				scrollBar.thumbProperties.verticalAlign = Button.VERTICAL_ALIGN_TOP;
				scrollBar.thumbProperties.paddingTop = 4;

				scrollBar.minimumTrackProperties.defaultSkin = new Scale9Image(hScrollBarTrackTextures);
			}
		}

		protected function textInputInitializer(input:TextInput):void
		{
			input.minWidth = input.minHeight = 22;
			input.paddingTop = input.paddingBottom = 2;
 			input.paddingRight = input.paddingLeft = 4;
			input.textEditorProperties.textFormat = this.defaultTextFormat;

			input.backgroundSkin = new Scale9Image(textInputBackgroundSkinTextures);
			input.backgroundDisabledSkin = new Scale9Image(textInputBackgroundDisabledSkinTextures);

			input.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			input.focusPadding = -1;

			input.promptProperties.textFormat = this.defaultTextFormat;
		}

		protected function numericStepperTextInputInitializer(input:TextInput):void
		{
			input.minWidth = input.minHeight = 22;
			input.paddingTop = input.paddingBottom = 2;
			input.paddingRight = input.paddingLeft = 4;
			input.textEditorProperties.textFormat = this.defaultTextFormat;

			const backgroundSkin:Scale9Image = new Scale9Image(textInputBackgroundSkinTextures);
			backgroundSkin.width = backgroundSkin.height;
			input.backgroundSkin = backgroundSkin;
			const backgroundDisabledSkin:Scale9Image = new Scale9Image(textInputBackgroundDisabledSkinTextures);
			backgroundDisabledSkin.width = backgroundDisabledSkin.height;
			input.backgroundDisabledSkin = backgroundDisabledSkin;
		}

		protected function textAreaInitializer(textArea:TextArea):void
		{
			textArea.horizontalScrollBarFactory = horizontalScrollBarFactory;
			textArea.verticalScrollBarFactory = verticalScrollBarFactory;

			textArea.interactionMode = ScrollContainer.INTERACTION_MODE_MOUSE;
			textArea.scrollBarDisplayMode = ScrollContainer.SCROLL_BAR_DISPLAY_MODE_FIXED;

			textArea.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_AUTO;
			textArea.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_AUTO;

			textArea.textEditorProperties.textFormat = this.defaultTextFormat;

			textArea.paddingTop = 2;
			textArea.paddingBottom = 2;
			textArea.paddingRight = 4;
			textArea.paddingLeft = 4;

			textArea.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			textArea.focusPadding = -1;

			const backgroundSkin:Scale9Image = new Scale9Image(textInputBackgroundSkinTextures);
			backgroundSkin.width = 264;
			backgroundSkin.height = 88;
			textArea.backgroundSkin = backgroundSkin;
			const backgroundDisabledSkin:Scale9Image = new Scale9Image(textInputBackgroundDisabledSkinTextures);
			backgroundDisabledSkin.width = 264;
			backgroundDisabledSkin.height = 88;
			textArea.backgroundDisabledSkin = backgroundDisabledSkin;
		}

		protected function pageIndicatorInitializer(pageIndicator:PageIndicator):void
		{
			pageIndicator.normalSymbolFactory = this.pageIndicatorNormalSymbolFactory;
			pageIndicator.selectedSymbolFactory = this.pageIndicatorSelectedSymbolFactory;
			pageIndicator.gap = 12;
			pageIndicator.paddingTop = pageIndicator.paddingRight = pageIndicator.paddingBottom =
				pageIndicator.paddingLeft = 12;
			pageIndicator.minTouchWidth = pageIndicator.minTouchHeight = 12;
		}

		protected function progressBarInitializer(progress:ProgressBar):void
		{
			const backgroundSkin:Scale9Image = new Scale9Image(simpleBorderBackgroundSkinTextures);
			backgroundSkin.width = backgroundSkin.height * 30;
			progress.backgroundSkin = backgroundSkin;
			progress.fillSkin = new Image(progressBarFillSkinTexture);

			progress.paddingTop = progress.paddingRight = progress.paddingBottom =
				progress.paddingLeft = 1;
		}

		protected function scrollContainerInitializer(container:ScrollContainer):void
		{
			container.horizontalScrollBarFactory = horizontalScrollBarFactory;
			container.verticalScrollBarFactory = verticalScrollBarFactory;

			container.interactionMode = ScrollContainer.INTERACTION_MODE_MOUSE;
			container.scrollBarDisplayMode = ScrollContainer.SCROLL_BAR_DISPLAY_MODE_FIXED;

			container.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_AUTO;
			container.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_AUTO;
		}

		protected function panelInitializer(panel:Panel):void
		{
			panel.backgroundSkin = new Scale9Image(panelBorderBackgroundSkinTextures);
			panel.paddingTop = 0;
			panel.paddingRight = 10;
			panel.paddingBottom = 10;
			panel.paddingLeft = 10;

			panel.horizontalScrollBarFactory = horizontalScrollBarFactory;
			panel.verticalScrollBarFactory = verticalScrollBarFactory;
		}

		protected function listInitializer(list:List):void
		{
			list.backgroundSkin = new Scale9Image(simpleBorderBackgroundSkinTextures);

			list.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			list.focusPadding = -1;

			list.paddingTop = list.paddingRight = list.paddingBottom =
				list.paddingLeft = 1;

			list.horizontalScrollBarFactory = horizontalScrollBarFactory;
			list.verticalScrollBarFactory = verticalScrollBarFactory;

			list.interactionMode = List.INTERACTION_MODE_MOUSE;
			list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_FIXED;

			list.verticalScrollPolicy = List.SCROLL_POLICY_AUTO;
			list.horizontalScrollPolicy = List.SCROLL_POLICY_AUTO;
		}

		protected function groupedListInitializer(list:GroupedList):void
		{
			list.backgroundSkin = new Scale9Image(simpleBorderBackgroundSkinTextures);

			list.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			list.focusPadding = -1;

			list.paddingTop = list.paddingRight = list.paddingBottom =
				list.paddingLeft = 1;

			list.horizontalScrollBarFactory = horizontalScrollBarFactory;
			list.verticalScrollBarFactory = verticalScrollBarFactory;

			list.interactionMode = GroupedList.INTERACTION_MODE_MOUSE;
			list.scrollBarDisplayMode = GroupedList.SCROLL_BAR_DISPLAY_MODE_FIXED;

			list.verticalScrollPolicy = GroupedList.SCROLL_POLICY_AUTO;
			list.horizontalScrollPolicy = GroupedList.SCROLL_POLICY_AUTO;
		}

		protected function pickerListInitializer(list:PickerList):void
		{
			list.popUpContentManager = new DropDownPopUpContentManager();
		}

		protected function pickerListListInitializer(list:List):void
		{
			this.listInitializer(list);
			list.maxHeight = 110;
		}

		protected function defaultItemRendererInitializer(renderer:BaseDefaultItemRenderer):void
		{
			renderer.defaultSkin = new Image(itemRendererUpSkinTexture);
			renderer.hoverSkin = new Image(itemRendererHoverSkinTexture);
			renderer.downSkin = new Image(itemRendererSelectedUpSkinTexture);
			renderer.defaultSelectedSkin = new Image(itemRendererSelectedUpSkinTexture);

			renderer.defaultLabelProperties.textFormat = this.defaultTextFormat;
			renderer.disabledLabelProperties.textFormat = this.disabledTextFormat;

			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;

			renderer.iconPosition = Button.ICON_POSITION_LEFT;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;

			renderer.paddingTop = renderer.paddingBottom = 2;
			renderer.paddingRight = renderer.paddingLeft = 6;
			renderer.gap = 2;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.minWidth = renderer.minHeight = 22;
		}

		protected function defaultHeaderOrFooterRendererInitializer(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			renderer.backgroundSkin = new Scale9Image(groupedListHeaderBackgroundSkinTextures);
			renderer.backgroundSkin.height = 18;

			renderer.contentLabelProperties.textFormat = this.defaultTextFormat;

			renderer.paddingTop = renderer.paddingBottom = 2;
			renderer.paddingRight = renderer.paddingLeft = 6;
			renderer.minWidth = renderer.minHeight = 18;
		}

		protected function calloutInitializer(callout:Callout):void
		{
			callout.backgroundSkin = new Scale9Image(panelBorderBackgroundSkinTextures);
			const arrowSkin:Quad = new Quad(8, 8, 0xff00ff);
			arrowSkin.alpha = 0;
			callout.topArrowSkin =  callout.rightArrowSkin =  callout.bottomArrowSkin =
				callout.leftArrowSkin = arrowSkin;

			callout.paddingTop = callout.paddingBottom = 6;
			callout.paddingRight = callout.paddingLeft = 10;
		}

		protected function headerInitializer(header:Header):void
		{
			header.backgroundSkin = new Scale9Image(headerBackgroundSkinTextures);

			header.minHeight = 22;

			header.titleProperties.textFormat = this.defaultTextFormat;

			header.paddingTop = header.paddingBottom = 2;
			header.paddingRight = header.paddingLeft = 6;

			header.gap = 2;
			header.titleGap = 4;
		}

		protected function panelHeaderInitializer(header:Header):void
		{
			header.titleProperties.textFormat = this.defaultTextFormat;

			header.minHeight = 22;

			header.paddingTop = header.paddingBottom = 2;
			header.paddingRight = header.paddingLeft = 6;

			header.gap = 2;
			header.titleGap = 4;
		}

		protected function root_addedToStageHandler(event:Event):void
		{
			DisplayObject(event.currentTarget).stage.color = BACKGROUND_COLOR;
		}
	}
}
