/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import feathers.events.FeathersEventType;

	import flash.utils.Dictionary;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.ResizeEvent;

	/**
	 * The default <code>IPopUpManager</code> implementation.
	 *
	 * @see PopUpManager
	 */
	public class DefaultPopUpManager implements IPopUpManager
	{
		/**
		 * @copy PopUpManager#defaultOverlayFactory()
		 */
		public static function defaultOverlayFactory():DisplayObject
		{
			var quad:Quad = new Quad(100, 100, 0x000000);
			quad.alpha = 0;
			return quad;
		}

		/**
		 * Constructor.
		 */
		public function DefaultPopUpManager(root:DisplayObjectContainer = null)
		{
			this.root = root;
		}

		/**
		 * @private
		 */
		protected var _popUps:Vector.<DisplayObject> = new <DisplayObject>[];

		/**
		 * @copy PopUpManager#popUpCount
		 */
		public function get popUpCount():int
		{
			return this._popUps.length;
		}

		/**
		 * @private
		 */
		protected var _popUpToOverlay:Dictionary = new Dictionary(true);

		/**
		 * @private
		 */
		protected var _popUpToFocusManager:Dictionary = new Dictionary(true);

		/**
		 * @private
		 */
		protected var _centeredPopUps:Vector.<DisplayObject> = new <DisplayObject>[];

		/**
		 * @private
		 */
		protected var _overlayFactory:Function = defaultOverlayFactory;

		/**
		 * @copy PopUpManager#overlayFactory
		 */
		public function get overlayFactory():Function
		{
			return this._overlayFactory;
		}

		/**
		 * @private
		 */
		public function set overlayFactory(value:Function):void
		{
			this._overlayFactory = value;
		}

		/**
		 * @private
		 */
		protected var _ignoreRemoval:Boolean = false;

		/**
		 * @private
		 */
		protected var _root:DisplayObjectContainer;

		/**
		 * @copy PopUpManager#root
		 */
		public function get root():DisplayObjectContainer
		{
			return this._root;
		}

		/**
		 * @private
		 */
		public function set root(value:DisplayObjectContainer):void
		{
			if(this._root == value)
			{
				return;
			}
			var popUpCount:int = this._popUps.length;
			var oldIgnoreRemoval:Boolean = this._ignoreRemoval; //just in case
			this._ignoreRemoval = true;
			for(var i:int = 0; i < popUpCount; i++)
			{
				var popUp:DisplayObject = this._popUps[i];
				var overlay:DisplayObject = DisplayObject(_popUpToOverlay[popUp]);
				popUp.removeFromParent(false);
				if(overlay)
				{
					overlay.removeFromParent(false);
				}
			}
			this._ignoreRemoval = oldIgnoreRemoval;
			this._root = value;
			for(i = 0; i < popUpCount; i++)
			{
				popUp = this._popUps[i];
				overlay = DisplayObject(_popUpToOverlay[popUp]);
				if(overlay)
				{
					this._root.addChild(overlay);
				}
				this._root.addChild(popUp);
			}
		}

		/**
		 * @copy PopUpManager#addPopUp()
		 */
		public function addPopUp(popUp:DisplayObject, isModal:Boolean = true, isCentered:Boolean = true, customOverlayFactory:Function = null):DisplayObject
		{
			if(isModal)
			{
				if(customOverlayFactory == null)
				{
					customOverlayFactory = this._overlayFactory;
				}
				if(customOverlayFactory == null)
				{
					customOverlayFactory = defaultOverlayFactory;
				}
				var overlay:DisplayObject = customOverlayFactory();
				overlay.width = this._root.stage.stageWidth;
				overlay.height = this._root.stage.stageHeight;
				this._root.addChild(overlay);
				this._popUpToOverlay[popUp] = overlay;
			}

			this._popUps.push(popUp);
			this._root.addChild(popUp);
			//this listener needs to be added after the pop-up is added to the
			//root because the pop-up may not have been removed from its old
			//parent yet, which will trigger the listener if it is added first.
			popUp.addEventListener(Event.REMOVED_FROM_STAGE, popUp_removedFromStageHandler);

			if(this._popUps.length == 1)
			{
				this._root.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			}

			if(isModal && FocusManager.isEnabledForStage(this._root.stage) && popUp is DisplayObjectContainer)
			{
				this._popUpToFocusManager[popUp] = FocusManager.pushFocusManager(DisplayObjectContainer(popUp));
			}

			if(isCentered)
			{
				if(popUp is IFeathersControl)
				{
					popUp.addEventListener(FeathersEventType.RESIZE, popUp_resizeHandler);
				}
				this._centeredPopUps.push(popUp);
				this.centerPopUp(popUp);
			}

			return popUp;
		}

		/**
		 * @copy PopUpManager#removePopUp()
		 */
		public function removePopUp(popUp:DisplayObject, dispose:Boolean = false):DisplayObject
		{
			var index:int = this._popUps.indexOf(popUp);
			if(index < 0)
			{
				throw new ArgumentError("Display object is not a pop-up.");
			}
			popUp.removeFromParent(dispose);
			return popUp;
		}

		/**
		 * @copy PopUpManager#removeAllPopUps()
		 */
		public function removeAllPopUps(dispose:Boolean = false):void
		{
			//removing pop-ups may call event listeners that add new pop-ups,
			//and we don't want to remove the new ones or miss old ones, so
			//create a copy of the _popUps Vector to be safe.
			var popUps:Vector.<DisplayObject> = this._popUps.slice();
			var popUpCount:int = popUps.length;
			for(var i:int = 0; i < popUpCount; i++)
			{
				var popUp:DisplayObject = popUps[i];
				this.removePopUp(popUp, dispose);
			}
		}

		/**
		 * @copy PopUpManager#isPopUp()
		 */
		public function isPopUp(popUp:DisplayObject):Boolean
		{
			return this._popUps.indexOf(popUp) >= 0;
		}

		/**
		 * @copy PopUpManager#isTopLevelPopUp()
		 */
		public function isTopLevelPopUp(popUp:DisplayObject):Boolean
		{
			var lastIndex:int = this._popUps.length - 1;
			for(var i:int = lastIndex; i >= 0; i--)
			{
				var otherPopUp:DisplayObject = this._popUps[i];
				if(otherPopUp == popUp)
				{
					//we haven't encountered an overlay yet, so it is top-level
					return true;
				}
				var overlay:DisplayObject = this._popUpToOverlay[otherPopUp] as DisplayObject;
				if(overlay)
				{
					//this is the first overlay, and we haven't found the pop-up
					//yet, so it is not top-level
					return false;
				}
			}
			//pop-up was not found at all, so obviously, not top-level
			return false;
		}

		/**
		 * @copy PopUpManager#centerPopUp()
		 */
		public function centerPopUp(popUp:DisplayObject):void
		{
			var stage:Stage = this._root.stage;
			if(popUp is IValidating)
			{
				IValidating(popUp).validate();
			}
			popUp.x = popUp.pivotX + Math.round((stage.stageWidth - popUp.width) / 2);
			popUp.y = popUp.pivotY + Math.round((stage.stageHeight - popUp.height) / 2);
		}

		/**
		 * @private
		 */
		protected function popUp_resizeHandler(event:Event):void
		{
			var popUp:DisplayObject = DisplayObject(event.currentTarget);
			var index:int = this._centeredPopUps.indexOf(popUp);
			if(index < 0)
			{
				return;
			}
			this.centerPopUp(popUp);
		}

		/**
		 * @private
		 */
		protected function popUp_removedFromStageHandler(event:Event):void
		{
			if(this._ignoreRemoval)
			{
				return;
			}
			var popUp:DisplayObject = DisplayObject(event.currentTarget);
			popUp.removeEventListener(Event.REMOVED_FROM_STAGE, popUp_removedFromStageHandler);
			var index:int = this._popUps.indexOf(popUp);
			this._popUps.removeAt(index);
			var overlay:DisplayObject = DisplayObject(this._popUpToOverlay[popUp]);
			if(overlay)
			{
				overlay.removeFromParent(true);
				delete _popUpToOverlay[popUp];
			}
			var focusManager:IFocusManager = this._popUpToFocusManager[popUp] as IFocusManager;
			if(focusManager)
			{
				delete this._popUpToFocusManager[popUp];
				FocusManager.removeFocusManager(focusManager);
			}
			index = this._centeredPopUps.indexOf(popUp);
			if(index >= 0)
			{
				if(popUp is IFeathersControl)
				{
					popUp.removeEventListener(FeathersEventType.RESIZE, popUp_resizeHandler);
				}
				this._centeredPopUps.removeAt(index);
			}

			if(_popUps.length == 0)
			{
				this._root.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			}
		}

		/**
		 * @private
		 */
		protected function stage_resizeHandler(event:ResizeEvent):void
		{
			var stage:Stage = this._root.stage;
			var popUpCount:int = this._popUps.length;
			for(var i:int = 0; i < popUpCount; i++)
			{
				var popUp:DisplayObject = this._popUps[i];
				var overlay:DisplayObject = DisplayObject(this._popUpToOverlay[popUp]);
				if(overlay)
				{
					overlay.width = stage.stageWidth;
					overlay.height = stage.stageHeight;
				}
			}
			popUpCount = this._centeredPopUps.length;
			for(i = 0; i < popUpCount; i++)
			{
				popUp = this._centeredPopUps[i];
				centerPopUp(popUp);
			}
		}
	}
}
