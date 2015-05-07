package feathers.tests
{
	import feathers.core.PopUpManager;

	import org.flexunit.Assert;

	import starling.display.Quad;

	import starling.display.Sprite;

	public class PopUpManagerTests
	{
		[After]
		public function cleanup():void
		{
			TestFeathers.starlingRoot.removeChildren();
			PopUpManager.root = TestFeathers.starlingRoot.stage;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testCustomRoot():void
		{
			var customRoot:Sprite = new Sprite();
			TestFeathers.starlingRoot.addChild(customRoot);
			PopUpManager.root = customRoot;
			Assert.assertFalse("PopUpManager.root property incorrectly returns stage", PopUpManager.root === TestFeathers.starlingRoot.stage);
			
			var popUp:Quad = new Quad(200, 200, 0xff00ff);
			PopUpManager.addPopUp(popUp);

			Assert.assertStrictlyEquals("Pop-up added to wrong parent when a custom PopUpManager.root is set", customRoot, popUp.parent);
		}
	}
}
