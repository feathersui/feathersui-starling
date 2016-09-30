package feathers.tests
{
	import feathers.controls.AutoSizeMode;
	import feathers.controls.LayoutGroup;
	import feathers.controls.ScrollContainer;
	import feathers.core.IFeathersControl;
	import feathers.core.PopUpManager;
	import feathers.tests.supportClasses.DisposeFlagQuad;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;

	public class PopUpManagerTests
	{
		private static const OVERLAY_NAME:String = "PopUpManagerOverlay";

		private var _popUp1:Quad;
		private var _popUp2:Quad;
		private var _feathersPopUp:IFeathersControl;
		private var _customRoot:Sprite;

		[After]
		public function cleanup():void
		{
			if(this._customRoot)
			{
				this._customRoot.removeFromParent(true);
				this._customRoot = null;
			}
			if(this._popUp1)
			{
				this._popUp1.removeFromParent(true);
				this._popUp1 = null;
			}
			if(this._popUp2)
			{
				this._popUp2.removeFromParent(true);
				this._popUp2 = null;
			}
			if(this._feathersPopUp)
			{
				this._feathersPopUp.removeFromParent(true);
				this._feathersPopUp = null;
			}

			PopUpManager.root = TestFeathers.starlingRoot.stage;

			PopUpManager.overlayFactory = PopUpManager.defaultOverlayFactory;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		private function createOverlay():DisplayObject
		{
			var overlay:Quad = new Quad(1, 1, 0xff00ff);
			overlay.alpha = 0.5;
			overlay.name = OVERLAY_NAME;
			return overlay;
		}

		[Test]
		public function testCustomRoot():void
		{
			this._customRoot = new Sprite();
			TestFeathers.starlingRoot.addChild(this._customRoot);
			PopUpManager.root = this._customRoot;
			Assert.assertFalse("PopUpManager.root property incorrectly returns stage", PopUpManager.root === TestFeathers.starlingRoot.stage);

			this._popUp1 = new Quad(200, 200, 0xff00ff);
			PopUpManager.addPopUp(this._popUp1);

			Assert.assertStrictlyEquals("Pop-up added to wrong parent when a custom PopUpManager.root is set", this._customRoot, this._popUp1.parent);
		}

		[Test]
		public function testOverlayFactory():void
		{
			PopUpManager.overlayFactory = this.createOverlay;

			this._popUp1 = new Quad(200, 200, 0xff00ff);
			PopUpManager.addPopUp(this._popUp1, true);

			var overlay:DisplayObject = PopUpManager.root.getChildByName(OVERLAY_NAME);
			Assert.assertNotNull("PopUpManager.overlayFactory failed to create overlay", overlay);
		}

		[Test]
		public function testIsPopUp():void
		{
			PopUpManager.overlayFactory = this.createOverlay;

			this._popUp1 = new Quad(200, 200, 0xff00ff);
			PopUpManager.addPopUp(this._popUp1, true);

			this._popUp2 = new Quad(200, 200, 0x00ff00);
			TestFeathers.starlingRoot.addChild(this._popUp2);

			Assert.assertTrue("PopUpManager.isPopUp() failed to identify a pop-up", PopUpManager.isPopUp(this._popUp1));
			Assert.assertFalse("PopUpManager.isPopUp() incorrectly identified a display object that is not a pop-up", PopUpManager.isPopUp(this._popUp2));
		}

		[Test]
		public function testIsTopLevelPopUpWithModal():void
		{
			this._popUp1 = new Quad(200, 200, 0xff00ff);
			PopUpManager.addPopUp(this._popUp1, true);

			Assert.assertTrue("PopUpManager.isTopLevelPopUp() failed to identify a top-level pop-up",
				PopUpManager.isTopLevelPopUp(this._popUp1));

			this._popUp2 = new Quad(200, 200, 0x00ff00);
			PopUpManager.addPopUp(this._popUp2, true);

			Assert.assertTrue("PopUpManager.isTopLevelPopUp() failed to identify a top-level pop-up",
				PopUpManager.isTopLevelPopUp(this._popUp2));

			Assert.assertFalse("PopUpManager.isTopLevelPopUp() incorrectly identified a top-level pop-up",
				PopUpManager.isTopLevelPopUp(this._popUp1));
		}

		[Test]
		public function testIsTopLevelPopUpWithoutModal():void
		{
			this._popUp1 = new Quad(200, 200, 0xff00ff);
			PopUpManager.addPopUp(this._popUp1, false);

			Assert.assertTrue("PopUpManager.isTopLevelPopUp() failed to identify a top-level pop-up",
				PopUpManager.isTopLevelPopUp(this._popUp1));
		}

		[Test]
		public function testIsTopLevelPopUpWithoutModalAfterModal():void
		{
			this._popUp1 = new Quad(200, 200, 0xff00ff);
			PopUpManager.addPopUp(this._popUp1, true);

			this._popUp2 = new Quad(200, 200, 0x00ff00);
			PopUpManager.addPopUp(this._popUp2, false);

			Assert.assertTrue("PopUpManager.isTopLevelPopUp() failed to identify a top-level pop-up",
				PopUpManager.isTopLevelPopUp(this._popUp1));

			Assert.assertTrue("PopUpManager.isTopLevelPopUp() failed to identify a top-level pop-up",
				PopUpManager.isTopLevelPopUp(this._popUp2));
		}

		[Test]
		public function testPopUpCount():void
		{
			Assert.assertStrictlyEquals("PopUpManager.popUpCount returned wrong value with no pop-ups",
				0, PopUpManager.popUpCount);

			this._popUp1 = new Quad(200, 200, 0xff00ff);
			PopUpManager.addPopUp(this._popUp1, true);

			Assert.assertStrictlyEquals("PopUpManager.popUpCount returned wrong value after adding first pop-up",
				1, PopUpManager.popUpCount);

			this._popUp2 = new Quad(200, 200, 0x00ff00);
			TestFeathers.starlingRoot.addChild(this._popUp2);

			Assert.assertStrictlyEquals("PopUpManager.popUpCount incorrectly identified a display object that is not a pop-up and returned wrong value",
				1, PopUpManager.popUpCount);

			this._feathersPopUp = new LayoutGroup();
			PopUpManager.addPopUp(DisplayObject(this._feathersPopUp));

			Assert.assertStrictlyEquals("PopUpManager.popUpCount returned wrong value after adding second pop-up",
				2, PopUpManager.popUpCount);

			PopUpManager.removePopUp(this._popUp1);

			Assert.assertStrictlyEquals("PopUpManager.popUpCount returned wrong value after removing pop-up",
				1, PopUpManager.popUpCount);
		}

		[Test]
		public function testRemoveAllPopUps():void
		{
			this._popUp1 = new DisposeFlagQuad();
			PopUpManager.addPopUp(this._popUp1, true);

			this._popUp2 = new DisposeFlagQuad();
			PopUpManager.addPopUp(this._popUp2, true);

			PopUpManager.removeAllPopUps(true);

			Assert.assertStrictlyEquals("PopUpManager.popUpCount incorrect after removeAllPopUps()",
				0, PopUpManager.popUpCount);

			Assert.assertTrue("Pop up not disposed after removeAllPopUps(true)",
				DisposeFlagQuad(this._popUp1).isDisposed);
			Assert.assertNull("Pop up parent not null after removeAllPopUps()",
				this._popUp1.parent);

			Assert.assertTrue("Pop up not disposed after removeAllPopUps(true)",
				DisposeFlagQuad(this._popUp2).isDisposed);
			Assert.assertNull("Pop up parent not null after removeAllPopUps()",
				this._popUp2.parent);
		}

		[Test]
		public function testRemovePopUpWithoutDispose():void
		{
			this._popUp1 = new DisposeFlagQuad();
			PopUpManager.addPopUp(this._popUp1, true);

			PopUpManager.removePopUp(this._popUp1, false);

			Assert.assertFalse("Pop up not disposed after removePopUp(false)",
				DisposeFlagQuad(this._popUp1).isDisposed);
			Assert.assertNull("Pop up parent not null after removePopUp(false)",
				this._popUp1.parent);
		}

		[Test]
		public function testRemovePopUpWithDispose():void
		{
			this._popUp1 = new DisposeFlagQuad();
			PopUpManager.addPopUp(this._popUp1, true);

			PopUpManager.removePopUp(this._popUp1, true);

			Assert.assertTrue("Pop up not disposed after removePopUp(true)",
				DisposeFlagQuad(this._popUp1).isDisposed);
			Assert.assertNull("Pop up parent not null after removePopUp(true)",
				this._popUp1.parent);
		}

		[Test]
		public function testCenterPopUp():void
		{
			var popUpWidth:Number = 200;
			var popUpHeight:Number = 150;
			this._popUp1 = new Quad(popUpWidth, popUpHeight, 0xff00ff);
			PopUpManager.addPopUp(this._popUp1, true, true);

			Assert.assertStrictlyEquals("PopUpManager failed to center pop-up horizontally",
				(TestFeathers.starlingRoot.stage.stageWidth - popUpWidth) / 2, this._popUp1.x);
			Assert.assertStrictlyEquals("PopUpManager failed to center pop-up vertically",
				(TestFeathers.starlingRoot.stage.stageHeight - popUpHeight) / 2, this._popUp1.y);
		}

		[Test]
		public function testCenterPopUpWithPivots():void
		{
			var popUpWidth:Number = 200;
			var popUpHeight:Number = 150;
			this._popUp1 = new Quad(popUpWidth, popUpHeight, 0xff00ff);
			this._popUp1.pivotX = popUpWidth / 2;
			this._popUp1.pivotY = popUpHeight / 2;
			PopUpManager.addPopUp(this._popUp1, true, true);

			Assert.assertStrictlyEquals("PopUpManager failed to center pop-up with pivot horizontally",
				TestFeathers.starlingRoot.stage.stageWidth / 2, this._popUp1.x);
			Assert.assertStrictlyEquals("PopUpManager failed to center pop-up with pivot vertically",
				TestFeathers.starlingRoot.stage.stageHeight / 2, this._popUp1.y);
		}

		[Test]
		public function testLayoutGroupAutoSizeModeStage():void
		{
			var group:LayoutGroup = new LayoutGroup();
			this._feathersPopUp = group;
			PopUpManager.addPopUp(group);
			Assert.assertStrictlyEquals("LayoutGroup added to PopUpManager should default to autoSizeMode === AutoSizeMode.CONTENT", AutoSizeMode.CONTENT, group.autoSizeMode);
		}

		[Test]
		public function testScrollContainerAutoSizeModeStage():void
		{
			var container:ScrollContainer = new ScrollContainer();
			this._feathersPopUp = container;
			PopUpManager.addPopUp(container);
			Assert.assertStrictlyEquals("ScrollContainer added to PopUpManager should default to autoSizeMode === AutoSizeMode.CONTENT", AutoSizeMode.CONTENT, container.autoSizeMode);
		}
	}
}
