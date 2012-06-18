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
	import flash.geom.Rectangle;
	import flash.system.Capabilities;

	import org.josht.starling.display.IDisplayObjectWithScrollRect;
	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.core.IToggle;
	import org.josht.starling.foxhole.core.PropertyProxy;
	import org.josht.starling.foxhole.text.BitmapFontTextFormat;
	import org.josht.starling.motion.GTween;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Similar to a light switch. May be selected or not, like a check box.
	 */
	public class ToggleSwitch extends FoxholeControl implements IToggle
	{
		/**
		 * @private
		 * The minimum physical distance (in inches) that a touch must move
		 * before the scroller starts scrolling.
		 */
		private static const MINIMUM_DRAG_DISTANCE:Number = 0.04;

		/**
		 * The ON and OFF labels will be aligned to the middle vertically,
		 * based on the full character height of the font.
		 */
		public static const LABEL_ALIGN_MIDDLE:String = "middle";

		/**
		 * The ON and OFF labels will be aligned to the middle vertically,
		 * based on only the baseline value of the font.
		 */
		public static const LABEL_ALIGN_BASELINE:String = "baseline";

		/**
		 * The toggle switch has only one track skin, stretching to fill the
		 * full length of switch. In this layout mode, the on track is
		 * displayed, but the off track is hidden.
		 */
		public static const TRACK_LAYOUT_MODE_SINGLE:String = "single";

		/**
		 * The switch's on and off track skins will by resized by changing
		 * their width and height values. Consider using a special display
		 * object such as a Scale9Image, Scale3Image or a TiledImage if the
		 * skins should be resizable.
		 */
		public static const TRACK_LAYOUT_MODE_STRETCH:String = "stretch";

		/**
		 * The switch's on and off track skins will be resized and cropped
		 * using a scrollRect to ensure that the skins maintain a static
		 * appearance without altering the aspect ratio.
		 */
		public static const TRACK_LAYOUT_MODE_SCROLL:String = "scroll";

		/**
		 * Constructor.
		 */
		public function ToggleSwitch()
		{
			super();
			this.addEventListener(TouchEvent.TOUCH, touchHandler);
		}

		/**
		 * The value added to the <code>nameList</code> of the off label.
		 */
		protected var defaultOnLabelName:String = "foxhole-toggle-switch-off-label";

		/**
		 * The value added to the <code>nameList</code> of the on label.
		 */
		protected var defaultOffLabelName:String = "foxhole-toggle-switch-on-label";

		/**
		 * The value added to the <code>nameList</code> of the thumb.
		 */
		protected var defaultThumbName:String = "foxhole-toggle-switch-thumb";

		/**
		 * @private
		 */
		protected var thumb:Button;

		/**
		 * @private
		 */
		protected var onLabelControl:Label;

		/**
		 * @private
		 */
		protected var offLabelControl:Label;

		/**
		 * @private
		 */
		protected var _onTrackSkin:DisplayObject;

		/**
		 * The background skin for the left side of the toggle switch, where the
		 * ON label is displayed.
		 */
		public function get onTrackSkin():DisplayObject
		{
			return this._onTrackSkin;
		}

		/**
		 * @private
		 */
		public function set onTrackSkin(value:DisplayObject):void
		{
			if(this._onTrackSkin == value)
			{
				return;
			}

			if(this._onTrackSkin)
			{
				this.removeChild(this._onTrackSkin);
			}
			this._onTrackSkin = value;
			if(this._onTrackSkin)
			{
				this.onTrackSkinOriginalWidth = this._onTrackSkin.width;
				this.onTrackSkinOriginalHeight = this._onTrackSkin.height;
				this.addChildAt(this._onTrackSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _offTrackSkin:DisplayObject;

		/**
		 * The background skin for the right side of the toggle switch, where
		 * the OFF label is displayed.
		 */
		public function get offTrackSkin():DisplayObject
		{
			return this._offTrackSkin;
		}

		/**
		 * @private
		 */
		public function set offTrackSkin(value:DisplayObject):void
		{
			if(this._offTrackSkin == value)
			{
				return;
			}

			if(this._offTrackSkin)
			{
				this.removeChild(this._offTrackSkin);
			}
			this._offTrackSkin = value;
			if(this._offTrackSkin)
			{
				this.offTrackSkinOriginalWidth = this._offTrackSkin.width
				this.offTrackSkinOriginalHeight = this._offTrackSkin.height;
				this.addChildAt(this._offTrackSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingRight:Number = 0;

		/**
		 * The minimum space, in pixels, between the switch's right edge and the
		 * switch's content.
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
		protected var _paddingLeft:Number = 0;

		/**
		 * The minimum space, in pixels, between the switch's left edge and the
		 * switch's content.
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
		protected var _showLabels:Boolean = true;

		/**
		 * Determines if the labels should be drawn. The onTrackSkin and
		 * offTrackSkin backgrounds may include the text instead.
		 */
		public function get showLabels():Boolean
		{
			return _showLabels;
		}

		/**
		 * @private
		 */
		public function set showLabels(value:Boolean):void
		{
			if(this._showLabels == value)
			{
				return;
			}
			this._showLabels = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _showThumb:Boolean = true;

		/**
		 * Determines if the thumb should be displayed. This stops interaction
		 * while still displaying the background.
		 */
		public function get showThumb():Boolean
		{
			return this._showThumb;
		}

		/**
		 * @private
		 */
		public function set showThumb(value:Boolean):void
		{
			if(this._showThumb == value)
			{
				return;
			}
			this._showThumb = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _trackLayoutMode:String = TRACK_LAYOUT_MODE_SINGLE;

		/**
		 * Determines how the on and off track skins are positioned and sized.
		 */
		public function get trackLayoutMode():String
		{
			return this._trackLayoutMode;
		}

		/**
		 * @private
		 */
		public function set trackLayoutMode(value:String):void
		{
			if(this._trackLayoutMode == value)
			{
				return;
			}
			this._trackLayoutMode = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _defaultTextFormat:BitmapFontTextFormat;

		/**
		 * The text format used to display the labels, if no higher priority
		 * format is available. For the ON label, <code>onTextFormat</code>
		 * takes priority. For the OFF label, <code>offTextFormat</code> takes
		 * priority.
		 *
		 * @see #onTextFormat
		 * @see #offTextFormat
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
		protected var _disabledTextFormat:BitmapFontTextFormat;

		/**
		 * The text format used to display the labels if the toggle switch is
		 * disabled. If <code>null</code>, then <code>defaultTextFormat</code>
		 * will be used instead.
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
		protected var _onTextFormat:BitmapFontTextFormat;

		/**
		 * The text format used to display the ON label. If <code>null</code>,
		 * then <code>defaultTextFormat</code> will be used instead.
		 */
		public function get onTextFormat():BitmapFontTextFormat
		{
			return this._onTextFormat;
		}

		/**
		 * @private
		 */
		public function set onTextFormat(value:BitmapFontTextFormat):void
		{
			this._onTextFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _offTextFormat:BitmapFontTextFormat;

		/**
		 * The text format used to display the OFF label. If <code>null</code>,
		 * then <code>defaultTextFormat</code> will be used instead.
		 */
		public function get offTextFormat():BitmapFontTextFormat
		{
			return this._offTextFormat;
		}

		/**
		 * @private
		 */
		public function set offTextFormat(value:BitmapFontTextFormat):void
		{
			this._offTextFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _labelAlign:String = LABEL_ALIGN_BASELINE;

		/**
		 * The vertical alignment of the label.
		 */
		public function get labelAlign():String
		{
			return this._labelAlign;
		}

		/**
		 * @private
		 */
		public function set labelAlign(value:String):void
		{
			if(this._labelAlign == value)
			{
				return;
			}
			this._labelAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var onTrackSkinOriginalWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var onTrackSkinOriginalHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var offTrackSkinOriginalWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var offTrackSkinOriginalHeight:Number = NaN;

		/**
		 * @private
		 */
		private var _isSelected:Boolean = false;

		/**
		 * Indicates if the toggle switch is selected (ON) or not (OFF).
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
			//normally, we'd check to see if selected actually changed or not
			//but the animation is triggered by the draw cycle, so we always
			//need to invalidate. notice that the signal isn't dispatched
			//unless the value changes.
			const oldSelected:Boolean = this._isSelected;
			this._isSelected = value;
			this._isSelectionChangedByUser = false;
			this.invalidate(INVALIDATION_FLAG_DATA, INVALIDATION_FLAG_SELECTED);
			if(this._isSelected != oldSelected)
			{
				this._onChange.dispatch(this);
			}
		}

		/**
		 * @private
		 */
		private var _onText:String = "ON";

		/**
		 * The text to display in the ON label.
		 */
		public function get onText():String
		{
			return this._onText;
		}

		/**
		 * @private
		 */
		public function set onText(value:String):void
		{
			if(!value)
			{
				//don't allow null or undefined
				value = "";
			}
			if(this._onText == value)
			{
				return;
			}
			this._onText = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _offText:String = "OFF";

		/**
		 * The text to display in the OFF label.
		 */
		public function get offText():String
		{
			return this._offText;
		}

		/**
		 * @private
		 */
		public function set offText(value:String):void
		{
			if(!value)
			{
				//don't allow null or undefined
				value = "";
			}
			if(this._offText == value)
			{
				return;
			}
			this._offText = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		private var _selectionChangeTween:GTween;

		private var _ignoreTapHandler:Boolean = false;
		private var _touchPointID:int = -1;
		private var _thumbStartX:Number;
		private var _touchStartX:Number;
		private var _isSelectionChangedByUser:Boolean = false;

		/**
		 * @private
		 */
		protected var _onChange:Signal = new Signal(ToggleSwitch);

		/**
		 * Dispatched when the selection changes.
		 */
		public function get onChange():ISignal
		{
			return this._onChange;
		}

		/**
		 * @private
		 */
		private var _thumbProperties:PropertyProxy = new PropertyProxy(thumbProperties_onChange);

		/**
		 * A set of key/value pairs to be passed down to the toggle switch's
		 * thumb instance. The thumb is a Foxhole Button control.
		 */
		public function get thumbProperties():Object
		{
			return this._thumbProperties;
		}

		/**
		 * @private
		 */
		public function set thumbProperties(value:Object):void
		{
			if(this._thumbProperties == value)
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
			if(this._thumbProperties)
			{
				this._thumbProperties.onChange.remove(thumbProperties_onChange);
			}
			this._thumbProperties = PropertyProxy(value);
			if(this._thumbProperties)
			{
				this._thumbProperties.onChange.add(thumbProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			this._onChange.removeAll();
			super.dispose();
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(!this.offLabelControl)
			{
				this.offLabelControl = new Label();
				this.offLabelControl.nameList.add(this.defaultOffLabelName);
				this.offLabelControl.scrollRect = new Rectangle();
				this.addChild(this.offLabelControl);
			}

			if(!this.onLabelControl)
			{
				this.onLabelControl = new Label();
				this.onLabelControl.nameList.add(this.defaultOnLabelName);
				this.onLabelControl.scrollRect = new Rectangle();
				this.addChild(this.onLabelControl);
			}

			if(!this.thumb)
			{
				this.thumb = new Button();
				this.thumb.nameList.add(this.defaultThumbName);
				this.thumb.label = "";
				this.thumb.keepDownStateOnRollOut = true;
				this.thumb.addEventListener(TouchEvent.TOUCH, thumb_touchHandler);
				this.addChild(this.thumb);
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

			if(stylesInvalid || stateInvalid)
			{
				this.refreshOnLabelStyles();
				this.refreshOffLabelStyles();
				this.refreshThumbProperties();
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(stylesInvalid || sizeInvalid || stateInvalid)
			{
				this.thumb.y = (this.actualHeight - this.thumb.height) / 2;
				this.drawLabels();
			}

			if(sizeInvalid || stylesInvalid || dataInvalid)
			{
				this.updateSelection();
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

			this.thumb.validate();

			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth)
			{
				if(this._trackLayoutMode == TRACK_LAYOUT_MODE_SCROLL || this._trackLayoutMode == TRACK_LAYOUT_MODE_STRETCH)
				{
					newWidth = Math.min(this.onTrackSkinOriginalWidth, this.offTrackSkinOriginalWidth) + this.thumb.width / 2;
				}
				else
				{
					newWidth = this.onTrackSkinOriginalWidth;
				}
			}

			if(needsHeight)
			{
				if(this._trackLayoutMode == TRACK_LAYOUT_MODE_SCROLL || this._trackLayoutMode == TRACK_LAYOUT_MODE_STRETCH)
				{
					newHeight = Math.max(this.onTrackSkinOriginalHeight, this.offTrackSkinOriginalHeight);
				}
				else
				{
					newHeight = this.onTrackSkinOriginalHeight;
				}
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		protected function updateSelection():void
		{
			var xPosition:Number = this._paddingLeft;
			if(this._isSelected)
			{
				xPosition = this.actualWidth - this.thumb.width - this._paddingRight;
			}

			//stop the tween, no matter what
			if(this._selectionChangeTween)
			{
				this._selectionChangeTween.paused = true;
				this._selectionChangeTween = null;
			}

			if(this._isSelectionChangedByUser)
			{
				this._selectionChangeTween = new GTween(this.thumb, 0.15,
				{
					x: xPosition
				},
				{
					onChange: selectionTween_onChange,
					onComplete: selectionTween_onComplete
				});
			}
			else
			{
				this.thumb.x = xPosition;
			}
			this._isSelectionChangedByUser = false;

			//we want to be sure that the onLabel isn't visible behind the thumb
			//on init so that if we fade out the toggle switch alpha, on won't
			//suddenly appear due to the way that flash changes alpha values
			//of containers.
			this.layout();
		}

		/**
		 * @private
		 */
		protected function refreshOnLabelStyles():void
		{
			//no need to style the label field if there's no text to display
			if(!this._showLabels || !this._showThumb)
			{
				this.onLabelControl.visible = false;
				return;
			}

			var format:BitmapFontTextFormat;
			if(!this._isEnabled)
			{
				format = this._disabledTextFormat;
			}
			if(!format && this._onTextFormat)
			{
				format = this._onTextFormat;
			}
			if(!format)
			{
				format = this._defaultTextFormat;
			}

			this.onLabelControl.text = this._onText;
			if(format)
			{
				this.onLabelControl.textFormat = format;
			}
			this.onLabelControl.validate();
			this.onLabelControl.visible = true;
		}

		/**
		 * @private
		 */
		protected function refreshOffLabelStyles():void
		{
			//no need to style the label field if there's no text to display
			if(!this._showLabels || !this._showThumb)
			{
				this.offLabelControl.visible = false;
				return;
			}

			var format:BitmapFontTextFormat;
			if(!this._isEnabled)
			{
				format = this._disabledTextFormat;
			}
			if(!format && this._offTextFormat)
			{
				format = this._offTextFormat;
			}
			if(!format)
			{
				format = this._defaultTextFormat;
			}

			this.offLabelControl.text = this._offText;
			if(format)
			{
				this.offLabelControl.textFormat = format;
			}
			this.offLabelControl.validate();
			this.offLabelControl.visible = true;
		}

		/**
		 * @private
		 */
		protected function refreshThumbProperties():void
		{
			for(var propertyName:String in this._thumbProperties)
			{
				if(this.thumb.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._thumbProperties[propertyName];
					this.thumb[propertyName] = propertyValue;
				}
			}
			this.thumb.visible = this._showThumb;
			this.thumb.isEnabled = this._isEnabled;
		}

		/**
		 * @private
		 */
		private function drawLabels():void
		{
			const maxLabelWidth:Number = Math.max(0, this.actualWidth - this.thumb.width - this._paddingLeft - this._paddingRight);
			var totalLabelHeight:Number = Math.max(this.onLabelControl.height, this.offLabelControl.height);
			var labelHeight:Number;
			if(this._labelAlign == LABEL_ALIGN_MIDDLE || !this._defaultTextFormat)
			{
				labelHeight = totalLabelHeight;
			}
			else //baseline
			{
				const fontScale:Number = isNaN(this._defaultTextFormat.size) ? 1 : (this._defaultTextFormat.size / this._defaultTextFormat.font.size);
				labelHeight = fontScale * this._defaultTextFormat.font.baseline;
			}

			var onScrollRect:Rectangle = this.onLabelControl.scrollRect;
			onScrollRect.width = maxLabelWidth;
			onScrollRect.height = totalLabelHeight;
			this.onLabelControl.scrollRect = onScrollRect;

			this.onLabelControl.x = this._paddingLeft;
			this.onLabelControl.y = (this.actualHeight - labelHeight) / 2;

			var offScrollRect:Rectangle = this.offLabelControl.scrollRect;
			offScrollRect.width = maxLabelWidth;
			offScrollRect.height = totalLabelHeight;
			this.offLabelControl.scrollRect = offScrollRect;

			this.offLabelControl.x = this.actualWidth - this._paddingRight - maxLabelWidth;
			this.offLabelControl.y = (this.actualHeight - labelHeight) / 2;
		}

		/**
		 * @private
		 */
		protected function layout():void
		{
			const maxLabelWidth:Number = Math.max(0, this.actualWidth - this.thumb.width - this._paddingLeft - this._paddingRight);
			const thumbOffset:Number = this.thumb.x - this._paddingLeft;

			var currentScrollRect:Rectangle = this.onLabelControl.scrollRect;
			currentScrollRect.x = this.actualWidth - this.thumb.width - thumbOffset - (maxLabelWidth - this.onLabelControl.width) / 2;
			this.onLabelControl.scrollRect = currentScrollRect;

			currentScrollRect = this.offLabelControl.scrollRect;
			currentScrollRect.x = -thumbOffset - (maxLabelWidth - this.offLabelControl.width) / 2;
			this.offLabelControl.scrollRect = currentScrollRect;

			if(this._trackLayoutMode == TRACK_LAYOUT_MODE_SCROLL)
			{
				this.layoutTrackWithScrollRect();
			}
			else if(this._trackLayoutMode == TRACK_LAYOUT_MODE_STRETCH)
			{
				this.layoutTrackWithStretch();
			}
			else
			{
				this.layoutTrackWithSingle();
			}
		}

		/**
		 * @private
		 */
		protected function layoutTrackWithStretch():void
		{
			this._offTrackSkin.visible = true;
			if(this._onTrackSkin is IDisplayObjectWithScrollRect)
			{
				IDisplayObjectWithScrollRect(this._onTrackSkin).scrollRect = null;
			}
			if(this._offTrackSkin is IDisplayObjectWithScrollRect)
			{
				IDisplayObjectWithScrollRect(this._offTrackSkin).scrollRect = null;
			}
			this._onTrackSkin.width = this.thumb.x + this.thumb.width / 2;
			this._onTrackSkin.height = this.actualHeight;
			this._offTrackSkin.x = this._onTrackSkin.width;
			this._offTrackSkin.width = this.actualWidth - this._offTrackSkin.x;
			this._offTrackSkin.height = this.actualHeight;
		}

		/**
		 * @private
		 */
		protected function layoutTrackWithScrollRect():void
		{
			this._offTrackSkin.visible = true;

			//we want to scale the skins to match the height of the switch, but
			//we also want to keep the original aspect ratio of the skins.
			const onTrackSkinScaledWidth:Number = this.onTrackSkinOriginalWidth * this.actualHeight / this.onTrackSkinOriginalHeight;
			const offTrackSkinScaledWidth:Number = this.offTrackSkinOriginalWidth * this.actualHeight / this.offTrackSkinOriginalHeight;

			this._onTrackSkin.width = onTrackSkinScaledWidth;
			this._onTrackSkin.height = this.actualHeight;
			this._offTrackSkin.width = offTrackSkinScaledWidth;
			this._offTrackSkin.height = this.actualHeight;

			const middleOfThumb:Number = this.thumb.x + this.thumb.width / 2;
			if(this._onTrackSkin is IDisplayObjectWithScrollRect)
			{
				//if the on and off skins are transparent, we don't want them to overlap at all
				var scrollRectSkin:IDisplayObjectWithScrollRect = IDisplayObjectWithScrollRect(this._onTrackSkin);
				var currentScrollRect:Rectangle = scrollRectSkin.scrollRect;
				if(!currentScrollRect)
				{
					currentScrollRect = new Rectangle();
				}
				currentScrollRect.width = Math.min(onTrackSkinScaledWidth, middleOfThumb) / this._onTrackSkin.scaleX;
				currentScrollRect.height = this.actualHeight / this._onTrackSkin.scaleY;
				scrollRectSkin.scrollRect = currentScrollRect;
			}

			if(this._offTrackSkin is IDisplayObjectWithScrollRect)
			{
				this._offTrackSkin.x = Math.max(this.actualWidth - offTrackSkinScaledWidth, middleOfThumb);
				scrollRectSkin = IDisplayObjectWithScrollRect(this._offTrackSkin);
				currentScrollRect = scrollRectSkin.scrollRect;
				if(!currentScrollRect)
				{
					currentScrollRect = new Rectangle();
				}
				currentScrollRect.width = Math.min(offTrackSkinScaledWidth, this.actualWidth - middleOfThumb) / this._offTrackSkin.scaleX;
				currentScrollRect.height = this.actualHeight / this._offTrackSkin.scaleY;
				currentScrollRect.x = Math.max(0, offTrackSkinScaledWidth / this._offTrackSkin.scaleX - currentScrollRect.width);
				scrollRectSkin.scrollRect = currentScrollRect;
			}
			else
			{
				this._offTrackSkin.x = this.actualWidth - this._offTrackSkin.width;
			}
		}

		/**
		 * @private
		 */
		protected function layoutTrackWithSingle():void
		{
			if(this._onTrackSkin is IDisplayObjectWithScrollRect)
			{
				IDisplayObjectWithScrollRect(this._onTrackSkin).scrollRect = null;
			}
			this._onTrackSkin.x = 0;
			this._onTrackSkin.y = 0;
			this._onTrackSkin.width = this.actualWidth;
			this._onTrackSkin.height = this.actualHeight;
			if(this._offTrackSkin)
			{
				this._offTrackSkin.visible = false;
			}
		}

		/**
		 * @private
		 */
		protected function thumbProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private function touchHandler(event:TouchEvent):void
		{
			if(this._ignoreTapHandler)
			{
				this._ignoreTapHandler = false;
				return;
			}
			if(!this._isEnabled)
			{
				return;
			}
			const touch:Touch = event.getTouch(this);
			if(!touch)
			{
				return;
			}

			event.stopPropagation();
			if(touch.phase == TouchPhase.ENDED)
			{
				const location:Point = touch.getLocation(this);
				if(this.hitTest(location, true))
				{
					this.isSelected = !this._isSelected;
					this._isSelectionChangedByUser = true;
				}
			}
		}

		/**
		 * @private
		 */
		private function thumb_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				return;
			}
			const touch:Touch = event.getTouch(this.thumb);
			if(!touch || (this._touchPointID >= 0 && this._touchPointID != touch.id))
			{
				return;
			}

			const trackScrollableWidth:Number = this.actualWidth - this._paddingLeft - this._paddingRight - this.thumb.width;
			const location:Point = touch.getLocation(this);
			if(touch.phase == TouchPhase.BEGAN)
			{
				this._touchPointID = touch.id;
				this._thumbStartX = this.thumb.x;
				this._touchStartX = location.x;
			}
			else if(touch.phase == TouchPhase.MOVED)
			{
				const xOffset:Number = location.x - this._touchStartX;
				const xPosition:Number = Math.min(Math.max(this._paddingLeft, this._thumbStartX + xOffset), trackScrollableWidth);
				this.thumb.x = xPosition;
				this.layout();
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				this._touchPointID = -1;
				const inchesMoved:Number = Math.abs(location.x - this._touchStartX) / Capabilities.screenDPI;
				if(inchesMoved > MINIMUM_DRAG_DISTANCE)
				{
					this.isSelected = this.thumb.x > (trackScrollableWidth / 2);
					this._isSelectionChangedByUser = true;
					this._ignoreTapHandler = true;
				}
			}
		}

		/**
		 * @private
		 */
		private function selectionTween_onChange(tween:GTween):void
		{
			this.layout();
		}

		/**
		 * @private
		 */
		private function selectionTween_onComplete(tween:GTween):void
		{
			this._selectionChangeTween = null;
		}
	}
}