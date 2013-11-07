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
	 * Adds a display object as a pop-up above all content.
	 */
	public class PopUpManager
	{
		/**
		 * @private
		 */
		private static const POPUP_TO_OVERLAY:Dictionary = new Dictionary(true);

		/**
		 * @private
		 */
		private static const POPUP_TO_FOCUS_MANAGER:Dictionary = new Dictionary(true);

		/**
		 * @private
		 */
		private static const CENTERED_POPUPS:Vector.<DisplayObject> = new <DisplayObject>[];
		
		/**
		 * A function that returns a display object to use as an overlay for
		 * modal pop-ups.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 * <pre>function():DisplayObject</pre>
		 *
		 * <p>In the following example, the overlay factory is changed:</p>
		 *
		 * <listing version="3.0">
		 * PopUpManager.overlayFactory = function():DisplayObject
		 * {
		 *     var overlay:Quad = new Quad( 100, 100, 0x000000 );
		 *     overlay.alpha = 0.75;
		 *     return overlay;
		 * };</listing>
		 */
		public static var overlayFactory:Function = defaultOverlayFactory;

		/**
		 * The default factory that creates overlays for modal pop-ups. Creates
		 * an invisible <code>Quad</code>.
		 *
		 * @see starling.display.Quad
		 */
		public static function defaultOverlayFactory():DisplayObject
		{
			const quad:Quad = new Quad(100, 100, 0x000000);
			quad.alpha = 0;
			return quad;
		}

		/**
		 * @private
		 */
		protected static var ignoreRemoval:Boolean = false;

		/**
		 * @private
		 */
		protected static var _root:DisplayObjectContainer;

		/**
		 * The container where pop-ups are added. If not set manually, defaults
		 * to the Starling stage.
		 *
		 * <p>In the following example, the next tab focus is changed:</p>
		 *
		 * <listing version="3.0">
		 * PopUpManager.root = someSprite;</listing>
		 *
		 * @default null
		 */
		public static function get root():DisplayObjectContainer
		{
			return _root;
		}

		/**
		 * @private
		 */
		public static function set root(value:DisplayObjectContainer):void
		{
			if(_root == value)
			{
				return;
			}
			const popUpCount:int = popUps.length;
			const oldIgnoreRemoval:Boolean = ignoreRemoval; //just in case
			ignoreRemoval = true;
			for(var i:int = 0; i < popUpCount; i++)
			{
				var popUp:DisplayObject = popUps[i];
				var overlay:DisplayObject = DisplayObject(POPUP_TO_OVERLAY[popUp]);
				popUp.removeFromParent(false);
				if(overlay)
				{
					overlay.removeFromParent(false);
				}
			}
			ignoreRemoval = oldIgnoreRemoval;
			_root = value;
			const calculatedRoot:DisplayObjectContainer = _root ? _root : Starling.current.stage;
			for(i = 0; i < popUpCount; i++)
			{
				popUp = popUps[i];
				overlay = DisplayObject(POPUP_TO_OVERLAY[popUp]);
				if(overlay)
				{
					calculatedRoot.addChild(overlay);
				}
				calculatedRoot.addChild(popUp);
			}
		}

		/**
		 * @private
		 */
		protected static var popUps:Vector.<DisplayObject> = new <DisplayObject>[];
		
		/**
		 * Adds a pop-up to the stage.
		 *
		 * <p>The pop-up may be modal, meaning that an overlay will be displayed
		 * between the pop-up and everything under the pop-up manager, and the
		 * overlay will block touches. The default overlay used for modal
		 * pop-ups is created by <code>PopUpManager.overlayFactory</code>. A
		 * custom overlay factory may be passed to <code>PopUpManager.addPopUp()</code>
		 * to create an overlay that is different from the default one.</p>
		 *
		 * <p>A pop-up may be centered globally on the Starling stage. If the
		 * stage or the pop-up resizes, the pop-up will be repositioned to
		 * remain in the center. To position a pop-up in the center once,
		 * specify a value of <code>false</code> when calling
		 * <code>PopUpManager.addPopUp()</code> and call
		 * <code>PopUpManager.centerPopUp()</code> manually.</p>
		 *
		 * <p>Note: The pop-up manager can only detect if Feathers components
		 * have been resized in order to reposition them to remain centered.
		 * Regular Starling display objects do not dispatch a proper resize
		 * event that the pop-up manager can listen to.</p>
		 */
		public static function addPopUp(popUp:DisplayObject, isModal:Boolean = true, isCentered:Boolean = true, customOverlayFactory:Function = null):void
		{
			const calculatedRoot:DisplayObjectContainer = _root ? _root : Starling.current.stage;
			if(isModal)
			{
				if(customOverlayFactory == null)
				{
					customOverlayFactory = overlayFactory;
				}
				if(customOverlayFactory == null)
				{
					customOverlayFactory = defaultOverlayFactory;
				}
				const overlay:DisplayObject = customOverlayFactory();
				overlay.width = calculatedRoot.stage.stageWidth;
				overlay.height = calculatedRoot.stage.stageHeight;
				calculatedRoot.addChild(overlay);
				POPUP_TO_OVERLAY[popUp] = overlay;
			}

			popUps.push(popUp);
			calculatedRoot.addChild(popUp);
			popUp.addEventListener(Event.REMOVED_FROM_STAGE, popUp_removedFromStageHandler);

			if(popUps.length == 1)
			{
				calculatedRoot.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			}

			if(FocusManager.isEnabled && popUp is DisplayObjectContainer)
			{
				POPUP_TO_FOCUS_MANAGER[popUp] = new FocusManager(DisplayObjectContainer(popUp));
			}

			if(isCentered)
			{
				if(popUp is IFeathersControl)
				{
					popUp.addEventListener(FeathersEventType.RESIZE, popUp_resizeHandler);
				}
				CENTERED_POPUPS.push(popUp);
				centerPopUp(popUp);
			}
		}
		
		/**
		 * Removes a pop-up from the stage.
		 */
		public static function removePopUp(popUp:DisplayObject, dispose:Boolean = false):void
		{
			const index:int = popUps.indexOf(popUp);
			if(index < 0)
			{
				throw new ArgumentError("Display object is not a pop-up.");
			}
			popUp.removeFromParent(dispose);
		}

		/**
		 * Determines if a display object is a pop-up.
		 *
		 * <p>In the following example, we check if a display object is a pop-up:</p>
		 *
		 * <listing version="3.0">
		 * if( PopUpManager.isPopUp( displayObject ) )
		 * {
		 *     // do something
		 * }</listing>
		 */
		public static function isPopUp(popUp:DisplayObject):Boolean
		{
			return popUps.indexOf(popUp) >= 0;
		}

		/**
		 * Determines if a pop-up is above the highest overlay (of if there is
		 * no overlay).
		 */
		public static function isTopLevelPopUp(popUp:DisplayObject):Boolean
		{
			var lastIndex:int = popUps.length - 1;
			for(var i:int = lastIndex; i >= 0; i--)
			{
				var otherPopUp:DisplayObject = popUps[i];
				if(otherPopUp == popUp)
				{
					//we haven't encountered an overlay yet, so it is top-level
					return true;
				}
				var overlay:DisplayObject = POPUP_TO_OVERLAY[otherPopUp];
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
		 * Centers a pop-up on the stage. Unlike the <code>isCentered</code>
		 * argument passed to <code>PopUpManager.addPopUp()</code>, the pop-up
		 * will only be positioned once. If the stage or the pop-up resizes,
		 * <code>PopUpManager.centerPopUp()</code> will need to be called again
		 * if it should remain centered.
		 *
		 * <p>In the following example, we center a pop-up:</p>
		 *
		 * <listing version="3.0">
		 * PopUpManager.centerPopUp( displayObject );</listing>
		 */
		public static function centerPopUp(popUp:DisplayObject):void
		{
			const stage:Stage = Starling.current.stage;
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
		protected static function popUp_resizeHandler(event:Event):void
		{
			var popUp:DisplayObject = DisplayObject(event.currentTarget);
			var index:int = CENTERED_POPUPS.indexOf(popUp);
			if(index < 0)
			{
				return;
			}
			centerPopUp(popUp);
		}

		/**
		 * @private
		 */
		protected static function popUp_removedFromStageHandler(event:Event):void
		{
			if(ignoreRemoval)
			{
				return;
			}
			const popUp:DisplayObject = DisplayObject(event.currentTarget);
			popUp.removeEventListener(Event.REMOVED_FROM_STAGE, popUp_removedFromStageHandler);
			var index:int = popUps.indexOf(popUp);
			popUps.splice(index, 1);
			const overlay:DisplayObject = DisplayObject(POPUP_TO_OVERLAY[popUp]);
			if(overlay)
			{
				//this is a temporary workaround for Starling issue #131
				Starling.current.stage.addEventListener(EnterFrameEvent.ENTER_FRAME, function(event:EnterFrameEvent):void
				{
					event.currentTarget.removeEventListener(event.type, arguments.callee);
					overlay.removeFromParent(true);
					delete POPUP_TO_OVERLAY[popUp];
				});
			}
			const focusManager:IFocusManager = POPUP_TO_FOCUS_MANAGER[popUp];
			if(focusManager)
			{
				delete POPUP_TO_FOCUS_MANAGER[popUp];
				FocusManager.removeFocusManager(focusManager);
			}
			index = CENTERED_POPUPS.indexOf(popUp);
			if(index >= 0)
			{
				if(popUp is IFeathersControl)
				{
					popUp.removeEventListener(FeathersEventType.RESIZE, popUp_resizeHandler);
				}
				CENTERED_POPUPS.splice(index, 1);
			}

			if(popUps.length == 0)
			{
				Starling.current.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			}
		}

		/**
		 * @private
		 */
		protected static function stage_resizeHandler(event:ResizeEvent):void
		{
			const stage:Stage = Starling.current.stage;
			var popUpCount:int = popUps.length;
			for(var i:int = 0; i < popUpCount; i++)
			{
				var popUp:DisplayObject = popUps[i];
				var overlay:DisplayObject = DisplayObject(POPUP_TO_OVERLAY[popUp]);
				if(overlay)
				{
					overlay.width = stage.stageWidth;
					overlay.height = stage.stageHeight;
				}
			}
			popUpCount = CENTERED_POPUPS.length;
			for(i = 0; i < popUpCount; i++)
			{
				popUp = CENTERED_POPUPS[i];
				centerPopUp(popUp);
			}
		}
	}
}
