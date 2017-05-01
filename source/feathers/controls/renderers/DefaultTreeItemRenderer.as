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
	import feathers.core.IFeathersControl;
	import feathers.core.IStateObserver;

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
		protected var _ignoreDisclosureIconResizes:Boolean = false;

		/**
		 * @private
		 */
		protected var _disclosureIconTapToTrigger:TapToTrigger = null;

		/**
		 * @private
		 */
		protected var _currentDisclosureIcon:DisplayObject = null;

		/**
		 * @private
		 */
		protected var _defaultDisclosureIcon:DisplayObject = null;

		/**
		 * 
		 */
		public function get defaultDisclosureIcon():DisplayObject
		{
			return this._defaultDisclosureIcon;
		}

		/**
		 * @private
		 */
		public function set defaultDisclosureIcon(value:DisplayObject):void
		{
			if(this._defaultDisclosureIcon === value)
			{
				return;
			}
			if(this._defaultDisclosureIcon !== null &&
				this._currentDisclosureIcon === this._defaultDisclosureIcon)
			{
				//if this icon needs to be reused somewhere else, we need to
				//properly clean it up
				this.removeCurrentDisclosureIcon(this._defaultDisclosureIcon);
				this._currentDisclosureIcon = null;
			}
			this._defaultDisclosureIcon = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _disclosureOpenIcon:DisplayObject = null;

		/**
		 * 
		 */
		public function get disclosureOpenIcon():DisplayObject
		{
			return this._defaultDisclosureIcon;
		}

		/**
		 * @private
		 */
		public function set disclosureOpenIcon(value:DisplayObject):void
		{
			if(this._disclosureOpenIcon === value)
			{
				return;
			}
			if(this._disclosureOpenIcon !== null &&
				this._currentDisclosureIcon === this._disclosureOpenIcon)
			{
				//if this icon needs to be reused somewhere else, we need to
				//properly clean it up
				this.removeCurrentDisclosureIcon(this._disclosureOpenIcon);
				this._currentDisclosureIcon = null;
			}
			this._disclosureOpenIcon = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _disclosureClosedIcon:DisplayObject = null;

		/**
		 * 
		 */
		public function get disclosureClosedIcon():DisplayObject
		{
			return this._disclosureClosedIcon;
		}

		/**
		 * @private
		 */
		public function set disclosureClosedIcon(value:DisplayObject):void
		{
			if(this._disclosureClosedIcon === value)
			{
				return;
			}
			if(this._disclosureClosedIcon !== null &&
				this._currentDisclosureIcon === this._disclosureClosedIcon)
			{
				//if this icon needs to be reused somewhere else, we need to
				//properly clean it up
				this.removeCurrentDisclosureIcon(this._disclosureClosedIcon);
				this._currentDisclosureIcon = null;
			}
			this._disclosureClosedIcon = value;
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
			if(this._indentation === value)
			{
				return;
			}
			this._indentation = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _open:Boolean = false;

		/**
		 * @private
		 */
		public function get open():Boolean
		{
			return this._open;
		}

		/**
		 * @private
		 */
		public function set open(value:Boolean):void
		{
			if(this._open === value)
			{
				return;
			}
			this._open = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			//we don't dispose it if the item renderer is the parent because
			//it'll already get disposed in super.dispose()
			if(this._defaultDisclosureIcon !== null && this._defaultDisclosureIcon.parent !== this)
			{
				this._defaultDisclosureIcon.dispose();
			}
			if(this._disclosureOpenIcon !== null && this._disclosureOpenIcon.parent !== this)
			{
				this._disclosureOpenIcon.dispose();
			}
			if(this._disclosureClosedIcon !== null && this._disclosureClosedIcon.parent !== this)
			{
				this._disclosureClosedIcon.dispose();
			}
			this.owner = null;
			super.dispose();
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			if(stylesInvalid || stateInvalid)
			{
				this.refreshDisclosureIcon();
			}
			super.draw();
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
			if(this._currentDisclosureIcon !== null)
			{
				var oldIgnoreIconResizes:Boolean = this._ignoreDisclosureIconResizes;
				this._ignoreDisclosureIconResizes = true;
				if(this._currentDisclosureIcon is IValidating)
				{
					IValidating(this._currentDisclosureIcon).validate();
				}
				this._ignoreDisclosureIconResizes = oldIgnoreIconResizes;
				this._leftOffset += this._currentDisclosureIcon.width + this._gap;
				if(this.owner.dataProvider.isBranch(this._data))
				{
					this._currentDisclosureIcon.visible = true;
				}
				else
				{
					this._currentDisclosureIcon.visible = false;
				}
			}
		}

		/**
		 * @private
		 */
		override protected function layoutContent():void
		{
			super.layoutContent();
			if(this._currentDisclosureIcon !== null)
			{
				var indent:Number = 0;
				if(this._location !== null)
				{
					indent = this._indentation * (this._location.length - 1);
				}
				var oldIgnoreIconResizes:Boolean = this._ignoreDisclosureIconResizes;
				this._ignoreDisclosureIconResizes = true;
				if(this._currentDisclosureIcon is IValidating)
				{
					IValidating(this._currentDisclosureIcon).validate();
				}
				this._ignoreDisclosureIconResizes = oldIgnoreIconResizes;
				this._currentDisclosureIcon.x = this._paddingLeft + indent;
				this._currentDisclosureIcon.y = this._paddingTop + ((this.actualHeight - this._paddingTop - this._paddingBottom) - this._currentDisclosureIcon.height) / 2;
			}
		}

		/**
		 * @private
		 */
		override protected function hitTestWithAccessory(localPosition:Point):Boolean
		{
			if(this._currentDisclosureIcon !== null)
			{
				if(this._currentDisclosureIcon is DisplayObjectContainer)
				{
					var container:DisplayObjectContainer = DisplayObjectContainer(this._currentDisclosureIcon);
					if(container.contains(this.hitTest(localPosition)))
					{
						return false;
					}
				}
				if(this.hitTest(localPosition) === this._currentDisclosureIcon)
				{
					return false;
				}
			}
			return super.hitTestWithAccessory(localPosition);
		}

		/**
		 * @private
		 */
		protected function getCurrentDisclosureIcon():DisplayObject
		{
			var newIcon:DisplayObject = this._defaultDisclosureIcon;
			if(this._open && this._disclosureOpenIcon !== null)
			{
				newIcon = this._disclosureOpenIcon;
			}
			else if(!this._open && this._disclosureClosedIcon !== null)
			{
				newIcon = this._disclosureClosedIcon;
			}
			return newIcon;
		}

		/**
		 * @private
		 */
		protected function removeCurrentDisclosureIcon(icon:DisplayObject):void
		{
			if(icon === null)
			{
				return;
			}
			if(icon is IFeathersControl)
			{
				IFeathersControl(icon).removeEventListener(FeathersEventType.RESIZE, currentDisclosureIcon_resizeHandler);
			}
			icon.removeEventListener(Event.TRIGGERED, disclosureIcon_triggeredHandler);
			if(icon is IStateObserver)
			{
				IStateObserver(icon).stateContext = null;
			}
			if(icon.parent === this)
			{
				this.removeChild(icon, false);
			}
		}

		/**
		 * @private
		 */
		protected function refreshDisclosureIcon():void
		{
			var oldDisclosureIcon:DisplayObject = this._currentDisclosureIcon;
			this._currentDisclosureIcon = this.getCurrentDisclosureIcon();
			if(this._currentDisclosureIcon is IFeathersControl)
			{
				IFeathersControl(this._currentDisclosureIcon).isEnabled = this._isEnabled;
			}
			if(this._currentDisclosureIcon !== oldDisclosureIcon)
			{
				if(oldDisclosureIcon !== null)
				{
					this.removeCurrentDisclosureIcon(oldDisclosureIcon);
				}
				if(this._currentDisclosureIcon !== null)
				{
					if(this._currentDisclosureIcon is IStateObserver)
					{
						IStateObserver(this._currentDisclosureIcon).stateContext = this;
					}
					this.addChild(this._currentDisclosureIcon);
					if(!(this._currentDisclosureIcon is BasicButton))
					{
						if(this._disclosureIconTapToTrigger !== null)
						{
							this._disclosureIconTapToTrigger.target = this._currentDisclosureIcon;
						}
						else
						{
							this._disclosureIconTapToTrigger = new TapToTrigger(this._currentDisclosureIcon);
						}
					}
					this._currentDisclosureIcon.addEventListener(Event.TRIGGERED, disclosureIcon_triggeredHandler);
					if(this._currentDisclosureIcon is IFeathersControl)
					{
						IFeathersControl(this._currentDisclosureIcon).addEventListener(FeathersEventType.RESIZE, currentDisclosureIcon_resizeHandler);
					}
				}
				else
				{
					this._disclosureIconTapToTrigger = null;
				}
			}
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
			if(this._defaultDisclosureIcon !== null ||
				!this.owner.dataProvider.isBranch(this._data))
			{
				return;
			}
			//if there is no disclosure icon, then the branch is toggled simply
			//by triggering it with a click/tap
			this.toggleBranch();
		}

		/**
		 * @private
		 */
		protected function currentDisclosureIcon_resizeHandler():void
		{
			if(this._ignoreDisclosureIconResizes)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}
	}
}