package feathers.examples.youtube.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.controls.ScrollText;
	import feathers.examples.youtube.models.YouTubeModel;

	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class VideoDetailsScreen extends Screen
	{
		public function VideoDetailsScreen()
		{
		}

		private var _header:Header;
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
			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, onBackButton);

			this._watchButton = new Button();
			this._watchButton.label = "Watch";
			this._watchButton.addEventListener(Event.TRIGGERED, watchButton_triggeredHandler);

			this._header = new Header();
			this.addChild(this._header);
			this._header.leftItems = new <DisplayObject>
			[
				this._backButton
			];
			this._header.rightItems = new <DisplayObject>
			[
				this._watchButton
			];

			this._scrollText = new ScrollText();
			this._scrollText.isHTML = true;
			this._scrollText.verticalScrollPolicy = ScrollText.SCROLL_POLICY_ON;
			this.addChild(this._scrollText);

			this.backButtonHandler = onBackButton;
		}

		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);

			if(dataInvalid)
			{
				if(this._model && this._model.selectedVideo)
				{
					this._header.title = this._model.selectedVideo.title;
					var content:String = '<p><b><font size="+2">' + this._model.selectedVideo.title + '</font></b></p>';
					content += '<p><font size="-2" color="#999999">' + this._model.selectedVideo.author + '</font></p><br>';
					content += this._model.selectedVideo.description.replace(/\r\n/g, "<br>");
					this._scrollText.text = content;
				}
				else
				{
					this._header.title = null;
					this._scrollText.text = "";
				}
			}

			this._header.width = this.actualWidth;
			this._header.validate();

			this._scrollText.width = this.actualWidth;
			this._scrollText.y = this._header.height;
			this._scrollText.height = this.actualHeight - this._scrollText.y;
		}

		private function onBackButton(event:Event = null):void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function watchButton_triggeredHandler(event:Event):void
		{
			navigateToURL(new URLRequest(this._model.selectedVideo.url), "_blank");
		}
	}
}
