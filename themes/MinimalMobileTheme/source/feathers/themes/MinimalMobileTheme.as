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
	import feathers.display.Scale9Image;
	import feathers.layout.VerticalLayout;
	import feathers.skins.ImageStateValueSelector;
	import feathers.skins.Scale9ImageStateValueSelector;
	import feathers.skins.StandardIcons;
	import feathers.system.DeviceCapabilities;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	import feathers.utils.math.roundToNearest;

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
	import starling.textures.TextureSmoothing;

	public class MinimalMobileTheme extends DisplayListWatcher
	{
		[Embed(source="/../assets/images/minimal.png")]
		protected static const ATLAS_IMAGE:Class;

		[Embed(source="/../assets/images/minimal.xml",mimeType="application/octet-stream")]
		protected static const ATLAS_XML:Class;

		[Embed(source="/../assets/fonts/pf_ronda_seven.fnt",mimeType="application/octet-stream")]
		protected static const ATLAS_FONT_XML:Class;

		protected static const SCALE_9_GRID:Rectangle = new Rectangle(9, 9, 2, 2);
		protected static const SCROLLBAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(1, 1, 2, 2);
		protected static const TAB_SCALE_9_GRID:Rectangle = new Rectangle(25, 25, 2, 2);
		protected static const CHECK_SCALE_9_GRID:Rectangle = new Rectangle(13, 13, 2, 2);
		protected static const HEADER_SCALE_9_GRID:Rectangle = new Rectangle(0, 5, 4, 6);
		protected static const LIST_ITEM_SCALE_9_GRID:Rectangle = new Rectangle(0, 5, 4, 1);

		protected static const BACKGROUND_COLOR:uint = 0xf3f3f3;
		protected static const LIST_BACKGROUND_COLOR:uint = 0xf8f8f8;
		protected static const LIST_HEADER_BACKGROUND_COLOR:uint = 0xeeeeee;
		protected static const PRIMARY_TEXT_COLOR:uint = 0x666666;
		protected static const SELECTED_TEXT_COLOR:uint = 0x333333;
		protected static const INSET_TEXT_COLOR:uint = 0x333333;

		protected static const ORIGINAL_DPI_IPHONE_RETINA:int = 326;
		protected static const ORIGINAL_DPI_IPAD_RETINA:int = 264;

		protected static function textRendererFactory():BitmapFontTextRenderer
		{
			const renderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
			//since it's a pixel font, we don't want to smooth it.
			renderer.smoothing = TextureSmoothing.NONE;
			return renderer;
		}

		protected static function textEditorFactory():StageTextTextEditor
		{
			return new StageTextTextEditor();
		}

		public function MinimalMobileTheme(container:DisplayObjectContainer = null, scaleToDPI:Boolean = true)
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

		protected var buttonUpSkinTextures:Scale9Textures;
		protected var buttonDownSkinTextures:Scale9Textures;
		protected var buttonDisabledSkinTextures:Scale9Textures;
		protected var buttonSelectedSkinTextures:Scale9Textures;

		protected var toolBarButtonUpSkinTextures:Scale9Textures;
		protected var toolBarButtonDownSkinTextures:Scale9Textures;
		protected var toolBarButtonSelectedSkinTextures:Scale9Textures;

		protected var tabUpSkinTextures:Scale9Textures;
		protected var tabDownSkinTextures:Scale9Textures;
		protected var tabSelectedSkinTextures:Scale9Textures;

		protected var thumbSkinTextures:Scale9Textures;

		protected var scrollBarThumbSkinTextures:Scale9Textures;

		protected var insetBackgroundSkinTextures:Scale9Textures;
		protected var insetBackgroundDisabledSkinTextures:Scale9Textures;

		protected var dropDownArrowTexture:Texture;

		protected var listItemUpTextures:Scale9Textures;
		protected var listItemDownTextures:Scale9Textures;
		protected var listItemSelectedTextures:Scale9Textures;

		protected var headerSkinTextures:Scale9Textures;

		protected var popUpBackgroundSkinTextures:Scale9Textures;
		protected var calloutTopArrowSkinTexture:Texture;
		protected var calloutBottomArrowSkinTexture:Texture;
		protected var calloutLeftArrowSkinTexture:Texture;
		protected var calloutRightArrowSkinTexture:Texture;

		protected var checkSelectedIconTextures:Scale9Textures;

		protected var radioIconTexture:Texture;
		protected var radioSelectedIconTexture:Texture;

		protected var pageIndicatorNormalSkinTexture:Texture;
		protected var pageIndicatorSelectedSkinTexture:Texture;

		protected var bitmapFont:BitmapFont;

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
			//our min scale is 0.25 because lines in the graphics are four
			//pixels wide and this will keep them crisp.
			this.scale = Math.max(0.25, scaledDPI / this._originalDPI);

			//since it's a pixel font, we want a multiple of the original size,
			//which, in this case, is 8.
			this.fontSize = Math.max(4, roundToNearest(24 * this.scale, 8));

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

			this.bitmapFont = new BitmapFont(this.atlas.getTexture("pf_ronda_seven_0"), XML(new ATLAS_FONT_XML()));

			this.toolBarButtonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("toolbar-button-up-skin"), SCALE_9_GRID);
			this.toolBarButtonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("toolbar-button-down-skin"), SCALE_9_GRID);
			this.toolBarButtonSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("toolbar-button-selected-skin"), SCALE_9_GRID);

			this.buttonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-up-skin"), SCALE_9_GRID);
			this.buttonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("button-down-skin"), SCALE_9_GRID);
			this.buttonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("button-disabled-skin"), SCALE_9_GRID);
			this.buttonSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("button-selected-skin"), SCALE_9_GRID);

			this.tabUpSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-up-skin"), SCALE_9_GRID);
			this.tabDownSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-down-skin"), TAB_SCALE_9_GRID);
			this.tabSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-skin"), TAB_SCALE_9_GRID);

			this.thumbSkinTextures = new Scale9Textures(this.atlas.getTexture("thumb-skin"), SCALE_9_GRID);

			this.scrollBarThumbSkinTextures = new Scale9Textures(this.atlas.getTexture("scrollbar-thumb-skin"), SCROLLBAR_THUMB_SCALE_9_GRID);

			this.insetBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("inset-background-skin"), SCALE_9_GRID);
			this.insetBackgroundDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("inset-background-disabled-skin"), SCALE_9_GRID);

			this.dropDownArrowTexture = this.atlas.getTexture("drop-down-arrow");

			this.listItemUpTextures = new Scale9Textures(this.atlas.getTexture("list-item-up"), LIST_ITEM_SCALE_9_GRID);
			this.listItemDownTextures = new Scale9Textures(this.atlas.getTexture("list-item-down"), LIST_ITEM_SCALE_9_GRID);
			this.listItemSelectedTextures = new Scale9Textures(this.atlas.getTexture("list-item-selected"), LIST_ITEM_SCALE_9_GRID);

			this.headerSkinTextures = new Scale9Textures(this.atlas.getTexture("header-skin"), HEADER_SCALE_9_GRID);

			this.popUpBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("callout-background-skin"), SCALE_9_GRID);
			this.calloutTopArrowSkinTexture = this.atlas.getTexture("callout-arrow-top");
			this.calloutBottomArrowSkinTexture = this.atlas.getTexture("callout-arrow-bottom");
			this.calloutLeftArrowSkinTexture = this.atlas.getTexture("callout-arrow-left");
			this.calloutRightArrowSkinTexture = this.atlas.getTexture("callout-arrow-right");

			this.checkSelectedIconTextures = new Scale9Textures(this.atlas.getTexture("check-selected-icon"), CHECK_SCALE_9_GRID);

			this.radioIconTexture = this.atlas.getTexture("radio-icon");
			this.radioSelectedIconTexture = this.atlas.getTexture("radio-selected-icon");

			this.pageIndicatorNormalSkinTexture = this.atlas.getTexture("page-indicator-normal-skin");
			this.pageIndicatorSelectedSkinTexture = this.atlas.getTexture("page-indicator-selected-skin");

			StandardIcons.listDrillDownAccessoryTexture = this.atlas.getTexture("list-accessory-drill-down-icon");

			FeathersControl.defaultTextRendererFactory = textRendererFactory;
			FeathersControl.defaultTextEditorFactory = textEditorFactory;

			this.setInitializerForClassAndSubclasses(Screen, screenInitializer);
			this.setInitializerForClassAndSubclasses(PanelScreen, panelScreenInitializer);
			this.setInitializerForClass(Label, labelInitializer);
			this.setInitializerForClass(ScrollText, scrollTextInitializer);
			this.setInitializerForClass(BitmapFontTextRenderer, itemRendererAccessoryLabelInitializer, BaseDefaultItemRenderer.DEFAULT_CHILD_NAME_ACCESSORY_LABEL);
			this.setInitializerForClass(Button, buttonInitializer);
			this.setInitializerForClass(Button, buttonGroupButtonInitializer);
			this.setInitializerForClass(Button, sliderThumbInitializer, Slider.DEFAULT_CHILD_NAME_THUMB);
			this.setInitializerForClass(Button, simpleScrollBarThumbInitializer, SimpleScrollBar.DEFAULT_CHILD_NAME_THUMB);
			this.setInitializerForClass(Button, nothingInitializer, Slider.DEFAULT_CHILD_NAME_MINIMUM_TRACK);
			this.setInitializerForClass(Button, nothingInitializer, Slider.DEFAULT_CHILD_NAME_MAXIMUM_TRACK);
			this.setInitializerForClass(Button, toggleSwitchOnTrackInitializer, ToggleSwitch.DEFAULT_CHILD_NAME_ON_TRACK);
			this.setInitializerForClass(Button, toggleSwitchThumbInitializer, ToggleSwitch.DEFAULT_CHILD_NAME_THUMB);
			this.setInitializerForClass(Button, tabInitializer, TabBar.DEFAULT_CHILD_NAME_TAB);
			this.setInitializerForClass(Button, toolBarButtonInitializer, Header.DEFAULT_CHILD_NAME_ITEM);
			this.setInitializerForClass(Button, pickerListButtonInitializer, PickerList.DEFAULT_CHILD_NAME_BUTTON);
			this.setInitializerForClass(ButtonGroup, buttonGroupInitializer);
			this.setInitializerForClass(Slider, sliderInitializer);
			this.setInitializerForClass(ToggleSwitch, toggleSwitchInitializer);
			this.setInitializerForClass(Check, checkInitializer);
			this.setInitializerForClass(Radio, radioInitializer);
			this.setInitializerForClass(DefaultListItemRenderer, itemRendererInitializer);
			this.setInitializerForClass(DefaultGroupedListItemRenderer, itemRendererInitializer);
			this.setInitializerForClass(DefaultGroupedListHeaderOrFooterRenderer, headerOrFooterRendererInitializer);
			this.setInitializerForClass(List, listInitializer);
			this.setInitializerForClass(List, nothingInitializer, PickerList.DEFAULT_CHILD_NAME_LIST);
			this.setInitializerForClass(GroupedList, groupedListInitializer);
			this.setInitializerForClass(PickerList, pickerListInitializer);
			this.setInitializerForClass(Header, headerInitializer);
			this.setInitializerForClass(TextInput, textInputInitializer);
			this.setInitializerForClass(PageIndicator, pageIndicatorInitializer);
			this.setInitializerForClass(ProgressBar, progressBarInitializer);
			this.setInitializerForClass(Callout, calloutInitializer);
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
			image.smoothing = TextureSmoothing.NONE;
			image.textureScale = this.scale;
			return image;
		}

		protected function nothingInitializer(target:DisplayObject):void
		{
			//if this is assigned as an initializer, chances are the target will
			//be a subcomponent of something. the initializer for this
			//component's parent is probably handing the initializing for the
			//target too.
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

		protected function itemRendererAccessoryLabelInitializer(renderer:BitmapFontTextRenderer):void
		{
			renderer.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, PRIMARY_TEXT_COLOR);
		}

		protected function scrollTextInitializer(text:ScrollText):void
		{
			text.textFormat = new TextFormat("PF Ronda Seven,Roboto,Helvetica,Arial,_sans", this.fontSize, PRIMARY_TEXT_COLOR);
			text.paddingTop = text.paddingBottom = text.paddingLeft = 32 * this.scale;
			text.paddingRight = 36 * this.scale;
		}

		protected function buttonInitializer(button:Button):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = buttonUpSkinTextures;
			skinSelector.defaultSelectedValue = buttonSelectedSkinTextures;
			skinSelector.setValueForState(buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(buttonDownSkinTextures, Button.STATE_DOWN, true);
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
			button.minWidth = 66 * this.scale;
			button.minHeight = 66 * this.scale;
			button.minTouchWidth = button.minTouchHeight = 88 * this.scale;
		}

		protected function buttonGroupButtonInitializer(button:Button):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = buttonUpSkinTextures;
			skinSelector.defaultSelectedValue = buttonSelectedSkinTextures;
			skinSelector.setValueForState(buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(buttonDownSkinTextures, Button.STATE_DOWN, true);
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
			button.minWidth = 88 * this.scale;
			button.minHeight = 88 * this.scale;
			button.minTouchWidth = button.minTouchHeight = 88 * this.scale;
		}


		protected function toolBarButtonInitializer(button:Button):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = toolBarButtonUpSkinTextures;
			skinSelector.defaultSelectedValue = toolBarButtonSelectedSkinTextures;
			skinSelector.setValueForState(toolBarButtonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(toolBarButtonDownSkinTextures, Button.STATE_DOWN, true);
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

		protected function tabInitializer(tab:Button):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = tabUpSkinTextures;
			skinSelector.defaultSelectedValue = tabSelectedSkinTextures;
			skinSelector.setValueForState(tabDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.imageProperties =
			{
				width: 88 * this.scale,
				height: 88 * this.scale,
				textureScale: this.scale
			};
			tab.stateToSkinFunction = skinSelector.updateValue;

			tab.defaultLabelProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, PRIMARY_TEXT_COLOR);
			tab.defaultSelectedLabelProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, SELECTED_TEXT_COLOR);

			tab.iconPosition = Button.ICON_POSITION_TOP;
			tab.paddingTop = tab.paddingRight = tab.paddingBottom =
				tab.paddingLeft = 28 * this.scale;
			tab.gap = 12 * this.scale;
			tab.minWidth = tab.minHeight = 88 * this.scale;
			tab.minTouchWidth = tab.minTouchHeight = 88 * this.scale;
		}

		protected function simpleScrollBarThumbInitializer(thumb:Button):void
		{
			const defaultSkin:Scale9Image = new Scale9Image(scrollBarThumbSkinTextures, this.scale);
			defaultSkin.width = 8 * this.scale;
			defaultSkin.height = 8 * this.scale;
			thumb.defaultSkin = defaultSkin;

			thumb.minTouchWidth = thumb.minTouchHeight = 12 * this.scale;
		}

		protected function buttonGroupInitializer(group:ButtonGroup):void
		{
			group.minWidth = 560 * this.scale;
			group.gap = 16 * this.scale;
		}

		protected function sliderInitializer(slider:Slider):void
		{
			slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_SINGLE;

			const sliderTrackDefaultSkin:Scale9Image = new Scale9Image(insetBackgroundSkinTextures, this.scale);
			if(slider.direction == Slider.DIRECTION_VERTICAL)
			{
				sliderTrackDefaultSkin.width = 66 * this.scale;
				sliderTrackDefaultSkin.height = 198 * this.scale;
			}
			else //horizontal
			{
				sliderTrackDefaultSkin.width = 198 * this.scale;
				sliderTrackDefaultSkin.height = 66 * this.scale;
			}
			slider.minimumTrackProperties.defaultSkin = sliderTrackDefaultSkin;
		}

		protected function sliderThumbInitializer(thumb:Button):void
		{
			const defaultSkin:Scale9Image = new Scale9Image(thumbSkinTextures, this.scale);
			defaultSkin.width = 66 * this.scale;
			defaultSkin.height = 66 * this.scale;
			thumb.defaultSkin = defaultSkin;

			thumb.minTouchWidth = thumb.minTouchHeight = 88 * this.scale;
		}

		protected function toggleSwitchInitializer(toggleSwitch:ToggleSwitch):void
		{
			toggleSwitch.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;

			toggleSwitch.defaultLabelProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, PRIMARY_TEXT_COLOR);
			toggleSwitch.onLabelProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, SELECTED_TEXT_COLOR);
		}

		protected function toggleSwitchOnTrackInitializer(track:Button):void
		{
			const defaultSkin:Scale9Image = new Scale9Image(insetBackgroundSkinTextures, this.scale);
			defaultSkin.width = 148 * this.scale;
			defaultSkin.height = 66 * this.scale;
			track.defaultSkin = defaultSkin;
			track.minTouchWidth = track.minTouchHeight = 88 * this.scale;
		}

		protected function toggleSwitchThumbInitializer(thumb:Button):void
		{
			const defaultSkin:Scale9Image = new Scale9Image(thumbSkinTextures, this.scale);
			defaultSkin.width = 66 * this.scale;
			defaultSkin.height = 66 * this.scale;
			thumb.defaultSkin = defaultSkin;
			thumb.minTouchWidth = thumb.minTouchHeight = 88 * this.scale;
		}

		protected function checkInitializer(check:Check):void
		{
			const iconSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			iconSelector.defaultValue = insetBackgroundSkinTextures;
			iconSelector.defaultSelectedValue = checkSelectedIconTextures;
			iconSelector.imageProperties =
			{
				width: 40 * this.scale,
				height: 40 * this.scale,
				textureScale: this.scale
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
			iconSelector.defaultValue = radioIconTexture;
			iconSelector.defaultSelectedValue = radioSelectedIconTexture;
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

		protected function itemRendererInitializer(renderer:BaseDefaultItemRenderer):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = this.listItemUpTextures;
			skinSelector.defaultSelectedValue = this.listItemSelectedTextures;
			skinSelector.setValueForState(this.listItemDownTextures, Button.STATE_DOWN, false);
			skinSelector.imageProperties =
			{
				width: 88 * this.scale,
				height: 88 * this.scale,
				textureScale: this.scale
			};
			renderer.stateToSkinFunction = skinSelector.updateValue;

			renderer.defaultLabelProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, PRIMARY_TEXT_COLOR);
			renderer.defaultSelectedLabelProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, SELECTED_TEXT_COLOR);

			renderer.paddingTop = renderer.paddingBottom = 11 * this.scale;
			renderer.paddingLeft = renderer.paddingRight = 16 * this.scale;
			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			renderer.minWidth = renderer.minHeight = 88 * this.scale;

			renderer.gap = 10 * this.scale;
			renderer.iconPosition = Button.ICON_POSITION_LEFT;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;

			renderer.accessoryLoaderFactory = this.imageLoaderFactory;
			renderer.iconLoaderFactory = this.imageLoaderFactory;
		}

		protected function headerOrFooterRendererInitializer(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			const backgroundSkin:Quad = new Quad(44 * this.scale, 44 * this.scale, LIST_HEADER_BACKGROUND_COLOR);
			renderer.backgroundSkin = backgroundSkin;

			renderer.contentLabelProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, PRIMARY_TEXT_COLOR);

			renderer.paddingTop = renderer.paddingBottom = 6 * this.scale;
			renderer.paddingLeft = renderer.paddingRight = 16 * this.scale;
			renderer.minWidth = renderer.minHeight = 44 * this.scale;

			renderer.contentLoaderFactory = this.imageLoaderFactory;
		}

		protected function listInitializer(list:List):void
		{
			const backgroundSkin:Quad = new Quad(88 * this.scale, 88 * this.scale, LIST_BACKGROUND_COLOR);
			list.backgroundSkin = backgroundSkin;
		}

		protected function groupedListInitializer(list:GroupedList):void
		{
			const backgroundSkin:Quad = new Quad(88 * this.scale, 88 * this.scale, LIST_BACKGROUND_COLOR);
			list.backgroundSkin = backgroundSkin;
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
				list.listProperties.minWidth = 560 * this.scale;
				list.listProperties.maxHeight = 528 * this.scale;
			}
			else
			{
				const backgroundSkin:Scale9Image = new Scale9Image(popUpBackgroundSkinTextures, this.scale);
				backgroundSkin.width = 20 * this.scale;
				backgroundSkin.height = 20 * this.scale;
				list.listProperties.backgroundSkin = backgroundSkin;
				list.listProperties.paddingTop = list.listProperties.paddingRight =
					list.listProperties.paddingBottom = list.listProperties.paddingLeft = 8 * this.scale;
			}
		}

		protected function pickerListButtonInitializer(button:Button):void
		{
			//we're going to expand on the standard button styles
			this.buttonInitializer(button);

			const defaultIcon:Image = new Image(dropDownArrowTexture);
			defaultIcon.scaleX = defaultIcon.scaleY = this.scale;
			button.defaultIcon = defaultIcon;
			button.gap = Number.POSITIVE_INFINITY, //fill as completely as possible
				button.iconPosition = Button.ICON_POSITION_RIGHT;
			button.horizontalAlign =  Button.HORIZONTAL_ALIGN_LEFT;
		}

		protected function headerInitializer(header:Header):void
		{
			header.minWidth = 88 * this.scale;
			header.minHeight = 88 * this.scale;
			header.paddingTop = header.paddingRight = header.paddingBottom =
				header.paddingLeft = 14 * this.scale;
			header.gap = 8 * this.scale;
			header.titleGap = 12 * this.scale;
			const backgroundSkin:Scale9Image = new Scale9Image(headerSkinTextures, this.scale);
			backgroundSkin.width = 88 * this.scale;
			backgroundSkin.height = 88 * this.scale;
			header.backgroundSkin = backgroundSkin;
			header.titleProperties.textFormat = new BitmapFontTextFormat(bitmapFont, this.fontSize, PRIMARY_TEXT_COLOR);
		}

		protected function textInputInitializer(input:TextInput):void
		{
			input.minWidth = input.minHeight = 66 * this.scale;
			input.minTouchWidth = input.minTouchHeight = 66 * this.scale;
			input.paddingTop = input.paddingBottom = 14 * this.scale;
			input.paddingLeft = input.paddingRight = 16 * this.scale;
			input.textEditorProperties.fontFamily = "Helvetica";
			input.textEditorProperties.fontSize = 30 * this.scale;
			input.textEditorProperties.color = INSET_TEXT_COLOR;

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
			pageIndicator.gap = 12 * this.scale;
			pageIndicator.paddingTop = pageIndicator.paddingRight = pageIndicator.paddingBottom =
				pageIndicator.paddingLeft = 12 * this.scale;
			pageIndicator.minTouchWidth = pageIndicator.minTouchHeight = 44 * this.scale;
		}

		protected function progressBarInitializer(progress:ProgressBar):void
		{
			const backgroundSkin:Scale9Image = new Scale9Image(insetBackgroundSkinTextures, this.scale);
			backgroundSkin.width = (progress.direction == ProgressBar.DIRECTION_HORIZONTAL ? 264 : 22) * this.scale;
			backgroundSkin.height = (progress.direction == ProgressBar.DIRECTION_HORIZONTAL ? 22 : 264) * this.scale;
			progress.backgroundSkin = backgroundSkin;

			const backgroundDisabledSkin:Scale9Image = new Scale9Image(insetBackgroundDisabledSkinTextures, this.scale);
			backgroundDisabledSkin.width = (progress.direction == ProgressBar.DIRECTION_HORIZONTAL ? 264 : 22) * this.scale;
			backgroundDisabledSkin.height = (progress.direction == ProgressBar.DIRECTION_HORIZONTAL ? 22 : 264) * this.scale;
			progress.backgroundDisabledSkin = backgroundDisabledSkin;

			const fillSkin:Scale9Image = new Scale9Image(buttonUpSkinTextures, this.scale);
			fillSkin.width = 12 * this.scale;
			fillSkin.height = 12 * this.scale;
			progress.fillSkin = fillSkin;

			const fillDisabledSkin:Scale9Image = new Scale9Image(buttonDisabledSkinTextures, this.scale);
			fillDisabledSkin.width = 12 * this.scale;
			fillDisabledSkin.height = 12 * this.scale;
			progress.fillDisabledSkin = fillDisabledSkin;
		}

		protected function calloutInitializer(callout:Callout):void
		{
			callout.minWidth = 20 * this.scale;
			callout.minHeight = 20 * this.scale;
			callout.paddingTop = callout.paddingRight = callout.paddingBottom =
				callout.paddingLeft = 8 * this.scale;
			const backgroundSkin:Scale9Image = new Scale9Image(popUpBackgroundSkinTextures, this.scale);
			backgroundSkin.width = 20 * this.scale;
			backgroundSkin.height = 20 * this.scale;
			callout.backgroundSkin = backgroundSkin;

			const topArrowSkin:Image = new Image(calloutTopArrowSkinTexture);
			topArrowSkin.scaleX = topArrowSkin.scaleY = this.scale;
			callout.topArrowSkin = topArrowSkin;
			callout.topArrowGap = -4 * this.scale;

			const bottomArrowSkin:Image = new Image(calloutBottomArrowSkinTexture);
			bottomArrowSkin.scaleX = bottomArrowSkin.scaleY = this.scale;
			callout.bottomArrowSkin = bottomArrowSkin;
			callout.bottomArrowGap = -4 * this.scale;

			const leftArrowSkin:Image = new Image(calloutLeftArrowSkinTexture);
			leftArrowSkin.scaleX = leftArrowSkin.scaleY = this.scale;
			callout.leftArrowSkin = leftArrowSkin;
			callout.leftArrowGap = -4 * this.scale;

			const rightArrowSkin:Image = new Image(calloutRightArrowSkinTexture);
			rightArrowSkin.scaleX = rightArrowSkin.scaleY = this.scale;
			callout.rightArrowSkin = rightArrowSkin;
			callout.rightArrowGap = -4 * this.scale;
		}

		protected function root_addedToStageHandler(event:Event):void
		{
			DisplayObject(event.currentTarget).stage.color = BACKGROUND_COLOR;
		}
	}
}