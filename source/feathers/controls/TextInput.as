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
package feathers.controls
{
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.getDefinitionByName;

	import feathers.display.ScrollRectManager;
	import feathers.core.FeathersControl;
	import feathers.core.PropertyProxy;
	import feathers.text.StageTextField;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.ConcreteTexture;
	import starling.textures.Texture;
	import starling.utils.MatrixUtil;

	/**
	 * A text entry control that allows users to enter and edit a single line of
	 * uniformly-formatted text. Uses the native StageText class in AIR, and the
	 * custom StageTextField class in Flash Player.
	 *
	 * @see org.josht.text.StageTextField
	 */
	public class TextInput extends FeathersControl
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
			this.isQuickHitAreaEnabled = true;
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(starling.events.Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			this.addEventListener(TouchEvent.TOUCH, touchHandler);
		}

		/**
		 * The StageText instance. It's typed Object so that a replacement class
		 * can be used in browser-based Flash Player.
		 */
		protected var stageText:Object;

		/**
		 * @private
		 */
		protected var _touchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _measureTextField:TextField;

		/**
		 * @private
		 */
		protected var _stageTextHasFocus:Boolean = false;

		/**
		 * The currently selected background, based on state.
		 */
		protected var currentBackground:DisplayObject;

		/**
		 * @private
		 */
		private var _oldGlobalX:Number = 0;

		/**
		 * @private
		 */
		private var _oldGlobalY:Number = 0;

		/**
		 * @private
		 */
		private var _savedSelectionIndex:int = -1;

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
		 * Stores the snapshot of the StageText to display when the StageText
		 * isn't visible.
		 */
		protected var _textSnapshotBitmapData:BitmapData;

		/**
		 * @private
		 */
		protected var _textSnapshot:Image;

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
		protected var _paddingTop:Number = 0;

		/**
		 * The minimum space, in pixels, between the input's top edge and the
		 * input's content.
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
		 * The minimum space, in pixels, between the input's right edge and the
		 * input's content.
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
		 * The minimum space, in pixels, between the input's bottom edge and
		 * the input's content.
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
		 * The minimum space, in pixels, between the input's left edge and the
		 * input's content.
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
		 * Flag indicating that the StageText should get focus.
		 */
		protected var _isWaitingToSetFocus:Boolean = false;

		/**
		 * @private
		 */
		protected var _oldMouseCursor:String = null;

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
		protected var _onEnter:Signal = new Signal(TextInput);

		/**
		 * Dispatched when the user presses the Enter key while the text input
		 * has focus.
		 */
		public function get onEnter():ISignal
		{
			return this._onEnter;
		}

		/**
		 * @private
		 */
		private var _stageTextProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to the text input's
		 * StageText instance.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 */
		public function get stageTextProperties():Object
		{
			if(!this._stageTextProperties)
			{
				this._stageTextProperties = new PropertyProxy(stageTextProperties_onChange);
			}
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
			if(this._stageTextProperties)
			{
				this._stageTextProperties.onChange.remove(stageTextProperties_onChange);
			}
			this._stageTextProperties = PropertyProxy(value);
			if(this._stageTextProperties)
			{
				this._stageTextProperties.onChange.add(stageTextProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * Focuses the text input control so that it may be edited.
		 */
		public function setFocus():void
		{
			this.setFocusInternal(null);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			if(this._textSnapshotBitmapData)
			{
				this._textSnapshotBitmapData.dispose();
				this._textSnapshotBitmapData = null;
			}

			this._onChange.removeAll();
			super.dispose();
		}

		/**
		 * @private
		 */
		override public function render(support:RenderSupport, alpha:Number):void
		{
			super.render(support, alpha);
			helperPoint.x = helperPoint.y = 0;
			this.getTransformationMatrix(this.stage, helperMatrix);
			MatrixUtil.transformCoords(helperMatrix, 0, 0, helperPoint);
			ScrollRectManager.toStageCoordinates(helperPoint, this);
			if(helperPoint.x != this._oldGlobalX || helperPoint.y != this._oldGlobalY)
			{
				this._oldGlobalX = helperPoint.x;
				this._oldGlobalY = helperPoint.y;
				var viewPort:Rectangle = this.stageText.viewPort;
				if(!viewPort)
				{
					viewPort = new Rectangle();
				}
				viewPort.x = Math.round((helperPoint.x + this._paddingLeft * this.scaleX) * Starling.contentScaleFactor);
				viewPort.y = Math.round((helperPoint.y + this._paddingTop * this.scaleY) * Starling.contentScaleFactor);
				this.stageText.viewPort = viewPort;			
			}

			if(this._textSnapshot)
			{
				this._textSnapshot.x = Math.round(this._paddingLeft + helperMatrix.tx) - helperMatrix.tx;
				this._textSnapshot.y = Math.round(this._paddingTop + helperMatrix.ty) - helperMatrix.ty;
			}

			//theoretically, this will ensure that the StageText is set visible
			//or invisible immediately after the snapshot changes visibility in
			//the rendered graphics. the OS might take longer to do the change,
			//though.
			this.stageText.visible = this._textSnapshot ? !this._textSnapshot.visible : this._stageTextHasFocus;
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(!this._measureTextField)
			{
				this._measureTextField = new TextField();
				this._measureTextField.visible = false;
				this._measureTextField.mouseEnabled = this._measureTextField.mouseWheelEnabled = false;
				this._measureTextField.autoSize = TextFieldAutoSize.LEFT;
				this._measureTextField.multiline = false;
				this._measureTextField.wordWrap = false;
				this._measureTextField.embedFonts = false;
				this._measureTextField.defaultTextFormat = new TextFormat(null, 11, 0x000000, false, false, false);
				Starling.current.nativeStage.addChild(this._measureTextField);
			}
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
				this._measureTextField.text = this.stageText.text;
			}

			if(stateInvalid)
			{
				this.stageText.editable = this._isEnabled;
				if(!this._isEnabled && Mouse.supportsNativeCursor && this._oldMouseCursor)
				{
					Mouse.cursor = this._oldMouseCursor;
					this._oldMouseCursor = null;
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

			if(stylesInvalid || dataInvalid || sizeInvalid)
			{
				if(!this._stageTextHasFocus)
				{
					const hasText:Boolean = this._text.length > 0;
					if(hasText)
					{
						this.refreshSnapshot(sizeInvalid || !this._textSnapshotBitmapData);
					}
					if(this._textSnapshot)
					{
						this._textSnapshot.visible = hasText;
					}
				}
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
			return this.setSizeInternal(newWidth, newHeight, false);
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

			this._measureTextField.displayAsPassword = this.stageText.displayAsPassword;
			this._measureTextField.maxChars = this.stageText.maxChars;
			this._measureTextField.restrict = this.stageText.restrict;
			const format:TextFormat = this._measureTextField.defaultTextFormat;
			format.color = this.stageText.color;
			format.font = this.stageText.fontFamily;
			format.italic = this.stageText.fontPosture == FontPosture.ITALIC;
			format.size = this.stageText.fontSize;
			format.bold = this.stageText.fontWeight == FontWeight.BOLD;
			var alignValue:String = this.stageText.textAlign;
			if(alignValue == TextFormatAlign.START)
			{
				alignValue = TextFormatAlign.LEFT;
			}
			else if(alignValue == TextFormatAlign.END)
			{
				alignValue = TextFormatAlign.RIGHT;
			}
			format.align = alignValue;
			this._measureTextField.defaultTextFormat = format;
			this._measureTextField.setTextFormat(format);
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
		protected function refreshSnapshot(needsNewBitmap:Boolean):void
		{
			if(needsNewBitmap)
			{
				const viewPort:Rectangle = this.stageText.viewPort;
				if(viewPort.width == 0 || viewPort.height == 0)
				{
					return;
				}
				if(!this._textSnapshotBitmapData || this._textSnapshotBitmapData.width != viewPort.width || this._textSnapshotBitmapData.height != viewPort.height)
				{
					if(this._textSnapshotBitmapData)
					{
						this._textSnapshotBitmapData.dispose();
					}
					this._textSnapshotBitmapData = new BitmapData(viewPort.width, viewPort.height, true, 0x00ff00ff);
				}
			}

			if(!this._textSnapshotBitmapData)
			{
				return;
			}
			this._textSnapshotBitmapData.fillRect(this._textSnapshotBitmapData.rect, 0x00ff00ff);
			this.stageText.drawViewPortToBitmapData(this._textSnapshotBitmapData);
			if(!this._textSnapshot)
			{
				this._textSnapshot = new Image(starling.textures.Texture.fromBitmapData(this._textSnapshotBitmapData, false, false, Starling.contentScaleFactor));
				this.addChild(this._textSnapshot);
			}
			else
			{
				if(needsNewBitmap)
				{
					this._textSnapshot.texture.dispose();
					this._textSnapshot.texture = starling.textures.Texture.fromBitmapData(this._textSnapshotBitmapData, false, false, Starling.contentScaleFactor);
					this._textSnapshot.readjustSize();
				}
				else
				{
					//this is faster, so use it if we haven't resized the
					//bitmapdata
					const texture:starling.textures.Texture = this._textSnapshot.texture;
					if(Starling.handleLostContext && texture is ConcreteTexture)
					{
						ConcreteTexture(texture).restoreOnLostContext(this._textSnapshotBitmapData);
					}
					flash.display3D.textures.Texture(texture.base).uploadFromBitmapData(this._textSnapshotBitmapData);
				}
			}

			this.getTransformationMatrix(this.stage, helperMatrix);
			this._textSnapshot.x = Math.round(this._paddingLeft + helperMatrix.tx) - helperMatrix.tx;
			this._textSnapshot.y = Math.round(this._paddingTop + helperMatrix.ty) - helperMatrix.ty;
		}

		/**
		 * @private
		 */
		protected function setFocusInternal(touch:Touch):void
		{
			if(this.stageText)
			{
				if(touch)
				{
					touch.getLocation(this, helperPoint);
					helperPoint.x -= this._paddingLeft;
					helperPoint.y -= this._paddingTop;
					if(helperPoint.x < 0)
					{
						this._savedSelectionIndex = 0;
					}
					else
					{
						this._savedSelectionIndex = this._measureTextField.getCharIndexAtPoint(helperPoint.x, helperPoint.y);
						const bounds:Rectangle = this._measureTextField.getCharBoundaries(this._savedSelectionIndex);
						if(bounds && (bounds.x + bounds.width - helperPoint.x) < (helperPoint.x - bounds.x))
						{
							this._savedSelectionIndex++;
						}
					}
				}
				this.stageText.assignFocus();
			}
			else
			{
				this._isWaitingToSetFocus = true;
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

			this.refreshViewPort();
		}

		/**
		 * @private
		 */
		protected function refreshViewPort():void
		{
			var viewPort:Rectangle = this.stageText.viewPort;
			if(!viewPort)
			{
				viewPort = new Rectangle();
			}
			if(!this.stageText.stage)
			{
				this.stageText.stage = Starling.current.nativeStage;
			}

			helperPoint.x = helperPoint.y = 0;
			this.getTransformationMatrix(this.stage, helperMatrix);
			MatrixUtil.transformCoords(helperMatrix, 0, 0, helperPoint);
			ScrollRectManager.toStageCoordinates(helperPoint, this);
			this._oldGlobalX = helperPoint.x;
			this._oldGlobalY = helperPoint.y;
			viewPort.x = Math.round((helperPoint.x + this._paddingLeft * this.scaleX) * Starling.contentScaleFactor);
			viewPort.y = Math.round((helperPoint.y + this._paddingTop * this.scaleY) * Starling.contentScaleFactor);
			viewPort.width = Math.round(Math.max(1, (this.actualWidth - this._paddingLeft - this._paddingRight) * Starling.contentScaleFactor * this.scaleX));
			//we're ignoring padding bottom here to keep the descent from being cut off
			viewPort.height = Math.round(Math.max(1, (this.actualHeight - this._paddingTop) * Starling.contentScaleFactor * this.scaleY));
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
		protected function stageTextProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function addedToStageHandler(event:starling.events.Event):void
		{
			if(this._measureTextField && !this._measureTextField.parent)
			{
				Starling.current.nativeStage.addChild(this._measureTextField);
			}

			var StageTextType:Class;
			var initOptions:Object;
			try
			{
				StageTextType = Class(getDefinitionByName("flash.text.StageText"));
				const StageTextInitOptionsType:Class = Class(getDefinitionByName("flash.text.StageTextInitOptions"));
				initOptions = new StageTextInitOptionsType(false);
			}
			catch(error:Error)
			{
				StageTextType = StageTextField;
				initOptions = { multiline: false };
			}
			this.stageText = new StageTextType(initOptions);
			this.stageText.visible = false;
			this.stageText.addEventListener(Event.CHANGE, stageText_changeHandler);
			this.stageText.addEventListener(KeyboardEvent.KEY_DOWN, stageText_keyDownHandler);
			this.stageText.addEventListener(FocusEvent.FOCUS_IN, stageText_focusInHandler);
			this.stageText.addEventListener(FocusEvent.FOCUS_OUT, stageText_focusOutHandler);
			this.stageText.addEventListener(Event.COMPLETE, stageText_completeHandler);
		}

		/**
		 * @private
		 */
		protected function removedFromStageHandler(event:starling.events.Event):void
		{
			Starling.current.nativeStage.removeChild(this._measureTextField);

			this._touchPointID = -1;

			this.stageText.removeEventListener(Event.CHANGE, stageText_changeHandler);
			this.stageText.removeEventListener(KeyboardEvent.KEY_DOWN, stageText_keyDownHandler);
			this.stageText.removeEventListener(FocusEvent.FOCUS_IN, stageText_focusInHandler);
			this.stageText.removeEventListener(FocusEvent.FOCUS_OUT, stageText_focusOutHandler);
			this.stageText.removeEventListener(Event.COMPLETE, stageText_completeHandler);
			this.stageText.stage = null;
			this.stageText.dispose();
			this.stageText = null;
		}

		/**
		 * @private
		 */
		protected function touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				return;
			}

			const touches:Vector.<Touch> = event.getTouches(this);
			if(touches.length == 0)
			{
				//end hover
				if(Mouse.supportsNativeCursor && this._oldMouseCursor)
				{
					Mouse.cursor = this._oldMouseCursor;
					this._oldMouseCursor = null;
				}
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
					//end hover
					if(Mouse.supportsNativeCursor && this._oldMouseCursor)
					{
						Mouse.cursor = this._oldMouseCursor;
						this._oldMouseCursor = null;
					}
					return;
				}
				if(touch.phase == TouchPhase.ENDED)
				{
					this._touchPointID = -1;
					touch.getLocation(this, helperPoint);
					ScrollRectManager.adjustTouchLocation(helperPoint, this);
					var isInBounds:Boolean = this.hitTest(helperPoint, true) != null;
					if(!this._stageTextHasFocus && isInBounds)
					{
						this.setFocusInternal(touch);
					}
					return;
				}
			}
			else
			{
				for each(touch in touches)
				{
					if(touch.phase == TouchPhase.HOVER)
					{
						if(Mouse.supportsNativeCursor && !this._oldMouseCursor)
						{
							this._oldMouseCursor = Mouse.cursor;
							Mouse.cursor = MouseCursor.IBEAM;
						}
						return;
					}
					else if(touch.phase == TouchPhase.BEGAN)
					{
						this._touchPointID = touch.id;
						return;
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function stageText_changeHandler(event:Event):void
		{
			this.text = this.stageText.text;
		}

		/**
		 * @private
		 */
		protected function stageText_completeHandler(event:Event):void
		{
			this.stageText.removeEventListener(Event.COMPLETE, stageText_completeHandler);
			this.invalidate();

			if(this._isWaitingToSetFocus && this._text)
			{
				this.validate();
				this.setFocus();
			}
		}

		/**
		 * @private
		 */
		protected function stageText_focusInHandler(event:FocusEvent):void
		{
			this._stageTextHasFocus = true;
			if(this._textSnapshot)
			{
				this._textSnapshot.visible = false;
			}
			if(this._savedSelectionIndex < 0)
			{
				//we can't detect what character was tapped, so put the cursor at
				//the end of the text
				this._savedSelectionIndex = this.stageText.text.length;
			}
			this.stageText.selectRange(this._savedSelectionIndex, this._savedSelectionIndex);
			this._savedSelectionIndex = -1;
		}

		/**
		 * @private
		 */
		protected function stageText_focusOutHandler(event:FocusEvent):void
		{
			this._stageTextHasFocus = false;
			//since StageText doesn't expose its scroll position, we need to
			//set the selection back to the beginning to scroll there. it's a
			//hack, but so is everything about StageText.
			//in other news, why won't 0,0 work here?
			this.stageText.selectRange(1, 1);

			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected function stageText_keyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ENTER)
			{
				this._onEnter.dispatch(this);
			}
			else if(event.keyCode == Keyboard.BACK)
			{
				//even a listener on the stage won't detect the back key press that
				//will close the application if the StageText has focus, so we
				//always need to prevent it here
				event.preventDefault();
				Starling.current.nativeStage.focus = Starling.current.nativeStage;
			}
		}
	}
}
