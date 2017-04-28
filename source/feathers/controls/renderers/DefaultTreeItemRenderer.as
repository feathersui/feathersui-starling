/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.renderers
{
	import feathers.controls.renderers.ITreeItemRenderer;
	import feathers.skins.IStyleProvider;
	import feathers.events.FeathersEventType;
	import feathers.controls.Tree;
	import feathers.controls.BasicButton;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import feathers.utils.touch.TapToTrigger;
	import feathers.core.IValidating;
	import flash.geom.Point;
	import starling.display.DisplayObjectContainer;

	/**
	 * The size, in pixels, of the indentation when an item is a child of a branch.
	 *
	 * <p>In the following example, the indentation is set to 15 pixels:</p>
	 *
	 * <listing version="3.0">
	 * tree.indentation = 15;</listing>
	 *
	 * @default 10
	 */
	[Style(name="indentation",type="Number")]

	/**
	 * The default item renderer for Tree control. Supports up to three optional
	 * sub-views, including a label to display text, an icon to display an
	 * image, and an "accessory" to display a UI control or another display
	 * object (with shortcuts for including a second image or a second label).
	 * 
	 * @see feathers.controls.Tree
	 *
	 * @productversion Feathers 3.3.0
	 */
	public class DefaultTreeItemRenderer extends BaseDefaultItemRenderer implements ITreeItemRenderer
	{
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
		 * The default <code>IStyleProvider</code> for all <code>DefaultTreeItemRenderer</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function DefaultTreeItemRenderer()
		{
			super();
			this.addEventListener(Event.TRIGGERED, treeItemRenderer_triggeredHandler);
		}

		/**
		 * @private
		 */
		protected var _disclosureIconTapToTrigger:TapToTrigger = null;

		/**
		 * @private
		 */
		protected var _disclosureIcon:DisplayObject = null;

		public function get disclosureIcon():DisplayObject
		{
			return this._disclosureIcon;
		}

		public function set disclosureIcon(value:DisplayObject):void
		{
			if(this._disclosureIcon === value)
			{
				return;
			}
			if(this._disclosureIcon !== null)
			{
				if(this._disclosureIcon.parent === this)
				{
					this._disclosureIcon.removeFromParent(false);
				}
				this._disclosureIconTapToTrigger = null;
				this._disclosureIcon.removeEventListener(Event.TRIGGERED, disclosureIcon_triggeredHandler);
			}
			this._disclosureIcon = value;
			if(this._disclosureIcon !== null)
			{
				if(!(this._disclosureIcon is BasicButton))
				{
					this._disclosureIconTapToTrigger = new TapToTrigger(this._disclosureIcon);
				}
				this._disclosureIcon.addEventListener(Event.TRIGGERED, disclosureIcon_triggeredHandler);
				this.addChild(this._disclosureIcon);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return DefaultTreeItemRenderer.globalStyleProvider;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get owner():Tree
		{
			return Tree(this._owner);
		}
		
		/**
		 * @private
		 */
		public function set owner(value:Tree):void
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
				var list:Tree = Tree(this._owner);
				this.isSelectableWithoutToggle = list.isSelectable;
				this._owner.addEventListener(FeathersEventType.SCROLL_START, owner_scrollStartHandler);
				this._owner.addEventListener(FeathersEventType.SCROLL_COMPLETE, owner_scrollCompleteHandler);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _location:Vector.<int> = null;

		/**
		 * @inheritDoc
		 */
		public function get location():Vector.<int>
		{
			return this._location;
		}

		/**
		 * @private
		 */
		public function set location(value:Vector.<int>):void
		{
			if(this._location === value)
			{
				return;
			}
			this._location = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _layoutIndex:int = -1;

		/**
		 * @inheritDoc
		 */
		public function get layoutIndex():int
		{
			return this._layoutIndex;
		}

		/**
		 * @private
		 */
		public function set layoutIndex(value:int):void
		{
			this._layoutIndex = value;
		}

		/**
		 * @private
		 */
		protected var _indentation:Number = 10;

		/**
		 * @private
		 */
		public function get indentation():Number
		{
			return this._indentation;
		}

		/**
		 * @private
		 */
		public function set indentation(value:Number):void
		{
			this._indentation = value;
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
			if(this._location !== null)
			{
				//if the data provider is empty, but the tree has a typicalItem,
				//the location will be null
				this._leftOffset += this._indentation * (this._location.length - 1);
			}
			if(this._disclosureIcon !== null)
			{
				if(this._disclosureIcon is IValidating)
				{
					IValidating(this._disclosureIcon).validate();
				}
				this._leftOffset += this._disclosureIcon.width + this._gap;
				if(this.owner.dataProvider.isBranch(this._data))
				{
					this._disclosureIcon.visible = true;
				}
				else
				{
					this._disclosureIcon.visible = false;
				}
			}
		}

		/**
		 * @private
		 */
		override protected function layoutContent():void
		{
			super.layoutContent();
			if(this._disclosureIcon !== null)
			{
				var indent:Number = 0;
				if(this._location !== null)
				{
					indent = this._indentation * (this._location.length - 1);
				}
				if(this._disclosureIcon is IValidating)
				{
					IValidating(this._disclosureIcon).validate();
				}
				this._disclosureIcon.x = this._paddingLeft + indent;
				this._disclosureIcon.y = this._paddingTop + ((this.actualHeight - this._paddingTop - this._paddingBottom) - this._disclosureIcon.height) / 2;
			}
		}

		/**
		 * @private
		 */
		override protected function hitTestWithAccessory(localPosition:Point):Boolean
		{
			if(this._disclosureIcon !== null)
			{
				if(this._disclosureIcon is DisplayObjectContainer)
				{
					var container:DisplayObjectContainer = DisplayObjectContainer(this._disclosureIcon);
					if(container.contains(this.hitTest(localPosition)))
					{
						return false;
					}
				}
				if(this.hitTest(localPosition) === this._disclosureIcon)
				{
					return false;
				}
			}
			return super.hitTestWithAccessory(localPosition);
		}

		/**
		 * @private
		 */
		protected function toggleBranch():void
		{
		}

		/**
		 * @private
		 */
		protected function disclosureIcon_triggeredHandler(event:Event):void
		{
			this.toggleBranch();
		}

		/**
		 * @private
		 */
		protected function treeItemRenderer_triggeredHandler(event:Event):void
		{
			if(this._disclosureIcon !== null ||
				!this.owner.dataProvider.isBranch(this._data))
			{
				return;
			}
			//if there is no disclosure icon, then the branch is toggled simply
			//by triggering it with a click/tap
			this.toggleBranch();
		}
	}
}