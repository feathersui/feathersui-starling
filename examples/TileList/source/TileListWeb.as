package
{
	import feathers.system.DeviceCapabilities;

	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.utils.getDefinitionByName;

	import starling.core.Starling;

	[SWF(width="960",height="640",frameRate="60",backgroundColor="#ffffff")]
	public class TileListWeb extends MovieClip
	{
		public function TileListWeb()
		{
			var menu:ContextMenu = new ContextMenu();
			menu.hideBuiltInItems();
			this.contextMenu = menu;

			if(this.stage)
			{
				this.stage.align = StageAlign.TOP_LEFT;
				this.stage.scaleMode = StageScaleMode.NO_SCALE;
			}
			this.mouseEnabled = this.mouseChildren = false;

			//pretends to be an iPhone Retina screen
			DeviceCapabilities.dpi = 326;
			DeviceCapabilities.screenPixelWidth = 960;
			DeviceCapabilities.screenPixelHeight = 640;

			this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
		}

		private var _starling:Starling;

		private function start():void
		{
			this.gotoAndStop(2);
			this.graphics.clear();

			Starling.multitouchEnabled = true;
			var MainType:Class = getDefinitionByName("feathers.examples.tileList.Main") as Class;
			this._starling = new Starling(MainType, this.stage);
			this._starling.supportHighResolutions = true;
			this._starling.start();
		}

		private function enterFrameHandler(event:Event):void
		{
			if(this.stage.stageWidth > 0 && this.stage.stageHeight > 0)
			{
				this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				this.start();
			}
		}

		private function loaderInfo_completeHandler(event:Event):void
		{
			if(this.stage.stageWidth == 0 || this.stage.stageHeight == 0)
			{
				this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
				return;
			}
			this.start();
		}
	}
}