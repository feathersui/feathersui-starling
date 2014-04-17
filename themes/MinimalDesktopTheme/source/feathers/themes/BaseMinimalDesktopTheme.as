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
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.core.FeathersControl;
	import feathers.core.FocusManager;
	import feathers.core.PopUpManager;
	import feathers.display.Scale9Image;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.skins.SmartDisplayObjectStateValueSelector;
	import feathers.skins.StandardIcons;
	import feathers.system.DeviceCapabilities;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	import feathers.utils.math.roundToNearest;

	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.SubTexture;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;

	/**
	 * The base class for the "Minimal" theme for desktop Feathers apps. Handles
	 * everything except asset loading, which is left to subclasses.
	 *
	 * @see MinimalDesktopTheme
	 * @see MinimalDesktopThemeWithAssetManager
	 */
	public class BaseMinimalDesktopTheme extends StyleNameFunctionTheme
	{
		public static const FONT_NAME:String = "PF Ronda Seven";

		protected static const THEME_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK:String = "minimal-desktop-horizontal-slider-minimum-track";
		protected static const THEME_NAME_VERTICAL_SLIDER_MINIMUM_TRACK:String = "minimal-desktop-vertical-slider-minimum-track";
		protected static const THEME_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON:String = "minimal-desktop-horizontal-scroll-bar-decrement-button";
		protected static const THEME_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON:String = "minimal-desktop-horizontal-scroll-bar-increment-button";
		protected static const THEME_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON:String = "minimal-desktop-vertical-scroll-bar-decrement-button";
		protected static const THEME_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON:String = "minimal-desktop-vertical-scroll-bar-increment-button";

		protected static const ATLAS_NAME:String = "minimal";
		protected static const FONT_TEXTURE_NAME:String = "pf_ronda_seven_0";

		protected static const SCALE_9_GRID:Rectangle = new Rectangle(2, 2, 1, 1);
		protected static const BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(2, 2, 1, 1);
		protected static const BUTTON_DOWN_SCALE_9_GRID:Rectangle = new Rectangle(3, 3, 1, 1);
		protected static const SCROLLBAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(1, 1, 2, 2);
		protected static const TAB_SCALE_9_GRID:Rectangle = new Rectangle(8, 5, 1, 1);
		protected static const HEADER_SCALE_9_GRID:Rectangle = new Rectangle(0, 5, 3, 1);
		protected static const BACK_BUTTON_SCALE_REGION1:int = 10;
		protected static const BACK_BUTTON_SCALE_REGION2:int = 1;
		protected static const FORWARD_BUTTON_SCALE_REGION1:int = 4;
		protected static const FORWARD_BUTTON_SCALE_REGION2:int = 1;

		protected static const BACKGROUND_COLOR:uint = 0xf3f3f3;
		protected static const LIST_BACKGROUND_COLOR:uint = 0xffffff;
		protected static const LIST_SELECTED_BACKGROUND_COLOR:uint = 0xdddddd;
		protected static const LIST_HOVER_BACKGROUND_COLOR:uint = 0xeeeeee;
		protected static const LIST_HEADER_BACKGROUND_COLOR:uint = 0xf8f8f8;
		protected static const PRIMARY_TEXT_COLOR:uint = 0x666666;
		protected static const DISABLED_TEXT_COLOR:uint = 0x999999;
		protected static const MODAL_OVERLAY_COLOR:uint = 0xcccccc;
		protected static const MODAL_OVERLAY_ALPHA:Number = 0.4;

		protected static function textRendererFactory():BitmapFontTextRenderer
		{
			var renderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
			//since it's a pixel font, we don't want to smooth it.
			renderer.smoothing = TextureSmoothing.NONE;
			return renderer;
		}

		protected static function textEditorFactory():TextFieldTextEditor
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

		public function BaseMinimalDesktopTheme()
		{
		}

		protected var scale:Number = 1;
		protected var fontSize:int;
		protected var headingFontSize:int;
		protected var detailFontSize:int;
		protected var inputFontSize:int;

		protected var atlas:TextureAtlas;
		protected var atlasTexture:Texture;

		protected var buttonUpSkinTextures:Scale9Textures;
		protected var buttonDownSkinTextures:Scale9Textures;
		protected var buttonDisabledSkinTextures:Scale9Textures;
		protected var buttonSelectedSkinTextures:Scale9Textures;
		protected var buttonSelectedDisabledSkinTextures:Scale9Textures;
		protected var buttonCallToActionUpSkinTextures:Scale9Textures;
		protected var buttonDangerUpSkinTextures:Scale9Textures;
		protected var buttonDangerDownSkinTextures:Scale9Textures;
		protected var buttonBackUpSkinTextures:Scale3Textures;
		protected var buttonBackDownSkinTextures:Scale3Textures;
		protected var buttonBackDisabledSkinTextures:Scale3Textures;
		protected var buttonForwardUpSkinTextures:Scale3Textures;
		protected var buttonForwardDownSkinTextures:Scale3Textures;
		protected var buttonForwardDisabledSkinTextures:Scale3Textures;

		protected var tabSkinTextures:Scale9Textures;
		protected var tabDisabledSkinTextures:Scale9Textures;
		protected var tabSelectedSkinTextures:Scale9Textures;
		protected var tabSelectedDisabledSkinTextures:Scale9Textures;

		protected var thumbSkinTextures:Scale9Textures;
		protected var thumbDisabledSkinTextures:Scale9Textures;

		protected var simpleScrollBarThumbSkinTextures:Scale9Textures;

		protected var insetBackgroundSkinTextures:Scale9Textures;
		protected var insetBackgroundDisabledSkinTextures:Scale9Textures;
		protected var insetBackgroundFocusedSkinTextures:Scale9Textures;

		protected var pickerListButtonIconUpTexture:Texture;
		protected var pickerListButtonIconSelectedTexture:Texture;
		protected var pickerListButtonIconDisabledTexture:Texture;
		protected var searchIconTexture:Texture;
		protected var upArrowIconTexture:Texture;
		protected var rightArrowIconTexture:Texture;
		protected var downArrowIconTexture:Texture;
		protected var leftArrowIconTexture:Texture;
		protected var upArrowDisabledIconTexture:Texture;
		protected var rightArrowDisabledIconTexture:Texture;
		protected var downArrowDisabledIconTexture:Texture;
		protected var leftArrowDisabledIconTexture:Texture;

		protected var headerSkinTextures:Scale9Textures;

		protected var popUpBackgroundSkinTextures:Scale9Textures;
		protected var calloutTopArrowSkinTexture:Texture;
		protected var calloutBottomArrowSkinTexture:Texture;
		protected var calloutLeftArrowSkinTexture:Texture;
		protected var calloutRightArrowSkinTexture:Texture;

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

		protected var primaryTextFormat:BitmapFontTextFormat;
		protected var disabledTextFormat:BitmapFontTextFormat;
		protected var headingTextFormat:BitmapFontTextFormat;
		protected var headingDisabledTextFormat:BitmapFontTextFormat;
		protected var detailTextFormat:BitmapFontTextFormat;
		protected var detailDisabledTextFormat:BitmapFontTextFormat;

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

		protected function assetManager_onProgress(progress:Number):void
		{
			if(progress < 1)
			{
				return;
			}
			this.initialize();
			this.dispatchEventWith(Event.COMPLETE);
		}

		protected function initialize():void
		{
			this.initializeTextures();
			this.initializeFonts();
			this.initializeGlobals();
			this.initializeStage();
			this.initializeStyleProviders();
		}

		protected function initializeGlobals():void
		{
			FocusManager.isEnabled = true;

			PopUpManager.overlayFactory = popUpOverlayFactory;
			Callout.stagePaddingTop = Callout.stagePaddingRight = Callout.stagePaddingBottom =
				Callout.stagePaddingLeft = 16 * this.scale;

			FeathersControl.defaultTextRendererFactory = textRendererFactory;
			FeathersControl.defaultTextEditorFactory = textEditorFactory;
		}

		protected function initializeTextures():void
		{
			this.buttonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-up-skin"), BUTTON_SCALE_9_GRID);
			this.buttonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("button-down-skin"), BUTTON_DOWN_SCALE_9_GRID);
			this.buttonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("button-disabled-skin"), BUTTON_SCALE_9_GRID);
			this.buttonSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("button-selected-skin"), BUTTON_DOWN_SCALE_9_GRID);
			this.buttonSelectedDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("button-selected-disabled-skin"), BUTTON_DOWN_SCALE_9_GRID);
			this.buttonCallToActionUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-call-to-action-up-skin"), BUTTON_SCALE_9_GRID);
			this.buttonDangerUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-danger-up-skin"), BUTTON_SCALE_9_GRID);
			this.buttonDangerDownSkinTextures = new Scale9Textures(this.atlas.getTexture("button-danger-down-skin"), BUTTON_DOWN_SCALE_9_GRID);
			this.buttonBackUpSkinTextures = new Scale3Textures(this.atlas.getTexture("button-back-up-skin"), BACK_BUTTON_SCALE_REGION1, BACK_BUTTON_SCALE_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
			this.buttonBackDownSkinTextures = new Scale3Textures(this.atlas.getTexture("button-back-down-skin"), BACK_BUTTON_SCALE_REGION1, BACK_BUTTON_SCALE_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
			this.buttonBackDisabledSkinTextures = new Scale3Textures(this.atlas.getTexture("button-back-disabled-skin"), BACK_BUTTON_SCALE_REGION1, BACK_BUTTON_SCALE_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
			this.buttonForwardUpSkinTextures = new Scale3Textures(this.atlas.getTexture("button-forward-up-skin"), FORWARD_BUTTON_SCALE_REGION1, FORWARD_BUTTON_SCALE_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
			this.buttonForwardDownSkinTextures = new Scale3Textures(this.atlas.getTexture("button-forward-down-skin"), FORWARD_BUTTON_SCALE_REGION1, FORWARD_BUTTON_SCALE_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
			this.buttonForwardDisabledSkinTextures = new Scale3Textures(this.atlas.getTexture("button-forward-disabled-skin"), FORWARD_BUTTON_SCALE_REGION1, FORWARD_BUTTON_SCALE_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);

			this.tabSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-skin"), TAB_SCALE_9_GRID);
			this.tabDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-disabled-skin"), TAB_SCALE_9_GRID);
			this.tabSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-skin"), TAB_SCALE_9_GRID);
			this.tabSelectedDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-disabled-skin"), TAB_SCALE_9_GRID);

			this.thumbSkinTextures = new Scale9Textures(this.atlas.getTexture("thumb-skin"), SCALE_9_GRID);
			this.thumbDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("thumb-disabled-skin"), SCALE_9_GRID);

			this.simpleScrollBarThumbSkinTextures = new Scale9Textures(this.atlas.getTexture("scrollbar-thumb-skin"), SCROLLBAR_THUMB_SCALE_9_GRID);

			this.insetBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("inset-background-skin"), SCALE_9_GRID);
			this.insetBackgroundDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("inset-background-disabled-skin"), SCALE_9_GRID);
			this.insetBackgroundFocusedSkinTextures = new Scale9Textures(this.atlas.getTexture("inset-background-focus-skin"), SCALE_9_GRID);

			this.pickerListButtonIconUpTexture = this.atlas.getTexture("picker-list-icon");
			this.pickerListButtonIconSelectedTexture = this.atlas.getTexture("picker-list-selected-icon");
			this.pickerListButtonIconDisabledTexture = this.atlas.getTexture("picker-list-disabled-icon");
			this.searchIconTexture = this.atlas.getTexture("search-icon");
			this.upArrowIconTexture = this.atlas.getTexture("up-arrow-icon");
			this.rightArrowIconTexture = this.atlas.getTexture("right-arrow-icon");
			this.downArrowIconTexture = this.atlas.getTexture("down-arrow-icon");
			this.leftArrowIconTexture = this.atlas.getTexture("left-arrow-icon");
			this.upArrowDisabledIconTexture = this.atlas.getTexture("up-arrow-disabled-icon");
			this.rightArrowDisabledIconTexture = this.atlas.getTexture("right-arrow-disabled-icon");
			this.downArrowDisabledIconTexture = this.atlas.getTexture("down-arrow-disabled-icon");
			this.leftArrowDisabledIconTexture = this.atlas.getTexture("left-arrow-disabled-icon");

			this.headerSkinTextures = new Scale9Textures(this.atlas.getTexture("header-skin"), HEADER_SCALE_9_GRID);

			this.popUpBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("callout-background-skin"), BUTTON_SCALE_9_GRID);
			this.calloutTopArrowSkinTexture = this.atlas.getTexture("callout-arrow-top");
			this.calloutBottomArrowSkinTexture = this.atlas.getTexture("callout-arrow-bottom");
			this.calloutLeftArrowSkinTexture = this.atlas.getTexture("callout-arrow-left");
			this.calloutRightArrowSkinTexture = this.atlas.getTexture("callout-arrow-right");

			this.checkIconTexture = this.atlas.getTexture("check-icon");
			this.checkDisabledIconTexture = this.atlas.getTexture("check-disabled-icon");
			this.checkSelectedIconTexture = this.atlas.getTexture("check-selected-icon");
			this.checkSelectedDisabledIconTexture = this.atlas.getTexture("check-selected-disabled-icon");

			this.radioIconTexture = this.atlas.getTexture("radio-icon");
			this.radioDisabledIconTexture = this.atlas.getTexture("radio-disabled-icon");
			this.radioSelectedIconTexture = this.atlas.getTexture("radio-selected-icon");
			this.radioSelectedDisabledIconTexture = this.atlas.getTexture("radio-selected-disabled-icon");

			this.pageIndicatorNormalSkinTexture = this.atlas.getTexture("page-indicator-normal-skin");
			this.pageIndicatorSelectedSkinTexture = this.atlas.getTexture("page-indicator-selected-skin");

			StandardIcons.listDrillDownAccessoryTexture = this.atlas.getTexture("list-accessory-drill-down-icon");
		}

		protected function initializeFonts():void
		{
			//since it's a pixel font, we want a multiple of the original size,
			//which, in this case, is 8.
			this.fontSize = Math.max(8, roundToNearest(8 * this.scale, 8));
			this.headingFontSize = Math.max(8, roundToNearest(16 * this.scale, 8));
			this.detailFontSize = Math.max(8, roundToNearest(8 * this.scale, 8));
			this.inputFontSize = Math.max(8, roundToNearest(8 * this.scale));

			this.primaryTextFormat = new BitmapFontTextFormat(FONT_NAME, this.fontSize, PRIMARY_TEXT_COLOR);
			this.disabledTextFormat = new BitmapFontTextFormat(FONT_NAME, this.fontSize, DISABLED_TEXT_COLOR);
			this.headingTextFormat = new BitmapFontTextFormat(FONT_NAME, this.headingFontSize, PRIMARY_TEXT_COLOR);
			this.headingDisabledTextFormat = new BitmapFontTextFormat(FONT_NAME, this.headingFontSize, DISABLED_TEXT_COLOR);
			this.detailTextFormat = new BitmapFontTextFormat(FONT_NAME, this.detailFontSize, PRIMARY_TEXT_COLOR);
			this.detailDisabledTextFormat = new BitmapFontTextFormat(FONT_NAME, this.detailFontSize, DISABLED_TEXT_COLOR);
		}

		protected function initializeStyleProviders():void
		{
			//alert
			this.getStyleProviderForClass(Alert).defaultStyleFunction = this.setAlertStyles;
			this.getStyleProviderForClass(Header).setFunctionForStyleName(Alert.DEFAULT_CHILD_NAME_HEADER, this.setPanelHeaderStyles);
			this.getStyleProviderForClass(ButtonGroup).setFunctionForStyleName(Alert.DEFAULT_CHILD_NAME_BUTTON_GROUP, this.setAlertButtonGroupStyles);
			this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(Alert.DEFAULT_CHILD_NAME_MESSAGE, this.setAlertMessageTextRendererStyles);

			//button
			this.getStyleProviderForClass(Button).defaultStyleFunction = this.setButtonStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_NAME_CALL_TO_ACTION_BUTTON, this.setCallToActionButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_NAME_DANGER_BUTTON, this.setDangerButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_NAME_BACK_BUTTON, this.setBackButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_NAME_FORWARD_BUTTON, this.setForwardButtonStyles);

			//button group
			this.getStyleProviderForClass(ButtonGroup).defaultStyleFunction = this.setButtonGroupStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ButtonGroup.DEFAULT_CHILD_NAME_BUTTON, this.setButtonGroupButtonStyles);

			//callout
			this.getStyleProviderForClass(Callout).defaultStyleFunction = this.setCalloutStyles;

			//check
			this.getStyleProviderForClass(Check).defaultStyleFunction = this.setCheckStyles;

			//check
			this.getStyleProviderForClass(Drawers).defaultStyleFunction = this.setDrawersStyles;

			//grouped list (see also: item renderers)
			this.getStyleProviderForClass(GroupedList).defaultStyleFunction = this.setGroupedListStyles;
			this.getStyleProviderForClass(GroupedList).setFunctionForStyleName(GroupedList.ALTERNATE_NAME_INSET_GROUPED_LIST, this.setInsetGroupedListStyles);

			//header
			this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;

			//item renderers for lists
			this.getStyleProviderForClass(DefaultListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_NAME_ACCESSORY_LABEL, this.setItemRendererAccessoryLabelStyles);
			this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_NAME_ICON_LABEL, this.setItemRendererIconLabelStyles);

			//header and footer renderers for grouped list
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).defaultStyleFunction = this.setGroupedListHeaderOrFooterRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_NAME_INSET_HEADER_RENDERER, this.setInsetGroupedListHeaderOrFooterRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_NAME_INSET_FOOTER_RENDERER, this.setInsetGroupedListHeaderOrFooterRendererStyles);

			//label
			this.getStyleProviderForClass(Label).defaultStyleFunction = this.setLabelStyles;
			this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_NAME_HEADING, this.setHeadingLabelStyles);
			this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_NAME_DETAIL, this.setDetailLabelStyles);

			//list (see also: item renderers)
			this.getStyleProviderForClass(List).defaultStyleFunction = this.setListStyles;

			//numeric stepper
			this.getStyleProviderForClass(NumericStepper).defaultStyleFunction = this.setNumericStepperStyles;
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_NAME_TEXT_INPUT, this.setNumericStepperTextInputStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_NAME_DECREMENT_BUTTON, this.setNumericStepperButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_NAME_INCREMENT_BUTTON, this.setNumericStepperButtonStyles);

			//page indicator
			this.getStyleProviderForClass(PageIndicator).defaultStyleFunction = this.setPageIndicatorStyles;

			//panel
			this.getStyleProviderForClass(Panel).defaultStyleFunction = this.setPanelStyles;
			this.getStyleProviderForClass(Header).setFunctionForStyleName(Panel.DEFAULT_CHILD_NAME_HEADER, this.setPanelHeaderStyles);

			//panel screen
			this.getStyleProviderForClass(PanelScreen).defaultStyleFunction = this.setPanelScreenStyles;
			this.getStyleProviderForClass(Header).setFunctionForStyleName(PanelScreen.DEFAULT_CHILD_NAME_HEADER, this.setPanelScreenHeaderStyles);

			//picker list (see also: item renderers)
			this.getStyleProviderForClass(PickerList).defaultStyleFunction = this.setPickerListStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(PickerList.DEFAULT_CHILD_NAME_BUTTON, this.setPickerListButtonStyles);
			this.getStyleProviderForClass(List).setFunctionForStyleName(PickerList.DEFAULT_CHILD_NAME_LIST, this.setPickerListListStyles);

			//progress bar
			this.getStyleProviderForClass(ProgressBar).defaultStyleFunction = this.setProgressBarStyles;

			//radio
			this.getStyleProviderForClass(Radio).defaultStyleFunction = this.setRadioStyles;

			//screen
			this.getStyleProviderForClass(Screen).defaultStyleFunction = this.setScreenStyles;

			//scroll bar
			this.getStyleProviderForClass(ScrollBar).setFunctionForStyleName(Scroller.DEFAULT_CHILD_NAME_HORIZONTAL_SCROLL_BAR, this.setHorizontalScrollBarStyles);
			this.getStyleProviderForClass(ScrollBar).setFunctionForStyleName(Scroller.DEFAULT_CHILD_NAME_VERTICAL_SCROLL_BAR, this.setVerticalScrollBarStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ScrollBar.DEFAULT_CHILD_NAME_THUMB, this.setScrollBarThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ScrollBar.DEFAULT_CHILD_NAME_MINIMUM_TRACK, this.setScrollBarMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON, this.setHorizontalScrollBarDecrementButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON, this.setHorizontalScrollBarIncrementButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON, this.setVerticalScrollBarDecrementButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON, this.setVerticalScrollBarIncrementButtonStyles);

			//scroll container
			this.getStyleProviderForClass(ScrollContainer).defaultStyleFunction = this.setScrollContainerStyles;
			this.getStyleProviderForClass(ScrollContainer).setFunctionForStyleName(ScrollContainer.ALTERNATE_NAME_TOOLBAR, this.setToolbarScrollContainerStyles);

			//scroll screen
			this.getStyleProviderForClass(ScrollScreen).defaultStyleFunction = this.setScrollScreenStyles;

			//scroll text
			this.getStyleProviderForClass(ScrollText).defaultStyleFunction = this.setScrollTextStyles;

			//simple scroll bar
			this.getStyleProviderForClass(Button).setFunctionForStyleName(SimpleScrollBar.DEFAULT_CHILD_NAME_THUMB, this.setSimpleScrollBarThumbStyles);

			//slider
			this.getStyleProviderForClass(Slider).defaultStyleFunction = this.setSliderStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Slider.DEFAULT_CHILD_NAME_THUMB, this.setSliderThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK, this.setHorizontalSliderMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SLIDER_MINIMUM_TRACK, this.setVerticalSliderMinimumTrackStyles);

			//tab bar
			this.getStyleProviderForClass(TabBar).defaultStyleFunction = this.setTabBarStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(TabBar.DEFAULT_CHILD_NAME_TAB, this.setTabStyles);

			//text input
			this.getStyleProviderForClass(TextInput).defaultStyleFunction = this.setTextInputStyles;
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName(TextInput.ALTERNATE_NAME_SEARCH_TEXT_INPUT, this.setSearchTextInputStyles);

			//text area
			this.getStyleProviderForClass(TextArea).defaultStyleFunction = this.setTextAreaStyles;

			//toggle switch
			this.getStyleProviderForClass(ToggleSwitch).defaultStyleFunction = this.setToggleSwitchStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_NAME_THUMB, this.setToggleSwitchThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_NAME_ON_TRACK, this.setToggleSwitchOnTrackStyles);
		}

		protected function pageIndicatorNormalSymbolFactory():DisplayObject
		{
			var symbol:ImageLoader = new ImageLoader();
			symbol.source = this.pageIndicatorNormalSkinTexture;
			symbol.textureScale = this.scale;
			symbol.snapToPixels = true;
			return symbol;
		}

		protected function pageIndicatorSelectedSymbolFactory():DisplayObject
		{
			var symbol:ImageLoader = new ImageLoader();
			symbol.source = this.pageIndicatorSelectedSkinTexture;
			symbol.textureScale = this.scale;
			symbol.snapToPixels = true;
			return symbol;
		}

		protected function imageLoaderFactory():ImageLoader
		{
			var image:ImageLoader = new ImageLoader();
			image.textureScale = this.scale;
			image.snapToPixels = true;
			return image;
		}

	//-------------------------
	// Shared
	//-------------------------

		protected function setScrollerStyles(scroller:Scroller):void
		{
			scroller.interactionMode = ScrollContainer.INTERACTION_MODE_MOUSE;
			scroller.scrollBarDisplayMode = ScrollContainer.SCROLL_BAR_DISPLAY_MODE_FIXED;
			scroller.horizontalScrollBarFactory = scrollBarFactory;
			scroller.verticalScrollBarFactory = scrollBarFactory;
		}

	//-------------------------
	// Alert
	//-------------------------

		protected function setAlertStyles(alert:Alert):void
		{
			this.setScrollerStyles(alert);

			var backgroundSkin:Scale9Image = new Scale9Image(this.popUpBackgroundSkinTextures, this.scale);
			backgroundSkin.width = 20 * this.scale;
			backgroundSkin.height = 20 * this.scale;
			alert.backgroundSkin = backgroundSkin;

			alert.paddingTop = alert.paddingBottom = 4 * this.scale;
			alert.paddingLeft = alert.paddingRight = 8 * this.scale;
			alert.gap = 4 * this.scale;

			alert.maxWidth = alert.maxHeight = 200 * this.scale;
		}

		protected function setAlertButtonGroupStyles(group:ButtonGroup):void
		{
			group.direction = ButtonGroup.DIRECTION_VERTICAL;
			group.horizontalAlign = ButtonGroup.HORIZONTAL_ALIGN_JUSTIFY;
			group.verticalAlign = ButtonGroup.VERTICAL_ALIGN_JUSTIFY;
			group.gap = 4 * this.scale;
			group.paddingTop = 8 * this.scale;
			group.paddingRight = 8 * this.scale;
			group.paddingBottom = 8 * this.scale;
			group.paddingLeft = 8 * this.scale;
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
			button.defaultLabelProperties.textFormat = this.primaryTextFormat;
			button.defaultLabelProperties.disabledTextFormat = this.disabledTextFormat;

			button.paddingTop = button.paddingBottom = 2 * this.scale;
			button.paddingLeft = button.paddingRight = 4 * this.scale;
			button.gap = 4 * this.scale;
			button.minGap = 4 * this.scale;
			button.minWidth = 20 * this.scale;
			button.minHeight = 20 * this.scale;
		}

		protected function setButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.defaultSelectedValue = this.buttonSelectedSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, true);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			skinSelector.displayObjectProperties =
			{
				width: 20 * this.scale,
				height: 20 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
			button.minWidth = 100 * this.scale;
		}

		protected function setCallToActionButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonCallToActionUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: 20 * this.scale,
				height: 20 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
			button.minWidth = 100 * this.scale;
		}

		protected function setQuietButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = null;
			skinSelector.defaultSelectedValue = this.buttonSelectedSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, true);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			skinSelector.displayObjectProperties =
			{
				width: 20 * this.scale,
				height: 20 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
		}

		protected function setDangerButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonDangerUpSkinTextures;
			skinSelector.setValueForState(this.buttonDangerDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: 20 * this.scale,
				height: 20 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
			button.minWidth = 100 * this.scale;
		}

		protected function setBackButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonBackUpSkinTextures;
			skinSelector.setValueForState(this.buttonBackDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonBackDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: 20 * this.scale,
				height: 20 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
			button.paddingLeft = 12 * this.scale;
		}

		protected function setForwardButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonForwardUpSkinTextures;
			skinSelector.setValueForState(this.buttonForwardDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonForwardDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: 20 * this.scale,
				height: 20 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
			button.paddingRight = 12 * this.scale
		}

	//-------------------------
	// ButtonGroup
	//-------------------------

		protected function setButtonGroupStyles(group:ButtonGroup):void
		{
			group.minWidth = 100 * this.scale;
			group.gap = 4 * this.scale;
		}

		protected function setButtonGroupButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.defaultSelectedValue = this.buttonSelectedSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, true);
			skinSelector.setValueForState(this.buttonSelectedSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			skinSelector.displayObjectProperties =
			{
				width: 20 * this.scale,
				height: 20 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.defaultLabelProperties.textFormat = this.primaryTextFormat;
			button.defaultLabelProperties.disabledTextFormat = this.disabledTextFormat;

			button.paddingTop = button.paddingBottom =
				button.paddingLeft = button.paddingRight = 2 * this.scale;
			button.gap = 4 * this.scale;
			button.minGap = 4 * this.scale;
			button.minWidth = 100 * this.scale;
			button.minHeight = 20 * this.scale;
		}

	//-------------------------
	// Callout
	//-------------------------

		protected function setCalloutStyles(callout:Callout):void
		{
			callout.minWidth = 20 * this.scale;
			callout.minHeight = 20 * this.scale;
			callout.paddingTop = callout.paddingRight = callout.paddingBottom =
				callout.paddingLeft = 4 * this.scale;
			var backgroundSkin:Scale9Image = new Scale9Image(popUpBackgroundSkinTextures, this.scale);
			backgroundSkin.width = 20 * this.scale;
			backgroundSkin.height = 20 * this.scale;
			callout.backgroundSkin = backgroundSkin;

			var topArrowSkin:Image = new Image(calloutTopArrowSkinTexture);
			topArrowSkin.scaleX = topArrowSkin.scaleY = this.scale;
			callout.topArrowSkin = topArrowSkin;
			callout.topArrowGap = -2 * this.scale;

			var bottomArrowSkin:Image = new Image(calloutBottomArrowSkinTexture);
			bottomArrowSkin.scaleX = bottomArrowSkin.scaleY = this.scale;
			callout.bottomArrowSkin = bottomArrowSkin;
			callout.bottomArrowGap = -2 * this.scale;

			var leftArrowSkin:Image = new Image(calloutLeftArrowSkinTexture);
			leftArrowSkin.scaleX = leftArrowSkin.scaleY = this.scale;
			callout.leftArrowSkin = leftArrowSkin;
			callout.leftArrowGap = -2 * this.scale;

			var rightArrowSkin:Image = new Image(calloutRightArrowSkinTexture);
			rightArrowSkin.scaleX = rightArrowSkin.scaleY = this.scale;
			callout.rightArrowSkin = rightArrowSkin;
			callout.rightArrowGap = -2 * this.scale;
		}

	//-------------------------
	// Check
	//-------------------------

		protected function setCheckStyles(check:Check):void
		{
			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
			iconSelector.defaultValue = this.checkIconTexture;
			iconSelector.defaultSelectedValue = this.checkSelectedIconTexture;
			iconSelector.setValueForState(this.checkDisabledIconTexture, Button.STATE_DISABLED, false);
			iconSelector.setValueForState(this.checkSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
			iconSelector.displayObjectProperties =
			{
				textureScale: this.scale,
				snapToPixels: true,
				smoothing: TextureSmoothing.NONE
			};
			check.stateToIconFunction = iconSelector.updateValue;

			check.defaultLabelProperties.textFormat = this.primaryTextFormat;
			check.defaultLabelProperties.disabledTextFormat = this.disabledTextFormat;

			check.gap = 4 * this.scale;
			check.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			check.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
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

			var backgroundSkin:Quad = new Quad(30 * this.scale, 30 * this.scale, LIST_BACKGROUND_COLOR);
			list.backgroundSkin = backgroundSkin;
		}

		//see List section for item renderer styles

		protected function setGroupedListHeaderOrFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			var backgroundSkin:Quad = new Quad(20 * this.scale, 20 * this.scale, LIST_HEADER_BACKGROUND_COLOR);
			renderer.backgroundSkin = backgroundSkin;

			renderer.contentLabelProperties.textFormat = this.primaryTextFormat;

			renderer.paddingTop = renderer.paddingBottom = 2 * this.scale;
			renderer.paddingLeft = renderer.paddingRight = 4 * this.scale;
			renderer.minWidth = renderer.minHeight = 20 * this.scale;

			renderer.contentLoaderFactory = this.imageLoaderFactory;
		}

		protected function setInsetGroupedListStyles(list:GroupedList):void
		{
			this.setScrollerStyles(list);

			list.verticalScrollPolicy = GroupedList.SCROLL_POLICY_AUTO;

			list.headerRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_HEADER_RENDERER;
			list.footerRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_FOOTER_RENDERER;

			var layout:VerticalLayout = new VerticalLayout();
			layout.useVirtualLayout = true;
			layout.padding = 10 * this.scale;
			layout.paddingTop = 0;
			layout.gap = 0;
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			list.layout = layout;
		}

		protected function setInsetGroupedListHeaderOrFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			renderer.contentLabelProperties.textFormat = this.primaryTextFormat;

			renderer.paddingTop = 8 * this.scale;
			renderer.paddingBottom = 2 * this.scale;
			renderer.paddingLeft = renderer.paddingRight = 6 * this.scale;
			renderer.minWidth = renderer.minHeight = 20 * this.scale;

			renderer.contentLoaderFactory = this.imageLoaderFactory;
		}

	//-------------------------
	// Header
	//-------------------------

		protected function setHeaderStyles(header:Header):void
		{
			header.minWidth = 30 * this.scale;
			header.minHeight = 30 * this.scale;
			header.paddingTop = header.paddingRight = header.paddingBottom =
				header.paddingLeft = 10 * this.scale;
			header.gap = 4 * this.scale;
			header.titleGap = 6 * this.scale;

			var backgroundSkin:Scale9Image = new Scale9Image(headerSkinTextures, this.scale);
			backgroundSkin.width = 30 * this.scale;
			backgroundSkin.height = 30 * this.scale;
			header.backgroundSkin = backgroundSkin;

			header.titleProperties.textFormat = this.primaryTextFormat;
			header.titleProperties.disabledTextFormat = this.disabledTextFormat;
		}

	//-------------------------
	// Label
	//-------------------------

		protected function setLabelStyles(label:Label):void
		{
			label.textRendererProperties.textFormat = this.primaryTextFormat;
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

			var backgroundSkin:Quad = new Quad(30 * this.scale, 30 * this.scale, LIST_BACKGROUND_COLOR);
			list.backgroundSkin = backgroundSkin;
		}

		protected function setItemRendererStyles(renderer:BaseDefaultItemRenderer):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = LIST_BACKGROUND_COLOR;
			skinSelector.defaultSelectedValue = LIST_SELECTED_BACKGROUND_COLOR;
			skinSelector.setValueForState(LIST_HOVER_BACKGROUND_COLOR, Button.STATE_HOVER, false);
			skinSelector.setValueForState(LIST_SELECTED_BACKGROUND_COLOR, Button.STATE_DOWN, false);
			skinSelector.displayObjectProperties =
			{
				width: 20 * this.scale,
				height: 20 * this.scale
			};
			renderer.stateToSkinFunction = skinSelector.updateValue;

			renderer.defaultLabelProperties.textFormat = this.primaryTextFormat;
			renderer.defaultLabelProperties.disabledTextFormat = this.disabledTextFormat;

			renderer.paddingTop = renderer.paddingBottom = 2 * this.scale;
			renderer.paddingLeft = renderer.paddingRight = 8 * this.scale;
			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			renderer.minWidth = renderer.minHeight = 20 * this.scale;

			renderer.gap = 4 * this.scale;
			renderer.minGap = 4 * this.scale;
			renderer.iconPosition = Button.ICON_POSITION_LEFT;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.minAccessoryGap = 4 * this.scale;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;

			renderer.accessoryLoaderFactory = this.imageLoaderFactory;
			renderer.iconLoaderFactory = this.imageLoaderFactory;
		}

		protected function setItemRendererAccessoryLabelStyles(renderer:BitmapFontTextRenderer):void
		{
			renderer.textFormat = this.primaryTextFormat;
		}

		protected function setItemRendererIconLabelStyles(renderer:BitmapFontTextRenderer):void
		{
			renderer.textFormat = this.primaryTextFormat;
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

		protected function setNumericStepperButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.defaultSelectedValue = this.buttonSelectedSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, true);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			skinSelector.displayObjectProperties =
			{
				width: 20 * this.scale,
				height: 20 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
		}

		protected function setNumericStepperTextInputStyles(input:TextInput):void
		{
			input.minWidth = input.minHeight = 18 * this.scale;
			input.gap = 4 * this.scale;
			input.paddingTop = input.paddingBottom = 0;
			input.paddingLeft = input.paddingRight = 2 * this.scale;
			input.textEditorProperties.textFormat = new TextFormat("PF Ronda Seven,Roboto,Helvetica,Arial,_sans", this.inputFontSize, PRIMARY_TEXT_COLOR, null, null, null, null, null, TextFormatAlign.CENTER);
			input.textEditorProperties.disabledTextFormat = new TextFormat("PF Ronda Seven,Roboto,Helvetica,Arial,_sans", this.inputFontSize, DISABLED_TEXT_COLOR, null, null, null, null, null, TextFormatAlign.CENTER);

			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.insetBackgroundSkinTextures;
			skinSelector.setValueForState(this.insetBackgroundDisabledSkinTextures, TextInput.STATE_DISABLED, false);
			skinSelector.setValueForState(this.insetBackgroundFocusedSkinTextures, TextInput.STATE_FOCUSED, false);
			skinSelector.displayObjectProperties =
			{
				width: 18 * this.scale,
				height: 18 * this.scale
			};
			input.stateToSkinFunction = skinSelector.updateValue;
		}

	//-------------------------
	// PageIndicator
	//-------------------------

		protected function setPageIndicatorStyles(pageIndicator:PageIndicator):void
		{
			pageIndicator.interactionMode = PageIndicator.INTERACTION_MODE_PRECISE;
			pageIndicator.normalSymbolFactory = this.pageIndicatorNormalSymbolFactory;
			pageIndicator.selectedSymbolFactory = this.pageIndicatorSelectedSymbolFactory;
			pageIndicator.gap = 4 * this.scale;
			pageIndicator.paddingTop = pageIndicator.paddingRight = pageIndicator.paddingBottom =
				pageIndicator.paddingLeft = 4 * this.scale;
		}

	//-------------------------
	// Panel
	//-------------------------

		protected function setPanelStyles(panel:Panel):void
		{
			this.setScrollerStyles(panel);

			var backgroundSkin:Scale9Image = new Scale9Image(popUpBackgroundSkinTextures, this.scale);
			backgroundSkin.width = 20 * this.scale;
			backgroundSkin.height = 20 * this.scale;
			panel.backgroundSkin = backgroundSkin;

			panel.paddingTop = panel.paddingRight = panel.paddingBottom =
				panel.paddingLeft = 14 * this.scale;
		}

		protected function setPanelHeaderStyles(header:Header):void
		{
			header.minWidth = 30 * this.scale;
			header.minHeight = 30 * this.scale;
			header.paddingTop = header.paddingBottom =
				header.paddingLeft = header.paddingRight = 10 * this.scale;
			header.gap = 4 * this.scale;
			header.titleGap = 6 * this.scale;

			var backgroundSkin:Scale9Image = new Scale9Image(popUpBackgroundSkinTextures, this.scale);
			backgroundSkin.width = 30 * this.scale;
			backgroundSkin.height = 30 * this.scale;
			header.backgroundSkin = backgroundSkin;

			header.titleProperties.textFormat = this.primaryTextFormat;
			header.titleProperties.disabledTextFormat = this.disabledTextFormat;
		}

	//-------------------------
	// PanelScreen
	//-------------------------

		protected function setPanelScreenStyles(screen:PanelScreen):void
		{
			this.setScrollerStyles(screen);
			screen.originalDPI = DeviceCapabilities.dpi;
		}

		protected function setPanelScreenHeaderStyles(header:Header):void
		{
			this.setPanelHeaderStyles(header);
			header.useExtraPaddingForOSStatusBar = true;
		}

	//-------------------------
	// PickerList
	//-------------------------

		protected function setPickerListStyles(list:PickerList):void
		{
			list.toggleButtonOnOpenAndClose = true;
			list.popUpContentManager = new DropDownPopUpContentManager();
		}

		protected function setPickerListListStyles(list:List):void
		{
			this.setListStyles(list);
			list.maxHeight = 110;
		}

		protected function setPickerListButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, true);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				width: 20 * this.scale,
				height: 20 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
			iconSelector.defaultValue = this.pickerListButtonIconUpTexture;
			iconSelector.defaultSelectedValue = this.pickerListButtonIconSelectedTexture;
			skinSelector.setValueForState(this.pickerListButtonIconDisabledTexture, Button.STATE_DISABLED, false);
			iconSelector.displayObjectProperties =
			{
				textureScale: this.scale,
				snapToPixels: true
			};
			button.stateToIconFunction = iconSelector.updateValue;

			this.setBaseButtonStyles(button);

			button.minWidth = 100 * this.scale;
			button.gap = Number.POSITIVE_INFINITY; //fill as completely as possible
			button.minGap = 12 * this.scale;
			button.paddingRight = 8 * this.scale;
			button.iconPosition = Button.ICON_POSITION_RIGHT;
			button.horizontalAlign =  Button.HORIZONTAL_ALIGN_LEFT;
		}

	//-------------------------
	// ProgressBar
	//-------------------------

		protected function setProgressBarStyles(progress:ProgressBar):void
		{
			var backgroundSkin:Scale9Image = new Scale9Image(insetBackgroundSkinTextures, this.scale);
			if(progress.direction == ProgressBar.DIRECTION_VERTICAL)
			{
				backgroundSkin.width = 16 * this.scale;
				backgroundSkin.height = 100 * this.scale;
			}
			else
			{
				backgroundSkin.width = 100 * this.scale;
				backgroundSkin.height = 16 * this.scale;
			}
			progress.backgroundSkin = backgroundSkin;

			var backgroundDisabledSkin:Scale9Image = new Scale9Image(insetBackgroundDisabledSkinTextures, this.scale);
			if(progress.direction == ProgressBar.DIRECTION_VERTICAL)
			{
				backgroundDisabledSkin.width = 16 * this.scale;
				backgroundDisabledSkin.height = 100 * this.scale;
			}
			else
			{
				backgroundDisabledSkin.width = 100 * this.scale;
				backgroundDisabledSkin.height = 16 * this.scale;
			}
			progress.backgroundDisabledSkin = backgroundDisabledSkin;

			var fillSkin:Scale9Image = new Scale9Image(buttonUpSkinTextures, this.scale);
			if(progress.direction == ProgressBar.DIRECTION_VERTICAL)
			{
				fillSkin.width = 16 * this.scale;
				fillSkin.height = 4 * this.scale;
			}
			else
			{
				fillSkin.width = 4 * this.scale;
				fillSkin.height = 16 * this.scale;
			}
			progress.fillSkin = fillSkin;

			var fillDisabledSkin:Scale9Image = new Scale9Image(buttonDisabledSkinTextures, this.scale);
			if(progress.direction == ProgressBar.DIRECTION_VERTICAL)
			{
				fillDisabledSkin.width = 16 * this.scale;
				fillDisabledSkin.height = 4 * this.scale;
			}
			else
			{
				fillDisabledSkin.width = 4 * this.scale;
				fillDisabledSkin.height = 16 * this.scale;
			}
			progress.fillDisabledSkin = fillDisabledSkin;
		}

	//-------------------------
	// Radio
	//-------------------------

		protected function setRadioStyles(radio:Radio):void
		{
			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
			iconSelector.defaultValue = this.radioIconTexture;
			iconSelector.defaultSelectedValue = this.radioSelectedIconTexture;
			iconSelector.setValueForState(this.radioDisabledIconTexture, Button.STATE_DISABLED, false);
			iconSelector.setValueForState(this.radioSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
			iconSelector.displayObjectProperties =
			{
				textureScale: this.scale,
				snapToPixels: true
			};
			radio.stateToIconFunction = iconSelector.updateValue;

			radio.defaultLabelProperties.textFormat = this.primaryTextFormat;
			radio.defaultLabelProperties.disabledTextFormat = this.disabledTextFormat;

			radio.gap = 4 * this.scale;
			radio.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			radio.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
		}

	//-------------------------
	// Screen
	//-------------------------

		protected function setScreenStyles(screen:Screen):void
		{
			screen.originalDPI = DeviceCapabilities.dpi;
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
		}

		protected function setVerticalScrollBarStyles(scrollBar:ScrollBar):void
		{
			scrollBar.direction = ScrollBar.DIRECTION_VERTICAL;
			scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;

			scrollBar.customIncrementButtonName = THEME_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON;
			scrollBar.customDecrementButtonName = THEME_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON;
		}

		protected function setScrollBarThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.thumbSkinTextures;
			skinSelector.defaultSelectedValue = this.thumbDisabledSkinTextures;
			skinSelector.displayObjectProperties =
			{
				width: 10 * this.scale,
				height: 10 * this.scale,
				textureScale: this.scale
			};
			thumb.stateToSkinFunction = skinSelector.updateValue;
		}

		protected function setScrollBarMinimumTrackStyles(track:Button):void
		{
			var sliderTrackDefaultSkin:Scale9Image = new Scale9Image(this.insetBackgroundSkinTextures, this.scale);
			sliderTrackDefaultSkin.width = 10 * this.scale;
			sliderTrackDefaultSkin.height = 10 * this.scale;
			track.defaultSkin = sliderTrackDefaultSkin;
		}

		protected function setBaseScrollBarButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.defaultSelectedValue = this.buttonSelectedSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, true);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			skinSelector.displayObjectProperties =
			{
				width: 10 * this.scale,
				height: 10 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.horizontalAlign = Button.HORIZONTAL_ALIGN_CENTER;
			button.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
			button.paddingTop = 0;
			button.paddingRight = 0;
			button.paddingBottom = 0;
			button.paddingLeft = 0;
			button.gap = 0;
			button.minGap = 0;
			button.minWidth = 10 * this.scale;
			button.minHeight = 10 * this.scale;
		}

		protected function setHorizontalScrollBarDecrementButtonStyles(button:Button):void
		{
			this.setBaseScrollBarButtonStyles(button);

			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.defaultValue = this.leftArrowIconTexture;
			iconSelector.defaultSelectedValue = this.leftArrowDisabledIconTexture;
			iconSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			button.stateToIconFunction = iconSelector.updateValue;
		}

		protected function setHorizontalScrollBarIncrementButtonStyles(button:Button):void
		{
			this.setBaseScrollBarButtonStyles(button);

			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.defaultValue = this.rightArrowIconTexture;
			iconSelector.defaultSelectedValue = this.rightArrowDisabledIconTexture;
			iconSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			button.stateToIconFunction = iconSelector.updateValue;
		}

		protected function setVerticalScrollBarDecrementButtonStyles(button:Button):void
		{
			this.setBaseScrollBarButtonStyles(button);

			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.defaultValue = this.upArrowIconTexture;
			iconSelector.defaultSelectedValue = this.upArrowDisabledIconTexture;
			iconSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			button.stateToIconFunction = iconSelector.updateValue;
		}

		protected function setVerticalScrollBarIncrementButtonStyles(button:Button):void
		{
			this.setBaseScrollBarButtonStyles(button);

			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.defaultValue = this.downArrowIconTexture;
			iconSelector.defaultSelectedValue = this.downArrowDisabledIconTexture;
			iconSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			button.stateToIconFunction = iconSelector.updateValue;
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
				layout.paddingTop = layout.paddingRight = layout.paddingBottom =
					layout.paddingLeft = 14 * this.scale;
				layout.gap = 8 * this.scale;
				container.layout = layout;
			}

			container.minWidth = 30 * this.scale;
			container.minHeight = 30 * this.scale;

			var backgroundSkin:Scale9Image = new Scale9Image(headerSkinTextures, this.scale);
			backgroundSkin.width = 30 * this.scale;
			backgroundSkin.height = 30 * this.scale;
			container.backgroundSkin = backgroundSkin;
		}

	//-------------------------
	// ScrollScreen
	//-------------------------

		protected function setScrollScreenStyles(screen:ScrollScreen):void
		{
			this.setScrollerStyles(screen);
			screen.originalDPI = DeviceCapabilities.dpi;
		}

	//-------------------------
	// ScrollText
	//-------------------------

		protected function setScrollTextStyles(text:ScrollText):void
		{
			this.setScrollerStyles(text);

			text.textFormat = new TextFormat("PF Ronda Seven,Roboto,Helvetica,Arial,_sans", this.fontSize, PRIMARY_TEXT_COLOR);
			text.disabledTextFormat = new TextFormat("PF Ronda Seven,Roboto,Helvetica,Arial,_sans", this.fontSize, DISABLED_TEXT_COLOR);
			text.paddingTop = text.paddingRight = text.paddingBottom = text.paddingLeft = 4 * this.scale;
		}

	//-------------------------
	// SimpleScrollBar
	//-------------------------

		protected function setSimpleScrollBarThumbStyles(thumb:Button):void
		{
			var defaultSkin:Scale9Image = new Scale9Image(this.simpleScrollBarThumbSkinTextures, this.scale);
			defaultSkin.width = 4 * this.scale;
			defaultSkin.height = 4 * this.scale;
			thumb.defaultSkin = defaultSkin;
		}

	//-------------------------
	// Slider
	//-------------------------

		protected function setSliderStyles(slider:Slider):void
		{
			slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_SINGLE;

			if(slider.direction == Slider.DIRECTION_VERTICAL)
			{
				slider.customMinimumTrackName = THEME_NAME_VERTICAL_SLIDER_MINIMUM_TRACK;
			}
			else //horizontal
			{
				slider.customMinimumTrackName = THEME_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK;
			}
		}

		protected function setHorizontalSliderMinimumTrackStyles(track:Button):void
		{
			var sliderTrackDefaultSkin:Scale9Image = new Scale9Image(insetBackgroundSkinTextures, this.scale);
			sliderTrackDefaultSkin.width = 100 * this.scale;
			sliderTrackDefaultSkin.height = 10 * this.scale;
			track.defaultSkin = sliderTrackDefaultSkin;
		}

		protected function setVerticalSliderMinimumTrackStyles(track:Button):void
		{
			var sliderTrackDefaultSkin:Scale9Image = new Scale9Image(insetBackgroundSkinTextures, this.scale);
			sliderTrackDefaultSkin.width = 10 * this.scale;
			sliderTrackDefaultSkin.height = 100 * this.scale;
			track.defaultSkin = sliderTrackDefaultSkin;
		}

		protected function setSliderThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.thumbSkinTextures;
			skinSelector.defaultSelectedValue = this.thumbDisabledSkinTextures;
			skinSelector.displayObjectProperties =
			{
				width: 10 * this.scale,
				height: 10 * this.scale,
				textureScale: this.scale
			};
			thumb.stateToSkinFunction = skinSelector.updateValue;
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
			skinSelector.defaultValue = this.tabSkinTextures;
			skinSelector.defaultSelectedValue = this.tabSelectedSkinTextures;
			skinSelector.setValueForState(this.tabDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.tabSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			skinSelector.displayObjectProperties =
			{
				width: 20 * this.scale,
				height: 20 * this.scale,
				textureScale: this.scale
			};
			tab.stateToSkinFunction = skinSelector.updateValue;

			tab.defaultLabelProperties.textFormat = this.primaryTextFormat;
			tab.defaultLabelProperties.disabledTextFormat = this.disabledTextFormat;

			tab.iconPosition = Button.ICON_POSITION_LEFT;
			tab.paddingTop = tab.paddingBottom = 2 * this.scale;
			tab.paddingRight = tab.paddingLeft = 4 * this.scale;
			tab.gap = 4 * this.scale;
			tab.minGap = 4 * this.scale;
			tab.minWidth = 100 * this.scale;
			tab.minHeight = 20 * this.scale;
		}

	//-------------------------
	// TextArea
	//-------------------------

		protected function setTextAreaStyles(textArea:TextArea):void
		{
			this.setScrollerStyles(textArea);

			textArea.textEditorProperties.textFormat = new TextFormat("PF Ronda Seven,Roboto,Helvetica,Arial,_sans", this.fontSize, PRIMARY_TEXT_COLOR);
			textArea.textEditorProperties.disabledTextFormat = new TextFormat("PF Ronda Seven,Roboto,Helvetica,Arial,_sans", this.fontSize, DISABLED_TEXT_COLOR);

			textArea.paddingTop = 14 * this.scale;
			textArea.paddingBottom = 8 * this.scale;
			textArea.paddingLeft = textArea.paddingRight = 16 * this.scale;

			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.insetBackgroundSkinTextures;
			skinSelector.setValueForState(this.insetBackgroundDisabledSkinTextures, TextInput.STATE_DISABLED, false);
			skinSelector.setValueForState(this.insetBackgroundFocusedSkinTextures, TextInput.STATE_FOCUSED, false);
			skinSelector.displayObjectProperties =
			{
				width: 200 * this.scale,
				height: 100 * this.scale
			};
			textArea.stateToSkinFunction = skinSelector.updateValue;
		}

	//-------------------------
	// TextInput
	//-------------------------

		protected function setBaseTextInputStyles(input:TextInput):void
		{
			input.minWidth = input.minHeight = 18 * this.scale;
			input.gap = 4 * this.scale;
			input.paddingTop = input.paddingBottom = 0;
			input.paddingLeft = input.paddingRight = 2 * this.scale;
			input.textEditorProperties.textFormat = new TextFormat("PF Ronda Seven,Roboto,Helvetica,Arial,_sans", this.inputFontSize, PRIMARY_TEXT_COLOR);
			input.textEditorProperties.disabledTextFormat = new TextFormat("PF Ronda Seven,Roboto,Helvetica,Arial,_sans", this.inputFontSize, DISABLED_TEXT_COLOR);
			input.promptProperties.textFormat = this.primaryTextFormat;
			input.promptProperties.disabledTextFormat = this.disabledTextFormat;

			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.insetBackgroundSkinTextures;
			skinSelector.setValueForState(this.insetBackgroundDisabledSkinTextures, TextInput.STATE_DISABLED, false);
			skinSelector.setValueForState(this.insetBackgroundFocusedSkinTextures, TextInput.STATE_FOCUSED, false);
			skinSelector.displayObjectProperties =
			{
				width: 100 * this.scale,
				height: 18 * this.scale
			};
			input.stateToSkinFunction = skinSelector.updateValue;
		}

		protected function setTextInputStyles(input:TextInput):void
		{
			this.setBaseTextInputStyles(input);
		}

		protected function setSearchTextInputStyles(input:TextInput):void
		{
			this.setBaseTextInputStyles(input);

			var searchIcon:ImageLoader = new ImageLoader();
			searchIcon.source = this.searchIconTexture;
			searchIcon.snapToPixels = true;
			input.defaultIcon = searchIcon;
		}

	//-------------------------
	// ToggleSwitch
	//-------------------------

		protected function setToggleSwitchStyles(toggleSwitch:ToggleSwitch):void
		{
			toggleSwitch.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;

			toggleSwitch.defaultLabelProperties.textFormat = this.primaryTextFormat;
			toggleSwitch.defaultLabelProperties.disabledTextFormat = this.disabledTextFormat;
		}

		protected function setToggleSwitchOnTrackStyles(track:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.insetBackgroundSkinTextures;
			skinSelector.defaultSelectedValue = this.insetBackgroundDisabledSkinTextures;
			skinSelector.displayObjectProperties =
			{
				width: 40 * this.scale,
				height: 16 * this.scale,
				textureScale: this.scale
			};
			track.stateToSkinFunction = skinSelector.updateValue;
		}

		protected function setToggleSwitchThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.thumbSkinTextures;
			skinSelector.defaultSelectedValue = this.thumbDisabledSkinTextures;
			skinSelector.displayObjectProperties =
			{
				width: 16 * this.scale,
				height: 16 * this.scale,
				textureScale: this.scale
			};
			thumb.stateToSkinFunction = skinSelector.updateValue;
		}
	}
}
