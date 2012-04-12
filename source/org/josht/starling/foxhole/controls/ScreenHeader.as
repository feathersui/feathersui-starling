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
	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.text.BitmapFontTextFormat;

	import starling.display.DisplayObject;

	/**
	 * A header that displays a title along with a horizontal regions for
	 * additional UI controls on the sides. The Left side is for navigation and
	 * the right for additional actions.
	 */
	public class ScreenHeader extends FoxholeControl
	{
		/**
		 * Constructor.
		 */
		public function ScreenHeader()
		{
		}

		/**
		 * @private
		 */
		private var _title:String;

		/**
		 * The text displayed for the header's title.
		 */
		public function get title():String
		{
			return this._title;
		}

		/**
		 * @private
		 */
		public function set title(value:String):void
		{
			if(this._title == value)
			{
				return;
			}
			this._title = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		private var _titleLabel:Label;

		/**
		 * @private
		 */
		private var _navigationItems:Vector.<DisplayObject>;

		/**
		 * The UI controls that appear in the left region of the header.
		 */
		public function get navigationItems():Vector.<DisplayObject>
		{
			return this._navigationItems.concat();
		}

		/**
		 * @private
		 */
		public function set navigationItems(value:Vector.<DisplayObject>):void
		{
			if(this._navigationItems == value)
			{
				return;
			}
			if(this._navigationItems)
			{
				for each(var item:DisplayObject in this._navigationItems)
				{
					item.removeFromParent();
				}
			}
			this._navigationItems = value;
			if(this._navigationItems)
			{
				for each(item in this._navigationItems)
				{
					this.addChild(item);
				}
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		private var _actionItems:Vector.<DisplayObject>;

		/**
		 * The UI controls that appear in the right region of the header.
		 */
		public function get actionItems():Vector.<DisplayObject>
		{
			return this._actionItems.concat();
		}

		/**
		 * @private
		 */
		public function set actionItems(value:Vector.<DisplayObject>):void
		{
			if(this._actionItems == value)
			{
				return;
			}
			if(this._actionItems)
			{
				for each(var item:DisplayObject in this._actionItems)
				{
					item.removeFromParent();
				}
			}
			this._actionItems = value;
			if(this._actionItems)
			{
				for each(item in this._actionItems)
				{
					this.addChild(item);
				}
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
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
		protected var _gap:Number = 0;

		/**
		 * Space, in pixels, between items.
		 */
		public function get gap():Number
		{
			return _gap;
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
		private var _textFormat:BitmapFontTextFormat;

		/**
		 * The font and styles used to draw the title text.
		 */
		public function get textFormat():BitmapFontTextFormat
		{
			return this._textFormat;
		}

		/**
		 * @private
		 */
		public function set textFormat(value:BitmapFontTextFormat):void
		{
			if(this._textFormat == value)
			{
				return;
			}
			this._textFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(!this._titleLabel)
			{
				this._titleLabel = new Label();
				this._titleLabel.name = "foxhole-header-title";
				this._titleLabel.touchable = false;
				this.addChild(this._titleLabel);
			}
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);

			if(dataInvalid)
			{
				this._titleLabel.text = this._title;
			}

			if(stylesInvalid)
			{
				this._titleLabel.textFormat = this._textFormat;
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(sizeInvalid || dataInvalid || stylesInvalid)
			{
				this.layoutBackground();
				this.layoutNavigationItems();
				this.layoutActionItems();
				this.layoutTitle();
			}

		}

		/**
		 * @private
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			var needsWidth:Boolean = isNaN(this._width);
			var needsHeight:Boolean = isNaN(this._height);
			var newWidth:Number = needsWidth ? (2 * this._contentPadding) : this._width;
			var newHeight:Number = needsHeight ? 0 : this._height;

			if(!needsWidth && !needsHeight)
			{
				return false;
			}

			for each(var item:DisplayObject in this._navigationItems)
			{
				if(item is FoxholeControl)
				{
					FoxholeControl(item).validate();
				}
				if(needsWidth && !isNaN(item.width))
				{
					newWidth += item.width + this._gap;
				}
				if(needsHeight && !isNaN(item.height))
				{
					newHeight = Math.max(newHeight, item.height);
				}
			}
			for each(item in this._actionItems)
			{
				if(item is FoxholeControl)
				{
					FoxholeControl(item).validate();
				}
				if(needsWidth && !isNaN(item.width))
				{
					newWidth += item.width + this._gap;
				}
				if(needsHeight && !isNaN(item.height))
				{
					newHeight = Math.max(newHeight, item.height);
				}
			}

			this._titleLabel.validate();
			if(needsWidth && !isNaN(this._titleLabel.width))
			{
				newWidth += this._titleLabel.width;
			}
			if(needsHeight && !isNaN(this._titleLabel.height))
			{
				newHeight = Math.max(newHeight, this._titleLabel.height);
			}
			if(needsHeight)
			{
				newHeight += 2 * this._contentPadding;
			}

			this.setSizeInternal(newWidth, newHeight, false);
			return true;
		}

		/**
		 * @private
		 */
		protected function layoutBackground():void
		{
			var backgroundSkin:DisplayObject = this._backgroundSkin;
			if(!this._isEnabled && this._backgroundDisabledSkin)
			{
				if(this._backgroundSkin)
				{
					this._backgroundSkin.visible = false;
					this._backgroundSkin.touchable = false;
				}
				backgroundSkin = this._backgroundDisabledSkin;
			}
			else if(this._backgroundDisabledSkin)
			{
				this._backgroundDisabledSkin.visible = false;
				this._backgroundDisabledSkin.touchable = false;
			}
			if(backgroundSkin)
			{
				backgroundSkin.visible = true;
				backgroundSkin.touchable = true;
				backgroundSkin.width = this._width;
				backgroundSkin.height = this._height;
			}
		}

		/**
		 * @private
		 */
		protected function layoutNavigationItems():void
		{
			if(!this._navigationItems)
			{
				return;
			}
			var positionX:Number = this._contentPadding;
			const itemCount:int = this._navigationItems.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = this._navigationItems[i];
				item.x = positionX;
				item.y = (this._height - item.height) / 2;
				positionX += item.width + this._gap;
			}

		}

		/**
		 * @private
		 */
		protected function layoutActionItems():void
		{
			if(!this._actionItems)
			{
				return;
			}
			var positionX:Number = this._width - this._contentPadding;
			const itemCount:int = this._actionItems.length;
			for(var i:int = itemCount - 1; i >= 0; i--)
			{
				var item:DisplayObject = this._navigationItems[i];
				item.x = positionX;
				item.y = (this._height - item.height) / 2;
				positionX -= item.width + this._gap;
			}
		}

		/**
		 * @private
		 */
		protected function layoutTitle():void
		{
			if(!this._title)
			{
				return;
			}
			this._titleLabel.x = (this._width - this._titleLabel.width) / 2;
			this._titleLabel.y = (this._height - this._titleLabel.height) / 2;
		}
	}
}
