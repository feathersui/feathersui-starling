package feathers.tests
{
	import feathers.controls.TextInput;
	import feathers.controls.text.TextBlockTextEditor;
	import feathers.core.FocusManager;
	import feathers.events.FeathersEventType;

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.ui.Keyboard;

	import org.flexunit.Assert;
	import org.flexunit.async.Async;

	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;

	public class TextBlockTextEditorFocusTests
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

		private function textEditorFactory():TextBlockTextEditor
		{
			var textEditor:TextBlockTextEditor = new TextBlockTextEditor();
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
			this._textInput.addEventListener(FeathersEventType.FOCUS_OUT, function(event:starling.events.Event):void
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
			this._textInput.focusManager.focus = this._textInput;
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
			this._textInput.focusManager.focus = this._textInput;
			Starling.current.nativeStage.focus.dispatchEvent(new flash.events.Event(flash.events.Event.SELECT_ALL, true));
			Starling.current.nativeStage.focus.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, Keyboard.LEFT, 0, false, false, true));
			this._textInput.validate();
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
			this._textInput.focusManager.focus = this._textInput;
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
			this._textInput.focusManager.focus = this._textInput;
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
			this._textInput.focusManager.focus = this._textInput;
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
			this._textInput.focusManager.focus = this._textInput;
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
			this._textInput.focusManager.focus = this._textInput;
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

		[Test]
		public function testSelectRangeAndKeyboardDelete():void
		{
			this._textInput.text = "Hello World";
			this._textInput.validate();
			this._textInput.focusManager.focus = this._textInput;
			var rangeStart:int = 2;
			var rangeEnd:int = 8;
			this._textInput.selectRange(rangeStart, rangeEnd);
			this._textInput.validate();
			Starling.current.nativeStage.focus.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, Keyboard.DELETE, 0, false, false, false));
			Assert.assertStrictlyEquals("selectionBeginIndex not changed correctly after selectRange() and pressing Keyboard.DELETE",
				rangeStart, this._textInput.selectionBeginIndex);
			Assert.assertStrictlyEquals("selectionEndIndex not changed correctly after selectRange() and pressing Keyboard.DELETE",
				rangeStart, this._textInput.selectionEndIndex);
			Assert.assertStrictlyEquals("text not changed correctly after selectRange() and pressing Keyboard.DELETE",
				"Herld", this._textInput.text);
		}

		[Test]
		public function testSelectRangeAndKeyboardBackspace():void
		{
			this._textInput.text = "Hello World";
			this._textInput.validate();
			this._textInput.focusManager.focus = this._textInput;
			var rangeStart:int = 2;
			var rangeEnd:int = 8;
			this._textInput.selectRange(rangeStart, rangeEnd);
			this._textInput.validate();
			Starling.current.nativeStage.focus.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, Keyboard.BACKSPACE, 0, false, false, false));
			Assert.assertStrictlyEquals("selectionBeginIndex not changed correctly after selectRange() and pressing Keyboard.BACKSPACE",
				rangeStart, this._textInput.selectionBeginIndex);
			Assert.assertStrictlyEquals("selectionEndIndex not changed correctly after selectRange() and pressing Keyboard.BACKSPACE",
				rangeStart, this._textInput.selectionEndIndex);
			Assert.assertStrictlyEquals("text not changed correctly after selectRange() and pressing Keyboard.BACKSPACE",
				"Herld", this._textInput.text);
		}

		[Test]
		public function testSelectRangeAndTyping():void
		{
			this._textInput.text = "Hello World";
			this._textInput.validate();
			this._textInput.focusManager.focus = this._textInput;
			var rangeStart:int = 2;
			var rangeEnd:int = 8;
			var textToType:String = "test";
			this._textInput.selectRange(rangeStart, rangeEnd);
			this._textInput.validate();
			Starling.current.nativeStage.focus.dispatchEvent(new TextEvent(TextEvent.TEXT_INPUT, false, false, textToType));
			Assert.assertStrictlyEquals("selectionBeginIndex not changed correctly after selectRange() and typing some text",
				rangeStart + textToType.length, this._textInput.selectionBeginIndex);
			Assert.assertStrictlyEquals("selectionEndIndex not changed correctly after selectRange() and typing some text",
				rangeStart + textToType.length, this._textInput.selectionEndIndex);
			Assert.assertStrictlyEquals("text not changed correctly after selectRange() and typing some text",
				"He" + textToType + "rld", this._textInput.text);
		}

		[Test]
		public function testSetCursorAndKeyboardDelete():void
		{
			this._textInput.text = "Hello World";
			this._textInput.validate();
			this._textInput.focusManager.focus = this._textInput;
			var cursorIndex:int = 2;
			this._textInput.selectRange(cursorIndex, cursorIndex);
			this._textInput.validate();
			Starling.current.nativeStage.focus.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, Keyboard.DELETE, 0, false, false, false));
			Assert.assertStrictlyEquals("selectionBeginIndex incorrectly changed after selectRange() and pressing Keyboard.DELETE",
				cursorIndex, this._textInput.selectionBeginIndex);
			Assert.assertStrictlyEquals("selectionEndIndex incorrectly changed after selectRange() and pressing Keyboard.DELETE",
				cursorIndex, this._textInput.selectionEndIndex);
			Assert.assertStrictlyEquals("text not changed correctly after selectRange() and pressing Keyboard.DELETE",
				"Helo World", this._textInput.text);
		}

		[Test]
		public function testSetCursorAndKeyboardBackspace():void
		{
			this._textInput.text = "Hello World";
			this._textInput.validate();
			this._textInput.focusManager.focus = this._textInput;
			var cursorIndex:int = 2;
			this._textInput.selectRange(cursorIndex, cursorIndex);
			this._textInput.validate();
			Starling.current.nativeStage.focus.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, Keyboard.BACKSPACE, 0, false, false, false));
			cursorIndex--;
			Assert.assertStrictlyEquals("selectionBeginIndex not changed correctly after selectRange() and pressing Keyboard.BACKSPACE",
				cursorIndex, this._textInput.selectionBeginIndex);
			Assert.assertStrictlyEquals("selectionEndIndex not changed correctly after selectRange() and pressing Keyboard.BACKSPACE",
				cursorIndex, this._textInput.selectionEndIndex);
			Assert.assertStrictlyEquals("text not changed correctly after selectRange() and pressing Keyboard.BACKSPACE",
				"Hllo World", this._textInput.text);
		}

		[Test]
		public function testSetCursorAndKeyboardUp():void
		{
			this._textInput.text = "Hello World";
			this._textInput.validate();
			this._textInput.focusManager.focus = this._textInput;
			var cursorIndex:int = 2;
			this._textInput.selectRange(cursorIndex, cursorIndex);
			this._textInput.validate();
			Starling.current.nativeStage.focus.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, Keyboard.UP, 0, false, false, false));
			cursorIndex = 0;
			Assert.assertStrictlyEquals("selectionBeginIndex not changed correctly after selectRange() and pressing Keyboard.UP",
				cursorIndex, this._textInput.selectionBeginIndex);
			Assert.assertStrictlyEquals("selectionEndIndex not changed correctly after selectRange() and pressing Keyboard.UP",
				cursorIndex, this._textInput.selectionEndIndex);
		}

		[Test]
		public function testSetCursorAndKeyboardDown():void
		{
			this._textInput.text = "Hello World";
			this._textInput.validate();
			this._textInput.focusManager.focus = this._textInput;
			var cursorIndex:int = 2;
			this._textInput.selectRange(cursorIndex, cursorIndex);
			this._textInput.validate();
			Starling.current.nativeStage.focus.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, Keyboard.DOWN, 0, false, false, false));
			cursorIndex = this._textInput.text.length;
			Assert.assertStrictlyEquals("selectionBeginIndex not changed correctly after selectRange() and pressing Keyboard.DOWN",
				cursorIndex, this._textInput.selectionBeginIndex);
			Assert.assertStrictlyEquals("selectionEndIndex not changed correctly after selectRange() and pressing Keyboard.DOWN",
				cursorIndex, this._textInput.selectionEndIndex);
		}

		[Test]
		public function testSetCursorAndKeyboardLeft():void
		{
			this._textInput.text = "Hello World";
			this._textInput.validate();
			this._textInput.focusManager.focus = this._textInput;
			var cursorIndex:int = 2;
			this._textInput.selectRange(cursorIndex, cursorIndex);
			this._textInput.validate();
			Starling.current.nativeStage.focus.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, Keyboard.LEFT, 0, false, false, false));
			cursorIndex--;
			Assert.assertStrictlyEquals("selectionBeginIndex not changed correctly after selectRange() and pressing Keyboard.LEFT",
				cursorIndex, this._textInput.selectionBeginIndex);
			Assert.assertStrictlyEquals("selectionEndIndex not changed correctly after selectRange() and pressing Keyboard.LEFT",
				cursorIndex, this._textInput.selectionEndIndex);
		}

		[Test]
		public function testSetCursorAndKeyboardRight():void
		{
			this._textInput.text = "Hello World";
			this._textInput.validate();
			this._textInput.focusManager.focus = this._textInput;
			var cursorIndex:int = 2;
			this._textInput.selectRange(cursorIndex, cursorIndex);
			this._textInput.validate();
			Starling.current.nativeStage.focus.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, Keyboard.RIGHT, 0, false, false, false));
			cursorIndex++;
			Assert.assertStrictlyEquals("selectionBeginIndex not changed correctly after selectRange() and pressing Keyboard.RIGHT",
				cursorIndex, this._textInput.selectionBeginIndex);
			Assert.assertStrictlyEquals("selectionEndIndex not changed correctly after selectRange() and pressing Keyboard.RIGHT",
				cursorIndex, this._textInput.selectionEndIndex);
		}

		[Test]
		public function testSetCursorAndKeyboardShiftLeft():void
		{
			this._textInput.text = "Hello World";
			this._textInput.validate();
			this._textInput.focusManager.focus = this._textInput;
			var rangeStart:int = 2;
			var rangeEnd:int = 2;
			this._textInput.selectRange(rangeStart, rangeEnd);
			this._textInput.validate();
			Starling.current.nativeStage.focus.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, Keyboard.LEFT, 0, false, false, true));
			rangeStart--;
			Assert.assertStrictlyEquals("selectionBeginIndex not changed correctly after selectRange() and pressing Keyboard.LEFT and shift key",
				rangeStart, this._textInput.selectionBeginIndex);
			Assert.assertStrictlyEquals("selectionEndIndex not changed correctly after selectRange() and pressing Keyboard.LEFT and shift key",
				rangeEnd, this._textInput.selectionEndIndex);
		}

		[Test]
		public function testSetCursorAndKeyboardShiftRight():void
		{
			this._textInput.text = "Hello World";
			this._textInput.validate();
			this._textInput.focusManager.focus = this._textInput;
			var rangeStart:int = 2;
			var rangeEnd:int = 2;
			this._textInput.selectRange(rangeStart, rangeEnd);
			this._textInput.validate();
			Starling.current.nativeStage.focus.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, Keyboard.RIGHT, 0, false, false, true));
			rangeEnd++;
			Assert.assertStrictlyEquals("selectionBeginIndex not changed correctly after selectRange() and pressing Keyboard.RIGHT and shift key",
				rangeStart, this._textInput.selectionBeginIndex);
			Assert.assertStrictlyEquals("selectionEndIndex not changed correctly after selectRange() and pressing Keyboard.RIGHT and shift key",
				rangeEnd, this._textInput.selectionEndIndex);
		}

		[Test]
		public function testSetCursorAndTyping():void
		{
			this._textInput.text = "Hello World";
			this._textInput.validate();
			this._textInput.focusManager.focus = this._textInput;
			var cursorIndex:int = 2;
			var textToType:String = "test";
			this._textInput.selectRange(cursorIndex, cursorIndex);
			this._textInput.validate();
			Starling.current.nativeStage.focus.dispatchEvent(new TextEvent(TextEvent.TEXT_INPUT, false, false, textToType));
			Assert.assertStrictlyEquals("selectionBeginIndex not changed correctly after selectRange() and typing some text",
				cursorIndex + textToType.length, this._textInput.selectionBeginIndex);
			Assert.assertStrictlyEquals("selectionEndIndex not changed correctly after selectRange() and typing some text",
				cursorIndex + textToType.length, this._textInput.selectionEndIndex);
			Assert.assertStrictlyEquals("text not changed correctly after selectRange() and typing some text",
				"He" + textToType + "llo World", this._textInput.text);
		}
	}
}
