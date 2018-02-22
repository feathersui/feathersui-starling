package
{
	import feathers.examples.todos.Main;
	import feathers.utils.ScreenDensityScaleFactorManager;

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
	import flash.system.Capabilities;
	import flash.utils.ByteArray;

	import starling.core.Starling;

	[SWF(width="960",height="640",frameRate="60",backgroundColor="#4a4137")]
	public class Todos extends Sprite
	{
		public function Todos()
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
		private var _scaler:ScreenDensityScaleFactorManager;
		private var _launchImage:Loader;
		private var _savedAutoOrients:Boolean;

		/**
		 * On iOS, add the native launch image to the classic display list to
		 * avoid displaying only the stage background color between when the
		 * AIR app finishes launching and Starling starts rendering.
		 * 
		 * Launch image names: https://forums.adobe.com/message/9986239#9986239
		 */
		private function showLaunchImage():void
		{
			var filePath:String = null;
			var isPortraitOnly:Boolean = false;
			if(Capabilities.manufacturer.indexOf("iOS") >= 0)
			{
				var isPortraitUpsideDown:Boolean = this.stage.orientation == StageOrientation.UPSIDE_DOWN;
				var isPortrait:Boolean = this.stage.orientation == StageOrientation.DEFAULT || isPortraitUpsideDown;
				var isLandscapeRight:Boolean = this.stage.orientation == StageOrientation.ROTATED_RIGHT;
				if(Capabilities.screenResolutionX == 1242 && Capabilities.screenResolutionY == 2208)
				{
					//iphone 6/7/8 plus
					filePath = isPortrait ? "Default-414w-736h@3x~iphone.png" : "Default-Landscape-414w-736h@3x~iphone.png";
				}
				else if(Capabilities.screenResolutionX == 1125 && Capabilities.screenResolutionY == 2436)
				{
					//iphone x
					filePath = isPortrait ? "Default-812h@3x~iphone.png" : "Default-Landscape-812h@3x~iphone.png";
				}
				else if(Capabilities.screenResolutionX == 2048 && Capabilities.screenResolutionY == 2732)
				{
					//ipad pro
					filePath = isPortrait ? "Default-Portrait@2x.png" : "Default-Landscape@2x.png";
				}
				else if(Capabilities.screenResolutionX == 1536 && Capabilities.screenResolutionY == 2048)
				{
					//ipad 3/air
					if(isPortraitUpsideDown)
					{
						filePath = "Default-Portrait@2x~ipad.png";
					}
					else if(isPortrait)
					{
						filePath = "Default-PortraitUpsideDown@2x~ipad.png";
					}
					else if(isLandscapeRight)
					{
						filePath = "Default-LandscapeRight@2x~ipad.png";
					}
					else
					{
						filePath = "Default-LandscapeLeft@2x~ipad.png";
					}
				}
				else if(Capabilities.screenResolutionX == 768 && Capabilities.screenResolutionY == 1024)
				{
					//ipad 1/2
					if(isPortraitUpsideDown)
					{
						filePath = "Default-Portrait~ipad.png";
					}
					else if(isPortrait)
					{
						filePath = "Default-PortraitUpsideDown~ipad.png";
					}
					else if(isLandscapeRight)
					{
						filePath = "Default-LandscapeRight~ipad.png";
					}
					else
					{
						filePath = "Default-Landscape~ipad.png";
					}
				}
				else if(Capabilities.screenResolutionX == 750)
				{
					//iphone 6/7/8
					isPortraitOnly = true;
					filePath = "Default-375w-667h@2x~iphone.png";
				}
				else if(Capabilities.screenResolutionX == 640)
				{
					isPortraitOnly = true;
					if(Capabilities.screenResolutionY == 1136)
					{
						//iphone 5/5c/5s
						filePath = "Default-568h@2x~iphone.png";
					}
					else
					{
						//iphone 4/4s
						filePath = "Default@2x~iphone.png";
					}
				}
				else if(Capabilities.screenResolutionX == 320)
				{
					//iphone 3gs
					isPortraitOnly = true;
					filePath = "Default~iphone.png";
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
			this._starling.skipUnchangedFrames = true;
			this._starling.start();
			if(this._launchImage)
			{
				this._starling.addEventListener("rootCreated", starling_rootCreatedHandler);
			}
			this._scaler = new ScreenDensityScaleFactorManager(this._starling);

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