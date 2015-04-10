package
{
	import feathers.examples.componentsExplorer.Main;

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;

	import starling.core.Starling;

	[SWF(width="960",height="640",frameRate="60",backgroundColor="#4a4137")]
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
			this.showLaunchImage();
			this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
		}

		private var _starling:Starling;
		private var _launchImage:Loader;
		private var _savedAutoOrients:Boolean;

		private function showLaunchImage():void
		{
			var filePath:String;
			var isPortraitOnly:Boolean = false;
			if(Capabilities.manufacturer.indexOf("iOS") >= 0)
			{
				var isCurrentlyPortrait:Boolean = this.stage.orientation == StageOrientation.DEFAULT || this.stage.orientation == StageOrientation.UPSIDE_DOWN;
				if(Capabilities.screenResolutionX == 1242 && Capabilities.screenResolutionY == 2208)
				{
					//iphone 6 plus
					filePath = isCurrentlyPortrait ? "Default-414w-736h@3x.png" : "Default-414w-736h-Landscape@3x.png";
				}
				else if(Capabilities.screenResolutionX == 1536 && Capabilities.screenResolutionY == 2048)
				{
					//ipad retina
					filePath = isCurrentlyPortrait ? "Default-Portrait@2x.png" : "Default-Landscape@2x.png";
				}
				else if(Capabilities.screenResolutionX == 768 && Capabilities.screenResolutionY == 1024)
				{
					//ipad classic
					filePath = isCurrentlyPortrait ? "Default-Portrait.png" : "Default-Landscape.png";
				}
				else if(Capabilities.screenResolutionX == 750)
				{
					//iphone 6
					isPortraitOnly = true;
					filePath = "Default-375w-667h@2x.png";
				}
				else if(Capabilities.screenResolutionX == 640)
				{
					//iphone retina
					isPortraitOnly = true;
					if(Capabilities.screenResolutionY == 1136)
					{
						filePath = "Default-568h@2x.png";
					}
					else
					{
						filePath = "Default@2x.png";
					}
				}
				else if(Capabilities.screenResolutionX == 320)
				{
					//iphone classic
					isPortraitOnly = true;
					filePath = "Default.png";
				}
			}

			if(filePath)
			{
				var file:File = File.applicationDirectory.resolvePath(filePath);
				if(file.exists)
				{
					var bytes:ByteArray = new ByteArray();
					var stream:FileStream = new FileStream();
					stream.open(file, FileMode.READ);
					stream.readBytes(bytes, 0, stream.bytesAvailable);
					stream.close();
					this._launchImage = new Loader();
					this._launchImage.loadBytes(bytes);
					this.addChild(this._launchImage);
					this._savedAutoOrients = this.stage.autoOrients;
					this.stage.autoOrients = false;
					if(isPortraitOnly)
					{
						this.stage.setOrientation(StageOrientation.DEFAULT);
					}
				}
			}
		}

		private function loaderInfo_completeHandler(event:Event):void
		{
			Starling.multitouchEnabled = true;
			this._starling = new Starling(Main, this.stage, null, null, Context3DRenderMode.AUTO, Context3DProfile.BASELINE);
			this._starling.supportHighResolutions = true;
			this._starling.start();
			if(this._launchImage)
			{
				this._starling.addEventListener("rootCreated", starling_rootCreatedHandler);
			}

			this.stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, int.MAX_VALUE, true);
			this.stage.addEventListener(Event.DEACTIVATE, stage_deactivateHandler, false, 0, true);
		}

		private function starling_rootCreatedHandler(event:Object):void
		{
			if(this._launchImage)
			{
				this.removeChild(this._launchImage);
				this._launchImage.unloadAndStop(true);
				this._launchImage = null;
				this.stage.autoOrients = this._savedAutoOrients;
			}
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

		private function stage_deactivateHandler(event:Event):void
		{
			this._starling.stop(true);
			this.stage.addEventListener(Event.ACTIVATE, stage_activateHandler, false, 0, true);
		}

		private function stage_activateHandler(event:Event):void
		{
			this.stage.removeEventListener(Event.ACTIVATE, stage_activateHandler);
			this._starling.start();
		}

	}
}