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
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.core.PropertyProxy;

	import flash.geom.Point;

	/**
	 * Displays text.
	 */
	public class Label extends FeathersControl
	{
		private static const HELPER_POINT:Point = new Point();

		/**
		 * Constructor.
		 */
		public function Label()
		{
			this.isQuickHitAreaEnabled = true;
		}

		/**
		 * @private
		 */
		protected var textRenderer:ITextRenderer;

		/**
		 * @private
		 */
		protected var _text:String = "";

		/**
		 * The text displayed by the label.
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
		}

		/**
		 * @private
		 */
		protected var _textRendererFactory:Function;

		/**
		 * A function used to instantiate the text renderer. If null,
		 * <code>FeathersControl.defaultTextRendererFactory</code> is used
		 * instead.
		 *
		 * <p>The factory should have the following function signature:</p>
		 * <pre>function():ITextRenderer</pre>
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
		private var _textRendererProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to the text renderer.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
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
				this._textRendererProperties.onChange.remove(textRendererProperties_onChange);
			}
			this._textRendererProperties = PropertyProxy(value);
			if(this._textRendererProperties)
			{
				this._textRendererProperties.onChange.add(textRendererProperties_onChange);
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
			FeathersControl(this.textRenderer).maxWidth = Number.POSITIVE_INFINITY;
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
				this.removeChild(FeathersControl(this.textRenderer), true);
				this.textRenderer = null;
			}

			const factory:Function = this._textRendererFactory != null ? this._textRendererFactory : FeathersControl.defaultTextRendererFactory;
			this.textRenderer = factory();
			const uiLabelRenderer:FeathersControl = FeathersControl(this.textRenderer);
			this.addChild(uiLabelRenderer);
		}

		/**
		 * @private
		 */
		protected function refreshEnabled():void
		{
			FeathersControl(this.textRenderer).isEnabled = this._isEnabled;
		}

		/**
		 * @private
		 */
		protected function refreshTextRendererData():void
		{
			this.textRenderer.text = this._text;
			FeathersControl(this.textRenderer).visible = this._text.length > 0;
		}

		/**
		 * @private
		 */
		protected function refreshTextRendererStyles():void
		{
			const uiTextRenderer:FeathersControl = FeathersControl(this.textRenderer);
			for(var propertyName:String in this._textRendererProperties)
			{
				if(uiTextRenderer.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._textRendererProperties[propertyName];
					uiTextRenderer[propertyName] = propertyValue;
				}
			}
		}

		/**
		 * @private
		 */
		protected function layout():void
		{
			FeathersControl(this.textRenderer).maxWidth = this.actualWidth;
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
