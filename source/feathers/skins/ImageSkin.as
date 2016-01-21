/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.skins
{
	import feathers.core.IFeathersControl;
	import feathers.core.IMeasureDisplayObject;
	import feathers.core.IStateContext;
	import feathers.core.IStateObserver;
	import feathers.core.IToggle;
	import feathers.events.FeathersEventType;

	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;

	/**
	 * A skin for Feathers components that displays a texture. Has the ability
	 * to change its texture based on the current state of the Feathers
	 * component that is being skinned.
	 * 
	 * <listing version="3.0">
	 * function setButtonSkin( button:Button ):void
	 * {
	 *     var skin:ImageSkin = new ImageSkin( upTexture );
	 *     skin.setTextureForState( ButtonState.DOWN, downTexture );
	 *     skin.setTextureForState( ButtonState.HOVER, hoverTexture );
	 *     button.defaultSkin = skin;
	 * }
	 * 
	 * var button:Button = new Button();
	 * button.label = "Click Me";
	 * button.styleProvider = new AddOnFunctionStyleProvider( setButtonSkin, button.styleProvider );
	 * this.addChild( button );</listing>
	 * 
	 * @see starling.display.Image
	 */
	public class ImageSkin extends Image implements IMeasureDisplayObject, IStateObserver
	{
		/**
		 * Constructor.
		 */
		public function ImageSkin(defaultTexture:Texture = null)
		{
			super(defaultTexture);
			this.defaultTexture = defaultTexture;
		}

		/**
		 * @private
		 */
		protected var _defaultTexture:Texture;

		/**
		 * The default texture that the skin will display. If the component
		 * being skinned supports states, the texture for a specific state may
		 * be specified using the <code>setTextureForState()</code> method. If
		 * no texture has been specified for the current state, the default
		 * texture will be used.
		 *
		 * <p>In the following example, the default texture is specified in the
		 * constructor:</p>
		 *
		 * <listing version="3.0">
		 * var skin:ImageSkin = new ImageSkin( texture );</listing>
		 *
		 * <p>In the following example, the default texture is specified by
		 * setting the property:</p>
		 *
		 * <listing version="3.0">
		 * var skin:ImageSkin = new ImageSkin();
		 * skin.defaultTexture = texture;</listing>
		 *
		 * @default null
		 *
		 * @see #defaultTexture
		 * @see #disabledTexture
		 * @see #selectedTexture
		 * @see #setTextureForState()
		 * @see http://doc.starling-framework.org/current/starling/textures/Texture.html starling.textures.Texture
		 */
		public function get defaultTexture():Texture
		{
			return this._defaultTexture;
		}

		/**
		 * @private
		 */
		public function set defaultTexture(value:Texture):void
		{
			this._defaultTexture = value;
		}

		/**
		 * @private
		 */
		protected var _disabledTexture:Texture;

		/**
		 * The texture to display when the <code>stateContext</code> is
		 * an <code>IFeathersControl</code> and its <code>isEnabled</code>
		 * property is <code>false</code>. If a texture has been specified for
		 * the context's current state with <code>setTextureForState()</code>,
		 * it will take precedence over the <code>disabledTexture</code>.
		 *
		 * <p>In the following example, the disabled texture is changed:</p>
		 *
		 * <listing version="3.0">
		 * var skin:ImageSkin = new ImageSkin( upTexture );
		 * skin.disabledTexture = disabledTexture;
		 * button.skin = skin;
		 * button.isEnabled = false;</listing>
		 *
		 * @default null
		 *
		 * @see #defaultTexture
		 * @see #selectedTexture
		 * @see #setTextureForState()
		 * @see http://doc.starling-framework.org/current/starling/textures/Texture.html starling.textures.Texture
		 */
		public function get disabledTexture():Texture
		{
			return this._disabledTexture;
		}

		/**
		 * @private
		 */
		public function set disabledTexture(value:Texture):void
		{
			this._disabledTexture = value;
		}

		/**
		 * @private
		 */
		protected var _selectedTexture:Texture;

		/**
		 * The texture to display when the <code>stateContext</code> is
		 * an <code>IToggle</code> instance and its <code>isSelected</code>
		 * property is <code>true</code>. If a texture has been specified for
		 * the context's current state with <code>setTextureForState()</code>,
		 * it will take precedence over the <code>selectedTexture</code>.
		 *
		 * <p>In the following example, the selected texture is changed:</p>
		 *
		 * <listing version="3.0">
		 * var skin:ImageSkin = new ImageSkin( upTexture );
		 * skin.selectedTexture = selectedTexture;
		 * toggleButton.skin = skin;
		 * toggleButton.isSelected = true;</listing>
		 *
		 * @default null
		 *
		 * @see #defaultTexture
		 * @see #disabledTexture
		 * @see #setTextureForState()
		 * @see http://doc.starling-framework.org/current/starling/textures/Texture.html starling.textures.Texture
		 */
		public function get selectedTexture():Texture
		{
			return this._selectedTexture;
		}

		/**
		 * @private
		 */
		public function set selectedTexture(value:Texture):void
		{
			this._selectedTexture = value;
		}

		/**
		 * @private
		 */
		protected var _stateContext:IStateContext;

		/**
		 * When the skin observes a state context, the skin may change its
		 * <code>Texture</code> based on the current state of that context.
		 * Typically, a relevant component will automatically assign itself as
		 * the state context of its skin, so this property is considered to be
		 * for internal use only.
		 *
		 * @default null
		 *
		 * @see #setTextureForState()
		 */
		public function get stateContext():IStateContext
		{
			return this._stateContext;
		}

		/**
		 * @private
		 */
		public function set stateContext(value:IStateContext):void
		{
			if(this._stateContext === value)
			{
				return;
			}
			if(this._stateContext)
			{
				this._stateContext.removeEventListener(FeathersEventType.STATE_CHANGE, stateContext_stageChangeHandler);
			}
			this._stateContext = value;
			if(this._stateContext)
			{
				this._stateContext.addEventListener(FeathersEventType.STATE_CHANGE, stateContext_stageChangeHandler);
			}
			this.updateTextureFromContext();
		}

		/**
		 * @private
		 */
		protected var _explicitWidth:Number = NaN;

		/**
		 * The value passed to the <code>width</code> property setter. If the
		 * <code>width</code> property has not be set, returns <code>NaN</code>.
		 * 
		 * @see #width
		 */
		public function get explicitWidth():Number
		{
			return this._explicitWidth;
		}

		/**
		 * @private
		 */
		override public function set width(value:Number):void
		{
			if(this._explicitWidth === value)
			{
				return;
			}
			if(value !== value && this._explicitWidth !== this._explicitWidth)
			{
				return;
			}
			this._explicitWidth = value;
			if(value === value) //!isNaN
			{
				super.width = value;
			}
			else
			{
				this.readjustSize();
			}
			this.dispatchEventWith(Event.RESIZE);
		}

		/**
		 * @private
		 */
		protected var _explicitHeight:Number = NaN;

		/**
		 * The value passed to the <code>height</code> property setter. If the
		 * <code>height</code> property has not be set, returns
		 * <code>NaN</code>.
		 * 
		 * @see #height
		 */
		public function get explicitHeight():Number
		{
			return this._explicitHeight;
		}

		/**
		 * @private
		 */
		override public function set height(value:Number):void
		{
			if(this._explicitHeight === value)
			{
				return;
			}
			if(value !== value && this._explicitHeight !== this._explicitHeight)
			{
				return;
			}
			this._explicitHeight = value;
			if(value === value) //!isNaN
			{
				super.height = value;
			}
			else
			{
				this.readjustSize();
			}
			this.dispatchEventWith(Event.RESIZE);
		}

		/**
		 * @private
		 */
		protected var _explicitMinWidth:Number = NaN;

		/**
		 * The value passed to the <code>minWidth</code> property setter. If the
		 * <code>minWidth</code> property has not be set, returns
		 * <code>NaN</code>.
		 *
		 * @see #minWidth
		 */
		public function get explicitMinWidth():Number
		{
			return this._explicitMinWidth;
		}

		/**
		 *
		 */
		public function get minWidth():Number
		{
			if(this._explicitMinWidth === this._explicitMinWidth) //!isNaN
			{
				return this._explicitMinWidth;
			}
			return 0;
		}

		/**
		 * @private
		 */
		public function set minWidth(value:Number):void
		{
			if(this._explicitMinWidth === value)
			{
				return;
			}
			if(value !== value && this._explicitMinWidth !== this._explicitMinWidth)
			{
				return;
			}
			this._explicitMinWidth = value;
			this.dispatchEventWith(Event.RESIZE);
		}

		/**
		 * @private
		 */
		protected var _explicitMinHeight:Number = NaN;

		/**
		 * The value passed to the <code>minHeight</code> property setter. If
		 * the <code>minHeight</code> property has not be set, returns
		 * <code>NaN</code>.
		 *
		 * @see #minHeight
		 */
		public function get explicitMinHeight():Number
		{
			return this._explicitMinHeight;
		}

		/**
		 *
		 */
		public function get minHeight():Number
		{
			if(this._explicitMinHeight === _explicitMinHeight) //!isNaN
			{
				return this._explicitMinHeight;
			}
			return 0;
		}

		/**
		 * @private
		 */
		public function set minHeight(value:Number):void
		{
			if(this._explicitMinHeight === value)
			{
				return;
			}
			if(value !== value && this._explicitMinHeight !== this._explicitMinHeight)
			{
				return;
			}
			this._explicitMinHeight = value;
			this.dispatchEventWith(Event.RESIZE);
		}

		/**
		 * @private
		 */
		protected var _stateToTexture:Object = {};

		/**
		 * Gets the texture to be used by the skin when the context's
		 * <code>currentState</code> property matches the specified state value.
		 *
		 * <p>If a texture is not defined for a specific state, returns
		 * <code>null</code>.</p>
		 *
		 * @see #setTextureForState()
		 */
		public function getTextureForState(state:String):Texture
		{
			return this._stateToTexture[state] as Texture;
		}

		/**
		 * Sets the texture to be used by the skin when the context's
		 * <code>currentState</code> property matches the specified state value.
		 *
		 * <p>If a texture is not defined for a specific state, the value of the
		 * <code>defaultTexture</code> property will be used instead.</p>
		 *
		 * @see #defaultTexture
		 * @see #getTextureForState()
		 */
		public function setTextureForState(state:String, texture:Texture):void
		{
			if(texture !== null)
			{
				this._stateToTexture[state] = texture;
			}
			else
			{
				delete this._stateToTexture[state];
			}
		}

		/**
		 * @private
		 */
		protected function updateTextureFromContext():void
		{
			if(this._stateContext === null)
			{
				this.texture = this._defaultTexture;
				return;
			}
			var texture:Texture = this._stateToTexture[this._stateContext.currentState] as Texture;
			if(texture === null &&
				this._disabledTexture !== null &&
				this._stateContext is IFeathersControl &&
				!IFeathersControl(this._stateContext).isEnabled)
			{
				texture = this._disabledTexture;
			}
			if(texture === null &&
				this._selectedTexture !== null &&
				this._stateContext is IToggle &&
				IToggle(this._stateContext).isSelected)
			{
				texture = this._selectedTexture;
			}
			if(texture === null)
			{
				texture = this._defaultTexture;
			}
			if(this.texture !== texture)
			{
				this.texture = texture;
			}
		}

		/**
		 * @private
		 */
		protected function stateContext_stageChangeHandler(event:Event):void
		{
			this.updateTextureFromContext();
		}
	}
}
