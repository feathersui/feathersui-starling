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
	}
}
