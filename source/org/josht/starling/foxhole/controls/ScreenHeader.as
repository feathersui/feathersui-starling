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
	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.text.BitmapFontTextFormat;

	import starling.display.DisplayObject;

	/**
	 * A header that displays a title along with a horizontal regions on the
	 * sides for additional UI controls. The left side is typically for
	 * navigation (to display a back button, for example) and the right for
	 * additional actions.
	 */
	public class ScreenHeader extends FoxholeControl
	{
		/**
		 * @private
		 */
		public static const INVALIDATION_FLAG_LEFT_CONTENT:String = "leftContent";

		/**
		 * @private
		 */
		public static const INVALIDATION_FLAG_RIGHT_CONTENT:String = "rightContent";

		/**
		 * The title will appear in the center of the header.
		 */
		public static const TITLE_ALIGN_CENTER:String = "center";

		/**
		 * The title will appear on the left of the header, if there is no other
		 * content on that side. If there is content, the title will appear in
		 * the center.
		 */
		public static const TITLE_ALIGN_PREFER_LEFT:String = "preferLeft";

		/**
		 * The title will appear on the right of the header, if there is no
		 * other content on that side. If there is content, the title will
		 * appear in the center.
		 */
		public static const TITLE_ALIGN_PREFER_RIGHT:String = "preferRight";

		/**
		 * @private
		 */
		private static const ITEM_NAME:String = "foxhole-header-item";

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
		private var _leftItems:Vector.<DisplayObject>;

		/**
		 * The UI controls that appear in the left region of the header.
		 */
		public function get leftItems():Vector.<DisplayObject>
		{
			return this._leftItems.concat();
		}

		/**
		 * @private
		 */
		public function set leftItems(value:Vector.<DisplayObject>):void
		{
			if(this._leftItems == value)
			{
				return;
			}
			if(this._leftItems)
			{
				for each(var item:DisplayObject in this._leftItems)
				{
					if(item is FoxholeControl)
					{
						FoxholeControl(item).nameList.remove(ITEM_NAME);
					}
					item.removeFromParent();
				}
			}
			this._leftItems = value;
			this.invalidate(INVALIDATION_FLAG_LEFT_CONTENT);
		}

		/**
		 * @private
		 */
		private var _rightItems:Vector.<DisplayObject>;

		/**
		 * The UI controls that appear in the right region of the header.
		 */
		public function get rightItems():Vector.<DisplayObject>
		{
			return this._rightItems.concat();
		}

		/**
		 * @private
		 */
		public function set rightItems(value:Vector.<DisplayObject>):void
		{
			if(this._rightItems == value)
			{
				return;
			}
			if(this._rightItems)
			{
				for each(var item:DisplayObject in this._rightItems)
				{
					if(item is FoxholeControl)
					{
						FoxholeControl(item).nameList.remove(ITEM_NAME);
					}
					item.removeFromParent();
				}
			}
			this._rightItems = value;
			this.invalidate(INVALIDATION_FLAG_RIGHT_CONTENT);
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
		private var _titleAlign:String = TITLE_ALIGN_CENTER;

		/**
		 * The preferred position of the title. If leftItems and/or rightItems
		 * is defined, the title may be forced to the center even if the
		 * preferred position is on the left or right.
		 */
		public function get titleAlign():String
		{
			return this._titleAlign;
		}

		/**
		 * @private
		 */
		public function set titleAlign(value:String):void
		{
			if(this._titleAlign == value)
			{
				return;
			}
			this._titleAlign = value;
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
				this._titleLabel.nameList.add("foxhole-header-title");
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
			const leftContentInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LEFT_CONTENT);
			const rightContentInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_RIGHT_CONTENT);

			if(dataInvalid)
			{
				this._titleLabel.text = this._title;
			}

			if(stylesInvalid)
			{
				this._titleLabel.textFormat = this._textFormat;
			}

			if(leftContentInvalid)
			{
				if(this._leftItems)
				{
					for each(var item:DisplayObject in this._leftItems)
					{
						if(item is FoxholeControl)
						{
							FoxholeControl(item).nameList.add(ITEM_NAME);
						}
						this.addChild(item);
					}
				}
			}

			if(rightContentInvalid)
			{
				if(this._rightItems)
				{
					for each(item in this._rightItems)
					{
						FoxholeControl(item).nameList.add(ITEM_NAME);
						this.addChild(item);
					}
				}
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(sizeInvalid || stylesInvalid)
			{
				this.layoutBackground();
			}

			if(sizeInvalid || leftContentInvalid || rightContentInvalid || stylesInvalid)
			{
				this.layoutLeftItems();
				this.layoutRightItems();
			}

			if(sizeInvalid || stylesInvalid || dataInvalid || leftContentInvalid || rightContentInvalid)
			{
				this.layoutTitle();
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
			var newWidth:Number = needsWidth ? (2 * this._contentPadding) : this.explicitWidth;
			var newHeight:Number = needsHeight ? 0 : this.explicitHeight;

			for each(var item:DisplayObject in this._leftItems)
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
			for each(item in this._rightItems)
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
				backgroundSkin.width = this.actualWidth;
				backgroundSkin.height = this.actualHeight;
			}
		}

		/**
		 * @private
		 */
		protected function layoutLeftItems():void
		{
			if(!this._leftItems)
			{
				return;
			}
			var positionX:Number = this._contentPadding;
			const itemCount:int = this._leftItems.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = this._leftItems[i];
				if(item is FoxholeControl)
				{
					FoxholeControl(item).validate();
				}
				item.x = positionX;
				item.y = (this.actualHeight - item.height) / 2;
				positionX += item.width + this._gap;
			}

		}

		/**
		 * @private
		 */
		protected function layoutRightItems():void
		{
			if(!this._rightItems)
			{
				return;
			}
			var positionX:Number = this.actualWidth - this._contentPadding;
			const itemCount:int = this._rightItems.length;
			for(var i:int = itemCount - 1; i >= 0; i--)
			{
				var item:DisplayObject = this._rightItems[i];
				if(item is FoxholeControl)
				{
					FoxholeControl(item).validate();
				}
				positionX -= item.width;
				item.x = positionX;
				item.y = (this.actualHeight - item.height) / 2;
				positionX -= this._gap;
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
			this._titleLabel.validate();
			if(this._titleAlign == TITLE_ALIGN_PREFER_LEFT && (!this._leftItems || this._leftItems.length == 0))
			{
				this._titleLabel.x = this._contentPadding;
			}
			else if(this._titleAlign == TITLE_ALIGN_PREFER_RIGHT && (!this._rightItems || this._rightItems.length == 0))
			{
				this._titleLabel.x = this.actualWidth - this._contentPadding - this._titleLabel.width;
			}
			else
			{
				this._titleLabel.x = (this.actualWidth - this._titleLabel.width) / 2;
			}
			this._titleLabel.y = (this.actualHeight - this._titleLabel.height) / 2;
		}
	}
}
