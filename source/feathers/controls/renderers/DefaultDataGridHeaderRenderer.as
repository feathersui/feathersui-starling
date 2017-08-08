/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.renderers
{
	import feathers.controls.GroupedList;
	import feathers.controls.ImageLoader;
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.IMeasureDisplayObject;
	import feathers.core.ITextRenderer;
	import feathers.core.IValidating;
	import feathers.core.PropertyProxy;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalAlign;
	import feathers.skins.IStyleProvider;
	import feathers.text.FontStylesSet;
	import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;

	import flash.geom.Point;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.text.TextFormat;
	import feathers.controls.renderers.IDataGridHeaderRenderer;
	import feathers.controls.DataGridColumn;
	import feathers.controls.DataGrid;
	import starling.utils.Pool;

	/**
	 * A background to behind the header renderer's content.
	 *
	 * <p>In the following example, the header renderers is given a
	 * background skin:</p>
	 *
	 * <listing version="3.0">
	 * headerRenderer.backgroundSkin = new Image( texture );</listing>
	 *
	 * @default null
	 * 
	 * @see #style:backgroundDisabledSkin
	 */
	[Style(name="backgroundSkin",type="starling.display.DisplayObject")]

	/**
	 * A background to display when the header renderer is disabled.
	 *
	 * <p>In the following example, the header renderers is given a
	 * disabled background skin:</p>
	 *
	 * <listing version="3.0">
	 * headerRenderer.backgroundDisabledSkin = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #style:backgroundSkin
	 */
	[Style(name="backgroundDisabledSkin",type="starling.display.DisplayObject")]

	/**
	 * A style name to add to the header renderer's text renderer
	 * sub-component. Typically used by a theme to provide different styles to
	 * different header renderers.
	 *
	 * <p>In the following example, a custom text renderer style name is passed
	 * to the header renderer:</p>
	 *
	 * <listing version="3.0">
	 * headerRenderer.customTextRendererStyleName = "my-custom-header-text";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( BitmapFontTextRenderer ).setFunctionForStyleName( "my-custom-header-text", setCustomHeaderTextStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_TEXT_RENDERER
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #textRendererFactory
	 */
	[Style(name="customTextRendererStyleName",type="String")]

	/**
	 * The font styles used to display the header renderer's text when the
	 * component is disabled.
	 *
	 * <p>In the following example, the disabled font styles are customized:</p>
	 *
	 * <listing version="3.0">
	 * headerRenderer.disabledFontStyles = new TextFormat( "Helvetica", 20, 0x999999 );</listing>
	 *
	 * <p>Note: The <code>starling.text.TextFormat</code> class defines a
	 * number of common font styles, but the text renderer being used may
	 * support a larger number of ways to be customized. Use the
	 * <code>textRendererFactory</code> to set more advanced styles on the
	 * text renderer.</p>
	 *
	 * @default null
	 *
	 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
	 * @see #style:fontStyles
	 */
	[Style(name="disabledFontStyles",type="starling.text.TextFormat")]

	/**
	 * The font styles used to display the header renderer's text.
	 *
	 * <p>In the following example, the font styles are customized:</p>
	 *
	 * <listing version="3.0">
	 * headerRenderer.fontStyles = new TextFormat( "Helvetica", 20, 0xcc0000 );</listing>
	 *
	 * <p>Note: The <code>starling.text.TextFormat</code> class defines a
	 * number of common font styles, but the text renderer being used may
	 * support a larger number of ways to be customized. Use the
	 * <code>textRendererFactory</code> to set more advanced styles.</p>
	 *
	 * @default null
	 *
	 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
	 * @see #style:disabledFontStyles
	 */
	[Style(name="fontStyles",type="starling.text.TextFormat")]

	/**
	 * The location where the header renderer's content is aligned horizontally
	 * (on the x-axis).
	 *
	 * <p>In the following example, the horizontal alignment is changed to
	 * right:</p>
	 *
	 * <listing version="3.0">
	 * headerRenderer.horizontalAlign = HorizontalAlign.RIGHT;</listing>
	 *
	 * @default feathers.layout.HorizontalAlign.LEFT
	 *
	 * @see feathers.layout.HorizontalAlign#LEFT
	 * @see feathers.layout.HorizontalAlign#CENTER
	 * @see feathers.layout.HorizontalAlign#RIGHT
	 * @see feathers.layout.HorizontalAlign#JUSTIFY
	 */
	[Style(name="horizontalAlign",type="String")]

	/**
	 * Quickly sets all padding properties to the same value. The
	 * <code>padding</code> getter always returns the value of
	 * <code>paddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * <p>In the following example, the padding on all four sides is set to 20
	 * pixels:</p>
	 *
	 * <listing version="3.0">
	 * headerRenderer.padding = 20;</listing>
	 *
	 * @default 0
	 * 
	 * @see #style:paddingTop
	 * @see #style:paddingRight
	 * @see #style:paddingBottom
	 * @see #style:paddingLeft
	 */
	[Style(name="padding",type="Number")]

	/**
	 * The minimum space, in pixels, between the component's top edge and
	 * the component's content.
	 *
	 * <p>In the following example, the top padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * headerRenderer.paddingTop = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingTop",type="Number")]

	/**
	 * The minimum space, in pixels, between the component's right edge
	 * and the component's content.
	 *
	 * <p>In the following example, the right padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * headerRenderer.paddingRight = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingRight",type="Number")]

	/**
	 * The minimum space, in pixels, between the component's bottom edge
	 * and the component's content.
	 *
	 * <p>In the following example, the bottom padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * headerRenderer.paddingBottom = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingBottom",type="Number")]

	/**
	 * The minimum space, in pixels, between the component's left edge
	 * and the component's content.
	 *
	 * <p>In the following example, the left padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * headerRenderer.paddingLeft = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingLeft",type="Number")]

	/**
	 * The location where the header renderer's content is aligned vertically
	 * (on the y-axis).
	 *
	 * <p>In the following example, the vertical alignment is changed to
	 * bottom:</p>
	 *
	 * <listing version="3.0">
	 * headerRenderer.verticalAlign = VerticalAlign.BOTTOM;</listing>
	 *
	 * @default feathers.layout.VerticalAlign.MIDDLE
	 *
	 * @see feathers.layout.VerticalAlign#TOP
	 * @see feathers.layout.VerticalAlign#MIDDLE
	 * @see feathers.layout.VerticalAlign#BOTTOM
	 * @see feathers.layout.VerticalAlign#JUSTIFY
	 */
	[Style(name="verticalAlign",type="String")]

	/**
	 * Determines if the text wraps to the next line when it reaches the
	 * width (or max width) of the component.
	 *
	 * <p>In the following example, the header renderer's text is wrapped:</p>
	 *
	 * <listing version="3.0">
	 * headerRenderer.wordWrap = true;</listing>
	 *
	 * @default false
	 */
	[Style(name="wordWrap",type="Boolean")]

	/**
	 * The default renderer used for headers in a <code>DataGrid</code> component.
	 *
	 * @see feathers.controls.GroupedList
	 *
	 * @productversion Feathers 3.4.0
	 */
	public class DefaultDataGridHeaderRenderer extends FeathersControl implements IDataGridHeaderRenderer
	{
		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * text renderer.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_TEXT_RENDERER:String = "feathers-data-grid-header-renderer-text-renderer";

		/**
		 * The default <code>IStyleProvider</code> for all <code>DefaultDataGridHeaderRenderer</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * @private
		 */
		protected static function defaultImageLoaderFactory():ImageLoader
		{
			return new ImageLoader();
		}

		/**
		 * Constructor.
		 */
		public function DefaultDataGridHeaderRenderer()
		{
			super();
			if(this._fontStylesSet === null)
			{
				this._fontStylesSet = new FontStylesSet();
				this._fontStylesSet.addEventListener(Event.CHANGE, fontStyles_changeHandler);
			}
		}

		/**
		 * The value added to the <code>styleNameList</code> of the text
		 * renderer. This variable is <code>protected</code> so that
		 * sub-classes can customize the label text renderer style name in their
		 * constructors instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_TEXT_RENDERER</code>.
		 *
		 * <p>To customize the text renderer style name without
		 * subclassing, see <code>customTextRendererStyleName</code>.</p>
		 *
		 * @see #style:customTextRendererStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var textRendererStyleName:String = DEFAULT_CHILD_STYLE_NAME_TEXT_RENDERER;

		/**
		 * @private
		 */
		protected var textRenderer:ITextRenderer;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return DefaultDataGridHeaderRenderer.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _data:DataGridColumn = null;

		/**
		 * @inheritDoc
		 */
		public function get data():DataGridColumn
		{
			return this._data;
		}

		/**
		 * @private
		 */
		public function set data(value:DataGridColumn):void
		{
			if(this._data == value)
			{
				return;
			}
			this._data = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _layoutIndex:int = -1;

		/**
		 * @inheritDoc
		 */
		public function get layoutIndex():int
		{
			return this._layoutIndex;
		}

		/**
		 * @private
		 */
		public function set layoutIndex(value:int):void
		{
			this._layoutIndex = value;
		}

		/**
		 * @private
		 */
		protected var _owner:DataGrid = null;

		/**
		 * @inheritDoc
		 */
		public function get owner():DataGrid
		{
			return this._owner;
		}

		/**
		 * @private
		 */
		public function set owner(value:DataGrid):void
		{
			if(this._owner === value)
			{
				return;
			}
			this._owner = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _horizontalAlign:String = HorizontalAlign.LEFT;

		[Inspectable(type="String",enumeration="left,center,right,justify")]
		/**
		 * @private
		 */
		public function get horizontalAlign():String
		{
			return this._horizontalAlign;
		}

		/**
		 * @private
		 */
		public function set horizontalAlign(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._horizontalAlign === value)
			{
				return;
			}
			this._horizontalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _verticalAlign:String = VerticalAlign.MIDDLE;

		[Inspectable(type="String",enumeration="top,middle,bottom,justify")]
		/**
		 * @private
		 */
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}

		/**
		 * @private
		 */
		public function set verticalAlign(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._verticalAlign === value)
			{
				return;
			}
			this._verticalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _fontStylesSet:FontStylesSet;

		/**
		 * @private
		 */
		public function get fontStyles():TextFormat
		{
			return this._fontStylesSet.format;
		}

		/**
		 * @private
		 */
		public function set fontStyles(value:TextFormat):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._fontStylesSet.format = value;
		}

		/**
		 * @private
		 */
		public function get disabledFontStyles():TextFormat
		{
			return this._fontStylesSet.disabledFormat;
		}

		/**
		 * @private
		 */
		public function set disabledFontStyles(value:TextFormat):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._fontStylesSet.disabledFormat = value;
		}

		/**
		 * @private
		 */
		private var _wordWrap:Boolean = false;

		/**
		 * @private
		 */
		public function get wordWrap():Boolean
		{
			return this._wordWrap;
		}

		/**
		 * @private
		 */
		public function set wordWrap(value:Boolean):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._wordWrap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _textRendererFactory:Function = null;

		/**
		 * A function that generates an <code>ITextRenderer</code> that
		 * displays the header's text. The factory may be used to set custom
		 * properties on the <code>ITextRenderer</code>.
		 *
		 * <p>In the following example, a custom text renderer factory is passed
		 * to the renderer:</p>
		 *
		 * <listing version="3.0">
		 * headerRenderer.textRendererFactory = function():ITextRenderer
		 * {
		 *     var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
		 *     textRenderer.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333 );
		 *     textRenderer.embedFonts = true;
		 *     return textRenderer;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.ITextRenderer
		 * @see feathers.core.FeathersControl#defaultTextRendererFactory
		 */
		public function get textRendererFactory():Function
		{
			return this._textRendererFactory;
		}

		/**
		 * @private
		 */
		public function set textRendererFactory(value:Function):void
		{
			if(this._textRendererFactory == value)
			{
				return;
			}
			this._textRendererFactory = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _customTextRendererStyleName:String = null;

		/**
		 * @private
		 */
		public function get customTextRendererStyleName():String
		{
			return this._customTextRendererStyleName;
		}

		/**
		 * @private
		 */
		public function set customTextRendererStyleName(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customTextRendererStyleName === value)
			{
				return;
			}
			this._customTextRendererStyleName = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _explicitBackgroundWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundMinWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundMinHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundMaxWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundMaxHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitTextRendererWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitTextRendererHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitTextRendererMinWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitTextRendererMinHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitTextRendererMaxWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitTextRendererMaxHeight:Number;

		/**
		 * @private
		 */
		protected var currentBackgroundSkin:DisplayObject;

		/**
		 * @private
		 */
		protected var _backgroundSkin:DisplayObject;

		/**
		 * @private
		 */
		public function get backgroundSkin():DisplayObject
		{
			return this._backgroundSkin;
		}

		/**
		 * @private
		 */
		public function set backgroundSkin(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._backgroundSkin === value)
			{
				return;
			}
			if(this._backgroundSkin !== null &&
				this.currentBackgroundSkin === this._backgroundSkin)
			{
				this.removeCurrentBackgroundSkin(this._backgroundSkin);
				this.currentBackgroundSkin = null;
			}
			this._backgroundSkin = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _backgroundDisabledSkin:DisplayObject;

		/**
		 * @private
		 */
		public function get backgroundDisabledSkin():DisplayObject
		{
			return this._backgroundDisabledSkin;
		}

		/**
		 * @private
		 */
		public function set backgroundDisabledSkin(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._backgroundDisabledSkin === value)
			{
				return;
			}
			if(this._backgroundDisabledSkin !== null &&
				this.currentBackgroundSkin === this._backgroundDisabledSkin)
			{
				this.removeCurrentBackgroundSkin(this._backgroundDisabledSkin);
				this.currentBackgroundSkin = null;
			}
			this._backgroundDisabledSkin = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		public function get padding():Number
		{
			return this._paddingTop;
		}

		/**
		 * @private
		 */
		public function set padding(value:Number):void
		{
			this.paddingTop = value;
			this.paddingRight = value;
			this.paddingBottom = value;
			this.paddingLeft = value;
		}

		/**
		 * @private
		 */
		protected var _paddingTop:Number = 0;

		/**
		 * @private
		 */
		public function get paddingTop():Number
		{
			return this._paddingTop;
		}

		/**
		 * @private
		 */
		public function set paddingTop(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._paddingTop === value)
			{
				return;
			}
			this._paddingTop = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingRight:Number = 0;

		/**
		 * @private
		 */
		public function get paddingRight():Number
		{
			return this._paddingRight;
		}

		/**
		 * @private
		 */
		public function set paddingRight(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._paddingRight === value)
			{
				return;
			}
			this._paddingRight = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingBottom:Number = 0;

		/**
		 * @private
		 */
		public function get paddingBottom():Number
		{
			return this._paddingBottom;
		}

		/**
		 * @private
		 */
		public function set paddingBottom(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._paddingBottom === value)
			{
				return;
			}
			this._paddingBottom = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingLeft:Number = 0;

		/**
		 * @private
		 */
		public function get paddingLeft():Number
		{
			return this._paddingLeft;
		}

		/**
		 * @private
		 */
		public function set paddingLeft(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._paddingLeft === value)
			{
				return;
			}
			this._paddingLeft = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * The number of text lines displayed by the renderer. The component may
		 * contain multiple text lines if the text contains line breaks or if
		 * the <code>wordWrap</code> property is enabled.
		 *
		 * @see #wordWrap
		 */
		public function get numLines():int
		{
			if(this.textRenderer === null)
			{
				return 0;
			}
			return this.textRenderer.numLines;
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			//we don't dispose it if the renderer is the parent because it'll
			//already get disposed in super.dispose()
			if(this._backgroundSkin !== null &&
				this._backgroundSkin.parent !== this)
			{
				this._backgroundSkin.dispose();
			}
			if(this._backgroundDisabledSkin !== null &&
				this._backgroundDisabledSkin.parent !== this)
			{
				this._backgroundDisabledSkin.dispose();
			}
			if(this._fontStylesSet !== null)
			{
				this._fontStylesSet.dispose();
				this._fontStylesSet = null;
			}
			super.dispose();
		}

		/**
		 * Determines which text to display in the header.
		 */
		protected function itemToText(item:DataGridColumn):String
		{
			if(item !== null)
			{
				if(item.headerText !== null)
				{
					return item.headerText;
				}
				else if(item.dataField !== null)
				{
					return item.dataField;
				}
				return Object(item).toString();
			}
			return null;
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var textRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);

			if(stylesInvalid || stateInvalid)
			{
				this.refreshBackgroundSkin();
			}

			if(textRendererInvalid)
			{
				this.createTextRenderer();
			}

			if(textRendererInvalid || dataInvalid)
			{
				this.commitData();
			}

			if(dataInvalid || stylesInvalid)
			{
				this.refreshTextRendererStyles();
			}

			if(dataInvalid || stateInvalid)
			{
				this.refreshEnabled();
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;
			this.layoutChildren();
		}

		/**
		 * If the component's dimensions have not been set explicitly, it will
		 * measure its content and determine an ideal size for itself. If the
		 * <code>explicitWidth</code> or <code>explicitHeight</code> member
		 * variables are set, those value will be used without additional
		 * measurement. If one is set, but not the other, the dimension with the
		 * explicit value will not be measured, but the other non-explicit
		 * dimension will still need measurement.
		 *
		 * <p>Calls <code>saveMeasurements()</code> to set up the
		 * <code>actualWidth</code> and <code>actualHeight</code> member
		 * variables used for layout.</p>
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			var needsWidth:Boolean = this._explicitWidth !== this._explicitWidth; //isNaN
			var needsHeight:Boolean = this._explicitHeight !== this._explicitHeight; //isNaN
			var needsMinWidth:Boolean = this._explicitMinWidth !== this._explicitMinWidth; //isNaN
			var needsMinHeight:Boolean = this._explicitMinHeight !== this._explicitMinHeight; //isNaN
			if(!needsWidth && !needsHeight && !needsMinWidth && !needsMinHeight)
			{
				return false;
			}

			resetFluidChildDimensionsForMeasurement(DisplayObject(this.textRenderer),
				this._explicitWidth - this._paddingLeft - this._paddingRight,
				this._explicitHeight - this._paddingTop - this._paddingBottom,
				this._explicitMinWidth - this._paddingLeft - this._paddingRight,
				this._explicitMinHeight - this._paddingTop - this._paddingBottom,
				this._explicitMaxWidth - this._paddingLeft - this._paddingRight,
				this._explicitMaxHeight - this._paddingTop - this._paddingBottom,
				this._explicitTextRendererWidth, this._explicitTextRendererHeight,
				this._explicitTextRendererMinWidth, this._explicitTextRendererMinHeight,
				this._explicitTextRendererMaxWidth, this._explicitTextRendererMaxHeight);
			this.textRenderer.maxWidth = this._explicitMaxWidth - this._paddingLeft - this._paddingRight;
			this.textRenderer.maxHeight = this._explicitMaxHeight - this._paddingTop - this._paddingBottom;
			var point:Point = Pool.getPoint();
			this.textRenderer.measureText(point);

			resetFluidChildDimensionsForMeasurement(this.currentBackgroundSkin,
				this._explicitWidth, this._explicitHeight,
				this._explicitMinWidth, this._explicitMinHeight,
				this._explicitMaxWidth, this._explicitMaxHeight,
				this._explicitBackgroundWidth, this._explicitBackgroundHeight,
				this._explicitBackgroundMinWidth, this._explicitBackgroundMinHeight,
				this._explicitBackgroundMaxWidth, this._explicitBackgroundMaxHeight);
			var measureSkin:IMeasureDisplayObject = this.currentBackgroundSkin as IMeasureDisplayObject;

			var newWidth:Number = this._explicitWidth;
			if(needsWidth)
			{
				newWidth = point.x;
				newWidth += this._paddingLeft + this._paddingRight;
				if(this.currentBackgroundSkin !== null &&
					this.currentBackgroundSkin.width > newWidth)
				{
					newWidth = this.currentBackgroundSkin.width;
				}
			}
			var newHeight:Number = this._explicitHeight;
			if(needsHeight)
			{
				newHeight = point.y;
				newHeight += this._paddingTop + this._paddingBottom;
				if(this.currentBackgroundSkin !== null &&
					this.currentBackgroundSkin.height > newHeight)
				{
					newHeight = this.currentBackgroundSkin.height;
				}
			}
			var newMinWidth:Number = this._explicitMinWidth;
			if(needsMinWidth)
			{
				newMinWidth = point.x;
				newMinWidth += this._paddingLeft + this._paddingRight;
				if(this.currentBackgroundSkin !== null)
				{
					if(measureSkin !== null)
					{
						if(measureSkin.minWidth > newMinWidth)
						{
							newMinWidth = measureSkin.minWidth;
						}
					}
					else if(this._explicitBackgroundMinWidth > newMinWidth)
					{
						newMinWidth = this._explicitBackgroundMinWidth;
					}
				}
			}
			var newMinHeight:Number = this._explicitMinHeight;
			if(needsMinHeight)
			{
				newMinHeight = point.y;
				newMinHeight += this._paddingTop + this._paddingBottom;
				if(this.currentBackgroundSkin !== null)
				{
					if(measureSkin !== null)
					{
						if(measureSkin.minHeight > newMinHeight)
						{
							newMinHeight = measureSkin.minHeight;
						}
					}
					else if(this._explicitBackgroundMinHeight > newMinHeight)
					{
						newMinHeight = this._explicitBackgroundMinHeight;
					}
				}
			}
			Pool.putPoint(point);
			return this.saveMeasurements(newWidth, newHeight, newMinWidth, newMinHeight);
		}

		/**
		 * @private
		 */
		protected function refreshBackgroundSkin():void
		{
			var oldBackgroundSkin:DisplayObject = this.currentBackgroundSkin;
			this.currentBackgroundSkin = this._backgroundSkin;
			if(!this._isEnabled && this._backgroundDisabledSkin !== null)
			{
				this.currentBackgroundSkin = this._backgroundDisabledSkin;
			}
			if(oldBackgroundSkin !== this.currentBackgroundSkin)
			{
				this.removeCurrentBackgroundSkin(oldBackgroundSkin);
				if(this.currentBackgroundSkin !== null)
				{
					if(this.currentBackgroundSkin is IFeathersControl)
					{
						IFeathersControl(this.currentBackgroundSkin).initializeNow();
					}
					if(this.currentBackgroundSkin is IMeasureDisplayObject)
					{
						var measureSkin:IMeasureDisplayObject = IMeasureDisplayObject(this.currentBackgroundSkin);
						this._explicitBackgroundWidth = measureSkin.explicitWidth;
						this._explicitBackgroundHeight = measureSkin.explicitHeight;
						this._explicitBackgroundMinWidth = measureSkin.explicitMinWidth;
						this._explicitBackgroundMinHeight = measureSkin.explicitMinHeight;
						this._explicitBackgroundMaxWidth = measureSkin.explicitMaxWidth;
						this._explicitBackgroundMaxHeight = measureSkin.explicitMaxHeight;
					}
					else
					{
						this._explicitBackgroundWidth = this.currentBackgroundSkin.width;
						this._explicitBackgroundHeight = this.currentBackgroundSkin.height;
						this._explicitBackgroundMinWidth = this._explicitBackgroundWidth;
						this._explicitBackgroundMinHeight = this._explicitBackgroundHeight;
						this._explicitBackgroundMaxWidth = this._explicitBackgroundWidth;
						this._explicitBackgroundMaxHeight = this._explicitBackgroundHeight;
					}
					this.addChildAt(this.currentBackgroundSkin, 0);
				}
			}
		}

		/**
		 * @private
		 */
		protected function removeCurrentBackgroundSkin(skin:DisplayObject):void
		{
			if(skin === null)
			{
				return;
			}
			if(skin.parent === this)
			{
				//we need to restore these values so that they won't be lost the
				//next time that this skin is used for measurement
				skin.width = this._explicitBackgroundWidth;
				skin.height = this._explicitBackgroundHeight;
				if(skin is IMeasureDisplayObject)
				{
					var measureSkin:IMeasureDisplayObject = IMeasureDisplayObject(skin);
					measureSkin.minWidth = this._explicitBackgroundMinWidth;
					measureSkin.minHeight = this._explicitBackgroundMinHeight;
					measureSkin.maxWidth = this._explicitBackgroundMaxWidth;
					measureSkin.maxHeight = this._explicitBackgroundMaxHeight;
				}
				skin.removeFromParent(false);
			}
		}

		/**
		 * @private
		 */
		protected function createTextRenderer():void
		{
			if(this.textRenderer !== null)
			{
				this.removeChild(DisplayObject(this.textRenderer), true);
				this.textRenderer = null;
			}

			var factory:Function = this._textRendererFactory != null ? this._textRendererFactory : FeathersControl.defaultTextRendererFactory;
			this.textRenderer = ITextRenderer(factory());
			var textRendererStyleName:String = this._customTextRendererStyleName != null ? this._customTextRendererStyleName : this.textRendererStyleName;
			this.textRenderer.styleNameList.add(textRendererStyleName);
			this.addChild(DisplayObject(this.textRenderer));

			this.textRenderer.initializeNow();
			this._explicitTextRendererWidth = this.textRenderer.explicitWidth;
			this._explicitTextRendererHeight = this.textRenderer.explicitHeight;
			this._explicitTextRendererMinWidth = this.textRenderer.explicitMinWidth;
			this._explicitTextRendererMinHeight = this.textRenderer.explicitMinHeight;
			this._explicitTextRendererMaxWidth = this.textRenderer.explicitMaxWidth;
			this._explicitTextRendererMaxHeight = this.textRenderer.explicitMaxHeight;
		}

		/**
		 * @private
		 */
		protected function commitData():void
		{
			if(this._owner)
			{
				this.textRenderer.text = this.itemToText(this._data);
			}
			else
			{
				this.textRenderer.text = null;
			}
		}

		/**
		 * @private
		 */
		protected function refreshEnabled():void
		{
			this.textRenderer.isEnabled = this._isEnabled;
		}

		/**
		 * @private
		 */
		protected function refreshTextRendererStyles():void
		{
			this.textRenderer.fontStyles = this._fontStylesSet;
			this.textRenderer.wordWrap = this._wordWrap;
		}

		/**
		 * @private
		 */
		protected function layoutChildren():void
		{
			if(this.currentBackgroundSkin !== null)
			{
				this.currentBackgroundSkin.width = this.actualWidth;
				this.currentBackgroundSkin.height = this.actualHeight;
			}

			this.textRenderer.maxWidth = this.actualWidth - this._paddingLeft - this._paddingRight;
			this.textRenderer.validate();

			switch(this._horizontalAlign)
			{
				case HorizontalAlign.CENTER:
				{
					this.textRenderer.x = this._paddingLeft + (this.actualWidth - this._paddingLeft - this._paddingRight - this.textRenderer.width) / 2;
					break;
				}
				case HorizontalAlign.RIGHT:
				{
					this.textRenderer.x = this.actualWidth - this._paddingRight - this.textRenderer.width;
					break;
				}
				case HorizontalAlign.JUSTIFY:
				{
					this.textRenderer.x = this._paddingLeft;
					this.textRenderer.width = this.actualWidth - this._paddingLeft - this._paddingRight;
					break;
				}
				default: //left
				{
					this.textRenderer.x = this._paddingLeft;
				}
			}

			switch(this._verticalAlign)
			{
				case VerticalAlign.TOP:
				{
					this.textRenderer.y = this._paddingTop;
					break;
				}
				case VerticalAlign.BOTTOM:
				{
					this.textRenderer.y = this.actualHeight - this._paddingBottom - this.textRenderer.height;
					break;
				}
				case VerticalAlign.JUSTIFY:
				{
					this.textRenderer.y = this._paddingTop;
					this.textRenderer.height = this.actualHeight - this._paddingTop - this._paddingBottom;
					break;
				}
				default: //middle
				{
					this.textRenderer.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this.textRenderer.height) / 2;
				}
			}

		}

		/**
		 * @private
		 */
		protected function fontStyles_changeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
	}
}
