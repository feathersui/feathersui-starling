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
package feathers.core
{
	import flash.utils.Dictionary;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Stage;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;

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
		 * A function that returns a display object to use as an overlay for
		 * modal pop-ups.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 * <pre>function():DisplayObject</pre>
		 */
		public static var overlayFactory:Function = defaultOverlayFactory;

		/**
		 * The default factory that creates overlays for modal pop-ups.
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
		protected static var popUps:Vector.<DisplayObject> = new <DisplayObject>[];
		
		/**
		 * Adds a pop-up to the stage.
		 */
		public static function addPopUp(popUp:DisplayObject, isModal:Boolean = true, isCentered:Boolean = true, customOverlayFactory:Function = null):void
		{
			const stage:Stage = Starling.current.stage;
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
				overlay.width = stage.stageWidth;
				overlay.height = stage.stageHeight;
				stage.addChild(overlay);
				POPUP_TO_OVERLAY[popUp] = overlay;
			}

			popUps.push(popUp);
			stage.addChild(popUp);
			popUp.addEventListener(Event.REMOVED_FROM_STAGE, popUp_removedFromStageHandler);
			
			if(isCentered)
			{
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
		 */
		public static function isPopUp(popUp:DisplayObject):Boolean
		{
			return popUps.indexOf(popUp) >= 0;
		}

		
		/**
		 * Centers a pop-up on the stage.
		 */
		public static function centerPopUp(popUp:DisplayObject):void
		{
			const stage:Stage = Starling.current.stage;
			popUp.x = (stage.stageWidth - popUp.width) / 2;
			popUp.y = (stage.stageHeight - popUp.height) / 2;
		}

		/**
		 * @private
		 */
		protected static function popUp_removedFromStageHandler(event:Event):void
		{
			const popUp:DisplayObject = DisplayObject(event.currentTarget);
			popUp.removeEventListener(Event.REMOVED_FROM_STAGE, popUp_removedFromStageHandler);
			const index:int = popUps.indexOf(popUp);
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
		}
	}
}