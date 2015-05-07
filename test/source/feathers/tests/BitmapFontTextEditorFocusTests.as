package feathers.tests
{
	import feathers.controls.TextInput;
	import feathers.controls.text.BitmapFontTextEditor;
	import feathers.core.FocusManager;
	import feathers.events.FeathersEventType;

	import flash.events.KeyboardEvent;

	import flash.ui.Keyboard;

	import org.flexunit.Assert;
	import org.flexunit.async.Async;

	import starling.core.Starling;

	import starling.display.Quad;
	import starling.events.Event;

	public class BitmapFontTextEditorFocusTests
	{
		private var _textInput:TextInput;

		[Before]
		public function prepare():void
		{
			FocusManager.setEnabledForStage(TestFeathers.starlingRoot.stage, true);

			this._textInput = new TextInput();
			this._textInput.backgroundSkin = new Quad(200, 200);
			this._textInput.textEditorFactory = textEditorFactory;
			TestFeathers.starlingRoot.addChild(this._textInput);
			this._textInput.validate();
		}

		private function textEditorFactory():BitmapFontTextEditor
		{
			var textEditor:BitmapFontTextEditor = new BitmapFontTextEditor();
			return textEditor;
		}

		[After]
		public function cleanup():void
		{
			//one of the tests sets the parent's visible property to false, so
			//it needs to be reset.
			this._textInput.parent.visible = true;

			FocusManager.setEnabledForStage(TestFeathers.starlingRoot.stage, false);
			this._textInput.removeFromParent(true);
			this._textInput = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test(async)]
		public function testFocusOutEventAfterSetTextInputParentVisibleToFalse():void
		{
			var hasDispatchedFocusOut:Boolean = false;
			this._textInput.addEventListener(FeathersEventType.FOCUS_OUT, function(event:Event):void
			{
				hasDispatchedFocusOut = true;
			});
			this._textInput.setFocus();
			this._textInput.parent.visible = false;
			Async.delayCall(this, function():void
			{
				Assert.assertTrue("FeathersEventType.FOCUS_OUT was not dispatched after setting TextInput parent's visible property to false when using BitmapFontTextEditor", hasDispatchedFocusOut);
			}, 100);
		}

		[Test]
		public function testSelectionChangeAfterSelectAllEvent():void
		{
			this._textInput.text = "Hello World";
			this._textInput.validate();
			FocusManager.getFocusManagerForStage(this._textInput.stage).focus = this._textInput;
			Starling.current.nativeStage.focus.dispatchEvent(new flash.events.Event(flash.events.Event.SELECT_ALL, true));
			Assert.assertStrictlyEquals("selectionBeginIndex not changed after Ctrl/Cmd+A to select all",
				0, this._textInput.selectionBeginIndex);
			Assert.assertStrictlyEquals("selectionEndIndex not changed after Ctrl/Cmd+A to select all",
				this._textInput.text.length, this._textInput.selectionEndIndex);
		}

		[Test]
		public function testSelectionChangeAfterSelectAllEventAndKeyboardShiftLeft():void
		{
			this._textInput.text = "Hello World";
			this._textInput.validate();
			FocusManager.getFocusManagerForStage(this._textInput.stage).focus = this._textInput;
			Starling.current.nativeStage.focus.dispatchEvent(new flash.events.Event(flash.events.Event.SELECT_ALL, true));
			Starling.current.nativeStage.focus.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, Keyboard.LEFT, 0, false, false, true));
			Assert.assertStrictlyEquals("selectionBeginIndex not changed correctly after Ctrl/Cmd+A to select all and pressing Keyboard.LEFT and shift key",
				0, this._textInput.selectionBeginIndex);
			Assert.assertStrictlyEquals("selectionEndIndex not changed correctly after Ctrl/Cmd+A to select all and pressing Keyboard.LEFT and shift key",
				this._textInput.text.length - 1, this._textInput.selectionEndIndex);
		}

		[Test]
		public function testSelectionChangeAfterSelectAllEventAndKeyboardLeft():void
		{
			this._textInput.text = "Hello World";
			this._textInput.validate();
			FocusManager.getFocusManagerForStage(this._textInput.stage).focus = this._textInput;
			Starling.current.nativeStage.focus.dispatchEvent(new flash.events.Event(flash.events.Event.SELECT_ALL, true));
			Starling.current.nativeStage.focus.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, Keyboard.LEFT, 0, false, false, false));
			Assert.assertStrictlyEquals("selectionBeginIndex not changed correctly after Ctrl/Cmd+A to select all and pressing Keyboard.LEFT",
				0, this._textInput.selectionBeginIndex);
			Assert.assertStrictlyEquals("selectionEndIndex not changed correctly after Ctrl/Cmd+A to select all and pressing Keyboard.LEFT",
				0, this._textInput.selectionEndIndex);
		}

		[Test]
		public function testSelectionChangeAfterSelectAllEventAndKeyboardRight():void
		{
			this._textInput.text = "Hello World";
			this._textInput.validate();
			FocusManager.getFocusManagerForStage(this._textInput.stage).focus = this._textInput;
			Starling.current.nativeStage.focus.dispatchEvent(new flash.events.Event(flash.events.Event.SELECT_ALL, true));
			Starling.current.nativeStage.focus.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, Keyboard.RIGHT, 0, false, false, false));
			Assert.assertStrictlyEquals("selectionBeginIndex not changed correctly after Ctrl/Cmd+A to select all and pressing Keyboard.RIGHT",
				this._textInput.text.length, this._textInput.selectionBeginIndex);
			Assert.assertStrictlyEquals("selectionEndIndex not changed correctly after Ctrl/Cmd+A to select all and pressing Keyboard.RIGHT",
				this._textInput.text.length, this._textInput.selectionEndIndex);
		}

		[Test]
		public function testSelectionChangeAfterSelectRange():void
		{
			this._textInput.text = "Hello World";
			this._textInput.validate();
			FocusManager.getFocusManagerForStage(this._textInput.stage).focus = this._textInput;
			var rangeStart:int = 2;
			var rangeEnd:int = 8;
			this._textInput.selectRange(rangeStart, rangeEnd);
			Assert.assertStrictlyEquals("selectionBeginIndex not changed correctly after selectRange() and pressing Keyboard.LEFT",
				rangeStart, this._textInput.selectionBeginIndex);
			Assert.assertStrictlyEquals("selectionEndIndex not changed correctly after selectRange() and pressing Keyboard.LEFT",
				rangeEnd, this._textInput.selectionEndIndex);
		}

		[Test]
		public function testSelectionChangeAfterSelectRangeAndKeyboardLeft():void
		{
			this._textInput.text = "Hello World";
			this._textInput.validate();
			FocusManager.getFocusManagerForStage(this._textInput.stage).focus = this._textInput;
			var rangeStart:int = 2;
			var rangeEnd:int = 8;
			this._textInput.selectRange(rangeStart, rangeEnd);
			this._textInput.validate();
			Starling.current.nativeStage.focus.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, Keyboard.LEFT, 0, false, false, false));
			Assert.assertStrictlyEquals("selectionBeginIndex not changed correctly after selectRange() and pressing Keyboard.LEFT",
				rangeStart, this._textInput.selectionBeginIndex);
			Assert.assertStrictlyEquals("selectionEndIndex not changed correctly after selectRange() and pressing Keyboard.LEFT",
				rangeStart, this._textInput.selectionEndIndex);
		}

		[Test]
		public function testSelectionChangeAfterSelectRangeAndKeyboardRight():void
		{
			this._textInput.text = "Hello World";
			this._textInput.validate();
			FocusManager.getFocusManagerForStage(this._textInput.stage).focus = this._textInput;
			var rangeStart:int = 2;
			var rangeEnd:int = 8;
			this._textInput.selectRange(rangeStart, rangeEnd);
			this._textInput.validate();
			Starling.current.nativeStage.focus.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, Keyboard.RIGHT, 0, false, false, false));
			Assert.assertStrictlyEquals("selectionBeginIndex not changed correctly after selectRange() and pressing Keyboard.RIGHT",
				rangeEnd, this._textInput.selectionBeginIndex);
			Assert.assertStrictlyEquals("selectionEndIndex not changed correctly after selectRange() and pressing Keyboard.RIGHT",
				rangeEnd, this._textInput.selectionEndIndex);
		}
	}
}
