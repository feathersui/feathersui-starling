/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import feathers.events.FeathersEventType;

	import flash.utils.Dictionary;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Stage;
	import starling.events.EnterFrameEvent;
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
			const quad:Quad = new Quad(100, 100, 0x000000);
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
			const popUpCount:int = this._popUps.length;
			const oldIgnoreRemoval:Boolean = this._ignoreRemoval; //just in case
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
			const calculatedRoot:DisplayObjectContainer = this._root ? this._root : Starling.current.stage;
			for(i = 0; i < popUpCount; i++)
			{
				popUp = this._popUps[i];
				overlay = DisplayObject(_popUpToOverlay[popUp]);
				if(overlay)
				{
					calculatedRoot.addChild(overlay);
				}
				calculatedRoot.addChild(popUp);
			}
		}

		/**
		 * @copy PopUpManager#addPopUp()
		 */
		public function addPopUp(popUp:DisplayObject, isModal:Boolean = true, isCentered:Boolean = true, customOverlayFactory:Function = null):DisplayObject
		{
			const calculatedRoot:DisplayObjectContainer = this._root ? this._root : Starling.current.stage;
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
				const overlay:DisplayObject = customOverlayFactory();
				overlay.width = calculatedRoot.stage.stageWidth;
				overlay.height = calculatedRoot.stage.stageHeight;
				calculatedRoot.addChild(overlay);
				this._popUpToOverlay[popUp] = overlay;
			}

			this._popUps.push(popUp);
			calculatedRoot.addChild(popUp);
			popUp.addEventListener(Event.REMOVED_FROM_STAGE, popUp_removedFromStageHandler);

			if(this._popUps.length == 1)
			{
				calculatedRoot.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			}

			if(FocusManager.isEnabled && popUp is DisplayObjectContainer)
			{
				this._popUpToFocusManager[popUp] = new FocusManager(DisplayObjectContainer(popUp));
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
			const index:int = this._popUps.indexOf(popUp);
			if(index < 0)
			{
				throw new ArgumentError("Display object is not a pop-up.");
			}
			popUp.removeFromParent(dispose);
			return popUp;
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
				var overlay:DisplayObject = this._popUpToOverlay[otherPopUp];
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
			var stage:Stage = Starling.current.stage;
			if(popUp is IFeathersControl)
			{
				IFeathersControl(popUp).validate();
			}
			popUp.x = (stage.stageWidth - popUp.width) / 2;
			popUp.y = (stage.stageHeight - popUp.height) / 2;
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
			const popUp:DisplayObject = DisplayObject(event.currentTarget);
			popUp.removeEventListener(Event.REMOVED_FROM_STAGE, popUp_removedFromStageHandler);
			var index:int = this._popUps.indexOf(popUp);
			this._popUps.splice(index, 1);
			const overlay:DisplayObject = DisplayObject(this._popUpToOverlay[popUp]);
			if(overlay)
			{
				//this is a temporary workaround for Starling issue #131
				Starling.current.stage.addEventListener(EnterFrameEvent.ENTER_FRAME, function(event:EnterFrameEvent):void
				{
					event.currentTarget.removeEventListener(event.type, arguments.callee);
					overlay.removeFromParent(true);
					delete _popUpToOverlay[popUp];
				});
			}
			const focusManager:IFocusManager = this._popUpToFocusManager[popUp];
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
				this._centeredPopUps.splice(index, 1);
			}

			if(_popUps.length == 0)
			{
				Starling.current.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			}
		}

		/**
		 * @private
		 */
		protected function stage_resizeHandler(event:ResizeEvent):void
		{
			const stage:Stage = Starling.current.stage;
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
