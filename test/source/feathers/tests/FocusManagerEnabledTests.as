package feathers.tests
{
	import feathers.core.FocusManager;

	import org.flexunit.Assert;

	import starling.display.Stage;

	public class FocusManagerEnabledTests
	{
		[After]
		public function cleanup():void
		{
			FocusManager.setEnabledForStage(TestFeathers.starlingRoot.stage, false);
		}

		[Test]
		public function testIsEnabledForStageWhenNotEnabled():void
		{
			var stage:Stage = TestFeathers.starlingRoot.stage;
			Assert.assertFalse("FocusManager incorrectly enabled for stage", FocusManager.isEnabledForStage(stage));
		}

		[Test]
		public function testIsEnabledForStageWhenEnabled():void
		{
			var stage:Stage = TestFeathers.starlingRoot.stage;
			FocusManager.setEnabledForStage(stage, true);
			Assert.assertTrue("FocusManager incorrectly disabled for stage", FocusManager.isEnabledForStage(stage));
		}

		[Test]
		public function testNotNullWhenEnabled():void
		{
			var stage:Stage = TestFeathers.starlingRoot.stage;
			FocusManager.setEnabledForStage(stage, true);
			Assert.assertNotNull("getFocusManagerForStage() incorrectly returns null when enabled", FocusManager.getFocusManagerForStage(stage));
		}
	}
}
