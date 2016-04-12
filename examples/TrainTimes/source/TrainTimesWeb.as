package
{
	import feathers.system.DeviceCapabilities;

	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.ui.ContextMenu;
	import flash.utils.getDefinitionByName;

	import starling.core.Starling;

	[SWF(width="960",height="640",frameRate="60",backgroundColor="#424254")]
	public class TrainTimesWeb extends MovieClip
	{
		public function TrainTimesWeb()
		{
			var menu:ContextMenu = new ContextMenu();
			menu.hideBuiltInItems();
			this.contextMenu = menu;
			
			if(this.stage)
			{
				this.stage.align = StageAlign.TOP_LEFT;
				this.stage.scaleMode = StageScaleMode.NO_SCALE;
			}
			
			this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
		}
		
		private var _starling:Starling;
		
		private function start():void
		{
			this.gotoAndStop(2);
			this.graphics.clear();
			
			Starling.multitouchEnabled = true;
			var MainType:Class = getDefinitionByName("feathers.examples.trainTimes.Main") as Class;
			this._starling = new Starling(MainType, this.stage, new Rectangle(0, 0, 960, 640));
			this._starling.supportHighResolutions = true;
			this._starling.skipUnchangedFrames = true;
			this._starling.stage.stageWidth = 480;
			this._starling.stage.stageHeight = 320;
			this._starling.start();
		}
		
		private function loaderInfo_completeHandler(event:Event):void
		{
			this.start();
		}
	}
}