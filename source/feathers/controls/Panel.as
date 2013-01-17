/*
 Copyright 2012-2013 Joshua Tynjala

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
	import feathers.controls.supportClasses.LayoutViewPort;
	import feathers.core.FeathersControl;
	import feathers.core.PropertyProxy;

	import starling.display.DisplayObject;

	/**
	 * A container with a header and layout.
	 */
	public class Panel extends ScrollContainer
	{
		/**
		 * The default value added to the <code>nameList</code> of the header.
		 */
		public static const DEFAULT_CHILD_NAME_HEADER:String = "feathers-panel-header";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_HEADER_FACTORY:String = "headerFactory";

		/**
		 * @private
		 */
		protected static function defaultHeaderFactory():Header
		{
			return new Header();
		}

		/**
		 * Constructor.
		 */
		public function Panel()
		{
			super();
		}

		/**
		 * The Header sub-component.
		 */
		protected var header:Header;

		/**
		 * The default value added to the <code>nameList</code> of the header.
		 */
		protected var headerName:String = DEFAULT_CHILD_NAME_HEADER;

		/**
		 * @private
		 */
		protected var _headerFactory:Function;

		/**
		 * A function used to generate the panel's header sub-component.
		 * This can be used to change properties on the header when it is first
		 * created. For instance, if you are skinning Feathers components
		 * without a theme, you might use <code>headerFactory</code> to set
		 * skins and text styles on the header.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():Header</pre>
		 *
		 * @see #headerProperties
		 */
		public function get headerFactory():Function
		{
			return this._headerFactory;
		}

		/**
		 * @private
		 */
		public function set headerFactory(value:Function):void
		{
			if(this._headerFactory == value)
			{
				return;
			}
			this._headerFactory = value;
			this.invalidate(INVALIDATION_FLAG_HEADER_FACTORY);
			//hack because the super class doesn't know anything about the
			//header factory
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		protected var _customHeaderName:String;

		/**
		 * A name to add to the panel's header sub-component. Typically
		 * used by a theme to provide different skins to different panels.
		 *
		 * @see #DEFAULT_CHILD_NAME_HEADER
		 * @see feathers.core.FeathersControl#nameList
		 * @see #headerFactory
		 * @see #headerProperties
		 */
		public function get customHeaderName():String
		{
			return this._customHeaderName;
		}

		/**
		 * @private
		 */
		public function set customHeaderName(value:String):void
		{
			if(this._customHeaderName == value)
			{
				return;
			}
			this._customHeaderName = value;
			this.invalidate(INVALIDATION_FLAG_HEADER_FACTORY);
			//hack because the super class doesn't know anything about the
			//header factory
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		protected var _headerProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to the container's
		 * scroller sub-component. The scroller is a
		 * <code>feathers.controls.Scroller</code> instance.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * @see feathers.controls.Header
		 */
		public function get headerProperties():Object
		{
			if(!this._headerProperties)
			{
				this._headerProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._headerProperties;
		}

		/**
		 * @private
		 */
		public function set headerProperties(value:Object):void
		{
			if(this._headerProperties == value)
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
			if(this._headerProperties)
			{
				this._headerProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._headerProperties = PropertyProxy(value);
			if(this._headerProperties)
			{
				this._headerProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			const headerFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_HEADER_FACTORY);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);

			if(headerFactoryInvalid)
			{
				this.createHeader();
			}

			if(headerFactoryInvalid || stylesInvalid)
			{
				this.refreshHeaderStyles();
			}

			super.draw();
		}

		/**
		 * @private
		 */
		override protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}

			this.header.validate();
			this.scroller.validate();

			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth)
			{
				newWidth = Math.max(this.scroller.width + this._paddingLeft + this._paddingRight, this.header.width);
				if(!isNaN(this._originalBackgroundWidth))
				{
					newWidth = Math.max(newWidth, this._originalBackgroundWidth);
				}
			}
			if(needsHeight)
			{
				newHeight = this.scroller.height + this._paddingTop + this._paddingBottom + this.header.height;
				if(!isNaN(this._originalBackgroundHeight))
				{
					newHeight = Math.max(newHeight, this._originalBackgroundHeight);
				}
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		protected function createHeader():void
		{
			if(this.header)
			{
				this.$removeChild(this.header, true);
				this.header = null;
			}

			const factory:Function = this._headerFactory != null ? this._headerFactory : defaultHeaderFactory;
			const headerName:String = this._customHeaderName != null ? this._customHeaderName : this.headerName;
			this.header = Header(factory());
			this.header.nameList.add(headerName);
			this.$addChild(this.header);
		}

		/**
		 * @private
		 */
		protected function refreshHeaderStyles():void
		{
			for(var propertyName:String in this._headerProperties)
			{
				if(this.header.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._headerProperties[propertyName];
					this.header[propertyName] = propertyValue;
				}
			}
		}

		/**
		 * @private
		 */
		override protected function refreshScrollerBounds():void
		{
			this.header.width = this.explicitWidth;
			this.header.height = NaN;
			this.header.validate();

			const scrollerWidthOffset:Number = this._paddingLeft + this._paddingRight;
			const scrollerHeightOffset:Number = this.header.height + this._paddingTop + this._paddingBottom;

			if(isNaN(this.explicitWidth))
			{
				this.scroller.width = NaN;
			}
			else
			{
				this.scroller.width = Math.max(0, this.explicitWidth - scrollerWidthOffset);
			}
			if(isNaN(this.explicitHeight))
			{
				this.scroller.height = NaN;
			}
			else
			{
				this.scroller.height = Math.max(0, this.explicitHeight - scrollerHeightOffset);
			}
			this.scroller.minWidth = Math.max(0,  this._minWidth - scrollerWidthOffset);
			this.scroller.maxWidth = Math.max(0, this._maxWidth - scrollerWidthOffset);
			this.scroller.minHeight = Math.max(0, this._minHeight - scrollerHeightOffset);
			this.scroller.maxHeight = Math.max(0, this._maxHeight - scrollerHeightOffset);
		}

		/**
		 * @private
		 */
		override protected function layoutChildren():void
		{
			if(this.currentBackgroundSkin)
			{
				this.currentBackgroundSkin.width = this.actualWidth;
				this.currentBackgroundSkin.height = this.actualHeight;
			}

			this.header.width = this.actualWidth;
			this.header.validate();

			this.scroller.x = this._paddingLeft;
			this.scroller.y = this.header.y + this.header.height + this._paddingTop;
		}
	}
}
