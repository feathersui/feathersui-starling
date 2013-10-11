package feathers.examples.drawersExplorer.views
{
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.ScrollContainer;
	import feathers.events.FeathersEventType;

	import starling.events.Event;

	public class DrawerView extends ScrollContainer
	{
		public static const CHANGE_DOCK_MODE_TO_NONE:String = "changeDockModeToNone";
		public static const CHANGE_DOCK_MODE_TO_BOTH:String = "changeDockModeToBoth";

		public function DrawerView(title:String)
		{
			this._title = title;
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		private var _title:String;
		private var _titleLabel:Label;
		private var _dockCheck:Check;

		private function initializeHandler(event:Event):void
		{
			this._titleLabel = new Label();
			this._titleLabel.nameList.add(Label.ALTERNATE_NAME_HEADING);
			this._titleLabel.text = this._title;
			this.addChild(this._titleLabel);

			this._dockCheck = new Check();
			this._dockCheck.isSelected = false;
			this._dockCheck.label = "Dock";
			this._dockCheck.addEventListener(Event.CHANGE, dockCheck_changeHandler);
			this.addChild(this._dockCheck);
		}

		private function dockCheck_changeHandler(event:Event):void
		{
			if(this._dockCheck.isSelected)
			{
				this.dispatchEventWith(CHANGE_DOCK_MODE_TO_BOTH);
			}
			else
			{
				this.dispatchEventWith(CHANGE_DOCK_MODE_TO_NONE);
			}
		}

	}
}
