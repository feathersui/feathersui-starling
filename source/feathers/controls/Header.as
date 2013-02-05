/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.core.PropertyProxy;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.ViewPortBounds;

	import flash.geom.Point;

	import starling.display.DisplayObject;

	/**
	 * A header that displays an optional title along with a horizontal regions
	 * on the sides for additional UI controls. The left side is typically for
	 * navigation (to display a back button, for example) and the right for
	 * additional actions. The title is displayed in the center by default,
	 * but it may be aligned to the left or right if there are no items on the
	 * desired side.
	 *
	 * @see http://wiki.starling-framework.org/feathers/header
	 */
	public class Header extends FeathersControl
	{
		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_LEFT_CONTENT:String = "leftContent";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_RIGHT_CONTENT:String = "rightContent";

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
		 * The items will be aligned to the top of the bounds.
		 */
		public static const VERTICAL_ALIGN_TOP:String = "top";

		/**
		 * The items will be aligned to the middle of the bounds.
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";

		/**
		 * The items will be aligned to the bottom of the bounds.
		 */
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";

		/**
		 * The default value added to the <code>nameList</code> of the header's
		 * items.
		 */
		public static const DEFAULT_CHILD_NAME_ITEM:String = "feathers-header-item";

		/**
		 * The default value added to the <code>nameList</code> of the header's
		 * title.
		 */
		public static const DEFAULT_CHILD_NAME_TITLE:String = "feathers-header-title";

		/**
		 * @private
		 */
		private static const HELPER_BOUNDS:ViewPortBounds = new ViewPortBounds();

		/**
		 * @private
		 */
		private static const HELPER_LAYOUT_RESULT:LayoutBoundsResult = new LayoutBoundsResult();

		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * Constructor.
		 */
		public function Header()
		{
			super();
		}

		/**
		 * The value added to the <code>nameList</code> of the header's title.
		 */
		protected var titleName:String = DEFAULT_CHILD_NAME_TITLE;

		/**
		 * The value added to the <code>nameList</code> of the header's items.
		 */
		protected var itemName:String = DEFAULT_CHILD_NAME_ITEM;

		/**
		 * @private
		 */
		protected var leftItemsWidth:Number = 0;

		/**
		 * @private
		 */
		protected var rightItemsWidth:Number = 0;

		/**
		 * @private
		 * The layout algorithm. Shared by both sides.
		 */
		protected var _layout:HorizontalLayout;

		/**
		 * @private
		 */
		protected var _title:String = "";

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
			if(value === null)
			{
				value = "";
			}
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
		protected var _titleFactory:Function;

		/**
		 * A function used to instantiate the header's title subcomponent.
		 *
		 * <p>The factory should have the following function signature:</p>
		 * <pre>function():ITextRenderer</pre>
		 *
		 * @see feathers.core.ITextRenderer
		 * @see feathers.core.FeathersControl#defaultTextRendererFactory
		 */
		public function get titleFactory():Function
		{
			return this._titleFactory;
		}

		/**
		 * @private
		 */
		public function set titleFactory(value:Function):void
		{
			if(this._titleFactory == value)
			{
				return;
			}
			this._titleFactory = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _titleRenderer:ITextRenderer;

		/**
		 * @private
		 */
		protected var _leftItems:Vector.<DisplayObject>;

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
					if(item is IFeathersControl)
					{
						IFeathersControl(item).nameList.remove(this.itemName);
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
		protected var _rightItems:Vector.<DisplayObject>;

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
					if(item is IFeathersControl)
					{
						IFeathersControl(item).nameList.remove(this.itemName);
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
		protected var _paddingTop:Number = 0;

		/**
		 * The minimum space, in pixels, between the header's top edge and the
		 * header's content.
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
		 * The minimum space, in pixels, between the header's right edge and the
		 * header's content.
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
		 * The minimum space, in pixels, between the header's bottom edge and
		 * the header's content.
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
		 * The minimum space, in pixels, between the header's left edge and the
		 * header's content.
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
		protected var _verticalAlign:String = VERTICAL_ALIGN_MIDDLE;

		[Inspectable(type="String",enumeration="top,middle,bottom")]
		/**
		 * The alignment of the items vertically, on the y-axis.
		 */
		public function get verticalAlign():String
		{
			return this._verticalAlign;
		}

		/**
		 * @private
		 */
		public function set verticalAlign(value:String):void
		{
			if(this._verticalAlign == value)
			{
				return;
			}
			this._verticalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var originalBackgroundWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var originalBackgroundHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var _backgroundSkin:DisplayObject;

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
		protected var _backgroundDisabledSkin:DisplayObject;

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
		protected var _titleProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to the headers's title
		 * instance.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * @see feathers.core.ITextRenderer
		 */
		public function get titleProperties():Object
		{
			if(!this._titleProperties)
			{
				this._titleProperties = new PropertyProxy(titleProperties_onChange);
			}
			return this._titleProperties;
		}

		/**
		 * @private
		 */
		public function set titleProperties(value:Object):void
		{
			if(this._titleProperties == value)
			{
				return;
			}
			if(value && !(value is PropertyProxy))
			{
				value = PropertyProxy.fromObject(value);
			}
			if(this._titleProperties)
			{
				this._titleProperties.removeOnChangeCallback(titleProperties_onChange);
			}
			this._titleProperties = PropertyProxy(value);
			if(this._titleProperties)
			{
				this._titleProperties.addOnChangeCallback(titleProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _titleAlign:String = TITLE_ALIGN_CENTER;

		[Inspectable(type="String",enumeration="center,preferLeft,preferRight")]
		/**
		 * The preferred position of the title. If leftItems and/or rightItems
		 * is defined, the title may be forced to the center even if the
		 * preferred position is on the left or right.
		 *
		 * @default TITLE_ALIGN_CENTER
		 * @see #TITLE_ALIGN_CENTER
		 * @see #TITLE_ALIGN_PREFER_LEFT
		 * @see #TITLE_ALIGN_PREFER_RIGHT
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
			if(!this._layout)
			{
				this._layout = new HorizontalLayout();
				this._layout.useVirtualLayout = false;
				this._layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
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
			const textRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);

			if(textRendererInvalid)
			{
				this.createTitle();
			}

			if(textRendererInvalid || dataInvalid)
			{
				this._titleRenderer.text = this._title;
			}

			if(textRendererInvalid || stylesInvalid)
			{
				this.refreshLayout();
				this.refreshTitleStyles();
			}

			if(leftContentInvalid)
			{
				if(this._leftItems)
				{
					for each(var item:DisplayObject in this._leftItems)
					{
						if(item is IFeathersControl)
						{
							IFeathersControl(item).nameList.add(this.itemName);
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
						if(item is IFeathersControl)
						{
							IFeathersControl(item).nameList.add(this.itemName);
						}
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
				this.leftItemsWidth = 0;
				this.rightItemsWidth = 0;
				if(this._leftItems)
				{
					this.layoutLeftItems();
				}
				if(this._rightItems)
				{
					this.layoutRightItems();
				}
			}

			if(textRendererInvalid || sizeInvalid || stylesInvalid || dataInvalid || leftContentInvalid || rightContentInvalid)
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
			var newWidth:Number = needsWidth ? (this._paddingLeft + this._paddingRight) : this.explicitWidth;
			var newHeight:Number = needsHeight ? 0 : this.explicitHeight;

			if(this._backgroundSkin)
			{
				if(isNaN(this.originalBackgroundWidth))
				{
					this.originalBackgroundWidth = this._backgroundSkin.width;
				}
				if(isNaN(this.originalBackgroundHeight))
				{
					this.originalBackgroundHeight = this._backgroundSkin.height;
				}
			}

			var totalItemWidth:Number = 0;
			for each(var item:DisplayObject in this._leftItems)
			{
				if(item is IFeathersControl)
				{
					IFeathersControl(item).validate();
				}
				if(needsWidth && !isNaN(item.width))
				{
					totalItemWidth += item.width + this._gap;
				}
				if(needsHeight && !isNaN(item.height))
				{
					newHeight = Math.max(newHeight, item.height);
				}
			}
			for each(item in this._rightItems)
			{
				if(item is IFeathersControl)
				{
					IFeathersControl(item).validate();
				}
				if(needsWidth && !isNaN(item.width))
				{
					totalItemWidth += item.width + this._gap;
				}
				if(needsHeight && !isNaN(item.height))
				{
					newHeight = Math.max(newHeight, item.height);
				}
			}
			newWidth += totalItemWidth;

			const maxTitleWidth:Number = (needsWidth ? this._maxWidth : this.explicitWidth) - totalItemWidth - this._paddingLeft - this._paddingRight;
			this._titleRenderer.maxWidth = maxTitleWidth;
			this._titleRenderer.measureText(HELPER_POINT);
			const measuredTitleWidth:Number = HELPER_POINT.x;
			const measuredTitleHeight:Number = HELPER_POINT.x;
			if(needsWidth && !isNaN(measuredTitleWidth))
			{
				newWidth += HELPER_POINT.x;
			}
			if(needsHeight && !isNaN(measuredTitleHeight))
			{
				newHeight = Math.max(newHeight, HELPER_POINT.y);
			}
			if(needsHeight)
			{
				newHeight += this._paddingTop + this._paddingBottom;
			}
			if(needsWidth && !isNaN(this.originalBackgroundWidth))
			{
				newWidth = Math.max(newWidth, this.originalBackgroundWidth);
			}
			if(needsHeight && !isNaN(this.originalBackgroundHeight))
			{
				newHeight = Math.max(newHeight, this.originalBackgroundHeight);
			}

			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		protected function createTitle():void
		{
			if(this._titleRenderer)
			{
				this.removeChild(DisplayObject(this._titleRenderer), true);
				this._titleRenderer = null;
			}

			const factory:Function = this._titleFactory != null ? this._titleFactory : FeathersControl.defaultTextRendererFactory;
			this._titleRenderer = ITextRenderer(factory());
			const uiTitleRenderer:IFeathersControl = IFeathersControl(this._titleRenderer);
			uiTitleRenderer.nameList.add(this.titleName);
			uiTitleRenderer.touchable = false;
			this.addChild(DisplayObject(uiTitleRenderer));
		}

		/**
		 * @private
		 */
		protected function refreshLayout():void
		{
			this._layout.gap = this._gap;
			this._layout.paddingTop = this._paddingTop;
			this._layout.paddingBottom = this._paddingBottom;
			this._layout.verticalAlign = this._verticalAlign;
		}

		/**
		 * @private
		 */
		protected function refreshTitleStyles():void
		{
			const displayTitleRenderer:DisplayObject = DisplayObject(this._titleRenderer);
			for(var propertyName:String in this._titleProperties)
			{
				if(displayTitleRenderer.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._titleProperties[propertyName];
					displayTitleRenderer[propertyName] = propertyValue;
				}
			}
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
			for each(var item:DisplayObject in this._leftItems)
			{
				if(item is IFeathersControl)
				{
					IFeathersControl(item).validate();
				}
			}
			HELPER_BOUNDS.x = HELPER_BOUNDS.y = 0;
			HELPER_BOUNDS.explicitWidth = this.actualWidth;
			HELPER_BOUNDS.explicitHeight = this.actualHeight;
			this._layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			this._layout.paddingRight = 0;
			this._layout.paddingLeft = this._paddingLeft;
			this._layout.layout(this._leftItems, HELPER_BOUNDS, HELPER_LAYOUT_RESULT);
			this.leftItemsWidth = HELPER_LAYOUT_RESULT.contentWidth;
			if(isNaN(this.leftItemsWidth))
			{
				this.leftItemsWidth = 0;
			}

		}

		/**
		 * @private
		 */
		protected function layoutRightItems():void
		{
			for each(var item:DisplayObject in this._rightItems)
			{
				if(item is IFeathersControl)
				{
					IFeathersControl(item).validate();
				}
			}
			HELPER_BOUNDS.x = HELPER_BOUNDS.y = 0;
			HELPER_BOUNDS.explicitWidth = this.actualWidth;
			HELPER_BOUNDS.explicitHeight = this.actualHeight;
			this._layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_RIGHT;
			this._layout.paddingRight = this._paddingRight;
			this._layout.paddingLeft = 0;
			this._layout.layout(this._rightItems, HELPER_BOUNDS, HELPER_LAYOUT_RESULT);
			this.rightItemsWidth = HELPER_LAYOUT_RESULT.contentWidth;
			if(isNaN(this.rightItemsWidth))
			{
				this.rightItemsWidth = 0;
			}
		}

		/**
		 * @private
		 */
		protected function layoutTitle():void
		{
			if(this._title.length == 0)
			{
				return;
			}
			const leftOffset:Number = (this._leftItems && this._leftItems.length > 0) ? (this.leftItemsWidth + this._gap) : 0;
			const rightOffset:Number = (this._rightItems && this._rightItems.length > 0) ? (this.rightItemsWidth + this._gap) : 0;
			if(this._titleAlign == TITLE_ALIGN_PREFER_LEFT && (!this._leftItems || this._leftItems.length == 0))
			{
				this._titleRenderer.maxWidth = this.actualWidth - this._paddingLeft - this._paddingRight - rightOffset;
				this._titleRenderer.validate();
				this._titleRenderer.x = this._paddingLeft;
			}
			else if(this._titleAlign == TITLE_ALIGN_PREFER_RIGHT && (!this._rightItems || this._rightItems.length == 0))
			{
				this._titleRenderer.maxWidth = this.actualWidth - this._paddingLeft - this._paddingRight - leftOffset;
				this._titleRenderer.validate();
				this._titleRenderer.x = this.actualWidth - this._paddingRight - this._titleRenderer.width;
			}
			else
			{
				const sharedOffset:Number = Math.max(leftOffset, rightOffset);
				const availableWidth:Number = this.actualWidth - this._paddingLeft - this._paddingRight - 2 * sharedOffset;
				this._titleRenderer.maxWidth = availableWidth;
				this._titleRenderer.validate();
				this._titleRenderer.x = this._paddingLeft + sharedOffset + (availableWidth - this._titleRenderer.width) / 2;
			}
			if(this._verticalAlign == VERTICAL_ALIGN_TOP)
			{
				this._titleRenderer.y = this._paddingTop;
			}
			else if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
			{
				this._titleRenderer.y = this.actualHeight - this._paddingBottom - this._titleRenderer.height;
			}
			else
			{
				this._titleRenderer.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this._titleRenderer.height) / 2;
			}
		}

		/**
		 * @private
		 */
		protected function titleProperties_onChange(proxy:PropertyProxy, propertyName:String):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
	}
}
