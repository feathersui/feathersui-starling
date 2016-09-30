package feathers.examples.drawersExplorer.views
{
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.Panel;
	import feathers.controls.PickerList;
	import feathers.controls.ScrollContainer;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.RelativeDepth;
	import feathers.layout.VerticalLayout;
	import feathers.skins.IStyleProvider;

	import starling.events.Event;

	public class ContentView extends ScrollContainer
	{
		public static var globalStyleProvider:IStyleProvider;

		public static const TOGGLE_TOP_DRAWER:String = "toggleTopDrawer";
		public static const TOGGLE_RIGHT_DRAWER:String = "toggleRightDrawer";
		public static const TOGGLE_BOTTOM_DRAWER:String = "toggleBottomDrawer";
		public static const TOGGLE_LEFT_DRAWER:String = "toggleLeftDrawer";
		public static const OPEN_MODE_CHANGE:String = "openModeChange";

		public function ContentView()
		{

		}

		private var _topButton:Button;
		private var _rightButton:Button;
		private var _bottomButton:Button;
		private var _leftButton:Button;
		
		private var _openModePicker:PickerList;

		override protected function get defaultStyleProvider():IStyleProvider
		{
			return ContentView.globalStyleProvider;
		}
		
		private var _openMode:String = RelativeDepth.BELOW;
		
		public function get openMode():String
		{
			return this._openMode;
		}

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
			
			var optionsPanel:Panel = new Panel();
			optionsPanel.headerProperties.title = "Options";
			optionsPanel.layout = new VerticalLayout();
			this.addChild(optionsPanel);
			
			this._openModePicker = new PickerList();
			this._openModePicker.dataProvider = new ListCollection(
			[
				{ label: "Below", data: RelativeDepth.BELOW },
				{ label: "Above", data: RelativeDepth.ABOVE },
			]);
			this._openModePicker.addEventListener(Event.CHANGE, openModePicker_changeHandler);

			var optionsList:List = new List();
			optionsList.dataProvider = new ListCollection(
			[
				{ label: "Open Mode", accessory: this._openModePicker },
			]);
			optionsPanel.addChild(optionsList);
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
		
		private function openModePicker_changeHandler(event:Event):void
		{
			this._openMode = this._openModePicker.selectedItem.data as String;
			this.dispatchEventWith(OPEN_MODE_CHANGE);
		}
	}
}
