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

        override protected function draw():void
        {
            const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
            const skinInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SKIN);
            var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
            const focusInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_FOCUS);

            if(stateInvalid || skinInvalid)
            {
                this.refreshBackgroundSkin();
            }

            sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;


            if(sizeInvalid || focusInvalid)
            {
                this.refreshFocusIndicator();
            }


            super.draw();
        }

        /**
         * @private
         */
        override protected function layout():void
        {
            //TODO layout background

            this.textRenderer.width = this.actualWidth;
            this.textRenderer.height = this.actualHeight;
            this.textRenderer.validate();
            this._baseline = this.textRenderer.baseline;
        }




	}


}