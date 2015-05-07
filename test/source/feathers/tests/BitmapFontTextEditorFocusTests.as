package feathers.tests
{
	import feathers.controls.TextInput;
	import feathers.controls.text.BitmapFontTextEditor;
	import feathers.core.FocusManager;
	import feathers.events.FeathersEventType;

	import org.flexunit.Assert;
	import org.flexunit.async.Async;

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
	}
}
