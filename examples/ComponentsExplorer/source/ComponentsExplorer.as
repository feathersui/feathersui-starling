package
{
	import feathers.examples.componentsExplorer.Main;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;

	import starling.core.Starling;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	[SWF(width="960",height="640",frameRate="60",backgroundColor="#2f2f2f")]
	public class ComponentsExplorer extends Sprite
	{
		public function ComponentsExplorer()
		{
			if(this.stage)
			{
				this.stage.scaleMode = StageScaleMode.NO_SCALE;
				this.stage.align = StageAlign.TOP_LEFT;
			}
			this.mouseEnabled = this.mouseChildren = false;
			this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
		}

		private var _starling:Starling;

		private function loaderInfo_completeHandler(event:Event):void
		{
			Starling.handleLostContext = true;
			Starling.multitouchEnabled = true;
			this._starling = new Starling(Main, this.stage);
			this._starling.enableErrorChecking = false;
			//this._starling.showStats = true;
			//this._starling.showStatsAt(HAlign.LEFT, VAlign.BOTTOM);
			this._starling.start();

			this.stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, int.MAX_VALUE, true);
			this.stage.addEventListener(Event.DEACTIVATE, stage_deactivateHandler, false, 0, true);
		}

		private function stage_resizeHandler(event:Event):void
		{
			this._starling.stage.stageWidth = this.stage.stageWidth;
			this._starling.stage.stageHeight = this.stage.stageHeight;

			const viewPort:Rectangle = this._starling.viewPort;
			viewPort.width = this.stage.stageWidth;
			viewPort.height = this.stage.stageHeight;
			try
			{
				this._starling.viewPort = viewPort;
			}
			catch(error:Error) {}
			//this._starling.showStatsAt(HAlign.LEFT, VAlign.BOTTOM);
		}

		private function stage_deactivateHandler(event:Event):void
		{
			this._starling.stop();
			this.stage.addEventListener(Event.ACTIVATE, stage_activateHandler, false, 0, true);
		}

		private function stage_activateHandler(event:Event):void
		{
			this.stage.removeEventListener(Event.ACTIVATE, stage_activateHandler);
			this._starling.start();
		}

	}
}