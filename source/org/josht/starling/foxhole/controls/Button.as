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
	import flash.geom.Point;
	
	import org.josht.starling.display.ScrollRectManager;
	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.core.IToggle;
	import org.josht.starling.foxhole.text.BitmapFontTextFormat;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.BitmapFont;

	/**
	 * A push (or optionally, toggle) button control.
	 */
	public class Button extends FoxholeControl implements IToggle
	{
		/**
		 * @private
		 */
		private static const helperPoint:Point = new Point();
		
		/**
		 * @private
		 */
		protected static const STATE_UP:String = "up";
		
		/**
		 * @private
		 */
		protected static const STATE_DOWN:String = "down";
		
		/**
		 * @private
		 */
		protected static const STATE_DISABLED:String = "disabled";
		
		/**
		 * @private
		 */
		protected static const STATE_SELECTED_UP:String = "selectedUp";
		
		/**
		 * @private
		 */
		protected static const STATE_SELECTED_DOWN:String = "selectedDown";
		
		/**
		 * The icon will be positioned above the label.
		 */
		public static const ICON_POSITION_TOP:String = "top";
		
		/**
		 * The icon will be positioned to the right of the label.
		 */
		public static const ICON_POSITION_RIGHT:String = "right";
		
		/**
		 * The icon will be positioned below the label.
		 */
		public static const ICON_POSITION_BOTTOM:String = "bottom";
		
		/**
		 * The icon will be positioned to the left of the label.
		 */
		public static const ICON_POSITION_LEFT:String = "left";
		
		/**
		 * The icon will be positioned to the left the label, and the bottom of
		 * the icon will be aligned to the baseline of the label text.
		 */
		public static const ICON_POSITION_LEFT_BASELINE:String = "leftBaseline";
		
		/**
		 * The icon will be positioned to the right the label, and the bottom of
		 * the icon will be aligned to the baseline of the label text.
		 */
		public static const ICON_POSITION_RIGHT_BASELINE:String = "rightBaseline";
		
		/**
		 * The icon and label will be aligned horizontally to the left edge of the button.
		 */
		public static const HORIZONTAL_ALIGN_LEFT:String = "left";
		
		/**
		 * The icon and label will be aligned horizontally to the center of the button.
		 */
		public static const HORIZONTAL_ALIGN_CENTER:String = "center";
		
		/**
		 * The icon and label will be aligned horizontally to the right edge of the button.
		 */
		public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
		
		/**
		 * The icon and label will be aligned vertically to the top edge of the button.
		 */
		public static const VERTICAL_ALIGN_TOP:String = "top";
		
		/**
		 * The icon and label will be aligned vertically to the middle of the button.
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
		
		/**
		 * The icon and label will be aligned vertically to the bottom edge of the button.
		 */
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
		
		/**
		 * Constructor.
		 */
		public function Button()
		{
			this.isQuickHitAreaEnabled = true;
			this.addEventListener(TouchEvent.TOUCH, touchHandler);
		}

		/**
		 * The value added to the <code>nameList</code> of the label.
		 */
		protected var defaultLabelName:String = "foxhole-button-label";
		
		/**
		 * @private
		 */
		protected var labelControl:Label;
		
		/**
		 * @private
		 */
		protected var currentSkin:DisplayObject;
		
		/**
		 * @private
		 */
		protected var currentIcon:DisplayObject;
		
		/**
		 * @private
		 */
		protected var _touchPointID:int = -1;
		
		/**
		 * @inheritDoc
		 */
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
		
		/**
		 * @private
		 */
		protected var _currentState:String = STATE_UP;
		
		/**
		 * @private
		 */
		protected function get currentState():String
		{
			return _currentState;
		}
		
		/**
		 * @private
		 */
		protected function set currentState(value:String):void
		{
			if(this._isEnabled && this._isSelected && value.indexOf("selected") < 0)
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
		
		/**
		 * @private
		 */
		protected var _label:String = "";
		
		/**
		 * The text displayed on the button.
		 */
		public function get label():String
		{
			return this._label;
		}
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		private var _isToggle:Boolean = false;
		
		/**
		 * Determines if the button may be selected or unselected when clicked.
		 */
		public function get isToggle():Boolean
		{
			return this._isToggle;
		}
		
		/**
		 * @private
		 */
		public function set isToggle(value:Boolean):void
		{
			this._isToggle = value;
		}
		
		/**
		 * @private
		 */
		private var _isSelected:Boolean = false;
		
		/**
		 * Indicates if the button is selected or not. The button may be
		 * selected programmatically, even if <code>isToggle</code> is false.
		 * 
		 * @see #isToggle
		 */
		public function get isSelected():Boolean
		{
			return this._isSelected;
		}
		
		/**
		 * @private
		 */
		public function set isSelected(value:Boolean):void
		{
			if(this._isSelected == value)
			{
				return;
			}
			this._isSelected = value;
			this.currentState = this.currentState;
			this.invalidate(INVALIDATION_FLAG_STATE, INVALIDATION_FLAG_SELECTED);
			this._onChange.dispatch(this);
		}
		
		/**
		 * @private
		 */
		private var _iconPosition:String = ICON_POSITION_LEFT;
		
		/**
		 * The location of the icon, relative to the label.
		 */
		public function get iconPosition():String
		{
			return this._iconPosition;
		}
		
		/**
		 * @private
		 */
		public function set iconPosition(value:String):void
		{
			if(this._iconPosition == value)
			{
				return;
			}
			this._iconPosition = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		private var _gap:Number = 10;
		
		/**
		 * The space, in pixels, between the icon and the label. Applies to
		 * either horizontal or vertical spacing, depending on the value of
		 * <code>iconPosition</code>.
		 * 
		 * <p>If <code>gap</code> is set to <code>Number.POSITIVE_INFINITY</code>,
		 * the label and icon will be positioned as far apart as possible. In
		 * other words, they will be positioned at the edges of the button,
		 * adjusted for padding.</p>
		 * 
		 * @see #iconPosition
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
		protected var _horizontalAlign:String = HORIZONTAL_ALIGN_CENTER;
		
		/**
		 * The location where the button's content is aligned horizontally (on
		 * the x-axis).
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
			if(this._horizontalAlign == value)
			{
				return;
			}
			this._horizontalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		protected var _verticalAlign:String = VERTICAL_ALIGN_MIDDLE;
		
		/**
		 * The location where the button's content is aligned vertically (on
		 * the y-axis).
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
			if(this._verticalAlign == value)
			{
				return;
			}
			this._verticalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingTop:Number = 0;

		/**
		 * The minimum space, in pixels, between the button's top edge and the
		 * button's content.
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
		 * The minimum space, in pixels, between the button's right edge and the
		 * button's content.
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
		 * The minimum space, in pixels, between the button's bottom edge and
		 * the button's content.
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
		 * The minimum space, in pixels, between the button's left edge and the
		 * button's content.
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
		 * Determines if a pressed button should remain in the down state if a
		 * touch moves outside of the button's bounds. Useful for controls like
		 * <code>Slider</code> and <code>ToggleSwitch</code> to keep a thumb in
		 * the down state while it is dragged around.
		 */
		public var keepDownStateOnRollOut:Boolean = false;
		
		/**
		 * @private
		 */
		protected function get stateNames():Vector.<String>
		{
			return Vector.<String>([STATE_UP, STATE_DOWN, STATE_DISABLED, STATE_SELECTED_UP, STATE_SELECTED_DOWN]);
		}

		/**
		 * @private
		 */
		protected var _originalSkinWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var _originalSkinHeight:Number = NaN;
		
		/**
		 * @private
		 */
		protected var _defaultSkin:DisplayObject;
		
		/**
		 * The skin used when no other skin is defined for the current state.
		 * Intended for use when multiple states should use the same skin.
		 * 
		 * @see #upSkin
		 * @see #downSkin
		 * @see #disabledSkin
		 * @see #defaultSelectedSkin
		 * @see #selectedUpSkin
		 * @see #selectedDownSkin
		 */
		public function get defaultSkin():DisplayObject
		{
			return this._defaultSkin;
		}
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		protected var _defaultSelectedSkin:DisplayObject;
		
		/**
		 * The skin used when no other skin is defined for the current state
		 * when the button is selected. Has a higher priority than
		 * <code>defaultSkin</code>, but a lower priority than other selected
		 * skins.
		 * 
		 * @see #defaultSkin
		 * @see #selectedUpSkin
		 * @see #selectedDownSkin
		 */
		public function get defaultSelectedSkin():DisplayObject
		{
			return this._defaultSelectedSkin;
		}
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		protected var _upSkin:DisplayObject;
		
		/**
		 * The skin used for the button's up state. If <code>null</code>, then
		 * <code>defaultSkin</code> is used instead.
		 * 
		 * @see #defaultSkin
		 */
		public function get upSkin():DisplayObject
		{
			return this._upSkin;
		}
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		protected var _downSkin:DisplayObject;
		
		/**
		 * The skin used for the button's down state. If <code>null</code>, then
		 * <code>defaultSkin</code> is used instead.
		 * 
		 * @see #defaultSkin
		 */
		public function get downSkin():DisplayObject
		{
			return this._downSkin;
		}
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		protected var _disabledSkin:DisplayObject;
		
		/**
		 * The skin used for the button's disabled state. If <code>null</code>,
		 * then <code>defaultSkin</code> is used instead.
		 * 
		 * @see #defaultSkin
		 */
		public function get disabledSkin():DisplayObject
		{
			return this._disabledSkin;
		}
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		protected var _selectedUpSkin:DisplayObject;
		
		/**
		 * The skin used for the button's up state when the button is selected.
		 * If <code>null</code>, then <code>defaultSelectedSkin</code> is used
		 * instead. If <code>defaultSelectedSkin</code> is also
		 * <code>null</code>, then <code>defaultSkin</code> is used.
		 * 
		 * @see #defaultSkin
		 * @see #defaultSelectedSkin
		 */
		public function get selectedUpSkin():DisplayObject
		{
			return this._selectedUpSkin;
		}
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		protected var _selectedDownSkin:DisplayObject;
		
		/**
		 * The skin used for the button's down state when the button is
		 * selected. If <code>null</code>, then <code>defaultSelectedSkin</code>
		 * is used instead. If <code>defaultSelectedSkin</code> is also
		 * <code>null</code>, then <code>defaultSkin</code> is used.
		 * 
		 * @see #defaultSkin
		 * @see #defaultSelectedSkin
		 */
		public function get selectedDownSkin():DisplayObject
		{
			return this._selectedDownSkin;
		}
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		protected var _defaultTextFormat:BitmapFontTextFormat;
		
		/**
		 * The text format used when no other text format is defined for the
		 * current state. Intended for use when multiple states should use the
		 * same text format.
		 * 
		 * @see #upTextFormat
		 * @see #downTextFormat
		 * @see #disabledTextFormat
		 * @see #defaultSelectedTextFormat
		 * @see #selectedUpTextFormat
		 * @see #selectedDownTextFormat
		 */
		public function get defaultTextFormat():BitmapFontTextFormat
		{
			return this._defaultTextFormat;
		}
		
		/**
		 * @private
		 */
		public function set defaultTextFormat(value:BitmapFontTextFormat):void
		{
			this._defaultTextFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		protected var _upTextFormat:BitmapFontTextFormat;
		
		/**
		 * The text format used for the button's up state. If <code>null</code>,
		 * then <code>defaultTextFormat</code> is used instead.
		 * 
		 * @see #defaultTextFormat
		 */
		public function get upTextFormat():BitmapFontTextFormat
		{
			return this._upTextFormat;
		}
		
		/**
		 * @private
		 */
		public function set upTextFormat(value:BitmapFontTextFormat):void
		{
			this._upTextFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		protected var _downTextFormat:BitmapFontTextFormat;
		
		/**
		 * The text format used for the button's down state. If <code>null</code>,
		 * then <code>defaultTextFormat</code> is used instead.
		 * 
		 * @see #defaultTextFormat
		 */
		public function get downTextFormat():BitmapFontTextFormat
		{
			return this._downTextFormat;
		}
		
		/**
		 * @private
		 */
		public function set downTextFormat(value:BitmapFontTextFormat):void
		{
			this._downTextFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		protected var _disabledTextFormat:BitmapFontTextFormat;
		
		/**
		 * The text format used for the button's disabled state. If <code>null</code>,
		 * then <code>defaultTextFormat</code> is used instead.
		 * 
		 * @see #defaultTextFormat
		 */
		public function get disabledTextFormat():BitmapFontTextFormat
		{
			return this._disabledTextFormat;
		}
		
		/**
		 * @private
		 */
		public function set disabledTextFormat(value:BitmapFontTextFormat):void
		{
			this._disabledTextFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		protected var _defaultSelectedTextFormat:BitmapFontTextFormat;
		
		/**
		 * The text format used when no other text format is defined for the
		 * current state when the button is selected. Has a higher priority than
		 * <code>defaultTextFormat</code>, but a lower priority than other
		 * selected text formats.
		 * 
		 * @see #defaultTextFormat
		 * @see #selectedUpTextFormat
		 * @see #selectedDownTextFormat
		 */
		public function get defaultSelectedTextFormat():BitmapFontTextFormat
		{
			return this._defaultSelectedTextFormat;
		}
		
		/**
		 * @private
		 */
		public function set defaultSelectedTextFormat(value:BitmapFontTextFormat):void
		{
			this._defaultSelectedTextFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		protected var _selectedUpTextFormat:BitmapFontTextFormat;
		
		/**
		 * The text format used for the button's up state when the button is
		 * selected. If <code>null</code>, then <code>defaultSelectedTextFormat</code>
		 * is used instead. If <code>defaultSelectedTextFormat</code> is also
		 * <code>null</code>, then <code>defaultTextFormat</code> is used.
		 * 
		 * @see #defaultTextFormat
		 * @see #defaultSelectedTextFormat
		 */
		public function get selectedUpTextFormat():BitmapFontTextFormat
		{
			return this._selectedUpTextFormat;
		}
		
		/**
		 * @private
		 */
		public function set selectedUpTextFormat(value:BitmapFontTextFormat):void
		{
			this._selectedUpTextFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		protected var _selectedDownTextFormat:BitmapFontTextFormat;
		
		/**
		 * The text format used for the button's down state when the button is
		 * selected. If <code>null</code>, then <code>defaultSelectedTextFormat</code>
		 * is used instead. If <code>defaultSelectedTextFormat</code> is also
		 * <code>null</code>, then <code>defaultTextFormat</code> is used.
		 * 
		 * @see #defaultTextFormat
		 * @see #defaultSelectedTextFormat
		 */
		public function get selectedDownTextFormat():BitmapFontTextFormat
		{
			return this._selectedDownTextFormat;
		}
		
		/**
		 * @private
		 */
		public function set selectedDownTextFormat(value:BitmapFontTextFormat):void
		{
			this._selectedDownTextFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		private var _defaultIcon:DisplayObject;
		
		/**
		 * The icon used when no other icon is defined for the current state.
		 * Intended for use when multiple states should use the same icon.
		 * 
		 * @see #upIcon
		 * @see #downIcon
		 * @see #disabledIcon
		 * @see #defaultSelectedIcon
		 * @see #selectedUpIcon
		 * @see #selectedDownIcon
		 */
		public function get defaultIcon():DisplayObject
		{
			return this._defaultIcon;
		}
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		private var _defaultSelectedIcon:DisplayObject;
		
		/**
		 * The icon used when no other icon is defined for the current state
		 * when the button is selected. Has a higher priority than
		 * <code>defaultIcon</code>, but a lower priority than other selected
		 * icons.
		 * 
		 * @see #defaultIcon
		 * @see #selectedUpIcon
		 * @see #selectedDownIcon
		 */
		public function get defaultSelectedIcon():DisplayObject
		{
			return this._defaultSelectedIcon;
		}
		
		/**
		 * @private
		 */
		public function set defaultSelectedIcon(value:DisplayObject):void
		{
			if(this._defaultSelectedIcon == value)
			{
				return;
			}
			
			if(this._defaultSelectedIcon && this._defaultSelectedIcon != this._defaultIcon &&
				this._defaultSelectedIcon != this._upIcon && this._defaultSelectedIcon != this._downIcon &&
				this._defaultSelectedIcon != this._selectedUpIcon  && this._defaultSelectedIcon != this._selectedDownIcon &&
				this._defaultSelectedIcon != this._disabledIcon)
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
		
		/**
		 * @private
		 */
		private var _upIcon:DisplayObject;
		
		/**
		 * The icon used for the button's up state. If <code>null</code>, then
		 * <code>defaultIcon</code> is used instead.
		 * 
		 * @see #defaultIcon
		 */
		public function get upIcon():DisplayObject
		{
			return this._upIcon;
		}
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		private var _downIcon:DisplayObject;
		
		/**
		 * The icon used for the button's down state. If <code>null</code>, then
		 * <code>defaultIcon</code> is used instead.
		 * 
		 * @see #defaultIcon
		 */
		public function get downIcon():DisplayObject
		{
			return this._downIcon;
		}
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		private var _disabledIcon:DisplayObject;
		
		/**
		 * The icon used for the button's disabled state. If <code>null</code>, then
		 * <code>defaultIcon</code> is used instead.
		 * 
		 * @see #defaultIcon
		 */
		public function get disabledIcon():DisplayObject
		{
			return this._disabledIcon;
		}
		
		/**
		 * @private
		 */
		public function set disabledIcon(value:DisplayObject):void
		{
			if(this._disabledIcon == value)
			{
				return;
			}
			
			if(this._disabledIcon && this._disabledIcon != this._defaultIcon && this._disabledIcon != this._defaultSelectedIcon &&
				this._disabledIcon != this._upIcon && this._disabledIcon != this._downIcon &&
				this._disabledIcon != this._selectedUpIcon && this._disabledIcon != this._selectedDownIcon)
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
		
		/**
		 * @private
		 */
		private var _selectedUpIcon:DisplayObject;
		
		/**
		 * The icon used for the button's up state when the button is
		 * selected. If <code>null</code>, then <code>defaultSelectedIcon</code>
		 * is used instead. If <code>defaultSelectedIcon</code> is also
		 * <code>null</code>, then <code>defaultIcon</code> is used.
		 * 
		 * @see #defaultIcon
		 * @see #defaultSelectedIcon
		 */
		public function get selectedUpIcon():DisplayObject
		{
			return this._selectedUpIcon;
		}
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		private var _selectedDownIcon:DisplayObject;
		
		/**
		 * The icon used for the button's down state when the button is
		 * selected. If <code>null</code>, then <code>defaultSelectedIcon</code>
		 * is used instead. If <code>defaultSelectedIcon</code> is also
		 * <code>null</code>, then <code>defaultIcon</code> is used.
		 * 
		 * @see #defaultIcon
		 * @see #defaultSelectedIcon
		 */
		public function get selectedDownIcon():DisplayObject
		{
			return this._selectedDownIcon;
		}
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		private var _autoFlatten:Boolean = false;
		
		/**
		 * Determines if the button should automatically call <code>flatten()</code>
		 * after it finishes drawing. In some cases, this will improve
		 * performance.
		 */
		public function get autoFlatten():Boolean
		{
			return this._autoFlatten;
		}
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		protected var _onPress:Signal = new Signal(Button);
		
		/**
		 * Dispatched when the button enters the down state.
		 */
		public function get onPress():ISignal
		{
			return this._onPress;
		}
		
		/**
		 * @private
		 */
		protected var _onRelease:Signal = new Signal(Button);
		
		/**
		 * Dispatched when the button is released while the touch is still
		 * within the button's bounds (a tap or click that should trigger the
		 * button).
		 */
		public function get onRelease():ISignal
		{
			return this._onRelease;
		}
		
		/**
		 * @private
		 */
		protected var _onChange:Signal = new Signal(Button);
		
		/**
		 * Dispatched when the button is selected or unselected.
		 */
		public function get onChange():ISignal
		{
			return this._onChange;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			this._onPress.removeAll();
			this._onRelease.removeAll();
			this._onChange.removeAll();
			super.dispose();
		}
		
		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(!this.labelControl)
			{
				this.labelControl = new Label();
				this.labelControl.nameList.add(this.defaultLabelName);
				this.addChild(this.labelControl);
			}
		}
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			
			if(dataInvalid)
			{
				this.refreshLabelData();
			}

			if(stylesInvalid || stateInvalid)
			{
				this.refreshSkin();
				if(this.currentSkin && isNaN(this._originalSkinWidth))
				{
					this._originalSkinWidth = this.currentSkin.width;
				}
				if(this.currentSkin && isNaN(this._originalSkinHeight))
				{
					this._originalSkinHeight = this.currentSkin.height;
				}
				this.refreshIcon();
				this.refreshLabelStyles();
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;
			
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

				this.layoutContent();
			}
			
			if(this._autoFlatten)
			{
				this.unflatten();
				this.flatten();
			}
		}

		/**
		 * @private
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			this.labelControl.measureText(helperPoint);
			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				if(this.currentIcon && this.label)
				{
					if(this._iconPosition != ICON_POSITION_TOP && this._iconPosition != ICON_POSITION_BOTTOM)
					{
						var adjustedGap:Number = this._gap == Number.POSITIVE_INFINITY ? Math.min(this._paddingLeft, this._paddingRight) : this._gap;
						newWidth = this.currentIcon.width + adjustedGap + helperPoint.x;
					}
					else
					{
						newWidth = Math.max(this.currentIcon.width, helperPoint.x);
					}
				}
				else if(this.currentIcon)
				{
					newWidth = this.currentIcon.width;
				}
				else if(this.label)
				{
					newWidth = helperPoint.x;
				}
				newWidth += this._paddingLeft + this._paddingRight;
				if(isNaN(newWidth))
				{
					newWidth = this._originalSkinWidth;
				}
				else if(!isNaN(this._originalSkinWidth))
				{
					newWidth = Math.max(newWidth, this._originalSkinWidth);
				}
			}

			var newHeight:Number = this.explicitHeight;
			if(needsHeight)
			{
				if(this.currentIcon && this.label)
				{
					if(this._iconPosition == ICON_POSITION_TOP || this._iconPosition == ICON_POSITION_BOTTOM)
					{
						adjustedGap = this._gap == Number.POSITIVE_INFINITY ? Math.min(this._paddingTop, this._paddingBottom) : this._gap;
						newHeight = this.currentIcon.height + adjustedGap + helperPoint.y;
					}
					else
					{
						newHeight = Math.max(this.currentIcon.height, helperPoint.y);
					}
				}
				else if(this.currentIcon)
				{
					newHeight = this.currentIcon.height;
				}
				else if(this.label)
				{
					newHeight = helperPoint.y;
				}
				newHeight += this._paddingTop + this._paddingBottom;
				if(isNaN(newHeight))
				{
					newHeight = this._originalSkinHeight;
				}
				else if(!isNaN(this._originalSkinHeight))
				{
					newHeight = Math.max(newHeight, this._originalSkinHeight);
				}
			}

			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		protected function refreshLabelData():void
		{
			this.labelControl.text = this._label;
			this.labelControl.visible = this._label != null;
		}

		/**
		 * @private
		 */
		protected function refreshSkin():void
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

			if(this.currentSkin)
			{
				this.currentSkin.visible = true;
			}
		}
		
		/**
		 * @private
		 */
		protected function refreshIcon():void
		{
			this.currentIcon = null;
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
		
		/**
		 * @private
		 */
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
			
			if(format)
			{
				this.labelControl.textFormat = format;
			}
		}
		
		/**
		 * @private
		 */
		protected function scaleSkin():void
		{
			if(!this.currentSkin)
			{
				return;
			}
			if(this.currentSkin.width != this.actualWidth)
			{
				this.currentSkin.width = this.actualWidth;
			}
			if(this.currentSkin.height != this.actualHeight)
			{
				this.currentSkin.height = this.actualHeight;
			}
		}
		
		/**
		 * @private
		 */
		protected function layoutContent():void
		{
			if(this.label && this.currentIcon)
			{
				if(this._iconPosition == ICON_POSITION_LEFT || this._iconPosition == ICON_POSITION_LEFT_BASELINE ||
					this._iconPosition == ICON_POSITION_RIGHT || this._iconPosition == ICON_POSITION_RIGHT_BASELINE)
				{
					var adjustedGap:Number = this._gap == Number.POSITIVE_INFINITY ? Math.min(this._paddingLeft, this._paddingRight) : this._gap;
					this.labelControl.maxWidth = this.actualWidth - this._paddingLeft - this._paddingRight - this.currentIcon.width - adjustedGap;
				}
				this.labelControl.validate();
				this.positionLabelOrIcon(this.labelControl);
				this.positionLabelAndIcon();
			}
			else if(this.label && !this.currentIcon)
			{
				this.labelControl.maxWidth = this.actualWidth - this._paddingLeft - this._paddingRight;
				this.labelControl.validate();
				this.positionLabelOrIcon(this.labelControl);
			}
			else if(!this.label && this.currentIcon)
			{
				this.positionLabelOrIcon(this.currentIcon)
			}
		}
		
		/**
		 * @private
		 */
		protected function positionLabelOrIcon(displayObject:DisplayObject):void
		{
			if(this._horizontalAlign == HORIZONTAL_ALIGN_LEFT)
			{
				displayObject.x = this._paddingLeft;
			}
			else if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
			{
				displayObject.x = this.actualWidth - this._paddingRight - displayObject.width;
			}
			else //center
			{
				displayObject.x = (this.actualWidth - displayObject.width) / 2;
			}
			if(this._verticalAlign == VERTICAL_ALIGN_TOP)
			{
				displayObject.y = this._paddingTop;
			}
			else if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
			{
				displayObject.y = this.actualHeight - this._paddingBottom - displayObject.height;
			}
			else //middle
			{
				displayObject.y = (this.actualHeight - displayObject.height) / 2;
			}
		}
		
		/**
		 * @private
		 */
		protected function positionLabelAndIcon():void
		{
			if(this._iconPosition == ICON_POSITION_TOP)
			{
				if(this._gap == Number.POSITIVE_INFINITY)
				{
					this.currentIcon.y = this._paddingTop;
					this.labelControl.y = this.actualHeight - this._paddingBottom - this.labelControl.height;
				}
				else
				{
					if(this._verticalAlign == VERTICAL_ALIGN_TOP)
					{
						this.labelControl.y += this.currentIcon.height + this._gap;
					}
					else if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
					{
						this.labelControl.y += (this.currentIcon.height + this._gap) / 2;
					}
					this.currentIcon.y = this.labelControl.y - this.currentIcon.height - this._gap;
				}
			}
			else if(this._iconPosition == ICON_POSITION_RIGHT || this._iconPosition == ICON_POSITION_RIGHT_BASELINE)
			{
				if(this._gap == Number.POSITIVE_INFINITY)
				{
					this.labelControl.x = this._paddingLeft;
					this.currentIcon.x = this.actualWidth - this._paddingRight - this.currentIcon.width;
				}
				else
				{
					if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
					{
						this.labelControl.x -= this.currentIcon.width + this._gap;
					}
					else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
					{
						this.labelControl.x -= (this.currentIcon.width + this._gap) / 2;
					}
					this.currentIcon.x = this.labelControl.x + this.labelControl.width + this._gap;
				}
			}
			else if(this._iconPosition == ICON_POSITION_BOTTOM)
			{
				if(this._gap == Number.POSITIVE_INFINITY)
				{
					this.labelControl.y = this._paddingTop;
					this.currentIcon.y = this.actualHeight - this._paddingBottom - this.currentIcon.height;
				}
				else
				{
					if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
					{
						this.labelControl.y -= this.currentIcon.height + this._gap;
					}
					else if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
					{
						this.labelControl.y -= (this.currentIcon.height + this._gap) / 2;
					}
					this.currentIcon.y = this.labelControl.y + this.labelControl.height + this._gap;
				}
			}
			else if(this._iconPosition == ICON_POSITION_LEFT || this._iconPosition == ICON_POSITION_LEFT_BASELINE)
			{
				if(this._gap == Number.POSITIVE_INFINITY)
				{
					this.currentIcon.x = this._paddingLeft;
					this.labelControl.x = this.actualWidth - this._paddingRight - this.labelControl.width;
				}
				else
				{
					if(this._horizontalAlign == HORIZONTAL_ALIGN_LEFT)
					{
						this.labelControl.x += this._gap + this.currentIcon.width;
					}
					else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
					{
						this.labelControl.x += (this._gap + this.currentIcon.width) / 2;
					}
					this.currentIcon.x = this.labelControl.x - this._gap - this.currentIcon.width;
				}
			}
			
			if(this._iconPosition == ICON_POSITION_LEFT || this._iconPosition == ICON_POSITION_RIGHT)
			{
				this.currentIcon.y = this.labelControl.y + (this.labelControl.height - this.currentIcon.height) / 2;
			}
			else if(this._iconPosition == ICON_POSITION_LEFT_BASELINE || this._iconPosition == ICON_POSITION_RIGHT_BASELINE)
			{
				const font:BitmapFont = this.labelControl.textFormat.font;
				const formatSize:Number = this.labelControl.textFormat.size;
				const fontSizeScale:Number = isNaN(formatSize) ? 1 : (formatSize / font.size);
				this.currentIcon.y = this.labelControl.y + (fontSizeScale * font.baseline) - this.currentIcon.height;
			}
			else
			{
				if(this._horizontalAlign == HORIZONTAL_ALIGN_LEFT)
				{
					this.currentIcon.x = this.labelControl.x;
				}
				else if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
				{
					this.currentIcon.x = this.labelControl.x + this.labelControl.width - this.currentIcon.width;
				}
				else
				{
					this.currentIcon.x = this.labelControl.x + (this.labelControl.width - this.currentIcon.width) / 2;
				}
			}
		}
		
		/**
		 * @private
		 */
		private function touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				return;
			}
			const touch:Touch = event.getTouch(this);
			if(!touch || (this._touchPointID >= 0 && this._touchPointID != touch.id))
			{
				return;
			}
			const location:Point = touch.getLocation(this);
			ScrollRectManager.adjustTouchLocation(location, this);
			const isInBounds:Boolean = this.hitTest(location, true) != null;
			if(touch.phase == TouchPhase.BEGAN)
			{
				this.currentState = STATE_DOWN;
				this._touchPointID = touch.id;
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
				this._touchPointID = -1;
				this.currentState = STATE_UP;
				if(isInBounds)
				{
					this._onRelease.dispatch(this);
					if(this._isToggle)
					{
						this.isSelected = !this._isSelected;
					}
				}
			}
		}
	}
}