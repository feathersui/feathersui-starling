package feathers.text
{
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;

	/**
	 * A StageText replacement for Flash Player with matching properties, since
	 * StageText is only available in AIR.
	 */
	public class StageTextField extends EventDispatcher
	{
		/**
		 * Constructor.
		 */
		public function StageTextField(initOptions:Object = null)
		{
			this.initialize(initOptions);
		}

		protected var textField:TextField;
		protected var textFormat:TextFormat;
		protected var isComplete:Boolean = false;

		private var _autoCapitalize:String = "none";

		public function get autoCapitalize():String
		{
			return this._autoCapitalize;
		}

		public function set autoCapitalize(value:String):void
		{
			this._autoCapitalize = value;
		}

		private var _autoCorrect:Boolean = false;

		public function get autoCorrect():Boolean
		{
			return this._autoCorrect;
		}

		public function set autoCorrect(value:Boolean):void
		{
			this._autoCorrect = value;
		}

		private var _color:uint = 0x000000;

		public function get color():uint
		{
			return this.textFormat.color as uint;
		}

		public function set color(value:uint):void
		{
			if(this.textFormat.color == value)
			{
				return;
			}
			this.textFormat.color = value;
			this.textField.defaultTextFormat = this.textFormat;
			this.textField.setTextFormat(this.textFormat);
		}

		public function get displayAsPassword():Boolean
		{
			return this.textField.displayAsPassword;
		}

		public function set displayAsPassword(value:Boolean):void
		{
			this.textField.displayAsPassword = value;
		}

		public function get editable():Boolean
		{
			return this.textField.type == TextFieldType.INPUT;
		}

		public function set editable(value:Boolean):void
		{
			this.textField.type = value ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
		}

		private var _fontFamily:String = null;

		public function get fontFamily():String
		{
			return this.textFormat.font;
		}

		public function set fontFamily(value:String):void
		{
			if(this.textFormat.font == value)
			{
				return;
			}
			this.textFormat.font = value;
			this.textField.defaultTextFormat = this.textFormat;
			this.textField.setTextFormat(this.textFormat);
		}

		public function get fontPosture():String
		{
			return this.textFormat.italic ? FontPosture.ITALIC : FontPosture.NORMAL;
		}

		public function set fontPosture(value:String):void
		{
			if(this.fontPosture == value)
			{
				return;
			}
			this.textFormat.italic = value == FontPosture.ITALIC;
			this.textField.defaultTextFormat = this.textFormat;
			this.textField.setTextFormat(this.textFormat);
		}

		public function get fontSize():int
		{
			return this.textFormat.size as int;
		}

		public function set fontSize(value:int):void
		{
			if(this.textFormat.size == value)
			{
				return;
			}
			this.textFormat.size = value;
			this.textField.defaultTextFormat = this.textFormat;
			this.textField.setTextFormat(this.textFormat);
		}

		public function get fontWeight():String
		{
			return this.textFormat.bold ? FontWeight.BOLD : FontWeight.NORMAL;
		}

		public function set fontWeight(value:String):void
		{
			if(this.fontWeight == value)
			{
				return;
			}
			this.textFormat.bold = value == FontWeight.BOLD;
			this.textField.defaultTextFormat = this.textFormat;
			this.textField.setTextFormat(this.textFormat);
		}

		private var _locale:String = "en";

		public function get locale():String
		{
			return this._locale;
		}

		public function set locale(value:String):void
		{
			this._locale = value;
		}

		public function get maxChars():int
		{
			return this.textField.maxChars;
		}

		public function set maxChars(value:int):void
		{
			this.textField.maxChars = value;
		}

		private function get multiline():Boolean
		{
			return this.textField.multiline;
		}

		public function get restrict():String
		{
			return this.textField.restrict;
		}

		public function set restrict(value:String):void
		{
			this.textField.restrict = value;
		}

		private var _returnKeyLabel:String = "default";

		public function get returnKeyLabel():String
		{
			return this._returnKeyLabel;
		}

		public function set returnKeyLabel(value:String):void
		{
			this._returnKeyLabel = value;
		}

		public function get selectionActiveIndex():int
		{
			return this.textField.selectionBeginIndex;
		}

		public function get selectionAnchorIndex():int
		{
			return this.textField.selectionEndIndex;
		}

		private var _softKeyboardType:String = "default";

		public function get softKeyboardType():String
		{
			return this._softKeyboardType;
		}

		public function set softKeyboardType(value:String):void
		{
			this._softKeyboardType = value;
		}

		public function get stage():Stage
		{
			return this.textField.stage;
		}

		public function set stage(value:Stage):void
		{
			if(this.textField.stage == value)
			{
				return;
			}
			if(this.textField.stage)
			{
				this.textField.parent.removeChild(this.textField);
			}
			if(value)
			{
				value.addChild(this.textField);
				this.dispatchCompleteIfPossible();
			}
		}

		public function get text():String
		{
			return this.textField.text;
		}

		public function set text(value:String):void
		{
			this.textField.text = value;
		}

		private var _textAlign:String = TextFormatAlign.START;

		public function get textAlign():String
		{
			return this._textAlign;
		}

		public function set textAlign(value:String):void
		{
			if(this._textAlign == value)
			{
				return;
			}
			this._textAlign = value;
			if(value == TextFormatAlign.START)
			{
				value = TextFormatAlign.LEFT;
			}
			else if(value == TextFormatAlign.END)
			{
				value = TextFormatAlign.RIGHT;
			}
			this.textFormat.align = value;
			this.textField.defaultTextFormat = this.textFormat;
			this.textField.setTextFormat(this.textFormat);
		}

		private var _viewPort:Rectangle = new Rectangle();

		public function get viewPort():Rectangle
		{
			return this._viewPort;
		}

		public function set viewPort(value:Rectangle):void
		{
			if(!value || value.width < 0 || value.height < 0)
			{
				throw new RangeError("The Rectangle value is not valid.");
			}
			this._viewPort = value;
			this.textField.x = this._viewPort.x;
			this.textField.y = this._viewPort.y;
			this.textField.width = this._viewPort.width;
			this.textField.height = this._viewPort.height;

			this.dispatchCompleteIfPossible();
		}

		public function get visible():Boolean
		{
			return this.textField.visible;
		}

		public function set visible(value:Boolean):void
		{
			this.textField.visible = value;
		}

		public function assignFocus():void
		{
			if(!this.textField.parent)
			{
				return;
			}
			this.textField.stage.focus = this.textField;
		}

		public function dispose():void
		{
			this.stage = null;
			this.textField = null;
			this.textFormat = null;
		}

		public function drawViewPortToBitmapData(bitmap:BitmapData):void
		{
			if(!bitmap)
			{
				throw new Error("The bitmap is null.");
			}
			if(bitmap.width != this._viewPort.width || bitmap.height != this._viewPort.height)
			{
				throw new ArgumentError("The bitmap's width or height is different from view port's width or height.");
			}
			bitmap.draw(this.textField);
		}

		public function selectRange(anchorIndex:int, activeIndex:int):void
		{
			this.textField.setSelection(anchorIndex, activeIndex);
		}

		protected function dispatchCompleteIfPossible():void
		{
			if(!this.textField.stage || this._viewPort.isEmpty())
			{
				this.isComplete = false;
			}
			if(this.textField.stage && !this.viewPort.isEmpty())
			{
				this.isComplete = true;
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}

		protected function initialize(initOptions:Object):void
		{
			this.textField = new TextField();
			this.textField.type = TextFieldType.INPUT;
			this.textField.multiline = initOptions && initOptions.hasOwnProperty("multiline") && initOptions.multiline;
			this.textField.addEventListener(Event.CHANGE, textField_eventHandler);
			this.textField.addEventListener(FocusEvent.FOCUS_IN, textField_eventHandler);
			this.textField.addEventListener(FocusEvent.FOCUS_OUT, textField_eventHandler);
			this.textField.addEventListener(KeyboardEvent.KEY_DOWN, textField_eventHandler);
			this.textField.addEventListener(KeyboardEvent.KEY_UP, textField_eventHandler);
			this.textFormat = new TextFormat(null, 11, 0x000000, false, false, false);
			this.textField.defaultTextFormat = this.textFormat;
		}

		protected function textField_eventHandler(event:Event):void
		{
			this.dispatchEvent(event);
		}
	}
}
