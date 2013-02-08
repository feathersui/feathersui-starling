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
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.PageIndicator;
	import feathers.controls.PanelScreen;
	import feathers.controls.PickerList;
	import feathers.controls.ProgressBar;
	import feathers.controls.Radio;
	import feathers.controls.Screen;
	import feathers.controls.ScrollText;
	import feathers.controls.SimpleScrollBar;
	import feathers.controls.Slider;
	import feathers.controls.TabBar;
	import feathers.controls.TextInput;
	import feathers.controls.ToggleSwitch;
	import feathers.controls.popups.CalloutPopUpContentManager;
	import feathers.controls.popups.VerticalCenteredPopUpContentManager;
	import feathers.controls.renderers.BaseDefaultItemRenderer;
	import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.DisplayListWatcher;
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.layout.VerticalLayout;
	import feathers.skins.ImageStateValueSelector;
	import feathers.skins.Scale9ImageStateValueSelector;
	import feathers.skins.StandardIcons;
	import feathers.system.DeviceCapabilities;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class AzureMobileTheme extends DisplayListWatcher
	{
		[Embed(source="/../assets/images/azure.png")]
		protected static const ATLAS_IMAGE:Class;

		[Embed(source="/../assets/images/azure.xml",mimeType="application/octet-stream")]
		protected static const ATLAS_XML:Class;

		[Embed(source="/../assets/fonts/lato30.fnt",mimeType="application/octet-stream")]
		protected static const ATLAS_FONT_XML:Class;

		protected static const PROGRESS_BAR_SCALE_3_FIRST_REGION:Number = 12;
		protected static const PROGRESS_BAR_SCALE_3_SECOND_REGION:Number = 12;
		protected static const BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(8, 8, 15, 49);
		protected static const SLIDER_FIRST:Number = 16;
		protected static const SLIDER_SECOND:Number = 8;
		protected static const CALLOUT_SCALE_9_GRID:Rectangle = new Rectangle(8, 24, 15, 33);
		protected static const SCROLL_BAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(4, 4, 4, 4);

		protected static const BACKGROUND_COLOR:uint = 0x13171a;
		protected static const PRIMARY_TEXT_COLOR:uint = 0xe5e5e5;
		protected static const SELECTED_TEXT_COLOR:uint = 0xffffff;
		protected static const LIST_BACKGROUND_COLOR:uint = 0x1d2326;

		protected static const ORIGINAL_DPI_IPHONE_RETINA:int = 326;
		protected static const ORIGINAL_DPI_IPAD_RETINA:int = 264;

		protected static function textRendererFactory():BitmapFontTextRenderer
		{
			return new BitmapFontTextRenderer();
		}

		protected static function textEditorFactory():StageTextTextEditor
		{
			return new StageTextTextEditor();
		}

		public function AzureMobileTheme(container:DisplayObjectContainer = null, scaleToDPI:Boolean = true)
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
			this._scaleToDPI = scaleToDPI;
			this.initialize();
		}

		protected var _originalDPI:int;

		public function get originalDPI():int
		{
			return this._originalDPI;
		}

		protected var _scaleToDPI:Boolean;

		public function get scaleToDPI():Boolean
		{
			return this._scaleToDPI;
		}

		protected var scale:Number;
		protected var fontSize:int;

		protected var atlas:TextureAtlas;
		protected var atlasBitmapData:BitmapData;

		protected var bitmapFont:BitmapFont;

		protected var buttonUpSkinTextures:Scale9Textures;
		protected var buttonDownSkinTextures:Scale9Textures;
		protected var buttonDisabledSkinTextures:Scale9Textures;

		protected var hSliderMinimumTrackUpSkinTextures:Scale3Textures;
		protected var hSliderMinimumTrackDownSkinTextures:Scale3Textures;
		protected var hSliderMinimumTrackDisabledSkinTextures:Scale3Textures;

		protected var hSliderMaximumTrackUpSkinTextures:Scale3Textures;
		protected var hSliderMaximumTrackDownSkinTextures:Scale3Textures;
		protected var hSliderMaximumTrackDisabledSkinTextures:Scale3Textures;

		protected var vSliderMinimumTrackUpSkinTextures:Scale3Textures;
		protected var vSliderMinimumTrackDownSkinTextures:Scale3Textures;
		protected var vSliderMinimumTrackDisabledSkinTextures:Scale3Textures;

		protected var vSliderMaximumTrackUpSkinTextures:Scale3Textures;
		protected var vSliderMaximumTrackDownSkinTextures:Scale3Textures;
		protected var vSliderMaximumTrackDisabledSkinTextures:Scale3Textures;

		protected var sliderThumbUpSkinTexture:Texture;
		protected var sliderThumbDownSkinTexture:Texture;
		protected var sliderThumbDisabledSkinTexture:Texture;

		protected var scrollBarThumbSkinTextures:Scale9Textures;

		protected var progressBarBackgroundSkinTextures:Scale3Textures;
		protected var progressBarBackgroundDisabledSkinTextures:Scale3Textures;
		protected var progressBarFillSkinTextures:Scale3Textures;
		protected var progressBarFillDisabledSkinTextures:Scale3Textures;

		protected var insetBackgroundSkinTextures:Scale9Textures;
		protected var insetBackgroundDisabledSkinTextures:Scale9Textures;

		protected var pickerIconTexture:Texture;

		protected var listItemUpTexture:Texture;
		protected var listItemDownTexture:Texture;

		protected var groupedListHeaderBackgroundSkinTexture:Texture;

		protected var toolBarBackgroundSkinTexture:Texture;

		protected var tabSelectedSkinTexture:Texture;

		protected var calloutBackgroundSkinTextures:Scale9Textures;
		protected var calloutTopArrowSkinTexture:Texture;
		protected var calloutBottomArrowSkinTexture:Texture;
		protected var calloutLeftArrowSkinTexture:Texture;
		protected var calloutRightArrowSkinTexture:Texture;

		protected var checkUpIconTexture:Texture;
		protected var checkDownIconTexture:Texture;
		protected var checkDisabledIconTexture:Texture;
		protected var checkSelectedUpIconTexture:Texture;
		protected var checkSelectedDownIconTexture:Texture;
		protected var checkSelectedDisabledIconTexture:Texture;

		protected var radioUpIconTexture:Texture;
		protected var radioDownIconTexture:Texture;
		protected var radioDisabledIconTexture:Texture;
		protected var radioSelectedUpIconTexture:Texture;
		protected var radioSelectedDisabledIconTexture:Texture;

		protected var pageIndicatorSelectedSkinTexture:Texture;
		protected var pageIndicatorNormalSkinTexture:Texture;

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
			const scaledDPI:int = DeviceCapabilities.dpi / Starling.contentScaleFactor;
			if(this._scaleToDPI)
			{
				if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
				{
					this._originalDPI = ORIGINAL_DPI_IPAD_RETINA;
				}
				else
				{
					this._originalDPI = ORIGINAL_DPI_IPHONE_RETINA;
				}
			}
			else
			{
				this._originalDPI = scaledDPI;
			}
			this.scale = scaledDPI / this._originalDPI;

			this.fontSize = 30 * this.scale;

			Callout.stagePaddingTop = Callout.stagePaddingRight = Callout.stagePaddingBottom =
				Callout.stagePaddingLeft = 16 * this.scale;

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

			this.bitmapFont = new BitmapFont(this.atlas.getTexture("lato30_0"), XML(new ATLAS_FONT_XML()));

			this.buttonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-up-skin"), BUTTON_SCALE_9_GRID);
			this.buttonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("button-down-skin"), BUTTON_SCALE_9_GRID);
			this.buttonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("button-disabled-skin"), BUTTON_SCALE_9_GRID);

			this.hSliderMinimumTrackUpSkinTextures = new Scale3Textures(this.atlas.getTexture("hslider-minimum-track-up-skin"), SLIDER_FIRST, SLIDER_SECOND, Scale3Textures.DIRECTION_HORIZONTAL);
			this.hSliderMinimumTrackDownSkinTextures = new Scale3Textures(this.atlas.getTexture("hslider-minimum-track-down-skin"), SLIDER_FIRST, SLIDER_SECOND, Scale3Textures.DIRECTION_HORIZONTAL);
			this.hSliderMinimumTrackDisabledSkinTextures = new Scale3Textures(this.atlas.getTexture("hslider-minimum-track-disabled-skin"), SLIDER_FIRST, SLIDER_SECOND, Scale3Textures.DIRECTION_HORIZONTAL);

			this.hSliderMaximumTrackUpSkinTextures = new Scale3Textures(this.atlas.getTexture("hslider-maximum-track-up-skin"), 0, SLIDER_SECOND, Scale3Textures.DIRECTION_HORIZONTAL);
			this.hSliderMaximumTrackDownSkinTextures = new Scale3Textures(this.atlas.getTexture("hslider-maximum-track-down-skin"), 0, SLIDER_SECOND, Scale3Textures.DIRECTION_HORIZONTAL);
			this.hSliderMaximumTrackDisabledSkinTextures = new Scale3Textures(this.atlas.getTexture("hslider-maximum-track-disabled-skin"), 0, SLIDER_SECOND, Scale3Textures.DIRECTION_HORIZONTAL);

			this.vSliderMinimumTrackUpSkinTextures = new Scale3Textures(this.atlas.getTexture("vslider-minimum-track-up-skin"), 0, SLIDER_SECOND, Scale3Textures.DIRECTION_VERTICAL);
			this.vSliderMinimumTrackDownSkinTextures = new Scale3Textures(this.atlas.getTexture("vslider-minimum-track-down-skin"), 0, SLIDER_SECOND, Scale3Textures.DIRECTION_VERTICAL);
			this.vSliderMinimumTrackDisabledSkinTextures = new Scale3Textures(this.atlas.getTexture("vslider-minimum-track-disabled-skin"), 0, SLIDER_SECOND, Scale3Textures.DIRECTION_VERTICAL);

			this.vSliderMaximumTrackUpSkinTextures = new Scale3Textures(this.atlas.getTexture("vslider-maximum-track-up-skin"), SLIDER_FIRST, SLIDER_SECOND, Scale3Textures.DIRECTION_VERTICAL);
			this.vSliderMaximumTrackDownSkinTextures = new Scale3Textures(this.atlas.getTexture("vslider-maximum-track-down-skin"), SLIDER_FIRST, SLIDER_SECOND, Scale3Textures.DIRECTION_VERTICAL);
			this.vSliderMaximumTrackDisabledSkinTextures = new Scale3Textures(this.atlas.getTexture("vslider-maximum-track-disabled-skin"), SLIDER_FIRST, SLIDER_SECOND, Scale3Textures.DIRECTION_VERTICAL);

			this.sliderThumbUpSkinTexture = this.atlas.getTexture("slider-thumb-up-skin");
			this.sliderThumbDownSkinTexture = this.atlas.getTexture("slider-thumb-down-skin");
			this.sliderThumbDisabledSkinTexture = this.atlas.getTexture("slider-thumb-disabled-skin");

			this.scrollBarThumbSkinTextures = new Scale9Textures(this.atlas.getTexture("simple-scroll-bar-thumb-skin"), SCROLL_BAR_THUMB_SCALE_9_GRID);

			this.progressBarBackgroundSkinTextures = new Scale3Textures(this.atlas.getTexture("progress-bar-background-skin"), PROGRESS_BAR_SCALE_3_FIRST_REGION, PROGRESS_BAR_SCALE_3_SECOND_REGION, Scale3Textures.DIRECTION_HORIZONTAL);
			this.progressBarBackgroundDisabledSkinTextures = new Scale3Textures(this.atlas.getTexture("progress-bar-background-disabled-skin"), PROGRESS_BAR_SCALE_3_FIRST_REGION, PROGRESS_BAR_SCALE_3_SECOND_REGION, Scale3Textures.DIRECTION_HORIZONTAL);
			this.progressBarFillSkinTextures = new Scale3Textures(this.atlas.getTexture("progress-bar-fill-skin"), PROGRESS_BAR_SCALE_3_FIRST_REGION, PROGRESS_BAR_SCALE_3_SECOND_REGION, Scale3Textures.DIRECTION_HORIZONTAL);
			this.progressBarFillDisabledSkinTextures = new Scale3Textures(this.atlas.getTexture("progress-bar-fill-disabled-skin"), PROGRESS_BAR_SCALE_3_FIRST_REGION, PROGRESS_BAR_SCALE_3_SECOND_REGION, Scale3Textures.DIRECTION_HORIZONTAL);

			this.insetBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("inset-skin"), BUTTON_SCALE_9_GRID);
			this.insetBackgroundDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("inset-disabled-skin"), BUTTON_SCALE_9_GRID);

			this.pickerIconTexture = this.atlas.getTexture("picker-icon");

			this.listItemUpTexture = this.atlas.getTexture("list-item-up-skin");
			this.listItemDownTexture = this.atlas.getTexture("list-item-down-skin");

			this.groupedListHeaderBackgroundSkinTexture = this.atlas.getTexture("grouped-list-header-background-skin");

			this.toolBarBackgroundSkinTexture = this.atlas.getTexture("toolbar-background-skin");

			this.tabSelectedSkinTexture = this.atlas.getTexture("tab-selected-skin");

			this.calloutBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("callout-background-skin"), CALLOUT_SCALE_9_GRID);
			this.calloutTopArrowSkinTexture = this.atlas.getTexture("callout-arrow-top-skin");
			this.calloutBottomArrowSkinTexture = this.atlas.getTexture("callout-arrow-bottom-skin");
			this.calloutLeftArrowSkinTexture = this.atlas.getTexture("callout-arrow-left-skin");
			this.calloutRightArrowSkinTexture = this.atlas.getTexture("callout-arrow-right-skin");

			this.checkUpIconTexture = this.atlas.getTexture("check-up-icon");
			this.checkDownIconTexture = this.atlas.getTexture("check-down-icon");
			this.checkDisabledIconTexture = this.atlas.getTexture("check-disabled-icon");
			this.checkSelectedUpIconTexture = this.atlas.getTexture("check-selected-up-icon");
			this.checkSelectedDownIconTexture = this.atlas.getTexture("check-selected-down-icon");
			this.checkSelectedDisabledIconTexture = this.atlas.getTexture("check-selected-disabled-icon");

			this.radioUpIconTexture = this.atlas.getTexture("radio-up-icon");
			this.radioDownIconTexture = this.atlas.getTexture("radio-down-icon");
			this.radioDisabledIconTexture = this.atlas.getTexture("radio-disabled-icon");
			this.radioSelectedUpIconTexture = this.atlas.getTexture("radio-selected-up-icon");
			this.radioSelectedDisabledIconTexture = this.atlas.getTexture("radio-selected-disabled-icon");

			this.pageIndicatorNormalSkinTexture = this.atlas.getTexture("page-indicator-normal-skin");
			this.pageIndicatorSelectedSkinTexture = this.atlas.getTexture("page-indicator-selected-skin");

			FeathersControl.defaultTextRendererFactory = textRendererFactory;
			FeathersControl.defaultTextEditorFactory = textEditorFactory;

			StandardIcons.listDrillDownAccessoryTexture = this.atlas.getTexture("list-accessory-drill-down-icon");

			this.setInitializerForClassAndSubclasses(Screen, screenInitializer);
			this.setInitializerForClassAndSubclasses(PanelScreen, panelScreenInitializer);
			this.setInitializerForClass(Label, labelInitializer);
			this.setInitializerForClass(ScrollText, scrollTextInitializer);
			this.setInitializerForClass(BitmapFontTextRenderer, itemRendererAccessoryLabelInitializer, BaseDefaultItemRenderer.DEFAULT_CHILD_NAME_ACCESSORY_LABEL);
			this.setInitializerForClass(Button, buttonInitializer);
			this.setInitializerForClass(Button, buttonGroupButtonInitializer, ButtonGroup.DEFAULT_CHILD_NAME_BUTTON);
			this.setInitializerForClass(Button, tabInitializer, TabBar.DEFAULT_CHILD_NAME_TAB);
			this.setInitializerForClass(Button, headerButtonInitializer, Header.DEFAULT_CHILD_NAME_ITEM);
			this.setInitializerForClass(Button, scrollBarThumbInitializer, SimpleScrollBar.DEFAULT_CHILD_NAME_THUMB);
			this.setInitializerForClass(Button, sliderThumbInitializer, Slider.DEFAULT_CHILD_NAME_THUMB);
			this.setInitializerForClass(Button, pickerListButtonInitializer, PickerList.DEFAULT_CHILD_NAME_BUTTON);
			this.setInitializerForClass(Button, toggleSwitchOnTrackInitializer, ToggleSwitch.DEFAULT_CHILD_NAME_ON_TRACK);
			this.setInitializerForClass(Button, nothingInitializer, Slider.DEFAULT_CHILD_NAME_MINIMUM_TRACK);
			this.setInitializerForClass(Button, nothingInitializer, Slider.DEFAULT_CHILD_NAME_MAXIMUM_TRACK);
			this.setInitializerForClass(ButtonGroup, buttonGroupInitializer);
			this.setInitializerForClass(Slider, sliderInitializer);
			this.setInitializerForClass(SimpleScrollBar, scrollBarInitializer);
			this.setInitializerForClass(Check, checkInitializer);
			this.setInitializerForClass(Radio, radioInitializer);
			this.setInitializerForClass(ToggleSwitch, toggleSwitchInitializer);
			this.setInitializerForClass(DefaultListItemRenderer, itemRendererInitializer);
			this.setInitializerForClass(DefaultGroupedListItemRenderer, itemRendererInitializer);
			this.setInitializerForClass(DefaultGroupedListHeaderOrFooterRenderer, headerOrFooterRendererInitializer);
			this.setInitializerForClass(PickerList, pickerListInitializer);
			this.setInitializerForClass(Header, headerInitializer);
			this.setInitializerForClass(TextInput, textInputInitializer);
			this.setInitializerForClass(PageIndicator, pageIndicatorInitializer);
			this.setInitializerForClass(ProgressBar, progressBarInitializer);
			this.setInitializerForClass(Callout, calloutInitializer);
			this.setInitializerForClass(List, listInitializer);
			this.setInitializerForClass(GroupedList, groupedListInitializer);
		}

		protected function pageIndicatorNormalSymbolFactory():DisplayObject
		{
			const symbol:ImageLoader = new ImageLoader();
			symbol.source = this.pageIndicatorNormalSkinTexture;
			symbol.textureScale = this.scale;
			return symbol;
		}

		protected function pageIndicatorSelectedSymbolFactory():DisplayObject
		{
			const symbol:ImageLoader = new ImageLoader();
			symbol.source = this.pageIndicatorSelectedSkinTexture;
			symbol.textureScale = this.scale;
			return symbol;
		}

		protected function imageLoaderFactory():ImageLoader
		{
			const image:ImageLoader = new ImageLoader();
			image.textureScale = this.scale;
			return image;
		}

		protected function nothingInitializer(nothing:IFeathersControl):void
		{

		}

		protected function screenInitializer(screen:Screen):void
		{
			screen.originalDPI = this._originalDPI;
		}

		protected function panelScreenInitializer(screen:PanelScreen):void
		{
			screen.originalDPI = this._originalDPI;
		}

		protected function labelInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, PRIMARY_TEXT_COLOR);
		}

		protected function scrollTextInitializer(text:ScrollText):void
		{
			text.textFormat = new TextFormat("Lato,Roboto,Helvetica,Arial,_sans", this.fontSize, PRIMARY_TEXT_COLOR);
			text.paddingTop = text.paddingBottom = text.paddingLeft = 32 * this.scale;
			text.paddingRight = 36 * this.scale;
		}

		protected function itemRendererAccessoryLabelInitializer(renderer:BitmapFontTextRenderer):void
		{
			renderer.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, PRIMARY_TEXT_COLOR);
		}

		protected function buttonInitializer(button:Button):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = buttonUpSkinTextures;
			skinSelector.defaultSelectedValue = buttonDownSkinTextures;
			skinSelector.setValueForState(buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.imageProperties =
			{
				width: 66 * this.scale,
				height: 66 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.defaultLabelProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, PRIMARY_TEXT_COLOR);
			button.defaultSelectedLabelProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, SELECTED_TEXT_COLOR);

			button.paddingTop = button.paddingBottom = 8 * this.scale;
			button.paddingLeft = button.paddingRight = 16 * this.scale;
			button.gap = 12 * this.scale;
			button.minWidth = button.minHeight = 66 * this.scale;
			button.minTouchWidth = button.minTouchHeight = 88 * this.scale;
		}

		protected function buttonGroupButtonInitializer(button:Button):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = buttonUpSkinTextures;
			skinSelector.defaultSelectedValue = buttonDownSkinTextures;
			skinSelector.setValueForState(buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.imageProperties =
			{
				width: 88 * this.scale,
				height: 88 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.defaultLabelProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, PRIMARY_TEXT_COLOR);
			button.defaultSelectedLabelProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, SELECTED_TEXT_COLOR);

			button.paddingTop = button.paddingBottom = 8 * this.scale;
			button.paddingLeft = button.paddingRight = 16 * this.scale;
			button.gap = 12 * this.scale;
			button.minWidth = button.minHeight = 88 * this.scale;
			button.minTouchWidth = button.minTouchHeight = 88 * this.scale;
		}

		protected function pickerListButtonInitializer(button:Button):void
		{
			//styles for the pickerlist button come from above, and then we're
			//adding a little bit extra.
			this.buttonInitializer(button);

			const pickerListButtonDefaultIcon:Image = new Image(pickerIconTexture);
			pickerListButtonDefaultIcon.scaleX = pickerListButtonDefaultIcon.scaleY = this.scale;
			button.defaultIcon = pickerListButtonDefaultIcon
			button.gap = Number.POSITIVE_INFINITY; //fill as completely as possible
			button.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			button.iconPosition = Button.ICON_POSITION_RIGHT;
		}

		protected function toggleSwitchOnTrackInitializer(track:Button):void
		{
			const defaultSkin:Scale9Image = new Scale9Image(insetBackgroundSkinTextures, this.scale);
			defaultSkin.width = 148 * this.scale;
			defaultSkin.height = 66 * this.scale;
			track.defaultSkin = defaultSkin;
			track.minTouchWidth = track.minTouchHeight = 88 * this.scale;
		}

		protected function scrollBarThumbInitializer(thumb:Button):void
		{
			const scrollBarDefaultSkin:Scale9Image = new Scale9Image(scrollBarThumbSkinTextures, this.scale);
			scrollBarDefaultSkin.width = 8 * this.scale;
			scrollBarDefaultSkin.height = 8 * this.scale;
			thumb.defaultSkin = scrollBarDefaultSkin;
			thumb.minTouchWidth = thumb.minTouchHeight = 12 * this.scale;
		}

		protected function sliderThumbInitializer(thumb:Button):void
		{
			const skinSelector:ImageStateValueSelector = new ImageStateValueSelector();
			skinSelector.defaultValue = sliderThumbUpSkinTexture;
			skinSelector.defaultSelectedValue = tabSelectedSkinTexture;
			skinSelector.setValueForState(sliderThumbDownSkinTexture, Button.STATE_DOWN, false);
			skinSelector.setValueForState(sliderThumbDisabledSkinTexture, Button.STATE_DISABLED, false);
			skinSelector.imageProperties =
			{
				width: 66 * this.scale,
				height: 66 * this.scale
			};
			thumb.stateToSkinFunction = skinSelector.updateValue;

			thumb.minTouchWidth = thumb.minTouchHeight = 88 * this.scale;
		}

		protected function tabInitializer(tab:Button):void
		{
			const skinSelector:ImageStateValueSelector = new ImageStateValueSelector();
			skinSelector.defaultValue = toolBarBackgroundSkinTexture;
			skinSelector.defaultSelectedValue = tabSelectedSkinTexture;
			skinSelector.setValueForState(tabSelectedSkinTexture, Button.STATE_DOWN, false);
			skinSelector.imageProperties =
			{
				width: 88 * this.scale,
				height: 88 * this.scale
			};
			tab.stateToSkinFunction = skinSelector.updateValue;

			tab.minWidth = tab.minHeight = 88 * this.scale;
			tab.minTouchWidth = tab.minTouchHeight = 88 * this.scale;
			tab.paddingTop = tab.paddingRight = tab.paddingBottom =
				tab.paddingLeft = 16 * this.scale;
			tab.gap = 12 * this.scale;
			tab.iconPosition = Button.ICON_POSITION_TOP;

			tab.defaultLabelProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, PRIMARY_TEXT_COLOR);
			tab.defaultSelectedLabelProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, SELECTED_TEXT_COLOR);
		}

		protected function headerButtonInitializer(button:Button):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = buttonUpSkinTextures;
			skinSelector.defaultSelectedValue = buttonDownSkinTextures;
			skinSelector.setValueForState(buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.imageProperties =
			{
				width: 60 * this.scale,
				height: 60 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.defaultLabelProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, PRIMARY_TEXT_COLOR);
			button.defaultSelectedLabelProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, SELECTED_TEXT_COLOR);

			button.paddingTop = button.paddingBottom = 8 * this.scale;
			button.paddingLeft = button.paddingRight = 16 * this.scale;
			button.gap = 12 * this.scale;
			button.minWidth = button.minHeight = 60 * this.scale;
			button.minTouchWidth = button.minTouchHeight = 88 * this.scale;
		}

		protected function buttonGroupInitializer(group:ButtonGroup):void
		{
			group.minWidth = 560 * this.scale;
			group.gap = 18 * this.scale;
		}

		protected function sliderInitializer(slider:Slider):void
		{
			slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_MIN_MAX;
			if(slider.direction == Slider.DIRECTION_VERTICAL)
			{
				var sliderMinimumTrackDefaultSkin:Scale3Image = new Scale3Image(vSliderMinimumTrackUpSkinTextures, this.scale);
				sliderMinimumTrackDefaultSkin.width *= this.scale;
				sliderMinimumTrackDefaultSkin.height = 198 * this.scale;
				var sliderMinimumTrackDownSkin:Scale3Image = new Scale3Image(vSliderMinimumTrackDownSkinTextures, this.scale);
				sliderMinimumTrackDownSkin.width *= this.scale;
				sliderMinimumTrackDownSkin.height = 198 * this.scale;
				var sliderMinimumTrackDisabledSkin:Scale3Image = new Scale3Image(vSliderMinimumTrackDisabledSkinTextures, this.scale);
				sliderMinimumTrackDisabledSkin.width *= this.scale;
				sliderMinimumTrackDisabledSkin.height = 198 * this.scale;
				slider.minimumTrackProperties.defaultSkin = sliderMinimumTrackDefaultSkin;
				slider.minimumTrackProperties.downSkin = sliderMinimumTrackDownSkin;
				slider.minimumTrackProperties.disabledSkin = sliderMinimumTrackDisabledSkin;

				var sliderMaximumTrackDefaultSkin:Scale3Image = new Scale3Image(vSliderMaximumTrackUpSkinTextures, this.scale);
				sliderMaximumTrackDefaultSkin.width *= this.scale;
				sliderMaximumTrackDefaultSkin.height = 198 * this.scale;
				var sliderMaximumTrackDownSkin:Scale3Image = new Scale3Image(vSliderMaximumTrackDownSkinTextures, this.scale);
				sliderMaximumTrackDownSkin.width *= this.scale;
				sliderMaximumTrackDownSkin.height = 198 * this.scale;
				var sliderMaximumTrackDisabledSkin:Scale3Image = new Scale3Image(vSliderMaximumTrackDisabledSkinTextures, this.scale);
				sliderMaximumTrackDisabledSkin.width *= this.scale;
				sliderMaximumTrackDisabledSkin.height = 198 * this.scale;
				slider.maximumTrackProperties.defaultSkin = sliderMaximumTrackDefaultSkin;
				slider.maximumTrackProperties.downSkin = sliderMaximumTrackDownSkin;
				slider.maximumTrackProperties.disabledSkin = sliderMaximumTrackDisabledSkin;
			}
			else //horizontal
			{
				sliderMinimumTrackDefaultSkin = new Scale3Image(hSliderMinimumTrackUpSkinTextures, this.scale);
				sliderMinimumTrackDefaultSkin.width = 198 * this.scale;
				sliderMinimumTrackDefaultSkin.height *= this.scale;
				sliderMinimumTrackDownSkin = new Scale3Image(hSliderMinimumTrackDownSkinTextures, this.scale);
				sliderMinimumTrackDownSkin.width = 198 * this.scale;
				sliderMinimumTrackDownSkin.height *= this.scale;
				sliderMinimumTrackDisabledSkin = new Scale3Image(hSliderMinimumTrackDisabledSkinTextures, this.scale);
				sliderMinimumTrackDisabledSkin.width = 198 * this.scale;
				sliderMinimumTrackDisabledSkin.height *= this.scale;
				slider.minimumTrackProperties.defaultSkin = sliderMinimumTrackDefaultSkin;
				slider.minimumTrackProperties.downSkin = sliderMinimumTrackDownSkin;
				slider.minimumTrackProperties.disabledSkin = sliderMinimumTrackDisabledSkin;

				sliderMaximumTrackDefaultSkin = new Scale3Image(hSliderMaximumTrackUpSkinTextures, this.scale);
				sliderMaximumTrackDefaultSkin.width = 198 * this.scale;
				sliderMaximumTrackDefaultSkin.height *= this.scale;
				sliderMaximumTrackDownSkin = new Scale3Image(hSliderMaximumTrackDownSkinTextures, this.scale);
				sliderMaximumTrackDownSkin.width = 198 * this.scale;
				sliderMaximumTrackDownSkin.height *= this.scale;
				sliderMaximumTrackDisabledSkin = new Scale3Image(hSliderMaximumTrackDisabledSkinTextures, this.scale);
				sliderMaximumTrackDisabledSkin.width = 198 * this.scale;
				sliderMaximumTrackDisabledSkin.height *= this.scale;
				slider.maximumTrackProperties.defaultSkin = sliderMaximumTrackDefaultSkin;
				slider.maximumTrackProperties.downSkin = sliderMaximumTrackDownSkin;
				slider.maximumTrackProperties.disabledSkin = sliderMaximumTrackDisabledSkin;
			}
		}

		protected function scrollBarInitializer(scrollBar:SimpleScrollBar):void
		{
			scrollBar.paddingTop = scrollBar.paddingRight = scrollBar.paddingBottom =
				scrollBar.paddingLeft = 2 * this.scale;
		}

		protected function checkInitializer(check:Check):void
		{
			const iconSelector:ImageStateValueSelector = new ImageStateValueSelector();
			iconSelector.defaultValue = checkUpIconTexture;
			iconSelector.defaultSelectedValue = checkSelectedUpIconTexture;
			iconSelector.setValueForState(checkDownIconTexture, Button.STATE_DOWN, false);
			iconSelector.setValueForState(checkDisabledIconTexture, Button.STATE_DISABLED, false);
			iconSelector.setValueForState(checkSelectedDownIconTexture, Button.STATE_DOWN, true);
			iconSelector.setValueForState(checkSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
			iconSelector.imageProperties =
			{
				scaleX: this.scale,
				scaleY: this.scale
			};
			check.stateToIconFunction = iconSelector.updateValue;

			check.defaultLabelProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, PRIMARY_TEXT_COLOR);
			check.defaultSelectedLabelProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, SELECTED_TEXT_COLOR);

			check.minTouchWidth = check.minTouchHeight = 88 * this.scale;
			check.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			check.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
		}

		protected function radioInitializer(radio:Radio):void
		{
			const iconSelector:ImageStateValueSelector = new ImageStateValueSelector();
			iconSelector.defaultValue = radioUpIconTexture;
			iconSelector.defaultSelectedValue = radioSelectedUpIconTexture;
			iconSelector.setValueForState(radioDownIconTexture, Button.STATE_DOWN, false);
			iconSelector.setValueForState(radioDisabledIconTexture, Button.STATE_DISABLED, false);
			iconSelector.setValueForState(radioSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
			iconSelector.imageProperties =
			{
				scaleX: this.scale,
				scaleY: this.scale
			};
			radio.stateToIconFunction = iconSelector.updateValue;

			radio.defaultLabelProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, PRIMARY_TEXT_COLOR);
			radio.defaultSelectedLabelProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, SELECTED_TEXT_COLOR);

			radio.minTouchWidth = radio.minTouchHeight = 88 * this.scale;
			radio.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			radio.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
		}

		protected function toggleSwitchInitializer(toggleSwitch:ToggleSwitch):void
		{
			toggleSwitch.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;

			toggleSwitch.defaultLabelProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, PRIMARY_TEXT_COLOR);
			toggleSwitch.onLabelProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, SELECTED_TEXT_COLOR);
		}

		protected function itemRendererInitializer(renderer:BaseDefaultItemRenderer):void
		{
			const skinSelector:ImageStateValueSelector = new ImageStateValueSelector();
			skinSelector.defaultValue = listItemUpTexture;
			skinSelector.defaultSelectedValue = listItemDownTexture;
			skinSelector.setValueForState(listItemDownTexture, Button.STATE_DOWN, false);
			skinSelector.imageProperties =
			{
				width: 88 * this.scale,
				height: 88 * this.scale
			};
			renderer.stateToSkinFunction = skinSelector.updateValue;

			renderer.defaultLabelProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, PRIMARY_TEXT_COLOR);

			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			renderer.paddingTop = renderer.paddingBottom = 11 * this.scale;
			renderer.paddingLeft = renderer.paddingRight = 20 * this.scale;
			renderer.minWidth = 88 * this.scale;
			renderer.minHeight = 88 * this.scale;

			renderer.gap = 10 * this.scale;
			renderer.iconPosition = Button.ICON_POSITION_LEFT;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;

			renderer.accessoryLoaderFactory = this.imageLoaderFactory;
			renderer.iconLoaderFactory = this.imageLoaderFactory;
		}

		protected function headerOrFooterRendererInitializer(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			const backgroundSkin:Image = new Image(groupedListHeaderBackgroundSkinTexture);
			backgroundSkin.width = 44 * this.scale;
			backgroundSkin.height = 44 * this.scale;
			renderer.backgroundSkin = backgroundSkin;

			renderer.contentLabelProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, PRIMARY_TEXT_COLOR);

			renderer.paddingTop = renderer.paddingBottom = 9 * this.scale;
			renderer.paddingLeft = renderer.paddingRight = 16 * this.scale;
			renderer.minWidth = renderer.minHeight = 44 * this.scale;

			renderer.contentLoaderFactory = this.imageLoaderFactory;
		}

		protected function pickerListInitializer(list:PickerList):void
		{
			if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				list.popUpContentManager = new CalloutPopUpContentManager();
			}
			else
			{
				const centerStage:VerticalCenteredPopUpContentManager = new VerticalCenteredPopUpContentManager();
				centerStage.marginTop = centerStage.marginRight = centerStage.marginBottom =
					centerStage.marginLeft = 16 * this.scale;
				list.popUpContentManager = centerStage;
			}

			const layout:VerticalLayout = new VerticalLayout();
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_BOTTOM;
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			layout.useVirtualLayout = true;
			layout.gap = 0;
			layout.paddingTop = layout.paddingRight = layout.paddingBottom =
				layout.paddingLeft = 0;
			list.listProperties.layout = layout;
			list.listProperties.verticalScrollPolicy = List.SCROLL_POLICY_ON;

			if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				list.listProperties.minWidth = 264 * this.scale;
				list.listProperties.maxHeight = 352 * this.scale;
			}
			else
			{
				const backgroundSkin:Scale9Image = new Scale9Image(insetBackgroundSkinTextures, this.scale);
				backgroundSkin.width = 20 * this.scale;
				backgroundSkin.height = 20 * this.scale;
				list.listProperties.backgroundSkin = backgroundSkin;
				list.listProperties.paddingTop = list.listProperties.paddingRight =
					list.listProperties.paddingBottom = list.listProperties.paddingLeft = 8 * this.scale;
			}
		}

		protected function headerInitializer(header:Header):void
		{
			const backgroundSkin:Image = new Image(toolBarBackgroundSkinTexture);
			backgroundSkin.width = 88 * this.scale;
			backgroundSkin.height = 88 * this.scale;
			header.backgroundSkin = backgroundSkin;
			header.titleProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, PRIMARY_TEXT_COLOR);
			header.paddingTop = header.paddingRight = header.paddingBottom =
				header.paddingLeft = 14 * this.scale;
			header.gap = 8 * this.scale;
			header.titleGap = 12 * this.scale;
			header.minHeight = 88 * this.scale;
		}

		protected function textInputInitializer(input:TextInput):void
		{
			input.minWidth = input.minHeight = 66 * this.scale;
			input.minTouchWidth = input.minTouchHeight = 66 * this.scale;
			input.paddingTop = input.paddingBottom = 14 * this.scale;
			input.paddingLeft = input.paddingRight = 16 * this.scale;
			input.textEditorProperties.fontFamily = "Helvetica";
			input.textEditorProperties.fontSize = 30 * this.scale;
			input.textEditorProperties.color = 0xffffff;

			const backgroundSkin:Scale9Image = new Scale9Image(insetBackgroundSkinTextures, this.scale);
			backgroundSkin.width = 264 * this.scale;
			backgroundSkin.height = 66 * this.scale;
			input.backgroundSkin = backgroundSkin;

			const backgroundDisabledSkin:Scale9Image = new Scale9Image(insetBackgroundDisabledSkinTextures, this.scale);
			backgroundDisabledSkin.width = 264 * this.scale;
			backgroundDisabledSkin.height = 66 * this.scale;
			input.backgroundDisabledSkin = backgroundDisabledSkin;
		}

		protected function pageIndicatorInitializer(pageIndicator:PageIndicator):void
		{
			pageIndicator.normalSymbolFactory = this.pageIndicatorNormalSymbolFactory;
			pageIndicator.selectedSymbolFactory = this.pageIndicatorSelectedSymbolFactory;
			pageIndicator.gap = 6 * this.scale;
			pageIndicator.paddingTop = pageIndicator.paddingRight = pageIndicator.paddingBottom =
				pageIndicator.paddingLeft = 6 * this.scale;
			pageIndicator.minTouchWidth = pageIndicator.minTouchHeight = 44 * this.scale;
		}

		protected function progressBarInitializer(progress:ProgressBar):void
		{
			const backgroundSkin:Scale3Image = new Scale3Image(progressBarBackgroundSkinTextures, this.scale);
			backgroundSkin.width = (progress.direction == ProgressBar.DIRECTION_HORIZONTAL ? 264 : 24) * this.scale;
			backgroundSkin.height = (progress.direction == ProgressBar.DIRECTION_HORIZONTAL ? 24 : 264) * this.scale;
			progress.backgroundSkin = backgroundSkin;

			const backgroundDisabledSkin:Scale3Image = new Scale3Image(progressBarBackgroundDisabledSkinTextures, this.scale);
			backgroundDisabledSkin.width = (progress.direction == ProgressBar.DIRECTION_HORIZONTAL ? 264 : 24) * this.scale;
			backgroundDisabledSkin.height = (progress.direction == ProgressBar.DIRECTION_HORIZONTAL ? 24 : 264) * this.scale;
			progress.backgroundDisabledSkin = backgroundDisabledSkin;

			const fillSkin:Scale3Image = new Scale3Image(progressBarFillSkinTextures, this.scale);
			fillSkin.width = 24 * this.scale;
			fillSkin.height = 24 * this.scale;
			progress.fillSkin = fillSkin;

			const fillDisabledSkin:Scale3Image = new Scale3Image(progressBarFillDisabledSkinTextures, this.scale);
			fillDisabledSkin.width = 24 * this.scale;
			fillDisabledSkin.height = 24 * this.scale;
			progress.fillDisabledSkin = fillDisabledSkin;
		}

		protected function calloutInitializer(callout:Callout):void
		{
			callout.paddingTop = callout.paddingRight = callout.paddingBottom =
				callout.paddingLeft = 16 * this.scale;

			const backgroundSkin:Scale9Image = new Scale9Image(calloutBackgroundSkinTextures, this.scale);
			backgroundSkin.width = 48 * this.scale;
			backgroundSkin.height = 48 * this.scale;
			callout.backgroundSkin = backgroundSkin;

			const topArrowSkin:Image = new Image(calloutTopArrowSkinTexture);
			topArrowSkin.scaleX = topArrowSkin.scaleY = this.scale;
			callout.topArrowSkin = topArrowSkin;
			callout.topArrowGap = 0 * this.scale;

			const bottomArrowSkin:Image = new Image(calloutBottomArrowSkinTexture);
			bottomArrowSkin.scaleX = bottomArrowSkin.scaleY = this.scale;
			callout.bottomArrowSkin = bottomArrowSkin;
			callout.bottomArrowGap = -1 * this.scale;

			const leftArrowSkin:Image = new Image(calloutLeftArrowSkinTexture);
			leftArrowSkin.scaleX = leftArrowSkin.scaleY = this.scale;
			callout.leftArrowSkin = leftArrowSkin;
			callout.leftArrowGap = 0 * this.scale;

			const rightArrowSkin:Image = new Image(calloutRightArrowSkinTexture);
			rightArrowSkin.scaleX = rightArrowSkin.scaleY = this.scale;
			callout.rightArrowSkin = rightArrowSkin;
			callout.rightArrowGap = -1 * this.scale;
		}

		protected function listInitializer(list:List):void
		{
			const backgroundSkin:Quad = new Quad(100, 100, LIST_BACKGROUND_COLOR);
			list.backgroundSkin = backgroundSkin;
		}

		protected function groupedListInitializer(list:GroupedList):void
		{
			const backgroundSkin:Quad = new Quad(100, 100, LIST_BACKGROUND_COLOR);
			list.backgroundSkin = backgroundSkin;
		}

		protected function root_addedToStageHandler(event:Event):void
		{
			DisplayObject(event.currentTarget).stage.color = BACKGROUND_COLOR;
		}

	}
}