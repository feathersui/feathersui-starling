package feathers.tests
{
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PickerList;
	import feathers.controls.popups.DropDownPopUpContentManager;
	import feathers.core.PopUpManager;
	import feathers.data.ListCollection;

	import flash.geom.Point;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;

	import starling.display.DisplayObjectContainer;

	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class PickerListTests
	{
		private static const BUTTON_NAME:String = "button";
		private static const LIST_NAME:String = "list";

		private var _list:PickerList;

		[Before]
		public function prepare():void
		{
			this._list = new PickerList();
			this._list.dataProvider = new ListCollection(
			[
				{ label: "One" },
				{ label: "Two" },
				{ label: "Three" },
			]);
			this._list.popUpContentManager = new DropDownPopUpContentManager();
			this._list.buttonFactory = function():Button
			{
				var track:Button = new Button();
				track.name = BUTTON_NAME;
				track.defaultSkin = new Quad(200, 200);
				return track;
			};
			this._list.listFactory = function():List
			{
				var list:List = new List();
				list.name = LIST_NAME;
				return list;
			};
			TestFeathers.starlingRoot.addChild(this._list);
			this._list.validate();
		}

		[After]
		public function cleanup():void
		{
			this._list.removeFromParent(true);
			this._list = null;
		}

		[Test]
		public function testProgrammaticOpenAndCloseEvents():void
		{
			var hasOpened:Boolean = false;
			this._list.addEventListener(Event.OPEN, function(event:Event):void
			{
				hasOpened = true;
			});
			var hasClosed:Boolean = false;
			this._list.addEventListener(Event.CLOSE, function(event:Event):void
			{
				hasClosed = true;
			});

			this._list.openList();
			//the picker list may require validation before opening or closing
			this._list.validate();

			Assert.assertTrue("Event.OPEN was not dispatched", hasOpened);
			Assert.assertNotNull("The pop-up list was not added to the PopUpManager",
				PopUpManager.root.getChildByName(LIST_NAME));

			this._list.closeList();
			this._list.validate();

			Assert.assertTrue("Event.CLOSE was not dispatched", hasClosed);
			Assert.assertNull("The list's parent property is not null",
				PopUpManager.root.getChildByName(LIST_NAME));
		}

		[Test]
		public function testCloseOnDispose():void
		{
			var hasClosed:Boolean = false;
			this._list.addEventListener(Event.CLOSE, function(event:Event):void
			{
				hasClosed = true;
			});

			this._list.openList();
			this._list.validate();

			this._list.dispose();

			Assert.assertTrue("Event.CLOSE was not dispatched", hasClosed);
		}

		[Test]
		public function testInteractiveOpenEvent():void
		{
			var hasOpened:Boolean = false;
			this._list.addEventListener(Event.OPEN, function(event:Event):void
			{
				hasOpened = true;
			});
			var hasClosed:Boolean = false;
			this._list.addEventListener(Event.CLOSE, function(event:Event):void
			{
				hasClosed = true;
			});

			var position:Point = new Point(100, 100);
			var target:DisplayObject = this._list.stage.hitTest(position, true);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			//this touch does not move at all, so it should result in triggering
			//the button.
			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			//the picker list may require validation before opening or closing
			this._list.validate();

			Assert.assertTrue("Event.OPEN was not dispatched", hasOpened);
			Assert.assertNotNull("The pop-up list was not added to the PopUpManager",
				PopUpManager.root.getChildByName(LIST_NAME));
		}

		[Test]
		public function testSetPopUpListDataProvider():void
		{
			this._list.openList();
			//the picker list may require validation before opening or closing
			this._list.validate();

			var popUpList:List = PopUpManager.root.getChildByName(LIST_NAME) as List;

			Assert.assertStrictlyEquals("The pop-up list data provider was not set",
				this._list.dataProvider, popUpList.dataProvider);
		}

		[Test]
		public function testProgrammaticSelectionChange():void
		{
			var beforeSelectedIndex:int = this._list.selectedIndex;
			var beforeSelectedItem:Object = this._list.selectedItem;
			var hasChanged:Boolean = false;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._list.selectedIndex = 1;
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertFalse("The selectedIndex property was not changed",
				beforeSelectedIndex === this._list.selectedIndex);
			Assert.assertFalse("The selectedItem property was not changed",
				beforeSelectedItem === this._list.selectedItem);
		}
	}
}
