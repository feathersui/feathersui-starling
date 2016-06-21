/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.color
{
	import feathers.controls.TextInput;
	import feathers.events.FeathersEventType;

	import starling.events.Event;
	import starling.utils.Color;

	[Event(name="change",type="starling.events.Event")]
	[Event(name="update",type="starling.events.Event")]

	/**
	 * A specialized <code>TextInput</code> that displays a hexadecimal color
	 * value.
	 */
	public class HexColorInput extends TextInput implements IColorControl
	{
		/**
		 * Constructor.
		 */
		public function HexColorInput()
		{
			super();
			this.restrict = "0-9a-fA-F#";
			this.maxChars = 7;
			this.addEventListener(FeathersEventType.ENTER, hexColorInput_enterHandler);
			this.addEventListener(FeathersEventType.FOCUS_OUT, hexColorInput_focusOutHandler);
		}

		/**
		 * @private
		 */
		protected var _color:uint = Color.BLACK;

		/**
		 * The color to display.
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
			if(value > Color.WHITE)
			{
				value = Color.WHITE;
			}
			if(this._color === value)
			{
				return;
			}
			this._color = value;
			this.text = this.colorToString(value);
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		override public function set text(value:String):void
		{
			if(value === null || value.length === 0)
			{
				//don't allow null or undefined
				value = "";
			}
			if(this._text === value)
			{
				return;
			}
			this._text = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
			var newValue:uint = this.stringToColor(this._text);
			if(this._liveUpdates)
			{
				//don't call the setter because it will change the text
				this._color = newValue;
				this.dispatchEventWith(Event.CHANGE);
			}
			else
			{
				this.dispatchEventWith(Event.UPDATE, false, newValue);
			}
		}

		/**
		 * @private
		 */
		protected var _liveUpdates:Boolean = false;

		/**
		 * Determines if the color value will change as the user types.
		 *
		 * @default false
		 */
		public function get liveUpdates():Boolean
		{
			return this._liveUpdates;
		}

		/**
		 * @private
		 */
		public function set liveUpdates(value:Boolean):void
		{
			this._liveUpdates = value;
		}

		/**
		 * @private
		 */
		protected var _showHashPrefix:Boolean = true;

		/**
		 * Determines if a hash sign is displayed as a prefix before the color
		 * value.
		 */
		public function get showHashPrefix():Boolean
		{
			return this._showHashPrefix;
		}

		/**
		 * @private
		 */
		public function set showHashPrefix(value:Boolean):void
		{
			if(this._showHashPrefix === value)
			{
				return;
			}
			this._showHashPrefix = value;
			this.text = this.colorToString(this._color);
		}

		/**
		 * @private
		 */
		protected function stringToColor(string:String):uint
		{
			if(string.charAt(0) === "#")
			{
				string = string.substr(1);
			}
			if(string.length === 3)
			{
				//shorthand: 19f becomes 1199ff
				string = string.charAt(0) + string.charAt(0) + string.charAt(1) +
					string.charAt(1) + string.charAt(2) + string.charAt(2);
			}
			var newValue:uint = parseInt(string, 16);
			if(newValue === newValue) //!isNaN
			{
				if(newValue > Color.WHITE)
				{
					newValue = Color.WHITE;
				}
				return newValue;
			}
			return 0;
		}

		/**
		 * @private
		 */
		protected function colorToString(value:uint):String
		{
			if(value > Color.WHITE)
			{
				value = Color.WHITE;
			}
			var colorAsString:String = value.toString(16);
			var charCount:int = 6 - colorAsString.length;
			for(var i:int = 0; i < charCount; i++)
			{
				colorAsString = "0" + colorAsString;
			}
			if(this._showHashPrefix)
			{
				colorAsString = "#" + colorAsString
			}
			return colorAsString;
		}

		/**
		 * @private
		 */
		protected function commitChanges():void
		{
			if(this._liveUpdates)
			{
				//the color value is already up to date because the text was
				//parsed with every change, so update to the canonical hex
				//string
				this.text = this.colorToString(this._color);
			}
			else
			{
				//the color value is not up to date, so parse the string
				this.color = this.stringToColor(this._text);
			}
			//we need to force invalidation just to be sure that the text input
			//is displaying the correct color value.
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected function hexColorInput_enterHandler(event:Event):void
		{
			this.commitChanges();
			this.selectRange(0, this._text.length);
		}

		/**
		 * @private
		 */
		protected function hexColorInput_focusOutHandler(event:Event):void
		{
			this.commitChanges();
		}
	}
}
