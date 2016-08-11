package feathers.tests
{
	import feathers.controls.TextInput;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.core.FocusManager;
	import feathers.events.FeathersEventType;

	import org.flexunit.Assert;

	import starling.display.Quad;
	import starling.events.Event;

	public class TextInputFocusTests
	{
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
			var text:String = "I am the very model of a modern major general";
			this._textInput.text = text;
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
				text.length, selectionEndIndex);
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
			var text:String = "I am the very model of a modern major general";
			this._textInput.text = text;
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
	}
}
