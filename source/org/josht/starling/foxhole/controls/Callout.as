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
	import flash.geom.Rectangle;

	import org.josht.starling.foxhole.core.FoxholeControl;

	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.core.PopUpManager;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * A pop-up container that points at (or calls out) a specific region of
	 * the application (most likely a specific control).
	 */
	public class Callout extends FoxholeControl
	{
		/**
		 * Creates a callout, and then positions and sizes it automatically
		 * based on an origin rectangle. The provided width and height are
		 * optional, and these values may be ignored if the callout cannot be
		 * drawn at the specified dimensions.
		 */
		public static function showCallout(content:DisplayObject, globalOrigin:Rectangle, width:Number = NaN, height:Number = NaN):Callout
		{
			const callout:Callout = new Callout();
			callout.content = content;
			PopUpManager.addPopUp(callout, true, false, calloutOverlayFactory);
			callout.validate();

			callout.x = globalOrigin.x + globalOrigin.width;
			callout.y = globalOrigin.y + (globalOrigin.height - callout.height) / 2;

			return callout;
		}

		protected static function calloutOverlayFactory():DisplayObject
		{
			const quad:Quad = new Quad(100, 100, 0xff00ff);
			quad.alpha = 0;
			return quad;
		}

		/**
		 * Constructor.
		 */
		public function Callout()
		{
		}

		/**
		 * @private
		 */
		protected var _touchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _originalContentWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var _originalContentHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var _content:DisplayObject;

		/**
		 * The display object displayed by the callout. This object will be
		 * resized to fit the callout's bounds, and if it needs scrolling to
		 * fit into a smaller region, it should provide scrolling capabilities
		 * itself because the callout will not.
		 */
		public function get content():DisplayObject
		{
			return this._content;
		}

		/**
		 * @private
		 */
		public function set content(value:DisplayObject):void
		{
			if(this._content == value)
			{
				return;
			}
			if(this._content)
			{
				this._content.removeFromParent();
			}
			this._content = value;
			if(this._content)
			{
				this.addChild(this._content);
			}
			this._originalContentWidth = NaN;
			this._originalContentHeight = NaN;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _paddingTop:Number = 0;

		/**
		 * The minimum space, in pixels, between the callout's top edge and the
		 * callout's content.
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
		 * The minimum space, in pixels, between the callout's right edge and
		 * the callout's content.
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
		 * The minimum space, in pixels, between the callout's bottom edge and
		 * the callout's content.
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
		 * The minimum space, in pixels, between the callout's left edge and the
		 * callout's content.
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
		protected var _originalBackgroundWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var _originalBackgroundHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var currentBackground:DisplayObject;

		/**
		 * @private
		 */
		private var _backgroundSkin:DisplayObject;

		/**
		 * The primary background to display.
		 */
		public function get backgroundSkin():DisplayObject
		{
			return this._backgroundSkin;
		}

		/**
		 * @private
		 */
		public function set backgroundSkin(value:DisplayObject):void
		{
			if(this._backgroundSkin == value)
			{
				return;
			}

			if(this._backgroundSkin && this._backgroundSkin != this._backgroundDisabledSkin)
			{
				this.removeChild(this._backgroundSkin);
			}
			this._backgroundSkin = value;
			if(this._backgroundSkin && this._backgroundSkin.parent != this)
			{
				this._backgroundSkin.visible = false;
				this._backgroundSkin.touchable = false;
				this.addChildAt(this._backgroundSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _backgroundDisabledSkin:DisplayObject;

		/**
		 * A background to display when the progress bar is disabled.
		 */
		public function get backgroundDisabledSkin():DisplayObject
		{
			return this._backgroundDisabledSkin;
		}

		/**
		 * @private
		 */
		public function set backgroundDisabledSkin(value:DisplayObject):void
		{
			if(this._backgroundDisabledSkin == value)
			{
				return;
			}

			if(this._backgroundDisabledSkin && this._backgroundDisabledSkin != this._backgroundSkin)
			{
				this.removeChild(this._backgroundDisabledSkin);
			}
			this._backgroundDisabledSkin = value;
			if(this._backgroundDisabledSkin && this._backgroundDisabledSkin.parent != this)
			{
				this._backgroundDisabledSkin.visible = false;
				this._backgroundDisabledSkin.touchable = false;
				this.addChildAt(this._backgroundDisabledSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			this.stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);

			if(stylesInvalid || stateInvalid)
			{
				this.refreshBackground();
			}

			if(stateInvalid)
			{
				if(this._content is FoxholeControl)
				{
					FoxholeControl(this._content).isEnabled = this._isEnabled;
				}
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(sizeInvalid || stylesInvalid || dataInvalid || stateInvalid)
			{
				this.layout();
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

			const needsContentWidth:Boolean = isNaN(this._originalContentWidth);
			const needsContentHeight:Boolean = isNaN(this._originalContentHeight);
			if(needsContentWidth || needsContentHeight)
			{
				if(this._content is FoxholeControl)
				{
					FoxholeControl(this._content).validate();
				}
				if(needsContentWidth)
				{
					this._originalContentWidth = this._content.width;
				}
				if(needsContentHeight)
				{
					this._originalContentHeight = this._content.height;
				}
			}

			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth)
			{
				newWidth = this._originalContentWidth + this._paddingLeft + this._paddingRight;
				if(!isNaN(this._originalBackgroundWidth))
				{
					newWidth = Math.max(this._originalBackgroundWidth, newWidth);
				}
			}
			if(needsHeight)
			{
				newHeight = this._originalContentHeight + this._paddingTop + this._paddingBottom;
				if(!isNaN(this._originalBackgroundHeight))
				{
					newHeight = Math.max(this._originalBackgroundHeight, newHeight);
				}
			}
			this.setSizeInternal(newWidth, newHeight, false);
			return true;
		}

		/**
		 * @private
		 */
		protected function refreshBackground():void
		{
			this.currentBackground = this._backgroundSkin;
			if(this._backgroundDisabledSkin)
			{
				if(this._isEnabled)
				{
					this._backgroundDisabledSkin.visible = false;
				}
				else
				{
					this.currentBackground = this._backgroundDisabledSkin;
					if(this._backgroundSkin)
					{
						this._backgroundSkin.visible = false;
					}
				}
			}
			if(this.currentBackground)
			{
				if(isNaN(this._originalBackgroundWidth))
				{
					this._originalBackgroundWidth = this.currentBackground.width;
				}
				if(isNaN(this._originalBackgroundHeight))
				{
					this._originalBackgroundHeight = this.currentBackground.height;
				}
				this.currentBackground.visible = true;
			}
		}

		protected function layout():void
		{
			if(this.currentBackground)
			{
				this.currentBackground.x = 0;
				this.currentBackground.y = 0;
				this.currentBackground.width = this.actualWidth;
				this.currentBackground.height = this.actualHeight;
			}

			if(this._content)
			{
				this._content.x = this._paddingLeft;
				this._content.y = this._paddingTop;
				this._content.width = this.actualWidth - this._paddingLeft - this._paddingRight;
				this._content.height = this.actualHeight - this._paddingTop - this._paddingBottom;
			}
		}

		protected function removedFromStageHandler(event:Event):void
		{
			this.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
		}

		protected function stage_touchHandler(event:TouchEvent):void
		{
			if(event.interactsWith(this))
			{
				return;
			}
			const touch:Touch = event.getTouch(this.stage);
			if(!touch || (this._touchPointID >= 0 && this._touchPointID != touch.id))
			{
				return;
			}

			if(touch.phase == TouchPhase.BEGAN)
			{
				this._touchPointID = touch.id;
			}
			else if(this._touchPointID >= 0)
			{
				if(touch.phase == TouchPhase.ENDED)
				{
					PopUpManager.removePopUp(this, true);
					this._touchPointID = -1;
				}
			}
		}
	}
}
