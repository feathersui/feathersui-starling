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
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;

	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.text.StageTextField;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.utils.transformCoords;

	/**
	 * A text entry control that allows users to enter and edit a single line of
	 * uniformly-formatted text. Uses the native StageText class in AIR, and the
	 * custom StageTextField class in Flash Player.
	 *
	 * @see org.josht.text.StageTextField
	 */
	public class TextInput extends FoxholeControl
	{
		/**
		 * @private
		 */
		private static const helperMatrix:Matrix = new Matrix();

		/**
		 * @private
		 */
		private static const helperPoint:Point = new Point();

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_POSITION:String = "position";

		/**
		 * Constructor.
		 */
		public function TextInput()
		{
		}

		/**
		 * The StageText instance.
		 */
		protected var stageText:Object;

		/**
		 * The currently selected background, based on state.
		 */
		protected var currentBackground:DisplayObject;

		private var _oldGlobalX:Number = 0;
		private var _oldGlobalY:Number = 0;

		/**
		 * @private
		 */
		override public function set x(value:Number):void
		{
			super.x = value;
			//we need to know when the position changes to change the position
			//of the StageText instance.
			this.invalidate(INVALIDATION_FLAG_POSITION);
		}

		/**
		 * @private
		 */
		override public function set y(value:Number):void
		{
			super.y = value;
			this.invalidate(INVALIDATION_FLAG_POSITION);
		}

		/**
		 * @private
		 */
		protected var _text:String = "";

		/**
		 * The text displayed by the input.
		 */
		public function get text():String
		{
			return this._text;
		}

		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			if(!value)
			{
				//don't allow null or undefined
				value = "";
			}
			if(this._text == value)
			{
				return;
			}
			this._text = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
			this._onChange.dispatch(this);
		}

		/**
		 * @private
		 * The width of the first skin that was displayed.
		 */
		protected var _originalSkinWidth:Number = NaN;

		/**
		 * @private
		 * The height of the first skin that was displayed.
		 */
		protected var _originalSkinHeight:Number = NaN;

		/**
		 * @private
		 */
		private var _backgroundSkin:DisplayObject;

		/**
		 * A display object displayed behind the header's content.
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
		 * A background to display when the header is disabled.
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
		protected var _contentPadding:Number = 0;

		/**
		 * Space, in pixels, around the edges of the content.
		 */
		public function get contentPadding():Number
		{
			return _contentPadding;
		}

		/**
		 * @private
		 */
		public function set contentPadding(value:Number):void
		{
			if(this._contentPadding == value)
			{
				return;
			}
			this._contentPadding = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _onChange:Signal = new Signal(TextInput);

		/**
		 * Dispatched when the text changes.
		 */
		public function get onChange():ISignal
		{
			return this._onChange;
		}

		/**
		 * @private
		 */
		private var _stageTextProperties:Object = {};

		/**
		 * A set of key/value pairs to be passed down to the text input's
		 * StageText instance.
		 */
		public function get stageTextProperties():Object
		{
			return this._stageTextProperties;
		}

		/**
		 * @private
		 */
		public function set stageTextProperties(value:Object):void
		{
			if(this._stageTextProperties == value)
			{
				return;
			}
			if(!value)
			{
				value = {};
			}
			this._stageTextProperties = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * Sets a single property on the text input's StageText instance.
		 */
		public function setStageTextProperty(propertyName:String, propertyValue:Object):void
		{
			this._stageTextProperties[propertyName] = propertyValue;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this.stageText.removeEventListener(flash.events.Event.CHANGE, stageText_changeHandler);
			this.stageText.dispose();
			this.stageText = null;
			super.dispose();
		}

		/**
		 * @private
		 */
		override public function render(support:RenderSupport, alpha:Number):void
		{
			helperPoint.x = helperPoint.y = 0;
			this.getTransformationMatrix(this.stage, helperMatrix);
			transformCoords(helperMatrix, 0, 0, helperPoint);
			if(helperPoint.x != this._oldGlobalX || helperPoint.y != this._oldGlobalY)
			{
				this._oldGlobalX = helperPoint.x;
				this._oldGlobalY = helperPoint.y;
				var viewPort:Rectangle = this.stageText.viewPort;
				if(!viewPort)
				{
					viewPort = new Rectangle();
				}
				viewPort.x = (helperPoint.x + this._contentPadding * this.scaleX) * Starling.contentScaleFactor;
				viewPort.y = (helperPoint.y + this._contentPadding * this.scaleY) * Starling.contentScaleFactor;
				this.stageText.viewPort = viewPort;			
			}

			super.render(support, alpha);
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			this.addEventListener(starling.events.Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			var StageTextType:Class;
			try
			{
				StageTextType = Class(getDefinitionByName("flash.text.StageText"));
			}
			catch(error:Error)
			{
				StageTextType = StageTextField;
			}
			this.stageText = new StageTextType();
			this.stageText.stage = Starling.current.nativeStage;
			this.stageText.addEventListener(flash.events.Event.CHANGE, stageText_changeHandler);
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const positionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_POSITION);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);

			if(stylesInvalid)
			{
				this.refreshStageTextProperties();
			}

			if(dataInvalid)
			{
				if(this.stageText.text != this._text)
				{
					this.stageText.text = this._text;
				}
			}

			if(stateInvalid || stylesInvalid)
			{
				this.refreshBackground();
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(positionInvalid || sizeInvalid || stylesInvalid || stateInvalid)
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

			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth)
			{
				newWidth = this._originalSkinWidth;
			}
			if(needsHeight)
			{
				newHeight = this._originalSkinHeight;
			}
			this.setSizeInternal(newWidth, newHeight, false);
			return true;
		}

		/**
		 * @private
		 */
		protected function refreshStageTextProperties():void
		{
			for(var propertyName:String in this._stageTextProperties)
			{
				if(this.stageText.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._stageTextProperties[propertyName];
					this.stageText[propertyName] = propertyValue;
				}
			}
		}

		/**
		 * @private
		 */
		protected function refreshBackground():void
		{
			this.currentBackground = this._backgroundSkin;
			if(!this._isEnabled && this._backgroundDisabledSkin)
			{
				if(this._backgroundSkin)
				{
					this._backgroundSkin.visible = false;
					this._backgroundSkin.touchable = false;
				}
				this.currentBackground = this._backgroundDisabledSkin;
			}
			else if(this._backgroundDisabledSkin)
			{
				this._backgroundDisabledSkin.visible = false;
				this._backgroundDisabledSkin.touchable = false;
			}

			if(this.currentBackground)
			{
				if(isNaN(this._originalSkinWidth))
				{
					this._originalSkinWidth = this.currentBackground.width;
				}
				if(isNaN(this._originalSkinHeight))
				{
					this._originalSkinHeight = this.currentBackground.height;
				}
			}
		}

		/**
		 * @private
		 */
		protected function layout():void
		{
			if(this.currentBackground)
			{
				this.currentBackground.visible = true;
				this.currentBackground.touchable = true;
				this.currentBackground.width = this.actualWidth;
				this.currentBackground.height = this.actualHeight;
			}

			var viewPort:Rectangle = this.stageText.viewPort;
			if(!viewPort)
			{
				viewPort = new Rectangle();
			}

			helperPoint.x = helperPoint.y = 0;
			this.getTransformationMatrix(this.stage, helperMatrix);
			transformCoords(helperMatrix, 0, 0, helperPoint);
			this._oldGlobalX = helperPoint.x;
			this._oldGlobalY = helperPoint.y;
			viewPort.x = (helperPoint.x + this._contentPadding * this.scaleX) * Starling.contentScaleFactor;
			viewPort.y = (helperPoint.y + this._contentPadding * this.scaleY) * Starling.contentScaleFactor;
			viewPort.width = Math.max(1, (this.actualWidth - 2 * this._contentPadding ) * Starling.contentScaleFactor * this.scaleX);
			viewPort.height = Math.max(1, (this.actualHeight - 2 * this._contentPadding ) * Starling.contentScaleFactor * this.scaleY);
			if(isNaN(viewPort.width) || isNaN(viewPort.height))
			{
				viewPort.width = 1;
				viewPort.height = 1;
			}
			this.stageText.viewPort = viewPort;
		}

		/**
		 * @private
		 */
		protected function stageText_changeHandler(event:flash.events.Event):void
		{
			this.text = this.stageText.text;
		}

		/**
		 * @private
		 */
		protected function addedToStageHandler(event:starling.events.Event):void
		{
			if(event.target != this)
			{
				return;
			}

			this.stageText.visible = true;
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		/**
		 * @private
		 */
		protected function removedFromStageHandler(event:starling.events.Event):void
		{
			if(event.target != this)
			{
				return;
			}

			this.stageText.visible = false;
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler);
		}


	}
}
