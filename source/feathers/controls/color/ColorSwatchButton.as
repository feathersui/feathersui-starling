/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.color
{
	import feathers.controls.ToggleButton;
	import feathers.skins.IStyleProvider;

	import starling.display.Quad;
	import starling.events.Event;

	[Event(name="change",type="starling.events.Event")]

	/**
	 * A button that displays a color that may be used for building color
	 * pickers.
	 */
	public class ColorSwatchButton extends ToggleButton implements IColorControl
	{
		/**
		 * The default <code>IStyleProvider</code> for all <code>ColorSwatchButton</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function ColorSwatchButton()
		{
			super();
			this.isToggle = false;
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return ColorSwatchButton.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _swatch:Quad;

		/**
		 * @private
		 */
		protected var _color:uint = 0x000000;

		/**
		 * The color to display.
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
		 * @private
		 */
		override protected function initialize():void
		{
			if(this._swatch === null)
			{
				this._swatch = new Quad(1, 1, 0);
				this.addChild(this._swatch);
			}
			super.initialize();
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(dataInvalid)
			{
				this.refreshSwatch();
			}
			super.draw();
			this.layoutContent();
		}

		/**
		 * @private
		 */
		protected function refreshSwatch():void
		{
			this._swatch.color = this._color;
		}

		/**
		 * @private
		 */
		override protected function layoutContent():void
		{
			super.layoutContent();
			this._swatch.x = this._paddingLeft;
			this._swatch.y = this._paddingRight;
			this._swatch.width = this.actualWidth - this._paddingLeft - this._paddingRight;
			this._swatch.height = this.actualHeight - this._paddingTop - this._paddingBottom;
			var index:int = this.getChildIndex(this.currentSkin) + 1;
			if(this.getChildIndex(this._swatch) !== index)
			{
				this.setChildIndex(this._swatch, index);
			}
		}
	}
}
