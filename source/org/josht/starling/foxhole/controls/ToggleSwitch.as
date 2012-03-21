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
	import com.gskinner.motion.GTween;
	
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import org.josht.starling.display.IDisplayObjectWithScrollRect;
	import org.josht.starling.display.Image;
	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.core.IToggle;
	import org.josht.starling.foxhole.text.BitmapFontTextFormat;
	import org.josht.starling.text.BitmapFont;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class ToggleSwitch extends FoxholeControl implements IToggle
	{
		private static const MINIMUM_DRAG_DISTANCE:Number = 0.04;
		
		public static const LABEL_ALIGN_MIDDLE:String = "middle";
		public static const LABEL_ALIGN_BASELINE:String = "baseline";
		
		public function ToggleSwitch()
		{
			super();
			this.addEventListener(TouchEvent.TOUCH, touchHandler);
		}
		
		protected var thumb:Button;
		protected var onLabelField:Label;
		protected var offLabelField:Label;
		protected var sampleThumbSkin:Image;
		
		protected var _onSkin:DisplayObject;
		
		public function get onSkin():DisplayObject
		{
			return this._onSkin;
		}
		
		public function set onSkin(value:DisplayObject):void
		{
			if(this._onSkin == value)
			{
				return;
			}
			
			if(this._onSkin)
			{
				this.removeChild(this._onSkin);
			}
			this._onSkin = value;
			if(this._onSkin)
			{
				if(this._onSkin is IDisplayObjectWithScrollRect)
				{
					var scrollRectSkin:IDisplayObjectWithScrollRect = IDisplayObjectWithScrollRect(this._onSkin);
					scrollRectSkin.scrollRect = null;
				}
				this.onSkinOriginalWidth = this._onSkin.width;
				this.onSkinOriginalHeight = this._onSkin.height;
				if(scrollRectSkin)
				{
					scrollRectSkin.scrollRect = new Rectangle();
				}
				this.addChildAt(this._onSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		protected var _offSkin:DisplayObject;
		
		public function get offSkin():DisplayObject
		{
			return this._offSkin;
		}
		
		public function set offSkin(value:DisplayObject):void
		{
			if(this._offSkin == value)
			{
				return;
			}
			
			if(this._offSkin)
			{
				this.removeChild(this._offSkin);
			}
			this._offSkin = value;
			if(this._offSkin)
			{
				if(this._offSkin is IDisplayObjectWithScrollRect)
				{
					var scrollRectSkin:IDisplayObjectWithScrollRect = IDisplayObjectWithScrollRect(this._offSkin);
					scrollRectSkin.scrollRect = null;
				}
				this.offSkinOriginalWidth = this._offSkin.width
				this.offSkinOriginalHeight = this._offSkin.height;
				if(scrollRectSkin)
				{
					scrollRectSkin.scrollRect = new Rectangle();
				}
				this.addChildAt(this._offSkin, 0);
			}
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
		
		protected var _showLabels:Boolean = true;
		
		public function get showLabels():Boolean
		{
			return _showLabels;
		}
		
		public function set showLabels(value:Boolean):void
		{
			if(this._showLabels == value)
			{
				return;
			}
			this._showLabels = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		private var _showThumb:Boolean = true;
		
		public function get showThumb():Boolean
		{
			return this._showThumb;
		}
		
		public function set showThumb(value:Boolean):void
		{
			if(this._showThumb == value)
			{
				return;
			}
			this._showThumb = value;
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
		
		private var _labelAlign:String = LABEL_ALIGN_BASELINE;

		public function get labelAlign():String
		{
			return this._labelAlign;
		}

		public function set labelAlign(value:String):void
		{
			if(this._labelAlign == value)
			{
				return;
			}
			this._labelAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		protected var onSkinOriginalWidth:Number = NaN;
		protected var onSkinOriginalHeight:Number = NaN;
		protected var offSkinOriginalWidth:Number = NaN;
		protected var offSkinOriginalHeight:Number = NaN;
		
		private var _backgroundBounds:Point;
		
		private var _isSelected:Boolean = false;
		
		public function get isSelected():Boolean
		{
			return this._isSelected;
		}
		
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
		
		private var _onText:String = "ON";
		
		public function get onText():String
		{
			return this._onText;
		}
		
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
		
		private var _offText:String = "OFF";
		
		public function get offText():String
		{
			return this._offText;
		}
		
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
		
		private var _onChange:Signal = new Signal(ToggleSwitch);
		
		public function get onChange():ISignal
		{
			return this._onChange;
		}
		
		private var _thumbProperties:Object = {};
		
		public function get thumbProperties():Object
		{
			return this._thumbProperties;
		}
		
		public function set thumbProperties(value:Object):void
		{
			if(this._thumbProperties == value)
			{
				return;
			}
			this._thumbProperties = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		public function setThumbProperty(propertyName:String, propertyValue:Object):void
		{
			this._thumbProperties[propertyName] = propertyValue;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		override public function dispose():void
		{
			this._onChange.removeAll();
			super.dispose();
		}
		
		override protected function initialize():void
		{
			if(!this.offLabelField)
			{
				this.offLabelField = new Label();
				this.offLabelField.scrollRect = new Rectangle();
				this.addChild(this.offLabelField);
			}
			
			if(!this.onLabelField)
			{
				this.onLabelField = new Label();
				this.onLabelField.scrollRect = new Rectangle();
				this.addChild(this.onLabelField);
			}
			
			if(!this.thumb)
			{
				this.thumb = new Button();
				this.thumb.label = "";
				this.thumb.keepDownStateOnRollOut = true;
				this.thumb.addEventListener(TouchEvent.TOUCH, thumb_touchHandler);
				this.addChild(this.thumb);
			}
		}
		
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			
			if(stylesInvalid || stateInvalid)
			{
				this.refreshLabelStyles();
				this.refreshThumbProperties();
			}
			
			if(isNaN(this._width))
			{
				this.thumb.validate();
				this._width = this.onSkinOriginalWidth + this.offSkinOriginalWidth - this.thumb.width;
				sizeInvalid = true;
			}
			
			if(isNaN(this._height))
			{
				this._height = Math.max(this.onSkinOriginalHeight, this.offSkinOriginalHeight);
				sizeInvalid = true;
			}
			
			if(stylesInvalid || sizeInvalid || stateInvalid)
			{
				this.scaleSkins();
				this.thumb.y = this._contentPadding;
				this.drawLabels();
			}
			
			this.thumb.validate();
			
			if(sizeInvalid || stylesInvalid || dataInvalid)
			{
				this.updateSelection();
			}
		}
		
		protected function updateSelection():void
		{
			var xPosition:Number = this.contentPadding;
			if(this._isSelected)
			{
				xPosition = this._width - this.thumb.width - this._contentPadding;
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
			this.updateScrollRects();
		}
		
		protected function refreshLabelStyles():void
		{	
			//no need to style the label field if there's no text to display
			if(!this._showLabels || !this._showThumb)
			{
				this.onLabelField.visible = this.offLabelField.visible = false;
				return;
			}
			
			var format:BitmapFontTextFormat;
			if(!this._isEnabled)
			{
				format = this._disabledTextFormat;
			}
			if(!format)
			{
				format = this._defaultTextFormat;
			}
			
			if(!format)
			{
				throw new IllegalOperationError("No text format defined for state \"" + (this._isEnabled ? "Enabled" : "Disabled") + "\" and there is no default value.");
			}
			this.onLabelField.textFormat = format;
			this.offLabelField.textFormat = format;
			this.onLabelField.text = this._onText;
			this.offLabelField.text = this._offText;
			this.onLabelField.validate();
			this.offLabelField.validate();
			this.onLabelField.visible = this.offLabelField.visible = true;
		}
		
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
		}
		
		private function scaleSkins():void
		{
			const skinScale:Number = this._height / Math.max(this.onSkinOriginalHeight, this.offSkinOriginalHeight);
			this.onSkin.width = this.onSkinOriginalWidth * skinScale;
			this.onSkin.height = this.onSkinOriginalHeight * skinScale;
			this.offSkin.width = this.offSkinOriginalWidth * skinScale;
			this.offSkin.height = this.offSkinOriginalHeight * skinScale;
			this.offSkin.y = this.onSkin.y = 0;
		}
		
		private function drawLabels():void
		{
			const maxLabelWidth:Number = Math.max(0, this._width - this.thumb.width - 2 * this._contentPadding);
			var totalLabelHeight:Number = Math.max(this.onLabelField.height, this.offLabelField.height);
			var labelHeight:Number;
			if(this._labelAlign == LABEL_ALIGN_MIDDLE || !(this.defaultTextFormat.font is BitmapFont))
			{
				labelHeight = totalLabelHeight;
			}
			else //baseline
			{
				const fontScale:Number = isNaN(this._defaultTextFormat.size) ? 1 : (this._defaultTextFormat.size / this._defaultTextFormat.font.size);
				labelHeight = fontScale * BitmapFont(this._defaultTextFormat.font).base;
			}
			
			var onScrollRect:Rectangle = this.onLabelField.scrollRect;
			onScrollRect.width = maxLabelWidth;
			onScrollRect.height = totalLabelHeight;
			this.onLabelField.scrollRect = onScrollRect;
			
			this.onLabelField.x = this._contentPadding;
			this.onLabelField.y = (this._height - labelHeight) / 2;
			
			var offScrollRect:Rectangle = this.offLabelField.scrollRect;
			offScrollRect.width = maxLabelWidth;
			offScrollRect.height = totalLabelHeight;
			this.offLabelField.scrollRect = offScrollRect;
			
			this.offLabelField.x = this._width - this._contentPadding - maxLabelWidth;
			this.offLabelField.y = (this._height - labelHeight) / 2;
		}
		
		private function updateScrollRects():void
		{
			const maxLabelWidth:Number = Math.max(0, this._width - this.thumb.width - 2 * this._contentPadding);
			const thumbOffset:Number = this.thumb.x - this._contentPadding;
			const halfWidth:Number = (this._width - 2 * this._contentPadding) / 2;
			const middleOfThumb:Number = this.thumb.x + this.thumb.width / 2;
			
			var currentScrollRect:Rectangle = this.onLabelField.scrollRect;
			currentScrollRect.x = this._width - this.thumb.width - thumbOffset - (maxLabelWidth - this.onLabelField.width) / 2;
			this.onLabelField.scrollRect = currentScrollRect;
			
			currentScrollRect = this.offLabelField.scrollRect;
			currentScrollRect.x = -thumbOffset - (maxLabelWidth - this.offLabelField.width) / 2;
			this.offLabelField.scrollRect = currentScrollRect;
			
			if(this._onSkin is IDisplayObjectWithScrollRect)
			{
				const onSkinScaledWidth:Number = this.onSkinOriginalWidth * this._onSkin.scaleX;
				//if the on and off skins are transparent, we don't want them to overlap at all
				var scrollRectSkin:IDisplayObjectWithScrollRect = IDisplayObjectWithScrollRect(this._onSkin);
				currentScrollRect = scrollRectSkin.scrollRect;
				currentScrollRect.width = Math.min(onSkinScaledWidth, middleOfThumb) / this._onSkin.scaleX;
				currentScrollRect.height = this._height / this._onSkin.scaleX;
				scrollRectSkin.scrollRect = currentScrollRect;
			}
			
			if(this._offSkin is IDisplayObjectWithScrollRect)
			{
				const offSkinScaledWidth:Number = this.offSkinOriginalWidth * this._offSkin.scaleX;
				this._offSkin.x = Math.max(this._width - offSkinScaledWidth, middleOfThumb);
				scrollRectSkin = IDisplayObjectWithScrollRect(this._offSkin);
				currentScrollRect = scrollRectSkin.scrollRect;
				currentScrollRect.width = Math.min(offSkinScaledWidth, this._width - middleOfThumb) / this._offSkin.scaleX;
				currentScrollRect.height = this._height / this._onSkin.scaleX;
				currentScrollRect.x = this.offSkinOriginalWidth - currentScrollRect.width;
				scrollRectSkin.scrollRect = currentScrollRect;
			}
			else
			{
				this._offSkin.x = this._width - this._offSkin.width;
			}
		}
		
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
			if(!touch || touch.phase != TouchPhase.ENDED)
			{
				return;
			}
			const location:Point = touch.getLocation(this);
			const isInBounds:Boolean = location.x >= 0 && location.y >= 0 && 
				location.x < this._width && location.y < this._height;
			if(isInBounds)
			{
				this.isSelected = !this._isSelected;
				this._isSelectionChangedByUser = true;
			}
		}
		
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
			
			const trackScrollableWidth:Number = this._width - 2 * this._contentPadding - this.thumb.width;
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
				const xPosition:Number = Math.min(Math.max(this._contentPadding, this._thumbStartX + xOffset), trackScrollableWidth);
				this.thumb.x = xPosition;
				this.updateScrollRects();
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
		
		private function selectionTween_onChange(tween:GTween):void
		{
			this.updateScrollRects();
		}
		
		private function selectionTween_onComplete(tween:GTween):void
		{
			this._selectionChangeTween = null;
		}
	}
}