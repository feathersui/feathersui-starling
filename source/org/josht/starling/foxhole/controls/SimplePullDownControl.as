package org.josht.starling.foxhole.controls
{
	import org.josht.starling.foxhole.controls.Label;
	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.text.BitmapFontTextFormat;

	import starling.display.DisplayObject;

	/**
	 * The default pull down control for AdvancedList.
	 *
	 * @see AdvancedList
	 */
	public class SimplePullDownControl extends FoxholeControl implements IPullDownControl
	{				

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
		 * @private
		 */
		protected var _currentState:String = AdvancedList.CONTROL_STATE_BASE;

		/**
		 * @private
		 */
		public function get currentState():String
		{
			return _currentState;
		}

		/**
		 * @private
		 */
		public function set currentState(value:String):void
		{			
			this._currentState = value;
			this.invalidate(INVALIDATION_FLAG_STATE);
		}

		/**
		 * @private
		 */
		protected var _contentPadding:Number = 0;

		/**
		 * The minimum space, in pixels, between the button's edges and the
		 * button's content.
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
		protected var labelField:Label;

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
		protected var _draggingLabel:String = "";

		/**
		 * The text displayed on the control when dragging to ready state.
		 */
		public function get draggingLabel():String
		{
			return this._draggingLabel;
		}

		/**
		 * @private
		 */
		public function set draggingLabel(value:String):void
		{
			if(!value)
			{
				//don't allow null or undefined
				value = "";
			}
			if(this._draggingLabel == value)
			{
				return;
			}
			this._draggingLabel = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _readyLabel:String = "";

		/**
		 * The text displayed on the control in ready state.
		 */
		public function get readyLabel():String
		{
			return this._readyLabel;
		}

		/**
		 * @private
		 */
		public function set readyLabel(value:String):void
		{
			if(!value)
			{
				//don't allow null or undefined
				value = "";
			}
			if(this._readyLabel == value)
			{
				return;
			}
			this._readyLabel = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _releasedLabel:String = "";

		/**
		 * The text displayed on the control in released state.
		 */
		public function get releasedLabel():String
		{
			return this._releasedLabel;
		}

		/**
		 * @private
		 */
		public function set releasedLabel(value:String):void
		{
			if(!value)
			{
				//don't allow null or undefined
				value = "";
			}
			if(this._releasedLabel == value)
			{
				return;
			}
			this._releasedLabel = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
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
		 * @see iconPosition
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
		 * @see draggingSkin
		 * @see readySkin
		 * @see releasedSkin
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

			if(this._defaultSkin &&	this._defaultSkin != this._draggingSkin && 
				this._defaultSkin != this._readySkin &&
				this._defaultSkin != this._releasedSkin)
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
		protected var _draggingSkin:DisplayObject;

		/**
		 * The skin used for the button's dragging state. If <code>null</code>, then
		 * <code>defaultSkin</code> is used instead.
		 *
		 * @see defaultSkin
		 */
		public function get draggingSkin():DisplayObject
		{
			return this._draggingSkin;
		}

		/**
		 * @private
		 */
		public function set draggingSkin(value:DisplayObject):void
		{
			if(this._draggingSkin == value)
			{
				return;
			}

			if(this._draggingSkin && this._draggingSkin != this._defaultSkin && 
				this._draggingSkin != this._readySkin && this._draggingSkin != this._releasedSkin)
			{
				this.removeChild(this._draggingSkin);
			}
			this._draggingSkin = value;
			if(this._draggingSkin && this._draggingSkin.parent != this)
			{
				this._draggingSkin.visible = false;
				this.addChildAt(this._draggingSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _readySkin:DisplayObject;

		/**
		 * The skin used for the button's ready state. If <code>null</code>, then
		 * <code>defaultSkin</code> is used instead.
		 *
		 * @see defaultSkin
		 */
		public function get readySkin():DisplayObject
		{
			return this._readySkin;
		}

		/**
		 * @private
		 */
		public function set readySkin(value:DisplayObject):void
		{
			if(this._readySkin == value)
			{
				return;
			}

			if(this._readySkin && this._readySkin != this._defaultSkin && 
				this._readySkin != this._draggingSkin && this._readySkin != this._releasedSkin)
			{
				this.removeChild(this._readySkin);
			}
			this._readySkin = value;
			if(this._readySkin && this._readySkin.parent != this)
			{
				this._readySkin.visible = false;
				this.addChildAt(this._readySkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _releasedSkin:DisplayObject;

		/**
		 * The skin used for the button's released state. If <code>null</code>,
		 * then <code>defaultSkin</code> is used instead.
		 *
		 * @see defaultSkin
		 */
		public function get releasedSkin():DisplayObject
		{
			return this._releasedSkin;
		}

		/**
		 * @private
		 */
		public function set releasedSkin(value:DisplayObject):void
		{
			if(this._releasedSkin == value)
			{
				return;
			}

			if(this._releasedSkin && this._releasedSkin != this._defaultSkin && 
				this._releasedSkin != this._draggingSkin && this._releasedSkin != this._readySkin)
			{
				this.removeChild(this._releasedSkin);
			}
			this._releasedSkin = value;
			if(this._releasedSkin && this._releasedSkin.parent != this)
			{
				this._releasedSkin.visible = false;
				this.addChildAt(this._releasedSkin, 0);
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
		 * @see upTextFormat
		 * @see downTextFormat
		 * @see disabledTextFormat
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
		private var _defaultIcon:DisplayObject;

		/**
		 * The icon used when no other icon is defined for the current state.
		 * Intended for use when multiple states should use the same icon.
		 *
		 * @see draggingIcon
		 * @see readyIcon
		 * @see releasedIcon
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

			if(this._defaultIcon && this._defaultIcon != this._draggingIcon && this._defaultIcon != this._readyIcon && 
				this._defaultIcon != this._releasedIcon)
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
		private var _draggingIcon:DisplayObject;

		/**
		 * The icon used for the button's up state. If <code>null</code>, then
		 * <code>defaultIcon</code> is used instead.
		 *
		 * @see defaultIcon
		 */
		public function get draggingIcon():DisplayObject
		{
			return this._draggingIcon;
		}

		/**
		 * @private
		 */
		public function set draggingIcon(value:DisplayObject):void
		{
			if(this._draggingIcon == value)
			{
				return;
			}

			if(this._draggingIcon && this._draggingIcon != this._defaultIcon && 
				this._draggingIcon != this._readyIcon && 
				this._draggingIcon != this._releasedIcon)
			{
				this.removeChild(this._draggingIcon);
			}
			this._draggingIcon = value;
			if(this._draggingIcon && this._draggingIcon.parent != this)
			{
				this._draggingIcon.visible = false;
				this.addChild(this._draggingIcon);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _releasedIcon:DisplayObject;

		/**
		 * The icon used for the button's released state. If <code>null</code>, then
		 * <code>defaultIcon</code> is used instead.
		 *
		 * @see defaultIcon
		 */
		public function get releasedIcon():DisplayObject
		{
			return this._releasedIcon;
		}

		/**
		 * @private
		 */
		public function set releasedIcon(value:DisplayObject):void
		{
			if(this._releasedIcon == value)
			{
				return;
			}

			if(this._releasedIcon && this._releasedIcon != this._defaultIcon && 
				this._releasedIcon != this._draggingIcon && 
				this._releasedIcon != this._readyIcon)
			{
				this.removeChild(this._releasedIcon);
			}
			this._releasedIcon = value;
			if(this._releasedIcon && this._releasedIcon.parent != this)
			{
				this._releasedIcon.visible = false;
				this.addChild(this._releasedIcon);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _readyIcon:DisplayObject;

		/**
		 * The icon used for the button's down state. If <code>null</code>, then
		 * <code>defaultIcon</code> is used instead.
		 *
		 * @see defaultIcon
		 */
		public function get readyIcon():DisplayObject
		{
			return this._readyIcon;
		}

		/**
		 * @private
		 */
		public function set readyIcon(value:DisplayObject):void
		{
			if(this._readyIcon == value)
			{
				return;
			}

			if(this._readyIcon && this._readyIcon != this._defaultIcon && 
				this._readyIcon != this._draggingIcon && 
				this._readyIcon != this._releasedIcon)
			{
				this.removeChild(this._readyIcon);
			}
			this._readyIcon = value;
			if(this._readyIcon && this._readyIcon.parent != this)
			{
				this._readyIcon.visible = false;
				this.addChild(this._readyIcon);
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

		public function SimplePullDownControl()
		{
			super();		
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(!this.labelField)
			{
				this.labelField = new Label();
				this.labelField.nameList.add("foxhole-pulldownbutton-label");
				this.addChild(this.labelField);
			}
		}

		protected function refreshLabel():void
		{
			var text:String = draggingLabel;
			switch(_currentState)
			{								
				case AdvancedList.CONTROL_STATE_READY:
				{
					text=readyLabel;
					break;
				}
				case AdvancedList.CONTROL_STATE_RELEASED:
				{
					text=releasedLabel;
					break;
				}				
			}

			this.labelField.text = text;
			this.labelField.visible = (text != null);
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

			if(dataInvalid || stateInvalid)			
				refreshLabel();			

			if(stylesInvalid || stateInvalid)
			{
				this.refreshSkin();
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
				this.labelField.validate();
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
			var newWidth:Number = this.stage.stageWidth - 2 * contentPadding;
			var newHeight:Number = this.explicitHeight;

			if(needsHeight)
			{
				if(this.currentIcon && this.labelField.text)
				{
					newHeight = Math.max(this.currentIcon.height, this.labelField.height);
				}
				else if(this.currentIcon)
				{
					newHeight = this.currentIcon.height;
				}
				else if(this.labelField.text)
				{
					newHeight = this.labelField.height;
				}
				newHeight += 2 * this._contentPadding;
				if(isNaN(newHeight))
				{
					newHeight = this._originalSkinHeight;
				}
				else if(!isNaN(this._originalSkinHeight))
				{
					newHeight = Math.max(newHeight, this._originalSkinHeight);
				}
			}

			this.setSizeInternal(newWidth, newHeight, false);
			return true;
		}


		/**
		 * Update visible property for all skin states and set currentSkin
		 * @private
		 */
		protected function updateSkinStates():void
		{
			if(this._currentState == AdvancedList.CONTROL_STATE_BASE)
			{
				this.currentSkin = this._draggingSkin;
			}
			else if(this._draggingSkin)
			{
				this._draggingSkin.visible = false;
			}

			if(this._currentState == AdvancedList.CONTROL_STATE_READY)
			{
				this.currentSkin = this._readySkin;
			}
			else if(this._readySkin)
			{
				this._readySkin.visible = false;
			}

			if(this._currentState == AdvancedList.CONTROL_STATE_RELEASED)
			{
				this.currentSkin = this._releasedSkin;
			}
			else if(this._releasedSkin)
			{
				this._releasedSkin.visible = false;
			}

			if(!this.currentSkin)
			{				
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
			}
		}

		/**
		 * @private
		 */
		protected function refreshSkin():void
		{	
			this.currentSkin = null;

			updateSkinStates();

			if(this.currentSkin)
			{
				this.currentSkin.visible = true;
				if(isNaN(this._originalSkinWidth))
				{
					this._originalSkinWidth = this.currentSkin.width;
				}
				if(isNaN(this._originalSkinHeight))
				{
					this._originalSkinHeight = this.currentSkin.height;
				}
			}
			else
			{
				trace("No skin defined for state \"" + this._currentState + "\" and there is no default value.");
			}
		}

		/**
		 * Update visible property for all icons and set currentIcon
		 * @private
		 */
		protected function updateIcons():void
		{
			if(this._currentState == AdvancedList.CONTROL_STATE_DRAGGING)
			{
				this.currentIcon = this._draggingIcon;
			}
			else if(this._draggingIcon)
			{
				this._draggingIcon.visible = false;
			}

			if(this._currentState == AdvancedList.CONTROL_STATE_READY)
			{
				this.currentIcon = this._readyIcon;
			}
			else if(this._readyIcon)
			{
				this._readyIcon.visible = false;
			}

			if(this._currentState == AdvancedList.CONTROL_STATE_RELEASED)
			{
				this.currentIcon = this._releasedIcon;
			}
			else if(this._releasedIcon)
			{
				this._releasedIcon.visible = false;
			}
		}

		/**
		 * @private
		 */
		protected function refreshIcon():void
		{
			this.currentIcon = null;

			updateIcons();

			if(!this.currentIcon)
			{				
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

			if(!format)
			{							
				format = this._defaultTextFormat;			
			}

			if(format)
			{
				this.labelField.textFormat = format;
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
			if(this.labelField.text && this.currentIcon)
			{
				this.positionLabelOrIcon(this.labelField);
				this.positionLabelAndIcon();
			}
			else if(this.labelField.text && !this.currentIcon)
			{
				this.positionLabelOrIcon(this.labelField);
			}
			else if(!this.labelField.text && this.currentIcon)
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
				displayObject.x = this._contentPadding;
			}
			else if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
			{
				displayObject.x = this.actualWidth - this._contentPadding - displayObject.width;
			}
			else //center
			{
				displayObject.x = (this.actualWidth - displayObject.width) / 2;
			}

			//middle vertical align			
			displayObject.y = (this.actualHeight - displayObject.height) / 2;

		}

		/**
		 * @private
		 */
		protected function positionLabelAndIcon():void
		{
			if(this._gap == Number.POSITIVE_INFINITY)
			{
				this.currentIcon.x = this._contentPadding;
				this.labelField.x = this.actualWidth - this._contentPadding - this.labelField.width;
			}
			else
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



			this.currentIcon.y = this.labelField.y + (this.labelField.height - this.currentIcon.height) / 2;


		}



	}
}

