package feathers.tests
{
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.ToggleButton;
	import feathers.data.ListCollection;
	import feathers.layout.Direction;

	import flash.geom.Point;

	import org.flexunit.Assert;
	import org.flexunit.async.Async;

	import starling.display.DisplayObject;

	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class ButtonGroupDataProviderEventsTests
	{
		private var _group:ButtonGroup;

		[Before]
		public function prepare():void
		{
			this._group = new ButtonGroup();
			this._group.direction = Direction.VERTICAL;
			TestFeathers.starlingRoot.addChild(this._group);
		}

		[After]
		public function cleanup():void
		{
			this._group.removeFromParent(true);
			this._group = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testTriggeredEventInDataProvider():void
		{
			var triggeredItem:Object;
			var hasTriggered:Boolean = false;
			function triggeredListener(event:Event, data:Object, item:Object):void
			{
				hasTriggered = true;
				triggeredItem = item;
			}
			
			this._group.dataProvider = new ListCollection(
			[
				{ label: "One" },
				{ label: "Two", triggered: triggeredListener },
				{ label: "Three" },
			]);
			this._group.buttonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(200, 200);
				return button;
			}
			this._group.validate();
			
			var position:Point = new Point(10, 210);
			var target:DisplayObject = this._group.stage.hitTest(position);
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
			Assert.assertTrue("Event.TRIGGERED was not dispatched to listener in data provider", hasTriggered);
			Assert.assertStrictlyEquals("Event.TRIGGERED was not dispatched with correct item to listener in data provider", this._group.dataProvider.getItemAt(1), triggeredItem);
		}

		[Test]
		public function testChangeEventInDataProvider():void
		{
			var changedItem:Object;
			var hasChanged:Boolean = false;
			function changeListener(event:Event, data:Object, item:Object):void
			{
				hasChanged = true;
				changedItem = item;
			}

			this._group.dataProvider = new ListCollection(
			[
				{ label: "One" },
				{ label: "Two", change: changeListener },
				{ label: "Three" },
			]);
			this._group.buttonFactory = function():ToggleButton
			{
				var button:ToggleButton = new ToggleButton();
				button.defaultSkin = new Quad(200, 200);
				return button;
			}
			this._group.validate();
			
			var position:Point = new Point(10, 210);
			var target:DisplayObject = this._group.stage.hitTest(position);
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
			Assert.assertTrue("Event.CHANGE was not dispatched to listener in data provider", hasChanged);
			Assert.assertStrictlyEquals("Event.CHANGE was not dispatched with correct item to listener in data provider", this._group.dataProvider.getItemAt(1), changedItem);
		}

		[Test(async)]
		public function testLongPressEventInDataProvider():void
		{
			var longPressItem:Object;
			var hasLongPressed:Boolean = false;
			function longPressListener(event:Event, data:Object, item:Object):void
			{
				hasLongPressed = true;
				longPressItem = item;
			}

			this._group.dataProvider = new ListCollection(
			[
				{ label: "One" },
				{ label: "Two", isLongPressEnabled: true, longPress: longPressListener },
				{ label: "Three" },
			]);
			this._group.buttonFactory = function():ToggleButton
			{
				var button:ToggleButton = new ToggleButton();
				button.defaultSkin = new Quad(200, 200);
				return button;
			}
			this._group.validate();

			var position:Point = new Point(10, 210);
			var target:DisplayObject = this._group.stage.hitTest(position);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = 10;
			touch.globalY = 210;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Async.delayCall(this, function():void
			{
				Assert.assertTrue("FeathersEventType.LONG_PRESS was not dispatched to listener in data provider", hasLongPressed);
				Assert.assertStrictlyEquals("Event.CHANGE was not dispatched with correct item to listener in data provider", _group.dataProvider.getItemAt(1), longPressItem);
			}, 600);
		}
	}
}
