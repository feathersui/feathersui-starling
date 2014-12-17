package feathers.examples.youtube.screens
{
	import feathers.controls.Button;
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

	[Event(name="complete",type="starling.events.Event")]

	public class VideoDetailsScreen extends PanelScreen
	{
		public function VideoDetailsScreen()
		{
			super();
		}

		private var _backButton:Button;
		private var _watchButton:Button;
		private var _scrollText:ScrollText;

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

			this._scrollText = new ScrollText();
			this._scrollText.isHTML = true;
			this._scrollText.verticalScrollPolicy = ScrollText.SCROLL_POLICY_ON;
			this._scrollText.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this.addChild(this._scrollText);

			this._backButton = new Button();
			this._backButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON);
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, onBackButton);
			this.headerProperties.leftItems = new <DisplayObject>
			[
				this._backButton
			];

			this._watchButton = new Button();
			this._watchButton.label = "Watch";
			this._watchButton.addEventListener(Event.TRIGGERED, watchButton_triggeredHandler);
			this.headerProperties.rightItems = new <DisplayObject>
			[
				this._watchButton
			];

			this.backButtonHandler = onBackButton;

			this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionInCompleteHandler);
		}

		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(dataInvalid)
			{
				if(this._model && this._model.selectedVideo)
				{
					this.title = this._model.selectedVideo.title;
					var content:String = '<p><b><font size="+2">' + this._model.selectedVideo.title + '</font></b></p>';
					content += '<p><font size="-2" color="#999999">' + this._model.selectedVideo.author + '</font></p><br>';
					content += this._model.selectedVideo.description.replace(/\r\n/g, "<br>");
					this._scrollText.text = content;
				}
				else
				{
					this.title = null;
					this._scrollText.text = "";
				}
			}

			//never forget to call super.draw()!
			super.draw();
		}

		private function onBackButton(event:Event = null):void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function transitionInCompleteHandler(event:Event):void
		{
			this.revealScrollBars();
		}

		private function watchButton_triggeredHandler(event:Event):void
		{
			navigateToURL(new URLRequest(this._model.selectedVideo.url), "_blank");
		}
	}
}
