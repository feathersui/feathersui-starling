package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.ProgressBar;
	import feathers.controls.Screen;

	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class ProgressBarScreen extends Screen
	{
		public function ProgressBarScreen()
		{
		}

		private var _header:Header;
		private var _backButton:Button;
		private var _progress:ProgressBar;

		private var _progressTween:Tween;

		override protected function initialize():void
		{
			this._progress = new ProgressBar();
			this._progress.minimum = 0;
			this._progress.maximum = 1;
			this._progress.value = 0;
			this.addChild(this._progress);

			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

			this._header = new Header();
			this._header.title = "Progress Bar";
			this.addChild(this._header);
			this._header.leftItems = new <DisplayObject>
			[
				this._backButton
			];

			// handles the back hardware key on android
			this.backButtonHandler = this.onBackButton;

			this._progressTween = new Tween(this._progress, 5);
			this._progressTween.animate("value", 1);
			this._progressTween.repeatCount = int.MAX_VALUE;
			Starling.juggler.add(this._progressTween);
		}

		override protected function draw():void
		{
			this._header.width = this.actualWidth;
			this._header.validate();

			this._progress.validate();
			this._progress.x = (this.actualWidth - this._progress.width) / 2;
			this._progress.y = this._header.height + (this.actualHeight - this._header.height - this._progress.height) / 2;
		}

		private function onBackButton():void
		{
			if(this._progressTween)
			{
				Starling.juggler.remove(this._progressTween);
				this._progressTween = null;
			}
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}
	}
}
