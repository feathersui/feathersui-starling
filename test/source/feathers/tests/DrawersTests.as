package feathers.tests
{
	import feathers.controls.Drawers;
	import feathers.controls.LayoutGroup;

	import org.flexunit.Assert;
	import org.flexunit.async.Async;

	import starling.display.Quad;
	import starling.events.Event;

	public class DrawersTests
	{
		private static const OVERLAY_ALPHA:Number = 0.45;
		
		private var _drawers:Drawers;
		private var _overlay:Quad;
		private var _content:LayoutGroup;
		private var _drawer1:LayoutGroup;

		[Before]
		public function prepare():void
		{
			this._content = new LayoutGroup();
			this._content.backgroundSkin = new Quad(200, 150, 0xff00ff);
			
			this._overlay = new Quad(1, 1, 0x000000);
			this._overlay.alpha = OVERLAY_ALPHA;
			
			this._drawer1 = new LayoutGroup();
			this._drawer1.backgroundSkin = new Quad(125, 100, 0xff0000);
			
			this._drawers = new Drawers(this._content);
			this._drawers.overlaySkin = this._overlay;
			TestFeathers.starlingRoot.addChild(this._drawers);
			this._drawers.validate();
		}

		[After]
		public function cleanup():void
		{
			this._drawers.removeFromParent(true);
			this._drawers = null;
			
			this._overlay = null;
			this._content = null;
			this._drawer1 = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testTopDrawerOpen():void
		{
			this._drawers.topDrawer = this._drawer1;
			this._drawers.isTopDrawerOpen = true;
			this._drawers.validate();

			Assert.assertNotNull("Drawers topDrawer.parent is incorrectly null when isTopDrawerOpen set to true", this._drawer1.parent);
			Assert.assertTrue("Drawers topDrawer.visible is incorrectly false when isTopDrawerOpen set to true", this._drawer1.visible);
			Assert.assertNotNull("Drawers overlaySkin.parent is incorrectly null when isTopDrawerOpen set to true", this._overlay.parent);
			Assert.assertTrue("Drawers overlaySkin.visible is incorrectly false when isTopDrawerOpen set to true", this._overlay.visible);
			Assert.assertStrictlyEquals("Drawers overlaySkin.alpha has incorrect value when isTopDrawerOpen set to true",
				OVERLAY_ALPHA, this._overlay.alpha);
		}

		[Test]
		public function testRightDrawerOpenShowsOverlay():void
		{
			this._drawers.rightDrawer = this._drawer1;
			this._drawers.isRightDrawerOpen = true;
			this._drawers.validate();

			Assert.assertNotNull("Drawers rightDrawer.parent is incorrectly null when isRightDrawerOpen set to true", this._drawer1.parent);
			Assert.assertTrue("Drawers rightDrawer.visible is incorrectly false when isRightDrawerOpen set to true", this._drawer1.visible);
			Assert.assertNotNull("Drawers overlaySkin.parent is incorrectly null when isRightDrawerOpen set to true", this._overlay.parent);
			Assert.assertTrue("Drawers overlaySkin.visible is incorrectly false when isRightDrawerOpen set to true", this._overlay.visible);
			Assert.assertStrictlyEquals("Drawers overlaySkin.alpha has incorrect value when isRightDrawerOpen set to true",
				OVERLAY_ALPHA, this._overlay.alpha);
		}

		[Test]
		public function testBottomDrawerOpen():void
		{
			this._drawers.bottomDrawer = this._drawer1;
			this._drawers.isBottomDrawerOpen = true;
			this._drawers.validate();

			Assert.assertNotNull("Drawers bottomDrawer.parent is incorrectly null when isBottomDrawerOpen set to true", this._drawer1.parent);
			Assert.assertTrue("Drawers bottomDrawer.visible is incorrectly false when isBottomDrawerOpen set to true", this._drawer1.visible);
			Assert.assertNotNull("Drawers overlaySkin.parent is incorrectly null when isBottomDrawerOpen set to true", this._overlay.parent);
			Assert.assertTrue("Drawers overlaySkin.visible is incorrectly false when isBottomDrawerOpen set to true", this._overlay.visible);
			Assert.assertStrictlyEquals("Drawers overlaySkin.alpha has incorrect value when isBottomDrawerOpen set to true",
				OVERLAY_ALPHA, this._overlay.alpha);
		}

		[Test]
		public function testLeftDrawerOpen():void
		{
			this._drawers.leftDrawer = this._drawer1;
			this._drawers.isLeftDrawerOpen = true;
			this._drawers.validate();

			Assert.assertNotNull("Drawers leftDrawer.parent is incorrectly null when isLeftDrawerOpen set to true", this._drawer1.parent);
			Assert.assertTrue("Drawers leftDrawer.visible is incorrectly false when isLeftDrawerOpen set to true", this._drawer1.visible);
			Assert.assertNotNull("Drawers overlaySkin.parent is incorrectly null when isLeftDrawerOpen set to true", this._overlay.parent);
			Assert.assertTrue("Drawers overlaySkin.visible is incorrectly false when isLeftDrawerOpen set to true", this._overlay.visible);
			Assert.assertStrictlyEquals("Drawers overlaySkin.alpha has incorrect value when isLeftDrawerOpen set to true",
				OVERLAY_ALPHA, this._overlay.alpha);
		}

		[Test]
		public function testSetTopDrawerToNullWhileOpen():void
		{
			this._drawers.topDrawer = this._drawer1;
			this._drawers.isTopDrawerOpen = true;
			this._drawers.validate();
			this._drawers.topDrawer = null;
			this._drawers.validate();

			Assert.assertNull("Drawers topDrawer.parent is incorrectly non-null when topDrawer is set to null", this._drawer1.parent);
			Assert.assertFalse("Drawers overlaySkin.visible is incorrectly true when topDrawer set to null while open", this._overlay.visible);
		}

		[Test]
		public function testSetRightDrawerToNullWhileOpen():void
		{
			this._drawers.rightDrawer = this._drawer1;
			this._drawers.isRightDrawerOpen = true;
			this._drawers.validate();
			this._drawers.rightDrawer = null;
			this._drawers.validate();

			Assert.assertNull("Drawers rightDrawer.parent is incorrectly non-null when rightDrawer is set to null", this._drawer1.parent);
			Assert.assertFalse("Drawers overlaySkin.visible is incorrectly true when rightDrawer set to null while open", this._overlay.visible);
		}

		[Test]
		public function testSetBottomDrawerToNullWhileOpen():void
		{
			this._drawers.bottomDrawer = this._drawer1;
			this._drawers.isBottomDrawerOpen = true;
			this._drawers.validate();
			this._drawers.bottomDrawer = null;
			this._drawers.validate();

			Assert.assertNull("Drawers bottomDrawer.parent is incorrectly non-null when bottomDrawer is set to null", this._drawer1.parent);
			Assert.assertFalse("Drawers overlaySkin.visible is incorrectly true when bottomDrawer set to null while open", this._overlay.visible);
		}

		[Test]
		public function testSetLeftDrawerToNullWhileOpen():void
		{
			this._drawers.leftDrawer = this._drawer1;
			this._drawers.isLeftDrawerOpen = true;
			this._drawers.validate();
			this._drawers.leftDrawer = null;
			this._drawers.validate();

			Assert.assertNull("Drawers leftDrawer.parent is incorrectly non-null when leftDrawer is set to null", this._drawer1.parent);
			Assert.assertFalse("Drawers overlaySkin.visible is incorrectly true when leftDrawer set to null while open", this._overlay.visible);
		}

		[Test(async)]
		public function testToggleTopDrawerOpen():void
		{
			var hasDispatchedOpenEvent:Boolean = false;
			this._drawers.topDrawer = this._drawer1;
			this._drawers.addEventListener(Event.OPEN, function(event:Event):void
			{
				hasDispatchedOpenEvent = true;
			});
			this._drawers.toggleTopDrawer(0.2);
			this._drawers.validate();
			Assert.assertFalse("Drawers Event.OPEN was incorrectly dispatched before the animation completed", hasDispatchedOpenEvent);
			var drawers:Drawers = this._drawers;
			Async.delayCall(this, function():void
			{
				Assert.assertTrue("Drawers Event.OPEN was not dispatched after toggleTopDrawer()", hasDispatchedOpenEvent);
				Assert.assertTrue("Drawers isTopDrawerOpen is incorrectly false after toggleTopDrawer()", drawers.isTopDrawerOpen);
			}, 300);
		}

		[Test(async)]
		public function testToggleTopDrawerClose():void
		{
			var hasDispatchedCloseEvent:Boolean = false;
			this._drawers.topDrawer = this._drawer1;
			this._drawers.addEventListener(Event.CLOSE, function(event:Event):void
			{
				hasDispatchedCloseEvent = true;
			});
			this._drawers.isTopDrawerOpen = true;
			this._drawers.validate();
			this._drawers.toggleTopDrawer(0.2);
			this._drawers.validate();
			Assert.assertFalse("Drawers Event.CLOSE was incorrectly dispatched before the animation completed", hasDispatchedCloseEvent);
			var drawers:Drawers = this._drawers;
			Async.delayCall(this, function():void
			{
				Assert.assertTrue("Drawers Event.CLOSE was not dispatched after toggleTopDrawer()", hasDispatchedCloseEvent);
				Assert.assertFalse("Drawers isTopDrawerOpen is incorrectly true after toggleTopDrawer()", drawers.isTopDrawerOpen);
			}, 300);
		}

		[Test(async)]
		public function testToggleRightDrawerOpen():void
		{
			var hasDispatchedOpenEvent:Boolean = false;
			this._drawers.rightDrawer = this._drawer1;
			this._drawers.addEventListener(Event.OPEN, function(event:Event):void
			{
				hasDispatchedOpenEvent = true;
			});
			this._drawers.toggleRightDrawer(0.2);
			this._drawers.validate();
			Assert.assertFalse("Drawers Event.OPEN was incorrectly dispatched before the animation completed", hasDispatchedOpenEvent);
			var drawers:Drawers = this._drawers;
			Async.delayCall(this, function():void
			{
				Assert.assertTrue("Drawers Event.OPEN was not dispatched after toggleRightDrawer()", hasDispatchedOpenEvent);
				Assert.assertTrue("Drawers isRightDrawerOpen is incorrectly false after toggleRightDrawer()", drawers.isRightDrawerOpen);
			}, 300);
		}

		[Test(async)]
		public function testToggleRightDrawerClose():void
		{
			var hasDispatchedCloseEvent:Boolean = false;
			this._drawers.rightDrawer = this._drawer1;
			this._drawers.addEventListener(Event.CLOSE, function(event:Event):void
			{
				hasDispatchedCloseEvent = true;
			});
			this._drawers.isRightDrawerOpen = true;
			this._drawers.validate();
			this._drawers.toggleRightDrawer(0.2);
			this._drawers.validate();
			Assert.assertFalse("Drawers Event.CLOSE was incorrectly dispatched before the animation completed", hasDispatchedCloseEvent);
			var drawers:Drawers = this._drawers;
			Async.delayCall(this, function():void
			{
				Assert.assertTrue("Drawers Event.CLOSE was not dispatched after toggleRightDrawer()", hasDispatchedCloseEvent);
				Assert.assertFalse("Drawers isRightDrawerOpen is incorrectly true after toggleRightDrawer()", drawers.isRightDrawerOpen);
			}, 300);
		}

		[Test(async)]
		public function testToggleBottomDrawerOpen():void
		{
			var hasDispatchedOpenEvent:Boolean = false;
			this._drawers.bottomDrawer = this._drawer1;
			this._drawers.addEventListener(Event.OPEN, function(event:Event):void
			{
				hasDispatchedOpenEvent = true;
			});
			this._drawers.toggleBottomDrawer(0.2);
			this._drawers.validate();
			Assert.assertFalse("Drawers Event.OPEN was incorrectly dispatched before the animation completed", hasDispatchedOpenEvent);
			var drawers:Drawers = this._drawers;
			Async.delayCall(this, function():void
			{
				Assert.assertTrue("Drawers Event.OPEN was not dispatched after toggleBottomDrawer()", hasDispatchedOpenEvent);
				Assert.assertTrue("Drawers isBottomDrawerOpen is incorrectly false after toggleBottomDrawer()", drawers.isBottomDrawerOpen);
			}, 300);
		}

		[Test(async)]
		public function testToggleBottomDrawerClose():void
		{
			var hasDispatchedCloseEvent:Boolean = false;
			this._drawers.bottomDrawer = this._drawer1;
			this._drawers.addEventListener(Event.CLOSE, function(event:Event):void
			{
				hasDispatchedCloseEvent = true;
			});
			this._drawers.isBottomDrawerOpen = true;
			this._drawers.validate();
			this._drawers.toggleBottomDrawer(0.2);
			this._drawers.validate();
			Assert.assertFalse("Drawers Event.CLOSE was incorrectly dispatched before the animation completed", hasDispatchedCloseEvent);
			var drawers:Drawers = this._drawers;
			Async.delayCall(this, function():void
			{
				Assert.assertTrue("Drawers Event.CLOSE was not dispatched after toggleBottomDrawer()", hasDispatchedCloseEvent);
				Assert.assertFalse("Drawers isBottomDrawerOpen is incorrectly true after toggleBottomDrawer()", drawers.isBottomDrawerOpen);
			}, 300);
		}

		[Test(async)]
		public function testToggleLeftDrawerOpen():void
		{
			var hasDispatchedOpenEvent:Boolean = false;
			this._drawers.leftDrawer = this._drawer1;
			this._drawers.addEventListener(Event.OPEN, function(event:Event):void
			{
				hasDispatchedOpenEvent = true;
			});
			this._drawers.toggleLeftDrawer(0.2);
			this._drawers.validate();
			Assert.assertFalse("Drawers Event.OPEN was incorrectly dispatched before the animation completed", hasDispatchedOpenEvent);
			var drawers:Drawers = this._drawers;
			Async.delayCall(this, function():void
			{
				Assert.assertTrue("Drawers Event.OPEN was not dispatched after toggleLeftDrawer()", hasDispatchedOpenEvent);
				Assert.assertTrue("Drawers isLeftDrawerOpen is incorrectly false after toggleLeftDrawer()", drawers.isLeftDrawerOpen);
			}, 300);
		}

		[Test(async)]
		public function testToggleLeftDrawerClose():void
		{
			var hasDispatchedCloseEvent:Boolean = false;
			this._drawers.leftDrawer = this._drawer1;
			this._drawers.addEventListener(Event.CLOSE, function(event:Event):void
			{
				hasDispatchedCloseEvent = true;
			});
			this._drawers.isLeftDrawerOpen = true;
			this._drawers.validate();
			this._drawers.toggleLeftDrawer(0.2);
			this._drawers.validate();
			Assert.assertFalse("Drawers Event.CLOSE was incorrectly dispatched before the animation completed", hasDispatchedCloseEvent);
			var drawers:Drawers = this._drawers;
			Async.delayCall(this, function():void
			{
				Assert.assertTrue("Drawers Event.CLOSE was not dispatched after toggleLeftDrawer()", hasDispatchedCloseEvent);
				Assert.assertFalse("Drawers isLeftDrawerOpen is incorrectly true after toggleLeftDrawer()", drawers.isLeftDrawerOpen);
			}, 300);
		}
	}
}
