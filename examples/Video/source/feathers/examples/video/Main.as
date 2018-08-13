package feathers.examples.video
{
	import feathers.controls.Alert;
	import feathers.controls.AutoSizeMode;
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.data.ArrayCollection;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.events.MediaPlayerEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayoutData;
	import feathers.media.FullScreenToggleButton;
	import feathers.media.MuteToggleButton;
	import feathers.media.PlayPauseToggleButton;
	import feathers.media.SeekSlider;
	import feathers.media.VideoPlayer;
	import feathers.themes.MetalWorksDesktopTheme;

	import flash.desktop.NativeApplication;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.ContextMenuEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;

	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;

	public class Main extends Sprite
	{
		public function Main()
		{
			new MetalWorksDesktopTheme();
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		protected var _videoPlayer:VideoPlayer
		protected var _controls:LayoutGroup;
		protected var _playPauseButton:PlayPauseToggleButton;
		protected var _seekSlider:SeekSlider;
		protected var _muteButton:MuteToggleButton;
		protected var _fullScreenButton:FullScreenToggleButton;
		protected var _view:ImageLoader;
		
		protected var _fullScreenItem:NativeMenuItem;
		protected var _fileToOpen:File;
		
		private function addedToStageHandler(event:Event):void
		{
			this.createMenu();
			
			this._videoPlayer = new VideoPlayer();
			this._videoPlayer.autoSizeMode = AutoSizeMode.STAGE;
			this._videoPlayer.layout = new AnchorLayout();
			this._videoPlayer.addEventListener(Event.READY, videoPlayer_readyHandler);
			this._videoPlayer.addEventListener(FeathersEventType.CLEAR, videoPlayer_clearHandler);
			this._videoPlayer.addEventListener(MediaPlayerEventType.DISPLAY_STATE_CHANGE, videoPlayer_displayStateChangeHandler);
			this._videoPlayer.addEventListener(Event.IO_ERROR, videoPlayer_errorHandler);
			this._videoPlayer.addEventListener(FeathersEventType.ERROR, videoPlayer_errorHandler);
			this.addChild(this._videoPlayer);
			
			this._view = new ImageLoader();
			this._videoPlayer.addChild(this._view);
			
			this._controls = new LayoutGroup();
			this._controls.touchable = false;
			this._controls.styleNameList.add(LayoutGroup.ALTERNATE_STYLE_NAME_TOOLBAR);
			this._videoPlayer.addChild(this._controls);
			
			this._playPauseButton = new PlayPauseToggleButton();
			this._controls.addChild(this._playPauseButton);
			
			this._seekSlider = new SeekSlider();
			this._seekSlider.layoutData = new HorizontalLayoutData(100);
			this._controls.addChild(this._seekSlider);
			
			this._muteButton = new MuteToggleButton();
			this._controls.addChild(this._muteButton);

			this._fullScreenButton = new FullScreenToggleButton();
			this._controls.addChild(this._fullScreenButton);
			
			var controlsLayoutData:AnchorLayoutData = new AnchorLayoutData();
			controlsLayoutData.left = 0;
			controlsLayoutData.right = 0;
			controlsLayoutData.bottom = 0;
			this._controls.layoutData = controlsLayoutData;

			var viewLayoutData:AnchorLayoutData = new AnchorLayoutData(0, 0, 0, 0);
			viewLayoutData.bottomAnchorDisplayObject = this._controls;
			this._view.layoutData = viewLayoutData;
		}
		
		protected function createMenu():void
		{
			var menu:NativeMenu;
			if(NativeApplication.supportsMenu)
			{
				menu = NativeApplication.nativeApplication.menu;
				var applicationMenuItem:NativeMenuItem = menu.getItemAt(0);
				menu.removeAllItems();
				menu.addItem(applicationMenuItem);
			}
			else
			{
				menu = new NativeMenu();
				Starling.current.nativeStage.nativeWindow.menu = menu;
			}

			var fileMenuItem:NativeMenuItem = new NativeMenuItem("File");
			var fileMenu:NativeMenu = new NativeMenu();
			fileMenuItem.submenu = fileMenu;
			menu.addItem(fileMenuItem);
			var openItem:NativeMenuItem = new NativeMenuItem("Open");
			openItem.keyEquivalent = "o";
			openItem.addEventListener(flash.events.Event.SELECT, openItem_selectHandler);
			fileMenu.addItem(openItem);
			var closeItem:NativeMenuItem = new NativeMenuItem("Close");
			closeItem.keyEquivalent = "w";
			closeItem.addEventListener(flash.events.Event.SELECT, closeItem_selectHandler);
			fileMenu.addItem(closeItem);

			var viewMenuItem:NativeMenuItem = new NativeMenuItem("View");
			var viewMenu:NativeMenu = new NativeMenu();
			viewMenuItem.submenu = viewMenu;
			menu.addItem(viewMenuItem);
			this._fullScreenItem = new NativeMenuItem("Enter Full Screen");
			this._fullScreenItem.keyEquivalent = "f";
			this._fullScreenItem.addEventListener(flash.events.Event.SELECT, fullScreenItem_selectHandler);
			viewMenu.addItem(this._fullScreenItem);
			
			if(NativeApplication.supportsMenu)
			{
				var windowMenuItem:NativeMenuItem = new NativeMenuItem("Window");
				var windowMenu:NativeMenu = new NativeMenu();
				windowMenuItem.submenu = windowMenu;
				menu.addItem(windowMenuItem);
				var minimizeItem:NativeMenuItem = new NativeMenuItem("Minimize");
				minimizeItem.keyEquivalent = "m";
				minimizeItem.addEventListener(flash.events.Event.SELECT, minimizeItem_selectHandler);
				windowMenu.addItem(minimizeItem);
				var zoomItem:NativeMenuItem = new NativeMenuItem("Zoom");
				zoomItem.addEventListener(flash.events.Event.SELECT, zoomItem_selectHandler);
				windowMenu.addItem(zoomItem);
			}
		}
		
		protected function videoPlayer_readyHandler(event:Event):void
		{
			this._view.source = this._videoPlayer.texture;
			this._controls.touchable = true;
		}
		
		protected function videoPlayer_clearHandler(event:Event):void
		{
			this._view.source = null;
			this._controls.touchable = false;
		}

		protected function videoPlayer_displayStateChangeHandler(event:Event):void
		{
			this._fullScreenItem.label = this._videoPlayer.isFullScreen ? "Exit Full Screen" : "Enter Full Screen";
		}
		
		protected function videoPlayer_errorHandler(event:Event):void
		{
			Alert.show("Cannot play selected video.",
				"Video Error", new ArrayCollection([{ label: "OK" }]));
			trace("VideoPlayer Error: " + event.data);
		}
		
		protected function openItem_selectHandler(event:flash.events.Event):void
		{
			this._fileToOpen = new File();
			this._fileToOpen.addEventListener(flash.events.Event.SELECT, fileToOpen_selectHandler);
			this._fileToOpen.addEventListener(flash.events.Event.CANCEL, fileToOpen_cancelHandler);
			this._fileToOpen.browseForOpen("Select video file",
			[
				new FileFilter("Video files", "*.m4v;*.mp4;*.f4v;*.flv;*.mov")
			]);
		}
		
		protected function closeItem_selectHandler(event:flash.events.Event):void
		{
			//we don't need to dispose the texture here. the VideoPlayer will
			//do it automatically when videoSource is changed.
			this._view.source = null;
			this._videoPlayer.videoSource = null;
			this._controls.touchable = false;
		}
		
		protected function fileToOpen_cancelHandler(event:flash.events.Event):void
		{
			this._fileToOpen.removeEventListener(flash.events.Event.SELECT, fileToOpen_selectHandler);
			this._fileToOpen.removeEventListener(flash.events.Event.CANCEL, fileToOpen_cancelHandler);
			this._fileToOpen = null;
		}

		protected function fileToOpen_selectHandler(event:flash.events.Event):void
		{
			if(this._videoPlayer.videoSource === this._fileToOpen.url)
			{
				//it's the same file, so just start it over instead of trying
				//to load it again!
				this._videoPlayer.stop();
				this._videoPlayer.play();
				return;
			}
			this._controls.touchable = false;
			this._videoPlayer.videoSource = this._fileToOpen.url;
			this._fileToOpen.removeEventListener(flash.events.Event.SELECT, fileToOpen_selectHandler);
			this._fileToOpen.removeEventListener(flash.events.Event.CANCEL, fileToOpen_cancelHandler);
			this._fileToOpen = null;
		}
		
		protected function fullScreenItem_selectHandler(event:flash.events.Event):void
		{
			this._videoPlayer.toggleFullScreen();
		}
		
		protected function minimizeItem_selectHandler(event:flash.events.Event):void
		{
			Starling.current.nativeStage.nativeWindow.minimize();
		}

		protected function zoomItem_selectHandler(event:flash.events.Event):void
		{
			Starling.current.nativeStage.nativeWindow.maximize();
		}
	}
}
