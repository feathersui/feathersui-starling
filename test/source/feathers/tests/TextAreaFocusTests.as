package feathers.tests
{
	import feathers.controls.TextArea;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.controls.text.TextFieldTextEditorViewPort;
	import feathers.core.FocusManager;
	import feathers.events.FeathersEventType;

	import org.flexunit.Assert;

	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class TextAreaFocusTests
	{
		private static const SAMPLE_TEXT:String = "I am the very model of a modern major general";

		private var _textArea:TextArea;

		[Before]
		public function prepare():void
		{
			this._textArea = new TextArea();
			this._textArea.backgroundSkin = new Quad(200, 200);
			this._textArea.textEditorFactory = textEditorFactory;
			TestFeathers.starlingRoot.addChild(this._textArea);
			this._textArea.validate();
		}

		private function textEditorFactory():TextFieldTextEditor
		{
			var textEditor:TextFieldTextEditorViewPort = new TextFieldTextEditorViewPort();
			return textEditor;
		}

		[After]
		public function cleanup():void
		{
			FocusManager.setEnabledForStage(this._textArea.stage, false);
			this._textArea.removeFromParent(true);
			this._textArea = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testFocusInEventAfterSetFocusFunctionWithoutFocusManager():void
		{
			var hasDispatchedFocusIn:Boolean = false;
			this._textArea.addEventListener(FeathersEventType.FOCUS_IN, function(event:Event):void
			{
				hasDispatchedFocusIn = true;
			});
			this._textArea.setFocus();
			Assert.assertTrue("FeathersEventType.FOCUS_IN was not dispatched after calling setFocus()", hasDispatchedFocusIn);
		}

		[Test]
		public function testFocusOutEventAfterClearFocusFunctionWithoutFocusManager():void
		{
			var hasDispatchedFocusOut:Boolean = false;
			this._textArea.addEventListener(FeathersEventType.FOCUS_OUT, function(event:Event):void
			{
				hasDispatchedFocusOut = true;
			});
			this._textArea.setFocus();
			this._textArea.clearFocus();
			Assert.assertTrue("FeathersEventType.FOCUS_OUT was not dispatched after calling clearFocus()", hasDispatchedFocusOut);
		}

		[Test]
		public function testFocusInEventAfterSetFocusFunctionWithFocusManager():void
		{
			FocusManager.setEnabledForStage(this._textArea.stage, true);
			this.testFocusInEventAfterSetFocusFunctionWithoutFocusManager();
		}

		[Test]
		public function testFocusOutEventAfterClearFocusFunctionWithFocusManager():void
		{
			FocusManager.setEnabledForStage(this._textArea.stage, true);
			this.testFocusOutEventAfterClearFocusFunctionWithoutFocusManager();
		}

		[Test]
		public function testSelectionRangeInsideFocusInListenerAfterSetFocusFunctionWithoutFocusManager():void
		{
			this._textArea.text = SAMPLE_TEXT;
			var selectionBeginIndex:int = -1;
			var selectionEndIndex:int = -1;
			this._textArea.addEventListener(FeathersEventType.FOCUS_IN, function(event:Event):void
			{
				selectionBeginIndex = _textArea.selectionBeginIndex;
				selectionEndIndex = _textArea.selectionEndIndex;
			});
			this._textArea.setFocus();
			Assert.assertStrictlyEquals("TextArea selectionBeginIndex incorrect after calling setFocus()",
				0, selectionBeginIndex);
			Assert.assertStrictlyEquals("TextArea selectionBeginIndex incorrect after calling setFocus()",
				0, selectionEndIndex);
		}

		[Test]
		public function testSelectionRangeInsideFocusInListenerAfterSetFocusFunctionWithFocusManager():void
		{
			FocusManager.setEnabledForStage(this._textArea.stage, true);
			this.testSelectionRangeInsideFocusInListenerAfterSetFocusFunctionWithoutFocusManager();
		}

		[Test]
		public function testSelectionRangeAfterSetFocusThenSelectRangeFunctionWithoutFocusManager():void
		{
			this._textArea.text = SAMPLE_TEXT;
			this._textArea.setFocus();
			var selectionBeginIndex:int = 1;
			var selectionEndIndex:int = 3;
			this._textArea.selectRange(selectionBeginIndex, selectionEndIndex);
			Assert.assertStrictlyEquals("TextArea selectionBeginIndex incorrect after calling setFocus() then selectRange()",
				selectionBeginIndex, this._textArea.selectionBeginIndex);
			Assert.assertStrictlyEquals("TextArea selectionBeginIndex incorrect after calling setFocus() then selectRange()",
				selectionEndIndex, this._textArea.selectionEndIndex);
		}

		[Test]
		public function testSelectionRangeAfterSetFocusThenSelectRangeFunctionWithFocusManager():void
		{
			FocusManager.setEnabledForStage(this._textArea.stage, true);
			this.testSelectionRangeAfterSetFocusThenSelectRangeFunctionWithoutFocusManager();
		}

		[Test]
		public function testSelectionRangeAfterTouchEventWithoutFocusManager():void
		{
			this._textArea.text = SAMPLE_TEXT;
			//validate to make sure the text is passed down to the text editor
			this._textArea.validate();

			var selectionBeginIndex:int = -1;
			var selectionEndIndex:int = -1;
			this._textArea.addEventListener(FeathersEventType.FOCUS_IN, function(event:Event):void
			{
				selectionBeginIndex = _textArea.selectionBeginIndex;
				selectionEndIndex = _textArea.selectionEndIndex;
			});

			var touch:Touch = new Touch(0);
			touch.target = this._textArea;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = 100;
			touch.globalY = 5;
			var touches:Vector.<Touch> = new <Touch>[touch];
			this._textArea.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			//this touch does not move at all, so it should result in triggering
			//the button.
			touch.phase = TouchPhase.ENDED;
			this._textArea.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			//we don't care what the exact index is, but it should be clear that
			//the touch changed it to something
			Assert.assertTrue("TextArea selectionBeginIndex and selectionEndIndex incorrect after TouchEvent.TOUCH",
				selectionBeginIndex > 0 && selectionEndIndex < SAMPLE_TEXT.length && selectionBeginIndex === selectionEndIndex)
		}

		[Test]
		public function testSelectionRangeAfterTouchEventWithFocusManager():void
		{
			FocusManager.setEnabledForStage(this._textArea.stage, true);
			this.testSelectionRangeAfterTouchEventWithoutFocusManager();
		}
	}
}
