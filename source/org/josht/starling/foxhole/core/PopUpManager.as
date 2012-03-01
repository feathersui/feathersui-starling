package org.josht.starling.foxhole.core
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import org.josht.starling.display.TiledImage;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.textures.Texture;

	public class PopUpManager
	{
		private static const POPUP_TO_OVERLAY:Dictionary = new Dictionary(true);
		
		public static var overlaySkin:Texture;
		
		public static function addPopUp(popUp:DisplayObject, stage:Stage, isCentered:Boolean = true):void
		{
			var overlay:TiledImage;
			if(overlaySkin)
			{
				overlay = new TiledImage(overlaySkin);
				overlay.width = stage.stageWidth;
				overlay.height = stage.stageHeight;
				stage.addChild(overlay);
				POPUP_TO_OVERLAY[popUp] = overlay;
			}
			
			stage.addChild(popUp);
			
			if(isCentered)
			{
				centerPopUp(popUp, stage);
			}
		}
		
		public static function removePopUp(popUp:DisplayObject, dispose:Boolean = false):void
		{
			const overlay:DisplayObject = DisplayObject(POPUP_TO_OVERLAY[popUp]);
			if(overlay)
			{
				overlay.removeFromParent(true);
			}
			delete POPUP_TO_OVERLAY[popUp];
			
			popUp.removeFromParent(false);
		}
		
		private static function centerPopUp(popUp:DisplayObject, stage:Stage):void
		{
			popUp.x = (stage.stageWidth - popUp.width) / 2;
			popUp.y = (stage.stageHeight - popUp.height) / 2;
		}
	}
}