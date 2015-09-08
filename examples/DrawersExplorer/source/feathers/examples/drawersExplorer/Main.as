package feathers.examples.drawersExplorer
{
	import feathers.controls.Drawers;
	import feathers.examples.drawersExplorer.skins.DrawersExplorerTheme;
	import feathers.examples.drawersExplorer.views.ContentView;
	import feathers.examples.drawersExplorer.views.DrawerView;

	import starling.display.Sprite;
	import starling.events.Event;

	public class Main extends Sprite
	{
		public function Main()
		{
			//set up the theme right away!
			new DrawersExplorerTheme();
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		private var _drawers:Drawers;

		private function changeDockMode(drawer:DrawerView, dockMode:String):void
		{
			switch(drawer)
			{
				case this._drawers.topDrawer:
				{
					this._drawers.topDrawerDockMode = dockMode;
					break;
				}
				case this._drawers.rightDrawer:
				{
					this._drawers.rightDrawerDockMode = dockMode;
					break;
				}
				case this._drawers.bottomDrawer:
				{
					this._drawers.bottomDrawerDockMode = dockMode;
					break;
				}
				case this._drawers.leftDrawer:
				{
					this._drawers.leftDrawerDockMode = dockMode;
					break;
				}
			}
		}
		
		private function addedToStageHandler(event:Event):void
		{
			this._drawers = new Drawers();

			//a drawer may be opened by dragging from the edge of the content
			//you can also set it to drag from anywhere inside the content
			//or you can disable gestures entirely and only open a drawer when
			//an event is dispatched by the content or by calling a function
			//on the drawer component to open a drawer programmatically.
			this._drawers.openGesture = Drawers.OPEN_GESTURE_DRAG_CONTENT_EDGE;

			this._drawers.content = new ContentView();
			//these events are dispatched by the content
			//Drawers listens for each of these events and opens the drawer
			//associated with an event when it is dispatched
			this._drawers.topDrawerToggleEventType = ContentView.TOGGLE_TOP_DRAWER;
			this._drawers.rightDrawerToggleEventType = ContentView.TOGGLE_RIGHT_DRAWER;
			this._drawers.bottomDrawerToggleEventType = ContentView.TOGGLE_BOTTOM_DRAWER;
			this._drawers.leftDrawerToggleEventType = ContentView.TOGGLE_LEFT_DRAWER;
<<<<<<< HEAD
=======
			this._drawers.content.addEventListener(ContentView.OPEN_MODE_CHANGE, contentView_openDrawerChangeHandler);
>>>>>>> master

			var topDrawer:DrawerView = new DrawerView("Top");
			topDrawer.styleNameList.add(DrawersExplorerTheme.THEME_NAME_TOP_AND_BOTTOM_DRAWER);
			topDrawer.addEventListener(DrawerView.CHANGE_DOCK_MODE_TO_NONE, drawer_dockNoneHandler);
			topDrawer.addEventListener(DrawerView.CHANGE_DOCK_MODE_TO_BOTH, drawer_dockBothHandler);
			//a drawer may be any display object
			this._drawers.topDrawer = topDrawer;
			//by default, a drawer is not docked. it may be opened and closed
			//based on user interaction or events dispatched by the content.
			this._drawers.topDrawerDockMode = Drawers.DOCK_MODE_NONE;

			var rightDrawer:DrawerView = new DrawerView("Right");
			rightDrawer.styleNameList.add(DrawersExplorerTheme.THEME_NAME_LEFT_AND_RIGHT_DRAWER);
			rightDrawer.addEventListener(DrawerView.CHANGE_DOCK_MODE_TO_NONE, drawer_dockNoneHandler);
			rightDrawer.addEventListener(DrawerView.CHANGE_DOCK_MODE_TO_BOTH, drawer_dockBothHandler);
			this._drawers.rightDrawer = rightDrawer;
			this._drawers.rightDrawerDockMode = Drawers.DOCK_MODE_NONE;

			var bottomDrawer:DrawerView = new DrawerView("Bottom");
			bottomDrawer.styleNameList.add(DrawersExplorerTheme.THEME_NAME_TOP_AND_BOTTOM_DRAWER);
			bottomDrawer.addEventListener(DrawerView.CHANGE_DOCK_MODE_TO_NONE, drawer_dockNoneHandler);
			bottomDrawer.addEventListener(DrawerView.CHANGE_DOCK_MODE_TO_BOTH, drawer_dockBothHandler);
			this._drawers.bottomDrawer = bottomDrawer;
			this._drawers.bottomDrawerDockMode = Drawers.DOCK_MODE_NONE;

			var leftDrawer:DrawerView = new DrawerView("Left");
			leftDrawer.styleNameList.add(DrawersExplorerTheme.THEME_NAME_LEFT_AND_RIGHT_DRAWER);
			leftDrawer.addEventListener(DrawerView.CHANGE_DOCK_MODE_TO_NONE, drawer_dockNoneHandler);
			leftDrawer.addEventListener(DrawerView.CHANGE_DOCK_MODE_TO_BOTH, drawer_dockBothHandler);
			this._drawers.leftDrawer = leftDrawer;
			this._drawers.leftDrawerDockMode = Drawers.DOCK_MODE_NONE;

			this.addChild(this._drawers);
		}

		private function drawer_dockNoneHandler(event:Event):void
		{
			var drawer:DrawerView = DrawerView(event.currentTarget);
			this.changeDockMode(drawer, Drawers.DOCK_MODE_NONE);
		}

		private function drawer_dockBothHandler(event:Event):void
		{
			var drawer:DrawerView = DrawerView(event.currentTarget);
			this.changeDockMode(drawer, Drawers.DOCK_MODE_BOTH);
		}
<<<<<<< HEAD
=======
		
		private function contentView_openDrawerChangeHandler(event:Event):void
		{
			var content:ContentView = ContentView(event.currentTarget);
			this._drawers.openMode = content.openMode;
		}
>>>>>>> master
	}
}