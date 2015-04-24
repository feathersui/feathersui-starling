package feathers.tests
{
	import feathers.controls.TextArea;
	import feathers.controls.TextInput;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.controls.text.TextFieldTextEditorViewPort;
	import feathers.core.FocusManager;
	import feathers.events.FeathersEventType;

	import org.flexunit.Assert;

	import starling.display.Quad;
	import starling.events.Event;

	public class TextAreaFocusTests
	{
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
	}
}
