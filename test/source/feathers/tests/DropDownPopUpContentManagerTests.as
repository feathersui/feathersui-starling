package feathers.tests
{
	import feathers.controls.popups.DropDownPopUpContentManager;
	import feathers.core.PopUpManager;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;

	public class DropDownPopUpContentManagerTests
	{
		private static const OVERLAY_NAME:String = "DropDownPopUpContentManagerOverlay";
		
		private var _popUp:DisplayObject;
		private var _customRoot:Sprite;
		private var _source:Quad;
		private var _popUpContentManager:DropDownPopUpContentManager;

		[Before]
		public function prepare():void
		{
			this._source = new Quad(200, 180, 0x00ff00);
			TestFeathers.starlingRoot.addChild(this._source);

			this._customRoot = new Sprite();
			TestFeathers.starlingRoot.addChild(this._customRoot);
			PopUpManager.root = this._customRoot;

			this._popUpContentManager = new DropDownPopUpContentManager();
			this._popUpContentManager.openCloseDuration = 0;
		}

		[After]
		public function cleanup():void
		{
			this._source.removeFromParent(true);
			this._source = null;

			this._customRoot.removeFromParent(true);
			this._customRoot = null;

			if(this._popUp)
			{
				this._popUp.removeFromParent(true);
				this._popUp = null;
			}

			PopUpManager.root = TestFeathers.starlingRoot.stage;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		private function createSimplePopUp():DisplayObject
		{
			var simplePopUp:Quad = new Quad(100, 150, 0xff00ff);
			return simplePopUp;
		}

		private function createOverlay():DisplayObject
		{
			var overlay:Quad = new Quad(1, 1, 0x000000);
			overlay.alpha = 0.5;
			overlay.name = OVERLAY_NAME;
			return overlay;
		}

		[Test]
		public function testOpen():void
		{
			this._popUp = this.createSimplePopUp();
			var openDispatched:Boolean = false;
			this._popUpContentManager.addEventListener(Event.OPEN, function(event:Event):void
			{
				openDispatched = true;
			});
			this._popUpContentManager.open(this._popUp, this._source);
			Assert.assertNotNull("DropDownPopUpContentManager content parent should not be null.", this._popUp.parent);
			Assert.assertTrue("DropDownPopUpContentManager did not dispatch Event.OPEN.", openDispatched);
		}

		[Test]
		public function testClose():void
		{
			this._popUp = this.createSimplePopUp();
			var closeDispatched:Boolean = false;
			this._popUpContentManager.addEventListener(Event.CLOSE, function(event:Event):void
			{
				closeDispatched = true;
			});
			this._popUpContentManager.open(this._popUp, this._source);
			this._popUpContentManager.close();
			Assert.assertNull("DropDownPopUpContentManager content parent should be null.", this._popUp.parent);
			Assert.assertTrue("DropDownPopUpContentManager did not dispatch Event.CLOSE.", closeDispatched);
		}

		[Test]
		public function testOverlayFactory():void
		{
			this._popUp = this.createSimplePopUp();
			this._popUpContentManager.isModal = true;
			this._popUpContentManager.overlayFactory = this.createOverlay;
			this._popUpContentManager.open(this._popUp, this._source);
			var overlay:DisplayObject = this._customRoot.getChildByName(OVERLAY_NAME);
			Assert.assertNotNull("DropDownPopUpContentManager overlayFactory result not found.", overlay);
		}
	}
}
