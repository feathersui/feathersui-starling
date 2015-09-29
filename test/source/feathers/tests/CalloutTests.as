package feathers.tests
{
	import feathers.controls.Callout;
	import feathers.tests.supportClasses.DisposeFlagQuad;

	import flash.geom.Point;

	import org.flexunit.Assert;
	import org.flexunit.async.Async;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Stage;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class CalloutTests
	{
		private var _callout:Callout;
		private var _origin:Quad;

		[Before]
		public function prepare():void
		{
			this._origin = new Quad(100, 100, 0xff00ff);
			this._origin.x = 100;
			this._origin.y = 100;
			TestFeathers.starlingRoot.addChild(this._origin);
		}

		[After]
		public function cleanup():void
		{
			this._callout.removeFromParent(true);
			if(this._callout.content)
			{
				this._callout.content.dispose();
			}
			this._callout = null;
			
			this._origin.removeFromParent(true);
			this._origin = null;
			
			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
			Assert.assertStrictlyEquals("Child not removed from Starling stage on cleanup.", 1, TestFeathers.starlingRoot.stage.numChildren);
		}

		[Test(async)]
		public function testCloseOnTouchBeganOutside():void
		{
			this._callout = Callout.show(new Quad(100, 100, 0xffff00), this._origin);
			this._callout.closeOnTouchBeganOutside = true;
			var stage:Stage = this._callout.stage;
			Async.delayCall(this, function():void
			{
				var position:Point = new Point(stage.stageWidth - 1, stage.stageHeight - 1);
				var target:DisplayObject = stage.hitTest(position, true);
				var touch:Touch = new Touch(0);
				touch.target = target;
				touch.phase = TouchPhase.BEGAN;
				touch.globalX = position.x;
				touch.globalY = position.y;
				var touches:Vector.<Touch> = new <Touch>[touch];
				target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
				
				Assert.assertNull("Callout not removed from parent on TouchPhase.BEGAN", _callout.parent);
			}, 1);
		}

		[Test(async)]
		public function testCloseOnTouchEndedOutside():void
		{
			this._callout = Callout.show(new Quad(100, 100, 0xff00ff), this._origin);
			//this._callout.closeOnTouchBeganOutside = false;
			this._callout.closeOnTouchEndedOutside = true;
			var stage:Stage = this._callout.stage;
			Async.delayCall(this, function():void
			{
				var position:Point = new Point(stage.stageWidth - 1, stage.stageHeight - 1);
				var target:DisplayObject = stage.hitTest(position, true);
				var touch:Touch = new Touch(0);
				touch.target = target;
				touch.phase = TouchPhase.BEGAN;
				touch.globalX = position.x;
				touch.globalY = position.y;
				var touches:Vector.<Touch> = new <Touch>[touch];
				target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
				touch.phase = TouchPhase.ENDED;
				target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
				Assert.assertNull("Callout not removed from parent on TouchPhase.ENDED", _callout.parent);
			}, 1);
		}

		[Test]
		public function testDisposeContentSetToTrue():void
		{
			var content:DisposeFlagQuad = new DisposeFlagQuad();
			this._callout = Callout.show(content, this._origin);
			this._callout.disposeContent = true;
			this._callout.removeFromParent(true);
			Assert.assertTrue("Callout content not disposed when disposeContent is true", content.isDisposed);
		}

		[Test]
		public function testDisposeContentSetToFalse():void
		{
			var content:DisposeFlagQuad = new DisposeFlagQuad();
			this._callout = Callout.show(content, this._origin);
			this._callout.disposeContent = false;
			this._callout.removeFromParent(true);
			Assert.assertFalse("Callout content incorrectly disposed when disposeContent is false", content.isDisposed);
		}

		[Test(async)]
		public function testDisposeOnSelfCloseSetToTrue():void
		{
			var content:DisposeFlagQuad = new DisposeFlagQuad();
			this._callout = Callout.show(content, this._origin);
			this._callout.disposeContent = true;
			this._callout.disposeOnSelfClose = true;
			this._callout.closeOnTouchBeganOutside = true;
			var stage:Stage = this._callout.stage;
			Async.delayCall(this, function():void
			{
				var position:Point = new Point(stage.stageWidth - 1, stage.stageHeight - 1);
				var target:DisplayObject = stage.hitTest(position, true);
				var touch:Touch = new Touch(0);
				touch.target = target;
				touch.phase = TouchPhase.BEGAN;
				touch.globalX = position.x;
				touch.globalY = position.y;
				var touches:Vector.<Touch> = new <Touch>[touch];
				target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
				
				Assert.assertTrue("Callout content not disposed when closed and disposeOnSelfClose is true", content.isDisposed);
			}, 1);
		}

		[Test(async)]
		public function testDisposeOnSelfCloseSetToFalse():void
		{
			var content:DisposeFlagQuad = new DisposeFlagQuad();
			this._callout = Callout.show(content, this._origin);
			this._callout.disposeContent = true;
			this._callout.disposeOnSelfClose = false;
			this._callout.closeOnTouchBeganOutside = true;
			var stage:Stage = this._callout.stage;
			Async.delayCall(this, function():void
			{
				var position:Point = new Point(stage.stageWidth - 1, stage.stageHeight - 1);
				var target:DisplayObject = stage.hitTest(position, true);
				var touch:Touch = new Touch(0);
				touch.target = target;
				touch.phase = TouchPhase.BEGAN;
				touch.globalX = position.x;
				touch.globalY = position.y;
				var touches:Vector.<Touch> = new <Touch>[touch];
				target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
				
				Assert.assertFalse("Callout content not disposed when closed and disposeOnSelfClose is true", content.isDisposed);
			}, 1);
		}
	}
}