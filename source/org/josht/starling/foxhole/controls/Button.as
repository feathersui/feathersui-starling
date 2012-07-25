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
	import org.josht.starling.foxhole.core.PropertyProxy;
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
		public static const STATE_UP:String = "up";
		
		/**
		 * @private
		 */
		public static const STATE_DOWN:String = "down";

		/**
		 * @private
		 */
		public static const STATE_HOVER:String = "hover";
		
		/**
		 * @private
		 */
		public static const STATE_DISABLED:String = "disabled";
		
		/**
		 * @private
		 */
		public static const STATE_SELECTED_UP:String = "selectedUp";
		
		/**
		 * @private
		 */
		public static const STATE_SELECTED_DOWN:String = "selectedDown";

		/**
		 * @private
		 */
		public static const STATE_SELECTED_HOVER:String = "selectedHover";

		/**
		 * @private
		 */
		public static const STATE_SELECTED_DISABLED:String = "selectedDisabled";
		
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
		 * @private
		 */
		protected var _isHoverSupported:Boolean = false;
		
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
		protected var _stateNames:Vector.<String> = new <String>
		[
			STATE_UP, STATE_DOWN, STATE_HOVER, STATE_DISABLED,
			STATE_SELECTED_UP, STATE_SELECTED_DOWN, STATE_SELECTED_HOVER, STATE_SELECTED_DISABLED
		];

		/**
		 * A list of all valid state names.
		 */
		protected function get stateNames():Vector.<String>
		{
			return this._stateNames;
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
		protected var _stateToSkinFunction:Function;

		/**
		 * Returns a skin for the current state.
		 *
		 * <p>The following function signature is expected:</p>
		 * <pre>function(target:Button, state:Object, oldSkin:DisplayObject = null):DisplayObject</pre>
		 */
		public function get stateToSkinFunction():Function
		{
			return this._stateToSkinFunction;
		}

		/**
		 * @private
		 */
		public function set stateToSkinFunction(value:Function):void
		{
			if(this._stateToSkinFunction == value)
			{
				return;
			}
			this._stateToSkinFunction = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _stateToIconFunction:Function;

		/**
		 * Returns an icon for the current state.
		 *
		 * <p>The following function signature is expected:</p>
		 * <pre>function(target:Button, state:Object, oldIcon:DisplayObject = null):DisplayObject</pre>
		 */
		public function get stateToIconFunction():Function
		{
			return this._stateToIconFunction;
		}

		/**
		 * @private
		 */
		public function set stateToIconFunction(value:Function):void
		{
			if(this._stateToIconFunction == value)
			{
				return;
			}
			this._stateToIconFunction = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _stateToTextFormatFunction:Function;

		/**
		 * Returns a text format for the current state.
		 *
		 * <p>The following function signature is expected:</p>
		 * <pre>function(target:Button, state:Object, oldTextFormat:BitmapFontTextFormat = null):BitmapFontTextFormat</pre>
		 */
		public function get stateToTextFormatFunction():Function
		{
			return this._stateToTextFormatFunction;
		}

		/**
		 * @private
		 */
		public function set stateToTextFormatFunction(value:Function):void
		{
			if(this._stateToTextFormatFunction == value)
			{
				return;
			}
			this._stateToTextFormatFunction = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
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
		 * @see #hoverSkin
		 * @see #disabledSkin
		 * @see #defaultSelectedSkin
		 * @see #selectedUpSkin
		 * @see #selectedDownSkin
		 * @see #selectedHoverSkin
		 * @see #selectedDisabledSkin
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
				this._defaultSkin != this._hoverSkin && this._defaultSkin != this._disabledSkin &&
				this._defaultSkin != this._selectedUpSkin && this._defaultSkin != this._selectedDownSkin &&
				this._defaultSkin != this._selectedHoverSkin && this._defaultSkin != this._selectedDisabledSkin)
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
		 * @see #selectedHoverSkin
		 * @see #selectedDisabledSkin
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
				this._defaultSelectedSkin != this._hoverSkin && this._defaultSelectedSkin != this._disabledSkin &&
				this._defaultSelectedSkin != this._selectedUpSkin && this._defaultSelectedSkin != this._selectedDownSkin &&
				this._defaultSelectedSkin != this._selectedHoverSkin && this._defaultSelectedSkin != this._selectedDisabledSkin)
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
		 * @see #selectedUpSkin
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
				this._upSkin != this._downSkin && this._upSkin != this._hoverSkin && this._upSkin != this._disabledSkin &&
				this._upSkin != this._selectedUpSkin && this._upSkin != this._selectedDownSkin &&
				this._upSkin != this._selectedHoverSkin && this._upSkin != this._selectedDisabledSkin)
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
		 * @see #selectedDownSkin
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
				this._downSkin != this._upSkin && this._downSkin != this._hoverSkin && this._downSkin != this._disabledSkin &&
				this._downSkin != this._selectedUpSkin && this._downSkin != this._selectedDownSkin &&
				this._downSkin != this._selectedHoverSkin && this._downSkin != this._selectedDisabledSkin)
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
		protected var _hoverSkin:DisplayObject;

		/**
		 * The skin used for the button's hover state. If <code>null</code>, then
		 * <code>defaultSkin</code> is used instead.
		 *
		 * @see #defaultSkin
		 * @see #selectedHoverSkin
		 */
		public function get hoverSkin():DisplayObject
		{
			return this._hoverSkin;
		}

		/**
		 * @private
		 */
		public function set hoverSkin(value:DisplayObject):void
		{
			if(this._hoverSkin == value)
			{
				return;
			}

			if(this._hoverSkin && this._hoverSkin != this._defaultSkin && this._hoverSkin != this._defaultSelectedSkin &&
				this._hoverSkin != this._upSkin && this._hoverSkin != this._downSkin && this._hoverSkin != this._disabledSkin &&
				this._hoverSkin != this._selectedUpSkin && this._hoverSkin != this._selectedDownSkin &&
				this._hoverSkin != this._selectedHoverSkin && this._hoverSkin != this._selectedDisabledSkin)
			{
				this.removeChild(this._hoverSkin);
			}
			this._hoverSkin = value;
			if(this._hoverSkin && this._hoverSkin.parent != this)
			{
				this._hoverSkin.visible = false;
				this.addChildAt(this._hoverSkin, 0);
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
		 * @see #selectedDisabledSkin
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
				this._disabledSkin != this._upSkin && this._disabledSkin != this._downSkin && this._disabledSkin != this._hoverSkin &&
				this._disabledSkin != this._selectedUpSkin && this._disabledSkin != this._selectedDownSkin &&
				this._disabledSkin != this._selectedHoverSkin && this._disabledSkin != this._selectedDisabledSkin)
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
				this._selectedUpSkin != this._hoverSkin && this._selectedUpSkin != this._disabledSkin &&
				this._selectedUpSkin != this._selectedDownSkin &&
				this._selectedUpSkin != this._selectedHoverSkin && this._selectedUpSkin != this._selectedDisabledSkin)
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
				this._selectedDownSkin != this._hoverSkin && this._selectedDownSkin != this._disabledSkin &&
				this._selectedDownSkin != this._selectedUpSkin &&
				this._selectedDownSkin != this._selectedHoverSkin && this._selectedDownSkin != this._selectedDisabledSkin)
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
		protected var _selectedHoverSkin:DisplayObject;

		/**
		 * The skin used for the button's hover state when the button is
		 * selected. If <code>null</code>, then <code>defaultSelectedSkin</code>
		 * is used instead. If <code>defaultSelectedSkin</code> is also
		 * <code>null</code>, then <code>defaultSkin</code> is used.
		 *
		 * @see #defaultSkin
		 * @see #defaultSelectedSkin
		 */
		public function get selectedHoverSkin():DisplayObject
		{
			return this._selectedHoverSkin;
		}

		/**
		 * @private
		 */
		public function set selectedHoverSkin(value:DisplayObject):void
		{
			if(this._selectedHoverSkin == value)
			{
				return;
			}

			if(this._selectedHoverSkin && this._selectedHoverSkin != this._defaultSkin && this._selectedHoverSkin != this._defaultSelectedSkin &&
				this._selectedHoverSkin != this._upSkin && this._selectedHoverSkin != this._downSkin &&
				this._selectedHoverSkin != this._hoverSkin && this._selectedHoverSkin != this._disabledSkin &&
				this._selectedHoverSkin != this._selectedUpSkin && this._selectedHoverSkin != this._selectedDownSkin &&
				this._selectedHoverSkin != this._selectedDisabledSkin)
			{
				this.removeChild(this._selectedHoverSkin);
			}
			this._selectedHoverSkin = value;
			if(this._selectedHoverSkin && this._selectedHoverSkin.parent != this)
			{
				this._selectedHoverSkin.visible = false;
				this.addChildAt(this._selectedHoverSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _selectedDisabledSkin:DisplayObject;

		/**
		 * The skin used for the button's disabled state when the button is
		 * selected. If <code>null</code>, then <code>defaultSelectedSkin</code>
		 * is used instead. If <code>defaultSelectedSkin</code> is also
		 * <code>null</code>, then <code>defaultSkin</code> is used.
		 *
		 * @see #defaultSkin
		 * @see #defaultSelectedSkin
		 */
		public function get selectedDisabledSkin():DisplayObject
		{
			return this._selectedDisabledSkin;
		}

		/**
		 * @private
		 */
		public function set selectedDisabledSkin(value:DisplayObject):void
		{
			if(this._selectedDisabledSkin == value)
			{
				return;
			}

			if(this._selectedDisabledSkin && this._selectedDisabledSkin != this._defaultSkin && this._selectedDisabledSkin != this._defaultSelectedSkin &&
				this._selectedDisabledSkin != this._upSkin && this._selectedDisabledSkin != this._downSkin &&
				this._selectedDisabledSkin != this._hoverSkin && this._selectedDisabledSkin != this._disabledSkin &&
				this._selectedDisabledSkin != this._selectedUpSkin && this._selectedDisabledSkin != this._selectedDownSkin &&
				this._selectedDisabledSkin != this._selectedHoverSkin)
			{
				this.removeChild(this._selectedDisabledSkin);
			}
			this._selectedDisabledSkin = value;
			if(this._selectedDisabledSkin && this._selectedDisabledSkin.parent != this)
			{
				this._selectedDisabledSkin.visible = false;
				this.addChildAt(this._selectedDisabledSkin, 0);
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
		 * @see #defaultSelectedTextFormat
		 * @see #upTextFormat
		 * @see #downTextFormat
		 * @see #hoverTextFormat
		 * @see #disabledTextFormat
		 * @see #selectedUpTextFormat
		 * @see #selectedDownTextFormat
		 * @see #selectedHoverTextFormat
		 * @see #selectedDisabledTextFormat
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
		 * @see #selectedUpTextFormat
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
		 * @see #selectedDownTextFormat
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
		protected var _hoverTextFormat:BitmapFontTextFormat;

		/**
		 * The text format used for the button's hover state. If <code>null</code>,
		 * then <code>defaultTextFormat</code> is used instead.
		 *
		 * @see #defaultTextFormat
		 * @see #selectedHoverTextFormat
		 */
		public function get hoverTextFormat():BitmapFontTextFormat
		{
			return this._hoverTextFormat;
		}

		/**
		 * @private
		 */
		public function set hoverTextFormat(value:BitmapFontTextFormat):void
		{
			this._hoverTextFormat = value;
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
		 * @see #selectedDisabledTextFormat
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
		 * @see #selectedHoverTextFormat
		 * @see #selectedDisabledTextFormat
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
		protected var _selectedHoverTextFormat:BitmapFontTextFormat;

		/**
		 * The text format used for the button's down state when the button is
		 * selected. If <code>null</code>, then <code>defaultSelectedTextFormat</code>
		 * is used instead. If <code>defaultSelectedTextFormat</code> is also
		 * <code>null</code>, then <code>defaultTextFormat</code> is used.
		 *
		 * @see #defaultTextFormat
		 * @see #defaultSelectedTextFormat
		 */
		public function get selectedHoverTextFormat():BitmapFontTextFormat
		{
			return this._selectedHoverTextFormat;
		}

		/**
		 * @private
		 */
		public function set selectedHoverTextFormat(value:BitmapFontTextFormat):void
		{
			this._selectedHoverTextFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _selectedDisabledTextFormat:BitmapFontTextFormat;

		/**
		 * The text format used for the button's disabled state when the button is
		 * selected. If <code>null</code>, then <code>defaultSelectedTextFormat</code>
		 * is used instead. If <code>defaultSelectedTextFormat</code> is also
		 * <code>null</code>, then <code>defaultTextFormat</code> is used.
		 *
		 * @see #defaultTextFormat
		 * @see #defaultSelectedTextFormat
		 */
		public function get selectedDisabledTextFormat():BitmapFontTextFormat
		{
			return this._selectedDisabledTextFormat;
		}

		/**
		 * @private
		 */
		public function set selectedDisabledTextFormat(value:BitmapFontTextFormat):void
		{
			this._selectedDisabledTextFormat = value;
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
		 * @see #hoverIcon
		 * @see #disabledIcon
		 * @see #defaultSelectedIcon
		 * @see #selectedUpIcon
		 * @see #selectedDownIcon
		 * @see #selectedHoverIcon
		 * @see #selectedDisabledIcon
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
				this._defaultIcon != this._hoverIcon && this._defaultIcon != this._disabledIcon &&
				this._defaultIcon != this._selectedUpIcon && this._defaultIcon != this._selectedDownIcon &&
				this._defaultIcon != this._selectedHoverIcon && this._defaultIcon != this._selectedDisabledIcon)
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
		 * @see #selectedHoverIcon
		 * @see #selectedDisabledIcon
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
				this._defaultSelectedIcon != this._hoverIcon && this._defaultSelectedIcon != this._disabledIcon &&
				this._defaultSelectedIcon != this._selectedUpIcon  && this._defaultSelectedIcon != this._selectedDownIcon &&
				this._defaultSelectedIcon != this._selectedHoverIcon && this._defaultSelectedIcon != this._selectedDisabledIcon)
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
		 * @see #selectedUpIcon
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
				this._upIcon != this._downIcon && this._upIcon != this._hoverIcon && this._upIcon != this._disabledIcon &&
				this._upIcon != this._selectedUpIcon && this._upIcon != this._selectedDownIcon &&
				this._upIcon != this._selectedHoverIcon && this._upIcon != this._selectedDisabledIcon)
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
		 * @see #selectedDownIcon
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
				this._downIcon != this._upIcon && this._downIcon != this._hoverIcon && this._downIcon != this._disabledIcon &&
				this._downIcon != this._selectedUpIcon && this._downIcon != this._selectedDownIcon &&
				this._downIcon != this._selectedHoverIcon && this._downIcon != this._selectedDisabledIcon)
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
		private var _hoverIcon:DisplayObject;

		/**
		 * The icon used for the button's hover state. If <code>null</code>, then
		 * <code>defaultIcon</code> is used instead.
		 *
		 * @see #defaultIcon
		 * @see #selectedDownIcon
		 */
		public function get hoverIcon():DisplayObject
		{
			return this._hoverIcon;
		}

		/**
		 * @private
		 */
		public function set hoverIcon(value:DisplayObject):void
		{
			if(this._hoverIcon == value)
			{
				return;
			}

			if(this._hoverIcon && this._hoverIcon != this._defaultIcon && this._hoverIcon != this._defaultSelectedIcon &&
				this._hoverIcon != this._upIcon && this._hoverIcon != this._downIcon && this._hoverIcon != this._disabledIcon &&
				this._hoverIcon != this._selectedUpIcon && this._hoverIcon != this._selectedDownIcon &&
				this._hoverIcon != this._selectedHoverIcon && this._hoverIcon != this._selectedDisabledIcon)
			{
				this.removeChild(this._hoverIcon);
			}
			this._hoverIcon = value;
			if(this._hoverIcon && this._hoverIcon.parent != this)
			{
				this._hoverIcon.visible = false;
				this.addChild(this._hoverIcon);
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
		 * @see #selectedDisabledIcon
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
				this._disabledIcon != this._hoverIcon &&
				this._disabledIcon != this._selectedUpIcon && this._disabledIcon != this._selectedDownIcon &&
				this._disabledIcon != this._selectedHoverIcon && this._disabledIcon != this._selectedDisabledIcon)
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
				this._selectedUpIcon != this._hoverIcon && this._selectedUpIcon != this._disabledIcon &&
				this._selectedUpIcon != this._selectedDownIcon &&
				this._selectedUpIcon != this._selectedHoverIcon && this._selectedUpIcon != this._selectedDisabledIcon)
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
				this._selectedDownIcon != this._hoverIcon &&  this._selectedDownIcon != this._disabledIcon &&
				this._selectedDownIcon != this._selectedUpIcon &&
				this._selectedDownIcon != this._selectedHoverIcon && this._selectedDownIcon != this._selectedDisabledIcon)
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
		private var _selectedHoverIcon:DisplayObject;

		/**
		 * The icon used for the button's hover state when the button is
		 * selected. If <code>null</code>, then <code>defaultSelectedIcon</code>
		 * is used instead. If <code>defaultSelectedIcon</code> is also
		 * <code>null</code>, then <code>defaultIcon</code> is used.
		 *
		 * @see #defaultIcon
		 * @see #defaultSelectedIcon
		 */
		public function get selectedHoverIcon():DisplayObject
		{
			return this._selectedDownIcon;
		}

		/**
		 * @private
		 */
		public function set selectedHoverIcon(value:DisplayObject):void
		{
			if(this._selectedHoverIcon == value)
			{
				return;
			}

			if(this._selectedHoverIcon && this._selectedHoverIcon != this._defaultIcon && this._selectedHoverIcon != this._defaultSelectedIcon &&
				this._selectedHoverIcon != this._upIcon && this._selectedHoverIcon != this._downIcon &&
				this._selectedHoverIcon != this._hoverIcon &&  this._selectedHoverIcon != this._disabledIcon &&
				this._selectedHoverIcon != this._selectedUpIcon && this._selectedHoverIcon != this._selectedDownIcon &&
				this._selectedHoverIcon != this._selectedDisabledIcon)
			{
				this.removeChild(this._selectedHoverIcon);
			}
			this._selectedHoverIcon = value;
			if(this._selectedHoverIcon && this._selectedHoverIcon.parent != this)
			{
				this._selectedHoverIcon.visible = false;
				this.addChild(this._selectedHoverIcon);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _selectedDisabledIcon:DisplayObject;

		/**
		 * The icon used for the button's disabled state when the button is
		 * selected. If <code>null</code>, then <code>defaultSelectedIcon</code>
		 * is used instead. If <code>defaultSelectedIcon</code> is also
		 * <code>null</code>, then <code>defaultIcon</code> is used.
		 *
		 * @see #defaultIcon
		 * @see #defaultSelectedIcon
		 */
		public function get selectedDisabledIcon():DisplayObject
		{
			return this._selectedDisabledIcon;
		}

		/**
		 * @private
		 */
		public function set selectedDisabledIcon(value:DisplayObject):void
		{
			if(this._selectedDisabledIcon == value)
			{
				return;
			}

			if(this._selectedDisabledIcon && this._selectedDisabledIcon != this._defaultIcon && this._selectedDisabledIcon != this._defaultSelectedIcon &&
				this._selectedDisabledIcon != this._upIcon && this._selectedDisabledIcon != this._downIcon &&
				this._selectedDisabledIcon != this._hoverIcon && this._selectedDisabledIcon != this._disabledIcon &&
				this._selectedDisabledIcon != this._selectedUpIcon && this._selectedDisabledIcon != this._selectedDownIcon &&
				this._selectedDisabledIcon != this._selectedHoverIcon)
			{
				this.removeChild(this._selectedDisabledIcon);
			}
			this._selectedDisabledIcon = value;
			if(this._selectedDisabledIcon && this._selectedDisabledIcon.parent != this)
			{
				this._selectedDisabledIcon.visible = false;
				this.addChild(this._selectedDisabledIcon);
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
		private var _labelProperties:PropertyProxy = new PropertyProxy(labelProperties_onChange);

		/**
		 * A set of key/value pairs to be passed down to the buttons's label
		 * instance. The label is a Foxhole Label control.
		 *
		 * <p>If the sub-component has its own sub-components, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 */
		public function get labelProperties():Object
		{
			return this._labelProperties;
		}

		/**
		 * @private
		 */
		public function set labelProperties(value:Object):void
		{
			if(this._labelProperties == value)
			{
				return;
			}
			if(!value)
			{
				value = new PropertyProxy();
			}
			if(!(value is PropertyProxy))
			{
				const newValue:PropertyProxy = new PropertyProxy();
				for(var propertyName:String in value)
				{
					newValue[propertyName] = value[propertyName];
				}
				value = newValue;
			}
			if(this._labelProperties)
			{
				this._labelProperties.onChange.remove(labelProperties_onChange);
			}
			this._labelProperties = PropertyProxy(value);
			if(this._labelProperties)
			{
				this._labelProperties.onChange.add(labelProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
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
			if(this._stateToSkinFunction != null)
			{
				const oldSkin:DisplayObject = this.currentSkin;
				this.currentSkin = this._stateToSkinFunction(this, this._currentState, oldSkin);
				if(this.currentSkin != oldSkin)
				{
					this.removeChild(oldSkin, true);
					if(this.currentSkin)
					{
						this.addChildAt(this.currentSkin, 0);
					}
				}
			}
			else
			{
				this.currentSkin = null;
				for each(var stateName:String in this._stateNames)
				{
					var skinName:String = stateName + "Skin";
					if(this._currentState == stateName)
					{
						this.currentSkin = DisplayObject(this[skinName]);
					}
					else if(this[skinName])
					{
						DisplayObject(this[skinName]).visible = false;
					}
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
			if(this._stateToIconFunction != null)
			{
				const oldIcon:DisplayObject = this.currentIcon;
				this.currentIcon = this._stateToIconFunction(this, this._currentState, oldIcon);
				if(this.currentIcon != oldIcon)
				{
					this.removeChild(oldIcon, true);
					if(this.currentIcon)
					{
						this.addChild(this.currentIcon);
					}
				}
			}
			else
			{
				this.currentIcon = null;
				for each(var stateName:String in this._stateNames)
				{
					var iconName:String = stateName + "Icon";
					if(this._currentState == stateName)
					{
						this.currentIcon = DisplayObject(this[iconName]);
					}
					else if(this[iconName])
					{
						DisplayObject(this[iconName]).visible = false;
					}
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
			for(var propertyName:String in this._labelProperties)
			{
				if(this.labelControl.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._labelProperties[propertyName];
					this.labelControl[propertyName] = propertyValue;
				}
			}

			if(this._stateToTextFormatFunction != null)
			{
				var format:BitmapFontTextFormat = this._stateToTextFormatFunction(this, this._currentState);
			}
			else
			{
				const formatName:String = this._currentState + "TextFormat";
				format = BitmapFontTextFormat(this[formatName]);
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
		protected function labelProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
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

			const touches:Vector.<Touch> = event.getTouches(this);
			if(touches.length == 0)
			{
				//end of hover
				this.currentState = STATE_UP;
				return;
			}
			if(this._touchPointID >= 0)
			{
				var touch:Touch;
				for each(var currentTouch:Touch in touches)
				{
					if(currentTouch.id == this._touchPointID)
					{
						touch = currentTouch;
						break;
					}
				}

				if(!touch)
				{
					//end of hover
					this.currentState = STATE_UP;
					return;
				}

				var location:Point = touch.getLocation(this);
				ScrollRectManager.adjustTouchLocation(location, this);
				var isInBounds:Boolean = this.hitTest(location, true) != null;
				if(touch.phase == TouchPhase.MOVED)
				{
					if(isInBounds || this.keepDownStateOnRollOut)
					{
						this.currentState = STATE_DOWN;
					}
					else
					{
						this.currentState = STATE_UP;
					}
					return;
				}
				else if(touch.phase == TouchPhase.ENDED)
				{
					this._touchPointID = -1;
					if(isInBounds)
					{
						this._onRelease.dispatch(this);
						if(this._isToggle)
						{
							this.isSelected = !this._isSelected;
						}
						if(this._isHoverSupported)
						{
							location = touch.getLocation(this);
							location = this.localToGlobal(location);

							//we need to do a new hitTest() because a display
							//object may have appeared above this button that
							//will prevent clearing the hover state
							isInBounds = this.stage.hitTest(location, true) == this;
							this.currentState = (isInBounds && this._isHoverSupported) ? STATE_HOVER : STATE_UP;
						}
						else
						{
							this.currentState = STATE_UP;
						}
					}
					else
					{
						this.currentState = STATE_UP;
					}
					return;
				}
			}
			else //if we get here, we don't have a saved touch ID yet
			{
				for each(touch in touches)
				{
					if(touch.phase == TouchPhase.BEGAN)
					{
						this.currentState = STATE_DOWN;
						this._touchPointID = touch.id;
						this._onPress.dispatch(this);
						return;
					}
					else if(touch.phase == TouchPhase.HOVER)
					{
						this.currentState = STATE_HOVER;
						this._isHoverSupported = true;
						return;
					}
				}
			}
		}
	}
}