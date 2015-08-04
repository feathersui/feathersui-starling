package
{
    import feathers.examples.video.Main;

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.display3D.Context3DProfile;
    import flash.display3D.Context3DRenderMode;
    import flash.events.Event;
    import flash.geom.Rectangle;

    import starling.core.Starling;

    [SWF(width="960",height="640",frameRate="60",backgroundColor="#4a4137")]
    public class Video extends Sprite
    {
        public function Video()
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
            Starling.multitouchEnabled = true;
            this._starling = new Starling(Main, this.stage, null, null, Context3DRenderMode.AUTO, Context3DProfile.BASELINE);
            this._starling.supportHighResolutions = true;
            this._starling.start();

            this.stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, int.MAX_VALUE, true);
        }

        private function stage_resizeHandler(event:Event):void
        {
            this._starling.stage.stageWidth = this.stage.stageWidth;
            this._starling.stage.stageHeight = this.stage.stageHeight;

            var viewPort:Rectangle = this._starling.viewPort;
            viewPort.width = this.stage.stageWidth;
            viewPort.height = this.stage.stageHeight;
            try
            {
                this._starling.viewPort = viewPort;
            }
            catch(error:Error) {}
        }

    }
}