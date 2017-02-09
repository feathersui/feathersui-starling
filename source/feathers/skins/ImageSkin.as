/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

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
	 * var button:Button = new Button();
	 * button.label = "Click Me";
	 * var skin:ImageSkin = new ImageSkin( upTexture );
	 * skin.setTextureForState( ButtonState.DOWN, downTexture );
	 * skin.setTextureForState( ButtonState.HOVER, hoverTexture );
	 * button.defaultSkin = skin;
	 * this.addChild( button );</listing>
	 * 
	 * @see starling.display.Image
	 *
	 * @productversion Feathers 3.0.0
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
			if(this._defaultTexture === value)
			{
				return;
			}
			this._defaultTexture = value;
			this.updateTextureFromContext();
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
			if(this._disabledTexture === value)
			{
				return;
			}
			this._disabledTexture = value;
			this.updateTextureFromContext();
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
			if(this._selectedTexture === value)
			{
				return;
			}
			this._selectedTexture = value;
			this.updateTextureFromContext();
		}

		/**
		 * @private
		 */
		protected var _defaultColor:uint = uint.MAX_VALUE;

		/**
		 * The default color to use to tint the skin. If the component
		 * being skinned supports states, the color for a specific state may
		 * be specified using the <code>setColorForState()</code> method. If
		 * no color has been specified for the current state, the default
		 * color will be used.
		 * 
		 * <p>A value of <code>uint.MAX_VALUE</code> means that the
		 * <code>color</code> property will not be changed when the context's
		 * state changes.</p>
		 *
		 * <p>In the following example, the default color is specified:</p>
		 *
		 * <listing version="3.0">
		 * var skin:ImageSkin = new ImageSkin();
		 * skin.defaultColor = 0x9f0000;</listing>
		 *
		 * @default uint.MAX_VALUE
		 *
		 * @see #disabledColor
		 * @see #selectedColor
		 * @see #setColorForState()
		 */
		public function get defaultColor():uint
		{
			return this._defaultColor;
		}

		/**
		 * @private
		 */
		public function set defaultColor(value:uint):void
		{
			if(this._defaultColor === value)
			{
				return;
			}
			this._defaultColor = value;
			this.updateColorFromContext();
		}

		/**
		 * @private
		 */
		protected var _disabledColor:uint = uint.MAX_VALUE;

		/**
		 * The color to tint the skin when the <code>stateContext</code> is
		 * an <code>IFeathersControl</code> and its <code>isEnabled</code>
		 * property is <code>false</code>. If a color has been specified for
		 * the context's current state with <code>setColorForState()</code>,
		 * it will take precedence over the <code>disabledColor</code>.
		 *
		 * <p>A value of <code>uint.MAX_VALUE</code> means that the
		 * <code>disabledColor</code> property cannot affect the tint when the
		 * context's state changes.</p>
		 *
		 * <p>In the following example, the disabled color is changed:</p>
		 *
		 * <listing version="3.0">
		 * var skin:ImageSkin = new ImageSkin();
		 * skin.defaultColor = 0xffffff;
		 * skin.disabledColor = 0x999999;
		 * button.skin = skin;
		 * button.isEnabled = false;</listing>
		 *
		 * @default uint.MAX_VALUE
		 *
		 * @see #defaultColor
		 * @see #selectedColor
		 * @see #setColorForState()
		 */
		public function get disabledColor():uint
		{
			return this._disabledColor;
		}

		/**
		 * @private
		 */
		public function set disabledColor(value:uint):void
		{
			if(this._disabledColor === value)
			{
				return;
			}
			this._disabledColor = value;
			this.updateColorFromContext();
		}

		/**
		 * @private
		 */
		protected var _selectedColor:uint = uint.MAX_VALUE;

		/**
		 * The color to tint the skin when the <code>stateContext</code> is
		 * an <code>IToggle</code> instance and its <code>isSelected</code>
		 * property is <code>true</code>. If a color has been specified for
		 * the context's current state with <code>setColorForState()</code>,
		 * it will take precedence over the <code>selectedColor</code>.
		 *
		 * <p>In the following example, the selected color is changed:</p>
		 *
		 * <listing version="3.0">
		 * var skin:ImageSkin = new ImageSkin();
		 * skin.defaultColor = 0xffffff;
		 * skin.selectedColor = 0xffcc00;
		 * toggleButton.skin = skin;
		 * toggleButton.isSelected = true;</listing>
		 *
		 * @default uint.MAX_VALUE
		 *
		 * @see #defaultColor
		 * @see #disabledColor
		 * @see #setColorForState()
		 */
		public function get selectedColor():uint
		{
			return this._selectedColor;
		}

		/**
		 * @private
		 */
		public function set selectedColor(value:uint):void
		{
			if(this._selectedColor === value)
			{
				return;
			}
			this._selectedColor = value;
			this.updateColorFromContext();
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
			this.updateColorFromContext();
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
			else if(this.texture !== null)
			{
				//return to the original width of the texture
				this.scaleX = 1;
				this.readjustSize(this.texture.frameWidth);
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
			else if(this.texture !== null)
			{
				//return to the original height of the texture
				this.scaleY = 1;
				this.readjustSize(-1, this.texture.frameHeight);
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
		 * The minimum width of the component.
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
		protected var _explicitMaxWidth:Number = Number.POSITIVE_INFINITY;

		/**
		 * The value passed to the <code>maxWidth</code> property setter. If the
		 * <code>maxWidth</code> property has not be set, returns
		 * <code>NaN</code>.
		 *
		 * @see #maxWidth
		 */
		public function get explicitMaxWidth():Number
		{
			return this._explicitMaxWidth;
		}

		/**
		 * The maximum width of the component.
		 */
		public function get maxWidth():Number
		{
			return this._explicitMaxWidth;
		}

		/**
		 * @private
		 */
		public function set maxWidth(value:Number):void
		{
			if(this._explicitMaxWidth === value)
			{
				return;
			}
			if(value !== value && this._explicitMaxWidth !== this._explicitMaxWidth)
			{
				return;
			}
			this._explicitMaxWidth = value;
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
		 * The minimum height of the component.
		 */
		public function get minHeight():Number
		{
			if(this._explicitMinHeight === this._explicitMinHeight) //!isNaN
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
		protected var _explicitMaxHeight:Number = Number.POSITIVE_INFINITY;

		/**
		 * The value passed to the <code>maxHeight</code> property setter. If
		 * the <code>maxHeight</code> property has not be set, returns
		 * <code>NaN</code>.
		 *
		 * @see #maxHeight
		 */
		public function get explicitMaxHeight():Number
		{
			return this._explicitMaxHeight;
		}

		/**
		 * The maximum height of the component.
		 */
		public function get maxHeight():Number
		{
			return this._explicitMaxHeight;
		}

		/**
		 * @private
		 */
		public function set maxHeight(value:Number):void
		{
			if(this._explicitMaxHeight === value)
			{
				return;
			}
			if(value !== value && this._explicitMaxHeight !== this._explicitMaxHeight)
			{
				return;
			}
			this._explicitMaxHeight = value;
			this.dispatchEventWith(Event.RESIZE);
		}

		/**
		 * @private
		 */
		protected var _stateToTexture:Object = {};

		/**
		 * @private
		 */
		protected var _stateToColor:Object = {};

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
			this.updateTextureFromContext();
		}

		/**
		 * Gets the color to be used by the skin when the context's
		 * <code>currentState</code> property matches the specified state value.
		 *
		 * <p>If a color is not defined for a specific state, returns
		 * <code>uint.MAX_VALUE</code>.</p>
		 *
		 * @see #setColorForState()
		 */
		public function getColorForState(state:String):uint
		{
			if(state in this._stateToColor)
			{
				return this._stateToColor[state] as uint;
			}
			return uint.MAX_VALUE;
		}

		/**
		 * Sets the color to be used by the skin when the context's
		 * <code>currentState</code> property matches the specified state value.
		 *
		 * <p>If a color is not defined for a specific state, the value of the
		 * <code>defaultTexture</code> property will be used instead.</p>
		 * 
		 * <p>To clear a state's color, pass in <code>uint.MAX_VALUE</code>.</p>
		 *
		 * @see #defaultColor
		 * @see #getColorForState()
		 */
		public function setColorForState(state:String, color:uint):void
		{
			if(color !== uint.MAX_VALUE)
			{
				this._stateToColor[state] = color;
			}
			else
			{
				delete this._stateToColor[state];
			}
			this.updateColorFromContext();
		}

		/**
		 * @private
		 */
		override public function readjustSize(width:Number=-1, height:Number=-1):void
		{
			super.readjustSize(width, height);
			if(this._explicitWidth === this._explicitWidth) //!isNaN
			{
				super.width = this._explicitWidth;
			}
			if(this._explicitHeight === this._explicitHeight) //!isNaN
			{
				super.height = this._explicitHeight;
			}
		}

		/**
		 * @private
		 */
		protected function updateTextureFromContext():void
		{
			var texture:Texture = null;
			if(this._stateContext === null)
			{
				texture = this._defaultTexture;
			}
			else
			{
				texture = this._stateToTexture[this._stateContext.currentState] as Texture;
				if(texture === null &&
					this._disabledTexture !== null &&
					this._stateContext is IFeathersControl && !IFeathersControl(this._stateContext).isEnabled)
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
			}
			this.texture = texture;
		}

		/**
		 * @private
		 */
		protected function updateColorFromContext():void
		{
			if(this._stateContext === null)
			{
				if(this._defaultColor !== uint.MAX_VALUE)
				{
					this.color = this._defaultColor;
				}
				return;
			}
			var color:uint = uint.MAX_VALUE;
			var currentState:String = this._stateContext.currentState;
			if(currentState in this._stateToColor)
			{
				color = this._stateToColor[currentState] as uint;
			}
			if(color === uint.MAX_VALUE &&
				this._disabledColor !== uint.MAX_VALUE &&
				this._stateContext is IFeathersControl && !IFeathersControl(this._stateContext).isEnabled)
			{
				color = this._disabledColor;
			}
			if(color === uint.MAX_VALUE &&
				this._selectedColor !== uint.MAX_VALUE &&
				this._stateContext is IToggle &&
				IToggle(this._stateContext).isSelected)
			{
				color = this._selectedColor;
			}
			if(color === uint.MAX_VALUE)
			{
				color = this._defaultColor;
			}
			if(color !== uint.MAX_VALUE)
			{
				this.color = color;
			}
		}

		/**
		 * @private
		 */
		protected function stateContext_stageChangeHandler(event:Event):void
		{
			this.updateTextureFromContext();
			this.updateColorFromContext();
		}
	}
}
