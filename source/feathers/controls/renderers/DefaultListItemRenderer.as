/*
Feathers
Copyright 2012-2020 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.renderers
{
	import feathers.controls.List;
	import feathers.events.FeathersEventType;
	import feathers.skins.IStyleProvider;
	import starling.display.DisplayObject;
	import feathers.core.IValidating;
	import feathers.core.IFeathersControl;
	import starling.events.Event;

	/**
	 * An optional icon used to drag and drop the list item.
	 *
	 * <p>The following example gives the item renderer a drag icon:</p>
	 *
	 * <listing version="3.0">
	 * itemRenderer.dragIcon = new Image( texture );</listing>
	 *
	 * @default null
	 */
	[Style(name="dragIcon",type="starling.display.DisplayObject")]

	/**
	 * The default item renderer for List control. Supports up to three optional
	 * sub-views, including a label to display text, an icon to display an
	 * image, and an "accessory" to display a UI control or another display
	 * object (with shortcuts for including a second image or a second label).
	 * 
	 * @see feathers.controls.List
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class DefaultListItemRenderer extends BaseDefaultItemRenderer implements IListItemRenderer, IDragAndDropItemRenderer
	{
		/**
		 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#ALTERNATE_STYLE_NAME_DRILL_DOWN
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const ALTERNATE_STYLE_NAME_DRILL_DOWN:String = "feathers-drill-down-item-renderer";

		/**
		 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#ALTERNATE_STYLE_NAME_CHECK
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const ALTERNATE_STYLE_NAME_CHECK:String = "feathers-check-item-renderer";

		/**
		 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#DEFAULT_CHILD_STYLE_NAME_LABEL
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_LABEL:String = "feathers-item-renderer-label";

		/**
		 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#DEFAULT_CHILD_STYLE_NAME_ICON_LABEL
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_ICON_LABEL:String = "feathers-item-renderer-icon-label";

		/**
		 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL:String = "feathers-item-renderer-accessory-label";

		/**
		 * The default <code>IStyleProvider</code> for all <code>DefaultListItemRenderer</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function DefaultListItemRenderer()
		{
			super();
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return DefaultListItemRenderer.globalStyleProvider;
		}
		
		/**
		 * @private
		 */
		protected var _index:int = -1;
		
		/**
		 * @inheritDoc
		 */
		public function get index():int
		{
			return this._index;
		}
		
		/**
		 * @private
		 */
		public function set index(value:int):void
		{
			this._index = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get owner():List
		{
			return List(this._owner);
		}
		
		/**
		 * @private
		 */
		public function set owner(value:List):void
		{
			if(this._owner === value)
			{
				return;
			}
			if(this._owner)
			{
				this._owner.removeEventListener(FeathersEventType.SCROLL_START, owner_scrollStartHandler);
				this._owner.removeEventListener(FeathersEventType.SCROLL_COMPLETE, owner_scrollCompleteHandler);
			}
			this._owner = value;
			if(this._owner)
			{
				var list:List = List(this._owner);
				this.isSelectableWithoutToggle = list.isSelectable;
				if(list.allowMultipleSelection)
				{
					//toggling is forced in this case
					this.isToggle = true;
				}
				this._owner.addEventListener(FeathersEventType.SCROLL_START, owner_scrollStartHandler);
				this._owner.addEventListener(FeathersEventType.SCROLL_COMPLETE, owner_scrollCompleteHandler);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _dragEnabled:Boolean = false;

		/**
		 * @private
		 */
		public function get dragEnabled():Boolean
		{
			return this._dragEnabled;
		}

		/**
		 * @private
		 */
		public function set dragEnabled(value:Boolean):void
		{
			if(this._dragEnabled === value)
			{
				return;
			}
			this._dragEnabled = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _dragIcon:DisplayObject = null;

		/**
		 * @private
		 */
		public function get dragIcon():DisplayObject
		{
			return this._dragIcon;
		}

		/**
		 * @private
		 */
		public function set dragIcon(value:DisplayObject):void
		{
			if(this._dragIcon === value)
			{
				return;
			}
			if(this._dragIcon !== null)
			{
				if(this._dragIcon is IFeathersControl)
				{
					IFeathersControl(this._dragIcon).removeEventListener(FeathersEventType.RESIZE, dragIcon_resizeHandler);
				}
				//if this icon needs to be reused somewhere else, we need to
				//properly clean it up
				if(this._dragIcon.parent === this)
				{
					this._dragIcon.removeFromParent(false);
				}
				this._dragIcon = null;
			}
			this._dragIcon = value;
			if(this._dragIcon !== null)
			{
				this.addChild(this._dragIcon);
				if(this._dragIcon is IFeathersControl)
				{
					IFeathersControl(this._dragIcon).addEventListener(FeathersEventType.RESIZE, dragIcon_resizeHandler);
				}
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _dragGap:Number = NaN;

		/**
		 * @private
		 */
		public function get dragGap():Number
		{
			return this._dragGap;
		}

		/**
		 * @private
		 */
		public function set dragGap(value:Number):void
		{
			if(this._dragGap == value)
			{
				return;
			}
			this._dragGap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _ignoreDragIconResizes:Boolean = false;

		/**
		 * @private
		 */
		public function get dragProxy():DisplayObject
		{
			return this._dragIcon;
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this.owner = null;
			super.dispose();
		}

		/**
		 * @private
		 */
		override protected function refreshOffsets():void
		{
			super.refreshOffsets();
			var dragGap:Number = this._gap;
			if(this._dragGap === this._dragGap) //!isNaN
			{
				dragGap = this._dragGap;
			}
			if(this._dragEnabled && this._dragIcon !== null)
			{
				var oldIgnoreIconResizes:Boolean = this._ignoreDragIconResizes;
				this._ignoreDragIconResizes = true;
				if(this._dragIcon is IValidating)
				{
					IValidating(this._dragIcon).validate();
				}
				this._ignoreDragIconResizes = oldIgnoreIconResizes;
				this._leftOffset += this._dragIcon.width + dragGap;
			}
		}

		/**
		 * @private
		 */
		override protected function layoutContent():void
		{
			super.layoutContent();
			if(this._dragIcon !== null)
			{
				if(this._dragEnabled)
				{
					var oldIgnoreIconResizes:Boolean = this._ignoreDragIconResizes;
					this._ignoreDragIconResizes = true;
					if(this._dragIcon is IValidating)
					{
						IValidating(this._dragIcon).validate();
					}
					this._ignoreDragIconResizes = oldIgnoreIconResizes;
					this._dragIcon.x = this._paddingLeft;
					this._dragIcon.y = this._paddingTop + ((this.actualHeight - this._paddingTop - this._paddingBottom) - this._dragIcon.height) / 2;
					this._dragIcon.visible = true;
				}
				else
				{
					this._dragIcon.visible = false;
				}
			}
		}

		/**
		 * @private
		 */
		protected function dragIcon_resizeHandler(event:Event):void
		{
			if(this._ignoreDragIconResizes)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}
	}
}