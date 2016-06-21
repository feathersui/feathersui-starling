/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.color
{
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.skins.IStyleProvider;

	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="update",type="starling.events.Event")]
	[Event(name="change",type="starling.events.Event")]

	public class DefaultColorPopUp extends LayoutGroup implements IColorControl
	{
		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * color drop-down's swatch.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_SWATCH:String = "feathers-color-drop-down-swatch";

		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * color drop-down's input.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_INPUT:String = "feathers-color-drop-down-input";

		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * color drop-down's swatch list.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_SWATCH_LIST:String = "feathers-color-drop-down-swatch-list";

		/**
		 * The default <code>IStyleProvider</code> for all
		 * <code>DefaultColorDropDown</code> components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * @private
		 */
		protected static function defaultSwatchFactory():ColorSwatchButton
		{
			return new ColorSwatchButton();
		}

		/**
		 * @private
		 */
		protected static function defaultSwatchListFactory():ColorSwatchList
		{
			return new ColorSwatchList();
		}

		/**
		 * @private
		 */
		protected static function defaultInputFactory():HexColorInput
		{
			return new HexColorInput();
		}

		/**
		 * Constructor.
		 */
		public function DefaultColorPopUp()
		{
			super();
		}

		protected var swatchStyleName:String = DEFAULT_CHILD_STYLE_NAME_SWATCH;

		protected var inputStyleName:String = DEFAULT_CHILD_STYLE_NAME_INPUT;

		protected var swatchListStyleName:String = DEFAULT_CHILD_STYLE_NAME_SWATCH_LIST;

		protected var swatch:IColorControl;

		protected var input:HexColorInput;

		protected var swatchList:ColorSwatchList;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return DefaultColorPopUp.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _color:uint = 0x000000;

		/**
		 * The currently selected color value;
		 *
		 * @default 0x000000
		 */
		public function get color():uint
		{
			return this._color;
		}

		/**
		 * @private
		 */
		public function set color(value:uint):void
		{
			if(this._color === value)
			{
				return;
			}
			this._color = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * Quickly sets all padding properties to the same value. The
		 * <code>padding</code> getter always returns the value of
		 * <code>paddingTop</code>, but the other padding values may be
		 * different.
		 *
		 * <p>The following example gives the button 20 pixels of padding on all
		 * sides:</p>
		 *
		 * <listing version="3.0">
		 * control.padding = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #paddingTop
		 * @see #paddingRight
		 * @see #paddingBottom
		 * @see #paddingLeft
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
		 * The minimum space, in pixels, between the control's top edge and the
		 * content.
		 *
		 * <p>The following example gives the control 20 pixels of padding on
		 * the top edge only:</p>
		 *
		 * <listing version="3.0">
		 * control.paddingTop = 20;</listing>
		 *
		 * @default 0
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
			if(this._paddingTop == value)
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
		 * The minimum space, in pixels, between the control's right edge and
		 * the content.
		 *
		 * <p>The following example gives the control 20 pixels of padding on
		 * the right edge only:</p>
		 *
		 * <listing version="3.0">
		 * control.paddingRight = 20;</listing>
		 *
		 * @default 0
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
			if(this._paddingRight == value)
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
		 * The minimum space, in pixels, between the control's bottom edge and
		 * the content.
		 *
		 * <p>The following example gives the control 20 pixels of padding on
		 * the bottom edge only:</p>
		 *
		 * <listing version="3.0">
		 * control.paddingBottom = 20;</listing>
		 *
		 * @default 0
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
			if(this._paddingBottom == value)
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
		 * The minimum space, in pixels, between the control's left edge and the
		 * content.
		 *
		 * <p>The following example gives the control 20 pixels of padding on
		 * the left edge only:</p>
		 *
		 * <listing version="3.0">
		 * control.paddingLeft = 20;</listing>
		 *
		 * @default 0
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
			if(this._paddingLeft == value)
			{
				return;
			}
			this._paddingLeft = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _gap:Number = 0;

		/**
		 * The space, in pixels, between the control's content.
		 *
		 * <p>The following example gives the control 20 pixels of gap between
		 * items:</p>
		 *
		 * <listing version="3.0">
		 * control.gap = 20;</listing>
		 *
		 * @default 0
		 */
		public function get gap():Number
		{
			return this._gap;
		}

		/**
		 * @private
		 */
		public function set gap(value:Number):void
		{
			if(this._gap == value)
			{
				return;
			}
			this._gap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _ignoreValueChanges:Boolean = false;

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(this._layout === null)
			{
				this.layout = new AnchorLayout();
			}

			super.initialize();

			this.createSwatchList();
			this.createSwatch();
			this.createInput();
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			/*var swatchFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SWATCH_FACTORY);
			var inputFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_INPUT_FACTORY);
			var swatchListFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SWATCH_LIST_FACTORY);

			if(swatchFactoryInvalid)
			{
				this.createSwatch();
			}

			if(inputFactoryInvalid)
			{
				this.createInput();
			}

			if(swatchListFactoryInvalid)
			{
				this.createSwatchList();
			}*/

			if(stylesInvalid)
			{
				this.refreshLayout();
			}

			if(dataInvalid)
			{
				var oldIgnoreValueChanges:Boolean = this._ignoreValueChanges;
				this._ignoreValueChanges = true;
				this.swatch.color = this._color;
				this.input.color = this._color;
				this.swatchList.color = this._color;
				this._ignoreValueChanges = oldIgnoreValueChanges;
			}

			super.draw();
		}

		/**
		 * @private
		 */
		protected function refreshLayout():void
		{
			if(!(this._layout is AnchorLayout))
			{
				return;
			}
			var layoutData:AnchorLayoutData = this.swatch.layoutData as AnchorLayoutData;
			if(layoutData !== null)
			{
				layoutData.top = this._paddingTop;
				layoutData.left = this._paddingLeft;
			}

			layoutData = this.input.layoutData as AnchorLayoutData;
			if(layoutData !== null)
			{
				layoutData.top = this._paddingTop;
				layoutData.left = this._gap;
				layoutData.leftAnchorDisplayObject = DisplayObject(this.swatch);
			}

			layoutData = this.swatchList.layoutData as AnchorLayoutData;
			if(layoutData !== null)
			{
				layoutData.top = this._gap;
				layoutData.bottom = this._paddingBottom;
				layoutData.horizontalCenter = 0;
				layoutData.topAnchorDisplayObject = this.input;
			}
		}

		/**
		 * Creates and adds the <code>swatch</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #swatch
		 * @see #swatchFactory
		 * @see #customSwatchStyleName
		 */
		protected function createSwatch():void
		{
			if(this.swatch !== null)
			{
				this.swatch.removeFromParent(true);
				this.swatch = null;
			}

			var factory:Function = /*this._swatchFactory != null ? this._swatchFactory :*/ defaultSwatchFactory;
			var swatchStyleName:String = /*this._customSwatchStyleName !== null ? this._customSwatchStyleName :*/ this.swatchStyleName;
			this.swatch = IColorControl(factory());
			this.swatch.styleNameList.add(swatchStyleName);
			if(this._layout is AnchorLayout)
			{
				this.swatch.layoutData = new AnchorLayoutData()
			}
			this.addChild(DisplayObject(this.swatch));

			/*//we will use these values for measurement, if possible
			this.swatchExplicitWidth = this.swatch.explicitWidth;
			this.swatchExplicitHeight = this.swatch.explicitHeight;
			this.swatchExplicitMinWidth = this.swatch.explicitMinWidth;
			this.swatchExplicitMinHeight = this.swatch.explicitMinHeight;*/
		}

		/**
		 * Creates and adds the <code>HexColorInput</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #input
		 * @see #inputFactory
		 * @see #customInputStyleName
		 */
		protected function createInput():void
		{
			if(this.input !== null)
			{
				this.input.removeFromParent(true);
				this.input = null;
			}

			var factory:Function = /*this._inputFactory != null ? this._inputFactory :*/ defaultInputFactory;
			var swatchListStyleName:String = /*this._customInputStyleName !== null ? this._customInputStyleName :*/ this.inputStyleName;
			this.input = HexColorInput(factory());
			this.input.styleNameList.add(swatchListStyleName);
			this.input.addEventListener(Event.UPDATE, input_updateHandler);
			this.input.addEventListener(Event.CHANGE, input_changeHandler);
			if(this._layout is AnchorLayout)
			{
				this.input.layoutData = new AnchorLayoutData()
			}
			this.addChild(this.input);

			/*//we will use these values for measurement, if possible
			this.inputExplicitWidth = this.input.explicitWidth;
			this.inputExplicitHeight = this.input.explicitHeight;
			this.inputExplicitMinWidth = this.input.explicitMinWidth;
			this.inputExplicitMinHeight = this.input.explicitMinHeight;*/
		}

		/**
		 * Creates and adds the <code>swatchList</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #swatchList
		 * @see #swatchListFactory
		 * @see #customSwatchListStyleName
		 */
		protected function createSwatchList():void
		{
			if(this.swatchList !== null)
			{
				this.swatchList.removeFromParent(true);
				this.swatchList = null;
			}

			var factory:Function = /*this._swatchListFactory != null ? this._swatchListFactory :*/ defaultSwatchListFactory;
			var swatchListStyleName:String = /*this._customSwatchListStyleName !== null ? this._customSwatchListStyleName :*/ this.swatchListStyleName;
			this.swatchList = ColorSwatchList(factory());
			this.swatchList.styleNameList.add(swatchListStyleName);
			this.swatchList.addEventListener(Event.UPDATE, swatchList_updateHandler);
			this.swatchList.addEventListener(Event.CHANGE, swatchList_changeHandler);
			this.swatchList.addEventListener(Event.TRIGGERED, swatchList_triggeredHandler);
			if(this._layout is AnchorLayout)
			{
				this.swatchList.layoutData = new AnchorLayoutData()
			}
			this.addChild(this.swatchList);

			/*//we will use these values for measurement, if possible
			this.swatchListExplicitWidth = this.swatchList.explicitWidth;
			this.swatchListExplicitHeight = this.swatchList.explicitHeight;
			this.swatchListExplicitMinWidth = this.swatchList.explicitMinWidth;
			this.swatchListExplicitMinHeight = this.swatchList.explicitMinHeight;*/
		}

		/**
		 * @private
		 */
		protected function swatchList_updateHandler(event:Event, color:Object):void
		{
			var oldIgnoreValueChanges:Boolean = this._ignoreValueChanges;
			this._ignoreValueChanges = true;
			if(color !== null)
			{
				var newColor:uint = color as uint;
				this.swatch.color = newColor;
				this.input.color = newColor;
			}
			else
			{
				this.swatch.color = this._color;
				this.input.color = this._color;
			}
			this._ignoreValueChanges = oldIgnoreValueChanges;
			this.dispatchEventWith(Event.UPDATE, false, color)
		}

		/**
		 * @private
		 */
		protected function swatchList_changeHandler(event:Event):void
		{
			if(this._ignoreValueChanges)
			{
				return;
			}
			this.color = this.swatchList.color;
		}

		/**
		 * @private
		 */
		protected function swatchList_triggeredHandler(event:Event):void
		{
			this.dispatchEventWith(Event.TRIGGERED, false, event.data);
		}

		/**
		 * @private
		 */
		protected function input_updateHandler(event:Event, color:Object):void
		{
			var oldIgnoreValueChanges:Boolean = this._ignoreValueChanges;
			this._ignoreValueChanges = true;
			if(color !== null)
			{
				this.swatch.color = color as uint;
			}
			else
			{
				this.swatch.color = this._color;
			}
			this._ignoreValueChanges = oldIgnoreValueChanges;
			this.dispatchEventWith(Event.UPDATE, false, color)
		}

		/**
		 * @private
		 */
		protected function input_changeHandler(event:Event):void
		{
			if(this._ignoreValueChanges)
			{
				return;
			}
			this.color = this.input.color;
		}
	}
}
