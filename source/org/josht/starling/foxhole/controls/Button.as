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
package org.josht.starling.foxhole.controls
{
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	
	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.core.IToggle;
	import org.josht.starling.foxhole.text.BitmapFontTextFormat;
	import org.josht.starling.text.BitmapFont;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.BitmapFont;
	
	public class Button extends FoxholeControl implements IToggle
	{
		protected static const STATE_UP:String = "up";
		protected static const STATE_DOWN:String = "down";
		protected static const STATE_DISABLED:String = "disabled";
		protected static const STATE_SELECTED_UP:String = "selectedUp";
		protected static const STATE_SELECTED_DOWN:String = "selectedDown";
		
		public static const ICON_POSITION_TOP:String = "top";
		public static const ICON_POSITION_RIGHT:String = "right";
		public static const ICON_POSITION_BOTTOM:String = "bottom";
		public static const ICON_POSITION_LEFT:String = "left";
		public static const ICON_POSITION_LEFT_BASELINE:String = "leftBaseline";
		public static const ICON_POSITION_RIGHT_BASELINE:String = "rightBaseline";
		
		public static const HORIZONTAL_ALIGN_LEFT:String = "left";
		public static const HORIZONTAL_ALIGN_CENTER:String = "center";
		public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
		
		public static const VERTICAL_ALIGN_TOP:String = "top";
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
		
		public function Button()
		{
			this.addEventListener(TouchEvent.TOUCH, touchHandler);
		}
		
		protected var labelField:Label;
		protected var currentSkin:DisplayObject;
		protected var currentIcon:DisplayObject;
		
		override public function set isEnabled(value:Boolean):void
		{
			if(super.isEnabled == value)
			{
				return;
			}
			super.isEnabled = value;
			if(!this.isEnabled)
			{
				this.touchable = false;
				this.currentState = STATE_DISABLED;
			}
			else
			{
				//might be in another state for some reason
				//let's only change to up if needed
				if(this.currentState == STATE_DISABLED)
				{
					this.currentState = STATE_UP;
				}
				this.touchable = true;
			}
		}
		
		protected var _currentState:String = STATE_UP;
		
		protected function get currentState():String
		{
			return _currentState;
		}
		
		protected function set currentState(value:String):void
		{
			if(this._isSelected && value.indexOf("selected") < 0)
			{
				value = "selected" + String.fromCharCode(value.substr(0, 1).charCodeAt(0) - 32) + value.substr(1);
			}
			else if(!this._isSelected && value.indexOf("selected") == 0)
			{
				value = String.fromCharCode(value.substr(8, 1).charCodeAt(0) + 32) + value.substr(9);
			}
			if(this._currentState == value)
			{
				return;
			}
			if(this.stateNames.indexOf(value) < 0)
			{
				throw new ArgumentError("Invalid state: " + value + ".");
			}
			this._currentState = value;
			this.invalidate(INVALIDATION_FLAG_STATE);
		}
		
		protected var _label:String = "";
		
		public function get label():String
		{
			return this._label;
		}
		
		public function set label(value:String):void
		{
			if(!value)
			{
				//don't allow null or undefined
				value = "";
			}
			if(this._label == value)
			{
				return;
			}
			this._label = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		private var _isToggle:Boolean = false;
		
		public function get isToggle():Boolean
		{
			return this._isToggle;
		}
		
		public function set isToggle(value:Boolean):void
		{
			this._isToggle = value;
		}
		
		private var _isSelected:Boolean = false;
		
		public function get isSelected():Boolean
		{
			return this._isSelected;
		}
		
		public function set isSelected(value:Boolean):void
		{
			this._isSelected = value;
			this.currentState = this.currentState;
			this.invalidate(INVALIDATION_FLAG_STATE, INVALIDATION_FLAG_SELECTED);
			this._onChange.dispatch(this);
		}
		
		private var _iconPosition:String = ICON_POSITION_LEFT;
		
		public function get iconPosition():String
		{
			return this._iconPosition;
		}
		
		public function set iconPosition(value:String):void
		{
			if(this._iconPosition == value)
			{
				return;
			}
			this._iconPosition = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		private var _gap:Number = 10;
		
		public function get gap():Number
		{
			return this._gap;
		}
		
		public function set gap(value:Number):void
		{
			if(this._gap == value)
			{
				return;
			}
			this._gap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		protected var _horizontalAlign:String = HORIZONTAL_ALIGN_CENTER;
		
		public function get horizontalAlign():String
		{
			return this._horizontalAlign;
		}
		
		public function set horizontalAlign(value:String):void
		{
			if(this._horizontalAlign == value)
			{
				return;
			}
			this._horizontalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		protected var _verticalAlign:String = VERTICAL_ALIGN_MIDDLE;
		
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		
		public function set verticalAlign(value:String):void
		{
			if(this._verticalAlign == value)
			{
				return;
			}
			this._verticalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		protected var _contentPadding:Number = 0;
		
		public function get contentPadding():Number
		{
			return _contentPadding;
		}
		
		public function set contentPadding(value:Number):void
		{
			if(this._contentPadding == value)
			{
				return;
			}
			this._contentPadding = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		public var keepDownStateOnRollOut:Boolean = false;
		
		protected function get stateNames():Vector.<String>
		{
			return Vector.<String>([STATE_UP, STATE_DOWN, STATE_DISABLED, STATE_SELECTED_UP, STATE_SELECTED_DOWN]);
		}
		
		protected var _defaultSkin:DisplayObject;
		
		public function get defaultSkin():DisplayObject
		{
			return this._defaultSkin;
		}
		
		public function set defaultSkin(value:DisplayObject):void
		{
			if(this._defaultSkin == value)
			{
				return;
			}
			
			if(this._defaultSkin && this._defaultSkin != this._defaultSelectedSkin &&
				this._defaultSkin != this._upSkin && this._defaultSkin != this._downSkin &&
				this._defaultSkin != this._selectedUpSkin && this._defaultSkin != this._selectedDownSkin &&
				this._defaultSkin != this._disabledSkin)
			{
				this.removeChild(this._defaultSkin);
			}
			this._defaultSkin = value;
			if(this._defaultSkin && this._defaultSkin.parent != this)
			{
				this._defaultSkin.visible = false;
				this.addChildAt(this._defaultSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		protected var _defaultSelectedSkin:DisplayObject;
		
		public function get defaultSelectedSkin():DisplayObject
		{
			return this._defaultSelectedSkin;
		}
		
		public function set defaultSelectedSkin(value:DisplayObject):void
		{
			if(this._defaultSelectedSkin == value)
			{
				return;
			}
			
			if(this._defaultSelectedSkin && this._defaultSelectedSkin != this._defaultSkin &&
				this._defaultSelectedSkin != this._upSkin && this._defaultSelectedSkin != this._downSkin &&
				this._defaultSelectedSkin != this._selectedUpSkin && this._defaultSelectedSkin != this._selectedDownSkin &&
				this._defaultSelectedSkin != this._disabledSkin)
			{
				this.removeChild(this._defaultSelectedSkin);
			}
			this._defaultSelectedSkin = value;
			if(this._defaultSelectedSkin && this._defaultSelectedSkin.parent != this)
			{
				this._defaultSelectedSkin.visible = false;
				this.addChildAt(this._defaultSelectedSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		protected var _upSkin:DisplayObject;
		
		public function get upSkin():DisplayObject
		{
			return this._upSkin;
		}
		
		public function set upSkin(value:DisplayObject):void
		{
			if(this._upSkin == value)
			{
				return;
			}
			
			if(this._upSkin && this._upSkin != this._defaultSkin && this._upSkin != this._defaultSelectedSkin &&
				this._upSkin != this._downSkin && this._upSkin != this._disabledSkin &&
				this._upSkin != this._selectedUpSkin && this._upSkin != this._selectedDownSkin)
			{
				this.removeChild(this._upSkin);
			}
			this._upSkin = value;
			if(this._upSkin && this._upSkin.parent != this)
			{
				this._upSkin.visible = false;
				this.addChildAt(this._upSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		protected var _downSkin:DisplayObject;
		
		public function get downSkin():DisplayObject
		{
			return this._downSkin;
		}
		
		public function set downSkin(value:DisplayObject):void
		{
			if(this._downSkin == value)
			{
				return;
			}
			
			if(this._downSkin && this._downSkin != this._defaultSkin && this._downSkin != this._defaultSelectedSkin &&
				this._downSkin != this._upSkin && this._downSkin != this._disabledSkin &&
				this._downSkin != this._selectedUpSkin && this._downSkin != this._selectedDownSkin)
			{
				this.removeChild(this._downSkin);
			}
			this._downSkin = value;
			if(this._downSkin && this._downSkin.parent != this)
			{
				this._downSkin.visible = false;
				this.addChildAt(this._downSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		protected var _disabledSkin:DisplayObject;
		
		public function get disabledSkin():DisplayObject
		{
			return this._disabledSkin;
		}
		
		public function set disabledSkin(value:DisplayObject):void
		{
			if(this._disabledSkin == value)
			{
				return;
			}
			
			if(this._disabledSkin && this._disabledSkin != this._defaultSkin && this._disabledSkin != this._defaultSelectedSkin &&
				this._disabledSkin != this._upSkin && this._disabledSkin != this._downSkin &&
				this._disabledSkin != this._selectedUpSkin && this._disabledSkin != this._selectedDownSkin)
			{
				this.removeChild(this._disabledSkin);
			}
			this._disabledSkin = value;
			if(this._disabledSkin && this._disabledSkin.parent != this)
			{
				this._disabledSkin.visible = false;
				this.addChildAt(this._disabledSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		protected var _selectedUpSkin:DisplayObject;
		
		public function get selectedUpSkin():DisplayObject
		{
			return this._selectedUpSkin;
		}
		
		public function set selectedUpSkin(value:DisplayObject):void
		{
			if(this._selectedUpSkin == value)
			{
				return;
			}
			
			if(this._selectedUpSkin && this._selectedUpSkin != this._defaultSkin && this._selectedUpSkin != this._defaultSelectedSkin &&
				this._selectedUpSkin != this._upSkin && this._selectedUpSkin != this._downSkin &&
				this._upSkin != this._disabledSkin && this._selectedUpSkin != this._selectedDownSkin)
			{
				this.removeChild(this._selectedUpSkin);
			}
			this._selectedUpSkin = value;
			if(this._selectedUpSkin && this._selectedUpSkin.parent != this)
			{
				this._selectedUpSkin.visible = false;
				this.addChildAt(this._selectedUpSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		protected var _selectedDownSkin:DisplayObject;
		
		public function get selectedDownSkin():DisplayObject
		{
			return this._selectedDownSkin;
		}
		
		public function set selectedDownSkin(value:DisplayObject):void
		{
			if(this._selectedDownSkin == value)
			{
				return;
			}
			
			if(this._selectedDownSkin && this._selectedDownSkin != this._defaultSkin && this._selectedDownSkin != this._defaultSelectedSkin &&
				this._selectedDownSkin != this._upSkin && this._selectedDownSkin != this._downSkin &&
				this._selectedDownSkin != this._disabledSkin && this._selectedDownSkin != this._selectedUpSkin)
			{
				this.removeChild(this._selectedDownSkin);
			}
			this._selectedDownSkin = value;
			if(this._selectedDownSkin && this._selectedDownSkin.parent != this)
			{
				this._selectedDownSkin.visible = false;
				this.addChildAt(this._selectedDownSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		protected var _defaultTextFormat:BitmapFontTextFormat;
		
		public function get defaultTextFormat():BitmapFontTextFormat
		{
			return this._defaultTextFormat;
		}
		
		public function set defaultTextFormat(value:BitmapFontTextFormat):void
		{
			this._defaultTextFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		protected var _upTextFormat:BitmapFontTextFormat;
		
		public function get upTextFormat():BitmapFontTextFormat
		{
			return this._upTextFormat;
		}
		
		public function set upTextFormat(value:BitmapFontTextFormat):void
		{
			this._upTextFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		protected var _downTextFormat:BitmapFontTextFormat;
		
		public function get downTextFormat():BitmapFontTextFormat
		{
			return this._downTextFormat;
		}
		
		public function set downTextFormat(value:BitmapFontTextFormat):void
		{
			this._downTextFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		protected var _disabledTextFormat:BitmapFontTextFormat;
		
		public function get disabledTextFormat():BitmapFontTextFormat
		{
			return this._disabledTextFormat;
		}
		
		public function set disabledTextFormat(value:BitmapFontTextFormat):void
		{
			this._disabledTextFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		protected var _defaultSelectedTextFormat:BitmapFontTextFormat;
		
		public function get defaultSelectedTextFormat():BitmapFontTextFormat
		{
			return this._defaultSelectedTextFormat;
		}
		
		public function set defaultSelectedTextFormat(value:BitmapFontTextFormat):void
		{
			this._defaultSelectedTextFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		protected var _selectedUpTextFormat:BitmapFontTextFormat;
		
		public function get selectedUpTextFormat():BitmapFontTextFormat
		{
			return this._selectedUpTextFormat;
		}
		
		public function set selectedUpTextFormat(value:BitmapFontTextFormat):void
		{
			this._selectedUpTextFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		protected var _selectedDownTextFormat:BitmapFontTextFormat;
		
		public function get selectedDownTextFormat():BitmapFontTextFormat
		{
			return this._selectedDownTextFormat;
		}
		
		public function set selectedDownTextFormat(value:BitmapFontTextFormat):void
		{
			this._selectedDownTextFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		private var _defaultIcon:DisplayObject;
		
		public function get defaultIcon():DisplayObject
		{
			return this._defaultIcon;
		}
		
		public function set defaultIcon(value:DisplayObject):void
		{
			if(this._defaultIcon == value)
			{
				return;
			}
			
			if(this._defaultIcon && this._defaultIcon != this._defaultSelectedIcon &&
				this._defaultIcon != this._upIcon && this._defaultIcon != this._downIcon &&
				this._defaultIcon != this._selectedUpIcon && this._defaultIcon != this._selectedDownIcon && 
				this._defaultIcon != this._disabledIcon)
			{
				this.removeChild(this._defaultIcon);
			}
			this._defaultIcon = value;
			if(this._defaultIcon && this._defaultIcon.parent != this)
			{
				this._defaultIcon.visible = false;
				this.addChild(this._defaultIcon);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		private var _defaultSelectedIcon:DisplayObject;
		
		public function get defaultSelectedIcon():DisplayObject
		{
			return this._defaultSelectedIcon;
		}
		
		public function set defaultSelectedIcon(value:DisplayObject):void
		{
			if(this._defaultSelectedIcon == value)
			{
				return;
			}
			
			if(this._defaultSelectedIcon && this._defaultSelectedIcon != this._defaultIcon &&
				this._defaultSelectedIcon != this._upIcon && this._defaultSelectedIcon != this._downIcon &&
				this._defaultSelectedIcon != this._selectedUpIcon  && this._defaultSelectedIcon != this._selectedDownIcon &&
				this._defaultIcon != this._disabledIcon)
			{
				this.removeChild(this._defaultSelectedIcon);
			}
			this._defaultSelectedIcon = value;
			if(this._defaultSelectedIcon && this._defaultSelectedIcon.parent != this)
			{
				this._defaultSelectedIcon.visible = false;
				this.addChild(this._defaultSelectedIcon);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		private var _upIcon:DisplayObject;
		
		public function get upIcon():DisplayObject
		{
			return this._upIcon;
		}
		
		public function set upIcon(value:DisplayObject):void
		{
			if(this._upIcon == value)
			{
				return;
			}
			
			if(this._upIcon && this._upIcon != this._defaultIcon && this._upIcon != this._defaultSelectedIcon &&
				this._upIcon != this._downIcon && this._upIcon != this._disabledIcon &&
				this._upIcon != this._selectedUpIcon && this._upIcon != this._selectedDownIcon)
			{
				this.removeChild(this._upIcon);
			}
			this._upIcon = value;
			if(this._upIcon && this._upIcon.parent != this)
			{
				this._upIcon.visible = false;
				this.addChild(this._upIcon);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		private var _downIcon:DisplayObject;
		
		public function get downIcon():DisplayObject
		{
			return this._downIcon;
		}
		
		public function set downIcon(value:DisplayObject):void
		{
			if(this._downIcon == value)
			{
				return;
			}
			
			if(this._downIcon && this._downIcon != this._defaultIcon && this._downIcon != this._defaultSelectedIcon &&
				this._downIcon != this._upIcon && this._downIcon != this._disabledIcon &&
				this._downIcon != this._selectedUpIcon && this._downIcon != this._selectedDownIcon)
			{
				this.removeChild(this._downIcon);
			}
			this._downIcon = value;
			if(this._downIcon && this._downIcon.parent != this)
			{
				this._downIcon.visible = false;
				this.addChild(this._downIcon);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		private var _disabledIcon:DisplayObject;
		
		public function get disabledIcon():DisplayObject
		{
			return this._disabledIcon;
		}
		
		public function set disabledIcon(value:DisplayObject):void
		{
			if(this._disabledIcon == value)
			{
				return;
			}
			
			if(this._disabledIcon && this._disabledIcon != this._upIcon && this._disabledIcon != this._downIcon)
			{
				this.removeChild(this._disabledIcon);
			}
			this._disabledIcon = value;
			if(this._disabledIcon && this._disabledIcon.parent != this)
			{
				this._disabledIcon.visible = false;
				this.addChild(this._disabledIcon);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		private var _selectedUpIcon:DisplayObject;
		
		public function get selectedUpIcon():DisplayObject
		{
			return this._selectedUpIcon;
		}
		
		public function set selectedUpIcon(value:DisplayObject):void
		{
			if(this._selectedUpIcon == value)
			{
				return;
			}
			
			if(this._selectedUpIcon && this._selectedUpIcon != this._defaultIcon && this._selectedUpIcon != this._defaultSelectedIcon &&
				this._selectedUpIcon != this._upIcon && this._selectedUpIcon != this._downIcon &&
				this._selectedUpIcon != this._selectedDownIcon && this._selectedUpIcon != this._disabledIcon)
			{
				this.removeChild(this._selectedUpIcon);
			}
			this._selectedUpIcon = value;
			if(this._selectedUpIcon && this._selectedUpIcon.parent != this)
			{
				this._selectedUpIcon.visible = false;
				this.addChild(this._selectedUpIcon);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		private var _selectedDownIcon:DisplayObject;
		
		public function get selectedDownIcon():DisplayObject
		{
			return this._selectedDownIcon;
		}
		
		public function set selectedDownIcon(value:DisplayObject):void
		{
			if(this._selectedDownIcon == value)
			{
				return;
			}
			
			if(this._selectedDownIcon && this._selectedDownIcon != this._defaultIcon && this._selectedDownIcon != this._defaultSelectedIcon &&
				this._selectedDownIcon != this._upIcon && this._selectedDownIcon != this._downIcon &&
				this._selectedDownIcon != this._selectedUpIcon && this._selectedDownIcon != this._disabledIcon)
			{
				this.removeChild(this._selectedDownIcon);
			}
			this._selectedDownIcon = value;
			if(this._selectedDownIcon && this._selectedDownIcon.parent != this)
			{
				this._selectedDownIcon.visible = false;
				this.addChild(this._selectedDownIcon);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		private var _autoFlatten:Boolean = true;

		public function get autoFlatten():Boolean
		{
			return this._autoFlatten;
		}

		public function set autoFlatten(value:Boolean):void
		{
			if(this._autoFlatten == value)
			{
				return;
			}
			this._autoFlatten = value;
			this.unflatten();
			if(this._autoFlatten)
			{
				this.flatten();
			}
		}

		protected var _onPress:Signal = new Signal(Button);
		
		public function get onPress():ISignal
		{
			return this._onPress;
		}
		
		protected var _onRelease:Signal = new Signal(Button);
		
		public function get onRelease():ISignal
		{
			return this._onRelease;
		}
		
		private var _onChange:Signal = new Signal(Button);
		
		public function get onChange():ISignal
		{
			return this._onChange;
		}
		
		override public function dispose():void
		{
			this._onPress.removeAll();
			this._onRelease.removeAll();
			this._onChange.removeAll();
			super.dispose();
		}
		
		override protected function initialize():void
		{
			if(!this.labelField)
			{
				this.labelField = new Label();
				this.addChild(this.labelField);
			}
		}
		
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			
			if(dataInvalid)
			{
				this.labelField.text = this._label;
				this.labelField.visible = this._label != null;
			}
			
			if(stylesInvalid || stateInvalid || isNaN(this._width) || isNaN(this._height))
			{
				if(this.refreshSkin())
				{
					sizeInvalid = true;
				}
				this.refreshIcon();
				this.refreshLabelStyles();
				this.labelField.validate();
				if(isNaN(this._width))
				{
					if(this.currentIcon && this.label)
					{
						this._width = this.currentIcon.width + this.gap + this.labelField.width;
					}
					else if(this.currentIcon)
					{
						this._width = this.currentIcon.width;
					}
					else if(this.labelField)
					{
						this._width = this.labelField.width;
					}
					sizeInvalid = true;
				}
				
				if(isNaN(this._height))
				{
					if(this.currentIcon && this.label)
					{
						this._height = Math.max(this.currentIcon.height, this.labelField.height);
					}
					else if(this.currentIcon)
					{
						this._height = this.currentIcon.height;
					}
					else if(this.labelField)
					{
						this._height = this.labelField.height;
					}
					sizeInvalid = true;
				}
			}
			
			if(stylesInvalid || stateInvalid || sizeInvalid)
			{
				this.scaleSkin();
			}
			
			if(stylesInvalid || stateInvalid || dataInvalid || sizeInvalid)
			{
				if(this.currentSkin is FoxholeControl)
				{
					FoxholeControl(this.currentSkin).validate();
				}
				if(this.currentIcon is FoxholeControl)
				{
					FoxholeControl(this.currentIcon).validate();
				}
				this.labelField.validate();
				this.layoutContent();
			}
			
			if(this._autoFlatten)
			{
				this.unflatten();
				this.flatten();
			}
		}
		
		protected function refreshSkin():Boolean
		{	
			this.currentSkin = null;
			if(this._currentState == STATE_UP)
			{
				this.currentSkin = this._upSkin;
			}
			else if(this._upSkin)
			{
				this._upSkin.visible = false;
			}
			
			if(this._currentState == STATE_DOWN)
			{
				this.currentSkin = this._downSkin;
			}
			else if(this._downSkin)
			{
				this._downSkin.visible = false;
			}
			
			if(this._currentState == STATE_DISABLED)
			{
				this.currentSkin = this._disabledSkin;
			}
			else if(this._disabledSkin)
			{
				this._disabledSkin.visible = false;
			}
			
			if(this._currentState == STATE_SELECTED_UP)
			{
				this.currentSkin = this._selectedUpSkin;
			}
			else if(this._selectedUpSkin)
			{
				this._selectedUpSkin.visible = false;
			}
			
			if(this._currentState == STATE_SELECTED_DOWN)
			{
				this.currentSkin = this._selectedDownSkin;
			}
			else if(this._selectedDownSkin)
			{
				this._selectedDownSkin.visible = false;
			}
			
			if(!this.currentSkin)
			{
				if(this._isSelected)
				{
					this.currentSkin = this._defaultSelectedSkin;
				}
				else if(this._defaultSelectedSkin)
				{
					this._defaultSelectedSkin.visible = false;
				}
				if(!this.currentSkin)
				{
					this.currentSkin = this._defaultSkin;
				}
				else if(this._defaultSkin)
				{
					this._defaultSkin.visible = false;
				}
			}
			else
			{
				if(this._defaultSkin)
				{
					this._defaultSkin.visible = false;
				}
				if(this._defaultSelectedSkin)
				{
					this._defaultSelectedSkin.visible = false;
				}
			}
			
			var resized:Boolean = false;
			if(this.currentSkin)
			{
				this.currentSkin.visible = true;
				
				//set default width and height values if nothing was passed in
				if(isNaN(this._width))
				{
					this._width = this.currentSkin.width;
					resized = true;
				}
				if(isNaN(this._height))
				{
					this._height = this.currentSkin.height;
					resized = true;
				}
			}
			else
			{
				trace("No skin defined for state \"" + this._currentState + "\" and there is no default value.");
			}
			return resized;
		}
		
		protected function refreshIcon():void
		{
			if(this._currentState == STATE_UP)
			{
				this.currentIcon = this._upIcon;
			}
			else if(this._upIcon)
			{
				this._upIcon.visible = false;
			}
			
			if(this._currentState == STATE_DOWN)
			{
				this.currentIcon = this._downIcon;
			}
			else if(this._downIcon)
			{
				this._downIcon.visible = false;
			}
			
			if(this._currentState == STATE_DISABLED)
			{
				this.currentIcon = this._disabledIcon;
			}
			else if(this._disabledIcon)
			{
				this._disabledIcon.visible = false;
			}
			
			if(this._currentState == STATE_SELECTED_UP)
			{
				this.currentIcon = this._selectedUpIcon;
			}
			else if(this._selectedUpIcon)
			{
				this._selectedUpIcon.visible = false;
			}
			
			if(this._currentState == STATE_SELECTED_DOWN)
			{
				this.currentIcon = this._selectedDownIcon;
			}
			else if(this._selectedDownIcon)
			{
				this._selectedDownIcon.visible = false;
			}
			
			if(!this.currentIcon)
			{
				if(this._isSelected)
				{
					this.currentIcon = this._defaultSelectedIcon;
				}
				else if(this._defaultSelectedIcon)
				{
					this._defaultSelectedIcon.visible = false;
				}
				if(!this.currentIcon)
				{
					this.currentIcon = this._defaultIcon;
				}
				else if(this._defaultIcon)
				{
					this._defaultIcon.visible = false;
				}
			}
			else
			{
				if(this._defaultIcon)
				{
					this._defaultIcon.visible = false;
				}
				if(this._defaultSelectedIcon)
				{
					this._defaultSelectedIcon.visible = false;
				}
			}
			
			if(this.currentIcon)
			{
				this.currentIcon.visible = true;
			}
		}
		
		protected function refreshLabelStyles():void
		{	
			var format:BitmapFontTextFormat;
			if(this._currentState == STATE_UP)
			{
				format = this._upTextFormat;
			}
			else if(this._currentState == STATE_DOWN)
			{
				format = this._downTextFormat;
			}
			else if(this._currentState == STATE_DISABLED)
			{
				format = this._disabledTextFormat;
			}
			else if(this._currentState == STATE_SELECTED_UP)
			{
				format = this._selectedUpTextFormat;
			}
			else if(this._currentState == STATE_SELECTED_DOWN)
			{
				format = this._selectedDownTextFormat;
			}
			if(!format)
			{
				if(this._isSelected)
				{
					format = this._defaultSelectedTextFormat;
				}
				if(!format)
				{
					format = this._defaultTextFormat;
				}
			}
			
			if(!format && this._label)
			{
				throw new IllegalOperationError("No text format defined for state \"" + this._currentState + "\" and there is no default value.");
			}
			this.labelField.textFormat = format;
		}
		
		protected function scaleSkin():void
		{
			if(!this.currentSkin)
			{
				return;
			}
			if(this.currentSkin.width != this._width)
			{
				this.currentSkin.width = this._width;
			}
			if(this.currentSkin.height != this._height)
			{
				this.currentSkin.height = this._height;
			}
		}
		
		protected function layoutContent():void
		{
			if(this.label && this.currentIcon)
			{
				this.positionLabelOrIcon(this.labelField);
				this.positionLabelAndIcon();
			}
			else if(this.label && !this.currentIcon)
			{
				this.positionLabelOrIcon(this.labelField);
			}
			else if(!this.label && this.currentIcon)
			{
				this.positionLabelOrIcon(this.currentIcon)
			}
		}
		
		protected function positionLabelOrIcon(displayObject:DisplayObject):void
		{
			if(this._horizontalAlign == HORIZONTAL_ALIGN_LEFT)
			{
				displayObject.x = this._contentPadding;
			}
			else if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
			{
				displayObject.x = this._width - this._contentPadding - displayObject.width;
			}
			else //center
			{
				displayObject.x = (this._width - displayObject.width) / 2;
			}
			if(this._verticalAlign == VERTICAL_ALIGN_TOP)
			{
				displayObject.y = this._contentPadding;
			}
			else if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
			{
				displayObject.y = this._height - this._contentPadding - displayObject.height;
			}
			else //middle
			{
				displayObject.y = (this._height - displayObject.height) / 2;
			}
		}
		
		private function positionLabelAndIcon():void
		{
			if(this._iconPosition == ICON_POSITION_TOP)
			{
				this.currentIcon.y = this.labelField.y;
				this.labelField.y = this.currentIcon.y + this.currentIcon.height + this._gap;
			}
			else if(this._iconPosition == ICON_POSITION_RIGHT || this._iconPosition == ICON_POSITION_RIGHT_BASELINE)
			{
				if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
				{
					this.labelField.x -= this.currentIcon.width + this._gap;
				}
				else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
				{
					this.labelField.x -= (this.currentIcon.width + this._gap) / 2;
				}
				this.currentIcon.x = this.labelField.x + this.labelField.width + this._gap;
			}
			else if(this._iconPosition == ICON_POSITION_BOTTOM)
			{
				if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
				{
					this.labelField.y -= this.currentIcon.height + this._gap;
				}
				else if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
				{
					this.labelField.y -= (this.currentIcon.height + this._gap) / 2;
				}
				this.currentIcon.y = this.labelField.y + this.labelField.height + this._gap;
			}
			else if(this._iconPosition == ICON_POSITION_LEFT || this._iconPosition == ICON_POSITION_LEFT_BASELINE)
			{
				if(this._horizontalAlign == HORIZONTAL_ALIGN_LEFT)
				{
					this.labelField.x += this._gap + this.currentIcon.width;
				}
				else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
				{
					this.labelField.x += (this._gap + this.currentIcon.width) / 2;
				}
				this.currentIcon.x = this.labelField.x - this._gap - this.currentIcon.width;
			}
			
			if(this._iconPosition == ICON_POSITION_LEFT || this._iconPosition == ICON_POSITION_RIGHT)
			{
				this.currentIcon.y = this.labelField.y + this.labelField.height - this.currentIcon.height;
			}
			else if(this._iconPosition == ICON_POSITION_LEFT_BASELINE || this._iconPosition == ICON_POSITION_RIGHT_BASELINE)
			{
				const font:starling.text.BitmapFont = this.labelField.textFormat.font;
				const formatSize:Number = this.labelField.textFormat.size;
				const baseline:Number = (font is org.josht.starling.text.BitmapFont) ? org.josht.starling.text.BitmapFont(font).base : font.lineHeight;
				const fontSizeScale:Number = isNaN(formatSize) ? 1 : (formatSize / font.size);
				this.currentIcon.y = this.labelField.y + fontSizeScale * baseline - this.currentIcon.height;
			}
			else
			{
				this.currentIcon.x = this.labelField.x + (this.labelField.width - this.currentIcon.width) / 2;
			}
		}
		
		private function touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				return;
			}
			const touch:Touch = event.getTouch(this);
			if(!touch)
			{
				return;
			}
			const location:Point = touch.getLocation(this);
			const isInBounds:Boolean = location.x >= 0 && location.y >= 0 && 
				location.x < this._width && location.y < this._height;
			if(touch.phase == TouchPhase.BEGAN)
			{
				this.currentState = STATE_DOWN;
				this._onPress.dispatch(this);
			}
			else if(touch.phase == TouchPhase.MOVED)
			{
				if(isInBounds || this.keepDownStateOnRollOut)
				{
					this.currentState = STATE_DOWN;
				}
				else
				{
					this.currentState = STATE_UP;
				}
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				this.currentState = STATE_UP;
				if(isInBounds)
				{
					this.onRelease.dispatch(this);
					if(this._isToggle)
					{
						this.isSelected = !this._isSelected;
					}
				}
			}
		}
	}
}