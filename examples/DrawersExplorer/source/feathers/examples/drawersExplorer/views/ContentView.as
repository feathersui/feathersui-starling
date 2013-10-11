package feathers.examples.drawersExplorer.views
{
	import feathers.controls.Button;
	import feathers.controls.Panel;
	import feathers.controls.ScrollContainer;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;

	import starling.events.Event;

	public class ContentView extends ScrollContainer
	{
		public static const TOGGLE_TOP_DRAWER:String = "toggleTopDrawer";
		public static const TOGGLE_RIGHT_DRAWER:String = "toggleRightDrawer";
		public static const TOGGLE_BOTTOM_DRAWER:String = "toggleBottomDrawer";
		public static const TOGGLE_LEFT_DRAWER:String = "toggleLeftDrawer";

		public function ContentView()
		{

		}

		private var _topButton:Button;
		private var _rightButton:Button;
		private var _bottomButton:Button;
		private var _leftButton:Button;

		override protected function initialize():void
		{
			var openControlsPanel:Panel = new Panel();
			openControlsPanel.headerProperties.title = "Open Drawers";
			openControlsPanel.layout = new AnchorLayout();
			this.addChild(openControlsPanel);

			this._topButton = new Button();
			this._topButton.label = "Top";
			this._topButton.addEventListener(Event.TRIGGERED, topButton_triggeredHandler);
			var topLayoutData:AnchorLayoutData = new AnchorLayoutData();
			topLayoutData.horizontalCenter = 0;
			this._topButton.layoutData = topLayoutData;
			openControlsPanel.addChild(this._topButton);

			this._rightButton = new Button();
			this._rightButton.label = "Right";
			this._rightButton.addEventListener(Event.TRIGGERED, rightButton_triggeredHandler);
			var rightLayoutData:AnchorLayoutData = new AnchorLayoutData();
			rightLayoutData.verticalCenter = 0;
			this._rightButton.layoutData = rightLayoutData;
			openControlsPanel.addChild(this._rightButton);

			this._bottomButton = new Button();
			this._bottomButton.label = "Bottom";
			this._bottomButton.addEventListener(Event.TRIGGERED, bottomButton_triggeredHandler);
			var bottomLayoutData:AnchorLayoutData = new AnchorLayoutData();
			bottomLayoutData.horizontalCenter = 0;
			this._bottomButton.layoutData = bottomLayoutData;
			openControlsPanel.addChild(this._bottomButton);

			this._leftButton = new Button();
			this._leftButton.label = "Left";
			this._leftButton.addEventListener(Event.TRIGGERED, leftButton_triggeredHandler);
			var leftLayoutData:AnchorLayoutData = new AnchorLayoutData();
			leftLayoutData.verticalCenter = 0;
			this._leftButton.layoutData = leftLayoutData;
			openControlsPanel.addChild(this._leftButton);

			this._topButton.validate();
			var verticalOffset:Number = this._topButton.height * 1.5;
			topLayoutData.verticalCenter = -verticalOffset;
			bottomLayoutData.verticalCenter = verticalOffset;

			this._rightButton.validate();
			var horizontalOffset:Number = this._rightButton.width;
			rightLayoutData.horizontalCenter = horizontalOffset;
			leftLayoutData.horizontalCenter = -horizontalOffset;
		}

		private function topButton_triggeredHandler(event:Event):void
		{
			this.dispatchEventWith(TOGGLE_TOP_DRAWER);
		}

		private function rightButton_triggeredHandler(event:Event):void
		{
			this.dispatchEventWith(TOGGLE_RIGHT_DRAWER);
		}

		private function bottomButton_triggeredHandler(event:Event):void
		{
			this.dispatchEventWith(TOGGLE_BOTTOM_DRAWER);
		}

		private function leftButton_triggeredHandler(event:Event):void
		{
			this.dispatchEventWith(TOGGLE_LEFT_DRAWER);
		}
	}
}
