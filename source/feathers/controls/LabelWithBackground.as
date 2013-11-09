package feathers.controls
{
	import feathers.controls.Label;
    import feathers.core.IFeathersControl;
    import feathers.skins.StateValueSelector;

    import flash.geom.Point;

    import starling.display.DisplayObject;

    public class LabelWithBackground extends Label
	{

        /**
         * @private
         */
        private static const HELPER_POINT:Point = new Point();

        /**
         * The <code>TextInput</code> is enabled and does not have focus.
         */
        public static const STATE_ENABLED:String = "enabled";

        /**
         * The <code>TextInput</code> is disabled.
         */
        public static const STATE_DISABLED:String = "disabled";

        /**
         * The <code>TextInput</code> is enabled and has focus.
         */
        public static const STATE_FOCUSED:String = "focused";

        /**
         * @private
         */
        protected var _skinSelector:StateValueSelector = new StateValueSelector();
        protected static const INVALIDATION_FLAG_BACKGROUND_SKIN:String = "backgroundSkin";
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
         * The currently selected background, based on state.
         *
         * <p>For internal use in subclasses.</p>
         */
        protected var currentBackground:DisplayObject;

		public function LabelWithBackground()
		{
			super();
		}


        public function set value( value:Number ):void {
            this.text = String( value );
        }

        public function get value():Number {
            return Number( this.text );
        }

        /**
         * The skin used when no other skin is defined for the current state.
         * Intended for use when multiple states should use the same skin.
         *
         * <p>The following example gives the input a default skin to use for
         * all states when no specific skin is available:</p>
         *
         * <listing version="3.0">
         * input.backgroundSkin = new Image( texture );</listing>
         *
         * @default null
         *
         * @see #backgroundEnabledSkin
         * @see #backgroundDisabledSkin
         * @see #backgroundFocusedSkin
         */
        public function get backgroundSkin():DisplayObject
        {
            return DisplayObject(this._skinSelector.defaultValue);
        }

        /**
         * @private
         */
        public function set backgroundSkin(value:DisplayObject):void
        {
            if(this._skinSelector.defaultValue == value)
            {
                return;
            }
            this._skinSelector.defaultValue = value;
            this.invalidate(INVALIDATION_FLAG_SKIN);
        }

        /**
         * The skin used for the input's enabled state. If <code>null</code>,
         * then <code>backgroundSkin</code> is used instead.
         *
         * <p>The following example gives the input a skin for the enabled state:</p>
         *
         * <listing version="3.0">
         * input.backgroundEnabledSkin = new Image( texture );</listing>
         *
         * @default null
         *
         * @see #backgroundSkin
         * @see #backgroundDisabledSkin
         */
        public function get backgroundEnabledSkin():DisplayObject
        {
            return DisplayObject(this._skinSelector.getValueForState(STATE_ENABLED));
        }

        /**
         * @private
         */
        public function set backgroundEnabledSkin(value:DisplayObject):void
        {
            if(this._skinSelector.getValueForState(STATE_ENABLED) == value)
            {
                return;
            }
            this._skinSelector.setValueForState(value, STATE_ENABLED);
            this.invalidate(INVALIDATION_FLAG_SKIN);
        }

        /**
         * The skin used for the input's focused state. If <code>null</code>,
         * then <code>backgroundSkin</code> is used instead.
         *
         * <p>The following example gives the input a skin for the focused state:</p>
         *
         * <listing version="3.0">
         * input.backgroundFocusedSkin = new Image( texture );</listing>
         *
         * @default null
         */
        public function get backgroundFocusedSkin():DisplayObject
        {
            return DisplayObject(this._skinSelector.getValueForState(STATE_FOCUSED));
        }

        /**
         * @private
         */
        public function set backgroundFocusedSkin(value:DisplayObject):void
        {
            if(this._skinSelector.getValueForState(STATE_FOCUSED) == value)
            {
                return;
            }
            this._skinSelector.setValueForState(value, STATE_FOCUSED);
            this.invalidate(INVALIDATION_FLAG_SKIN);
        }

        /**
         * The skin used for the input's disabled state. If <code>null</code>,
         * then <code>backgroundSkin</code> is used instead.
         *
         * <p>The following example gives the input a skin for the disabled state:</p>
         *
         * <listing version="3.0">
         * input.backgroundDisabledSkin = new Image( texture );</listing>
         *
         * @default null
         */
        public function get backgroundDisabledSkin():DisplayObject
        {
            return DisplayObject(this._skinSelector.getValueForState(STATE_DISABLED));
        }

        /**
         * @private
         */
        public function set backgroundDisabledSkin(value:DisplayObject):void
        {
            if(this._skinSelector.getValueForState(STATE_DISABLED) == value)
            {
                return;
            }
            this._skinSelector.setValueForState(value, STATE_DISABLED);
            this.invalidate(INVALIDATION_FLAG_SKIN);
        }

        /**
         * @private
         */
        protected var _stateToSkinFunction:Function;

        /**
         * Returns a skin for the current state.
         *
         * <p>The following function signature is expected:</p>
         * <pre>function( target:TextInput, state:Object, oldSkin:DisplayObject = null ):DisplayObject</pre>
         *
         * @default null
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
            this.invalidate(INVALIDATION_FLAG_SKIN);
        }

        /**
         * Sets the <code>currentBackground</code> property.
         *
         * <p>For internal use in subclasses.</p>
         */
        protected function refreshBackgroundSkin():void
        {
            const oldSkin:DisplayObject = this.currentBackground;
            if(this._stateToSkinFunction != null)
            {
                this.currentBackground = DisplayObject(this._stateToSkinFunction(this, this._currentState, oldSkin));
            }
            else
            {
                this.currentBackground = DisplayObject(this._skinSelector.updateValue(this, this._currentState, this.currentBackground));
            }
            if(this.currentBackground != oldSkin)
            {
                if(oldSkin)
                {
                    this.removeChild(oldSkin, false);
                }
                if(this.currentBackground)
                {
                    this.addChildAt(this.currentBackground, 0);
                }
            }
            if(this.currentBackground && (isNaN(this._originalSkinWidth) || isNaN(this._originalSkinHeight)))
            {
                if(this.currentBackground is IFeathersControl)
                {
                    IFeathersControl(this.currentBackground).validate();
                }
                this._originalSkinWidth = this.currentBackground.width;
                this._originalSkinHeight = this.currentBackground.height;
            }
        }

        /**
         * @private
         */
        protected var _currentState:String = STATE_ENABLED;

        /**
         * The current state of the input.
         *
         * <p>For internal use in subclasses.</p>
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
        protected var _stateNames:Vector.<String> = new <String>
        [
            STATE_ENABLED, STATE_DISABLED, STATE_FOCUSED
        ];

        /**
         * A list of all valid state names for use with <code>currentState</code>.
         *
         * <p>For internal use in subclasses.</p>
         *
         * @see #currentState
         */
        protected function get stateNames():Vector.<String>
        {
            return this._stateNames;
        }

        /**
         * Quickly sets all padding properties to the same value. The
         * <code>padding</code> getter always returns the value of
         * <code>paddingTop</code>, but the other padding values may be
         * different.
         *
         * <p>In the following example, the text input's padding is set to
         * 20 pixels:</p>
         *
         * <listing version="3.0">
         * input.padding = 20;</listing>
         *
         * @default 0
         *
         * @see #paddingTop
         * @see #paddingRight
         * @see #paddingBottom
         * @see #paddingLeft
         */
        public function get padding():Number
        {
            return this._paddingTop;
        }

        /**
         * @private
         */
        public function set padding(value:Number):void
        {
            this.paddingTop = value;
            this.paddingRight = value;
            this.paddingBottom = value;
            this.paddingLeft = value;
        }

        /**
         * @private
         */
        protected var _paddingTop:Number = 0;

        /**
         * The minimum space, in pixels, between the input's top edge and the
         * input's content.
         *
         * <p>In the following example, the text input's top padding is set to
         * 20 pixels:</p>
         *
         * <listing version="3.0">
         * input.paddingTop = 20;</listing>
         *
         * @default 0
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
         *
         * <p>In the following example, the text input's right padding is set to
         * 20 pixels:</p>
         *
         * <listing version="3.0">
         * input.paddingRight = 20;</listing>
         *
         * @default 0
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
         *
         * <p>In the following example, the text input's bottom padding is set to
         * 20 pixels:</p>
         *
         * <listing version="3.0">
         * input.paddingBottom = 20;</listing>
         *
         * @default 0
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
         *
         * <p>In the following example, the text input's left padding is set to
         * 20 pixels:</p>
         *
         * <listing version="3.0">
         * input.paddingLeft = 20;</listing>
         *
         * @default 0
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



        override protected function draw():void
        {

            const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
            const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
            var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
            const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
            const textRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);
            const skinInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SKIN);
            const focusInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_FOCUS);

            if(stateInvalid || skinInvalid)
            {
                this.refreshBackgroundSkin();
            }

            if(textRendererInvalid)
            {
                this.createTextRenderer();
            }

            if(textRendererInvalid || dataInvalid || stateInvalid)
            {
                this.refreshTextRendererData();
            }

            if(textRendererInvalid || stateInvalid)
            {
                this.refreshEnabled();
            }

            if(textRendererInvalid || stylesInvalid || stateInvalid)
            {
                this.refreshTextRendererStyles();
            }

            sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;


            if(sizeInvalid || focusInvalid)
            {
                this.refreshFocusIndicator();
            }


            this.layout();

        }

        /**
         * If the component's dimensions have not been set explicitly, it will
         * measure its content and determine an ideal size for itself. If the
         * <code>explicitWidth</code> or <code>explicitHeight</code> member
         * variables are set, those value will be used without additional
         * measurement. If one is set, but not the other, the dimension with the
         * explicit value will not be measured, but the other non-explicit
         * dimension will still need measurement.
         *
         * <p>Calls <code>setSizeInternal()</code> to set up the
         * <code>actualWidth</code> and <code>actualHeight</code> member
         * variables used for layout.</p>
         *
         * <p>Meant for internal use, and subclasses may override this function
         * with a custom implementation.</p>
         */
        override protected function autoSizeIfNeeded():Boolean
        {
            const needsWidth:Boolean = isNaN(this.explicitWidth);
            const needsHeight:Boolean = isNaN(this.explicitHeight);
            if(!needsWidth && !needsHeight)
            {
                return false;
            }
            this.textRenderer.minWidth = this._minWidth;
            this.textRenderer.maxWidth = this._maxWidth;
            this.textRenderer.width = this.explicitWidth;
            this.textRenderer.minHeight = this._minHeight;
            this.textRenderer.maxHeight = this._maxHeight;
            this.textRenderer.height = this.explicitHeight;
            this.textRenderer.measureText(HELPER_POINT);
            var newWidth:Number = this.explicitWidth;
            if(needsWidth)
            {
                if(this._text)
                {
//                    newWidth = HELPER_POINT.x;
                    newWidth = Math.max(this._originalSkinWidth, HELPER_POINT.x + this._paddingLeft + this._paddingRight);
                }
                else
                {
                    newWidth = 0;
                }
            }

            var newHeight:Number = this.explicitHeight;
            if(needsHeight)
            {
                if(this._text)
                {
//                    newHeight = HELPER_POINT.y;
                    newHeight = Math.max(this._originalSkinHeight, HELPER_POINT.y + this._paddingTop + this._paddingBottom);
                }
                else
                {
                    newHeight = 0;
                }
            }

            return this.setSizeInternal(newWidth, newHeight, false);
        }

        /**
         * @private
         */
        override protected function layout():void
        {
            if(this.currentBackground)
            {
                this.currentBackground.visible = true;
                this.currentBackground.touchable = true;
                this.currentBackground.width = this.actualWidth;
                this.currentBackground.height = this.actualHeight;
            }
            this.textRenderer.x = this._paddingLeft;
            this.textRenderer.y = this._paddingTop;
            this.textRenderer.width = this.actualWidth - this._paddingRight - this.textRenderer.x;
            this.textRenderer.height = this.actualHeight - this._paddingTop - this._paddingBottom;
            this.textRenderer.validate();
            this._baseline = this.textRenderer.baseline;
        }




	}


}