package feathers.examples.drawersExplorer
{
	import feathers.controls.Drawers;
	import feathers.events.FeathersEventType;
	import feathers.examples.drawersExplorer.skins.DrawersExplorerTheme;
	import feathers.examples.drawersExplorer.views.ContentView;
	import feathers.examples.drawersExplorer.views.DrawerView;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.events.Event;

	public class Main extends Drawers
	{
		public function Main()
		{
			super();
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		private function changeDockMode(drawer:DrawerView, dockMode:String):void
		{
			switch(drawer)
			{
				case this.topDrawer:
				{
					this.topDrawerDockMode = dockMode;
					break;
				}
				case this.rightDrawer:
				{
					this.rightDrawerDockMode = dockMode;
					break;
				}
				case this.bottomDrawer:
				{
					this.bottomDrawerDockMode = dockMode;
					break;
				}
				case this.leftDrawer:
				{
					this.leftDrawerDockMode = dockMode;
					break;
				}
			}
		}
		
		private function initializeHandler(event:Event):void
		{
			new DrawersExplorerTheme();

			//a drawer may be opened by dragging from the edge of the content
			//you can also set it to drag from anywhere inside the content
			//or you can disable gestures entirely and only open a drawer when
			//an event is dispatched by the content or by calling a function
			//on the drawer component to open a drawer programmatically.
			this.openGesture = Drawers.OPEN_GESTURE_DRAG_CONTENT_EDGE;

			this.content = new ContentView();
			//these events are dispatched by the content
			//Drawers listens for each of these events and opens the drawer
			//associated with an event when it is dispatched
			this.topDrawerToggleEventType = ContentView.TOGGLE_TOP_DRAWER;
			this.rightDrawerToggleEventType = ContentView.TOGGLE_RIGHT_DRAWER;
			this.bottomDrawerToggleEventType = ContentView.TOGGLE_BOTTOM_DRAWER;
			this.leftDrawerToggleEventType = ContentView.TOGGLE_LEFT_DRAWER;

			var topDrawer:DrawerView = new DrawerView("Top");
			topDrawer.nameList.add(DrawersExplorerTheme.THEME_NAME_TOP_AND_BOTTOM_DRAWER);
			topDrawer.addEventListener(DrawerView.CHANGE_DOCK_MODE_TO_NONE, drawer_dockNoneHandler);
			topDrawer.addEventListener(DrawerView.CHANGE_DOCK_MODE_TO_BOTH, drawer_dockBothHandler);
			//a drawer may be any display object
			this.topDrawer = topDrawer;
			//by default, a drawer is not docked. it may be opened and closed
			//based on user interaction or events dispatched by the content.
			this.topDrawerDockMode = Drawers.DOCK_MODE_NONE;

			var rightDrawer:DrawerView = new DrawerView("Right");
			rightDrawer.nameList.add(DrawersExplorerTheme.THEME_NAME_LEFT_AND_RIGHT_DRAWER);
			rightDrawer.addEventListener(DrawerView.CHANGE_DOCK_MODE_TO_NONE, drawer_dockNoneHandler);
			rightDrawer.addEventListener(DrawerView.CHANGE_DOCK_MODE_TO_BOTH, drawer_dockBothHandler);
			this.rightDrawer = rightDrawer;
			this.rightDrawerDockMode = Drawers.DOCK_MODE_NONE;

			var bottomDrawer:DrawerView = new DrawerView("Bottom");
			bottomDrawer.nameList.add(DrawersExplorerTheme.THEME_NAME_TOP_AND_BOTTOM_DRAWER);
			bottomDrawer.addEventListener(DrawerView.CHANGE_DOCK_MODE_TO_NONE, drawer_dockNoneHandler);
			bottomDrawer.addEventListener(DrawerView.CHANGE_DOCK_MODE_TO_BOTH, drawer_dockBothHandler);
			this.bottomDrawer = bottomDrawer;
			this.bottomDrawerDockMode = Drawers.DOCK_MODE_NONE;

			var leftDrawer:DrawerView = new DrawerView("Left");
			leftDrawer.nameList.add(DrawersExplorerTheme.THEME_NAME_LEFT_AND_RIGHT_DRAWER);
			leftDrawer.addEventListener(DrawerView.CHANGE_DOCK_MODE_TO_NONE, drawer_dockNoneHandler);
			leftDrawer.addEventListener(DrawerView.CHANGE_DOCK_MODE_TO_BOTH, drawer_dockBothHandler);
			this.leftDrawer = leftDrawer;
			this.leftDrawerDockMode = Drawers.DOCK_MODE_NONE;
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
	}
}