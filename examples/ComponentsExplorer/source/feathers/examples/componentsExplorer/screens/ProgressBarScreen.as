package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.controls.ProgressBar;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import feathers.system.DeviceCapabilities;

	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class ProgressBarScreen extends PanelScreen
	{
		public function ProgressBarScreen()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		private var _backButton:Button;
		private var _horizontalProgress:ProgressBar;
		private var _verticalProgress:ProgressBar;

		private var _horizontalProgressTween:Tween;
		private var _verticalProgressTween:Tween;

		protected function initializeHandler(event:Event):void
		{
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			layout.gap = 44 * this.dpiScale;
			this.layout = layout;

			this._horizontalProgress = new ProgressBar();
			this._horizontalProgress.direction = ProgressBar.DIRECTION_HORIZONTAL;
			this._horizontalProgress.minimum = 0;
			this._horizontalProgress.maximum = 1;
			this._horizontalProgress.value = 0;
			this.addChild(this._horizontalProgress);

			this._verticalProgress = new ProgressBar();
			this._verticalProgress.direction = ProgressBar.DIRECTION_VERTICAL;
			this._verticalProgress.minimum = 0;
			this._verticalProgress.maximum = 100;
			this._verticalProgress.value = 0;
			this.addChild(this._verticalProgress);

			this.headerProperties.title = "Progress Bar";

			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this._backButton = new Button();
				this._backButton.styleNameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
				this._backButton.label = "Back";
				this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

				this.headerProperties.leftItems = new <DisplayObject>
				[
					this._backButton
				];

				this.backButtonHandler = this.onBackButton;
			}

			this._horizontalProgressTween = new Tween(this._horizontalProgress, 5);
			this._horizontalProgressTween.animate("value", 1);
			this._horizontalProgressTween.repeatCount = int.MAX_VALUE;
			Starling.juggler.add(this._horizontalProgressTween);

			this._verticalProgressTween = new Tween(this._verticalProgress, 8);
			this._verticalProgressTween.animate("value", 100);
			this._verticalProgressTween.repeatCount = int.MAX_VALUE;
			Starling.juggler.add(this._verticalProgressTween);
		}

		private function onBackButton():void
		{
			if(this._horizontalProgressTween)
			{
				Starling.juggler.remove(this._horizontalProgressTween);
				this._horizontalProgressTween = null;
			}
			if(this._verticalProgressTween)
			{
				Starling.juggler.remove(this._verticalProgressTween);
				this._verticalProgressTween = null;
			}
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}
	}
}
