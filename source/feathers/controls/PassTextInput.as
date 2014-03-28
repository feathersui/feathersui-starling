package com.gazeus.poker.ipad.views.login.ui
{
	import feathers.controls.TextInput;

	import starling.events.Event;

	/**
	 *
	 * Text field that inherits the traditional TextInput but contains rules to hide characters long with the possibility of adding automatic placeholder.
	 *
	 * @author Victor Carvalho Tavernari
	 *
	 */
	public class PassTextInput extends TextInput
	{
		private static const TIME_TO_SHOW_PLACEHOLDER:int = 1000;

		private const arrText:Array = [];
		private var _currPassText:String = "";
		private var _placeHolder:String;

		public function PassTextInput()
		{
			super();
			this.addEventListener( Event.CHANGE, onChangeHandler );
		}

		/**
		 *Set textfield's placeholder
		 * @param value String
		 *
		 */
		public function setDefaultPlaceHolder(value:String):void
		{
			_placeHolder = value;
			this.removeEventListener( Event.CHANGE, onChangeHandler );
			super.text = _placeHolder;
		}

		private function onChangeHandler(e:Event):void
		{
			this.removeEventListener( Event.CHANGE, onChangeHandler );

			if(super.text.length == 0)
			{
				arrText.length = 0;
			}else
			{
				var i:int = 0;
				var total:int = super.text.length;

				var placePassHidden:String = "";

				for(i ; i < total; ++i)
				{
					var char:String = super.text.charAt(i);

					if(char != "*")
					{
						arrText[i] = char;
					}

					placePassHidden += "*"
				}

				if(arrText.length > super.text.length)
				{
					arrText.slice(0,total);
				}

				super.text = placePassHidden;
			}

			_currPassText = arrText.join("");

			this.addEventListener( Event.CHANGE, onChangeHandler );
		}

		/**
		 *
		 * @param value
		 *
		 */
		override public function set text(value:String):void
		{
			var valueToChange:String = value;

			if(super.text == _placeHolder && value != _placeHolder)
			{
				if(this.hasEventListener(Event.CHANGE))
				{
					this.removeEventListener( Event.CHANGE, onChangeHandler );
				}

				super.text = "";
				arrText.length = 0;

				if(value == "")
				{
					return;
				}else if(valueToChange.indexOf(_placeHolder) != -1)
				{
					valueToChange = valueToChange.replace(_placeHolder, "");
					this.addEventListener( Event.CHANGE, onChangeHandler );
				}
			}else if(value.length == 0)
			{
				if(this.hasEventListener(Event.CHANGE))
				{
					this.removeEventListener( Event.CHANGE, onChangeHandler );
				}

				if(arrText.length > 0)
				{
					super.text = _placeHolder;
				}

				arrText.length = 0;
				return;

			}else if(this.hasEventListener(Event.CHANGE) == false)
			{
				this.addEventListener( Event.CHANGE, onChangeHandler );
			}

			super.text = valueToChange;
		}

		override public function get text():String
		{
			return _currPassText
		}
	}
}