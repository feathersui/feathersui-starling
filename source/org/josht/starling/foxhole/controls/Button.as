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
	import org.josht.starling.foxhole.skins.StateWithToggleValueSelector;
	import org.josht.starling.foxhole.text.BitmapFontTextFormat;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.display.DisplayObject;
	import starling.events.Event;
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
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
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
			return this._currentState;
		}
		
		/**
		 * @private
		 */
		protected function set currentState(value:String):void
		{
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
		protected var _isToggle:Boolean = false;
		
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
		protected var _isSelected:Boolean = false;
		
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
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this._onChange.dispatch(this);
		}
		
		/**
		 * @private
		 */
		protected var _iconPosition:String = ICON_POSITION_LEFT;
		
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
		protected var _gap:Number = 10;
		
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
			STATE_UP, STATE_DOWN, STATE_HOVER, STATE_DISABLED
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
		 * Chooses an appropriate skin based on the state and the selection.
		 */
		protected var _skinSelector:StateWithToggleValueSelector = new StateWithToggleValueSelector();
		
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
			return DisplayObject(this._skinSelector.defaultValue);
		}
		
		/**
		 * @private
		 */
		public function set defaultSkin(value:DisplayObject):void
		{
			if(this._skinSelector.defaultValue == value)
			{
				return;
			}
			this._skinSelector.defaultValue = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
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
			return DisplayObject(this._skinSelector.defaultSelectedValue);
		}
		
		/**
		 * @private
		 */
		public function set defaultSelectedSkin(value:DisplayObject):void
		{
			if(this._skinSelector.defaultSelectedValue == value)
			{
				return;
			}
			this._skinSelector.defaultSelectedValue = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * The skin used for the button's up state. If <code>null</code>, then
		 * <code>defaultSkin</code> is used instead.
		 * 
		 * @see #defaultSkin
		 * @see #selectedUpSkin
		 */
		public function get upSkin():DisplayObject
		{
			return DisplayObject(this._skinSelector.getValueForState(STATE_UP, false));
		}
		
		/**
		 * @private
		 */
		public function set upSkin(value:DisplayObject):void
		{
			if(this._skinSelector.getValueForState(STATE_UP, false) == value)
			{
				return;
			}
			this._skinSelector.setValueForState(value, STATE_UP, false);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * The skin used for the button's down state. If <code>null</code>, then
		 * <code>defaultSkin</code> is used instead.
		 * 
		 * @see #defaultSkin
		 * @see #selectedDownSkin
		 */
		public function get downSkin():DisplayObject
		{
			return DisplayObject(this._skinSelector.getValueForState(STATE_DOWN, false));
		}
		
		/**
		 * @private
		 */
		public function set downSkin(value:DisplayObject):void
		{
			if(this._skinSelector.getValueForState(STATE_DOWN, false) == value)
			{
				return;
			}
			this._skinSelector.setValueForState(value, STATE_DOWN, false);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * The skin used for the button's hover state. If <code>null</code>, then
		 * <code>defaultSkin</code> is used instead.
		 *
		 * @see #defaultSkin
		 * @see #selectedHoverSkin
		 */
		public function get hoverSkin():DisplayObject
		{
			return DisplayObject(this._skinSelector.getValueForState(STATE_HOVER, false));
		}

		/**
		 * @private
		 */
		public function set hoverSkin(value:DisplayObject):void
		{
			if(this._skinSelector.getValueForState(STATE_HOVER, false) == value)
			{
				return;
			}
			this._skinSelector.setValueForState(value, STATE_HOVER, false);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * The skin used for the button's disabled state. If <code>null</code>,
		 * then <code>defaultSkin</code> is used instead.
		 * 
		 * @see #defaultSkin
		 * @see #selectedDisabledSkin
		 */
		public function get disabledSkin():DisplayObject
		{
			return DisplayObject(this._skinSelector.getValueForState(STATE_DISABLED, false));
		}
		
		/**
		 * @private
		 */
		public function set disabledSkin(value:DisplayObject):void
		{
			if(this._skinSelector.getValueForState(STATE_DISABLED, false) == value)
			{
				return;
			}
			this._skinSelector.setValueForState(value, STATE_DISABLED, false);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
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
			return DisplayObject(this._skinSelector.getValueForState(STATE_UP, true));
		}
		
		/**
		 * @private
		 */
		public function set selectedUpSkin(value:DisplayObject):void
		{
			if(this._skinSelector.getValueForState(STATE_UP, true) == value)
			{
				return;
			}
			this._skinSelector.setValueForState(value, STATE_UP, true);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
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
			return DisplayObject(this._skinSelector.getValueForState(STATE_DOWN, true));
		}
		
		/**
		 * @private
		 */
		public function set selectedDownSkin(value:DisplayObject):void
		{
			if(this._skinSelector.getValueForState(STATE_DOWN, true) == value)
			{
				return;
			}
			this._skinSelector.setValueForState(value, STATE_DOWN, true);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

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
			return DisplayObject(this._skinSelector.getValueForState(STATE_HOVER, true));
		}

		/**
		 * @private
		 */
		public function set selectedHoverSkin(value:DisplayObject):void
		{
			if(this._skinSelector.getValueForState(STATE_HOVER, true) == value)
			{
				return;
			}
			this._skinSelector.setValueForState(value, STATE_HOVER, true);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

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
			return DisplayObject(this._skinSelector.getValueForState(STATE_DISABLED, true));
		}

		/**
		 * @private
		 */
		public function set selectedDisabledSkin(value:DisplayObject):void
		{
			if(this._skinSelector.getValueForState(STATE_DISABLED, true) == value)
			{
				return;
			}
			this._skinSelector.setValueForState(value, STATE_DISABLED, true);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		protected var _textFormatSelector:StateWithToggleValueSelector = new StateWithToggleValueSelector();
		
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
			return BitmapFontTextFormat(this._textFormatSelector.defaultValue);
		}
		
		/**
		 * @private
		 */
		public function set defaultTextFormat(value:BitmapFontTextFormat):void
		{
			this._textFormatSelector.defaultValue = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * The text format used for the button's up state. If <code>null</code>,
		 * then <code>defaultTextFormat</code> is used instead.
		 * 
		 * @see #defaultTextFormat
		 * @see #selectedUpTextFormat
		 */
		public function get upTextFormat():BitmapFontTextFormat
		{
			return BitmapFontTextFormat(this._textFormatSelector.getValueForState(STATE_UP, false));
		}
		
		/**
		 * @private
		 */
		public function set upTextFormat(value:BitmapFontTextFormat):void
		{
			this._textFormatSelector.setValueForState(value, STATE_UP, false);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * The text format used for the button's down state. If <code>null</code>,
		 * then <code>defaultTextFormat</code> is used instead.
		 * 
		 * @see #defaultTextFormat
		 * @see #selectedDownTextFormat
		 */
		public function get downTextFormat():BitmapFontTextFormat
		{
			return BitmapFontTextFormat(this._textFormatSelector.getValueForState(STATE_DOWN, false));
		}
		
		/**
		 * @private
		 */
		public function set downTextFormat(value:BitmapFontTextFormat):void
		{
			this._textFormatSelector.setValueForState(value, STATE_DOWN, false);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * The text format used for the button's hover state. If <code>null</code>,
		 * then <code>defaultTextFormat</code> is used instead.
		 *
		 * @see #defaultTextFormat
		 * @see #selectedHoverTextFormat
		 */
		public function get hoverTextFormat():BitmapFontTextFormat
		{
			return BitmapFontTextFormat(this._textFormatSelector.getValueForState(STATE_HOVER, false));
		}

		/**
		 * @private
		 */
		public function set hoverTextFormat(value:BitmapFontTextFormat):void
		{
			this._textFormatSelector.setValueForState(value, STATE_HOVER, false);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * The text format used for the button's disabled state. If <code>null</code>,
		 * then <code>defaultTextFormat</code> is used instead.
		 * 
		 * @see #defaultTextFormat
		 * @see #selectedDisabledTextFormat
		 */
		public function get disabledTextFormat():BitmapFontTextFormat
		{
			return BitmapFontTextFormat(this._textFormatSelector.getValueForState(STATE_DISABLED, false));
		}
		
		/**
		 * @private
		 */
		public function set disabledTextFormat(value:BitmapFontTextFormat):void
		{
			this._textFormatSelector.setValueForState(value, STATE_DISABLED, false);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
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
			return BitmapFontTextFormat(this._textFormatSelector.defaultSelectedValue);
		}
		
		/**
		 * @private
		 */
		public function set defaultSelectedTextFormat(value:BitmapFontTextFormat):void
		{
			this._textFormatSelector.defaultSelectedValue = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
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
			return BitmapFontTextFormat(this._textFormatSelector.getValueForState(STATE_UP, true));
		}
		
		/**
		 * @private
		 */
		public function set selectedUpTextFormat(value:BitmapFontTextFormat):void
		{
			this._textFormatSelector.setValueForState(value, STATE_UP, true);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
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
			return BitmapFontTextFormat(this._textFormatSelector.getValueForState(STATE_DOWN, true));
		}
		
		/**
		 * @private
		 */
		public function set selectedDownTextFormat(value:BitmapFontTextFormat):void
		{
			this._textFormatSelector.setValueForState(value, STATE_DOWN, true);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

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
			return BitmapFontTextFormat(this._textFormatSelector.getValueForState(STATE_HOVER, true));
		}

		/**
		 * @private
		 */
		public function set selectedHoverTextFormat(value:BitmapFontTextFormat):void
		{
			this._textFormatSelector.setValueForState(value, STATE_HOVER, true);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

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
			return BitmapFontTextFormat(this._textFormatSelector.getValueForState(STATE_DISABLED, true));
		}

		/**
		 * @private
		 */
		public function set selectedDisabledTextFormat(value:BitmapFontTextFormat):void
		{
			this._textFormatSelector.setValueForState(value, STATE_DISABLED, true);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		protected var _iconSelector:StateWithToggleValueSelector = new StateWithToggleValueSelector();
		
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
			return DisplayObject(this._iconSelector.defaultValue);
		}
		
		/**
		 * @private
		 */
		public function set defaultIcon(value:DisplayObject):void
		{
			if(this._iconSelector.defaultValue == value)
			{
				return;
			}
			this._iconSelector.defaultValue = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
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
			return DisplayObject(this._iconSelector.defaultSelectedValue);
		}
		
		/**
		 * @private
		 */
		public function set defaultSelectedIcon(value:DisplayObject):void
		{
			if(this._iconSelector.defaultSelectedValue == value)
			{
				return;
			}
			this._iconSelector.defaultSelectedValue = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * The icon used for the button's up state. If <code>null</code>, then
		 * <code>defaultIcon</code> is used instead.
		 * 
		 * @see #defaultIcon
		 * @see #selectedUpIcon
		 */
		public function get upIcon():DisplayObject
		{
			return DisplayObject(this._iconSelector.getValueForState(STATE_UP, false));
		}
		
		/**
		 * @private
		 */
		public function set upIcon(value:DisplayObject):void
		{
			if(this._iconSelector.getValueForState(STATE_UP, false) == value)
			{
				return;
			}
			this._iconSelector.setValueForState(value, STATE_UP, false);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * The icon used for the button's down state. If <code>null</code>, then
		 * <code>defaultIcon</code> is used instead.
		 * 
		 * @see #defaultIcon
		 * @see #selectedDownIcon
		 */
		public function get downIcon():DisplayObject
		{
			return DisplayObject(this._iconSelector.getValueForState(STATE_DOWN, false));
		}
		
		/**
		 * @private
		 */
		public function set downIcon(value:DisplayObject):void
		{
			if(this._iconSelector.getValueForState(STATE_DOWN, false) == value)
			{
				return;
			}
			this._iconSelector.setValueForState(value, STATE_DOWN, false);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * The icon used for the button's hover state. If <code>null</code>, then
		 * <code>defaultIcon</code> is used instead.
		 *
		 * @see #defaultIcon
		 * @see #selectedDownIcon
		 */
		public function get hoverIcon():DisplayObject
		{
			return DisplayObject(this._iconSelector.getValueForState(STATE_HOVER, false));
		}

		/**
		 * @private
		 */
		public function set hoverIcon(value:DisplayObject):void
		{
			if(this._iconSelector.getValueForState(STATE_HOVER, false) == value)
			{
				return;
			}
			this._iconSelector.setValueForState(value, STATE_HOVER, false);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * The icon used for the button's disabled state. If <code>null</code>, then
		 * <code>defaultIcon</code> is used instead.
		 * 
		 * @see #defaultIcon
		 * @see #selectedDisabledIcon
		 */
		public function get disabledIcon():DisplayObject
		{
			return DisplayObject(this._iconSelector.getValueForState(STATE_DISABLED, false));
		}
		
		/**
		 * @private
		 */
		public function set disabledIcon(value:DisplayObject):void
		{
			if(this._iconSelector.getValueForState(STATE_DISABLED, false) == value)
			{
				return;
			}
			this._iconSelector.setValueForState(value, STATE_DISABLED, false);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
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
			return DisplayObject(this._iconSelector.getValueForState(STATE_UP, true));
		}
		
		/**
		 * @private
		 */
		public function set selectedUpIcon(value:DisplayObject):void
		{
			if(this._iconSelector.getValueForState(STATE_UP, true) == value)
			{
				return;
			}
			this._iconSelector.setValueForState(value, STATE_UP, true);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
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
			return DisplayObject(this._iconSelector.getValueForState(STATE_DOWN, true));
		}
		
		/**
		 * @private
		 */
		public function set selectedDownIcon(value:DisplayObject):void
		{
			if(this._iconSelector.getValueForState(STATE_DOWN, true) == value)
			{
				return;
			}
			this._iconSelector.setValueForState(value, STATE_DOWN, true);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

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
			return DisplayObject(this._iconSelector.getValueForState(STATE_HOVER, true));
		}

		/**
		 * @private
		 */
		public function set selectedHoverIcon(value:DisplayObject):void
		{
			if(this._iconSelector.getValueForState(STATE_HOVER, true) == value)
			{
				return;
			}
			this._iconSelector.setValueForState(value, STATE_HOVER, true);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

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
			return DisplayObject(this._iconSelector.getValueForState(STATE_DISABLED, true));
		}

		/**
		 * @private
		 */
		public function set selectedDisabledIcon(value:DisplayObject):void
		{
			if(this._iconSelector.getValueForState(STATE_DISABLED, true) == value)
			{
				return;
			}
			this._iconSelector.setValueForState(value, STATE_DISABLED, true);
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
		private var _labelProperties:PropertyProxy;

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
			if(!this._labelProperties)
			{
				this._labelProperties = new PropertyProxy(labelProperties_onChange);
			}
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
			const selectedInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			
			if(dataInvalid)
			{
				this.refreshLabelData();
			}

			if(stylesInvalid || stateInvalid || selectedInvalid)
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
			
			if(stylesInvalid || stateInvalid || selectedInvalid || sizeInvalid)
			{
				this.scaleSkin();
			}
			
			if(stylesInvalid || stateInvalid || selectedInvalid || dataInvalid || sizeInvalid)
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
			const oldSkin:DisplayObject = this.currentSkin;
			if(this._stateToSkinFunction != null)
			{
				this.currentSkin = DisplayObject(this._stateToSkinFunction(this, this._currentState, oldSkin));
			}
			else
			{
				this.currentSkin = DisplayObject(this._skinSelector.updateValue(this, this._currentState, this.currentSkin));
			}
			if(this.currentSkin != oldSkin)
			{
				if(oldSkin)
				{
					this.removeChild(oldSkin, false);
				}
				if(this.currentSkin)
				{
					this.addChildAt(this.currentSkin, 0);
				}
			}
		}
		
		/**
		 * @private
		 */
		protected function refreshIcon():void
		{
			const oldIcon:DisplayObject = this.currentIcon;
			if(this._stateToIconFunction != null)
			{
				this.currentIcon = DisplayObject(this._stateToIconFunction(this, this._currentState, oldIcon));
			}
			else
			{
				this.currentIcon = DisplayObject(this._iconSelector.updateValue(this, this._currentState, this.currentIcon));
			}
			if(this.currentIcon != oldIcon)
			{
				if(oldIcon)
				{
					this.removeChild(oldIcon, false);
				}
				if(this.currentIcon)
				{
					this.addChild(this.currentIcon);
				}
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
				var format:BitmapFontTextFormat = BitmapFontTextFormat(this._stateToTextFormatFunction(this, this._currentState));
			}
			else
			{
				format = BitmapFontTextFormat(this._textFormatSelector.updateValue(this, this._currentState));
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
		protected function removedFromStageHandler(event:Event):void
		{
			this._touchPointID = -1;
			this.currentState = STATE_UP;
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
						this._onRelease.dispatch(this);
						if(this._isToggle)
						{
							this.isSelected = !this._isSelected;
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