package feathers.tests
{
	import feathers.controls.Button;
	import feathers.controls.NumericStepper;
	import feathers.controls.StepperButtonLayoutMode;
	import feathers.controls.TextInput;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class NumericStepperMeasurementTests
	{
		private static const TEXT_INPUT_GAP:Number = 8;
		private static const BUTTON_GAP:Number = 3;
		private static const LARGER_SIZE:Number = 300;
		private static const LARGER_SIZE2:Number = 250;
		private static const SMALLER_SIZE:Number = 100;
		private static const SMALLER_SIZE2:Number = 90;
		
		private var _stepper:NumericStepper;

		[Before]
		public function prepare():void
		{
			this._stepper = new NumericStepper();
			TestFeathers.starlingRoot.addChild(this._stepper);
		}

		[After]
		public function cleanup():void
		{
			this._stepper.removeFromParent(true);
			this._stepper = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testAutoSizeWidthWithButtonLayoutModeRightSideVertical():void
		{
			this._stepper.buttonLayoutMode = StepperButtonLayoutMode.RIGHT_SIDE_VERTICAL;
			this._stepper.textInputGap = TEXT_INPUT_GAP;
			this._stepper.buttonGap = BUTTON_GAP;
			this._stepper.textInputFactory = function():TextInput
			{
				var input:TextInput = new TextInput();
				input.backgroundSkin = new Quad(LARGER_SIZE, 1, 0xff00ff);
				return input;
			};
			this._stepper.incrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(SMALLER_SIZE, 1, 0xffff00);
				return button;
			};
			this._stepper.decrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(SMALLER_SIZE2, 1, 0x00ffff);
				return button;
			};
			this._stepper.validate();
			Assert.assertStrictlyEquals("The width of the NumericStepper was not calculated correctly with buttonLayoutMode set to right side vertical.",
				LARGER_SIZE + SMALLER_SIZE + TEXT_INPUT_GAP, this._stepper.width);
		}

		[Test]
		public function testAutoSizeHeightWithButtonLayoutModeRightSideVerticalAndLargerTextInput():void
		{
			this._stepper.buttonLayoutMode = StepperButtonLayoutMode.RIGHT_SIDE_VERTICAL;
			this._stepper.textInputGap = TEXT_INPUT_GAP;
			this._stepper.buttonGap = BUTTON_GAP;
			this._stepper.textInputFactory = function():TextInput
			{
				var input:TextInput = new TextInput();
				input.backgroundSkin = new Quad(1, LARGER_SIZE, 0xff00ff);
				return input;
			};
			this._stepper.incrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, SMALLER_SIZE, 0xffff00);
				return button;
			};
			this._stepper.decrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, SMALLER_SIZE2, 0x00ffff);
				return button;
			};
			this._stepper.validate();
			Assert.assertStrictlyEquals("The height of the NumericStepper was not calculated correctly with buttonLayoutMode set to right side vertical and a larger text input.",
				LARGER_SIZE, this._stepper.height);
		}

		[Test]
		public function testAutoSizeHeightWithButtonLayoutModeRightSideVerticalAndSmallerTextInput():void
		{
			this._stepper.buttonLayoutMode = StepperButtonLayoutMode.RIGHT_SIDE_VERTICAL;
			this._stepper.textInputGap = TEXT_INPUT_GAP;
			this._stepper.buttonGap = BUTTON_GAP;
			this._stepper.textInputFactory = function():TextInput
			{
				var input:TextInput = new TextInput();
				input.backgroundSkin = new Quad(1, SMALLER_SIZE, 0xff00ff);
				return input;
			};
			this._stepper.incrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, LARGER_SIZE, 0xffff00);
				return button;
			};
			this._stepper.decrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, SMALLER_SIZE2, 0x00ffff);
				return button;
			};
			this._stepper.validate();
			Assert.assertStrictlyEquals("The height of the NumericStepper was not calculated correctly with buttonLayoutMode set to right side vertical and a smaller text input.",
				LARGER_SIZE + SMALLER_SIZE2 + BUTTON_GAP, this._stepper.height);
		}

		[Test]
		public function testAutoSizeMinWidthWithButtonLayoutModeRightSideVertical():void
		{
			this._stepper.buttonLayoutMode = StepperButtonLayoutMode.RIGHT_SIDE_VERTICAL;
			this._stepper.textInputGap = TEXT_INPUT_GAP;
			this._stepper.buttonGap = BUTTON_GAP;
			this._stepper.textInputFactory = function():TextInput
			{
				var input:TextInput = new TextInput();
				input.backgroundSkin = new Quad(1, 1, 0xff00ff);
				input.minWidth = LARGER_SIZE;
				return input;
			};
			this._stepper.incrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, 1, 0xffff00);
				button.minWidth = SMALLER_SIZE;
				return button;
			};
			this._stepper.decrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, 1, 0x00ffff);
				button.minWidth = SMALLER_SIZE2;
				return button;
			};
			this._stepper.validate();
			Assert.assertStrictlyEquals("The minWidth of the NumericStepper was not calculated correctly with buttonLayoutMode set to right side vertical.",
				LARGER_SIZE + SMALLER_SIZE + TEXT_INPUT_GAP, this._stepper.minWidth);
		}

		[Test]
		public function testAutoSizeMinHeightWithButtonLayoutModeRightSideVerticalAndLargerTextInput():void
		{
			this._stepper.buttonLayoutMode = StepperButtonLayoutMode.RIGHT_SIDE_VERTICAL;
			this._stepper.textInputGap = TEXT_INPUT_GAP;
			this._stepper.buttonGap = BUTTON_GAP;
			this._stepper.textInputFactory = function():TextInput
			{
				var input:TextInput = new TextInput();
				input.backgroundSkin = new Quad(1, 1, 0xff00ff);
				input.minHeight = LARGER_SIZE;
				return input;
			};
			this._stepper.incrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, 1, 0xffff00);
				button.minHeight = SMALLER_SIZE;
				return button;
			};
			this._stepper.decrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, 1, 0x00ffff);
				button.minHeight = SMALLER_SIZE2;
				return button;
			};
			this._stepper.validate();
			Assert.assertStrictlyEquals("The minHeight of the NumericStepper was not calculated correctly with buttonLayoutMode set to right side vertical and a larger text input.",
				LARGER_SIZE, this._stepper.minHeight);
		}

		[Test]
		public function testAutoSizeMinHeightWithButtonLayoutModeRightSideVerticalAndSmallerTextInput():void
		{
			this._stepper.buttonLayoutMode = StepperButtonLayoutMode.RIGHT_SIDE_VERTICAL;
			this._stepper.textInputGap = TEXT_INPUT_GAP;
			this._stepper.buttonGap = BUTTON_GAP;
			this._stepper.textInputFactory = function():TextInput
			{
				var input:TextInput = new TextInput();
				input.backgroundSkin = new Quad(1, 1, 0xff00ff);
				input.minHeight = SMALLER_SIZE;
				return input;
			};
			this._stepper.incrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, 1, 0xffff00);
				button.minHeight = LARGER_SIZE;
				return button;
			};
			this._stepper.decrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, 1, 0x00ffff);
				button.minHeight = SMALLER_SIZE2;
				return button;
			};
			this._stepper.validate();
			Assert.assertStrictlyEquals("The minWidth of the NumericStepper was not calculated correctly with buttonLayoutMode set to right side vertical and a smaller text input.",
				LARGER_SIZE + SMALLER_SIZE2 + BUTTON_GAP, this._stepper.minHeight);
		}

		[Test]
		public function testAutoSizeWidthWithButtonLayoutModeSplitVerticalAndLargerTextInput():void
		{
			this._stepper.buttonLayoutMode = StepperButtonLayoutMode.SPLIT_VERTICAL;
			this._stepper.textInputGap = TEXT_INPUT_GAP;
			this._stepper.textInputFactory = function():TextInput
			{
				var input:TextInput = new TextInput();
				input.backgroundSkin = new Quad(LARGER_SIZE, 1, 0xff00ff);
				return input;
			};
			this._stepper.incrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(SMALLER_SIZE, 1, 0xffff00);
				return button;
			};
			this._stepper.decrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(SMALLER_SIZE2, 1, 0x00ffff);
				return button;
			};
			this._stepper.validate();
			Assert.assertStrictlyEquals("The width of the NumericStepper was not calculated correctly with buttonLayoutMode set to split vertical and a larger text input.",
				LARGER_SIZE, this._stepper.width);
		}

		[Test]
		public function testAutoSizeWidthWithButtonLayoutModeSplitVerticalAndSmallerTextInput():void
		{
			this._stepper.buttonLayoutMode = StepperButtonLayoutMode.SPLIT_VERTICAL;
			this._stepper.textInputGap = TEXT_INPUT_GAP;
			this._stepper.textInputFactory = function():TextInput
			{
				var input:TextInput = new TextInput();
				input.backgroundSkin = new Quad(SMALLER_SIZE, 1, 0xff00ff);
				return input;
			};
			this._stepper.incrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(LARGER_SIZE, 1, 0xffff00);
				return button;
			};
			this._stepper.decrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(LARGER_SIZE2, 1, 0x00ffff);
				return button;
			};
			this._stepper.validate();
			Assert.assertStrictlyEquals("The width of the NumericStepper was not calculated correctly with buttonLayoutMode set to split vertical and a smaller text input.",
				LARGER_SIZE, this._stepper.width);
		}

		[Test]
		public function testAutoSizeHeightWithButtonLayoutModeSplitVertical():void
		{
			this._stepper.buttonLayoutMode = StepperButtonLayoutMode.SPLIT_VERTICAL;
			this._stepper.textInputGap = TEXT_INPUT_GAP;
			this._stepper.textInputFactory = function():TextInput
			{
				var input:TextInput = new TextInput();
				input.backgroundSkin = new Quad(1, LARGER_SIZE, 0xff00ff);
				return input;
			};
			this._stepper.incrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, SMALLER_SIZE, 0xffff00);
				return button;
			};
			this._stepper.decrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, SMALLER_SIZE2, 0x00ffff);
				return button;
			};
			this._stepper.validate();
			Assert.assertStrictlyEquals("The height of the NumericStepper was not calculated correctly with buttonLayoutMode set to split vertical.",
				SMALLER_SIZE + SMALLER_SIZE2 + LARGER_SIZE + TEXT_INPUT_GAP * 2, this._stepper.height);
		}

		[Test]
		public function testAutoSizeMinWidthWithButtonLayoutModeSplitVerticalAndLargerTextInput():void
		{
			this._stepper.buttonLayoutMode = StepperButtonLayoutMode.SPLIT_VERTICAL;
			this._stepper.textInputGap = TEXT_INPUT_GAP;
			this._stepper.textInputFactory = function():TextInput
			{
				var input:TextInput = new TextInput();
				input.backgroundSkin = new Quad(1, 1, 0xff00ff);
				input.minWidth = LARGER_SIZE;
				return input;
			};
			this._stepper.incrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, 1, 0xffff00);
				button.minWidth = SMALLER_SIZE;
				return button;
			};
			this._stepper.decrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, 1, 0x00ffff);
				button.minWidth = SMALLER_SIZE2;
				return button;
			};
			this._stepper.validate();
			Assert.assertStrictlyEquals("The minWidth of the NumericStepper was not calculated correctly with buttonLayoutMode set to split vertical and a larger text input.",
				LARGER_SIZE, this._stepper.minWidth);
		}

		[Test]
		public function testAutoSizeMinWidthWithButtonLayoutModeSplitVerticalAndSmallerTextInput():void
		{
			this._stepper.buttonLayoutMode = StepperButtonLayoutMode.SPLIT_VERTICAL;
			this._stepper.textInputGap = TEXT_INPUT_GAP;
			this._stepper.textInputFactory = function():TextInput
			{
				var input:TextInput = new TextInput();
				input.backgroundSkin = new Quad(1, 1, 0xff00ff);
				input.minWidth = SMALLER_SIZE;
				return input;
			};
			this._stepper.incrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, 1, 0xffff00);
				button.minWidth = LARGER_SIZE;
				return button;
			};
			this._stepper.decrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, 1, 0x00ffff);
				button.minWidth = LARGER_SIZE;
				return button;
			};
			this._stepper.validate();
			Assert.assertStrictlyEquals("The minWidth of the NumericStepper was not calculated correctly with buttonLayoutMode set to split vertical and a smaller text input.",
				LARGER_SIZE, this._stepper.minWidth);
		}

		[Test]
		public function testAutoSizeMinHeightWithButtonLayoutModeSplitVertical():void
		{
			this._stepper.buttonLayoutMode = StepperButtonLayoutMode.SPLIT_VERTICAL;
			this._stepper.textInputGap = TEXT_INPUT_GAP;
			this._stepper.textInputFactory = function():TextInput
			{
				var input:TextInput = new TextInput();
				input.backgroundSkin = new Quad(1, 1, 0xff00ff);
				input.minHeight = LARGER_SIZE;
				return input;
			};
			this._stepper.incrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, 1, 0xffff00);
				button.minHeight = SMALLER_SIZE;
				return button;
			};
			this._stepper.decrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, 1, 0x00ffff);
				button.minHeight = SMALLER_SIZE2;
				return button;
			};
			this._stepper.validate();
			Assert.assertStrictlyEquals("The minHeight of the NumericStepper was not calculated correctly with buttonLayoutMode set to split vertical.",
				SMALLER_SIZE + SMALLER_SIZE2 + LARGER_SIZE + TEXT_INPUT_GAP * 2, this._stepper.minHeight);
		}

		[Test]
		public function testAutoSizeWidthWithButtonLayoutModeSplitHorizontal():void
		{
			this._stepper.buttonLayoutMode = StepperButtonLayoutMode.SPLIT_HORIZONTAL;
			this._stepper.textInputGap = TEXT_INPUT_GAP;
			this._stepper.textInputFactory = function():TextInput
			{
				var input:TextInput = new TextInput();
				input.backgroundSkin = new Quad(LARGER_SIZE, 1, 0xff00ff);
				return input;
			};
			this._stepper.incrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(SMALLER_SIZE, 1, 0xffff00);
				return button;
			};
			this._stepper.decrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(SMALLER_SIZE2, 1, 0x00ffff);
				return button;
			};
			this._stepper.validate();
			Assert.assertStrictlyEquals("The width of the NumericStepper was not calculated correctly with buttonLayoutMode set to split horizontal.",
				SMALLER_SIZE + SMALLER_SIZE2 + LARGER_SIZE + TEXT_INPUT_GAP * 2, this._stepper.width);
		}

		[Test]
		public function testAutoSizeHeightWithButtonLayoutModeSplitHorizontalAndLargerTextInput():void
		{
			this._stepper.buttonLayoutMode = StepperButtonLayoutMode.SPLIT_HORIZONTAL;
			this._stepper.textInputGap = TEXT_INPUT_GAP;
			this._stepper.textInputFactory = function():TextInput
			{
				var input:TextInput = new TextInput();
				input.backgroundSkin = new Quad(1, LARGER_SIZE, 0xff00ff);
				return input;
			};
			this._stepper.incrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, SMALLER_SIZE, 0xffff00);
				return button;
			};
			this._stepper.decrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, SMALLER_SIZE2, 0x00ffff);
				return button;
			};
			this._stepper.validate();
			Assert.assertStrictlyEquals("The height of the NumericStepper was not calculated correctly with buttonLayoutMode set to split horizontal and a larger text input.",
				LARGER_SIZE, this._stepper.height);
		}

		[Test]
		public function testAutoSizeHeightWithButtonLayoutModeSplitHorizontalAndSmallerTextInput():void
		{
			this._stepper.buttonLayoutMode = StepperButtonLayoutMode.SPLIT_HORIZONTAL;
			this._stepper.textInputGap = TEXT_INPUT_GAP;
			this._stepper.textInputFactory = function():TextInput
			{
				var input:TextInput = new TextInput();
				input.backgroundSkin = new Quad(1, SMALLER_SIZE, 0xff00ff);
				input.minHeight = SMALLER_SIZE;
				return input;
			};
			this._stepper.incrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, LARGER_SIZE, 0xffff00);
				button.minHeight = LARGER_SIZE;
				return button;
			};
			this._stepper.decrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, LARGER_SIZE2, 0x00ffff);
				return button;
			};
			this._stepper.validate();
			Assert.assertStrictlyEquals("The height of the NumericStepper was not calculated correctly with buttonLayoutMode set to split horizontal and a smaller text input.",
				LARGER_SIZE, this._stepper.height);
		}

		[Test]
		public function testAutoSizeMinWidthWithButtonLayoutModeSplitHorizontal():void
		{
			this._stepper.buttonLayoutMode = StepperButtonLayoutMode.SPLIT_HORIZONTAL;
			this._stepper.textInputGap = TEXT_INPUT_GAP;
			this._stepper.textInputFactory = function():TextInput
			{
				var input:TextInput = new TextInput();
				input.backgroundSkin = new Quad(1, 1, 0xff00ff);
				input.minWidth = LARGER_SIZE;
				return input;
			};
			this._stepper.incrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, 1, 0xffff00);
				button.minWidth = SMALLER_SIZE;
				return button;
			};
			this._stepper.decrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, 1, 0x00ffff);
				button.minWidth = SMALLER_SIZE2;
				return button;
			};
			this._stepper.validate();
			Assert.assertStrictlyEquals("The minWidth of the NumericStepper was not calculated correctly with buttonLayoutMode set to split horizontal.",
				SMALLER_SIZE + SMALLER_SIZE2 + LARGER_SIZE + TEXT_INPUT_GAP * 2, this._stepper.minWidth);
		}

		[Test]
		public function testAutoSizeMinHeightWithButtonLayoutModeSplitHorizontalAndLargerTextInput():void
		{
			this._stepper.buttonLayoutMode = StepperButtonLayoutMode.SPLIT_HORIZONTAL;
			this._stepper.textInputGap = TEXT_INPUT_GAP;
			this._stepper.textInputFactory = function():TextInput
			{
				var input:TextInput = new TextInput();
				input.backgroundSkin = new Quad(1, 1, 0xff00ff);
				input.minHeight = LARGER_SIZE;
				return input;
			};
			this._stepper.incrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, 1, 0xffff00);
				button.minHeight = SMALLER_SIZE;
				return button;
			};
			this._stepper.decrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, 1, 0x00ffff);
				button.minHeight = SMALLER_SIZE2;
				return button;
			};
			this._stepper.validate();
			Assert.assertStrictlyEquals("The minHeight of the NumericStepper was not calculated correctly with buttonLayoutMode set to split horizontal and a larger text input.",
				LARGER_SIZE, this._stepper.minHeight);
		}

		[Test]
		public function testAutoSizeMinHeightWithButtonLayoutModeSplitHorizontalAndSmallerTextInput():void
		{
			this._stepper.buttonLayoutMode = StepperButtonLayoutMode.SPLIT_HORIZONTAL;
			this._stepper.textInputGap = TEXT_INPUT_GAP;
			this._stepper.textInputFactory = function():TextInput
			{
				var input:TextInput = new TextInput();
				input.backgroundSkin = new Quad(1, 1, 0xff00ff);
				input.minHeight = SMALLER_SIZE;
				return input;
			};
			this._stepper.incrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, 1, 0xffff00);
				button.minHeight = LARGER_SIZE;
				return button;
			};
			this._stepper.decrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Quad(1, 1, 0x00ffff);
				button.minHeight = LARGER_SIZE2;
				return button;
			};
			this._stepper.validate();
			Assert.assertStrictlyEquals("The minHeight of the NumericStepper was not calculated correctly with buttonLayoutMode set to split horizontal and a smaller text input.",
				LARGER_SIZE, this._stepper.minHeight);
		}
	}
}
