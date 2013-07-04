/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.core.PropertyProxy;

	import flash.geom.Point;

	import starling.display.DisplayObject;

	/**
	 * Displays text.
	 *
	 * @see http://wiki.starling-framework.org/feathers/label
	 * @see http://wiki.starling-framework.org/feathers/text-renderers
	 */
	public class Label extends FeathersControl
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * Constructor.
		 */
		public function Label()
		{
			this.isQuickHitAreaEnabled = true;
		}

		/**
		 * The text renderer.
		 */
		protected var textRenderer:ITextRenderer;

		/**
		 * @private
		 */
		protected var _text:String = null;

		/**
		 * The text displayed by the label.
		 *
		 * <p>In the following example, the label's text is updated:</p>
		 *
		 * <listing version="3.0">
		 * label.text = "Hello World";</listing>
		 *
		 * @default null
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
			if(this._text == value)
			{
				return;
			}
			this._text = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _baseline:Number = 0;

		/**
		 * The baseline value of the text.
		 */
		public function get baseline():Number
		{
			return this._baseline;
		}

		/**
		 * @private
		 */
		protected var _textRendererFactory:Function;

		/**
		 * A function used to instantiate the label's text renderer
		 * sub-component. By default, the label will use the global text
		 * renderer factory, <code>FeathersControl.defaultTextRendererFactory()</code>,
		 * to create the text renderer. The text renderer must be an instance of
		 * <code>ITextRenderer</code>. This factory can be used to change
		 * properties on the text renderer when it is first created. For
		 * instance, if you are skinning Feathers components without a theme,
		 * you might use this factory to style the text renderer.
		 *
		 * <p>The factory should have the following function signature:</p>
		 * <pre>function():ITextRenderer</pre>
		 *
		 * <p>In the following example, a custom text renderer factory is passed
		 * to the label:</p>
		 *
		 * <listing version="3.0">
		 * label.textRendererFactory = function():ITextRenderer
		 * {
		 *     return new TextFieldTextRenderer();
		 * }</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.ITextRenderer
		 * @see feathers.core.FeathersControl#defaultTextRendererFactory
		 */
		public function get textRendererFactory():Function
		{
			return this._textRendererFactory;
		}

		/**
		 * @private
		 */
		public function set textRendererFactory(value:Function):void
		{
			if(this._textRendererFactory == value)
			{
				return;
			}
			this._textRendererFactory = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _textRendererProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to the text renderer. The
		 * text renderer is an <code>ITextRenderer</code> instance. The
		 * available properties depend on which <code>ITextRenderer</code>
		 * implementation is returned by <code>textRendererFactory</code>. The
		 * most common implementations are <code>BitmapFontTextRenderer</code>
		 * and <code>TextFieldTextRenderer</code>.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>textRendererFactory</code> function
		 * instead of using <code>textRendererProperties</code> will result in
		 * better performance.</p>
		 *
		 * <p>In the following example, the label's text renderer's properties
		 * are updated (this example assumes that the label text renderer is a
		 * <code>TextFieldTextRenderer</code>):</p>
		 *
		 * <listing version="3.0">
		 * label.textRendererProperties.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333 );
		 * label.textRendererProperties.embedFonts = true;</listing>
		 *
		 * @default null
		 *
		 * @see #textRendererFactory
		 * @see feathers.core.ITextRenderer
		 * @see feathers.controls.text.BitmapFontTextRenderer
		 * @see feathers.controls.text.TextFieldTextRenderer
		 */
		public function get textRendererProperties():Object
		{
			if(!this._textRendererProperties)
			{
				this._textRendererProperties = new PropertyProxy(textRendererProperties_onChange);
			}
			return this._textRendererProperties;
		}

		/**
		 * @private
		 */
		public function set textRendererProperties(value:Object):void
		{
			if(this._textRendererProperties == value)
			{
				return;
			}
			if(value && !(value is PropertyProxy))
			{
				value = PropertyProxy.fromObject(value);
			}
			if(this._textRendererProperties)
			{
				this._textRendererProperties.removeOnChangeCallback(textRendererProperties_onChange);
			}
			this._textRendererProperties = PropertyProxy(value);
			if(this._textRendererProperties)
			{
				this._textRendererProperties.addOnChangeCallback(textRendererProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
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
			const textRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);

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

			if(textRendererInvalid || dataInvalid || stateInvalid || sizeInvalid || stylesInvalid)
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
			this.textRenderer.minWidth = this._minWidth;
			this.textRenderer.maxWidth = this._maxWidth;
			this.textRenderer.width = this.explicitWidth;
			this.textRenderer.measureText(HELPER_POINT);
			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				if(this._text)
				{
					newWidth = HELPER_POINT.x;
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
					newHeight = HELPER_POINT.y;
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
		protected function createTextRenderer():void
		{
			if(this.textRenderer)
			{
				this.removeChild(DisplayObject(this.textRenderer), true);
				this.textRenderer = null;
			}

			const factory:Function = this._textRendererFactory != null ? this._textRendererFactory : FeathersControl.defaultTextRendererFactory;
			this.textRenderer = ITextRenderer(factory());
			this.addChild(DisplayObject(this.textRenderer));
		}

		/**
		 * @private
		 */
		protected function refreshEnabled():void
		{
			this.textRenderer.isEnabled = this._isEnabled;
		}

		/**
		 * @private
		 */
		protected function refreshTextRendererData():void
		{
			this.textRenderer.text = this._text;
			this.textRenderer.visible = this._text && this._text.length > 0;
		}

		/**
		 * @private
		 */
		protected function refreshTextRendererStyles():void
		{
			const displayTextRenderer:DisplayObject = DisplayObject(this.textRenderer);
			for(var propertyName:String in this._textRendererProperties)
			{
				if(displayTextRenderer.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._textRendererProperties[propertyName];
					displayTextRenderer[propertyName] = propertyValue;
				}
			}
		}

		/**
		 * @private
		 */
		protected function layout():void
		{
			this.textRenderer.width = this.actualWidth;
			this.textRenderer.validate();
			this._baseline = this.textRenderer.baseline;
		}

		/**
		 * @private
		 */
		protected function textRendererProperties_onChange(proxy:PropertyProxy, propertyName:String):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
	}
}
