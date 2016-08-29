package feathers.tests
{
	import feathers.controls.TextInput;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.core.FocusManager;
	import feathers.events.FeathersEventType;

	import org.flexunit.Assert;

	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class TextInputFocusTests
	{
		private static const SAMPLE_TEXT:String = "I am the very model of a modern major general";

		private var _textInput:TextInput;

		[Before]
		public function prepare():void
		{
			this._textInput = new TextInput();
			this._textInput.backgroundSkin = new Quad(200, 200);
			this._textInput.textEditorFactory = textEditorFactory;
			TestFeathers.starlingRoot.addChild(this._textInput);
			this._textInput.validate();
		}

		private function textEditorFactory():TextFieldTextEditor
		{
			var textEditor:TextFieldTextEditor = new TextFieldTextEditor();
			return textEditor;
		}

		[After]
		public function cleanup():void
		{
			TestFeathers.starlingRoot.visible = true;
			FocusManager.setEnabledForStage(this._textInput.stage, false);
			this._textInput.removeFromParent(true);
			this._textInput = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testFocusInEventAfterSetFocusFunctionWithoutFocusManager():void
		{
			var hasDispatchedFocusIn:Boolean = false;
			this._textInput.addEventListener(FeathersEventType.FOCUS_IN, function(event:Event):void
			{
				hasDispatchedFocusIn = true;
			});
			this._textInput.setFocus();
			Assert.assertTrue("FeathersEventType.FOCUS_IN was not dispatched after calling setFocus()", hasDispatchedFocusIn);
		}

		[Test]
		public function testFocusOutEventAfterClearFocusFunctionWithoutFocusManager():void
		{
			var hasDispatchedFocusOut:Boolean = false;
			this._textInput.addEventListener(FeathersEventType.FOCUS_OUT, function(event:Event):void
			{
				hasDispatchedFocusOut = true;
			});
			this._textInput.setFocus();
			this._textInput.clearFocus();
			Assert.assertTrue("FeathersEventType.FOCUS_OUT was not dispatched after calling clearFocus()", hasDispatchedFocusOut);
		}

		[Test]
		public function testFocusOutEventAfterSetVisibleToFalseWithoutFocusManager():void
		{
			var hasDispatchedFocusOut:Boolean = false;
			this._textInput.addEventListener(FeathersEventType.FOCUS_OUT, function(event:Event):void
			{
				hasDispatchedFocusOut = true;
			});
			this._textInput.setFocus();
			this._textInput.visible = false;
			Assert.assertTrue("FeathersEventType.FOCUS_OUT was not dispatched after setting visible property to false", hasDispatchedFocusOut);
		}

		[Test]
		public function testFocusInEventAfterSetFocusFunctionWithFocusManager():void
		{
			FocusManager.setEnabledForStage(this._textInput.stage, true);
			this.testFocusInEventAfterSetFocusFunctionWithoutFocusManager();
		}

		[Test]
		public function testFocusOutEventAfterClearFocusFunctionWithFocusManager():void
		{
			FocusManager.setEnabledForStage(this._textInput.stage, true);
			this.testFocusOutEventAfterClearFocusFunctionWithoutFocusManager();
		}

		[Test]
		public function testFocusOutEventAfterSetVisibleToFalseWithFocusManager():void
		{
			FocusManager.setEnabledForStage(this._textInput.stage, true);
			this.testFocusOutEventAfterSetVisibleToFalseWithoutFocusManager();
		}

		[Test]
		public function testSelectionRangeInsideFocusInListenerAfterSetFocusFunctionWithoutFocusManager():void
		{
			this._textInput.text = SAMPLE_TEXT;
			var selectionBeginIndex:int = -1;
			var selectionEndIndex:int = -1;
			this._textInput.addEventListener(FeathersEventType.FOCUS_IN, function(event:Event):void
			{
				selectionBeginIndex = _textInput.selectionBeginIndex;
				selectionEndIndex = _textInput.selectionEndIndex;
			});
			this._textInput.setFocus();
			Assert.assertStrictlyEquals("TextInput selectionBeginIndex incorrect after calling setFocus()",
				0, selectionBeginIndex);
			Assert.assertStrictlyEquals("TextInput selectionBeginIndex incorrect after calling setFocus()",
				SAMPLE_TEXT.length, selectionEndIndex);
		}

		[Test]
		public function testSelectionRangeInsideFocusInListenerAfterSetFocusFunctionWithFocusManager():void
		{
			FocusManager.setEnabledForStage(this._textInput.stage, true);
			this.testSelectionRangeInsideFocusInListenerAfterSetFocusFunctionWithoutFocusManager();
		}

		[Test]
		public function testSelectionRangeAfterSetFocusThenSelectRangeFunctionWithoutFocusManager():void
		{
			this._textInput.text = SAMPLE_TEXT;
			this._textInput.setFocus();
			var selectionBeginIndex:int = 1;
			var selectionEndIndex:int = 3;
			this._textInput.selectRange(selectionBeginIndex, selectionEndIndex);
			Assert.assertStrictlyEquals("TextInput selectionBeginIndex incorrect after calling setFocus() then selectRange()",
				selectionBeginIndex, this._textInput.selectionBeginIndex);
			Assert.assertStrictlyEquals("TextInput selectionBeginIndex incorrect after calling setFocus() then selectRange()",
				selectionEndIndex, this._textInput.selectionEndIndex);
		}

		[Test]
		public function testSelectionRangeAfterSetFocusThenSelectRangeFunctionWithFocusManager():void
		{
			FocusManager.setEnabledForStage(this._textInput.stage, true);
			this.testSelectionRangeAfterSetFocusThenSelectRangeFunctionWithoutFocusManager();
		}

		[Test]
		public function testSelectionRangeAfterTouchEventWithoutFocusManager():void
		{
			this._textInput.text = SAMPLE_TEXT;
			//validate to make sure the text is passed down to the text editor
			this._textInput.validate();

			var selectionBeginIndex:int = -1;
			var selectionEndIndex:int = -1;
			this._textInput.addEventListener(FeathersEventType.FOCUS_IN, function(event:Event):void
			{
				selectionBeginIndex = _textInput.selectionBeginIndex;
				selectionEndIndex = _textInput.selectionEndIndex;
			});

			var touch:Touch = new Touch(0);
			touch.target = this._textInput;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = 100;
			touch.globalY = 5;
			var touches:Vector.<Touch> = new <Touch>[touch];
			this._textInput.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			//this touch does not move at all, so it should result in triggering
			//the button.
			touch.phase = TouchPhase.ENDED;
			this._textInput.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			//we don't care what the exact index is, but it should be clear that
			//the touch changed it to something
			Assert.assertTrue("TextInput selectionBeginIndex and selectionEndIndex incorrect after TouchEvent.TOUCH",
				selectionBeginIndex > 0 && selectionEndIndex < SAMPLE_TEXT.length && selectionBeginIndex === selectionEndIndex)
		}

		[Test]
		public function testSelectionRangeAfterTouchEventWithFocusManager():void
		{
			FocusManager.setEnabledForStage(this._textInput.stage, true);
			this.testSelectionRangeAfterTouchEventWithoutFocusManager();
		}
	}
}
