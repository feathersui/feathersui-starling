package feathers.tests
{
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.data.ListCollection;
	import feathers.layout.Direction;

	import flash.geom.Point;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class ButtonGroupTests
	{
		private var _group:ButtonGroup;

		[Before]
		public function prepare():void
		{
			this._group = new ButtonGroup();
			this._group.dataProvider = new ListCollection(
			[
				{ label: "One", name: "one" },
				{ label: "Two", name: "two" },
				{ label: "Three", isEnabled: true, name: "three" },
				{ label: "Four", isEnabled: false, name: "four" },
			]);
			this._group.buttonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(200, 200);
				return button;
			}
			this._group.direction = Direction.VERTICAL;
			TestFeathers.starlingRoot.addChild(this._group);
			this._group.validate();
		}

		[After]
		public function cleanup():void
		{
			this._group.removeFromParent(true);
			this._group = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testTriggeredEvent():void
		{
			var triggeredItem:Object;
			var hasTriggered:Boolean = false;
			this._group.addEventListener(Event.TRIGGERED, function(event:Event):void
			{
				hasTriggered = true;
				triggeredItem = event.data;
			});
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
			Assert.assertTrue("Event.TRIGGERED was not dispatched", hasTriggered);
			Assert.assertStrictlyEquals("Event.TRIGGERED was not dispatched with correct data", this._group.dataProvider.getItemAt(1), triggeredItem);
		}

		[Test]
		public function testDirectionSetToVerticalAndDistributeButtonSizesSetToTrueWithLargerHeight():void
		{
			this._group.direction = Direction.VERTICAL;
			this._group.distributeButtonSizes = true;
			this._group.height = 1600;
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup button height not changed with vertical direction, larger explicit height, and distributeButtonSizes set to true", 400, this._group.getChildByName("one").height);
		}

		[Test]
		public function testDirectionSetToVerticalAndDistributeButtonSizesSetToTrueWithSmallerHeight():void
		{
			this._group.direction = Direction.VERTICAL;
			this._group.distributeButtonSizes = true;
			this._group.height = 400;
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup button height not changed with vertical direction, smaller explicit height, and distributeButtonSizes set to true", 100, this._group.getChildByName("one").height);
		}

		[Test]
		public function testDirectionSetToVerticalAndDistributeButtonSizesSetToFalseWithLargerHeight():void
		{
			var originalButtonHeight:Number = this._group.getChildByName("one").height;
			this._group.direction = Direction.VERTICAL;
			this._group.distributeButtonSizes = false;
			this._group.height = 1600;
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup button height not changed with vertical direction, larger explicit height, and distributeButtonSizes set to true", originalButtonHeight, this._group.getChildByName("one").height);
		}

		[Test]
		public function testDirectionSetToVerticalAndDistributeButtonSizesSetToFalseWithSmallerHeight():void
		{
			var originalButtonHeight:Number = this._group.getChildByName("one").height;
			this._group.direction = Direction.VERTICAL;
			this._group.distributeButtonSizes = false;
			this._group.height = 300;
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup button height not changed with vertical direction, smaller explicit height, and distributeButtonSizes set to true", originalButtonHeight, this._group.getChildByName("one").height);
		}

		[Test]
		public function testDirectionSetToHorizontalAndDistributeButtonSizesSetToTrueWithLargerWidth():void
		{
			this._group.direction = Direction.HORIZONTAL;
			this._group.distributeButtonSizes = true;
			this._group.width = 1600;
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup button width not changed with horizontal direction, larger explicit width, and distributeButtonSizes set to true", 400, this._group.getChildByName("one").width);
		}

		[Test]
		public function testDirectionSetToHorizontalAndDistributeButtonSizesSetToTrueWithSmallerWidth():void
		{
			this._group.direction = Direction.HORIZONTAL;
			this._group.distributeButtonSizes = true;
			this._group.width = 400;
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup button width not changed with horizontal direction, smaller explicit width, and distributeButtonSizes set to true", 100, this._group.getChildByName("one").width);
		}

		[Test]
		public function testDirectionSetToHorizontalAndDistributeButtonSizesSetToFalseWithLargerWidth():void
		{
			var originalButtonWidth:Number = this._group.getChildByName("one").width;
			this._group.direction = Direction.HORIZONTAL;
			this._group.distributeButtonSizes = false;
			this._group.width = 1600;
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup button width not changed with horizontal direction, larger explicit width, and distributeButtonSizes set to false", originalButtonWidth, this._group.getChildByName("one").width);
		}

		[Test]
		public function testButtonWidthAfterDirectionSetToHorizontalAndDistributeButtonSizesSetToFalseWithSmallerWidth():void
		{
			var button:DisplayObject = this._group.getChildByName("one");
			var originalButtonWidth:Number = button.width;
			var originalButtonHeight:Number = button.height;
			this._group.direction = Direction.HORIZONTAL;
			this._group.distributeButtonSizes = false;
			this._group.width = 300;
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup button width not changed with horizontal direction, smaller explicit width, and distributeButtonSizes set to false", originalButtonWidth, this._group.getChildByName("one").width);
			Assert.assertStrictlyEquals("ButtonGroup button not on new row with flow layout and small explicit width", originalButtonHeight, this._group.getChildByName("two").y);
		}

		[Test]
		public function testDisableAndReenable():void
		{
			this._group.isEnabled = false;
			this._group.validate();
			this._group.isEnabled = true;
			this._group.validate();
			var button1:Button = Button(this._group.getChildByName("one"));
			var button3:Button = Button(this._group.getChildByName("three"));
			var button4:Button = Button(this._group.getChildByName("four"));
			Assert.assertTrue("Button without isEnabled value in data provider is not enabled when ButtonGroup is disabled and then re-enabled", button1.isEnabled);
			Assert.assertTrue("Button with isEnabled value set to true in data provider is not enabled when ButtonGroup is disabled and then re-enabled", button3.isEnabled);
			Assert.assertFalse("Button with isEnabled value set to false in data provider is not disabled when ButtonGroup is disabled and then re-enabled", button4.isEnabled);
		}

		[Test]
		public function testDisable():void
		{
			this._group.isEnabled = false;
			this._group.validate();
			var button1:Button = Button(this._group.getChildByName("one"));
			var button3:Button = Button(this._group.getChildByName("three"));
			var button4:Button = Button(this._group.getChildByName("four"));
			Assert.assertFalse("Button without isEnabled value in data provider is incorrectly enabled when ButtonGroup is disabled", button1.isEnabled);
			Assert.assertFalse("Button with isEnabled value set to true in data provider is incorrectly enabled when ButtonGroup is disabled", button3.isEnabled);
			Assert.assertFalse("Button with isEnabled value set to false in data provider is incorrectly enabled when ButtonGroup is disabled", button4.isEnabled);
		}
	}
}
