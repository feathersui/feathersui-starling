package feathers.tests
{
	import feathers.controls.TextInput;
	import feathers.controls.TextInputState;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.FocusManager;
	import feathers.events.FeathersEventType;

	import flash.events.FocusEvent;
	import flash.ui.Keyboard;

	import org.flexunit.Assert;
	import org.flexunit.async.Async;

	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;

	public class StageTextTextEditorFocusTests
	{
		private var _textInput:TextInput;
		private var _textInput2:TextInput;

		[Before]
		public function prepare():void
		{
			FocusManager.setEnabledForStage(TestFeathers.starlingRoot.stage, true);

			this._textInput = new TextInput();
			this._textInput.backgroundSkin = new Quad(200, 200);
			this._textInput.textEditorFactory = textEditorFactory;
			TestFeathers.starlingRoot.addChild(this._textInput);
			this._textInput.validate();

			this._textInput2 = new TextInput();
			this._textInput2.backgroundSkin = new Quad(200, 200);
			this._textInput2.textEditorFactory = textEditorFactory;
			this._textInput2.y = 210;
			TestFeathers.starlingRoot.addChild(this._textInput2);
			this._textInput2.validate();
		}

		private function textEditorFactory():StageTextTextEditor
		{
			var textEditor:StageTextTextEditor = new StageTextTextEditor();
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

			this._textInput2.removeFromParent(true);
			this._textInput2 = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testChangeFocusOnTabKey():void
		{
			this._textInput.focusManager.focus = this._textInput;
			Starling.current.nativeStage.dispatchEvent(new FocusEvent(FocusEvent.KEY_FOCUS_CHANGE, true, false, null, false, Keyboard.TAB));
			Assert.assertStrictlyEquals("The FocusManager did not change focus when pressing Keyboard.TAB", this._textInput.focusManager.focus, this._textInput2);
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
			_textInput.parent.visible = false;
			Async.delayCall(this, function():void
			{
				Assert.assertTrue("FeathersEventType.FOCUS_OUT was not dispatched after setting TextInput parent's visible property to false when using StageTextTextEditor", hasDispatchedFocusOut);
			}, 100);
		}

		[Test]
		public function testSetFocusWhenFocusEnabledFalse():void
		{
			this._textInput.text = "Hello World";
			this._textInput.isFocusEnabled = false;
			this._textInput.validate();
			this._textInput.focusManager.focus = this._textInput;
			Assert.assertTrue("TextInput must not receive FocusManager focus when using StageTextTextEditor and isFocusEnabled is false",
				this._textInput.focusManager.focus !== this._textInput);
			Assert.assertStrictlyEquals("TextInput state must be TextInputState.ENABLED after receive FocusManager focus when using StageTextTextEditor and isFocusEnabled is false",
				TextInputState.ENABLED, this._textInput.currentState);
		}

		[Test]
		public function testSetFocusWhenEditableFalseAndSelectableFalse():void
		{
			this._textInput.text = "Hello World";
			this._textInput.isEditable = false;
			this._textInput.isSelectable = false;
			this._textInput.validate();
			Assert.assertNull("StageTextTextEditor nativeFocus must be null when isEditable is false and isSelectable is false",
				this._textInput.nativeFocus);
			this._textInput.focusManager.focus = this._textInput;
			Assert.assertStrictlyEquals("TextInput must receive FocusManager focus when using StageTextTextEditor and isEditable is false and isSelectable is false",
				this._textInput.focusManager.focus, this._textInput);
			Assert.assertStrictlyEquals("TextInput state must be TextInputState.FOCUSED after receive FocusManager focus when using TextFieldTextEditor and isEditable is false and isSelectable is false",
				TextInputState.FOCUSED, this._textInput.currentState);
		}

		[Test]
		public function testSetFocusWhenEditableTrueAndSelectableFalse():void
		{
			this._textInput.text = "Hello World";
			this._textInput.isEditable = true;
			this._textInput.isSelectable = false;
			this._textInput.validate();
			Assert.assertNotNull("StageTextTextEditor nativeFocus must not be null when isEditable is true and isSelectable is false",
				this._textInput.nativeFocus);
			this._textInput.focusManager.focus = this._textInput;
			Assert.assertStrictlyEquals("TextInput must receive FocusManager focus when using StageTextTextEditor and isEditable is true and isSelectable is false",
				this._textInput.focusManager.focus, this._textInput);
			Assert.assertStrictlyEquals("TextInput state must be TextInputState.FOCUSED after receive FocusManager focus when using StageTextTextEditor and isEditable is true and isSelectable is false",
				TextInputState.FOCUSED, this._textInput.currentState);
		}

		[Test]
		public function testSetFocusWhenEditableFalseAndSelectableTrue():void
		{
			this._textInput.text = "Hello World";
			this._textInput.isEditable = false;
			this._textInput.isSelectable = true;
			this._textInput.validate();
			Assert.assertNull("StageTextTextEditor nativeFocus must be null when isEditable is false and isSelectable is true",
				this._textInput.nativeFocus);
			this._textInput.focusManager.focus = this._textInput;
			Assert.assertStrictlyEquals("TextInput must receive FocusManager focus when using StageTextTextEditor and isEditable is false and isSelectable is true",
				this._textInput.focusManager.focus, this._textInput);
			Assert.assertStrictlyEquals("TextInput state must be TextInputState.FOCUSED after receive FocusManager focus when using StageTextTextEditor and isEditable is false and isSelectable is true",
				TextInputState.FOCUSED, this._textInput.currentState);
		}
	}
}
