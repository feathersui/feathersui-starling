package feathers.examples.youtube.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.ImageLoader;
	import feathers.controls.PanelScreen;
	import feathers.controls.ScrollText;
	import feathers.events.FeathersEventType;
	import feathers.examples.youtube.models.YouTubeModel;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;

	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.utils.ScaleMode;

	[Event(name="complete",type="starling.events.Event")]

	public class VideoDetailsScreen extends PanelScreen
	{
		public function VideoDetailsScreen()
		{
			super();
		}

		private var _backButton:Button;
		private var _watchButton:Button;
		private var _thumbnail:ImageLoader;
		private var _portraitThumbnailLayoutData:AnchorLayoutData;
		private var _landscapeThumbnailLayoutData:AnchorLayoutData;
		private var _scrollText:ScrollText;
		private var _portraitTextLayoutData:AnchorLayoutData;
		private var _landscapeTextLayoutData:AnchorLayoutData;

		private var _model:YouTubeModel;

		public function get model():YouTubeModel
		{
			return this._model;
		}

		public function set model(value:YouTubeModel):void
		{
			if(this._model == value)
			{
				return;
			}
			this._model = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.layout = new AnchorLayout();
			
			this._thumbnail = new ImageLoader();
			this._thumbnail.scaleMode = ScaleMode.NO_BORDER;
			this._thumbnail.layoutData = new AnchorLayoutData(0, 0, NaN, 0);
			this.addChild(this._thumbnail);

			this._scrollText = new ScrollText();
			this._scrollText.isHTML = true;
			this._scrollText.verticalScrollPolicy = ScrollText.SCROLL_POLICY_ON;
			this.addChild(this._scrollText);
			
			//we're going to use these AnchorLayoutData objects later, when we
			//know if this screen is displayed in portrait or landscape.
			//we'll change it dynamically if the device is rotated while this
			//screen is visible.
			this._portraitThumbnailLayoutData = new AnchorLayoutData(0, 0, NaN, 0);
			this._landscapeThumbnailLayoutData = new AnchorLayoutData(0, NaN, 0, 0);
			this._landscapeThumbnailLayoutData.percentWidth = 50;
			this._portraitTextLayoutData = new AnchorLayoutData(0, 0, 0, 0);
			this._portraitTextLayoutData.topAnchorDisplayObject = this._thumbnail;
			this._landscapeTextLayoutData = new AnchorLayoutData(0, 0, 0, 0);
			this._landscapeTextLayoutData.leftAnchorDisplayObject = this._thumbnail;

			this.headerFactory = this.customHeaderFactory;

			this.backButtonHandler = onBackButton;

			this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionInCompleteHandler);
		}

		private function customHeaderFactory():Header
		{
			var header:Header = new Header();

			this._backButton = new Button();
			this._backButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON);
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, onBackButton);
			header.leftItems = new <DisplayObject>
			[
				this._backButton
			];

			this._watchButton = new Button();
			this._watchButton.label = "Watch";
			this._watchButton.addEventListener(Event.TRIGGERED, watchButton_triggeredHandler);
			header.rightItems = new <DisplayObject>
			[
				this._watchButton
			];

			return header;
		}

		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			
			if(dataInvalid)
			{
				if(this._model && this._model.selectedVideo)
				{
					this.title = this._model.selectedVideo.title;
					this._thumbnail.source = this._model.selectedVideo.thumbnailURL;
					
					var content:String = '<p><b><font size="+2">' + this._model.selectedVideo.title + '</font></b></p>';
					content += '<p><font size="-2" color="#999999">' + this._model.selectedVideo.author + '</font></p><br>';
					content += this._model.selectedVideo.description.replace(/\r\n/g, "<br>");
					this._scrollText.text = content;
				}
				else
				{
					this.title = null;
					this._thumbnail.source = null;
					this._scrollText.text = "";
				}
			}
			
			if(sizeInvalid)
			{
				this.refreshLayout();
			}

			//never forget to call super.draw()!
			super.draw();
		}
		
		protected function refreshLayout():void
		{
			if(this.actualHeight > this.actualWidth &&
				this._thumbnail.layoutData != this._portraitThumbnailLayoutData) //portrait
			{
				//in landscape, the height of the thumbnail may have been set
				//explicitly. we need to reset it so that the thumbnail can
				//resize itself automatically.
				this._thumbnail.height = NaN;
				this._thumbnail.layoutData = this._portraitThumbnailLayoutData;
				
				this._scrollText.layoutData = this._portraitTextLayoutData;
			}
			else if(this.actualWidth > this.actualHeight) //landscape
			{
				this._thumbnail.layoutData = this._landscapeThumbnailLayoutData;
				this._scrollText.layoutData = this._landscapeTextLayoutData;
			}
		}

		private function onBackButton(event:Event = null):void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function transitionInCompleteHandler(event:Event):void
		{
			this._scrollText.revealScrollBars();
		}

		private function watchButton_triggeredHandler(event:Event):void
		{
			navigateToURL(new URLRequest(this._model.selectedVideo.url), "_blank");
		}
	}
}
